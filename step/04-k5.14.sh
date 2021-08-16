#!/bin/bash
clear
#add kernel 5.14 support
patch -p1 < ../patches/2001-add-5.14-support.patch
#add rockchip 5.14 support
patch -p1 < ../patches/2002-rockchip-add-5.14-support.patch
#mod for 5.14
patch -p1 < ../patches/2003-mod-for-k514.patch
exit 0
