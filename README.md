### NanoPi R2S固件：Friendlywrt版及原生OpenWrt版

#### 使用Friendlywrt源码更新到最新kernel，集成Lean功能插件，自用固件。<br> 
按应用筛选分成3版本，均不包含任何广告拦截应用。
1. 极简的tiny版，仅包含ssr-plus、ddns(不支持任何USB无线网卡，支持U盘)
2. 瘦身的slim版，包括有ssr-plus、frpc/frps、ttyd、zerotier（支持部分USB无线网卡，只测试过811AC）
3. 定制opt版在精简版基础上增加docker、transmission、等较常用功能等。（支持部分USB无线网卡，只测试过811AC）
4. 默认管理地址:192.168.2.1  用户名:root  密码:password
5. 下载见[FriendlyWrt-R2S固件](https://github.com/ardanzhu/Opwrt_Actions/releases/tag/FriendlyWrt)
#### Friendlywrt版R2S刷机方法：
7. 感谢gary lau的在线更新脚本，可选择保存配置升级，或下载固件后通过web管理页的“文件传输”上传到更新，支持多种R2S编译版本互刷，通过web管理页面的TTYD或SSH到R2S后执行下载脚本并执行：<br> 
```
wget -q https://github.com/ardanzhu/Opwrt_Actions/raw/master/script/update.sh -O update.sh && sh ./update.sh
```

8. 4.18之后固件已预装[songchenwen](https://github.com/songchenwen/nanopi-r2s)大佬的R2S刷机，可在web页面直接升级，与通常的OpenWrt刷机方法无异 <br> 
[R2S刷机IPK链接](https://github.com/ardanzhu/Opwrt_Actions/raw/master/other/luci-app-r2sflasher_1.0-4_all.ipk) 


#### OpenWrt原生源码，使用Simons的patch，脱离Friendlywrt架构编译，原汁原味<br> 
1. 仅打包原版bootstrap主题，自带Openwrt原生更新升级，支持各种备份、恢复及恢复默认设置。
2. Full版包含adguard home、ssr-plus、docker、ttyd、zerotier、transmission、smartdns、samba4、openclash、frpc/frps、trojan server、应用过滤、ddns等等常用功能。
3. Slim版仅有ssrp、trojan-server、frpc/frps、ddns、应用过滤、zerotier等个人自用功能。 
4. 驱动原因，暂不支持任何USB 无线网卡。
5. 管理地址: 192.168.1.1 密码默认为空
4. 下载见[OpenWrt-R2S固件](https://github.com/ardanzhu/Opwrt_Actions/releases/tag/OpenWrt)

### 感谢

- [QiuSimons](https://github.com/QiuSimons/R2S-OpenWrt)
- [Lean](https://github.com/coolsnowwolf/lede)
- [Klever1988](https://github.com/klever1988/nanopi-openwrt)
- [fanck0605](https://github.com/fanck0605/nanopi-r2s)
- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt)
- [Read the details in my blog (in Chinese) | 中文教程](https://p3terx.com/archives/build-openwrt-with-github-actions.html)

#### License
[MIT]


#### Friendlywrt截圖：
![opentomcat](pic/opentomcat.png)

#### Openwrt原生系統截圖：
![bootstrap](pic/bootstrap.png)

