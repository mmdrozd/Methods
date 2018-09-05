#!/bin/bash

# Extracts from economics.bib the entry whose key is keyName
if [ $# -ne 1 ]
then
  echo "usage:   ${0##*/} keyName"
  echo "example: ${0##*/} cstwMPC"
  exit 1
fi

keyName=$1

# Need to build the command because of complex requirements about quotes etc
bibtoolGet='bibtool -r /Methods/Tools/Scripts/bibtool.rsc '
selection=\'--select{\"$keyName\"}\'
bibtoolGet+=$selection
bibtoolGet+=' '`kpsewhich economics.bib`
bibtoolGet+=' 2> /dev/null | grep -v STRING | grep -v PREAMBLE | grep -v providecommand '

eval $bibtoolGet
