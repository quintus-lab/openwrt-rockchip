#### OpenWrt原生源码+Simons的patch编译，使用前请仔细阅读如下说明：
1. 原版主线OpenWrt，内核5.4，Luci 19.07+SNAPSHOT均当日最新，默认开启BBR。
2. Full版包含adguard home、ssr-plus、docker、ttyd、zerotier、transmission、smartdns、samba4、openclash、frpc/frps、trojan server、应用过滤、ddns、多线多拨（单线多拨无法叠加带宽）等功能
3. Slim版仅有ssrp、trojan-server、frpc/frps、ddns、应用过滤、zerotier及transmission等常用功能。 
3. 管理地址: 192.168.1.1 默认空密码
4. 驱动原因，暂不支持任何USB无线网卡。已测试支持Hilink模式的4G USB上网卡，NCM模式测试中。
6. 仅打包原版bootstrap主题，请勿轻易安装其它主题（19.07多数不兼容）。
7. 建议关闭ipv6的dns解析，以免影响网络体验，Network-DHCP and DNS-Advanced Settings-Filter IPv6 Records
8. Openwrt原生更新升级功能，支持各种备份、恢复及系统重置。
9. 从友善版固件刷写本固件，建议使用dd写卡：
```
dd if=/tmp/upload/openwrt.img of=/dev/mmcblk0 conv=fsync
```
10. 为避免写卡没有覆盖完全，建议首次启动后先运行firstboot清除再重启一次
11. 上游代码及编译yml更新频繁。自用测试固件，风险自负，不提供任何DaaS.
