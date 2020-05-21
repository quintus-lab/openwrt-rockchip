#!/bin/bash
clear
cd friendlywrt-rk3328/friendlywrt/
git config --local user.email "action@github.com" && git config --local user.name "GitHub Action"
git remote add upstream https://github.com/coolsnowwolf/lede && git fetch upstream
git rebase adc1a9a3676b8d7be1b48b5aed185a94d8e42728^ --onto upstream/master -X theirs
git revert --no-edit 23378ed9a481dc73923f5bfa81637a1a8056882d
git revert --no-edit 4787dbaf3cad44b374b660cc0fef9386963e6795
git revert --no-edit 463b6ac0508de4788a6e41335471ced0a255e1cd
git revert --no-edit 8faac30089ce616940b3e96c4f4d900aeb6b9fcb
rm target/linux/rockchip-rk3328/patches-4.14/0001-net-thunderx-workaround-BGX-TX-Underflow-issue.patch
git checkout upstream/master -- feeds.conf.default
sed -i '$a\src-git helloworld https://github.com/fw876/helloworld' ./feeds.conf.default
sed -i 's/^src-git telephony/#src-git telephony/g' ./feeds.conf.default
exit 0
