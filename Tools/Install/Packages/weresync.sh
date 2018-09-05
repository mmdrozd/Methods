#!/bin/bash

type python3 >/dev/null 2>&1 || { echo >&2 "weresync requires a full installation of python3 but it's not installed.  run Anaconda3.sh or python.sh."; exit 1; }

cd ~/Downloads
git clone https://github.com/DonyorM/weresync.git
cd weresync
python3 ./setup.py install

pip install weresync

