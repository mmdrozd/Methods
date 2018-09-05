#!/bin/bash

if [ ! -e /mnt/Xubuntu-Pen ]; then
    sudo mkdir /mnt/Xubuntu-Pen
fi

sudo mount -o rw /dev/sdb3 /mnt/Xubuntu-Pen
