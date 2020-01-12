#!/bin/bash
scriptDir="$(dirname "`realpath $0`")"
# scriptDir=/Volumes/Data/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Machines/Scripts/Methods-ISO/
cd "$scriptDir"
start='start_modified-for-econ-ark_start.sh'
touch "$start"
sudo chmod a+w "$start"

echo '#!/bin/bash' > "$start"

#cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages/Anaconda3-Latest.sh          | tee "$start"
echo 'sudo apt -y install bash-completion xsel git curl wget cifs-utils openssh-server nautilus-share xclip' >> "$start"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Toolkits/ARK.sh                        | tee "$start"
cat ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Packages/VirtualBox-Guest-Additions.sh | tee "$start"
chmod a+x "$start"
