#!/bin/bash

# Cobbled together from several sources including the Dropbox.com website

# Assumes you are logged in to a user named "methods"

if [ "$USER" != "methods" ]; then
    echo "Dropbox should be installed when you are logged in with the username 'methods'"
    exit 1 # Signals a failure 
fi

if hash dropbox 2>/dev/null; then # test whether dropbox is already installed
    ps cax | grep dropbox > /dev/null # if installed, is it running? see http://stackoverflow.com/questions/9117507/linux-unix-command-to-determine-if-process-is-running
    if [ $? -eq 0 ]; then
	echo 'Dropbox is already installed.  Stopping it before proceeding.'
	dropbox stop
    fi
    sudo apt-get -y remove dropbox
    # Remove configuration files 
    sudo rm -rf ~/.dropbox ~/.dropbox-dist; sudo rm -rf ~/Dropbox
    # Remove the bug-fix files created below 
    sudo rm -f ~/.config/autostart/start_dropbox.desktop
fi

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
dropbox start

echo ''
echo 'Giving it 30 seconds to set itself up and create necessary config files' ; echo ''
sleep 30 

dropbox autostart n
dropbox stop

# Fix a bug prsent today (2017-02-23) using code from
# http://www.webupd8.org/2016/06/fix-dropbox-indicator-icon-and-menu-not.html

cp ~/.config/autostart/dropbox.desktop ~/.config/autostart/start_dropbox.desktop
sed -i 's/^Exec=.*/Exec=dbus-launch dropbox start -i/' ~/.config/autostart/start_dropbox.desktop
mkdir -p ~/.local/share/applications/
cp /usr/share/applications/dropbox.desktop ~/.local/share/applications/
sed -i 's/^Exec=.*/Exec=dbus-launch dropbox start -i/' ~/.local/share/applications/dropbox.desktop

dropbox start

if [ ! -e /Methods ]; then
    sudo ln -fs /home/methods/Dropbox/Methods /
fi
