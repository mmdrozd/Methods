#!/usr/bin/env bash
# Addapted from netson github create-unattended/create-unattended-iso.sh

pathToScript=$(dirname `realpath "$0"`)
# pathToScript=/media/sf_VirtualBox/OSBOXES-From/ubuntu-unattended-install-options/ubuntu-desktop-unattended-installation/
methodsURL=https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO
startFile="start_modified-for-methods.sh"
seed_file="methods.seed"
ks_file=ks.cfg
rclocal_file=rc.local

# file names & paths
#tmp="/media/sf_VirtualBox"  # destination folder to store the final iso file
tmp="$HOME"  # destination folder to store the final iso file
rm -f "$tmp/$ks_file" # Make sure new version is downloaded
rm -f "$tmp/$seed_file" # Make sure new version is downloaded
rm -f "$tmp/$startFile" # Make sure new version is downloaded
rm -f "$tmp/$rclocal_file" # Make sure new version is downloaded

hostname="ubuntu"
currentuser="$( whoami)"

# define spinner function for slow tasks
# courtesy of http://fitnr.com/showing-a-bash-spinner.html
spinner()
{
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# define download function
# courtesy of http://fitnr.com/showing-file-download-progress-using-wget.html
download()
{
    local url=$1
    echo -n "    "
    wget --progress=dot $url 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo " DONE"
}

# define function to check if program is installed
# courtesy of https://gist.github.com/JamieMason/4761049
function program_is_installed {
    # set to 1 initially
    local return_=1
    # set to 0 if not found
    type $1 >/dev/null 2>&1 || { local return_=0; }
    # return value
    echo $return_
}

# print a pretty header
echo
echo " +---------------------------------------------------+"
echo " |            UNATTENDED UBUNTU ISO MAKER            |"
echo " +---------------------------------------------------+"
echo

# ask if script runs without sudo or root priveleges
if [ $currentuser != "root" ]; then
    echo " you need sudo privileges to run this script, or run it as root"
    exit 1
fi

#check that we are in ubuntu 16.04+

case "$(lsb_release -rs)" in
    16*|18*) ub1604="yes" ;;
    *) ub1604="" ;;
esac

#get the latest versions of Ubuntu LTS

tmphtml=$tmp/tmphtml
rm $tmphtml >/dev/null 2>&1
wget -O $tmphtml 'http://releases.ubuntu.com/' >/dev/null 2>&1

prec=$(fgrep Precise $tmphtml | head -1 | awk '{print $3}' | sed 's/href=\"//; s/\/\"//')
trus=$(fgrep Trusty $tmphtml | head -1 | awk '{print $3}' | sed 's/href=\"//; s/\/\"//')
xenn=$(fgrep Xenial $tmphtml | head -1 | awk '{print $3}' | sed 's/href=\"//; s/\/\"//')
bion=$(fgrep Bionic $tmphtml | head -1 | awk '{print $3}' | sed 's/href=\"//; s/\/\"//')
prec_vers=$(fgrep Precise $tmphtml | head -1 | awk '{print $6}')
trus_vers=$(fgrep Trusty $tmphtml | head -1 | awk '{print $6}')
xenn_vers=$(fgrep Xenial $tmphtml | head -1 | awk '{print $6}')
bion_vers=$(fgrep Bionic $tmphtml | head -1 | awk '{print $6}')

datestr=`date +"%Y%m%d"`
name='methods'

# ask whether to include vmware tools or not
while true; do
    echo " which ubuntu edition would you like to remaster:"
    echo
    echo "  [1] Ubuntu $prec LTS Server amd64 - Precise Pangolin"
    echo "  [2] Ubuntu $trus LTS Server amd64 - Trusty Tahr"
    echo "  [3] Ubuntu $xenn LTS Server amd64 - Xenial Xerus"
    echo "  [4] Ubuntu $bion LTS Server amd64 - Bionic Beaver"
    echo
    read -ep " please enter your preference: [1|2|3|4]: " -i "4" ubver
    case $ubver in
        [1]* )  download_file="ubuntu-$prec_vers-server-amd64.iso"           # filename of the iso to be downloaded
                download_location="http://releases.ubuntu.com/$prec/"     # location of the file to be downloaded
                new_iso_name="ubuntu-$prec_vers-server-amd64-unattended_$name-$datestr.iso" # filename of the new iso file to be created
                break;;
	[2]* )  download_file="ubuntu-$trus_vers-server-amd64.iso"             # filename of the iso to be downloaded
                download_location="http://releases.ubuntu.com/$trus/"     # location of the file to be downloaded
                new_iso_name="ubuntu-$trus_vers-server-amd64-unattended_$name-$datestr.iso"   # filename of the new iso file to be created
                break;;
        [3]* )  download_file="ubuntu-$xenn_vers-server-amd64.iso"
                download_location="http://releases.ubuntu.com/$xenn/"
                new_iso_name="ubuntu-$xenn_vers-server-amd64-unattended_$name-$datestr.iso"
                break;;
        [4]* )  download_file="ubuntu-$bion_vers-server-amd64.iso"
                download_location="http://cdimage.ubuntu.com/releases/$bion/release/"
                new_iso_name="ubuntu-$bion_vers-server-amd64-unattended_$name-$datestr.iso"
                break;;
        * ) echo " please answer [1], [2], [3] or [4]";;
    esac
