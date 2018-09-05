
Replacing Your Old VM With A New One
------------------------------------

These are generic instructions that should be followed whenever there is a new VM for the class.

0. If there is anything that you want to save, the easiest way to do that is to mount a "Share" to the VirtualBox, which will let you.  Some instructions are [here](https://www.howtogeek.com/187703/how-to-access-folders-on-your-host-machine-from-an-ubuntu-virtual-machine-in-virtualbox/). You can then copy the material to the share. 

[comment]: # (This item applies only to the first time you are replacing your handmade virtual machine with the class built one; after that, all modifications you make to the machine should be in your ~/Dropbox folder and will therefore be saved online and restored when you relink)

0. The other thing you will need to do before downloading is to make sure that your storage medium has enough space. The email message with the link to the VM should specify roughly how large it is, and of course you will need plenty of empty space on your medium so that the computer can operate efficiently even after it has been downloaded.

0. You probably should create a new "group" in your VirtualBox to contain possible iterations of the machine

0. To bring it into VirtualBox, use the "Add" menu item under the "Machine" menu

0. If you have the spare disk space, you might want to "Clone" the drive before starting it.  You would then leave the original alone and work only with the clone and its descendants.

0. Launch the VM (the `start` button)

0. Pay attention to the scrolling `verbose boot` log that goes by during the boot process, in case the machine experiences any freezes or other problems in booting

0. Once the machine has booted and you have successfully logged in, you should _immediately_ log out and shut down the VM.  This is because, after the boot process, the shutdown process is the next most likely place for problems to crop up.  If you worked on the machine for a few hours, installed some software, reconfigured some things, etc, before shutting down, it would be hard to tell whether there was some problem with the machine at the outset, or whether your shutdown problem was the result of modifications you had made. (During shutdown, you should also pay attention to the log messages in case there is a hang or useful message).

0. Assuming shutdown succeeds, restart the machine and log in again as the `methods` user

0. Before you change anything, take a look at the things that you know have changed since the last version of the VM, and anything I have drawn your attention to

0. Change the hostname of the computer.  I suggest simply using your moniker or some variant thereof (like, if this were my third substantially changed VM, I might call mine `CarrollCD-3`); but in any case it shoud (1) be short; and (2) be different from the hostname anyone else in the class is likely to use.  One guide to how to change your hostname is [here](https://www.cyberciti.biz/faq/ubuntu-change-hostname-command/) but of course you will use `sudo emacs` in place of `sudo nano`

0. Once you have scrutinized the new machine sufficiently, you will need to wipe out the existing Dropbox files.  You will find in the `/home/methods/bin` folder a script named `Dropbox-Remove.sh` which will completely remove Dropbox and associated files from the VM. Run that script via:

    `~/bin/Dropbox-Remove.sh`

0. Run the installation script `~/bin/Dropbox-Install.sh` and when the Dropbox app pops up, give it the login info for your Dropbox account

0. Verify that your `/pri`,`/shr`, and `/pub` directories have been restored to `/home/methods/Dropbox,` along with the `/Methods` directory

0. That should be it!  If you have any problems, please consult the TA or the Google Group that the TA should have set up for class discussions 
