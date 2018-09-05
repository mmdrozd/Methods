#!/bin/bash

# If quietly is true the user will not be prompted to make decisions
quietly=false

# For parallelism between OS X and Linux scripts, define $Users and $OS shell variables
Users=Users
OS=osx

# Establish sudo permissions

echo 'If necessary, enter sudo pasasword:'
echo ls /$Users > /dev/null
sudo ls /$Users > /dev/null
echo ''

# See http://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.hmtl for bash startup order
cd /$Users

for d in * ; do
    # If there is a user corresponding to the directory name
    if id -u $d > /dev/null 2>&1; then # if the user exists
	if [ ! -e /$Users/$d/.conda ]; then # if that user does not already have a .conda file, then link them to the standard one
	    sudo -u $d ln -fs  /Volumes/Sync/Lib/config/bash/dotconda-$OS /$Users/$d/.conda
	    echo sudo chown $USER /$Users/$d/.conda
	    sudo chown $USER /$Users/$d/.conda
	    sudo chmod a+rx /$Users/$d/.conda
	else # the user DOES already have a .conda file; test whether it's the standard one
	    if [[ -L "/$Users/$d/.conda" ]] && [[ "$(realpath /$Users/$d/.conda)" == "$(realpath /Volumes/Sync/Lib/config/bash/dotconda-$OS)" ]]; then
		echo '.conda is already linked to '$(realpath /Volumes/Sync/Lib/config/bash/dotconda-$OS)
	    else
		echo ''
		echo /$Users/$d/.conda is not identical to the standard one.  Here it is:
		echo ''
		ls /$Users/$d/.conda
		#		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotconda-$OS-setup /$Users/$d/.conda 
		#		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotconda-$OS-setup /$Users/$d/.conda | pbcopy
		if [ $quietly == "false" ]; then
		    echo 'Hit any key to replace the nonstandard .conda file.  If you do NOT want to replace it, abort here.'
		    read answer
		fi
		sudo chmod a+w /$Users/$d/.conda
		sudo rm -Rf    /$Users/$d/.conda
		sudo ln -fs /Volumes/Sync/Lib/config/bash/dotconda-$OS /$Users/$d/.conda
	      	sudo chown $USER /$Users/$d/.conda
	    fi # the existing file is a duplicate of the default file, so do nothing
	fi # Finished if-then about whether .conda file exists
    fi # If the user does not exist, do nothing
done