done

if [ -f /etc/timezone ]; then
  timezone=`cat /etc/timezone`
elif [ -h /etc/localtime ]; then
  timezone=`readlink /etc/localtime | sed "s/\/usr\/share\/zoneinfo\///"`
else
  checksum=`md5sum /etc/localtime | cut -d' ' -f1`
  timezone=`find /usr/share/zoneinfo/ -type f -exec md5sum {} \; | grep "^$checksum" | sed "s/.*\/usr\/share\/zoneinfo\///" | head -n 1`
fi

# ask the user questions about his/her preferences
read -ep " please enter your preferred timezone: " -i "${timezone}" timezone
read -ep " please enter your preferred username: " -i "methods" username
read -ep " please enter your preferred password: " -i "Ely78Jhu!" password
printf "\n"
read -ep " confirm your preferred password: " -i "Ely78Jhu!" password2
printf "\n"
read -ep " Make ISO bootable via USB: " -i "yes" bootable

# check if the passwords match to prevent headaches
if [[ "$password" != "$password2" ]]; then
    echo " your passwords do not match; please restart the script and try again"
    echo
    exit
fi

# download the ubuntu iso. If it already exists, do not delete in the end.
cd $tmp
if [[ ! -f $tmp/$download_file ]]; then
    echo -n " downloading $download_file: "
    download "$download_location$download_file"
fi
if [[ ! -f $tmp/$download_file ]]; then
	echo "Error: Failed to download ISO: $download_location$download_file"
	echo "This file may have moved or may no longer exist."
	echo
	echo "You can download it manually and move it to $tmp/$download_file"
	echo "Then run this script again."
	exit 1
fi

# download rc.local file
if [[ ! -f $tmp/$rclocal_file ]]; then
    echo -n " downloading $rclocal_file: "
    download "$methodsURL/$rclocal_file"
fi

# download methods seed file
if [[ ! -f $tmp/$seed_file ]]; then
    echo -n " downloading $seed_file: "
    download "$methodsURL/$seed_file"
fi

# download kickstart file
if [[ ! -f $tmp/$ks_file ]]; then
    echo -n " downloading $ks_file: "
    download "$methodsURL/$ks_file"
fi

# install required packages
echo " installing required packages"
if [ $(program_is_installed "mkpasswd") -eq 0 ] || [ $(program_is_installed "mkisofs") -eq 0 ]; then
    (apt-get -y update > /dev/null 2>&1) &
    spinner $!
    (apt-get -y install whois genisoimage > /dev/null 2>&1) &
    spinner $!
fi
if [[ $bootable == "yes" ]] || [[ $bootable == "y" ]]; then
    if [ $(program_is_installed "isohybrid") -eq 0 ]; then
      #16.04
      if [[ $ub1604 == "yes" || $(lsb_release -cs) == "artful" ]]; then
        (apt-get -y install syslinux syslinux-utils > /dev/null 2>&1) &
        spinner $!
      else
        (apt-get -y install syslinux > /dev/null 2>&1) &
        spinner $!
      fi
    fi
fi


# create working folders
echo " remastering your iso file"
mkdir -p $tmp
mkdir -p $tmp/iso_org
mkdir -p $tmp/iso_new

# mount the image
if grep -qs $tmp/iso_org /proc/mounts ; then
    echo " image is already mounted, continue"
else
    (mount -o loop $tmp/$download_file $tmp/iso_org > /dev/null 2>&1)
fi

# copy the iso contents to the working directory
(cp -rT $tmp/iso_org $tmp/iso_new > /dev/null 2>&1) &
spinner $!

# set the language for the installation menu
cd $tmp/iso_new
#doesn't work for 16.04
echo en > $tmp/iso_new/isolinux/lang

#16.04
#taken from https://github.com/fries/prepare-ubuntu-unattended-install-iso/blob/master/make.sh
sed -i -r 's/timeout\s+[0-9]+/timeout 1/g' $tmp/iso_new/isolinux/isolinux.cfg


# set late command

#   late_command="chroot /target curl -L -o /home/$username/start.sh $methodsURL/$startFile ;\
#     chroot /target chmod +x /home/$username/start.sh ;"

