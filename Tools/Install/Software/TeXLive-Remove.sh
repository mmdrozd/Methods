#!/bin/bash
# If texlive exists, remove it

if [ ! -e /usr/local/texlive ]; then
    echo '/usr/local/texlive does not exist, so it would appear that TeXLive is not installed.'
    exit 0
fi

# This will leave /opt/texbin in the /etc/environment file, but that should not cause any problems

sudo apt -y purge texlive*
sudo apt -y autoremove
sudo apt -y clean
sudo rm -rf /usr/local/texlive
sudo rm -rf ~/.texlive*
sudo rm -rf /usr/local/share/texmf
sudo rm -rf /var/lib/texmf
sudo rm -rf /etc/texmf
sudo apt -y remove tex-common --purge
sudo rm -Rf /etc/fonts/conf.d/*texlive*

