#!/bin/bash
export TERM=linux
cd friendlywrt-rk3328/kernel
git config --local user.email "action@github.com" && git config --local user.name "GitHub Action"
git remote add upstream https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git && git fetch upstream
git rebase upstream/linux-5.4.y
cd ../
#patch openwrt 5.4 kernel
git clone https://git.openwrt.org/openwrt/openwrt.git --depth=1 && cd openwrt/
wget -p https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/952-net-conntrack-events-support-multiple-registrant.patch ./target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
cp -a ./target/linux/generic/files/* ../kernel/
./scripts/patch-kernel.sh ../kernel target/linux/generic/backport-5.4
./scripts/patch-kernel.sh ../kernel target/linux/generic/pending-5.4
./scripts/patch-kernel.sh ../kernel target/linux/generic/hack-5.4
./scripts/patch-kernel.sh ../kernel target/linux/octeontx/patches-5.4
exit 0