# late_command="chroot /target curl -L -o /var/local/$startFile $methodsURL/$startFile ;\
#      chroot /target curl -L -o /etc/rc.local $methodsURL/$rclocal_file ;\
#      chroot /target chmod +x /var/local/$startFile ;\
#      chroot /target chmod +x /etc/rc.local ;\
#      mkdir -p /etc/systemd/system/keyboard-setup.service.d ;\
#      echo '[Service]' > /etc/systemd/system/keyboard-setup.service.d/reduce-timeout.conf ;\
#      echo 'TimeoutStartSec=1000' >> /etc/systemd/system/keyboard-setup.service.d/reduce-timeout.conf ;"

late_command="chroot /target curl -L -o /var/local/$startFile $methodsURL/$startFile ;\
     chroot /target curl -L -o /etc/rc.local $methodsURL/$rclocal_file ;\
     chroot /target chmod +x /var/local/$startFile ;\
     chroot /target chmod +x /etc/rc.local ;\
     mkdir -p /etc/lightdm/lightdm.conf.d ;\
     chroot /target curl -L -o /etc/lightdm/lightdm.conf.d/autologin-methods.conf $methodsURL/root/etc/lightdm/lightdm.conf.d/autologin-methods.conf ;\
     chroot /target chmod 755 /etc/lightdm/lightdm.conf.d/autologin-methods.conf ;"

# copy the methods seed file to the iso
cp -rT $tmp/$seed_file $tmp/iso_new/preseed/$seed_file

# copy the kickstart file to the root
cp -rT $tmp/$ks_file $tmp/iso_new/$ks_file
chmod 744 $tmp/iso_new/$ks_file

# include firstrun script
echo "
# setup firstrun script
d-i preseed/late_command                                    string      $late_command" >> $tmp/iso_new/preseed/$seed_file

# generate the password hash
pwhash=$(echo $password | mkpasswd -s -m sha-512)

# update the seed file to reflect the users' choices
# the normal separator for sed is /, but both the password and the timezone may contain it
# so instead, I am using @
sed -i "s@{{username}}@$username@g" $tmp/iso_new/preseed/$seed_file
sed -i "s@{{pwhash}}@$pwhash@g" $tmp/iso_new/preseed/$seed_file
sed -i "s@{{hostname}}@$hostname@g" $tmp/iso_new/preseed/$seed_file
sed -i "s@{{timezone}}@$timezone@g" $tmp/iso_new/preseed/$seed_file

# calculate checksum for seed file
seed_checksum=$(md5sum $tmp/iso_new/preseed/$seed_file)

# add the autoinstall option to the menu
sed -i "/label install/ilabel autoinstall\n\
  menu label ^Autoinstall Methods Ubuntu Server\n\
  kernel /install/vmlinuz\n\
  append file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz DEBCONF_DEBUG=5 auto=true priority=high preseed/file=/cdrom/preseed/methods.seed preseed/file/checksum=$seed_checksum -- ks=cdrom:/ks.cfg " $tmp/iso_new/isolinux/txt.cfg
  
# add the autoinstall option to the menu for USB Boot
sed -i '/set timeout=30/amenuentry "Autoinstall Methods Ubuntu Server" {\n\	set gfxpayload=keep\n\	linux /install/vmlinuz append file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz auto=true priority=high preseed/file=/cdrom/preseed/methods.seed quiet ---\n\	initrd	/install/initrd.gz\n\}' $tmp/iso_new/boot/grub/grub.cfg
sed -i -r 's/timeout=[0-9]+/timeout=1/g' $tmp/iso_new/boot/grub/grub.cfg

echo " creating the remastered iso"
cd $tmp/iso_new
# echo 'Hit C-C to quit'
# read answer
pwd
cmd="(mkisofs -D -r -V "METHODS_UBUNTU" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $tmp/$new_iso_name . > /dev/null 2>&1) &"
echo "$cmd"
(mkisofs -D -r -V "METHODS_UBUNTU" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $tmp/$new_iso_name . > /dev/null 2>&1) &
spinner $!

# make iso bootable (for dd'ing to  USB stick)
if [[ $bootable == "yes" ]] || [[ $bootable == "y" ]]; then
    isohybrid $tmp/$new_iso_name
fi

# print info to user
echo " -----"
echo " finished remastering your ubuntu iso file"
echo " the new file is located at: $tmp/$new_iso_name"
echo " your username is: $username"
echo " your password is: $password"
echo " your hostname is: $hostname"
echo " your timezone is: $timezone"
echo

cmd="mv $tmp/$new_iso_name /media/sf_VirtualBox/$new_iso_name"
echo "$cmd"
mv $tmp/$new_iso_name /media/sf_VirtualBox/$new_iso_name
exit

# cleanup
umount $tmp/iso_org
rm -rf $tmp/iso_new
rm -rf $tmp/iso_org
rm -rf $tmphtml

# unset vars
unset username
unset password
unset hostname
unset timezone
unset pwhash
unset download_file
unset download_location
unset new_iso_name
unset tmp
unset seed_file
