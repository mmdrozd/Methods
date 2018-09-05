#!/bin/bash

# Cobbled together from several sources including the Dropbox.com website

# Assumes you are logged in to a user named "methods"

if [ "$USER" != "methods" ]; then
    echo "Dropbox should be installed when you are logged in with the username 'methods'"
    exit 1 # Signals a failure 
fi

if [ -e ~/Dropbox ]; then # Dropbox is maybe already installed
    if hash dropbox 2>/dev/null; then # the dropbox command is installed
	if [ `pgrep dropbox` ]; then  # the dropbox command is running
	    dropboxStatus=`dropbox status`
	    if [ "$dropboxStatus" == "Up to date" ]; then
		echo 'Dropbox is running and up to date, so no need to run it.'
		echo 'To remove it, run ~/bin/Dropbox-Remove.sh'
		exit 0
	    else
		echo 'Dropbox is running but does not have an Up to date status, so fix and rerun'
		exit 0
	    fi
	else 
	    echo 'The dropbox command exists but is not running.  Try launching it.'
	    exit 0
	fi
    else # Dropbox folder exists but command is not installed, so delete folder 
	sudo rm -Rf ~/Dropbox
    fi
fi # Folder does not exist, so proceed to installation

[ `pgrep nautilus` ] && nautilus --quit 2>/dev/null
[ `pgrep nautilus` ] && echo 'Tried to kill nautilus but unable to do so; quit it by hand then hit return' && read answer 
# The code below is only for headless machines
# cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# ~/.dropbox-dist/dropboxd
if [ ! -e /var/lib/samba/usershares ]; then # Prevents a confusing and meaningless errror that pops up when dropbox is installed
	sudo mkdir -p /var/lib/samba/usershares
fi

sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/cache/apt/archives/lock
sudo rm -f /varlib/dpkg/lock
sudo apt -y update
sudo apt -y upgrade

sudo apt -y install nautilus-dropbox
dbus-launch dropbox start -i
# Wait until it has had a chance to initialize itself
sleep 30
if ! [ -e ~/bin ]; then
    mkdir ~/bin
fi
cp ./Dropbox*.sh ~/bin
~/bin/Dropbox-Fix-Icon.sh




