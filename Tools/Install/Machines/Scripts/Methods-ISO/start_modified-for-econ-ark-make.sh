#!/bin/bash
scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"
echo ''
#echo "scriptDir=$scriptDir"
#echo ''
# scriptDir=/Volumes/Data/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Machines/Scripts/Methods-ISO/
cd "$scriptDir"
myuser="econ-ark"
start="start_modified-for-$myuser.sh"
rm "$start"
touch "$start"
sudo chmod a+xw "$start"

echo '#!/bin/bash' > "$start"

# Autostart xfce4-terminal
cat "$scriptDir/xfce4-terminal_autostart.sh"  | fgrep -v "#!/bin/bash" >> "$start"

# Set up vnc server
cat "$scriptDir/vncserver_default_password_setup.sh" | fgrep -v "#!/bin/bash"  >> "$start"

# Reset hostname; setup bashrc 
cat "$scriptDir/start_modified-for-econ-ark_start.sh" | fgrep -v "#!/bin/bash" >> "$start"

chmod a+x "$start"

