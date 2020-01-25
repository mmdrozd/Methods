#!/bin/bash

scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"

myuser="econ-ark"

sudo "./start_modified-for-$myuser-make.sh"
sudo "./finish_modified-for-$myuser-make.sh"

econarktools="/home/econ-ark/GitHub/econ-ark/econ-ark-tools/"
ISOmaker="Virtual/Machine/VirtualBox/ISO-maker"
cp -a "$scriptDir/start_modified-for-$myuser.sh"  "$econarktools/$ISOmaker/start.sh"
echo cp -a "$scriptDir/start_modified-for-$myuser.sh"  "$econarktools/$ISOmaker/start.sh"
cp -a "$scriptDir/finish_modified-for-$myuser.sh" "$econarktools/$ISOmaker/finish.sh"

cp -a "ks.cfg" "$econarktools/$ISOmaker"
cp -a "rc.local" "$econarktools/$ISOmaker"
cp -a "econ-ark.seed" "$econarktools/$ISOmaker"
mkdir -p  "$econarktools/$ISOmaker/root"
rsync -avr "$scriptDir/root/" "$econarktools/$ISOmaker/root"
cp -a "$scriptDir/../Methods-ISO-make/ubuntu-desktop-unattended-installation/create-unattended-iso_Econ-ARK.sh" "$econarktools/$ISOmaker"
cd "$econarktools/$ISOmaker"
rpl -Rf "_modified-for-econ-ark.sh" ".sh" *

rpl -f 'https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO' "https://raw.githubusercontent.com/econ-ark/econ-ark-tools/master/$ISOmaker" *
rpl -vf 'iso_done="/media/sf_VirtualBox"' 'iso_done="/usr/local/share/data/drive.google.com/econ-ark@jhuecon.org/Resources/Virtual/Machine"'  * 
