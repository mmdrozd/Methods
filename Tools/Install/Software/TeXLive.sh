#!/bin/bash

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# There are too many options for installing TeXLive, none of which is very satisfactory.
# 
# http://tipsonubuntu.com/2016/09/16/install-tex-live-2016-ubuntu-16-04-14-04/
# http://chrisstrelioff.ws/sandbox/2016/10/31/install_tex_live_2016_on_ubuntu_16_04.html
# https://www.tug.org/texlive/doc/texlive-en/texlive-en.html#tlportable
# 
# All of these omit the tlmgr tool, which is like installing Ubuntu without the apt tool

# The best option to install BOTH TeXLive AND tlmgr seems to be:
# https://github.com/scottkosty/install-tl-ubuntu

# However, in order to work, this requires the installation of perl-tk and recommends gksu

# Get the directory in which this script is being run because assumptions will be made later
# about location of patch files relative to that directory

if [ -d /usr/local/texlive ]; then
    echo 'It appears that TeXLive has already been installed on this machine.'
    echo 'If you want to uninstall it and continue, open a shell and run:'
    echo '/Methods/Tools/Install/Software/TeXLive-Remove.sh'
    echo ''
    echo 'Otherwise, hit return to rerun the configuration/setup steps'
    echo 'that may be able to repair a nonfunctioning installation.'
    read answer
    if ! [ -d /usr/local/texlive ]; then # the've deleted the old installation, so reinstall
	/Methods/Tools/Install/Software/TeXLive-tlmgr-Download.sh
    fi
else # there was no installation, so install
    /Methods/Tools/Install/Software/TeXLive-tlmgr-Download.sh
fi


cd /usr/local/texlive

for YYYY in ????; do # This should find all directories that are four characters long, which are probably years
    if ! [[ $YYYY =~ ^-?[0-9]+$ ]]; then
	echo 'Could not find a year directory in /usr/local/texlive; aborting'
	exit 1
    fi
    for stuff in texmf-var texmf-config texmf-dist tlpkg; do
	if [ ! -e /usr/local/texlive/$stuff ]; then # Don't want to have to have fresh $stuff for every new version of texlive
	    if [ ! -L /usr/local/texlive/$YYYY/$stuff ]; then
		sudo mv /usr/local/texlive/$YYYY/$stuff /usr/local/texlive/$stuff
		sudo ln -fs /usr/local/texlive/$stuff /usr/local/texlive/$YYYY
	    else
		echo /usr/local/texlive/$YYYY is already linked to `readlink "/usr/local/texlive/$YYYY/$stuff"`
	    fi
	fi
    done
done

if [ -f /usr/local/texlive/texmf.cnf ]; then # Don't want to have to recreate texmf.cnf every time there's a new version of texlive
    sudo mv /usr/local/texlive/$YYYY/texmf.cnf texmf_orig.cnf 
    sudo ln -fs /usr/local/texlive/texmf-local/web2c/texmf.cnf /usr/local/texlive/$YYYY
else # the configuration file does not exist yet, so make it 
    sudo cp $scriptDir/TeXLive/root/usr/local/texlive/texmf-local/web2c/texmf.cnf /usr/local/texlive/texmf-local/web2c/texmf.cnf
    sudo chmod a+r /usr/local/texlive/texmf-local/web2c/texmf.cnf
fi

# Patch to fix bug in scr*.4ht which is needed to use htlatex 
sudo $scriptDir/TeXLive/Patches/scr-htlatex-bug/tex4ht-4ht-apply.sh

sudo texhash

sudo chmod a+w -Rf /usr/local/texlive/tlpkg 

echo ''
echo ''
echo 'Reboot is necessary before tlmgr will be operational.'
echo ''

cd /usr/local/texlive/texmf-local/

for texfile in tex bibtex; do
    sudo rm -Rf $texfile
    sudo ln -fs /Methods/Tools/Config/tool/texlive/texmf-local/$texfile ./$texfile
done

sudo apt -y install xzdec
sudo apt -y install texlive-fonts-extra
sudo texhash

sudo rm -Rf ~/tmp-TeXLive    
