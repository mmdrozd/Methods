#!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

# Create standardized repository for packages
if [ ! -e /usr/local/share/emacs/site-lisp/elpa ]; then
    sudo mkdir /usr/local/share/emacs/site-lisp/elpa
    chmod a+rwx /usr/local/share/emacs/site-lisp/elpa
fi

cd /Users
for d in */ ; do
    cd "/Users/$d"
    pathFull=`pwd`
    userName=${PWD##*/} # from http://stackoverflow.com/questions/1371261/get-current-directory-name-without-full-path-in-bash-script
    echo  pwd: $pathFull
    echo -n user: $userName
    id -u $userName # Test whether there is a user with this name
    FailureBecauseNoSuchUser=$?
    if [ $FailureBecauseNoSuchUser -eq 0 ]; then # didn't fail means that user exists
      sudo rm -Rf .emacs
      sudo ln -fs /Volumes/Sync/Lib/config/emacs/dotemacs-osx $pathFull/.emacs
      sudo chmod a+r $pathFull/.emacs
      if [ -e $pathFull/.emacs.d ]; then sudo ditto $pathFull/.emacs.d $pathFull/.emacs.d.orig ; fi
      if [ ! -e /usr/local/share/emacs/site-lisp/elpa ]; then
  	sudo mkdir /usr/local/share/emacs/site-lisp/elpa
	sudo chmod a+rwx /usr/local/share/emacs/site-lisp/elpa
	sudo chown ccarroll:admin /usr/local/share/emacs/site-lisp/elpa
  	echo 'Created by ' $me $ ' on ' `date +%Y%m%d` >  /usr/local/share/emacs/site-lisp/elpa/README.txt
      fi
      if [ ! -e $pathFull/.emacs.d ]; then
	  echo $pathFull/.emacs.d 'does not exist;  creating ...'
    	  echo sudo mkdir $pathFull/.emacs.d
  	  sudo mkdir $pathFull/.emacs.d
  	  echo sudo chown $userName $pathFull/.emacs.d
	  sudo chown $userName $pathFull/.emacs.d
      fi
      if [ -e $pathFull/.emacs.d/elpa ]; then
	  echo 'Deleting existin elpa archive.'
	  echo sudo rm -Rf $pathFull/.emacs.d/elpa
	  sudo rm -Rf $pathFull/.emacs.d/elpa
      fi
    echo sudo ln -fs /usr/local/share/emacs/site-lisp/elpa  $pathFull/.emacs.d
         sudo ln -fs /usr/local/share/emacs/site-lisp/elpa  $pathFull/.emacs.d
    echo sudo chown ccarroll:admin   $pathFull/.emacs.d/elpa
         sudo chown ccarroll:admin   $pathFull/.emacs.d/elpa
    fi # end of things to do if user exists
done
