#!/bin/bash
# Once the student has created their pri-shr-pub droot directories,
# the first step in executing any assignment is to run this script.
# It will copy the Markdown document containing the assignment to
# the correct location in the student's pri directory structure.
# The student then edits the assignment customized with their moniker,
# and turns in the result as described in "How-To-Turn-In-Assignments"

if [ $# -ne 2 ]; then
    echo "usage:   ${0##*/} <AssignmentPath> <Moniker>"
    echo "example: ${0##*/} 07-05_Compile-BufferStockTheory-Paper CarrollCD"
    exit 1
fi

assnDir=$1
moniker=$2 # assnDir=00_How-To-Turn-In-Assignments ; moniker=CarrollCD
assnRoot=Methods/Assignments

# Create the receptacle directories in the right places
cd ~/Dropbox
for i in pri shr ; do
    echo At beginning i is $i
    if [ -d "~/Dropbox/$i/$assnRoot/$assnDir" ]; then
	echo ''
	echo ''
	echo "Target directory ~/Dropbox/$i/$assnRoot/$assnDir already exists"
	echo ''
	echo Hit return when it has been moved or deleted via a command like
	echo ''
	echo "rm -Rf ~/Dropbox/$i/$assnRoot/$assnDir"
	echo ''
	echo 'or'
	echo ''
	echo mv "~/Dropbox/$i/$assnRoot/$assnDir ~/Dropbox/$i/$assnRoot/$assnDir-Old"
	echo ''
	read answer
	cmd="rm -Rf ~/Dropbox/$i/$assnRoot/$assnDir"
	echo "$cmd"
	eval "$cmd"
    else
	echo "~/Dropbox/$i/$assnRoot/$assnDir does not exist -- continuing"
    fi
    echo ''
    echo ''
    cmd="mkdir -p ~/Dropbox/$i/$assnRoot/$assnDir"
    echo "$cmd"
    eval "$cmd"
    if [ $i == "pri" ]; then
	cmd="cp -r /$assnRoot/$assnDir/*.* ~/Dropbox/$i/$assnRoot/$assnDir"
	echo "$cmd"
	eval "$cmd"
    fi
done

cd /$assnRoot/$assnDir

echo ''
echo 'The following are the commands being executed:'
echo ''
for f in *; do
    if [ -f $f ]; then
#	echo $f is a file
	filename="${f%.*}" # ; echo filename=$filename 
	extension="${f##*.}" # ; echo extension=$extension
	filenameNew=$filename
	filenameNew+='_'$moniker
	cmd="mkdir -p ~/Dropbox/pri/$assnRoot/$assnDir ; cp $filename.$extension ~/Dropbox/pri/$assnRoot/$assnDir/$filenameNew.$extension"
	echo "$cmd"
	eval "$cmd"
    else # it's a directory
#	echo $f is a directory
	fNew=$f'_'$moniker
	cmd="cp -r $f ~/Dropbox/pri/$assnRoot/$assnDir/$fNew"
	echo "$cmd"
	eval "$cmd"
    fi
done

echo '' ; echo ''
echo 'When you have finished with your assignment, you will need to copy the results into the directory shared with the instructor via a command like:'
echo ''
echo "cp -r ~/Dropbox/pri/$assnRoot/$assnDir/* ~/Dropbox/shr/$assnRoot/$assnDir/"
echo ''
echo '(Or you can copy the files using the file browser from the GUI).'
