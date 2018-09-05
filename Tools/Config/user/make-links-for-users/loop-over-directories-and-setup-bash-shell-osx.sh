#!/bin/bash

# Set up identical bash shell login for all users

# If quietly is true the user will not be prompted to make decisions
quietly=false

# For parallelism between OS X and Linux scripts, define $Users and $OS shell variables
Users=Users
OS=osx

# Establish sudo permissions
echo ''
echo ls /$Users
sudo ls /$Users
echo ''

# See http://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.hmtl for bash startup order
cd /$Users
for d in * ; do
    # If there is a user corresponding to the directory name
    if id -u $d > /dev/null 2>&1; then # if the user exists
	echo "User: " $d
	if [ ! -e /$Users/$d/.bashrc ]; then # if that user does not already have a .bashrc file, then give them the standard one
	    echo sudo cp /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-setup /$Users/$d/.bashrc
	         sudo cp /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-setup /$Users/$d/.bashrc
	    echo sudo chown $d /$Users/$d/.bashrc
	         sudo chown $d /$Users/$d/.bashrc
	else # the user DOES already have a .bashrc file, so go through the merge scenario
	    if sudo diff /$Users/$d/.bashrc  /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-setup >/dev/null ; then # if the existing file is not a duplicate of the default file
		echo The /$Users/$d/.bashrc file exists, but is identical to the default.
	    else
		echo ''
		echo /$Users/$d/.bashrc is not identical to the standard one.  Here it is:
		echo ''
		cat /$Users/$d/.bashrc
		echo ''
		echo 'A diff command has been copied onto the clipboard if you want to inspect more closely.'
		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-setup /$Users/$d/.bashrc 
		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-setup /$Users/$d/.bashrc | pbcopy
		echo ''
		echo 'Hit y to add the above lines to the end of the default .bashrc file.  Any other key to replace.'
		read answer
		if [[ $answer == "y" || $answer == "Y" ]] ; then
		    sudo -u $d chmod a+w /$Users/$d/.bashrc
		    sudo -u $d cat /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-setup /$Users/$d/.bashrc > /tmp/.bashrc_merged
		    sudo cp -p /tmp/.bashrc_merged /$Users/$d/.bashrc
		    sudo chown ccarroll:admin /$Users/$d/.bashrc
		else 
		    sudo -u $d chmod a+w /$Users/$d/.bashrc
		    sudo -u $d rm        /$Users/$d/.bashrc
		    sudo cp -p  /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-setup /$Users/$d/.bashrc
		    sudo chown ccarroll:admin /$Users/$d/.bashrc
		fi
	    fi # the existing file is a duplicate of the default file, so do nothing
	fi # Finished if-then about whether .bashrc file exists
    fi # If the user does not exist, do nothing
done

for d in * ; do
    if id -u $d > /dev/null 2>&1; then             # if there is a user corresponding to the directory name
	if [ ! -e /$Users/$d/.bash_profile ]; then # if that user does not already have a .bash_profile file, then give them the standard one
	    sudo -u $d ln -fs /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS /$Users/$d/.bash_profile
	else # the user DOES already have a .bash_profile file, so go through the merge scenario
	    if sudo diff /$Users/$d/.bash_profile  /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS >/dev/null ; then # if the existing file is not a duplicate of the default file
		echo The /$Users/$d/.bash_profile file exists, but is identical to the default.
	    else
if [ $quietly == "false" ]; then
		echo ''
		echo /$Users/$d/.profile is not identical to the standard one.  Here it is:
		echo ''
		cat /$Users/$d/.profile
#		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotprofile-$OS-setup /$Users/$d/.profile 
#		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotprofile-$OS-setup /$Users/$d/.profile | pbcopy
		echo 'Hit any key to replace the nonstandard .profile file.  If you do NOT want to replace it, abort here.'
		read answer
fi
		    sudo chmod a+w /$Users/$d/.bash_profile
		    sudo rm        /$Users/$d/.bash_profile
		    sudo ln -fs /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS /$Users/$d/.bash_profile
		    chown $USER /$Users/$d/.bash_profile
	    fi # the existing file is a duplicate of the default file, so do nothing
	fi # Finished if-then about whether .bash_profile file exists
    fi # If the user does not exist, do nothing
done

for d in * ; do
    # If there is a user corresponding to the directory name
    if id -u $d > /dev/null 2>&1; then # if the user exists
	if [ ! -e /$Users/$d/.profile ]; then # if that user does not already have a .profile file, then give them the standard one
	        sudo -u $d ln -fs  /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS /$Users/$d/.profile
		echo sudo chown $USER /$Users/$d/.profile
		sudo chown $USER /$Users/$d/.profile
		sudo chmod a+rx /$Users/$d/.profile
	else # the user DOES already have a .profile file, so go through the merge scenario
	    if sudo diff /$Users/$d/.profile  /Volumes/Sync/Lib/config/bash/dotprofile-$OS >/dev/null ; then # if the existing file is not a duplicate of the default file
		echo The /$Users/$d/.profile file exists, but is identical to the default.
	    else
		echo ''
		echo /$Users/$d/.profile is not identical to the standard one.  Here it is:
		echo ''
		cat /$Users/$d/.profile
#		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotprofile-$OS-setup /$Users/$d/.profile 
#		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotprofile-$OS-setup /$Users/$d/.profile | pbcopy
if [ $quietly == "false" ]; then
		echo 'Hit any key to replace the nonstandard .profile file.  If you do NOT want to replace it, abort here.'
		read answer
fi
		    sudo chmod a+w /$Users/$d/.profile
		    sudo rm        /$Users/$d/.profile
		    sudo ln -fs /Volumes/Sync/Lib/config/bash/dotprofile-$OS /$Users/$d/.profile
	      	sudo chown $USER /$Users/$d/.profile
	    fi # the existing file is a duplicate of the default file, so do nothing
	fi # Finished if-then about whether .profile file exists
    fi # If the user does not exist, do nothing
done

