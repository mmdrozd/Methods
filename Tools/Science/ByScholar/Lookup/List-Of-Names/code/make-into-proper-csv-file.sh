#!/bin/bash

if [ $# -ne 1 ]; then
  echo "usage:   ${0##*/} file.csv"
  exit 1
fi

# The file created by scholar.py is actually a |sv rather than ,sv file, because there are commas in urls
# This:
#   0. Deletes blank lines
#   0. If there are any double quote marks, replace with single quotes
#   0. Puts a quote at the beginning and the end of each line
#   0. Substitutes "|" for |
#   0. Deletes lines beyond the first one that are duplicates of the header line

cat $1 | sed '/^\s*$/d' | tr '"' "'" | sed -e 's/"//g' -e 's/^\|$/"/g' -e 's/|/"|"/g' | awk '{ print "\""$0"\""}' | sed -e 's/|/,/g' | awk '!a[$0]++' 

