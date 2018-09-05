#!/bin/bash

thisDirName=`pwd`                     
thisScript=`basename "$0"`                
thisScriptName=`echo "${thisScript%.*}"`  

echo 

echo 'Ensure that the following preconditions are met:'
echo '  * You are running this in Virtualbox from a Xubuntu filesystem on partition /sda1'
echo '  * Partition sda2 is (a) FAT32 formatted; (b) has the boot and the esp flags; (c) has the bootloader from which VirtualBox was booted'
echo '  * Partition sda3 is (a) HFS+ formatted'
echo '  * You have mounted the recipient pen drive using VirtualBox/Devices/USB as /sdb'
echo '  * The recipient FAT32 partition on that machine is at   /sdb1'
echo '  * The recipient HFS+  partition on that machine is at   /sdb2'
echo '  * The recipient Xubuntu partition on that machine is at /sdb3'


./UEFIONLY-FAT32-VBx_Mount.sh
./UEFIONLY-FAT32-Pen_Mount.sh

sudo rsync -avz /mnt/UEFIONLY/ /mnt/UEFIONLY-Pen

./UEFIONLY-FAT32-VBx_umount.sh
./UEFIONLY-FAT32-Pen_umount.sh

./Xubuntu-Pen_Mount.sh

#sudo rsync -avz --exclude=/mnt --exclude=/media --exclude=/proc --exclude=/dev --exclude=lost+found/ --exclude=/var/log --exclude=/etc/network/interfaces / /mnt/Xubuntu-Pen 2> .$thisScriptName.err
#sudo rsync -avz --exclude-from=/Methods/Tools/Install/Drives/Xubuntu-Filesystem-hotclone-rsync-excludes / /mnt/Xubuntu-Pen 2> /tmp/rsync.err

# https://www.archlinux.org/index.php/Full_system_backup_with_rsync
sudo rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / /mnt/Xubuntu-Int

./Xubuntu-Pen_umount.sh

./MacOS-Boot-Pen_Mount.sh
./MacOS-Boot-VBx_Mount.sh

sudo rsync -aAXvz --exclude=.Spotlight* --exclude=.Trash* --exclude=.fseventsd* --exclude=.HFS* /mnt/MacOS-Boot-Pen/ /mnt/MacOS-Boot-VBx 2> .$thisScriptName-MacOS-Boot.err 

./MacOS-Boot-Pen_umount.sh
./MacOS-Boot-VBx_umount.sh

