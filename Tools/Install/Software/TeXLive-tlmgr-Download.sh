#!/bin/bash

# There are too many options for installing TeXLive, none of which is very satisfactory.
# 
# http://tipsonubuntu.com/2016/09/16/install-tex-live-2016-ubuntu-16-04-14-04/
# http://chrisstrelioff.ws/sandbox/2016/10/31/install_tex_live_2016_on_ubuntu_16_04.html
# https://www.tug.org/texlive/doc/texlive-en/texlive-en.html#tlportable
# 
# All of these omit the tlmgr tool, which is like installing Ubuntu without the apt tool

# The best option to install BOTH TeXLive AND tlmgr seems to be:
# https://github.com/scottkosty/install-tl-ubuntu

# However, in order to work, this requires the installation of perl-tk and recommends gksu

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo apt update
sudo apt -y install perl-tk
sudo apt -y install gksu

# Because TeXLive is so large, uninstall any previous versions before installing

sudo "$scriptDir/TeXLive-Remove.sh"

# Installs into /opt/texbin, so that directory must exist
if [ ! -d /opt/texbin ]; then
    sudo mkdir -p /opt/texbin
fi

# Store the install files in the ~/tmp-TeXLive directory, erase it at the end of the install
mkdir -p ~/tmp-TeXLive ; cd ~/tmp-TeXLive 

# wget is a command that retrieves files from the internet 
wget https://github.com/scottkosty/install-tl-ubuntu/raw/master/install-tl-ubuntu && chmod +x ./install-tl-ubuntu

sudo apt -y install texlive-base

sudo ./install-tl-ubuntu --more-tex # This is the installer, which must be executed with root permissions; the --more-tex option installs extra files needed, for example, for Lyx

# Add the path to the current binaries 
sudo /opt/texbin/x86_64-linux/tlmgr path add

# Finally, install okular as the PDF reader
sudo apt -y install okular

