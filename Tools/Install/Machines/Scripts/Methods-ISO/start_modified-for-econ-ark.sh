#!/bin/bash
sudo apt -y install bash-completion xsel git curl wget cifs-utils openssh-server nautilus-share xclip
#!/bin/bash

#Download and extract HARK, REMARK, DemARK from GitHUB repository

conda install --yes -c conda-forge econ-ark
mkdir -p ~/GitHub/econ-ark
cd ~/GitHub/econ-ark
git clone https://github.com/econ-ark/REMARK.git
git clone https://github.com/econ-ark/DemARK.git
#!/bin/bash

# https://askubuntu.com/questions/499070/install-virtualbox-guest-addition-terminal

sudo apt -y install build-essential module-assistant virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
