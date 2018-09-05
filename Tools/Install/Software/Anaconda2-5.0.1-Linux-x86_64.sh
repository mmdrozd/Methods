#!/bin/bash
# This script should be given the name of the version of Anaconda you want to install from https://repo.continuum.io/archive/

scriptName="$(basename $0)"

cd /tmp
# Install as root user 
sudo curl -O https://repo.continuum.io/archive/$scriptName

# shaResult=`sha256sum "$scriptName"`
                     
# echo You will know that Anaconda is uncorrupted if the shaResult below matches the correct SHA at https://docs.anaconda.com/anaconda/install/hashes/
# echo $shaResult
# echo '' 
# echo Hit return when you have checked that the downloaded file is uncorrupted
# read answer

sudo bash /tmp/$scriptName -b -u -p /usr/local/anaconda2

