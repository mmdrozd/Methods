#!/bin/bash

scriptDir="$(dirname "`realpath $0`")"
cd "$scriptDir"

myuser="econ-ark"

sudo "./start_modified-for-$myuser-make.sh"
sudo "./finish_modified-for-$myuser-make.sh"
