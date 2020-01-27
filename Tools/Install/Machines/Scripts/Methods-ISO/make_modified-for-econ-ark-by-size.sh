#!/bin/bash

scriptDir="$(dirname "`realpath $0`")"

if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments:"
    echo "usage: ${0##*/} MIN|MAX"
    exit 1
else
    if ( [ ! "$1" == "MIN" ] && [ ! "$1" == "MAX" ] ); then
	echo "usage: ${0##*/} MIN|MAX"
	exit 2
    fi
fi

size="$1"

myuser="econ-ark"

cmd="./start_modified-for-$myuser-make.sh"
echo "$cmd"
eval "$cmd"

cmd="./finish_modified-for-$myuser-make-by-size.sh $size"
echo "$cmd"
eval "$cmd"

econarktools="/home/$myuser/GitHub/econ-ark/econ-ark-tools"
ISOmaker="Virtual/Machine/VirtualBox/ISO-maker"
cp -af "$scriptDir/start_modified-for-$myuser.sh"  "$econarktools/$ISOmaker/start.sh"
echo cp -af "$scriptDir/start_modified-for-$myuser.sh"  "$econarktools/$ISOmaker/start.sh"

cp -af "$scriptDir/finish_modified-for-$myuser.sh" "$econarktools/$ISOmaker/finish.sh"
cp -af "$scriptDir/finish_modified-for-$myuser.sh" "$econarktools/$ISOmaker/finish-$size.sh"
echo cp -af "$scriptDir/finish_modified-for-$myuser.sh" "$econarktools/$ISOmaker/finish.sh"

cp -af "ks.cfg" "$econarktools/$ISOmaker"
cp -af "rc.local" "$econarktools/$ISOmaker"
cp -af "econ-ark.seed" "$econarktools/$ISOmaker"
mkdir -p  "$econarktools/$ISOmaker/root"
rsync -avr "$scriptDir/root/" "$econarktools/$ISOmaker/root"
cp -af "$scriptDir/../Methods-ISO-make/ubuntu-desktop-unattended-installation/create-unattended-iso_Econ-ARK-by-size.sh" "$econarktools/$ISOmaker"
cd "$econarktools/$ISOmaker"

rpl -Rf "_modified-for-econ-ark.sh" ".sh" *

rpl -f 'https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO' "https://raw.githubusercontent.com/econ-ark/econ-ark-tools/master/$ISOmaker" *
rpl -vf 'iso_done="/media/sf_VirtualBox/ISO-made/methods"' 'iso_done="/media/sf_VirtualBox/ISO-made/econ-ark-tools"'  * 

cmd="cd $scriptDir ; git add . ; git commit -m 'Autoupdate start files' ; git push ; cd $econarktools/$ISOmaker ; cp finish.sh finish-$size.sh ; git add . ; git commit -m 'Autoupdate start files' ; git push ; sudo ./create-unattended-iso_Econ-ARK-by-size.sh $size"
echo ""
echo "To create the machine, execute the commands below, which should be on the clipboard:"
echo ""
echo "$cmd" | xsel -b
echo "$cmd" 

