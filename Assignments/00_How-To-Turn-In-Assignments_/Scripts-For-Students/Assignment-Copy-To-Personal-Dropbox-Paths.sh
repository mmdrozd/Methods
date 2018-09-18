#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage:   ${0##*/} <AssignmentPath> <Moniker>"
  echo "example: ${0##*/} 07-05_Compile-BufferStockTheory-Paper CarrollCD"
  exit 1
fi

assnDir=$1
moniker=$2 # assnDir=07-05_Compile-BufferStockTheory-Paper ; moniker=CarrollCD
assnRoot=Methods/Assignments

for i in pri shr ; do
    echo At beginning i is $i
    if [ -d ~/Dropbox/$i/$assnRoot/$assnDir ]; then
	echo ~/Dropbox/$i/$assnRoot/$assnDir exists
	echo ''
	echo ''
	echo Target directory ~/Dropbox/$i/$assnRoot/$assnDir already exists
	echo ''
	echo Hit return when it has been moved or deleted via a command like
	echo ''
	echo rm -Rf ~/Dropbox/$i/$assnRoot/$assnDir 
	echo ''
	echo 'or'
	echo ''
	echo mv ~/Dropbox/$i/$assnRoot/$assnDir ~/Dropbox/$i/$assnRoot/$assnDir-Old
	echo ''
	read answer
	echo	rm -Rf ~/Dropbox/$i/$assnRoot/$assnDir 
		rm -Rf ~/Dropbox/$i/$assnRoot/$assnDir 
    else
	echo ~/Dropbox/$i/$assnRoot/$assnDir does not exist -- continuing
    fi
    echo ''
    echo ''
    echo    mkdir -p ~/Dropbox/$i/$assnRoot/$assnDir
    mkdir -p ~/Dropbox/$i/$assnRoot/$assnDir
    if [ $i == "pri" ]; then
	echo	cp -r /$assnRoot/$assnDir/*.* ~/Dropbox/$i/$assnRoot/$assnDir
		cp -r /$assnRoot/$assnDir/*.* ~/Dropbox/$i/$assnRoot/$assnDir
    fi
done

cd ~/Dropbox/pri/$assnRoot/$assnDir
pwd
ls

echo ''
for f in *; do
    echo $f
    filename="${f%.*}" # ; echo filename=$filename 
    extension="${f##*.}" # ; echo extension=$extension
    filenameNew=$filename
    filenameNew+='_'$moniker
    echo     mv $filename.$extension $filenameNew.$extension
        mv $filename.$extension $filenameNew.$extension
done

echo 'When you have finished with your assignment, you will need to copy the results into the directory shared with the instructor via a command like:'
echo ''
echo cp ~/Dropbox/pri/$assnRoot/$assnDir/*.* ~/Dropbox/shr/$assnRoot/$assnDir/*.*
echo ''
