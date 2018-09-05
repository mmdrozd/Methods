#!/bin/bash

version=Anaconda2-4.3.1-Linux-x86_64.sh
# Check whether Anaconda is already installed

# For it to be available to all users, it wants to live in /usr/bin/local/anaconda2
# Put it in  the corresponding /pri location, so that it can be linked to from the correct location
# condaPATH=~/Dropbox/pri/root/usr/bin/local/anaconda2
condaPATH=/usr/bin/local/anaconda2 # had to remove it from Dropbox because it was 2.2 g and ate up all the Dropbox space


# If anaconda already exists at the path in question, give the user the opportunity to stop
# in case they want to back up or just keep the existing installation

if [ -e $condaPATH ]; then
    echo $condaPATH already exists.  Hit return to delete it and continue.  This will replace your existing installation.
    echo Hit C-c to abort.
    read answer
    sudo rm -Rf $condaPATH
fi

# Put downloads that you want to erase on reboot into /tmp

cd ~/Downloads

curl -O https://repo.continuum.io/archive/$version

# Verify the integrity of the download

echo 'The sha256sum is below:'
sha256sum $version
echo ''

echo "Compare this to the corresponding hash available at " https://docs.continuum.io/anaconda/hashes/$version-hash
open https://docs.continuum.io/anaconda/hashes/$version-hash

echo 'Hit return when you have confirmed a match.'
read answer

echo 'Now installing via the command:'
installIt="sudo bash $version -b -p $condaPATH"
echo $installIt
eval $installIt


# The installer file is large, and does not need to sit around after installation

sudo rm $version
