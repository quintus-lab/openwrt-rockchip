#!/bin/bash
export TERM=linux
cd friendlywrt-rk3328/friendlywrt/
git config --local user.email "action@github.com" && git config --local user.name "GitHub Action"
git remote add lean https://github.com/coolsnowwolf/lede.git
git fetch lean
git rebase adc1a9a3676b8d7be1b48b5aed185a94d8e42728^ --onto lean/master -X theirs
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git rebase --skip
git checkout lean/master -- feeds.conf.default
sed -i '$a\src-git helloworld https://github.com/fw876/helloworld' ./feeds.conf.default
sed -i 's/^src-git telephony/#src-git telephony/g' ./feeds.conf.default
rm target/linux/rockchip-rk3328/patches-4.14/0001-net-thunderx-workaround-BGX-TX-Underflow-issue.patch
exit 0
