#!/bin/bash

echo '' ; echo 'Switching automatically to existing ~/GitHub/Methods folder. '
sudo rm -f /Methods ; sudo ln -fs /home/methods/GitHub/Methods /Methods
echo 'Pulling latest courseware from GitHub'
/Methods/Tools/Scripts/GitHub-Methods-Pull.sh
echo 'Rerunning Basic setup script (in case it has changed)'
/Methods/Tools/Install/Machines/010_Xubuntu/Scripts/010_Basic.sh
