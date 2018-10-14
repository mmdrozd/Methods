#!/bin/bash
# Adapted from http://askubuntu.com/questions/505919/how-to-install-anaconda-on-ubuntu

mkdir ~/tmp
cd ~/tmp

CONTREPO=https://repo.continuum.io/archive/
# Stepwise filtering of the html at $CONTREPO
# Get the topmost line that matches our requirements, extract the file name.
ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
wget -O ~/tmp/anaconda.sh $CONTREPO$ANACONDAURL
bash ~/tmp/anaconda.sh

addToPath='export PATH=~/anaconda3/bin:$PATH'
if grep -q anaconda3 ~/.bash_aliases; then
    echo 'It appears that the path for anaconda3 has already been added to the ~/.bash_aliases file for this user'
    echo ''
    cat ~/.bash_aliases
    echo ''
else
    cat ~/.bash_aliases > ~/tmp/.bash_aliases_initial
    echo '' >> ~/tmp/.bash_aliases_initial
    echo $addToPath >> ~/tmp/.bash_aliases_initial
    mv ~/tmp/.bash_aliases_initial ~/.bash_aliases
fi

rm ~/tmp
