# openwrt-rockchip

ImmortalWrt 25.12 固件，源为 [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) 的 `openwrt-25.12` 分支。

ImmortalWrt 25.12 firmware from the `openwrt-25.12` branch of [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt).

支持 / Supported: NanoPi R2S / R2S Plus, R4S / R4S Enterprise / R4SE, Orange Pi R1 Plus / LTS.

预装 / Preinstalled: HomeProxy, Passwall, SmartDNS, Tailscale, WireGuard. IPv6 已启用 / IPv6 enabled.

默认 / Default: `192.168.1.1` / `root` / 无密码 no password。首次登录后请改密码 / Set a password after first login.

## 编译 / Build

Actions → **Build ImmortalWrt 25.12** → **Run workflow**。成品在 Artifacts 和 Release `immortalwrt-25.12`。

Artifacts and the `immortalwrt-25.12` release contain the images.

本机 / Local:

```bash
git clone --depth 1 -b openwrt-25.12 \
  https://github.com/immortalwrt/immortalwrt.git openwrt
cd openwrt
bash ../scripts/prepare.sh
cp ../seed/rockchip.seed .config
make defconfig
make -j$(nproc)
```

镜像 / Images: `openwrt/bin/targets/rockchip/armv8/`
