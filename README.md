# openwrt-rockchip

Single OpenWrt firmware builder for the Rockchip boards this repo used to
split across `openwrt-rockchip` and `NanoPi-R4S-OpenWRT` / `openwrt-r4s`.
One workflow, one seed, no R4S-only tree.

Boards in `seed/rockchip.seed`:

- FriendlyARM NanoPi R2S / R2S Plus
- FriendlyARM NanoPi R4S / R4S Enterprise
- Xunlong Orange Pi R1 Plus / R1 Plus LTS

This replaces the 2021 builder that cloned OpenWrt `master`, stacked custom
5.10/5.14 device patches, and pulled CTCGFW + Lean packages. Official OpenWrt
has supported these boards since 23.05. The current stable series is 25.12
(kernel 6.12, apk instead of opkg).

## Current source

| Piece | Source |
|---|---|
| Base | [openwrt/openwrt](https://github.com/openwrt/openwrt) branch `openwrt-25.12` (stable, latest tip at build time) |
| Extra proxy apps | [fw876/helloworld](https://github.com/fw876/helloworld) (`luci-app-ssr-plus`) |
| Disk / traffic | [lisaac/luci-app-diskman](https://github.com/lisaac/luci-app-diskman), [brvphoenix/wrtbwmon](https://github.com/brvphoenix/wrtbwmon) |

Default LAN is `192.168.1.1`, user `root`, no password. Set a password on first
login.

## Build

Actions → **Build OpenWrt 25.12** → Run workflow.

Or locally:

```bash
git clone --depth 1 -b openwrt-25.12 https://github.com/openwrt/openwrt.git openwrt
cd openwrt
bash ../scripts/prepare.sh
cp ../seed/rockchip.seed .config
make defconfig
make -j$(nproc)
```

Images land in `openwrt/bin/targets/rockchip/armv8/`.
