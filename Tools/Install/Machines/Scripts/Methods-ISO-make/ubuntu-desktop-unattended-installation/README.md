http://gyk.lt/ubuntu-16-04-desktop-unattended-installation/

# Steps to Create an ISO

1. Get a working [X]ubuntu VM, either by creating a new one or augmenting an existing one.
   1. To create a new Ubuntu VM
	  1. Clone an image from OSBOXES.com:
	  * `VBoxManage clonevdi "[path to]/Xubuntu 18.04.3 (64bit).vdi" "[path to]/Xubuntu_18p04p3_64bit_clone.vdi"`
	  1. Create a new machine in VirtualBox and attach the cloned image
   1. Attach the VirtualBox Guest Additions (from the Mac VirtualBox menu, or Machine/Settings)
   1. Boot the virtual machine
   1. Install the VirtualBox Guest Additions
1. On the installer-maker machine:
   1. Add the user to the vboxsf group:
   `sudo adduser $USER vboxsf`
   1. On the Mac, Machine/Settings/Shared Folders, share `/Users/Shared/VirtualBox`
   * Choose to mount permanently
   * Do NOT specify a mount point -- it will be chosen automatically as /media/sf_VirtualBox
   * Reboot, and the folder should now be shared
1. Install kickstart on the creator machine:
   * `sudo apt -y install system-config-kickstart`
1. Get the installation scripts:
   * `mkdir -p ~/GitHub/ccarrollATjhuecon; cd !$ ; git clone https://github.com/ccarrollATjhuecon/Methods.git; cd Methods/Tools/Install/Machines/Scripts/Methods-ISO*`
1. Rebuild the start script if anything in it has changed:
   * /bin/bash ./start_modified-for-econ-ark_make.sh
1. Commit any changes back to the original repo (whence they will be retrieved during install)
1. Change to the directory containing the script to build the ISO, and run it:
   `cd Methods-ISO-make/ubuntu-desktop-unattended-installation; sudo ./create-unattended-iso_Econ-ARK.sh`
1. The result should be, in /media/sf_VirtualBox, a file with a name like
   `ubuntu-18.04.3-server-amd64-unattended_econ-ark-20200119.iso`
   
# Settings to create VM from the ISO
1. Settings:General
   1. name for the machine (probably beginning with the date)
   1. Linux (64 bits)
   1. Create a new hard drive
      * Virtual
	  * 500GB
	  * VMDK
	  * Solid-State
  1. Attach the ISO to the CD-ROM drive (Storage/Controller:IDE should let you attach the ISO)
1. System
   1. 4096 MB
   1. 2 processors (or more)
1. Video
   1. 64 MB
1. Network
   1. NAT if in public; Bridge is better on own home wifi
1. Ports
   1. Select USB 1 because 2 or 3 require installation of VirtualBox Extension Pack
   
# In VirtualBox, Click "Start"
1. The script should take several hours
   1. The first step is the creation of a vanilla VM
   1. The system then reboots, and downloads the remaining items it needs
   1. The DemARK and REMARK repos are installed in /usr/local/share/GitHub/
   1. econ-ark is installed by conda 

