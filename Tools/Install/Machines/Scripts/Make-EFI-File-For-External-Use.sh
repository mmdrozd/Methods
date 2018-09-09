#!/bin/bash

sudo apt -y install grub-efi-amd64 
sudo grub-mkconfig -o /boot/grub/grub.cfg
grub-mkstandalone  -o /tmp/boot.efi -d /usr/lib/grub/x86_64-efi -O x86_64-efi --compress=xz /boot/grub/grub.cfg
mv /tmp/boot.efi /boot/efi/ls /usr
