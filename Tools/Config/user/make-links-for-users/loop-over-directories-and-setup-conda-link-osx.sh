#!/bin/bash

# .condarc defines, among other things, the default packagees included when a new environment is created

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
	if [ ! -e /$Users/$d/.condarc ]; then # if that user does not already have a .condarc file, then link them to the standard one
	    sudo -u $d ln -fs  /Volumes/Sync/Lib/config/bash/dotcondarc-$OS /$Users/$d/.condarc
	    echo sudo chown $USER /$Users/$d/.condarc
	    sudo chown $USER /$Users/$d/.condarc
	    sudo chmod a+rx /$Users/$d/.condarc
	else # the user DOES already have a .condarc file; test whether it's the standard one
	    if [[ -L "/$Users/$d/.condarc" ]] && [[ "$(realpath /$Users/$d/.condarc)" == "$(realpath /Volumes/Sync/Lib/config/bash/dotcondarc-$OS)" ]]; then
		echo '.condarc is already linked to '$(realpath /Volumes/Sync/Lib/config/bash/dotcondarc-$OS)
	    else
		echo ''
		echo /$Users/$d/.condarc is not identical to the standard one.  Here it is:
		echo ''
		ls /$Users/$d/.condarc
		#		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotcondarc-$OS-setup /$Users/$d/.condarc 
		#		echo sudo -u $d diff --side-by-side  /Volumes/Sync/Lib/config/bash/dotcondarc-$OS-setup /$Users/$d/.condarc | pbcopy
		if [ $quietly == "false" ]; then
		    echo 'Hit any key to replace the nonstandard .condarc file.  If you do NOT want to replace it, abort here.'
		    read answer
		fi
		sudo chmod a+w /$Users/$d/.condarc
		sudo rm -Rf    /$Users/$d/.condarc
		sudo ln -fs /Volumes/Sync/Lib/config/bash/dotcondarc-$OS /$Users/$d/.condarc
	      	sudo chown $USER /$Users/$d/.condarc
	    fi # the existing file is a duplicate of the default file, so do nothing
	fi # Finished if-then about whether .condarc file exists
    fi # If the user does not exist, do nothing
done

