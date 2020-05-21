#!/bin/bash
export TERM=linux
cd friendlywrt-rk3328/kernel
clear
git remote add upstream https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git && git fetch upstream
git rebase upstream/linux-5.4.y
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
exit 0