#/bin/bash

if [ $# -ne 2 ]; then
  echo "usage:   $root/${0##*/} <path> <fileName>"
  echo "example: $root/${0##*/} ~/Papers/BufferStockTheory/BufferStockTheory-Shared BufferStockTheory"
  exit 1
fi

pathName=$1
textName=$2

cd "$pathName"
echo ''
cmd="/Methods/Tools/Scripts/texmf-local_update.sh $SharedDir > /dev/null" # Update texmf-local
echo "$cmd"
eval "$cmd"
echo ''

rm -f "$textName".bib
touch "$textName".bib
cmd="pdflatex -halt-on-error $textName"
echo "$cmd"
eval "$cmd" > /dev/null
if [ "$?" -eq 1 ]; then
   eval "$cmd" # If an error occurs, rerun wihtout suppressing output
fi
bibtex="bibtex $textName"
echo ''
echo "$bibtex"
echo ''
eval "$bibtex"
echo ''
echo "$cmd" ; eval "$cmd"  > /dev/null
echo "$cmd" ; eval "$cmd"  > /dev/null
echo "$cmd" ; eval "$cmd"  > /dev/null
echo ''
cmd="bibexport -o $textName.bib $textName"
echo ''
echo "$cmd"
eval "$cmd"
echo ''
rm -f *bib-save* # Clean up potential junk files
