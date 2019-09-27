#!/bin/bash
# This script will be in the /var/local/methods directory and should be executed by root at the first boot 

finishPath=https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO/finish_modified-for-methods.sh

# set defaults
default_hostname="$(hostname)"
default_domain="jhu.edu"

# define download function
# courtesy of http://fitnr.com/showing-file-download-progress-using-wget.html
download()
{
    local url=$1
#    echo -n "    "
    wget --progress=dot $url 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
#    echo -ne "\b\b\b\b"
#    echo " DONE"
}

tmp="/tmp"

datetime="$(date +%Y%m%d%H%S)"
sed -i "s/ubuntu/Xub-$datetime/g" /etc/hostname
sed -i "s/ubuntu/Xub-$datetime/g" /etc/hosts

# Install Methods course material

apt-get -y install git
GHDir=/home/methods/GitHub/
mkdir -p "$GHDir"
cd "$GHDir"
git clone https://github.com/ccarrollATjhuecon/Methods.git
chmod -Rf a+rwx "$GHDir"
chown -Rf methods:methods "$GHDir"
cd Methods/Tools/Install/Machines/010_Xubuntu/Scripts
sudo -u methods /bin/bash ./010_Basic.sh
sudo -u methods /bin/bash ./020_Intermediate.sh
sudo -u methods /bin/bash ./030_Advanced.sh

# Other packages

apt -y install emacs
apt -y update
apt -y upgrade

chown -Rf methods:methods /home/methods/*
chown -Rf methods:methods /home/methods/.*
chown -Rf methods:methods /home/methods/*.*


# # download the finish script if it doesn't yet exist
# if [[ ! -f $tmp/finish.sh ]]; then
#     cd "$tmp"
#     download "$finishPath"
# fi

# # set proper permissions on finish script
# chmod a+x "$tmp/finish.sh"

# sudo -u methods xfce4-terminal -e 'bash "$tmp/finish.sh; bash"'

# remove myself to prevent any unintended changes at a later stage
# echo 'Remove this script: sudo rm "$0
# rm $0

#echo 'Run finish.sh'

