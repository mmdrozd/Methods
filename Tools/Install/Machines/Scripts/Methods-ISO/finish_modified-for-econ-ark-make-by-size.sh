#!/bin/bash

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

scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"
echo ''
myuser="econ-ark"
finish="finish_modified-for-$myuser.sh"
rm "$finish"
touch "$finish"
sudo chmod a+rxw "$finish"

echo '#!/bin/bash' > "$finish"

echo '# Set username'  >> "$finish"
echo "myuser=$myuser"  >> "$finish"

echo '# The cups service sometimes gets stuck; stop it before that happens' >> "$finish"
echo 'sudo systemctl stop cups-browsed.service '   >> "$finish"
echo 'sudo systemctl disable cups-browsed.service' >> "$finish"

echo '# Update everything ' >> "$finish"

echo 'sudo apt -y update && sudo apt -y upgrade' >> "$finish"

if [ "$size" == "MAX" ]; then
    echo '# Extra packages for MAX' >> "$finish"
    cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages/Anaconda3-Latest.sh | fgrep -v "!/bin/bash" >> "$finish"
else # Install stuff needed if anaconda is not there; https://liunxize.com/post/how-to-installpy-thon-3-8-on-ubuntu-18-04
    echo 'sudo add-apt-repository -y ppa:deadsnakes/ppa' >> "$finish"
    echo 'sudo apt -y install software-properties-common python3 python3-pip python-pytest' >> "$finish"
    echo 'sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10' >> "$finish"
    echo 'sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10' >> "$finish"
    echo 'sudo apt -y python-pytest' >> "$finish"    
fi    

echo '# Get default packages for Econ-ARK machine' >> "$finish"
echo 'sudo apt -y install curl git bash-completion xsel cifs-utils openssh-server nautilus-share xclip gpg nbval' >> "$finish"

if [ "$size" == "MAX" ]; then
    echo '# Extra packages for MAX' >> "$finish"
    echo 'sudo apt -y evince texlive-full quantecon scipy' >> "$finish"
fi    

echo '# Create a public key for security purposes'     >> "$finish"
echo -n 'sudo -u $myuser ssh-keygen -t rsa -b 4096 -q -N "" -C $myuser@XUBUNTU -f /home/' >> "$finish"
echo  "$myuser/.ssh/id_rsa" >> "$finish" 

echo '# Set up security for emacs package downloading ' >> "$finish"
echo 'sudo apt -y install emacs' >> "$finish"
echo "sudo -u $myuser gpg --list-keys " >> "$finish"
echo "sudo -u $myuser gpg --homedir /home/$myuser/.emacs.d/elpa/gnupg --receive-keys 066DAFCB81E42C40" >> "$finish"

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK-MIN.sh                        | fgrep -v "#!/bin/bash"  >> "$finish"
if [[ "$size" != "MIN" ]]; then
    cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK-$size.sh                        | fgrep -v "#!/bin/bash"  >> "$finish"
fi

chown -Rf "$myuser:$myuser" /home/$myuser/GitHub

echo "sudo -u $myuser pip install jupyter_contrib_nbextensions"     >> "$finish"
echo "sudo -u $myuser jupyter contrib nbextension install --user"   >> "$finish"

if [[ "$size" == "MAX" ]]; then
    echo '# Extra nbextensions for MAX' >> "$finish"
    echo "sudo -u $myuser jupyter nbextension enable codefolding/main"  >> "$finish"
    echo "sudo -u $myuser jupyter nbextension enable codefolding/edit"  >> "$finish"
    echo "sudo -u $myuser jupyter nbextension enable toc2/main"         >> "$finish"
    echo "sudo -u $myuser jupyter nbextension enable collapsible_headings/main"  >> "$finish"
fi

echo 'cd /usr/local/share/data/GitHub/econ-ark/REMARK/binder ; pip install -r requirements.txt' >> "$finish" 

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Packages/VirtualBox-Guest-Additions.sh | fgrep -v "!/bin/bash" >> "$finish"
echo "mkdir -p /home/$myuser/GitHub ; ln -s /usr/local/share/data/GitHub/econ-ark /home/$myuser/GitHub/econ-ark" >> "$finish" 
echo "chown $myuser:$myuser /home/$myuser/GitHub" >> "$finish" 
echo "chown -Rf $myuser:$myuser /usr/local/share/data/GitHub/econ-ark # Make it be owned by econ-ark user " >> "$finish" 

echo ''                                               >> "$finish" 
echo 'echo Finished automatic installations.  Rebooting.'  >> "$finish" 
echo 'reboot ' >> "$finish" 

chmod a+x "$finish"


