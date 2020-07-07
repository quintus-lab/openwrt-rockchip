#!/bin/bash
clear
#生成时间
VersionDate=$(git show -s --date=short --format="%cd")
echo "::set-env name=VersionDate::$VersionDate"
echo "::set-env name=DATE::$(date "+%Y-%m-%d %H:%M:%S")"
rm -f ./feeds.conf.default
wget https://raw.githubusercontent.com/openwrt/openwrt/openwrt-19.07/feeds.conf.default
#remove annoying snapshot tag
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in
#更新feed
./scripts/feeds update -a && ./scripts/feeds install -a
#O3
sed -i 's/Os/O3/g' include/target.mk
sed -i 's/O2/O3/g' ./rules.mk
#irqbalance
sed -i 's/0/1/g' feeds/packages/utils/irqbalance/files/irqbalance.config
cp -f ../patches/zzz-adjust_network package/base-files/files/etc/init.d/zzz-adjust_network
#scons patch
wget -P include/ https://raw.githubusercontent.com/openwrt/openwrt/openwrt-19.07/include/scons.mk
#patch jsonc
patch -p1 < ../patches/use_json_object_new_int64.patch
#dnsmasq aaaa filter
patch -p1 < ../patches/dnsmasq-add-filter-aaaa-option.patch
patch -p1 < ../patches/luci-add-filter-aaaa-option.patch
cp -f ../patches/900-add-filter-aaaa-option.patch ./package/network/services/dnsmasq/patches/900-add-filter-aaaa-option.patch
#FullCone Patch
git clone -b master --single-branch https://github.com/QiuSimons/openwrt-fullconenat package/fullconenat
# Patch FireWall for fullcone
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/fullconenat.patch
# Patch LuCI for fullcone
pushd feeds/luci
wget -O- https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
popd
#Patch Kernel for fullcone
pushd target/linux/generic/hack-5.4
wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
popd
#Patch FireWall for SFE
patch -p1 < ../patches/luci-app-firewall_add_sfe_switch.patch
# SFE kernel patch
pushd target/linux/generic/hack-5.4
wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/999-shortcut-fe-support.patch
popd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe package/new/shortcut-fe
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/fast-classifier package/new/fast-classifier
#cp -f ../patches/shortcut-fe package/base-files/files/etc/init.d/shortcut-fe
#
#patch config-5.4 support docker
echo '
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_IPVLAN=y
CONFIG_IPVTAP=m
CONFIG_DM_THIN_PROVISIONING=y
CONFIG_CRYPTO_AES_ARM64_CE_BLK=y
CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
CONFIG_CRYPTO_SHA512_ARM64=y
CONFIG_CRYPTO_SHA512_ARM64_CE=y
CONFIG_CRYPTO_SHA3_ARM64=y
CONFIG_CRYPTO_SM3_ARM64_CE=y
CONFIG_CRYPTO_SM4_ARM64_CE=y
CONFIG_CRYPTO_CRCT10DIF_ARM64_CE=y
CONFIG_CRYPTO_AES_ARM64_NEON_BLK=y
CONFIG_CRYPTO_AES_ARM64_BS=y
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_GHASH_ARM64_CE=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_ARM64_CE=y
CONFIG_CRYPTO_SHA2_ARM64_CE=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_DEV_ROCKCHIP=y
CONFIG_SND_SOC_ROCKCHIP=m
CONFIG_SND_SOC_ROCKCHIP_I2S=m
CONFIG_SND_SOC_ROCKCHIP_PDM=m
CONFIG_SND_SOC_ROCKCHIP_SPDIF=m
' >> ./target/linux/rockchip/armv8/config-5.4
#
#update new version GCC
rm -rf ./feeds/packages/devel/gcc
svn co https://github.com/openwrt/packages/trunk/devel/gcc feeds/packages/devel/gcc
#
#Additional package
#arpbind
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-arpbind package/lean/luci-app-arpbind
#AutoCore
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lean/autocore package/lean/autocore
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/autocore package/lean/autocore
sed -i "s,@TARGET_x86 ,,g" package/lean/autocore/Makefile
rm -rf ./package/lean/autocore/files/cpuinfo
wget -P package/lean/autocore/files https://raw.githubusercontent.com/QiuSimons/Others/master/cpuinfo
rm -rf ./package/lean/autocore/files/rpcd_10_system.js
wget -P package/lean/autocore/files https://raw.githubusercontent.com/QiuSimons/Others/master/rpcd_10_system.js
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lean/coremark package/lean/coremark
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/coremark package/lean/coremark
sed -i 's,-DMULTIT,-Ofast -DMULTIT,g' package/lean/coremark/Makefile
#DDNS
rm -rf ./feeds/packages/net/ddns-scripts
rm -rf ./feeds/luci/applications/luci-app-ddns
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_aliyun package/lean/ddns-scripts_aliyun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_dnspod package/lean/ddns-scripts_dnspod
svn co https://github.com/openwrt/packages/branches/openwrt-18.06/net/ddns-scripts feeds/packages/net/ddns-scripts
svn co https://github.com/openwrt/luci/branches/openwrt-18.06/applications/luci-app-ddns feeds/luci/applications/luci-app-ddns
#定时重启
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-autoreboot package/lean/luci-app-autoreboot
#AdGuard
git clone -b master --single-branch https://github.com/rufengsuixing/luci-app-adguardhome package/new/luci-app-adguardhome
#Adbyby
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-adbyby-plus package/lean/luci-app-adbyby-plus
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/adbyby package/lean/coremark/adbyby
#SSRP
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/lean/luci-app-ssr-plus
rm -rf ./package/lean/luci-app-ssr-plus/luasrc/view/shadowsocksr/ssrurl.htm
wget -P package/lean/luci-app-ssr-plus/luasrc/view/shadowsocksr https://raw.githubusercontent.com/QiuSimons/Others/master/luci-app-ssr-plus/luasrc/view/shadowsocksr/ssrurl.htm
#SSRP依赖
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/shadowsocks-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shadowsocksr-libev package/lean/shadowsocksr-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt package/lean/pdnsd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/v2ray package/lean/v2ray
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/kcptun package/lean/kcptun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/v2ray-plugin package/lean/v2ray-plugin
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/srelay package/lean/srelay
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/microsocks package/lean/microsocks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dns2socks package/lean/dns2socks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/redsocks2 package/lean/redsocks2
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/proxychains-ng package/lean/proxychains-ng
git clone -b master --single-branch https://github.com/pexcn/openwrt-ipt2socks package/lean/ipt2socks
#svn co https://github.com/QiuSimons/Others/trunk/ipt2socks-1-1 package/lean/ipt2socks
git clone -b master --single-branch https://github.com/aa65535/openwrt-simple-obfs package/lean/simple-obfs
svn co https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/lean/shadowsocks-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/trojan package/lean/trojan
svn co https://github.com/project-openwrt/openwrt/trunk/package/lean/tcpping package/lean/tcpping
#订阅转换
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/subconverter package/new/subconverter
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/jpcre2 package/new/jpcre2
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/rapidjson package/new/rapidjson
#清理内存
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-ramfree package/lean/luci-app-ramfree
#打印机
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-usb-printer package/lean/luci-app-usb-printer
#流量监视
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-wrtbwmon package/lean/luci-app-wrtbwmon
#流量监管
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-netdata package/lean/luci-app-netdata
#OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/new/luci-app-openclash
#SeverChan
git clone -b master --single-branch https://github.com/tty228/luci-app-serverchan package/new/luci-app-serverchan
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/iputils package/network/utils/iputils
#SmartDNS
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt package/new/smartdns/smartdns
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ntlf9t/luci-app-smartdns package/new/smartdns/luci-app-smartdns
#上网APP过滤
git clone -b master --single-branch https://github.com/destan19/OpenAppFilter package/new/OpenAppFilter
#jd-dailybonus
git clone https://github.com/jerrykuku/node-request package/lean/node-request
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus package/lean/luci-app-jd-dailybonus
wget -O package/lean/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/JD_DailyBonus.js https://github.com/NobyDa/Script/raw/master/JD-DailyBonus/JD_DailyBonus.js
#
#frp
git clone https://github.com/lwz322/luci-app-frps.git package/lean/luci-app-frps
git clone https://github.com/kuoruan/luci-app-frpc.git package/lean/luci-app-frpc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/frp package/leanfrp
#beardropper
git clone https://github.com/NateLol/luci-app-beardropper package/luci-app-beardropper
#trojan server
svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-app-trojan-server package/luci-app-trojan-server
#transmission-web-control
rm -rf ./feeds/packages/net/transmission*
rm -rf ./feeds/luci/applications/luci-app-transmission/
svn co https://github.com/coolsnowwolf/packages/trunk/net/transmission feeds/packages/net/transmission
svn co https://github.com/coolsnowwolf/packages/trunk/net/transmission-web-control feeds/packages/net/transmission-web-control
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-transmission feeds/luci/applications/luci-app-transmission
#Dockerman
git clone https://github.com/lisaac/luci-app-dockerman.git package/lean/luci-app-dockerman
git clone https://github.com/lisaac/luci-lib-docker package/lean/luci-lib-docker
svn co https://github.com/openwrt/packages/trunk/utils/docker-ce package/lean/docker-ce
svn co https://github.com/openwrt/packages/trunk/utils/cgroupfs-mount package/lean/cgroupfs-mount
svn co https://github.com/openwrt/packages/trunk/utils/libnetwork package/lean/libnetwork
svn co https://github.com/openwrt/packages/trunk/utils/tini package/lean/tini
svn co https://github.com/openwrt/packages/trunk/utils/containerd package/lean/containerd
svn co https://github.com/openwrt/packages/trunk/utils/runc package/lean/runc
svn co https://github.com/openwrt/packages/trunk/lang/golang package/lang/golang
#multiwan support
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-syncdial package/lean/luci-app-syncdial
#rm -rf feeds/packages/net/mwan3
#rm -rf feeds/luci/applications/luci-app-mwan3
#svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-mwan3 feeds/luci/applications/luci-app-mwan3
#svn co https://github.com/coolsnowwolf/packages/trunk/net/mwan3 feeds/packages/net/mwan3
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-mwan3helper package/lean/luci-app-mwan3helper
#Zerotier
git clone https://github.com/rufengsuixing/luci-app-zerotier package/lean/luci-app-zerotier
svn co https://github.com/coolsnowwolf/packages/trunk/net/zerotier package/lean/zerotier
#OLED display
git clone https://github.com/natelol/luci-app-oled package/natelol/luci-app-oled
wget -O package/natelol/luci-app-oled/root/etc/init.d/oled https://github.com/msylgj/luci-app-oled/raw/patch-1/root/etc/init.d/oled

#CF811AC wifi driver
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-18.06-dev/package/ctcgfw/rtl8821cu package/rtl8821cu
#mkdir package/base-files/files/etc/hotplug.d/usb
#wget -P package/base-files/files/etc/hotplug.d/usb https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/package/base-files/files/etc/hotplug.d/usb/31-usb_wifi
#
#最大连接
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#翻译
git clone -b master --single-branch https://github.com/QiuSimons/addition-trans-zh package/lean/lean-translate
wget -O package/lean/lean-translate/files/zzz-default-settings https://github.com/quintus-lab/Openwrt-R2S/raw/master/script/zzz-default-settings

#生成默认配置及缓存
rm -rf .config
#修正架构
sed -i "s,boardinfo.system,'ARMv8',g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
chmod -R 755 ./
echo -e '\nQuintus Build @ '$(date "+%Y.%m.%d")'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='Quintus Build'" >> package/base-files/files/etc/openwrt_release
exit 0
