#!/bin/bash

# Set up identical bash shell login for all users

# If quietly is true the user will not be prompted to make decisions
quietly=true

# For parallelism between OS X and Linux scripts, define $Users and $OS shell variables
Users=home
OS=linux
Flavor=Ubuntu

# Establish sudo permissions
echo ''
sudo ls /$Users
echo ''

# localMount=false
# if [ -e /media/llorracc.local ]; then # We are working on a home-local machine
#     if [ ! "$(ls -A /media/llorracc.local)" ]; then # we have not mounted the llorracc.local directory
# 	echo 'llorracc.local exists but is empty -- must be mounted to proceed.  Hit return when mounted.'
# 	read answer
#     fi
#     llorraccMethPath=/media/llorracc.local/Volumes/Sync/Dropbox/OthersTo/JHU/Courses/pri/Methods
#     echo 'Mounting ' $llorraccMethPath
#     sudo rm -f /Methods
#     sudo ln -fs $llorraccMethPath /Methods
#     localMount=true
# else # it's not a local machine so Dropbox will provide the Methods directory
#     sudo rm -f /Methods # The ln command below will create /Methods/Methods if /Methods already exists; delete it to prevent
#     sudo ln -fs /home/methods/Dropbox/Methods /Methods
# fi

# See http://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.hmtl for bash startup order
cd /$Users
for d in * ; do
    # If there is a user corresponding to the directory name
    if id -u $d > /dev/null 2>&1; then # if the user exists
	echo "User: " $d
	# Ubuntu's default ~/.bashrc file sources ~/.bash_aliases, so mostly want to make our mods in ~/.bash_aliases
	# However, ~/.bashrc only sources ~/.bash_aliases AFTER a test at the beginning for whether ~/.bashrc is being sourced by a noninteractive shell
	# We want noninteractive shells to get the environment variables and other goodies in ~/.bash_aliases
	# The fix is to put the sourcing of ~/.bash_aliases BEFORE the test for non-interactivity
	# and to export BASH_ENV to ~/.bash_aliases so that even noninteractive scripts will run ~/.bash_aliases on startup
	# Sources:
	#   http://unix.stackexchange.com/questions/257571/why-does-bashrc-check-whether-the-current-shell-is-interactive
	#   https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
	dateNow=`date '+%Y%m%d-%H%Mh'`
	if [ -e /$Users/$d/.bashrc ]; then sudo mv /$Users/$d/.bashrc /$Users/$d/.bashrc_$dateNow ; fi # Archive the original
        sudo cp -p /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-$Flavor /$Users/$d/.bashrc
	sudo chmod a+r /$Users/$d/.bashrc
 	sudo cp -p /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-local              /$Users/$d/.bashrc-$OS-local
 	sudo cp -p /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-local-mount        /$Users/$d/.bashrc-$OS-local-mount
 	sudo cp -p /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-local-mount-force  /$Users/$d/.bashrc-$OS-local-mount-force
	sudo chown $d:$d /$Users/$d/.bashrc*
	sudo chmod a+r /$Users/$d/.bashrc*
	if [ ! -e /$Users/$d/.bash_aliases ]; then # if that user does not already have a .bash_aliases file, then give them the standard one
	    sudo cp /Volumes/Sync/Lib/config/bash/dotbash_aliases-$OS-$Flavor-Methods /$Users/$d/.bash_aliases
	    sudo chown $d:$d /$Users/$d/.bash_aliases
	else # the user DOES already have a .bash_aliases file, so go through the merge scenario
	    if sudo -u $d diff /$Users/$d/.bash_aliases  /Volumes/Sync/Lib/config/bash/dotbash_aliases-$OS-$Flavor-Methods >/dev/null ; then # if the existing file is not a duplicate of the default file
		[ $quietly == "false" ] && echo The /$Users/$d/.bash_aliases file exists, but is identical to the default.
		echo ''
	    else
		if [ $quietly == "false" ]; then
		    echo ''
		    echo /$Users/$d/.bash_aliases is not identical to the standard one.  Here it is:
		    echo ''
		    cat /$Users/$d/.bash_aliases
		    echo ''
		    echo 'A diff command has been copied onto the clipboard if you want to inspect more closely.'
		    echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotbash_aliases-$OS-$Flavor-Methods /$Users/$d/.bash_aliases 
#		    echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotbash_aliases-$Flavor /$Users/$d/.bash_aliases | pbcopy # pbcopy command has not been defined yet here
		    echo ''
		    echo 'Hit y to add the above lines to the end of the default .bash_aliases file.  Any other key to replace.'
		    answer="n"
		    read answer
		fi # end of block executed only if not quietly
		if [[ $answer == "y" || $answer == "Y" || $quietly == "true" ]] ; then
		    sudo chmod a+w /$Users/$d/.bash_aliases
		    sudo cat /Volumes/Sync/Lib/config/bash/dotbash_aliases-$OS-$Flavor-Methods /$Users/$d/.bash_aliases > ~/.bash_aliases_merged
		    sudo cp /Volumes/Sync/Lib/config/bash/dotbash_aliases-$OS-$Flavor-Methods /$Users/$d/.bash_aliases
		    sudo chown $d:$d /$Users/$d/.bash_aliases
		else 
		    sudo rm        /$Users/$d/.bash_aliases
		    sudo cp /Volumes/Sync/Lib/config/bash/dotbash_aliases-$OS-$Flavor-Methods /$Users/$d/.bash_aliases
		    sudo chown $d:$d /$Users/$d/.bash_aliases
		fi # the existing file is a duplicate of the default file, so do nothing
	    fi # Finished if-then about whether .bash_aliases file exists
	    if [ "$localMount" == "true" ]; then 
		sudo cat ~/.bash_aliases /Volumes/Sync/Lib/config/bash/dotbashrc-$OS-local > /tmp/.bash_aliases
		sudo cp /Volumes/Sync/Lib/config/bash/dotbash_aliases-$OS-$Flavor-Methods /$Users/$d/.bash_aliases
		sudo chown $d:$d /$Users/$d/.bash_aliases
		#		sudo sudo mv /tmp/.bash_aliases /$Users/$d/.bash_aliases
		#		sudo chown $u /$Users/$d/.bash_aliases
	    fi
        fi
    fi # If the user does not exist, do nothing
