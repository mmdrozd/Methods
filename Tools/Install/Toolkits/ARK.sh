#!/bin/bash

#Download and extract HARK, REMARK, DemARK from GitHUB repository

# conda install --yes -c conda-forge econ-ark
pip install econ-ark
arkHome=/usr/local/share/data/GitHub/econ-ark
mkdir -p "$arkHome"
cd "$arkHome"
git clone https://github.com/econ-ark/REMARK.git
git clone https://github.com/econ-ark/HARK.git
git clone https://github.com/econ-ark/DemARK.git
chmod a+rw -Rf /usr/local/share/data/GitHub/econ-ark

echo 'This is your local, personal copy of HARK; it is also installed systemwide.  '    >  HARK-README.md
echo 'Local mods will not affect systemwide, unless you change the default source via:' >> HARK-README.md
echo "   cd $arkHOME ;  pip install -e setup.py "  >> HARK-README.md
echo '' >> HARK-README.md
echo '(You can switch back to the systemwide version using pip install econ-ark)' >> HARK-README.md


echo 'This is your local, personal copy of DemARK, which you can modify.  '    >  DemARK-README.md
echo 'This is your local, personal copy of REMARK, which you can modify.  '    >  REMARK-README.md

