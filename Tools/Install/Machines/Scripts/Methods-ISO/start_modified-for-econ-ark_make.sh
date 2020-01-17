#!/bin/bash
scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"
echo ''
echo "scriptDir=$scriptDir"
echo ''
# scriptDir=/Volumes/Data/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Machines/Scripts/Methods-ISO/
cd "$scriptDir"
myuser="econ-ark"
start="start_modified-for-$myuser.sh"
rm "$start"
touch "$start"
sudo chmod a+xw "$start"

echo '#!/bin/bash' > "$start"

# Set up vnc server
cat "$scriptDir/vncserver_default_password_setup.sh"  >> "$start"

# Reset hostname; setup bashrc 
cat "$scriptDir/start_modified-for-econ-ark_start.sh" >> "$start"
echo "sudo -u $myuser /bin/bash /home/$myuser/.bashrc_aliases" >> "$start" # Execute the new bashrc to start the log

echo 'sudo apt -y update && sudo apt -y upgrade' >> "$start"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages/Anaconda3-Latest.sh         >> "$start"
echo 'sudo apt -y install bash-completion xsel git curl wget cifs-utils openssh-server nautilus-share xclip emacs auctex texlive-full tigervnc-scraping-server' >> "$start"

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK.sh                        >> "$start"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Packages/VirtualBox-Guest-Additions.sh >> "$start"
echo 'mkdir -p /home/$myuser/GitHub/econ-ark ; ln -s /usr/local/share/GitHub/econ-ark /home/$myuser/GitHub/econ-ark' >> "$start" 
chmod a+x "$start"
