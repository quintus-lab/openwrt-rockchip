#!/bin/bash
clear

#Use 19.07 feed source
rm -f ./feeds.conf.default
wget https://raw.githubusercontent.com/openwrt/openwrt/openwrt-19.07/feeds.conf.default
wget -P include/ https://raw.githubusercontent.com/openwrt/openwrt/openwrt-19.07/include/scons.mk
patch -p1 < ../patches/001-tools-add-upx-ucl-support.patch

#remove annoying snapshot tag
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in

#use 02 
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2/O2/g' ./rules.mk

#Update feed
./scripts/feeds update -a && ./scripts/feeds install -a

#3328 add idle
wget -P target/linux/rockchip/patches-5.4 https://github.com/project-openwrt/openwrt/raw/master/target/linux/rockchip/patches-5.4/005-arm64-dts-rockchip-Add-RK3328-idle-state.patch

#IRQ
#sed -i '/;;/i\set_interface_core 8 "ff160000" "ff160000.i2c"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity
#sed -i '/;;/i\set_interface_core 1 "ff150000" "ff150000.i2c"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity

# Disabed rk3328 ethernet tcp/udp offloading tx/rx
sed -i '/;;/i\ethtool -K eth0 rx off tx off && logger -t disable-offloading "disabed rk3328 ethernet tcp/udp offloading tx/rx"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity
#irqbalance
#sed -i 's/0/1/g' feeds/packages/utils/irqbalance/files/irqbalance.config

#Over Clock to 1.6G
cp -f ../patches/999-unlock-1608mhz-rk3328.patch ./target/linux/rockchip/patches-5.4/999-unlock-1608mhz-rk3328.patch
#patch i2c0
cp -f ../patches/998-rockchip-enable-i2c0-on-NanoPi-R2S.patch ./target/linux/rockchip/patches-5.4/998-rockchip-enable-i2c0-on-NanoPi-R2S.patch

#luci network
#patch -p1 < ../patches/luci_network-add-packet-steering.patch
#patch jsonc
patch -p1 < ../patches/use_json_object_new_int64.patch

#dnsmasq aaaa filter
patch -p1 < ../patches/dnsmasq-add-filter-aaaa-option.patch
patch -p1 < ../patches/luci-add-filter-aaaa-option.patch
cp -f ../patches/900-add-filter-aaaa-option.patch ./package/network/services/dnsmasq/patches/900-add-filter-aaaa-option.patch
rm -rf ./package/base-files/files/etc/init.d/boot
wget -P package/base-files/files/etc/init.d https://raw.githubusercontent.com/project-openwrt/openwrt/openwrt-18.06-k5.4/package/base-files/files/etc/init.d/boot

#Fullcone-rollback fw3
rm -rf ./package/network/config/firewall
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/config/firewall package/network/config/firewall
#Fullcone-Patch Kernel
pushd target/linux/generic/hack-5.4
wget https://github.com/coolsnowwolf/lede/raw/master/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
popd
#Fullcone-Patch FireWall enable fullcone
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/fullconenat.patch
#Fullcone-Patch LuCI add fullcone button
pushd feeds/luci
wget -O- https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
popd
#Fullcone-fullconenat module
cp -rf ../patches/fullconenat ./package/network/fullconenat
#Fullcone-end

#SFE-kernel patch
pushd target/linux/generic/hack-5.4
wget https://github.com/coolsnowwolf/lede/raw/master/target/linux/generic/hack-5.4/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
popd
#SFE-Patch FireWall for enable SFE
patch -p1 < ../patches/luci-app-firewall_add_sfe_switch.patch
#SFE-sfe module
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe package/new/shortcut-fe
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/fast-classifier package/new/fast-classifier
cp -f ../patches/shortcut-fe ./package/base-files/files/etc/init.d
#SFE-end

#Change Cryptodev-linux
rm -rf ./package/kernel/cryptodev-linux
svn co https://github.com/project-openwrt/openwrt/trunk/package/kernel/cryptodev-linux package/kernel/cryptodev-linux

