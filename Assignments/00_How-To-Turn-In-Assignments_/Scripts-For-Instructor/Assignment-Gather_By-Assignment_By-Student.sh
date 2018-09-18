#!/bin/bash
# This script needs to be run on a VM that has linked the instructor.methods.dropbox@llorracc.org Dropbox account to its /home/methods/Dropbox folder
# The script will be run at the due date of an assignment, and will copy from the student's "shared" folder whatever exists on the due date

if [ $# -ne 2 ]; then
    echo "usage:   ${0##*/} assignmentName studentMoniker" 
    echo "example: ${0##*/} 02-10_Create-Your-pri-shr-pub-Directories_And-Share-Assignments-Folder-With-Instructor CarrollCD"
    exit
fi

assignment=$1 
moniker=$2

scriptRoot="$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script
scriptRoot=~/Dropbox/Assignments-Turned-In/Latest/ByAssignment/00_How-To-Turn-In-Assignments_/Scripts/
cd $scriptRoot
# For copy-and-paste-testing, put point right after # and select however far down you want to test
# scriptRoot=~/Dropbox/Assignments-Turned-In/Latest/ByAssignment/00_How-To-Turn-In-Assignments_/Scripts; assignment=01-05_Get-A-Course-Dropbox-Account ; moniker=ZhangTT

droot=$scriptRoot/../../../../..
assnmtShr=Assignments-Turned-In
assnmtShared=$droot/$assnmtShr/Latest # So, CarrollCD would share his `Assignments` folder at [droot]/shr/Methods/Assignments, which the instructor would then move to $assnmtShared/ByStudent/ and rename from `Assignments` to `CarrollCD`
assnmtTurnedIn=$droot/$assnmtShr/Latest # 

cd $assnmtShared/ByStudent/

#dir=$assnmtShared/ByAssignment/${file%%.*} # Directory into which the assignment will be filed, for easy comparison of all assignments
dir=$assnmtShared/ByAssignment/$assignment # Directory into which the assignment will be filed, for easy comparison of all assignments
mkdir -p $dir # Path will not exist the first time script is run
# Copy the original assignment.md or assignment_ directory (for reference) to the target directory
if [ -e /Methods/Assignments/$assignment/*.md ]; then
    echo  '' ;   echo 0. cp /Methods/Assignments/$assignment/*.md $assnmtShared/ByAssignment/$assignment ; echo ''
    echo sudo chmod -Rf a+w $assnmtShared/ByAssignment/$assignment # These files are read-only because they are the original instructions; if a student forgot to put their _Moniker on an edited version, their modified file will not copy overcp /Methods/Assignments/$assignment/*.md $assnmtShared/ByAssignment/$assignment
    sudo chmod -Rf a+w $assnmtShared/ByAssignment/$assignment # These files are read-only because they are the original instructions; if a student forgot to put their _Moniker on an edited version, their modified file will not copy overcp /Methods/Assignments/$assignment/*.md $assnmtShared/ByAssignment/$assignment
    cp /Methods/Assignments/$assignment/*.md $assnmtShared/ByAssignment/$assignment
    chmod -Rf a-w $assnmtShared/ByAssignment/$assignment/*.md # These files are read-only because they are the original instructions; if a student forgot to put their _Moniker on an edited version, their modified file will not copy over
#    chmod a-w $assnmtShared/ByAssignment/$assignment.md
fi
# Any directories created by the instructor should end with _; copy them too
if [ -e "/Methods/Assignments/$assignment/"*_ ]; then
    
    echo  1.  cp -r "/Methods/Assignments/$assignment/"*_ $assnmtShared/ByAssignment/$assignment
    sudo chmod -Rf a+w  $assnmtShared/ByAssignment/$assignment
    cp -r "/Methods/Assignments/$assignment/"*_ $assnmtShared/ByAssignment/$assignment
    sudo chmod -Rf a-w "$assnmtShared/ByAssignment/$assignment/"*_
fi

dir2="$assnmtShared/ByStudent/$moniker/$assignment*"

for f in $dir2; do
    echo "$(basename "$f")"
    if [ -f $f ]; then
	if [ ! -d $dir ]; then
	    mkdir $dir
	fi
#	echo file: $f
	echo '' ; echo 2. cp $f $assnmtShared/ByAssignment ; echo ''
	cp $f $assnmtShared/ByAssignment
    fi
    if [ -d $f ]; then
	echo '' ; echo 3 folder: $f ; echo ''
	echo	4. "cd $f ; cp -r . $assnmtShared/ByAssignment/$assignment ; cd .."
	sudo chmod -Rf a+rw $assnmtShared/ByAssignment/$assignment 
	cd $f ; cp -r . $assnmtShared/ByAssignment/$assignment ; cd ..
    fi
done

# Upon receiving each student's /shr/Methods/Assignments folder, TA will rename it to the student's Moniker and put it in $assnmtShared/Latest/ByStudent/[Moniker]
# echo cp -ar $dir2 $dir

#[[ -d "$dir2" ]] &&
#    cp -ar $dir2 $dir    # if folder exists in dir2 (if student submitted a folder), copy folder into dir
#    [[ -f $dir2/* ]] &&
#cd $dir2

#cp -rf . $dir  # if file   exists in dir2 (if student submitted a file),   copy file   in dir

rm -f $dir/*~
