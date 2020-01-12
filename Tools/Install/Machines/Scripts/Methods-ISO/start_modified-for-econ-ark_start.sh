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
