#!/bin/bash

# Get whatever are the tools mandated by the DemARK
curl https://raw.githubusercontent.com/econ-ark/DemARK/master/binder/postBuild > /tmp/postBuild
chmod u+x /tmp/postBuild

/bin/bash /tmp/postBuild
