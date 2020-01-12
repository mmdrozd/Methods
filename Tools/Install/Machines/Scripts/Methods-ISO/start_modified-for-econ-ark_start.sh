#!/bin/bash

#Download and extract HARK, REMARK, DemARK from GitHUB repository

conda install --yes -c conda-forge econ-ark
mkdir -p ~/GitHub/econ-ark
cd ~/GitHub/econ-ark
git clone https://github.com/econ-ark/REMARK.git
git clone https://github.com/econ-ark/DemARK.git
