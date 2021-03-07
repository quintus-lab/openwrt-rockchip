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
patch -p1 < ../patches/0003-new_rockchip_support_k510.patch
patch -p1 < ../patches/0007-optimize_for_rk3399.patch

# add AES and GCM with ARMv8 Crypto support
patch -p1 < ../patches/0008-mbedtls-Implements-AES-and-GCM-with-ARMv8-Crypto-Ext.patch

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
