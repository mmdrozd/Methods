#!/bin/bash

cd "$(dirname "$0")" 
# If jupytext has not been installed, install it
[[ ! `conda list | grep jupytext` != '' ]] && sudo conda install -c conda-forge jupytext

if [ ! -e ~/.jupyter/jupyter_notebook_config.py ]; then
	jupyter notebook --generate-config
fi

# If jupytext has not been configured, configure it
if ( ! grep -q jupytext ~/.jupyter/jupyter_notebook_config.py ); then
    echo 'Adding jupytext config via:'
    cmd="cat ./jupytext.add >> ~/.jupyter/jupyter_notebook_config.py"
    echo "$cmd"
    eval "$cmd"
else
    echo 'jupytext already configured'
fi

