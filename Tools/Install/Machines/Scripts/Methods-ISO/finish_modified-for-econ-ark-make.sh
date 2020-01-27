#!/bin/bash
scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"
echo ''
myuser="econ-ark"
finish="finish_modified-for-$myuser.sh"
rm "$finish"
touch "$finish"
sudo chmod a+xw "$finish"

echo '#!/bin/bash' > "$finish"

echo '# Set username'  >> "$finish"
echo "myuser=$myuser"  >> "$finish"

echo '# Update everything ' >> "$finish"

echo 'sudo apt -y update && sudo apt -y upgrade' >> "$finish"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages/Anaconda3-Latest.sh | fgrep -v "!/bin/bash"        >> "$finish"
echo '# Get default packages for Econ-ARK machine' >> "$finish"
echo 'sudo apt -y install git bash-completion xsel cifs-utils openssh-server nautilus-share xclip texlive-full emacs gpg evince' >> "$finish"

echo '# Create a public key for security purposes'     >> "$finish"
echo -n 'sudo -u $myuser ssh-keygen -t rsa -b 4096 -q -N "" -C $myuser@XUBUNTU -f /home/' >> "$finish"
echo  "$myuser/.ssh/id_rsa" >> "$finish" 
echo '# Set up security for emacs package downloading ' >> "$finish"
echo "sudo -u $myuser gpg --list-keys " >> "$finish"
echo "sudo -u $myuser gpg --homedir /home/$myuser/.emacs.d/elpa/gnupg --receive-keys 066DAFCB81E42C40" >> "$finish"

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK.sh                        | fgrep -v "#!/bin/bash"  >> "$finish"
chown -Rf "$myuser:$myuser" /home/$myuser/GitHub

echo "sudo -u $myuser pip install jupyter_contrib_nbextensions"     >> "$finish"
echo "sudo -u $myuser jupyter contrib nbextension install --user"   >> "$finish"
echo "sudo -u $myuser jupyter nbextension enable codefolding/main"  >> "$finish"
echo "sudo -u $myuser jupyter nbextension enable codefolding/edit"  >> "$finish"
echo "sudo -u $myuser jupyter nbextension enable toc2/main"         >> "$finish"
echo "sudo -u $myuser jupyter nbextension enable collapsible_headings/main"  >> "$finish"

echo 'cd /usr/local/share/data/GitHub/econ-ark/REMARK/binder ; pip install -r requirements.txt' >> "$finish" 

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Packages/VirtualBox-Guest-Additions.sh | fgrep -v "!/bin/bash" >> "$finish"
echo "mkdir -p /home/$myuser/GitHub ; ln -s /usr/local/share/data/GitHub/econ-ark /home/$myuser/GitHub/econ-ark" >> "$finish" 
echo "chown $myuser:$myuser /home/$myuser/GitHub" >> "$finish" 
echo "chown -Rf $myuser:$myuser /usr/local/share/data/GitHub/econ-ark # Make it be owned by econ-ark user " >> "$finish" 

echo ''                                               >> "$finish" 
echo 'echo Finished automatic installations.  Rebooting.'  >> "$finish" 
echo 'reboot ' >> "$finish" 

chmod a+x "$finish"


