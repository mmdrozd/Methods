#!/bin/bash

# set defaults
default_hostname="$(hostname)"
default_domain=""

# define download function
# courtesy of http://fitnr.com/showing-file-download-progress-using-wget.html
download()
{
    local url=$1
#    echo -n "    "
    wget --progress=dot $url 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
#    echo -ne "\b\b\b\b"
#    echo " DONE"
}

tmp="/tmp"

myuser="econ-ark"

# Change the name of the host to the date and time of its creation
datetime="$(date +%Y%m%d%H%S)"
sed -i "s/xubuntu/$datetime/g" /etc/hostname
sed -i "s/xubuntu/$datetime/g" /etc/hosts

cd /home/"$myuser"

# Remove the linux automatically created directories like "Music" and "Pictures"
for d in ./*/; do
    rm -Rf $d
done

# Add stuff to bash login script
bashadd=/home/"$myuser"/.bash_aliases
touch "$bashadd"
echo '' >> "$bashadd"

# On first boot, monitor progress of start install script
echo '[[ ! -f /var/log/firstboot.log ]] && xfce4-terminal -e "tail -f /var/local/start.log"  # On first boot, watch the remaining installations' >> "$bashadd"

# Modify prompt to keep track of git branches
echo 'parse_git_branch() {' >> "$bashadd"
echo "	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'" >> "$bashadd"
echo '}' >> "$bashadd"
echo 'export PS1="\u@\h:\W\[\033[32m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "' >>"$bashadd"

# Make ~/.bash_aliases be owned by "$myuser" instead of root
chmod a+x "$bashadd"
chown $myuser:$myuser "$bashadd"


# Create .emacs.d directory with proper permissions -- avoids annoying startup warning msg
cd    /home/$myuser
download "https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Config/tool/emacs/dot/emacs-ubuntu-virtualbox"
mv emacs-ubuntu-virtualbox ~/.emacs
chmod a+x ~/.emacs

mkdir /home/$myuser/.emacs.d

echo -n "downloading .emacs file"


chmod a+rw /home/$myuser/.emacs.d
chown $myuser:$myuser /home/$myuser/.emacs.d

# Get some key apps that should be available immediately 
sudo apt -y install curl wget tigervnc-scraping-server

# Give econ-ark
sudo adduser "$myuser" vboxsf
