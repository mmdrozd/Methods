#!/bin/bash

#source /Volumes/Sync/Lib/config/bash/dotbashrc-all
# make machine-wide place for package files

# Set location for downloaded packages which should be available to any user 

sudo apt -y update
sudo apt -y install emacs25-nox

touch ~/.emacs
if ! grep -q 'load-theme' ~/.emacs; then
    echo '' >> ~/.emacs
    echo "(load-theme 'tango-dark)" >> ~/.emacs
fi

# $METH_CONFIG/user/make-links-for-users/loop-over-directories-and-make-dot-emacs-link-Linux.sh   

