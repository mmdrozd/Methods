#!/bin/bash

if [ `whoami` != 'methods' ]; then
    echo 'This script must be run by username methods'
    echo ''
    echo 'Exiting.'
    exit 1
fi

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

# If it does not already exist, create standardized location for repository for downloaded packages 
if [ ! -e /usr/local/share/emacs/site-lisp/elpa ]; then
    sudo mkdir -p   /usr/local/share/emacs/site-lisp/elpa
    sudo mkdir -p   /usr/local/share/emacs/site-lisp/elpa/archives
fi

# Fix permissions if they are broken
sudo chmod a+rwx     /usr/local/share/emacs/site-lisp/elpa
sudo chmod -Rf a+rwx /usr/local/share/emacs/site-lisp/elpa/archives

Users=Users  # Mac default

if [ `uname` == 'Linux' ]; then
    Users=home
fi

cd /$Users

for d in */ ; do
    cd "/$Users/$d"
    pathFull=`pwd`
    userName=${PWD##*/} # from http://stackoverflow.com/questions/1371261/get-current-directory-name-without-full-path-in-bash-script
    echo    'pwd: ' $pathFull
    echo    'user:' $userName
    echo -n 'uid:  '
    id -u $userName # Test whether there is a user with this name
    FailureBecauseNoSuchUser=$?
    if [ $FailureBecauseNoSuchUser -eq 0 ]; then # didn't fail means that user exists
        if [ -e $pathFull/.emacs ]; then
            sudo rm -f $pathFull/.emacs
        fi
	if [ $userName == "methods" ]; then 
	    sudo ln -fs /Volumes/Sync/Lib/config/emacs/dot/emacs-linux $pathFull/.emacs # This is for backwards compatibility, and can eventually be removed 
	else
	    sudo cp /Volumes/Sync/Lib/config/emacs/dot/emacs-linux $pathFull/.emacs
	    sudo cp /Volumes/Sync/Lib/config/emacs/dot/emacs-all   $pathFull/.emacs-all
	    sudo chown $userName:$userName $pathFull/.emacs
	    sudo chown $userName:$userName $pathFull/.emacs-all
	fi
	if [ -e $pathFull/.emacs.d ]; then sudo cp -r $pathFull/.emacs.d $pathFull/.emacs.d.orig ; fi
	if [ ! -e $pathFull/.emacs.d ]; then
            echo $pathFull/.emacs.d 'does not exist;  creating ...'
            echo mkdir $pathFull/.emacs.d
            sudo mkdir $pathFull/.emacs.d
            echo chown $userName:$userName $pathFull/.emacs.d
            sudo chown $userName:$userName $pathFull/.emacs.d
	fi
	if [ -e $pathFull/.emacs.d/elpa ]; then
            echo 'Deleting existing elpa archive.'
            echo rm -Rf $pathFull/.emacs.d/elpa
            sudo rm -Rf $pathFull/.emacs.d/elpa
	fi
	echo ln -fs /usr/local/share/emacs/site-lisp/elpa  $pathFull/.emacs.d
        sudo -u $USER ln -fs /usr/local/share/emacs/site-lisp/elpa  $pathFull/.emacs.d
	#    echo chown methods:admin   $pathFull/.emacs.d/elpa
	#         sudo chown methods:admin   $pathFull/.emacs.d/elpa
    fi # end of things to do if user exists
done
