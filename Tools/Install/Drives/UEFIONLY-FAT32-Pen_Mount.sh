#!/bin/bash

if [ ! -e /mnt/UEFIONLY-Pen ]; then
    sudo mkdir /mnt/UEFIONLY-Pen
fi

sudo mount /dev/sdb1 /mnt/UEFIONLY-Pen
