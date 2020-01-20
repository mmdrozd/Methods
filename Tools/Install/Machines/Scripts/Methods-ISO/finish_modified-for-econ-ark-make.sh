#!/bin/bash
scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"
echo ''
#echo "scriptDir=$scriptDir"
echo ''
cd "$scriptDir"
myuser="econ-ark"
finish="finish_modified-for-$myuser.sh"
rm "$finish"
touch "$finish"
sudo chmod a+xw "$finish"

echo '#!/bin/bash' > "$finish"

echo 'sudo apt -y update && sudo apt -y upgrade' >> "$finish"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages/Anaconda3-Latest.sh | fgrep -v "!/bin/bash"        >> "$finish"
echo 'sudo apt -y install git bash-completion xsel cifs-utils openssh-server nautilus-share xclip texlive-full emacs auctex' >> "$finish"

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK.sh                        | fgrep -v "!/bin/bash"  >> "$finish"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Packages/VirtualBox-Guest-Additions.sh | fgrep -v "!/bin/bash" >> "$finish"
echo 'mkdir -p /home/$myuser/GitHub/econ-ark ; ln -s /usr/local/share/GitHub/econ-ark /home/$myuser/GitHub/econ-ark' >> "$finish" 

echo ''                                               >> "$finish" 
echo 'Finished automatic installations.  Rebooting.'  >> "$finish" 
echo 'reboot ' >> "$finish" 

chmod a+x "$finish"


