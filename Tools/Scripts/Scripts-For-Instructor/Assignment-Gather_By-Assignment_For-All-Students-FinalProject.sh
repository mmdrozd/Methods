#!/bin/bash
# This script needs to be run on a VM that has linked the instructor.methods.dropbox@llorracc.org Dropbox account to its /home/methods/Dropbox folder


# if [ $# -ne 1 ]; then
#     echo "usage:   ${0##*/} assignmentName" 
#     echo "example: ${0##*/} 02-10_Create-Your-pri-shr-pub-Directories_And-Share-Assignments-Folder-With-Instructor"
#     exit
# fi

# assignment=$1
assignment='14_Final-Class-Project'

monikers=( CarrollCD ReddyJK RotarescuAA ZhangTT hernandokaminskypd HernandokaminskyPD WangWY )

cd "$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script
for moniker in "${monikers[@]}"; do
    pwd
    echo '' ;
    cmd='cp -r '/home/methods/Dropbox/Assignments-Turned-In/Latest/ByStudent/$moniker/$assignment'_'$moniker/ImpatienceVsTarget' /home/methods/Dropbox/Assignments-Turned-In/Latest/ByAssignment/14_Final-Class-Project/ImpatienceVsTarget_'$moniker
    echo $cmd
    eval $cmd
    cmd='cp -r '/home/methods/Dropbox/Assignments-Turned-In/Latest/ByStudent/$moniker/$assignment'_'$moniker/ImpatienceVsTarget/Latest/LaTeX/ImpatienceVsTarget.pdf' /home/methods/Dropbox/Assignments-Turned-In/Latest/ByAssignment/14_Final-Class-Project/ImpatienceVsTarget_'$moniker.pdf
    echo $cmd
    eval $cmd
done

