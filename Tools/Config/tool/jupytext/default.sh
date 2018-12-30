#!/bin/bash

# Get the defaults needed for DemARK

cd "$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script

pwd

/bin/bash ./resources/DemARK-binder-PostBuild.sh  # among other things, adds nbextensions
/bin/bash ./resources/jupytext.sh
/bin/bash ./resources/cite2c.sh

# Add any extra nbextensions

jupyter nbextension enable collapsible_headings/main