#update curl
rm -rf ./package/network/utils/curl
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/curl package/network/utils/curl

#replace lzo
#svn co https://github.com/openwrt/packages/trunk/libs/lzo feeds/packages/libs/lzo
#ln -sf ../../../feeds/packages/libs/lzo ./package/feeds/packages/lzo
#replace node
#rm -rf ./feeds/packages/lang/node
#svn co https://github.com/nxhack/openwrt-node-packages/trunk/node feeds/packages/lang/node
#rm -rf ./feeds/packages/lang/node-arduino-firmata
#svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-arduino-firmata feeds/packages/lang/node-arduino-firmata
#rm -rf ./feeds/packages/lang/node-cylon
#svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-cylon feeds/packages/lang/node-cylon
#rm -rf ./feeds/packages/lang/node-hid
#svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-hid feeds/packages/lang/node-hid
#rm -rf ./feeds/packages/lang/node-homebridge
#svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-homebridge feeds/packages/lang/node-homebridge
#rm -rf ./feeds/packages/lang/node-serialport
#svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-serialport feeds/packages/lang/node-serialport
#rm -rf ./feeds/packages/lang/node-serialport-bindings
#svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-serialport-bindings feeds/packages/lang/node-serialport-bindings
# Change libcap
#rm -rf ./feeds/packages/libs/libcap/
#svn co https://github.com/openwrt/packages/trunk/libs/libcap feeds/packages/libs/libcap

# Change GCC
#rm -rf ./feeds/packages/devel/gcc
#svn co https://github.com/openwrt/packages/trunk/devel/gcc feeds/packages/devel/gcc

# Change Golang
#rm -rf ./feeds/packages/lang/golang
#svn co https://github.com/openwrt/packages/trunk/lang/golang feeds/packages/lang/golang

#add libs
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/libs/nghttp2 package/libs/nghttp2
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/libs/libconfig package/libs/libconfig
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/utils/fuse package/utils/fuse

#Additional package
#arpbind
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-arpbind package/lean/luci-app-arpbind
#AutoCore
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/autocore package/lean/autocore
svn co https://github.com/project-openwrt/packages/trunk/utils/coremark feeds/packages/utils/coremark
ln -sf ../../../feeds/packages/utils/coremark ./package/feeds/packages/coremark
sed -i 's,default n,default y,g' feeds/packages/utils/coremark/Makefile

#DDNS
#rm -rf ./feeds/packages/net/ddns-scripts
#rm -rf ./feeds/luci/applications/luci-app-ddns
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_aliyun package/lean/ddns-scripts_aliyun
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_dnspod package/lean/ddns-scripts_dnspod
#svn co https://github.com/openwrt/packages/branches/openwrt-18.06/net/ddns-scripts feeds/packages/net/ddns-scripts
#svn co https://github.com/openwrt/luci/branches/openwrt-18.06/applications/luci-app-ddns feeds/luci/applications/luci-app-ddns

#定时重启
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-autoreboot package/lean/luci-app-autoreboot
#AdGuard
#git clone -b master --single-branch https://github.com/rufengsuixing/luci-app-adguardhome package/new/luci-app-adguardhome
#Adbyby
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-adbyby-plus package/lean/luci-app-adbyby-plus
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/adbyby package/lean/coremark/adbyby
#gost
svn co https://github.com/project-openwrt/openwrt/branches/master/package/ctcgfw/gost package/ctcgfw/gost
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/luci-app-gost package/ctcgfw/luci-app-gost

#SSRP
#svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/lean/luci-app-ssr-plus
#svn co https://github.com/fw876/helloworld/trunk/tcping package/lean/tcping
#svn co https://github.com/fw876/helloworld/trunk/naiveproxy package/lean/naiveproxy
svn co https://github.com/Mattraks/helloworld/branches/Preview/luci-app-ssr-plus package/lean/luci-app-ssr-plus
svn co https://github.com/Mattraks/helloworld/branches/Preview/naiveproxy package/lean/naiveproxy
svn co https://github.com/Mattraks/helloworld/branches/Preview/tcping package/lean/tcping


