#!/bin/bash

if [ ! -e /mnt/UEFIONLY ]; then
    sudo mkdir /mnt/UEFIONLY-VBox
fi

sudo mount /dev/sda2 /mnt/UEFIONLY-VBox
