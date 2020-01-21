#!/bin/bash

scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"

myuser="econ-ark"

sudo "./start_modified-for-$myuser-make.sh"
sudo "./finish_modified-for-$myuser-make.sh"

econarktools="/Volumes/Data/Code/ARK/econ-ark-tools/"
ISOmaker="Virtual/Machine/VirtualBox/ISO-maker"
ditto "$scriptDir/start_modified-for-$myuser.sh"  "$econarktools/$ISOmaker/start.sh"
ditto "$scriptDir/finish_modified-for-$myuser.sh" "$econarktools/$ISOmaker/finish.sh"

ditto "ks.cfg" "$econarktools/$ISOmaker"
ditto "rc.local" "$econarktools/$ISOmaker"
ditto "econ-ark.seed" "$econarktools/$ISOmaker"
mkdir -p  "$econarktools/$ISOmaker/root"
rsync -avr "$scriptDir/root/" "$econarktools/$ISOmaker/root"
ditto "$scriptDir/../Methods-ISO-make/ubuntu-desktop-unattended-installation/create-unattended-iso_Econ-ARK.sh" "$econarktools/$ISOmaker"
cd "$econarktools/$ISOmaker"
rpl -Rf "_modified-for-econ-ark.sh" ".sh" *

rpl -f 'https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO' "https://raw.githubusercontent.com/econ-ark/econ-ark-tools/master/$ISOmaker" *
rpl -f 'iso_done="/media/sf_VirtualBox"' 'iso_done="/Volumes/Data/Code/ARK/econ-ark-tools/Virtual/Machine/VirtualBox/VM-Ready-To-Install/ISO-Included-In-Folder"'  * 
