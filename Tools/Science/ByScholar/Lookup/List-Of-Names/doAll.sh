#!/bin/bash

cd "$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script

# Copy the info to the ./working directory where it will be OK to modify it as desired 

ditto ./inputs/auth_names_update.csv ./working
ditto ./inputs/auth_inst.csv         ./working

cd code
# Canonicalize variations in institutional identifiers
./Institutions_Fix.sh

# Update the info on the list of scholars
python auth_lookup_update.py

echo 'Results should be in ./results'
cd ..
ls -las ./results

