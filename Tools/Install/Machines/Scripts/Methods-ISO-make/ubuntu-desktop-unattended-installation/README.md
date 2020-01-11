http://gyk.lt/ubuntu-16-04-desktop-unattended-installation/

This requires several steps to be taken by hand:

1. Create a new Ubuntu VM
   1. Clone an image from OSBOXES.com:
   * `VBoxManage clonevdi "[path to]/Xubuntu 18.04.3 (64bit).vdi" "[path to]/Xubuntu_18p04p3_64bit_clone.vdi"`
   1. Create a new machine in VirtualBox and attach the cloned image
   1. Attach the VirtualBox Guest Additions (from the Mac VirtualBox menu, or Machine/Settings)
   1. Boot the virtual machine
   1. Install the VirtualBox Guest Additions
   1. Add the user to the vboxsf group:
   `sudo adduser osboxes vboxsf`
   1. On the Mac, Machine/Settings/Shared Folders, share `/Users/Shared/VirtualBox`
   * Choose to mount permanently
   * Do NOT specify a mount point -- it will be chosen automatically
   * Reboot, and the folder should now be shared
1. Install kickstart on the creator machine:
   * `sudo apt -y install system-config-kickstart`
1. Downloading the ISO (to /media/sf_VirtualBox folder that has been shared with host Mac system via VirtualBox/Machine)
1. Mounting the iso:
   cd /media/sf_VirtualBox/ISOs
   mkdir /mnt/ubuntu_iso
   sudo mount -r -o loop ubuntu-16.04.1-server-amd64.iso /mnt/ubuntu_iso
1. Make ubuntu files:
   cd /tmp
   mkdir ubuntu_files
   sudo chown methods:methods ubuntu_files
   sudo chown 755 ubuntu_files
   sudo umount /mnt/ubuntu_iso
   rm -rf /mnt/ubuntu_iso
1. Copy config files to ubuntu_files:
   cp {ks.cfg,ubuntu-auto.seed,post.sh} ubuntu_files
   cd ubuntu_files
   chmod 644 ks.cfg ubuntu-auto.seed
   chmod 744 post.sh
   chmod 755 isolinux isolinux/txt.cfg isolinux/isolinux.cfg
   
   
