#!/bin/bash

echo '' ; echo Running "$0" ; echo ''
cd "$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script

# Links that will allow compatibility of scripts across systems

[ ! -e /Volumes ]          && sudo mkdir --mode=a+r /Volumes 
[ ! -e /Volumes/Sync ]     && sudo mkdir --mode=a+r /Volumes/Sync 
[ ! -e /Volumes/Sync/Lib ] && sudo mkdir --mode=a+r /Volumes/Sync/Lib 

if [ ! -e /Volumes/Sync/Lib/config ]; then # if it already exists, this command screws things up so don't do it
    sudo ln -fs /Methods/Tools/Config/tool /Volumes/Sync/Lib/config
fi

if [ -e /media/ro.llorracc.local ]; then # We are working on a home-local machine
    llorraccMethSlvePath=/media/ro.llorracc.local/Volumes/Sync/Dropbox/OthersTo/JHU/Courses/shr/Methods

    llorraccMethMstrPath=/media/rw.llorracc.local/Volumes/Sync/Dropbox/OthersTo/JHU/Courses/pri/Methods
    if [ ! "$(ls -A /media/ro.llorracc.local)" ]; then # we have not mounted the ro.llorracc.local directory
	echo 'ro.llorracc.local exists but is empty -- must be mounted to proceed.  Hit return when mounted.'
	read answer
    fi
    sudo rm -f /Methods-Slve
    sudo ln -fs $llorraccMethSlvePath /Methods-Slve
    if [ ! "$(ls -A /media/rw.llorracc.local)" ]; then # we have not mounted the rw.llorracc.local directory
	echo 'rw.llorracc.local exists but is empty -- must be mounted to proceed.  Hit return when mounted.'
	read answer
    fi
    sudo rm -f /Methods-Mstr
    sudo ln -fs $llorraccMethMstrPath /Methods-Mstr
    #    If no /Methods link exists, then create one for /Methods-Mstr; if one does exist, let it remain as is 
    if [ ! -e /Methods ]; then
	sudo ln -fs /Methods-Mstr /Methods
    fi
else # it's not a local machine so Methods should be local
    [[ -L /Methods ]] && sudo rm -f /Methods # if /Methods exists, the ln syntax below will create /Methods/Methods; delete it to prevent
    if [ -e /home/methods/GitHub/Methods ]; then
	sudo ln -fs /home/methods/GitHub/Methods /
    else
	if [ -e /home/methods/Dropbox/Methods ]; then # if GitHub/Methods did not exist link /Methods to Dropbox/Methods if it does 
	    sudo ln -fs /home/methods/Dropbox/Methods /
	else
	    echo 'Could not find an installation of Methods'
	    echo 'Install either via GitHub or Dropbox and try again'
	    exit 1
	fi
    fi
    sudo mkdir -p /Volumes/Data
    sudo rm -f  /Volumes/Data/Tools ; sudo ln -fs /Methods/Tools/Scripts /Volumes/Data/Tools
fi

# equivalate /Users (where MacOS stores them) and /home (where Linux stores them)

if [ ! $(uname -s) = "Darwin" ]; then # Not MacOS, assume Linux
    sudo rm -f /Users
    sudo ln -fs /home /Users
fi

# Make sure a root password has been set 
if [ `uname` == 'Linux' ]; then 
    passwd_root_status=`sudo passwd --status root`
    arr=($passwd_root_status) # parse the result into individual 'words'
    if [ arr[1] == 'NP' ]; then # The second 'word' is NP if No Password has been set 
	echo 'Need to set a root login password.  Do it now.'
	sudo passwd -i
    fi
fi

# Lengthen the grace period for use of the sudo command
sudo /Methods/Tools/Scripts/sudoTimeoutLengthen.sh

if [ ! -e /usr/local/methods ]; then
    sudo ln -fs    /Methods/Tools/Scripts /usr/local/methods
    sudo chmod a+x /usr/local/methods
fi

# Set up cron jobs that should be run automatically
if [ ! -e /etc/cron.d ]; then
    sudo mkdir -p /etc/cron.d
fi

sudo cp        ./010_Basic_Make-Root-Links_/etc/cron.d/* /etc/cron.d
sudo chmod a+x /etc/cron.d/*

sudo mkdir -p /home/methods/.local/share/applications
sudo chmod a+rw /home/methods/.local/share/applications
