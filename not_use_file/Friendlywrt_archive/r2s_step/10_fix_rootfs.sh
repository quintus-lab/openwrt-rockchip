#!/bin/bash
export TERM=linux
sudo df -lh
lodev=$(sudo losetup -f)
echo "found unused loop dev $lodev"
sudo losetup -P $lodev friendlywrt-rk3328/out/*.img
sudo rm -rf /mnt/friendlywrt-tmp
sudo mkdir -p /mnt/friendlywrt-tmp
sudo mount ${lodev}p1 /mnt/friendlywrt-tmp
sudo chown -R root:root /mnt/friendlywrt-tmp
sudo umount /mnt/friendlywrt-tmp
sudo losetup -d $lodev
exit 0
