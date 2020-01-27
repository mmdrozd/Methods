#!/bin/bash

# Get the full contents of the REMARK directory

cd /usr/local/share/data/GitHub/econ-ark/REMARK
git submodule update --init --recursive --remote
git pull --recursive-submodules

