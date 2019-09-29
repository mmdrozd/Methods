#!/bin/bash

# Starting with the `Basic` version of the VM, upgrade it to the `Intermediate` version
source /Methods/Tools/Config/tool/bash/dotbashrc-METHODS

if [ -z "$METH_INSTALL" ]; then
    echo 'Environment variables are not available as required.  Diagnose and fix, then rerun.'
    echo 'Perhaps you tried to run this script using sudo?'
    exit 0
fi

# To allow mounting of remote filesystems like the one that contains the Linux Mathematica installer
sudo apt -y install nautilus-share smbclient

# echo 'You should make a system snapshot before proceeding (using the VirtualBox menu command) before proceeding.  '
# echo 'Hit return when the snapshot has been completed.'
# read answer 

#for installer in TeXLive JHPulse Mathematica; do
for installer in TeXLive; do
    $METH_INSTALL/Software/$installer.sh
done

echo "Now change your machine's hostname to reflect the fact that you have updated it"


