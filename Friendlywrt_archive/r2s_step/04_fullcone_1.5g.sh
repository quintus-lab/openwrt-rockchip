#!/bin/bash
clear
export TERM=linux
cd friendlywrt-rk3328/kernel/
wget -O net/netfilter/xt_FULLCONENAT.c https://raw.githubusercontent.com/Chion82/netfilter-full-cone-nat/master/xt_FULLCONENAT.c
git apply ../../patches/000-fullconenat.patch
git apply ../../patches/002-enable-O3.patch
wget https://github.com/armbian/build/raw/master/patch/kernel/rockchip64-dev/RK3328-enable-1512mhz-opp.patch
git apply RK3328-enable-1512mhz-opp.patch
exit 0