#SSRP依赖
#rm -rf ./feeds/packages/net/kcptun
#rm -rf ./feeds/packages/net/shadowsocks-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shadowsocksr-libev package/lean/shadowsocksr-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt package/lean/pdnsd
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/kcptun package/lean/kcptun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/srelay package/lean/srelay
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/microsocks package/lean/microsocks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dns2socks package/lean/dns2socks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/redsocks2 package/lean/redsocks2
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/proxychains-ng package/lean/proxychains-ng
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ipt2socks package/lean/ipt2socks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/simple-obfs package/lean/simple-obfs
#svn co https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/lean/shadowsocks-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/trojan package/lean/trojan
svn co https://github.com/project-openwrt/openwrt/trunk/package/lean/tcpping package/lean/tcpping
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/xray package/lean/xray
#patch -p1 < ../patches/ssr-plus-tls.patch

#OpenClash
#svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/new/luci-app-openclash
#luci-app-clash
#git clone https://github.com/frainzy1477/luci-app-clash.git package/luci-app-clash
#edge主题
#git clone -b master --single-branch https://github.com/garypang13/luci-theme-edge package/new/luci-theme-edge
#订阅转换
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/subconverter package/new/subconverter
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/jpcre2 package/new/jpcre2
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/rapidjson package/new/rapidjson

#清理内存
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-ramfree package/lean/luci-app-ramfree

#打印机
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-usb-printer package/lean/luci-app-usb-printer

#流量监视
git clone -b master --single-branch https://github.com/brvphoenix/wrtbwmon package/new/wrtbwmon
git clone -b master --single-branch https://github.com/brvphoenix/luci-app-wrtbwmon package/new/luci-app-wrtbwmon
#流量监管
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-netdata package/lean/luci-app-netdata

#SeverChan
#git clone -b master --single-branch https://github.com/tty228/luci-app-serverchan package/new/luci-app-serverchan

#iputils
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/iputils package/network/utils/iputils
#SmartDNS
#svn co https://github.com/pymumu/smartdns/trunk/package/openwrt package/new/smartdns/smartdns
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ntlf9t/luci-app-smartdns package/new/smartdns/luci-app-smartdns

#jd-dailybonus
git clone --depth 1 https://github.com/jerrykuku/node-request.git package/new/node-request
git clone --depth 1 https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/new/luci-app-jd-dailybonus

#frp
rm -f ./feeds/luci/applications/luci-app-frps
rm -f ./feeds/luci/applications/luci-app-frpc
rm -rf ./feeds/packages/net/frp
rm -f ./package/feeds/packages/frp
git clone https://github.com/lwz322/luci-app-frps.git package/lean/luci-app-frps
git clone https://github.com/kuoruan/luci-app-frpc.git package/lean/luci-app-frpc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/frp package/feeds/packages/frp

#onliner
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/luci-app-onliner package/ctcgfw/luci-app-onliner
#filetransfer
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lean/luci-app-filetransfer package/lean/luci-app-filetransfer
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lean/luci-lib-fs package/lean/luci-lib-fs
#tmate
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/tmate package/ctcgfw/tmate
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/msgpack-c package/ctcgfw/msgpack-c
#
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/luci-app-cpufreq package/lean/luci-app-cpufreq
patch -p1 < ../patches/luci-app-freq.patch
#beardropper
git clone https://github.com/NateLol/luci-app-beardropper package/luci-app-beardropper

