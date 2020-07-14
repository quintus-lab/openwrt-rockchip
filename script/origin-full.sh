#!/bin/bash
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/rockchip-add-support-for-FriendlyARM-NanoPi-R2S.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/rockchip-add-support-for-rk3328-radxa-rock-pi-e.patch
patch -p1 < ./rockchip-add-support-for-rk3328-radxa-rock-pi-e.patch
patch -p1 < ./rockchip-add-support-for-FriendlyARM-NanoPi-R2S.patch
#
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/step/01-prepare_package.sh
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/step/02-convert_translation.sh
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/step/03-remove_upx.sh
bash 01-prepare_package.sh
bash 02-convert_translation.sh
bash 03-remove_upx.sh
rm .config
wget -O .config https://github.com/quintus-lab/Openwrt-R2S/raw/master/seed/origin-full.seed
make defconfig
make download -j10
chmod -R 755 ./
let make_process=$(nproc)+1
make toolchain/install -j${make_process} V=s
let make_process=$(nproc)+1
make -j${make_process} V=s || make -j${make_process} V=s
cd bin/targets/rockchip/armv8
gzip -d *.gz
gzip *.img
