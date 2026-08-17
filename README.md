# openwrt-rockchip

ImmortalWrt 25.12 firmware builder for Rockchip boards. One workflow, one seed.

Boards in `seed/rockchip.seed`:

- FriendlyARM NanoPi R2S / R2S Plus
- FriendlyARM NanoPi R4S / R4S Enterprise / R4SE
- Xunlong Orange Pi R1 Plus / R1 Plus LTS

## Source

Everything comes from ImmortalWrt. No extra third-party package trees.

| Piece | Source |
|---|---|
| Base | [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) branch `openwrt-25.12` |
| Feeds | [immortalwrt/packages](https://github.com/immortalwrt/packages), [immortalwrt/luci](https://github.com/immortalwrt/luci) (`openwrt-25.12`) |
| Proxy | `luci-app-homeproxy`, `luci-app-passwall`, `luci-app-smartdns` |
| Mesh VPN | `tailscale` + `luci-app-tailscale-community` |

IPv6 is on by default: DHCPv6/RA (`odhcp6c`, `odhcpd-ipv6only`), LuCI IPv6 protocols (`luci-proto-ipv6`), and 464XLAT / 6in4 / 6rd / 6to4 / DS-Lite / MAP.

Default LAN is `192.168.1.1`, user `root`, no password. Set a password on first login.

## Build

Actions → **Build ImmortalWrt 25.12** → Run workflow.

Or locally:

```bash
git clone --depth 1 -b openwrt-25.12 https://github.com/immortalwrt/immortalwrt.git openwrt
cd openwrt
bash ../scripts/prepare.sh
cp ../seed/rockchip.seed .config
make defconfig
make -j$(nproc)
```

Images land in `openwrt/bin/targets/rockchip/armv8/`.
