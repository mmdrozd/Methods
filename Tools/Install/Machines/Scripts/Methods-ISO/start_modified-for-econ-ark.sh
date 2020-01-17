#!/bin/bash
#!/bin/bash
# https://askubuntu.com/questions/328240/assign-vnc-password-using-script
myuser="econ-ark"
mypass="kra-noce"
echo "$mypass" >  /tmp/vncpasswd # First is the read-write password
echo "$myuser" >> /tmp/vncpasswd # Next  is the read-only  password (useful for sharing screen with students)

[[ -e /home/$myuser/.vnc ]] && rm -Rf /home/$myuser/.vnc  # If a previous version exists, delete it
mkdir /home/$myuser/.vnc

vncpasswd -f < /tmp/vncpasswd > /home/$myuser/.vnc/passwd  # Create encrypted versions

# Give the files the right permissions
chown -R $myuser:$myuser /home/$myuser/.vnc
chmod 0600 /home/$myuser/.vnc/passwd

touch /home/$myuser/.bashrc_aliases

echo '# If not already running, launch the vncserver whenever an interactive shell starts' >> /home/$myuser/.bashrc_aliases
echo 'pgrep x0vncserver'  >> /home/$myuser/.bashrc_aliases
echo '[[ $? -eq 1 ]] && x0vncserver -display :0 -PasswordFile=/home/'$myuser'/.vnc/passwd >/dev/null 2>&1 &' >> /home/$myuser/.bashrc_aliases

#!/bin/bash
# This is the start of a script will be in the /var/local directory and should be executed by root at the first boot 

finishPath=https://raw.githubusercontent.com/ccarrollATjhuecon/Methods/master/Tools/Install/Machines/Scripts/Methods-ISO/finish.sh

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

datetime="$(date +%Y%m%d%H%S)"
sed -i "s/xubuntu/$datetime/g" /etc/hostname
sed -i "s/xubuntu/$datetime/g" /etc/hosts

bashrcadd=/home/"$myuser"/.bashrc_aliases
touch "$bashrcadd"
echo '' >> "$bashrcadd"
echo '[[ ! -f /var/log/firstboot.log ]] && xfce4-terminal -e "tail -f /var/local/start.log"  # On first boot, watch the remaining installations' >> "$bashrcadd"
echo 'parse_git_branch() {' >> "$bashrcadd"
echo "	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'" >> "$bashrcadd"
echo '}' >> "$bashrcadd"
echo 'export PS1="\u@\h:\W\[\033[32m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "' >>"$bashrcadd"

mkdir /home/$myuser/.emacs.d
chmod a+rw /home/$myuser/.emacs.d
chown $myuser:$myuser /home/$myuser/.emacs.d

sudo chmod a+x /home/econ-ark/.bashrc_aliases
sudo chown econ-ark:econ-ark /home/econ-ark/.bashrc_aliases
sudo -u econ-ark xfce4-terminal --display :0 -e 'bash -c -i /home/econ-ark/.bashrc_aliases &'
sudo apt -y update && sudo apt -y upgrade
#!/bin/bash
# Adapted from http://askubuntu.com/questions/505919/how-to-install-anaconda-on-ubuntu

sudo ls  # make sure we have root permission from the outset
scriptDir="$(dirname "`realpath $0`")"

if [ -e /tmp/Anaconda ]; then # delete any prior install
    sudo rm -Rf /tmp/Anaconda
fi

mkdir /tmp/Anaconda ; cd /tmp/Anaconda

CONTREPO=https://repo.continuum.io/archive/
# Stepwise filtering of the html at $CONTREPO
# Get the topmost line that matches our requirements, extract the file name.
ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
cmd="wget -O /tmp/Anaconda/$ANACONDAURL $CONTREPO$ANACONDAURL ; cd /tmp/Anaconda"
echo "$cmd"
eval "$cmd"

cmd="sudo rm -Rf /usr/local/anaconda3 ; chmod a+x /tmp/Anaconda/$ANACONDAURL ; /tmp/Anaconda/$ANACONDAURL -b -p /usr/local/anaconda3"
echo "$cmd"
eval "$cmd"

addToPath='export PATH=/usr/local/anaconda3/bin:$PATH'
eval "$addToPath"
sudo chmod u+w /etc/environment
sudo sed -e 's\/usr/local/sbin:\/usr/local/anaconda3/bin:/usr/local/sbin:\g' /etc/environment > /tmp/environment
sudo sed -e 's\/usr/local/anaconda3/bin:/usr/local/anaconda3/bin\/usr/local/anaconda3/bin\g' /tmp/environment > /tmp/environment2 # eliminate any duplicates
sudo mv /tmp/environment2 /etc/environment # Weird permissions issue prevents direct redirect into /etc/environment
sudo chmod u-w /etc/environment

if [ ! -e /etc/sudoers.d/anaconda3 ]; then # Modify secure path so that anaconda commands will work with sudo
    sudo mkdir -p /etc/sudoers.d
    sudo echo 'Defaults secure_path="/usr/local/anaconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/snap/bin:/bin"' | sudo tee /etc/sudoers.d/anaconda3
fi

echo "$PATH"
source /etc/environment

conda update --yes conda
conda update --yes anaconda

conda install --yes -c anaconda scipy
conda install --yes -c anaconda pyopengl # Otherwise you get an error "Segmentation fault (core dumped)"

$scriptDir/Anaconda-jupyter_contrib_nbextensions.sh
#/Methods/Tools/Config/tool/jupytext/default.sh
sudo apt -y install bash-completion xsel git curl wget cifs-utils openssh-server nautilus-share xclip emacs auctex texlive-full tigervnc-scraping-server
#!/bin/bash

#Download and extract HARK, REMARK, DemARK from GitHUB repository

conda install --yes -c conda-forge econ-ark
arkHome=/usr/local/share/GitHub/econ-ark
mkdir -p "$arkHome"
cd "$arkHome"
git clone https://github.com/econ-ark/REMARK.git
git clone https://github.com/econ-ark/DemARK.git
#!/bin/bash

# https://askubuntu.com/questions/499070/install-virtualbox-guest-addition-terminal

sudo apt -y install build-essential module-assistant virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
mkdir -p /home/$myuser/GitHub/econ-ark ; ln -s /usr/local/share/GitHub/econ-ark /home/$myuser/GitHub/econ-ark