done

for d in * ; do
    if id -u $d > /dev/null 2>&1; then             # if there is a user corresponding to the directory name
	if [ ! -e /$Users/$d/.bash_profile ]; then # if that user does not already have a .bash_profile file, then give them the standard one
	    echo $d does not have a .bash_profile - giving them one
	    #	    sudo -u $d rm /$Users/$d/.bash_profile
	    if [ $d == "methods" ]; then
		sudo -u $d ln -fs  /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS /$Users/$d/.bash_profile
	    else
		sudo cp /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS /$Users/$d/.bash_profile
		sudo chown $d:$d /$Users/$d/.bash_profile
	    fi
	else # the user DOES already have a .bash_profile file, so go through the merge scenario
	    good="false"
	    if sudo -u $d test -r /$Users/$d/.bash_profile; then
		if  sudo -u $d test -r /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS ; then
		    if sudo -u $d diff /$Users/$d/.bash_profile  /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS > /dev/null ; then
			good="true"
			[ $quietly == "false" ] && echo The /$Users/$d/.bash_profile file exists, but is identical to the default.
		    fi
		fi
	    fi
	    if [ $good == "false" ]; then
		if [ $quietly == "false" ]; then
		    echo ''
		    echo /$Users/$d/.bash_profile is not identical to the standard one.  Here it is:
		    echo ''
		    cat /$Users/$d/.bash_profile
		    #		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotprofile-$OS-setup /$Users/$d/.profile 
		    #		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotprofile-$OS-setup /$Users/$d/.profile | pbcopy
		    echo 'Hit any key to replace the nonstandard .profile file.  If you do NOT want to replace it, abort here.'
		    read answer
		fi
		sudo chmod a+w /$Users/$d/.bash_profile
		sudo rm        /$Users/$d/.bash_profile
		if [ $d == "methods" ]; then
		    sudo -u $d ln -fs  /Volumes/Sync/Lib/config/bash/dotbash_profile-$OS /$Users/$d/.bash_profile
		else
		    sudo cp /Volumes/Sync/Lib/config/bash/dotbash_profile-all /$Users/$d/.bash_profile
		    sudo chown $d:$d /$Users/$d/.bash_profile
		fi
	    fi # the file is not good
	fi # Finished if-then about whether .bash_profile file exists
    fi # If the user does not exist, do nothing
done

for d in * ; do
    # If there is a user corresponding to the directory name
    if id -u $d > /dev/null 2>&1; then # if the user exists
	if [ ! -e /$Users/$d/.profile ]; then # if that user does not already have a .profile file, then give them the standard one
	    if [ $d == "methods" ]; then
 	        sudo -u $d ln -fs  /Volumes/Sync/Lib/config/bash/dotprofile-$OS /$Users/$d/.profile
	    else
		sudo cp  /Volumes/Sync/Lib/config/bash/dotprofile-all /$Users/$d/.profile
		sudo chown $d:$d /$Users/$d/.profile
	    fi
	    echo sudo chown $USER /$Users/$d/.profile
	    sudo chown $USER /$Users/$d/.profile
	    sudo chmod a+rx /$Users/$d/.profile
	else # the user DOES already have a .profile file, so go through the merge scenario
	    good="false"
	    if sudo -u $d test -r /$Users/$d/.profile; then
		if sudo -u $d test -r /Volumes/Sync/Lib/config/bash/dotprofile-$OS; then
		    if sudo -u $d diff /$Users/$d/.profile  /Volumes/Sync/Lib/config/bash/dotprofile-$OS > /dev/null ; then # if the existing file is not a duplicate of the default file
			good="true"
			[ $quietly == "false" ] && echo The /$Users/$d/.profile file exists, but is identical to the default.
		    fi
		fi
	    fi
	    if [ $good == "false" ]; then
		if [ $quietly == "false" ]; then 
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
		fi # end if quietly = false
		sudo chmod a+w /$Users/$d/.profile
		sudo rm        /$Users/$d/.profile
		if [ $d == "methods" ]; then
 	            sudo -u $d ln -fs  /Volumes/Sync/Lib/config/bash/dotprofile-$OS /$Users/$d/.profile
		else
		    sudo cp  /Volumes/Sync/Lib/config/bash/dotprofile-all /$Users/$d/.profile
 	            sudo chown $d:$d /$Users/$d/.profile
		fi # user is not methods
	    fi # file is not good
	fi # Finished if-then about whether .profile file exists
    fi # If the user does not exist, do nothing
done

