#!/bin/bash

scriptPath="$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script

if [ $# -ne 4 ]; then
  echo "usage:   ${0##*/} <path to directory> <src string> <rpl string> show|do "
  echo "example: ${0##*/} . 'fisher:interestTheory' 'fisherInterestTheory' do"
  exit 1
fi

path=$1
original=$2
replacement=$3
showOrDo=$4

$scriptPath/find-and-replace-BibTeX-Reference-Locally.sh $path $original $replacement $showOrDo

systemFiles=/usr/local/texlive/texmf-local

cd $systemFiles
echo Changing directory to $systemFiles

echo ''
bib=$scriptPath"/find-and-replace-string.sh "$systemFiles" bib '"$original"' '"$replacement"' "$showOrDo
echo Executing: $bib
eval $bib
echo ''

