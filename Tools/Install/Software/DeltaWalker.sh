#!/bin/bash

cd /tmp
if [ ! -e ~/Downloads/DeltaWalker-2.3.0-Linux_64.zip ]; then
    echo 'Please download DeltaWalker to the ~/Downloads directory and hit return.'
    read answer
fi
 
unzip ~/Downloads/DeltaWalker-2.3.0-Linux_64.zip
mkdir -p /usr/local/share/applications
cd /tmp
sudo mv deltawalker /usr/local/share/applications
open /usr/local/share/applications/DeltaWalker


