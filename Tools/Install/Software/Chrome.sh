#!/bin/bash

# As of 20170202, there is not an "official" Ubuntu repository for installing Chrome.
# The method of installation below was adapted from
# http://askubuntu.com/questions/760085/how-do-you-install-google-chrome-on-ubuntu-16-04?noredirect=1&lq=1
#
# The directory /var/cache/apt/methods is where repos downloaded for the methods course should be stored 

if [ ! -e /var/cache/apt/methods ]; then
    sudo mkdir /var/cache/apt/methods
fi

if [ -e /var/cache/apt/methods/google-chrome-stable_current_amd64.deb ]; then
    echo ''
    echo 'It appears that you may already have installed Google Chrome.  Skipping installation.'
    echo ''
    echo 'To force a reinstall delete '
    echo '' 
    echo '/var/cache/apt/google-chrome-stable_current_amd64.deb'
    echo ''
    echo 'and rerun this script.'
    echo ''
    echo ''
    echo ''
    echo ''
else 
    cd /var/cache/apt/methods
    sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
    sudo apt -y install -f

    echo 
    echo 
    echo 'Now is your chance to change your preferred browser to Chrome (actually, Chromium) using Preferred Applications tool'
    echo 
    echo 'Launch it from mouse menu at top if desired'
#    echo 'Hit return when you have made your choice.'
#    read answer
fi

# Make Chrome the default app for handling text/html mimetype 
sudo xdg-mime default google-chrome.desktop text/html
