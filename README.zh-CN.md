# openwrt-rockchip

[![English](https://img.shields.io/badge/English-334155?style=for-the-badge)](README.md)
[![中文](https://img.shields.io/badge/中文-0F172A?style=for-the-badge)](README.zh-CN.md)

ImmortalWrt 25.12 固件构建仓库。底包来自 [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) 的 `openwrt-25.12` 分支，软件来自同分支的 ImmortalWrt `packages` 与 `luci`。

## 支持的板子

- FriendlyARM NanoPi R2S / R2S Plus
- FriendlyARM NanoPi R4S / R4S Enterprise / R4SE
- Xunlong Orange Pi R1 Plus / LTS

## 预装软件

- LuCI 管理界面
- HomeProxy、Passwall、SmartDNS
- Tailscale、WireGuard
- IPv6（DHCPv6 / RA、464XLAT、6in4、6rd、6to4、DS-Lite、MAP）

默认登录：`192.168.1.1` / `root` / 无密码。第一次进去请改密码。

## 用 GitHub Actions 编译

一般用这种方式。

1. Fork 或打开本仓库。
2. 进入 **Actions** → **Build ImmortalWrt 25.12**。
3. 点 **Run workflow** → **Run workflow**。
4. 等任务结束。完整编译通常要几个小时。
5. 从该次运行的 **Artifacts** 下载，或到 Release 标签 `immortalwrt-25.12`。

每周一 UTC 03:20 也会自动跑；推送 `.github/workflows/`、`scripts/`、`seed/` 的改动时同样会触发。

按文件名选择对应板子的 `*sysupgrade*` 镜像。

## 本机编译

需要 Linux 主机，磁盘大约空余 40 GB，内存 16 GB 较稳妥。macOS 建议在 Linux 虚拟机里编。

### 1. 安装依赖

Debian / Ubuntu：

```bash
sudo apt-get update
sudo apt-get install -y build-essential clang flex bison g++ gawk \
  gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev \
  python3-setuptools python3-dev python3-pyelftools rsync swig unzip \
  zlib1g-dev file wget libelf-dev qemu-utils ccache
```

编 U-Boot 需要 `python3-pyelftools`。

### 2. 克隆本仓库和 ImmortalWrt

```bash
git clone https://github.com/quintus-lab/openwrt-rockchip.git
cd openwrt-rockchip

git clone --depth 1 -b openwrt-25.12 \
  https://github.com/immortalwrt/immortalwrt.git openwrt
```

ImmortalWrt 源码放在与 `scripts/`、`seed/` 同级的 `openwrt/` 目录。

### 3. 更新 feeds 并载入配置

```bash
cd openwrt
bash ../scripts/prepare.sh
cp ../seed/rockchip.seed .config
make defconfig
```

`prepare.sh` 必须在 ImmortalWrt 源码目录里执行，用来更新 feeds 并写入 banner。

要改板子或软件包，编辑 `seed/rockchip.seed`，再复制到 `.config` 后执行 `make defconfig`。也可以用 `make menuconfig`。

### 4. 下载并编译

```bash
make download -j$(nproc)
make -j$(nproc)
```

并行编译失败时：

```bash
make -j1 V=s
```

镜像输出目录：

```text
openwrt/bin/targets/rockchip/armv8/
```

烧录对应板子的 `*sysupgrade*` 文件。从厂商系统首次安装时，按该板要求选用 SD 镜像或 sysupgrade，用 Balena Etcher、`dd` 或板子自带工具写入。
