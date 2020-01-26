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

echo '# Update everything ' >> "$finish"
echo 'sudo apt -y update && sudo apt -y upgrade' >> "$finish"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages/Anaconda3-Latest.sh | fgrep -v "!/bin/bash"        >> "$finish"
echo '# Get default packages for Econ-ARK machine' >> "$finish"
echo 'sudo apt -y install git bash-completion xsel cifs-utils openssh-server nautilus-share xclip texlive-full emacs gpg' >> "$finish"

# Set up security for emacs package downloading 
echo "gpg --homedir /home/$myuser/.emacs.d/elpa/gnupg --receive-keys 066DAFCB81E42C40 " >> "$finish"

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK.sh                        | fgrep -v "!/bin/bash"  >> "$finish"
chown "$myuser:$myuser" /home/$myuser/GitHub
cat ~/GitHub/econ-ark/REMARK/binder/postBuild | fgrep -v "#!/bin/bash" >> "$finish"
echo 'cd /usr/local/share/data/GitHub/econ-ark/REMARK/binder ; pip install -r requirements.txt' >> "$finish" 

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Packages/VirtualBox-Guest-Additions.sh | fgrep -v "!/bin/bash" >> "$finish"
echo "mkdir -p /home/$myuser/GitHub ; ln -s /usr/local/share/GitHub/econ-ark /home/$myuser/GitHub/econ-ark" >> "$finish" 
echo "chown $myuser:$myuser /home/$myuser/GitHub" >> "$finish" 
echo "chown -Rf $myuser:$myuser /usr/local/share/GitHub/econ-ark # Make it be owned by econ-ark user " >> "$finish" 

echo ''                                               >> "$finish" 
echo 'echo Finished automatic installations.  Rebooting.'  >> "$finish" 
echo 'reboot ' >> "$finish" 

chmod a+x "$finish"


