#!/bin/bash
# Refresh version of texmf-local in target directory

if [ $# -ne 1 ]; then
    echo 'usage:   '$0' <target directory>'
    echo 'example: '$0' /Volumes/Data/Papers/dcegmSearch/dcegmSearch-Latest'
    exit
fi

dest="$1"
# dest=/Volumes/Data/Papers/SolvingMicroDSOPs/Latest
if [ ! -d "$dest" ]; then
    echo "$dest" is not a directory -- try again
    exit 1
fi
chmod -Rf a+rw "$dest" 

cmd="rsync -L -azh -vv -r --delete --delete-excluded --exclude='_region_.tex' --exclude='.gitkeep' --exclude='.DS_Store' --exclude='.AppleDouble' --exclude='.LSOverride' --exclude='*_*' --exclude='*~' --exclude='*.*~' `realpath /usr/local/texlive/texmf-local` $dest ; cd $dest"

echo "$cmd"
eval "$cmd"

