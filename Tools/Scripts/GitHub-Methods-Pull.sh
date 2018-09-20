#!/bin/bash

cd ~/GitHub/Methods
if curl --output /dev/null --head --silent --head --fail "https://github.com/ccarrollATjhuecon/Methods" ; then # We have access
    git fetch
    git reset --hard
    git pull
fi

