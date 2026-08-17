#!/usr/bin/env bash
set -euo pipefail

# Run from the ImmortalWrt source tree.
# Feeds already point at immortalwrt/packages and immortalwrt/luci.
stamp="$(date +%Y.%m.%d)"

./scripts/feeds update -a
./scripts/feeds install -a

{
  echo
  echo "Quintus Build@${stamp} (ImmortalWrt 25.12)"
  echo
} >> package/base-files/files/etc/banner

if [[ -f package/base-files/files/etc/openwrt_release ]]; then
  sed -i '/^DISTRIB_REVISION=/d' package/base-files/files/etc/openwrt_release
  sed -i '/^DISTRIB_DESCRIPTION=/d' package/base-files/files/etc/openwrt_release
  echo "DISTRIB_REVISION='${stamp}'" >> package/base-files/files/etc/openwrt_release
  echo "DISTRIB_DESCRIPTION='Quintus ImmortalWrt@${stamp}'" >> package/base-files/files/etc/openwrt_release
fi

if [[ -f package/kernel/linux/files/sysctl-nf-conntrack.conf ]]; then
  sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf || true
fi
