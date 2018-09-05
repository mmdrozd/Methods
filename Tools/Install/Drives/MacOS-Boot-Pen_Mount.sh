#!/bin/bash

if [ ! -e /mnt/MacOS-Boot-Pen ]; then
   sudo mkdir /mnt/MacOS-Boot-Pen
fi

sudo mount -t hfsplus -o force,rw /dev/sdb2 /mnt/MacOS-Boot-Pen
   
