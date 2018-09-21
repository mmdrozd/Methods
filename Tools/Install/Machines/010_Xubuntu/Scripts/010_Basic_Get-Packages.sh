#!/bin/bash

echo '' ; echo "$0" ; echo ''

# Packages that can be installed directly and with no need for any configuration

sudo apt -y install gparted bash-completion xsel markdown xscreensaver git hfsprogs rpl lynx touchegg curl wget nscd cifs-utils openssh-server nautilus-share xclip

# Packages that need to be installed by a custom script

source ~/.bashrc # Get environment variables
cmd="cd $METH_PACKAGES"
echo "$cmd"
eval "$cmd"
pwd

# 

# Packages to install if running in VirtualBox

if grep -q ^flags.*\ hypervisor\  /proc/cpuinfo; then
    echo "This is a Virtual Machine; installing VirtualBox-Guest-Additions"
    sudo ./VirtualBox-Guest-Additions.sh
fi

sudo /Methods/Tools/Install/Packages/samba.sh
