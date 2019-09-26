#!/bin/bash
# This script will be in the /var/local/methods directory and should be executed by root at the first boot 

finishPath=https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO/finish_modified-for-methods.sh

tmp="/tmp"

datetime="$(date +%Y%m%d%H%S)"
sed -i "s/ubuntu/Xub-$datetime/g" /etc/hostname
sed -i "s/ubuntu/Xub-$datetime/g" /etc/hosts

# Install Methods course material

apt-get -y install git
GHDir=/home/methods/GitHub/
mkdir -p "$GHDir"
chmod a+rwx "$GHDir"
cd "$GHDir"
git clone https://github.com/ccarrollATjhuecon/Methods.git
cd Methods/Tools/Install/Machines/010_Xubuntu/Scripts
/bin/bash ./010_Basic.sh

# Other packages

apt -y install emacs 

# download the finish script if it doesn't yet exist
if [[ ! -f $tmp/finish.sh ]]; then
    cd "$tmp"
    download "$finishPath"
fi

# set proper permissions on finish script
chmod a+x "$tmp/finish.sh"

sudo -u methods xfce4-terminal -e 'bash "$tmp/finish.sh; bash"'

# remove myself to prevent any unintended changes at a later stage
# echo 'Remove this script: sudo rm "$0
# rm $0

#echo 'Run finish.sh'
# reboot
#
