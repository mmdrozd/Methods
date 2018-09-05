#!/bin/bash

if [ ! -e /mnt/MacOS-Boot-VBx ]; then
   sudo mkdir /mnt/MacOS-Boot-VBx
fi

sudo mount -t hfsplus -o force,rw /dev/sda3 /mnt/MacOS-Boot-VBx
   
