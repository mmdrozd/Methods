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

# See http://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.hmtl for bash startup order
cd /$Users
for d in * ; do
    # If there is a user corresponding to the directory name
    if id -u $d > /dev/null 2>&1; then # if the user exists
	echo "User: " $d
	sudo -u $d jupyter contrib nbextension install --sys.prefix
    fi # The user existed
done
