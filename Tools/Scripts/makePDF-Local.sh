#!/bin/bash

if [ $# -ne 2 ]
then
  echo "usage:   ${0##*/} <path> <file>"
  echo "example: ${0##*/} /Methods/Data/Papers/RepresentingWithoutRA/Latest/LaTeX RepresentingWithoutRA"
  exit 1
fi

pathName=$1
textName=$2

toolRoot=/Methods/Tools/Scripts

echo {{{ Starting $toolRoot/${0##*/} $pathName $textName

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

# Remove any files beginning with econtex* because they are not for the local but instead for the portable version
if test -n "$(find . -maxdepth 1 -name 'econtex*' -print -quit)"
then
    sudo rm econtex*.*
fi
# Remove any files beginning with handout* because they are not for the local but instead for the portable version
if test -n "$(find . -maxdepth 1 -name 'handout*' -print -quit)"
then
    sudo rm handout*.*
fi

# Remove any files beginning with bejournal* because they are not for the local but instead for the portable version
if test -n "$(find . -maxdepth 1 -name 'bejournal*' -print -quit)"
then
    sudo rm bejournal*.*
fi

if [ -f ReadMe.texmf ] 
  then rm -f ReadMe.texmf
fi

if [ -f $textName.bib ]; then
    rm -f $textName.bib
    touch $textName.bib
fi

if [ -f $textName-Add.readme ] 
  then rm -f $textName-Add.readme
fi

echo pwd
     pwd

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

     ln -fs ./LaTeX/$textName.pdf ./$textName.pdf
echo ln -fs ./LaTeX/$textName.pdf ./$textName.pdf
     
echo open   ./$textName.pdf
     open   ./$textName.pdf

echo Finished $toolRoot/${0##*/} $pathName $textName }}}
