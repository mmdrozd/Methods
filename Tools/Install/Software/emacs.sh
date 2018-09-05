#!/bin/bash

source /Volumes/Sync/Lib/config/bash/dotbashrc-all
# make machine-wide place for package files

# Set location for downloaded packages which should be available to any user 

sudo apt-get update
sudo apt-get -y install emacs

sudo /$METH_CONFIG/user/make-links-for-users/loop-over-directories-and-make-dot-emacs-link-Linux.sh   

