#!/bin/bash
# A 'local' version of the PDF should not have the empty economics.bib file or the filled $textName.bib file

if [ $# -ne 2 ]
then
  echo "usage:   ${0##*/} <path> <file>"
  echo "example: ${0##*/} /home/methods/Papers/BufferStockTheory/BufferStockTheory-Shared BufferStockTheory"
  exit 1
fi

pathName=$1
textName=$2

toolRoot=/Methods/Tools/Scripts

#pathName=/home/methods/Papers/BufferStockTheory/BufferStockTheory-Shared ; textName=BufferStockTheory
echo '{{{ Starting '
echo '' 
echo $toolRoot/${0##*/} $pathName $textName
echo ''

echo cd $pathName
     cd $pathName || { echo 'cd $pathName failed; exiting' ; exit 1; }
echo ''
echo 'pwd'
      pwd
echo ''

# If no local .bib files exist, make empty ones so that the \bibliography command will not choke
if [ ! -f $textName-Add.bib ] 
  then touch $textName-Add.bib
fi

# If local economics.bib file exists, delete it so that system default version will be used
if [ -f economics.bib ] 
  then rm economics.bib
fi

if [ -f $textName.bib ]; then
    rm -f $textName.bib
    touch $textName.bib
fi

#echo pwd
#     pwd

if [ ! -e $textName.tex ]; then 
  echo `pwd`/$textName.tex does not exist.  Halting ${0##*/}.
  exit 1
fi

echo pdflatex -halt-on-error --shell-escape \'\\newcommand\\UseOption\{PrintGeom,FromShell\}\\input\{\'$textName\'} ' 1> /dev/null '
     pdflatex -halt-on-error --shell-escape "\newcommand\UseOption{PrintGeom,FromShell}\input{$textName}" 1> /dev/null 
     (( $? ))        && pdflatex --shell-escape "\newcommand\UseOption{PrintGeom,FromShell}\input{$textName}" # If prior command generated an error exit condition, then repeat it visibly
bibtex -terse    $textName
echo pdflatex -halt-on-error --shell-escape \'\\newcommand\\UseOption\{PrintGeom,FromShell\}\\input\{\'$textName\'} ' 1> /dev/null '
													      pdflatex -halt-on-error    --shell-escape "\newcommand\UseOption{PrintGeom,FromShell}\input{$textName}"  1> /dev/null
[[ $? -eq 1 ]] && pdflatex --shell-escape "\newcommand\UseOption{PrintGeom,FromShell}\input{$textName}"  # If prior command generated an error exit condition, then repeat it visibly
echo pdflatex -halt-on-error --shell-escape \'\\newcommand\\UseOption\{PrintGeom,FromShell\}\\input\{\'$textName\'} ' 1> /dev/null '
													      pdflatex -halt-on-error    --shell-escape "\newcommand\UseOption{PrintGeom,FromShell}\input{$textName}"  1> /dev/null
[[ $? -eq 1 ]] && pdflatex --shell-escape "\newcommand\UseOption{PrintGeom,FromShell}\input{$textName}"  # If prior command generated an error exit condition, then repeat it visibly
echo pdflatex -halt-on-error --shell-escape \'\\newcommand\\UseOption\{PrintGeom,FromShell\}\\input\{\'$textName\'} ' 1> /dev/null '
													      pdflatex -halt-on-error    --shell-escape "\newcommand\UseOption{PrintGeom,FromShell}\input{$textName}"  1> /dev/null
[[ $? -eq 1 ]] && pdflatex --shell-escape "\newcommand\UseOption{PrintGeom,FromShell}\input{$textName}"  # If prior command generated an error exit condition, then repeat it visibly

/Methods/Tools/Scripts/bibtoolGet.sh $textName > ../$textName.bib

echo cd $pathName/..
     cd $pathName/..
     
echo '' ; 'You should be able to open '$textName.pdf ; echo ''

echo Finished $toolRoot/${0##*/} $pathName $textName }}}
echo ''
