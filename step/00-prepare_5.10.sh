#!/bin/bash
clear
#Update feed
sed -i '4s/src-git/#src-git/g' ./feeds.conf.default
sed -i '5s/src-git/#src-git/g' ./feeds.conf.default
echo 'src-git addon https://github.com/quintus-lab/openwrt-package' >> ./feeds.conf.default
./scripts/feeds update -a && ./scripts/feeds install -a

#patch jsonc
patch -p1 < ../patches/0000-use_json_object_new_int64.patch
#add upx-ucl support
patch -p1 < ../patches/0001-tools-add-upx-ucl-support.patch
#add hwrng patch
patch -p1 < ../patches/0002-rockchip-rngd.patch

# add R4S support
patch -p1 < ../patches/0003-new_rk33xx_support_with_ARMv8_CE_k5.10.patch
patch -p1 < ../patches/0007-optimize_for_rk3399.patch

# add AES and GCM with ARMv8 Crypto support
patch -p1 < ../patches/0008-mbedtls-Implements-AES-and-GCM-with-ARMv8-Crypto-Ext.patch
# rockchip: add support for OrangePi R1 Plus
patch -p1 < ../patches/0009-rockchip-add-support-for-OrangePi-R1-Plus.patch
# rockchip: add drm and lima gpu driver
patch -p1 < ../patches/0011-rockchip-add-drm-and-lima-gpu-driver.patch

# use vendor usb3 inno driver
#patch -p1 < ../patches/0009-rockchip-introduce-vendor-USB3-inno-driver.patch
#patch -p1 < ../patches/0010-rk3328_refresh_usb3_nodes_k5.10.patch
#test 8152 patch
cp -f ../patches/993-board-nanopi-r2s-r8152-customise-leds.patch target/linux/rockchip/patches-5.10/
cp -f ../patches/994-board-nanopi-r2s-r8152-mac-from-dt.patch target/linux/rockchip/patches-5.10/

#Fullcone patch
patch -p1 < ../patches/1002-fw3_fullconenat.patch
patch -p1 < ../patches/1003-luci-app-firewall_add_fullcone.patch
#update curl
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/curl package/network/utils/curl

#dnsmasq aaaa filter
patch -p1 < ../patches/1001-dnsmasq_add_filter_aaaa_option.patch
cp -f ../patches/910-mini-ttl.patch package/network/services/dnsmasq/patches/
cp -f ../patches/911-dnsmasq-filter-aaaa.patch package/network/services/dnsmasq/patches/

#Max connection limite
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

exit 0
