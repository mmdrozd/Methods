#!/bin/bash

source /Volumes/Sync/Lib/config/bash/dotbashrc-all
# make machine-wide place for package files

# Set location for downloaded packages which should be available to any user 

sudo apt-get update
sudo apt-get -y install emacs

$METH_CONFIG/user/make-links-for-users/loop-over-directories-and-make-dot-emacs-link-Linux.sh
sudo mkdir -p /usr/local/share/emacs/site-lisp/elpa/gnupg
sudo gpg --homedir /usr/local/share/emacs/site-lisp/elpa/gnupg --receive-keys 066DAFCB81E42C40
