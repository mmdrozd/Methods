#!/bin/bash

echo '' ; echo Running "$0" ; echo ''

source /Volumes/Sync/Lib/config/bash/dotbashrc-METHODs

cd $METH_SOFTWARE

./emacs.sh

./Chrome.sh
