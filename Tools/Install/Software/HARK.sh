#!/bin/bash

if ! [ -x "$(command -v conda)" ]; then
    echo ''
    echo 'conda command does not exist or is not executable.'
    echo 'Fix and rerun this script.'
    echo ''
    exit 1
fi

# If ARK environment does not exist, create it 
ARKpy2Path=`conda info --envs | grep ARKpy2`
if [[ $ARKpy2Path == "" ]]; then #
    conda create --name ARKpy2 python=2
fi

source activate ARKpy2

cd ~/Dropbox

git clone https://github.com/ccarrollATjhuecon/HARK.git

cd HARK

