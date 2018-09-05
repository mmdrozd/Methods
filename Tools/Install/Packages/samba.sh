#!/bin/bash

# The JHU samba servers require version 2 of the samba protocol to be used
# Make sure that the /etc/samba/smb.conf file defaults to using version 2

sudo apt -y install samba

sudo cp -p /Methods/Tools/Config/tool/samba/root/etc/samba/smb.conf /etc/samba/smb.conf
