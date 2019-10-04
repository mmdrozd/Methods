#!/bin/bash

if [ -e ~/GitHub/ccarrollATjhuecon/Methods ]; then
    cd ~/GitHub/ccarrollATjhuecon/Methods
    git checkout master # Make sure on master branch
else
    echo 'No ~/GitHub/ccarrollATjhuecon/Methods; aborting'
    exit
fi

if curl --output /dev/null --head --silent --head --fail "https://github.com/ccarrollATjhuecon/Methods" ; then # We have access
# https://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
	echo "No changes in upstream Methods repo; continuing"
    else
	git fetch
	git reset --hard
	git pull
        echo 'Rerunning Basic setup script (in case it has changed)'
        /Methods/Tools/Install/Machines/010_Xubuntu/Scripts/010_Basic.sh
    fi
fi

