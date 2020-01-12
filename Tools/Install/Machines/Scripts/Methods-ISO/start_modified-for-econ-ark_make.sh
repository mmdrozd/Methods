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

cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages/Anaconda3-Latest.sh         >> tee "$start"
echo 'sudo apt -y install bash-completion xsel git curl wget cifs-utils openssh-server nautilus-share xclip' >> "$start"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK.sh                        >> "$start"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Packages/VirtualBox-Guest-Additions.sh >> "$start"
chmod a+x "$start"
