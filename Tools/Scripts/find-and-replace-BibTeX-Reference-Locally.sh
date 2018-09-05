#!/bin/bash

if [ $# -ne 4 ]; then
  echo "usage:   ${0##*/} <path to directory> <src string> <rpl string> show|do "
  echo "example: ${0##*/} . 'fisher:interestTheory' 'fisherInterestTheory' do"
  exit 1
fi

path=$1
# ext=$2
original=$2
replacement=$3
showOrDo=$4

if [ ! -d $path ]; then
    echo $path is not a path to a directory; aborting
    exit
fi

fullPath=$(realpath $path)

scriptPath="$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script

echo 'Need to authorize sudo:'
sudo ls -las > /dev/null

echo ''
bib=$scriptPath"/find-and-replace-string.sh "$path" bib '"$original"' '"$replacement"' "$showOrDo
echo Executing: $bib
eval $bib
echo ''

tex=$scriptPath"/find-and-replace-string.sh "$path" tex '"$original"' '"$replacement"' "$showOrDo
echo Executing: $tex
eval $tex
echo ''
