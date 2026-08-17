# openwrt-rockchip

[![English](https://img.shields.io/badge/English-0F172A?style=for-the-badge)](README.md)
[![中文](https://img.shields.io/badge/中文-334155?style=for-the-badge)](README.zh-CN.md)

ImmortalWrt 25.12 firmware builder for Rockchip boards. The source tree is the `openwrt-25.12` branch of [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt). Packages come from ImmortalWrt `packages` and `luci` on the same branch.

## Supported boards

- FriendlyARM NanoPi R2S / R2S Plus
- FriendlyARM NanoPi R4S / R4S Enterprise / R4SE
- Xunlong Orange Pi R1 Plus / LTS

## Included software

- LuCI web UI
- HomeProxy, Passwall, SmartDNS
- Tailscale, WireGuard
- IPv6 (DHCPv6 / RA, 464XLAT, 6in4, 6rd, 6to4, DS-Lite, MAP)

Default login: `192.168.1.1` / `root` / no password. Set a password after first login.

## Build with GitHub Actions

This is the usual way.

1. Fork or open this repository.
2. Go to **Actions** → **Build ImmortalWrt 25.12**.
3. Click **Run workflow** → **Run workflow**.
4. Wait for the job to finish. A full build often takes several hours.
5. Download images from the run **Artifacts**, or from Release tag `immortalwrt-25.12`.

The workflow also runs on Monday 03:20 UTC, and when you push changes under `.github/workflows/`, `scripts/`, or `seed/`.

Pick the `*sysupgrade*` file whose name matches your board.

## Build locally

Use a Linux host with enough disk (about 40 GB free) and RAM (16 GB is comfortable). macOS can work inside a Linux VM.

### 1. Install host packages

Debian / Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y build-essential clang flex bison g++ gawk \
  gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev \
  python3-setuptools python3-dev python3-pyelftools rsync swig unzip \
  zlib1g-dev file wget libelf-dev qemu-utils ccache
```

`python3-pyelftools` is required for U-Boot.

### 2. Clone this repo and ImmortalWrt

```bash
git clone https://github.com/quintus-lab/openwrt-rockchip.git
cd openwrt-rockchip

git clone --depth 1 -b openwrt-25.12 \
  https://github.com/immortalwrt/immortalwrt.git openwrt
```

Keep ImmortalWrt in the `openwrt/` directory next to `scripts/` and `seed/`.

### 3. Update feeds and apply the seed

```bash
cd openwrt
bash ../scripts/prepare.sh
cp ../seed/rockchip.seed .config
make defconfig
```

`prepare.sh` must run from inside the ImmortalWrt tree. It updates ImmortalWrt feeds and stamps the banner.

To change boards or packages, edit `seed/rockchip.seed`, copy it over `.config` again, then `make defconfig`. Optional: `make menuconfig`.

### 4. Download and compile

```bash
make download -j$(nproc)
make -j$(nproc)
```

If the parallel compile fails, retry with:

```bash
make -j1 V=s
```

Images are written to:

```text
openwrt/bin/targets/rockchip/armv8/
```

Flash the `*sysupgrade*` image for your device. For a first install from the vendor OS, use the SD image / `sysupgrade` file your board expects, then write it with Balena Etcher, `dd`, or the board’s own tool.
