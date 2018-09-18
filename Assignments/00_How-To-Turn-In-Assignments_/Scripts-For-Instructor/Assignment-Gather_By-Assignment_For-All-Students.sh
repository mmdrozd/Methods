#!/bin/bash
# This script needs to be run on a VM that has linked the instructor.methods.dropbox@llorracc.org Dropbox account to its /home/methods/Dropbox folder


if [ $# -ne 1 ]; then
    echo "usage:   ${0##*/} assignmentName" 
    echo "example: ${0##*/} 02-10_Create-Your-pri-shr-pub-Directories_And-Share-Assignments-Folder-With-Instructor"
    exit
fi

assignment=$1
#assignment='02-10_Create-Your-pri-shr-pub-Directories_And-Share-Assignments-Folder-With-Instructor'

monikers=( CarrollCD ReddyJK RotarescuAA ZhangTT hernandokaminskypd HernandokaminskyPD WangWY )

cd "$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script
for moniker in "${monikers[@]}"; do
    pwd
    echo '' ; echo    ./Assignment-Gather_By-Assignment_By-Student.sh $assignment $moniker
    ./Assignment-Gather_By-Assignment_By-Student.sh $assignment $moniker
done

