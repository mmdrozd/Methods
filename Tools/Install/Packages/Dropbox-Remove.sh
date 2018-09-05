#!/bin/bash

# Cobbled together from several sources including the Dropbox.com website

# Assumes you are logged in to a user named "methods"

if [ "$USER" != "methods" ]; then
    echo "Dropbox should be installed and removed when you are logged in with the username 'methods'"
    echo "Instead, you are logged in as $USER"
    echo "You will need to rerun this script in order to remove Dropbox."
    exit 1 # Signals a failure 
fi

if hash dropbox 2>/dev/null; then # test whether dropbox is already installed 
    if [ `pgrep dropbox` ]; then  # if installed, is it running? see http://stackoverflow.com/questions/9117507/linux-unix-command-to-determine-if-process-is-running
	echo 'Dropbox is installed and running.  Stopping it before proceeding.'
	dropbox stop
	sleep 10
    fi
    sudo apt -y remove nautilus-dropbox
    # Remove configuration files 
    sudo rm -rf ~/.dropbox ~/.dropbox-dist; sudo rm -rf ~/Dropbox
    # Remove the bug-fix files created below 
    sudo rm -f ~/.config/autostart/start_dropbox.desktop
    sudo rm -f /Methods
    source ~/.bashrc-linux-local-mount
fi

