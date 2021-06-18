#!/bin/bash
clear
#Update feed
#sed -i '4s/src-git/#src-git/g' ./feeds.conf.default
#sed -i '5s/src-git/#src-git/g' ./feeds.conf.default
echo 'src-git addon https://github.com/quintus-lab/openwrt-package' >> ./feeds.conf.default
./scripts/feeds update -a && ./scripts/feeds install -a

# uboot-rockchip: update to v2021.04
wget -q -O - https://github.com/openwrt/openwrt/commit/b832ebb886e71982675b8b889b81a91a18d57bf7.patch | patch -p1
#patch jsonc
patch -p1 < ../patches/0000-use_json_object_new_int64.patch
#add upx-ucl support
patch -p1 < ../patches/0001-tools-add-upx-ucl-support.patch

#add nanopi-r4s support
patch -p1 < ../patches/0002-add-nanopi-r4s-support-k54.patch
#rockchip-rk3328-dmc
patch -p1 < ../patches/0003-rockchip-rk3328-dmc-k54.patch
#add some new support rk33xx
patch -p1 < ../patches/0004-add-new-rk33xx-support-k54.patch

#add rk33xx HWRNG support
patch -p1 < ../patches/0006-support-rk33xx-HWRNG.patch

patch -p1 < ../patches/0007-optimize_for_rk3399.patch
# add AES and GCM with ARMv8 Crypto support
patch -p1 < ../patches/0008-mbedtls-Implements-AES-and-GCM-with-ARMv8-Crypto-Ext.patch
# rockchip: add support for OrangePi R1 Plus
patch -p1 < ../patches/0009-rockchip-add-support-for-OrangePi-R1-Plus.patch

#dnsmasq aaaa filter
patch -p1 < ../patches/1001-dnsmasq-add-filter-aaaa-option.patch
cp -f ../patches/910-mini-ttl.patch package/network/services/dnsmasq/patches/
cp -f ../patches/911-dnsmasq-filter-aaaa.patch package/network/services/dnsmasq/patches/

#test 8152 patch
cp -f ../patches/993-board-nanopi-r2s-r8152-customise-leds.patch target/linux/rockchip/patches-5.4/
cp -f ../patches/994-board-nanopi-r2s-r8152-mac-from-dt.patch target/linux/rockchip/patches-5.4/

#FULLCONENAT patch
patch -p1 < ../patches/1002-add-fullconenat-support.patch
patch -p1 < ../patches/1003-luci-app-firewall_add_fullcone.patch

#update curl
rm -rf ./package/network/utils/curl
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/curl package/network/utils/curl

#Max connection limite
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#nf_conntrack: helper assignment
echo 'net.netfilter.nf_conntrack_helper=1' >> package/kernel/linux/files/sysctl-nf-conntrack.conf

exit 0
