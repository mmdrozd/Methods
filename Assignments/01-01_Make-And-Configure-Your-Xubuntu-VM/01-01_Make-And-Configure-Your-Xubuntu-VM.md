# Create Class VM

This assignment takes you through the steps to create the `Basic` version of the Methods class virtual machine.

0. Create and configure a clean Ubuntu virtual machine in VirtualBox
    0. We are going to create essentially identical VMs for everyone
       * Only difference between them: named 'Methods-[Moniker]'  

    0. Download and install the free VirtualBox software on your laptop

    0. Using info in the `/Methods/Tools/Install/Machines/010_Xubuntu` directory:

        1. Create the VM following the steps in `/Steps/007_VirtualBox_*`

        illustrated by the first set of screenshots at

        2. `020_Installing-Xubuntu-On-VirutalBox_Illustrated`

        then configure the VM using the remainder of the Screenshots

        3. Decide which DropBox account you will link to the VM

        * You probably will want to get a "throwaway" DropBox account just for
        this class (if you have a lot of stuff in your DropBox Account that you
        do not want to sync to the VM, or do not want to change  anything in
        your personal DropBox account to follow class instructions)

        3. Then install DropBox following the final set of Screenshots
        * Connecting your online DropBox account to the VM

        * If you start by using your regular personal DropBox account and then
        decide to replace it with a throwaway account, first follow the
        instructions below for uninstalling and reinsalling DropBox

In case you need to do so, here are instructions for uninstalling and reinstalling Dropbox

Uninstalling and Reinstalling Dropbox<a name="UnDrop"></a>
-------------------------------------

0. In the Dropbox app, go to "Preferences"

0. In Preferences, go to "Account"

0. In the "Account linking" pane, select "unlink this Dropbox"

0. Go to the terminal, and delete the existing Dropbox folder using the command:

    `rm -Rf ~/Dropbox`

0. Repeat the instructions in the screenshots to reconnect to the Dropbox account
