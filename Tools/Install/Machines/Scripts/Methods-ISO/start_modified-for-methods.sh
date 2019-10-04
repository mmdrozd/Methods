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
GHDir=/home/methods/GitHub/ccarrollATjhuecon
mkdir -p "$GHDir"
cd "$GHDir"
if [ ! -e /home/methods/GitHub/ccarrollATjhuecon/Methods ]; then
    git clone https://github.com/ccarrollATjhuecon/Methods.git
    cd Methods
else
    cd Methods
    git fetch
    git pull
fi
chmod -Rf a+rwx "$GHDir"
chown -Rf methods:methods "$GHDir"

# Now add the paths to the root environment 
sudo chmod u+w /etc/environment

sudo cat /etc/environment "$GHDir/Methods/Tools/Config/tool/bash/dotbashrc-METHODS" > /tmp/environment
sudo mv /tmp/environment /etc/environment # Weird permissions issue prevents direct redirect into /etc/environment
sudo chmod u-w /etc/environment

source /etc/environment

cd Tools/Install/Machines/010_Xubuntu/Scripts

chown -Rf methods:methods /home/methods/*
chown -Rf methods:methods /home/methods/.*
chown -Rf methods:methods /home/methods/*.*

sudo ./010_Basic.sh
sudo ./020_Intermediate.sh
sudo ./030_Advanced.sh

# Adding the methods user to the vbox allows the user to browse shared network folders
sudo adduser methods vboxsf

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

