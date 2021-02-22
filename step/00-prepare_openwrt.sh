#!/bin/bash
clear
# use 02
sed -i 's/Os/O2/g' include/target.mk
#Update feed
sed -i '4s/src-git/#src-git/g' ./feeds.conf.default
sed -i '5s/src-git/#src-git/g' ./feeds.conf.default
echo 'src-git addon https://github.com/quintus-lab/openwrt-package' >> ./feeds.conf.default
./scripts/feeds update -a && ./scripts/feeds install -a

#patch jsonc
patch -p1 < ../patches/0000-use_json_object_new_int64.patch
#Add upx-ucl support
patch -p1 < ../patches/0001-tools-add-upx-ucl-support.patch
#Add UHS cards support
patch -p1 < ../patches/0003-rockchip-fixes-re-boot-with-UHS-cards.patch

# add R4S support
patch -p1 < ../patches/0004-uboot-add-r4s-support.patch
patch -p1 < ../patches/0005-target-add-r4s-support.patch

#crypto
patch -p1 < ../patches/0006-config54.patch

#CPU_CFLAGS for rk3399
patch -p1 < ../patches/0007-optimize_for_rk3399.patch

#dnsmasq aaaa filter
patch -p1 < ../patches/1001-dnsmasq_add_filter_aaaa_option.patch
cp -f ../patches/910-mini-ttl.patch package/network/services/dnsmasq/patches/
cp -f ../patches/911-dnsmasq-filter-aaaa.patch package/network/services/dnsmasq/patches/

#Fullcone patch
patch -p1 < ../patches/1002-add-fullconenat-support.patch
patch -p1 < ../patches/1003-luci-app-firewall_add_fullcone.patch
#update curl
rm -rf ./package/network/utils/curl
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/curl package/network/utils/curl

# dma patch
cp -rf ../patches/911-kernel-dma-adjust-default-coherent_pool-to-2MiB.patch target/linux/rockchip/patches-5.4

#3328 add idle patch
cp -rf ../patches/007-arm64-dts-rockchip-Add-RK3328-idle-state.patch target/linux/rockchip/patches-5.4

#patch i2c0
cp -f ../patches/998-rockchip-enable-i2c0-on-NanoPi-R2S.patch ./target/linux/rockchip/patches-5.4/

#R2S overclock to 1.6G patch
cp -f ../patches/999-unlock-1608mhz-rk3328.patch ./target/linux/rockchip/patches-5.4/
#R4S overclock to 2.2g patch
cp -f ../patches/991-rockchip-rk3399-overclock-to-2.2-1.8-GHz-for-NanoPi4.patch ./target/linux/rockchip/patches-5.4/

#r8168-8.048.03 realtek driver for R4S
#git clone https://github.com/BROBIRD/openwrt-r8168 package/new/r8168

# patch cpuinfo display modelname
wget https://patch-diff.githubusercontent.com/raw/openwrt/openwrt/pull/3829.patch
patch -p1 < ./3829.patch

#Max connection limite
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

exit 0
