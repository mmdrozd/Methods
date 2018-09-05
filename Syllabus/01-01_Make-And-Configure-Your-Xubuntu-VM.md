
This assignment takes you through the steps to create the `Basic` version of the Methods class virtual machine.

0. Create and configure your own clean Xubuntu virtual machine in VirtualBox

    0. Open VirtualBox and click on New. 

    0. Name the VirtualBox instance `methods-VM-[Moniker]`; for example, mine is `methods-VM-CarrollCD`

    0. For Type select Linux and on Version select Ubuntu

    0. Name the Xubuntu machine `methods-Xub-[Moniker]`

0. Startup your `methods-Xub-[Moniker]`, and create a user account for your own files

   0. Choose a full name like `Christopher Methods Carroll` or `Larry Methods Ball`

   0. Choose the username `methods` (This will be the user 1000, you can check this later in a `terminal` window via `id -u methods`)

      * Everyone will have the same username (`methods`) so that class scripts can work on your files

      * If you are tempted to create another username that is specific and private to you, don't (yet):

           * You are likely to replace your VirtualBox a number of times and anything in it would be wiped out

0. Install Dropbox per the instructions in `/Methods/Tools/Install/Machines/010_Xubuntu/Steps/020_Configure-Your-New-[x]ubuntu-system/[datetime]_Install-Dropbox_As-Herein`

    0. (If you have already installed Dropbox, please uninstall and reinstall using the instructions [here](#UnDrop))

    0. Opening a `terminal` window in `methods-Xub-[Moniker]`

    0. Starting Firefox from within your running `methods-Xub-[Moniker]` VM

    0. Logging into the course Dropbox account 

    0. Navigating to `/Methods/Tools/Install/Packages` and copying the contents of `Dropbox_x64.sh` into your `terminal` window 

    0. Paste the lines one at a time, and answer "Y" to any questions you are asked 

    0. After the second line executes, configure Dropbox with the username and password in the instructions using your individual Dropbox account that will be used for the class

    0. Allow the installation to proceed with default choices of everything else 

    0. When it is done synchronizing, verify that there is a directory named `Dropbox` in the `/home/methods` directory that contains a mirror image of the directories on the Dropbox.com website

0. Figure out how to run the bash script `Methods/Tools/Install/Machines/010_Xubuntu/Scripts/010_Basic.sh`

    * This is done in the `terminal` application.  Hints:

       0. The command to change directories is `cd`

       0. You can execute a script in the current directory using the command `/bin/bash [scriptname].sh`


Uninstalling and Reinstalling Dropbox<a name="UnDrop"></a>
-------------------------------------

0. In the Dropbox app, go to "Preferences"
   
0. In Preferences, go to "Account"

0. In the "Account linking" pane, select "unlink this Dropbox"

0. Go to the terminal, and delete the existing Dropbox folder using the command:

    `rm -Rf ~/Dropbox`

0. Repeat the instructions above to reconnect to the Dropbox account