#trojan server
#svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-app-trojan-server package/luci-app-trojan-server
#transmission-web-control
#rm -rf ./feeds/packages/net/transmission*
#rm -rf ./feeds/luci/applications/luci-app-transmission/
#svn co https://github.com/coolsnowwolf/packages/trunk/net/transmission feeds/packages/net/transmission
#svn co https://github.com/coolsnowwolf/packages/trunk/net/transmission-web-control feeds/packages/net/transmission-web-control
#svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-transmission feeds/luci/applications/luci-app-transmission
#Dockerman
#git clone https://github.com/lisaac/luci-app-dockerman.git package/lean/luci-app-dockerman
#git clone https://github.com/lisaac/luci-lib-docker package/lean/luci-lib-docker
#svn co https://github.com/openwrt/packages/trunk/utils/docker-ce package/lean/docker-ce
#svn co https://github.com/openwrt/packages/trunk/utils/cgroupfs-mount package/lean/cgroupfs-mount
#svn co https://github.com/openwrt/packages/trunk/utils/libnetwork package/lean/libnetwork
#svn co https://github.com/openwrt/packages/trunk/utils/tini package/lean/tini
#svn co https://github.com/openwrt/packages/trunk/utils/containerd package/lean/containerd
#svn co https://github.com/openwrt/packages/trunk/utils/runc package/lean/runc
#svn co https://github.com/openwrt/packages/trunk/lang/golang package/lang/golang
#multiwan support
#svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/luci-app-syncdial package/lean/luci-app-syncdial
#rm -rf feeds/packages/net/mwan3
#rm -rf feeds/luci/applications/luci-app-mwan3
#svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-mwan3 feeds/luci/applications/luci-app-mwan3
#svn co https://github.com/coolsnowwolf/packages/trunk/net/mwan3 feeds/packages/net/mwan3
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-mwan3helper package/lean/luci-app-mwan3helper
#Zerotier
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/luci-app-zerotier package/lean/luci-app-zerotier
#OLED display
git clone https://github.com/natelol/luci-app-oled package/natelol/luci-app-oled

#fix some depends, useless
#svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/utils/fuse package/utils/fuse
#svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/services/samba36 package/network/services/samba36
#svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/libs/libconfig package/libs/libconfig
#svn co https://github.com/openwrt/packages/trunk/libs/nghttp2 package/libs/nghttp2
#svn co https://github.com/openwrt/packages/trunk/libs/libcap-ng package/libs/libcap-ng
#rm -rf ./feeds/packages/utils/collectd
#svn co https://github.com/openwrt/packages/trunk/utils/collectd feeds/packages/utils/collectd

#最大连接
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#lean default-settings
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/default-settings package/lean/default-settings
patch -p1 < ../patches/zzz.patch

echo -e '\nQuintus Build@'$(date "+%Y.%m.%d")'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='Quintus Build@$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/luciversion/d' feeds/luci/modules/luci-base/luasrc/version.lua
echo 'luciversion = "Quintus@🇨🇦🇹🇼🇺🇸🇭🇰"' >> feeds/luci/modules/luci-base/luasrc/version.lua

#crypto
echo '
CONFIG_ARM64_CRYPTO=y
CONFIG_CRYPTO_AES_ARM64=y
CONFIG_CRYPTO_AES_ARM64_BS=y
CONFIG_CRYPTO_AES_ARM64_CE=y
CONFIG_CRYPTO_AES_ARM64_CE_BLK=y
CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
CONFIG_CRYPTO_AES_ARM64_NEON_BLK=y
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CHACHA20_NEON=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_GHASH_ARM64_CE=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_ARM64_CE=y
CONFIG_CRYPTO_SHA256_ARM64=y
CONFIG_CRYPTO_SHA2_ARM64_CE=y
# CONFIG_CRYPTO_SHA3_ARM64 is not set
CONFIG_CRYPTO_SHA512_ARM64=y
# CONFIG_CRYPTO_SHA512_ARM64_CE is not set
CONFIG_CRYPTO_SIMD=y
# CONFIG_CRYPTO_SM3_ARM64_CE is not set
# CONFIG_CRYPTO_SM4_ARM64_CE is not set
' >> ./target/linux/rockchip/armv8/config-5.4

#生成默认配置及缓存
rm -rf .config
#修正架构
#sed -i "s,boardinfo.system,'ARMv8',g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
chmod -R 755 ./

exit 0
