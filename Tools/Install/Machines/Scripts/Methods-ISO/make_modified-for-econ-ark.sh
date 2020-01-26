#!/bin/bash

scriptDir="$(dirname "`realpath $0`")"

# scriptDir=/home/econ-ark/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Machines/Scripts/Methods-ISO
cd "$scriptDir"

myuser="econ-ark"

sudo "./start_modified-for-$myuser-make.sh"
sudo "./finish_modified-for-$myuser-make.sh"

econarktools="/home/$myuser/GitHub/econ-ark/econ-ark-tools"
ISOmaker="Virtual/Machine/VirtualBox/ISO-maker"
cp -af "$scriptDir/start_modified-for-$myuser.sh"  "$econarktools/$ISOmaker/start.sh"
echo cp -af "$scriptDir/start_modified-for-$myuser.sh"  "$econarktools/$ISOmaker/start.sh"

cp -af "$scriptDir/finish_modified-for-$myuser.sh" "$econarktools/$ISOmaker/finish.sh"
echo cp -af "$scriptDir/finish_modified-for-$myuser.sh" "$econarktools/$ISOmaker/finish.sh"

cp -af "ks.cfg" "$econarktools/$ISOmaker"
cp -af "rc.local" "$econarktools/$ISOmaker"
cp -af "econ-ark.seed" "$econarktools/$ISOmaker"
mkdir -p  "$econarktools/$ISOmaker/root"
rsync -avr "$scriptDir/root/" "$econarktools/$ISOmaker/root"
cp -af "$scriptDir/../Methods-ISO-make/ubuntu-desktop-unattended-installation/create-unattended-iso_Econ-ARK.sh" "$econarktools/$ISOmaker"
cd "$econarktools/$ISOmaker"
rpl -Rf "_modified-for-econ-ark.sh" ".sh" *

rpl -f 'https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO' "https://raw.githubusercontent.com/econ-ark/econ-ark-tools/master/$ISOmaker" *
rpl -vf 'iso_done="/media/sf_VirtualBox"' 'iso_done="/usr/local/share/data/drive.google.com/econ-ark@jhuecon.org/Resources/Virtual/Machine"'  * 
