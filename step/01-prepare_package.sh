#!/bin/bash
clear

# remove other coremark
rm -rf feeds/packages/utils/coremark
rm -rf package/feeds/packages/coremark
./scripts/feeds update -a && ./scripts/feeds install -a

#OLED display
git clone https://github.com/natelol/luci-app-oled package/natelol/luci-app-oled

#SSRP
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/lean/luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/tcping package/lean/tcping
svn co https://github.com/fw876/helloworld/trunk/naiveproxy package/lean/naiveproxy
svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/lean/shadowsocks-rust

#SSRP dependences
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt package/lean/pdnsd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/srelay package/lean/srelay
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/microsocks package/lean/microsocks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dns2socks package/lean/dns2socks
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/proxychains-ng package/lean/proxychains-ng
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ipt2socks package/lean/ipt2socks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/simple-obfs package/lean/simple-obfs
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shadowsocksr-libev package/lean/shadowsocksr-libev/
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/trojan package/lean/trojan
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/v2ray-plugin package/lean/v2ray-plugin

#wrt bw monitor
git clone -b master --single-branch https://github.com/brvphoenix/wrtbwmon package/new/wrtbwmon
git clone -b master --single-branch https://github.com/brvphoenix/luci-app-wrtbwmon package/new/luci-app-wrtbwmon

#iputils
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/iputils package/network/utils/iputils

# Time stamp with $Build_Date=$(date +%Y.%m.%d)
echo -e '\nQuintus Build@'$(date "+%Y.%m.%d")'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='Quintus Build@$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/luciversion/d' feeds/luci/modules/luci-base/luasrc/version.lua
#echo 'luciversion = "Quintus@🇨🇦🇹🇼🇺🇸🇭🇰"' >> feeds/luci/modules/luci-base/luasrc/version.lua

#生成默认配置及缓存
rm -rf .config

exit 0
