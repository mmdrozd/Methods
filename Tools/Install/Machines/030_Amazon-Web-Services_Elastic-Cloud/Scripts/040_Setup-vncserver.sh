#!/bin/bash
# This script configures an EC2 instance for a GUI

# Google "GUI using VNC with Amazon EC2 Instances Arfat Khan"
# The instructions below follow that post

# At the command line in the EC2 instance:

echo 'Please wait while software is installed'
sudo apt-get update
sudo apt-get install ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal xfce4 vnc4server

echo 'Launching vncserver for the first time'
vncserver 

# 0. Now setup startup files

mkdir -p ~/.vnc/xstartup
cp /Methods/Tools/Install/Machines/030_Amazon-Web-Services_Elastic-Cloud/Resources/userRoot/dot/vnc/xstartup_xfce ~/.vnc/xstartup
chmod a+x !$

# 0. Now logout of the server and install a vnc client on the remote machine
#     remmina is a good client
# See script "Connect-To-vncserver-From-Outside.sh


