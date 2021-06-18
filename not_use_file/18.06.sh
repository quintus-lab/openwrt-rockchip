#!/bin/bash
clear
#生成时间
VersionDate=$(git show -s --date=short --format="%cd")
echo "::set-env name=VersionDate::$VersionDate"
echo "::set-env name=DATE::$(date "+%Y-%m-%d %H:%M:%S")"
Build_Date=$(date +%Y.%m.%d)
echo "::set-env name=Build_Date::$(date +%Y.%m.%d)"
#更新feed
./scripts/feeds update -a && ./scripts/feeds install -a

patch -p1 < ../patches/for_r2s_18.06.patch

#update new version GCC
#rm -rf ./feeds/packages/devel/gcc
#svn co https://github.com/openwrt/packages/trunk/devel/gcc feeds/packages/devel/gcc
#update new version Golang
#rm -rf ./feeds/packages/lang/golang
#svn co https://github.com/openwrt/packages/trunk/lang/golang feeds/packages/lang/golang

#edge主题
#git clone -b master --single-branch https://github.com/garypang13/luci-theme-edge package/new/luci-theme-edge

#流量监视
#rm -rf package/lean/luci-app-wrtbwmon
#git clone -b master --single-branch https://github.com/brvphoenix/wrtbwmon package/new/wrtbwmon
#git clone -b master --single-branch https://github.com/brvphoenix/luci-app-wrtbwmon package/new/luci-app-wrtbwmon
#流量监管
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-netdata package/lean/luci-app-netdata
#SeverChan
#git clone -b master --single-branch https://github.com/tty228/luci-app-serverchan package/new/luci-app-serverchan

#jd-dailybonus
#git clone https://github.com/jerrykuku/node-request package/lean/node-request
#git clone https://github.com/jerrykuku/luci-app-jd-dailybonus package/lean/luci-app-jd-dailybonus
#wget -O package/lean/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/JD_DailyBonus.js https://github.com/NobyDa/Script/raw/master/JD-DailyBonus/JD_DailyBonus.js

#frp
rm -rf ./package/lean/luci-app-frpc
#rm -rf ./package/ctcgfw/luci-app-frps
#git clone https://github.com/lwz322/luci-app-frps.git package/lean/luci-app-frps
git clone https://github.com/kuoruan/luci-app-frpc.git package/lean/luci-app-frpc

echo -e '\nQuintus Build @ '$Build_Date'\n'  >> package/lean/default-settings/files/openwrt_banner
wget -O package/lean/default-settings/files/zzz-default-settings https://github.com/quintus-lab/Openwrt-R2S/raw/master/script/zzz-default-settings-18.06
sed -i 's/| Mod20.08 by CTCGFW/| Mod20.08 by CTCGFW | Build by Quintus@'$Build_Date'/g' package/lean/default-settings/files/zzz-default-settings

chmod -R 755 ./

exit 0
