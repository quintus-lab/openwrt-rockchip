# openwrt-rockchip

ImmortalWrt 25.12 固件，源为 [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) 的 `openwrt-25.12` 分支。

支持：NanoPi R2S / R2S Plus、R4S / R4S Enterprise / R4SE、Orange Pi R1 Plus / LTS。

预装 HomeProxy、Passwall、SmartDNS、Tailscale、WireGuard，并启用 IPv6。

默认 `192.168.1.1` / `root` / 无密码，首次登录后请改密码。

## 编译

Actions → **Build ImmortalWrt 25.12** → **Run workflow**。成品在 Artifacts 和 Release `immortalwrt-25.12`。

本机：

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
