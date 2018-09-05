#!/bin/bash


sudo apt -y install build-essential module-assistant
sudo m-a prepare
sudo apt -y install virtualbox-guest-dkms
sudo apt -y upgrade virtualbox-guest-dkms

# The script below may not be necessary if the install and upgrade work

# ubuntu_description=`lsb_release -d`
# ubuntu_version=${ubuntu_description##*Ubuntu } # Trims everything up to and including the word Ubuntu; http://stackoverflow.com/questions/3162385/how-to-split-a-string-in-shell-and-get-the-last-field

# guest_additions_version='16.04.3 LTS'
# guest_additions_version_full=5.1.30-0ubuntu1.16.04.3

# if [ "$ubuntu_version" != "$guest_additions_version" ]; then
#     echo 'Not running the same version of Ubuntu for which this script was written; install guest additions CD by hand from VirtualBox Devices menu and hit return to proceed.'
#     read answer
# else
#     sudo apt -y install virtualbox-guest-additions-iso=5.0.32-0ubuntu1.16.04.2
# fi

# sudo mkdir /media/VBOXADDITIONS 
# sudo mount -o loop /usr/share/virtualbox/VBoxGuestAdditions.iso /media/VBOXADDITIONS

# cd /media/VBOXADDITIONS

# sudo VBoxLinuxAdditions.run

# cd

# sudo umount /media/VBOXADDITIONS

