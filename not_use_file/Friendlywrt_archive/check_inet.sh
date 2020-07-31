#!/bin/sh
# Copyright (c) 2020, Chuck <fanck0605@qq.com>
#
# this script is writing for openwrt
# this script need the interface named 'lan'

# usage: `/bin/sh /path/to/check_net4.sh >/dev/null 2>&1 &`

get_ipv4_address() {
  if ! if_status=$(ifstatus $1); then
    return 1
  fi
  echo $if_status | jsonfilter -e "@['ipv4-address'][0]['address']"
}

if ! lan_addr=$(get_ipv4_address lan); then
  logger "Check network health: Don't support your network environment!"
  exit 1
fi

logger 'Check network health: Script started!'

fail_count=0

while :; do
  sleep 2s

  # try to connect
  if ping -W 1 -c 1 "$lan_addr" >/dev/null 2>&1; then
    # No problem!
    if [ $fail_count -gt 0 ]; then
      logger 'Check network health: Network problems solved!'
    fi
    fail_count=0
    continue
  fi

  # May have some problem
  logger "Check network health: Network may have some problems!"
  fail_count=$((fail_count + 1))

  if [ $fail_count -ge 3 ]; then
    # Must have some problem! We refresh the ip address and try again!
    lan_addr=$(get_ipv4_address lan)

    if ping -W 1 -c 1 "$lan_addr" >/dev/null 2>&1; then
      continue
    fi

    logger 'Check network health: Network problem! Firewall reloading...'
    echo -e "$(date "+%Y-%m-%d %H:%M:%S"): Network problem! Firewall reloading..." >> /var/log/check_inet.log
    /etc/init.d/firewall reload >/dev/null 2>&1
    sleep 2s

    if ping -W 1 -c 1 "$lan_addr" >/dev/null 2>&1; then
      continue
    fi

    logger 'Check network health: Network problem! Network reloading...'
    echo -e "$(date "+%Y-%m-%d %H:%M:%S"): Network problem! Network reloading..." >> /var/log/check_inet.log
    /etc/init.d/network restart >/dev/null 2>&1
    sleep 2s
  fi
done