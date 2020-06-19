#!/bin/bash
clear
cd friendlywrt-rk3328/friendlywrt/
git config --local user.email "action@github.com" && git config --local user.name "GitHub Action"
git remote add upstream https://github.com/coolsnowwolf/lede && git fetch upstream
git rebase adc1a9a3676b8d7be1b48b5aed185a94d8e42728^ --onto upstream/master -X theirs
rm target/linux/rockchip-rk3328/patches-4.14/0001-net-thunderx-workaround-BGX-TX-Underflow-issue.patch
git checkout upstream/master -- feeds.conf.default
sed -i '$a\src-git helloworld https://github.com/fw876/helloworld' ./feeds.conf.default
sed -i 's/^src-git telephony/#src-git telephony/g' ./feeds.conf.default
exit 0
