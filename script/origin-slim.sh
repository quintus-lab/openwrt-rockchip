
#!/bin/bash
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
patch -p1 < ../patches/00-R2S.patch
wget -P target/linux/rockchip/patches-5.4 https://raw.githubusercontent.com/QiuSimons/R2S-OpenWrt/master/PATCH/000-add-nanopi-r2s-support.patch 
cp -r ../step/* ./
bash 01-prepare_package.sh
bash 02-convert_translation.sh
bash 03-remove_upx.sh
rm .config
cp ../seed/origin-slim.seed .config
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
