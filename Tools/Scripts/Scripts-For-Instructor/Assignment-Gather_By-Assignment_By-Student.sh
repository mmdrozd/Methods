#!/bin/bash
# This script needs to be run on a VM that has linked the instructor.methods.dropbox@llorracc.org Dropbox account to its /home/methods/Dropbox folder
# The script will be run at the due date of an assignment, and will copy from the student's "shared" folder whatever exists on the due date
# Upon receiving each student's /shr/Methods/Assignments folder, the instructor renames it and the student's Moniker and put it in $assnmtShared/Latest/ByStudent/[Moniker]

#rm -f $dir/*~
pp
if [ $# -ne 2 ]; then
    echo "usage:   ${0##*/} assignmentName studentMoniker" 
    echo "example: ${0##*/} 02-10_Create-Your-pri-shr-pub-Directories_And-Share-Assignments-Folder-With-Instructor CarrollCD"
    exit
fi

assignment=$1 
moniker=$2

scriptRoot="$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script

cd $scriptRoot
# For copy-and-paste-testing, put point right after # and select however far down you want to test
# scriptRoot=scriptRoot=/Methods/Tools/Scripts/Scripts-For-Instructor ; assignment=00_How-To-Turn-In-Assignments ; moniker=CarrollCD ; echo ''

droot=~/Dropbox
assnmtShr=Assignments-Turned-In
assnmtShared=$droot/$assnmtShr/Latest # So, CarrollCD would share his `Assignments` folder at [droot]/shr/Methods/Assignments, which the instructor would then move to $assnmtShared/ByStudent/ and rename from `Assignments` to `CarrollCD`
assnmtTurnedIn=$droot/$assnmtShr/Latest # 

cd $assnmtShared/ByStudent/

# Copy the original assignment directory (for reference) to the target directory
if [ ! -d /Methods/Assignments/$assignment ]; then
    echo "/Methods/Assignments/$assignment does not exist; aborting"
    exit 1
else
    if [ -z "$(ls -A /Methods/Assignments/$assignment)" ]; then
	echo "/Methods/Assignments/$assignment is empty; aborting"
	exit 1
    fi
    cmd="mkdir -p $assnmtShared/ByAssignment/$assignment/$moniker"
    echo "$cmd"
    eval "$cmd"
    echo  '' ;   echo
    cmd="sudo chmod -Rf a+w $assnmtShared/ByAssignment/$assignment " # Make everything in the destination writeable
    echo "$cmd"
    eval "$cmd"
    cmd="sudo chmod -Rf a-w /Methods/Assignments/$assignment" # Make these files read-only because they are the original instructions; if a student forgot to put their _Moniker on an edited version, their modified file will not copy over the original filename, but instead will generate an error
    echo "$cmd"
    eval "$cmd"
    cmd="cp -r /Methods/Assignments/$assignment/* $assnmtShared/ByAssignment/$assignment " # Copy the original assignment 
    echo "$cmd"
    eval "$cmd"
    cmd="sudo chmod -Rf a+w /Methods/Assignments/$assignment" # Restore write permission so the files can be modified at next git pull
    echo "$cmd"
    eval "$cmd"
fi

# Make two copies of the assignment folder contents: One at the root level of the directory, and one under the moniker of the student
dir0="$assnmtShared/ByAssignment/$assignment/$moniker" # Directory into which the assignment will be filed, for easy comparison of all assignments
dir1="$assnmtShared/ByAssignment/$assignment"          # Directory into which the assignment will be filed, for easy comparison of all assignments
dir2="$assnmtShared/ByStudent/$moniker/$assignment*" # The * captures it whether or not the student appended their moniker

for f in $dir2; do
    echo '' ; echo Working on file "$(basename "$f")"
    if [ -f $f ]; then
	if [ ! -d $dir1 ]; then
	    echo mkdir -p $dir1
	    mkdir -p $dir1
	fi
	echo file: $f
	cmd="cp $f $assnmtShared/ByAssignment/$assignment/$moniker" ; echo '' 
	echo $cmd
	eval $cmd
	cmd="cp $f $assnmtShared/ByAssignment/$assignment" ; echo ''
	echo $cmd
	eval $cmd
    fi
    if [ -d $f ]; then
	if [ ! -z "$(ls -A $f)" ]; then
	    echo '' ; echo working on folder: $f ; echo ''
	    cmd="cp -r $f/* $assnmtShared/ByAssignment/$assignment/$moniker" ; echo ''
	    echo $cmd
	    eval $cmd
	    cmd="cp -r $f/* $assnmtShared/ByAssignment/$assignment" ; echo ''
	    echo $cmd
	    eval $cmd
	fi
    fi
done

