#!/bin/bash

# A few things to do quickly at the very beginning; the "finish" script is stuff that runs in the background for a long time 
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

# Add stuff to bash login script
bashadd=/home/"$myuser"/.bash_aliases
touch "$bashadd"

echo '# On first boot, monitor progress of start install script' >> "$bashadd"
echo 'if [[ ! -f /var/log/firstboot.log ]]; then' >> "$bashadd"
echo  '  xfce4-terminal -e "tail -f /var/local/start-and-finish.log"  # On first boot, watch the remaining installations' >> "$bashadd"
echo  'fi' >> "$bashadd"

# Modify prompt to keep track of git branches
echo 'parse_git_branch() {' >> "$bashadd"
echo "	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'" >> "$bashadd"
echo '}' >> "$bashadd"
echo 'export PS1="\u@\h:\W\[\033[32m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "' >>"$bashadd"

# Make ~/.bash_aliases be owned by "$myuser" instead of root
chmod a+x "$bashadd"
chown $myuser:$myuser "$bashadd"


# Get some key apps that should be available immediately 
sudo apt -y install tigervnc-scraping-server

# Create .emacs.d directory with proper permissions -- avoids annoying startup warning msg
cd    /home/$myuser
echo "downloading .emacs file"

download "https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Config/tool/emacs/dot/emacs-ubuntu-virtualbox"

mv emacs-ubuntu-virtualbox /home/$myuser/.emacs
chmod a+rwx /home/$myuser/.emacs
chown "$myuser:$myuser" /home/$myuser/.emacs

mkdir /home/$myuser/.emacs.d

chmod a+rw /home/$myuser/.emacs.d
chown $myuser:$myuser /home/$myuser/.emacs.d
