#!/usr/bin/env bash
set -euo pipefail

# Run from the OpenWrt source tree.
stamp="$(date +%Y.%m.%d)"

clone_once() {
  local url="$1" dest="$2" branch="${3:-}"
  if [[ -d "$dest/.git" ]]; then
    return 0
  fi
  if [[ -n "$branch" ]]; then
    git clone --depth 1 -b "$branch" "$url" "$dest"
  else
    git clone --depth 1 "$url" "$dest"
  fi
}

clone_once https://github.com/fw876/helloworld.git package/helloworld dev
clone_once https://github.com/brvphoenix/wrtbwmon.git package/wrtbwmon
clone_once https://github.com/brvphoenix/luci-app-wrtbwmon.git package/luci-app-wrtbwmon
clone_once https://github.com/lisaac/luci-app-diskman.git package/luci-app-diskman

./scripts/feeds update -a
./scripts/feeds install -a

{
  echo
  echo "Quintus Build@${stamp}"
  echo
} >> package/base-files/files/etc/banner

if [[ -f package/base-files/files/etc/openwrt_release ]]; then
  sed -i '/^DISTRIB_REVISION=/d' package/base-files/files/etc/openwrt_release
  sed -i '/^DISTRIB_DESCRIPTION=/d' package/base-files/files/etc/openwrt_release
  echo "DISTRIB_REVISION='${stamp}'" >> package/base-files/files/etc/openwrt_release
  echo "DISTRIB_DESCRIPTION='Quintus Build@${stamp}'" >> package/base-files/files/etc/openwrt_release
fi

if [[ -f package/kernel/linux/files/sysctl-nf-conntrack.conf ]]; then
  sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf || true
fi
