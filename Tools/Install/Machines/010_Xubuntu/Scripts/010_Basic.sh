#!/bin/bash

cd "$(dirname "$0")"

# Links that will allow compatibility of scripts across systems

./010_Basic_Make-Root-Links.sh
./010_Basic_Make-User-Links.sh
./010_Basic_Config.sh

# Distinction between software and packages is somewhat arbitrary
# One distinction is to designate as packages things that can be installed without configuration
./010_Basic_Get-Packages.sh 
./010_Basic_Get-Software.sh 


