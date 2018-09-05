#!/bin/bash

lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT

echo '' ; echo 'Enter alternative device on which Linux has been installed, e.g. /dev/sda3'
read devName # e.g., =/dev/sda3

echo 'sudo mount $devName /mnt'
sudo mount $devName /mnt

echo for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
     for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done

echo '' 
echo 'You can now enter and run from the new filesystem as though you had booted with it using the command:'
echo ''
echo 'sudo chroot /mnt'
echo ''

echo ''
echo 'When done, type exit to return to your original filesystem, and unmount the alternative one.'



