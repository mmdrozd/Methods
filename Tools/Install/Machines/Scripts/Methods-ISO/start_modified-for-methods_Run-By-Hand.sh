#!/bin/bash
# This script will be in the user's $HOME directory and should be executed upon boot by
# sudo 

finishPath=https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO/finish_modified-for-methods.sh

# set defaults
default_hostname="$(hostname)"
default_domain="jhu.edu"
tmp="/home/methods/" # Working directory

clear

# check for root privilege
if [ "$(id -u)" != "0" ]; then
    echo " this script must be run as root" 1>&2
    echo
    exit 1
fi

# define download function
# courtesy of http://fitnr.com/showing-file-download-progress-using-wget.html
download()
{
    local url=$1
    echo -n "    "
    wget --progress=dot $url 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo " DONE"
}

# determine ubuntu version
ubuntu_version=$(lsb_release -cs)

# check for interactive shell
if ! grep -q "noninteractive" /proc/cmdline ; then
    echo hi
    stty sane

    # ask questions
    read -ep " please enter your preferred hostname: " -i "$default_hostname" hostname
    read -ep " please enter your preferred domain: " -i "$default_domain" domain

    # print status message
    echo " preparing your server; this may take a few minutes ..."

    # set fqdn
    fqdn="$hostname.$domain"

    # update hostname
    echo "$hostname" > /etc/hostname
    sed -i "s@ubuntu.ubuntu@$fqdn@g" /etc/hosts
    sed -i "s@ubuntu@$hostname@g" /etc/hosts
    hostname "$hostname"

    # update repos
    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    apt-get -y autoremove
    apt-get -y purge

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
        echo -n " downloading finish.sh: "
        cd $tmp
        download "$finishPath"
    fi

    # set proper permissions on finish script
    chmod +x $tmp/finish.sh

fi

# remove myself to prevent any unintended changes at a later stage
# rm $0

echo 'Run sudo ~/finish.sh'
read answer 
# reboot
echo 'Now reboot'
