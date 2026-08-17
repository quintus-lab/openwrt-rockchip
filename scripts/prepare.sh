#!/usr/bin/env bash
set -euo pipefail

# Run from the ImmortalWrt source tree.
# feeds.conf.default already points at immortalwrt/packages and immortalwrt/luci.

if [[ ! -x ./scripts/feeds ]]; then
  echo "prepare.sh must run inside the ImmortalWrt tree" >&2
  exit 1
fi

if ! grep -q 'immortalwrt/packages' feeds.conf.default; then
  echo "feeds.conf.default is not ImmortalWrt" >&2
  exit 1
fi

stamp="$(date -u +%Y.%m.%d)"
rev="$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"

./scripts/feeds update -a
./scripts/feeds install -a

{
  echo
  echo "Quintus Build@${stamp} ImmortalWrt 25.12 ${rev}"
  echo
} >> package/base-files/files/etc/banner

if [[ -f package/base-files/files/etc/openwrt_release ]]; then
  sed -i '/^DISTRIB_REVISION=/d;/^DISTRIB_DESCRIPTION=/d' \
    package/base-files/files/etc/openwrt_release
  echo "DISTRIB_REVISION='${stamp}'" >> package/base-files/files/etc/openwrt_release
  echo "DISTRIB_DESCRIPTION='Quintus ImmortalWrt@${stamp}'" \
    >> package/base-files/files/etc/openwrt_release
fi

if [[ -f package/base-files/files/usr/lib/os-release ]]; then
  sed -i "s/^OPENWRT_RELEASE=.*/OPENWRT_RELEASE=\"Quintus ImmortalWrt@${stamp}\"/" \
    package/base-files/files/usr/lib/os-release || true
fi

if [[ -f package/kernel/linux/files/sysctl-nf-conntrack.conf ]]; then
  sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf || true
fi
