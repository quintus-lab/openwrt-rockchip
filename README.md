# openwrt-rockchip

用 GitHub Actions 编 **ImmortalWrt 25.12** 固件。一份 workflow、一份 seed，覆盖这几块 Rockchip 板子。

- FriendlyARM NanoPi R2S / R2S Plus
- FriendlyARM NanoPi R4S / R4S Enterprise / R4SE
- Xunlong Orange Pi R1 Plus / R1 Plus LTS

软件只从 ImmortalWrt 自己的源取，不再外挂 helloworld / Lean / CTCGFW。

## 源

| 用途 | 仓库 / 分支 |
|---|---|
| 底包 | [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) `openwrt-25.12` |
| feeds | [immortalwrt/packages](https://github.com/immortalwrt/packages)、[immortalwrt/luci](https://github.com/immortalwrt/luci) 同分支 |
| 翻墙 | `luci-app-homeproxy`（sing-box）、`luci-app-passwall`（xray-core）、`luci-app-smartdns` |
| 组网 | `tailscale` + `luci-app-tailscale-community`，另有 WireGuard |

每次构建 `git clone --depth 1 -b openwrt-25.12`，跟 ImmortalWrt 该稳定线当时的 tip，不是钉死某一个 tag。

## 功能

**翻墙**

- HomeProxy：ImmortalWrt 官方客户端，内核是 sing-box。日常 **VLESS + Reality + Vision** 可以用。
- Passwall：同一份固件里的 Xray 客户端。XHTTP、VLESS Encryption 等 Xray 新协议走这里，不要走 HomeProxy。
- SmartDNS：分流 / 国内解析。

**Tailscale**

- 包来自 ImmortalWrt `packages` 的 `net/tailscale`，LuCI 用 `luci-app-tailscale-community`。

**IPv6**

- WAN：`odhcp6c`
- LAN：`odhcpd-ipv6only` + `dnsmasq-full`（含 DHCPv6）
- LuCI：`luci-proto-ipv6`（DHCPv6 / 464XLAT / 6in4 / 6rd / 6to4 / DS-Lite / MAP / ipip6）
- 内核：`kmod-sit`、`kmod-ip6-tunnel`、`kmod-nft-nat`、`kmod-nf-reject6`

**默认登录**

`192.168.1.1` / `root` / 无密码。第一次进去先设密码。

## 目录

```
.github/workflows/build.yml   Actions：清盘、拉 ImmortalWrt、编、上传、发 Release
scripts/prepare.sh            feeds update/install，写 banner
seed/rockchip.seed            板子 + 软件包
body-origin.md                Release 说明底稿
```

## 用 Actions 编

仓库 → **Actions** → **Build ImmortalWrt 25.12** → **Run workflow**。

也会在每周一 UTC 03:20 自动跑，以及当 `build.yml` / `scripts/` / `seed/` 有推送时跑。

编完在该次 run 的 Artifacts 里，也会更新 tag `immortalwrt-25.12` 的 Release。多板镜像都在 `rockchip/armv8` 产物里，按文件名选板子。

GitHub 托管 runner 编 ImmortalWrt + Xray + sing-box + Tailscale（Go）很吃磁盘和时间，一次可能要数小时。

## 本机编

```bash
git clone --depth 1 -b openwrt-25.12 \
  https://github.com/immortalwrt/immortalwrt.git openwrt
cd openwrt
bash ../scripts/prepare.sh
cp ../seed/rockchip.seed .config
make defconfig
make -j$(nproc)
```

镜像在 `openwrt/bin/targets/rockchip/armv8/`。
