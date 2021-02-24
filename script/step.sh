git clone https://git.openwrt.org/openwrt/openwrt.git

cd openwrt
git config --local user.email "action@github.com" && git config --local user.name "GitHub Action"
git remote add upstream https://github.com/openwrt/openwrt.git && git fetch upstream
git rebase upstream/master

./scripts/feeds update -a && ./scripts/feeds install -a

sed -i 's/Os/O3/g' include/target.mk
sed -i 's/O2/O3/g' ./rules.mk
#irqbalance
sed -i 's/0/1/g' feeds/packages/utils/irqbalance/files/irqbalance.config
wget -P package/base-files/files/etc/init.d/ https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/zzz-adjust_network

#patches
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/dnsmasq-add-filter-aaaa-option.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/luci-add-filter-aaaa-option.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/luci-app-firewall_add_sfe_switch.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/use_json_object_new_int64.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/kernel_crypto-add-rk3328-crypto-support.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/900-add-filter-aaaa-option.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/998-rockchip-enable-i2c0-on-NanoPi-R2S.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/991-r8152-Add-module-param-for-customized-LEDs.patch

patch -p1 < ./kernel_crypto-add-rk3328-crypto-support.patch
patch -p1 < ./use_json_object_new_int64.patch
patch -p1 < ./dnsmasq-add-filter-aaaa-option.patch
patch -p1 < ./luci-add-filter-aaaa-option.patch
patch -p1 < ./luci-app-firewall_add_sfe_switch.patch
cp ./900-add-filter-aaaa-option.patch package/network/services/dnsmasq/patches/
cp ./998-rockchip-enable-i2c0-on-NanoPi-R2S.patch ./target/linux/rockchip/patches-5.4/
cp ./991-r8152-Add-module-param-for-customized-LEDs.patch ./target/linux/rockchip/patches-5.4/

svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/luci-app-cpufreq package/lean/luci-app-cpufreq
wget https://github.com/project-openwrt/R2S-OpenWrt/raw/master/PATCH/luci-app-freq.patch
patch -p1 < ./luci-app-freq.patch

#FullCone Patch
git clone -b master --single-branch https://github.com/QiuSimons/openwrt-fullconenat package/fullconenat
# Patch FireWall for fullcone
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/fullconenat.patch

pushd feeds/luci
wget -O- https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
popd
#Patch Kernel for fullcone
pushd target/linux/generic/hack-5.4
wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
popd

# SFE kernel patch
pushd target/linux/generic/hack-5.4
wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/999-shortcut-fe-support.patch
popd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe package/new/shortcut-fe
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/fast-classifier package/new/fast-classifier

wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/999-unlock-1608mhz-rk3328.patch
cp 999-unlock-1608mhz-rk3328.patch target/linux/rockchip/patches-5.4/


rm -rf ./feeds/packages/devel/gcc
svn co https://github.com/openwrt/packages/trunk/devel/gcc feeds/packages/devel/gcc

#arpbind
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-arpbind package/lean/luci-app-arpbind
#AutoCore
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/autocore package/lean/autocore
#coremark
rm -rf ./feeds/packages/utils/coremark
rm -rf ./package/feeds/packages/coremark
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/coremark package/lean/coremark
sed -i 's,-DMULTIT,-Ofast -DMULTIT,g' package/lean/coremark/Makefile
#ddns script
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_aliyun package/lean/ddns-scripts_aliyun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_dnspod package/lean/ddns-scripts_dnspod
#autoreboot
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-autoreboot package/lean/luci-app-autoreboot
#gost
svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/gost package/ctcgfw/gost
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/luci-app-gost package/ctcgfw/luci-app-gost
#ssrp
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/lean/luci-app-ssr-plus
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
git clone -b master --single-branch https://github.com/aa65535/openwrt-simple-obfs package/lean/simple-obfs
svn co https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/lean/shadowsocks-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/trojan package/lean/trojan
svn co https://github.com/project-openwrt/openwrt/trunk/package/lean/tcpping package/lean/tcpping

git clone -b master --single-branch https://github.com/garypang13/luci-theme-edge package/new/luci-theme-edge

#OLED display
git clone https://github.com/natelol/luci-app-oled package/natelol/luci-app-oled

svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-ramfree package/lean/luci-app-ramfree
#打印机
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-usb-printer package/lean/luci-app-usb-printer
#流量监视
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-wrtbwmon package/lean/luci-app-wrtbwmon

git clone -b master --single-branch https://github.com/brvphoenix/wrtbwmon package/new/wrtbwmon
git clone -b master --single-branch https://github.com/brvphoenix/luci-app-wrtbwmon package/new/luci-app-wrtbwmon

#jd-dailybonus
git clone https://github.com/jerrykuku/node-request package/lean/node-request
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus package/lean/luci-app-jd-dailybonus
wget -O package/lean/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/JD_DailyBonus.js https://github.com/NobyDa/Script/raw/master/JD-DailyBonus/JD_DailyBonus.js
#

rm -f ./feeds/luci/applications/luci-app-frps
rm -f ./package/feeds/luci/luci-app-frps
rm -f ./feeds/luci/applications/luci-app-frpc
rm -f ./package/feeds/luci/luci-app-frpc
rm -rf ./feeds/packages/net/frp
rm -rf ./package/feeds/packages/frp
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/frp package/lean/frp
git clone https://github.com/lwz322/luci-app-frps.git package/lean/luci-app-frps
git clone https://github.com/kuoruan/luci-app-frpc.git package/lean/luci-app-frpc

#beardropper
git clone https://github.com/NateLol/luci-app-beardropper package/luci-app-beardropper
#tmate
svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/tmate package/ctcgfw/tmate
#transmission-web-control
rm -rf ./feeds/packages/net/transmission*
rm -rf ./feeds/luci/applications/luci-app-transmission/
svn co https://github.com/coolsnowwolf/packages/trunk/net/transmission feeds/packages/net/transmission
svn co https://github.com/coolsnowwolf/packages/trunk/net/transmission-web-control feeds/packages/net/transmission-web-control
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-transmission feeds/luci/applications/luci-app-transmission

git clone https://github.com/rufengsuixing/luci-app-zerotier package/lean/luci-app-zerotier
svn co https://github.com/coolsnowwolf/packages/trunk/net/zerotier package/lean/zerotier
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

#翻译
git clone -b master --single-branch https://github.com/QiuSimons/addition-trans-zh package/lean/lean-translate
wget -O package/lean/lean-translate/files/zzz-default-settings https://github.com/quintus-lab/Openwrt-R2S/raw/master/script/zzz-default-settings

svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/rtl8821cu package/ctcgfw/rtl8821cu

rm -rf .config
#修正架构
sed -i "s,boardinfo.system,'ARMv8',g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
chmod -R 755 ./
echo -e '\nQuintus Build @ '$(date "+%Y.%m.%d")'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='Quintus Build@$(date "+%Y.%m.%d")" >> package/base-files/files/etc/openwrt_release

#install upx
mkdir -p staging_dir/host/bin/
ln -s /usr/bin/upx-ucl staging_dir/host/bin/upx
#or
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/step/03-remove_upx.sh
bash 03-remove_upx
