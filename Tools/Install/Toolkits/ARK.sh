#!/bin/bash

#Download and extract HARK, REMARK, DemARK from GitHUB repository

conda install --yes -c conda-forge econ-ark
arkHome=/usr/local/share/GitHub/econ-ark
mkdir -p "$arkHome"
cd "$arkHome"
git clone https://github.com/econ-ark/REMARK.git
git clone https://github.com/econ-ark/DemARK.git
