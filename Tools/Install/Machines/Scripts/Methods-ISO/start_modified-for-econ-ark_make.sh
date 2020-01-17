#!/bin/bash
scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"
echo ''
echo "scriptDir=$scriptDir"
echo ''
# scriptDir=/Volumes/Data/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Machines/Scripts/Methods-ISO/
cd "$scriptDir"
start='start_modified-for-econ-ark.sh'
rm "$start"
touch "$start"
sudo chmod a+xw "$start"

echo '#!/bin/bash' > "$start"

echo 'sudo apt -y update && sudo apt -y upgrade' >> "$start"
cat "$scriptDir/start_modified-for-econ-ark_start.sh" >> "$start"
cat "$scriptDir/vncserver_default_password_setup.sh"  >> "$start"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages/Anaconda3-Latest.sh         >> "$start"
echo 'sudo apt -y install bash-completion xsel git curl wget cifs-utils openssh-server nautilus-share xclip emacs auctex texlive-full tigervnc-scraping-server' >> "$start"

echo 'myuser=econ-ark' >> "$start"
echo 'mypasswd=kra-noce' >> "$start"
echo "mkdir /home/"$myuser"/.vnc" >> "$start"
echo 'echo "$mypasswd" | vncpasswd -f > /home/$myuser/.vnc/passwd' >> "$start"
echo 'chown -R $myuser:$myuser /home/$myuser/.vnc' >> "$start"
echo 'chmod 0600 /home/$myuser/.vnc/passwd ' >> "$start"

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK.sh                        >> "$start"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Packages/VirtualBox-Guest-Additions.sh >> "$start"
echo 'mkdir -p /home/$myuser/GitHub/econ-ark ; ln -s /usr/local/share/GitHub/econ-ark /home/$myuser/GitHub/econ-ark' >> "$start" 
chmod a+x "$start"
