#!/bin/bash

# Modifies screen appearance depending on time of day
# http://f.lux
# Instructions from http://ubuntuhandbook.org/index.php/2016/03/install-f-lux-in-ubuntu-16-04/

# Install dependencies
sudo apt-add-repository ppa:nathan-renniewaldock/flux

sudo apt-get -y update
sudo apt-get -y install fluxgui

# To remove:
# sudo apt-get remove fluxgui
