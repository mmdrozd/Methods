#!/bin/bash
# This script will be in the user's $HOME directory and should be executed upon boot by
# sudo 

# set defaults
default_hostname="$(hostname)"
default_domain="jhu.edu"
tmp="/home/methods" # Working directory

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

echo 'Now reboot'
read answer
