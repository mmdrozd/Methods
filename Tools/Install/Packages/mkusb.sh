#!/bin/bash
# Create a usb drive from a disk image
# 20170208 from https://help.ubuntu.com/community/mkusb

sudo add-apt-repository universe  # only for standard Ubuntu
sudo add-apt-repository ppa:mkusb/ppa  # and press Enter
sudo apt-get update
sudo apt-get install mkusb mkusb-nox usb-pack-efi

