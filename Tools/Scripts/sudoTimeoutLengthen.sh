#!/bin/bash

# The sudo command has a default grace period of 5 minutes after a
# password has been entered; during this grace period the user can
# issue subsequent sudo commands from the same shell without haing to
# enter a password

# This script lengthens the grace period to 5000 minutes
# 

cd /etc
sudo cp -p sudoers sudoers.tmp

if [ ! -e sudoers.default ]; then
    sudo cp -p sudoers sudoers.default
fi

# Check to see whether the time limit for sudo commands has already been upgraded
timestampLineIfExists=`sudo cat /etc/sudoers | grep timestamp | grep 5000`

if [ -z "$timestampLineIfExists" ]; then # If it is of zero length, then it must not have been set yet; set it
       sudo chmod a+rw sudoers.tmp
       echo "# Increase timeout to 5000 minutes - modified via script sudoTimeLengthen.sh by CDC" >> sudoers.tmp
       echo "Defaults:ALL timestamp_timeout=5000" >> /etc/sudoers.tmp
       sudo chmod 0440 sudoers.tmp # if sudoers file does not have these exact permissions, nobody will e allowed to use the command
       sudo mv sudoers.tmp sudoers
fi
