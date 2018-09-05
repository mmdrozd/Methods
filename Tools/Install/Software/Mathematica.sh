#!/bin/bash

if ! [ -z ${INSIDE_EMACS+x} ]; then
    echo You are trying to run this script inside an emacs buffer
    echo 'which is not allowed. Script will exit -- rerun in a terminal shell'
    echo ''
    exit 1
fi

# Mount a location that contains the Mathematica Linux installer

if [ -d /usr/local/Wolfram ]; then
    if [ "$(ls -A /usr/local/Wolfram)" ]; then
	echo ''
	echo 'Mathematica appears already to be installed.  Aborting.'
	echo ''
	echo 'If you want to reinstall it, delete /usr/local/Wolfram and rerun.'
	echo ''
	exit 0
    fi
else
    echo ''
    echo /usr/local/Wolfram does not exist -- continuing
    echo ''
fi

while [ ! -e /usr/local/pulse/pulseUi ]; do
    echo ''
    echo 'You must run this script while connected to the JHU VPN.'
    echo 'This requires first installing JHPulse.'
    echo 'You should be able to do this by running the script:'
    echo '/Methods/Tools/Install/JHPulse.sh'
    echo ''
    echo 'Hit return when you have done this (in another terminal)'
    echo 'or C-c to abort.'
    read answer
done

ping -c 2 -w 5 econ-nas.win.ad.jhu.edu > /dev/null # Test whether logged into campus network
pingExitCode=$?
while ! [ $pingExitCode -eq 0 ]; do
    echo 'Your machine is not able to locate the server on which the Mathematica installer is posted.'
    echo 'Hit return when you have logged into the campus network via JHPulse and confirmed that '
    echo 'econ-nas.win.ad.jhu.edu is visible.'
    echo ''
    if [ ! -e /usr/local/pulse/pulseUi ]; then
	echo ''
	echo 'JHPulse is not installed.'
        echo 'Install it using /Methods/Tools/Install/Software/JHPulse.sh and rerun this script.'
	exit 1
    fi
    echo 'Running'
    echo /usr/local/pulse/pulseUi
    /usr/local/pulse/pulseUi
    echo ''
    echo 'Hit return when you have connected to the JHU VPN'
    echo 
    read answer
    echo ''
    ping -c 2 -w 5 econ-nas.win.ad.jhu.edu > /dev/null # Test whether logged into campus network
    pingExitCode=$?
done

# Commented out version assumes the Mma installer is available locally 
# local=/media/rw.llorracc.local
# 
# if [ -d $local ]; then                              # Working on a local machine 
#     if [ "$(ls -A $local)" ]; then                  # local directory mounted
# 	echo 'Working on local machine which is already mounted.'
# 	mountPath=$local
# 	localPath=Volumes/Sync/jhpulse.johnshopkins.edu
# 	mountLocal=$mountPath/$localPath
#     else
# 	echo 'Working on local machine but not mounted; mount now.'
# 	source ~/.bashrc-linux-local-mount-force
#     fi
# else
    echo 'In order for installation to proceed, you need to mount the network drive where the installer lives.'
    echo ''
#    echo 'To do so, enter your JHU login username:'
#    read username # username=ccarrol2
#    echo ''

    mountLocal=/media
    MmaPathParentDir=econ-nas.win.ad.jhu.edu/vm
    echo ''
#    echo 'Now creating the local mount point for the remote drive.'
#    echo 'You will need to enter your password for the '$USER' user:'
    echo ''
    echo sudo mkdir -p $mountLocal/$MmaPathParentDir
    sudo mkdir -p $mountLocal/$MmaPathParentDir
    echo ''
    username='M626'
    password='C!M!Ec0n'
    domain=econ-nas
    echo 'A command like the one below should work if you are logged into the JHU VPN:'
    echo 'sudo mount -t cifs //econ-nas.win.ad.jhu.edu/vm '$mountLocal/$MmaPathParentDir' -o domain=$domain,username="$username",password=$password,vers=2.0,sec=ntlm'
    sudo mount -t cifs //econ-nas.win.ad.jhu.edu/vm $mountLocal/$MmaPathParentDir -o domain=$domain,username="$username",password=$password,vers=2.0,sec=ntlm
    echo ''
    echo 'Hit return when you have successfully executed such a command in the Terminal.'
    echo ''
    read answer
# fi 

MmaPathDir=$mountLocal/$MmaPathParentDir/Mathematica

cd $MmaPathDir
pwd
ls

countMatchingCmd='matching=`find . -name "'"*LabVersion*"'" | wc -l`'
eval $countMatchingCmd

if ! [[ "$matching" -eq "1" ]]; then
    echo The number of candidate files is different than 1.
    echo Fix and rerun this script.
    echo Aborting.
    exit 1
fi

MmaPathInstaller=`find "$MmaPathDir"/*LabVersion*`

if [ ! -e $MmaPathInstaller ]; then
    echo 'The Mathematica installer is not at '$MmaPathInstaller
    echo 'Hit return when this has been rectified and verified.'
    read answer
else
    echo ''
    echo 'Mathematica installer found at:'
    echo $MmaPathInstaller
    echo ''
    echo 'Continuing.'
fi


echo ''
echo ''

if [ ! -d ~/tmp ]; then
    mkdir ~/tmp
    sudo chmod -Rf a+rw ~/tmp
fi

echo 'The following command will install the installer to your VM ~/tmp directory.'
echo 'If the command fails, it probably is because your virtual machine ran out of disk space.'
echo '  -- In that case, quit the installer and free up about 30 gb on the host device.'
echo ''
# The -- auto argument basically tells it to go ahead and install in default manner without further input
createInstaller="sudo $MmaPathInstaller --target /var/tmp/MathematicaInstaller -- auto"
echo -n $createInstaller | pbcopy
echo 'Now running the installer by executing the command '
echo $createInstaller
echo ''
echo 'Warning: This will take a LONG time.  Be patient.'
echo ''
sudo $createInstaller
echo ''
echo ''
# echo 'When the installer has verified itself and begins running, it will ask for a default directory,just hit return to accept the default directory.'
# echo ''
# echo sudo /var/tmp/MathematicaInstaller/Unix/Installer/MathInstaller -auto
# read answer

echo ''
echo 'Next we will launch Mathematica.'
echo 'For user name put in your name'
echo 'For organization, put in JHU'
echo 'For the password, put in the password from the file below that corresponds to the version number of Mathematica you have just installed:'

cat  $MmaPathDir/*passwords-FY*.txt
echo ''
echo ''

source ~/.bashrc
sudo Mathematica &

if [ -e /var/tmp/MathematicaInstaller ]; then # It's supposed to delete this, but make sure 
    sudo rm -Rf /var/tmp/MathematicaInstaller
fi
