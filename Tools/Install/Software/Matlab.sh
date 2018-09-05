#!/bin/bash
# Written 2017-05 by Shujaat Khan

cd ~/Downloads

wget "https://www.mathworks.com/supportfiles/downloads/R2017a/deployment_files/R2017a/installers/glnxa64/MCR_R2017a_glnxa64_installer.zip"

mkdir Matlab_install
unzip MCR_R2017a_glnxa64_installer.zip -d Matlab_install

cd Matlab_install

./install
