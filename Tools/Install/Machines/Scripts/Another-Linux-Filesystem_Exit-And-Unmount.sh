#!/bin/bash

exit

echo for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
sudo for i in /dev /dev/pts /proc /sys /run; do sudo umount   $i /mnt$i; done

echo 'sudo umount $devName /mnt'
sudo umount $devName /mnt




