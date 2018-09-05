#!/bin/bash

echo '' ; echo Running "$0" ; echo ''

source /Volumes/Sync/Lib/config/bash/dotbashrc-all

cd $METH_SOFTWARE

./emacs.sh

./Chrome.sh

