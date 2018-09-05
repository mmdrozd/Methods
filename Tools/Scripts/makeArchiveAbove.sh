#!/bin/bash 

# Makes public and private versions of the archives in the appropriate directory depending on file type
# First argument is the "root" directory containing the master source
# Second argument is the name of the file to be compiled in the LaTeX directory, which will also be the name of the -Pub and -Pri archives

if [ $# -ne 3 ]
then
  echo "usage:   ${0##*/} <root> <fileName> handout | paper | topic | question | code"
  echo "example: ${0##*/} Methods/Data/Courses/Choice/LectureNotes/Consumption/Handouts/2PeriodLCModel 2PeriodLCModel handout"
  echo "example: ${0##*/} Methods/Data/Papers/RepresentingWithoutRA RepresentingWithoutRA paper"
  echo "example: ${0##*/} Methods/Data/Courses/Choice/Questions/FriedmanPIH FriedmanPIH question"
  echo "example: ${0##*/} Methods/Data/Topics/NumericalMethods SolvingMicroDSOPs paper"
  exit 1
fi

pathRoot=$1 
textName=$2 
docType=$3  

toolsPath=Methods/Tools/Scripts

cd /$toolsPath
echo ''
echo {{{ Starting `pwd`/${0##*/} $pathRoot $textName $docType
echo ''

pathAboveRoot=$pathRoot/..

badType="true"

if [ $docType == "handout" ]; then
  badType="false"
fi

if [ $docType == "codeArchive" ]; then
  badType="false"
fi

if [ $docType == "question" ]; then
  badType="false"
fi

if [ $docType == "paper" ]; then
  badType="false"
fi

if [ $docType == "topic" ]; then
  badType="false"
fi

if [ $badType == "true" ]; then 
  echo The type $badType is not defined.  Aborting.
  exit 1
fi

if [ ! -d  /$pathRoot ]
  then echo Directory /$pathToTeX does not exist.  Aborting.
  exit 1
fi

if [ -e /$pathRoot/make-private/makeLinks.sh ]; then
    /$pathRoot/make-private/makeLinks.sh
fi

echo ''
echo 'Make local version to be sure everything is in sync.'
echo ''

echo /$toolsPath/makePDF-Local.sh /$pathRoot/LaTeX $textName 
     /$toolsPath/makePDF-Local.sh /$pathRoot/LaTeX $textName 

if [ -e /$toolsPath/makeSlides.sh ]; then 
echo /$toolsPath/makePDF-Local.sh /$pathRoot/Slides $textName 
     /$toolsPath/makePDF-Local.sh /$pathRoot/Slides $textName 
fi

echo ''
echo Deleting any already-existing zip file because puzzling things happen if they are not deleted first
echo ''

echo cd /$pathAboveRoot
     cd /$pathAboveRoot || { echo 'cd /$pathAboveRoot failed; exiting' ; exit 1; }
echo pwd
     pwd

if       [ -f $textName-Pri.zip ]; then
echo  sudo rm   -f $textName-Pri.zip
      sudo rm   -f $textName-Pri.zip
echo  sudo rm  -Rf $textName-Pri
      sudo rm  -Rf $textName-Pri
fi

if       [ -f $textName-Pub.zip ]; then
echo  sudo rm   -f $textName-Pub.zip
      sudo rm   -f $textName-Pub.zip
echo  sudo rm  -Rf $textName-Pub
      sudo rm  -Rf $textName-Pub
fi

if  [ -f $textName-Private.zip ]; then
  sudo rm  -f $textName-Private.zip
  sudo rm  -f $textName-Public.zip
fi

echo cd /$pathRoot
     cd /$pathRoot || { echo 'cd /$pathRoot failed; exiting' ; exit 1; }

if [ `uname` == "Darwin" ]; then # Remove mac-specific nuisance files
    find . -name '.DS_Store' -type f -delete
    find . -name 'Icon*'     -type f -delete
    find . -type d | xargs dot_clean -m
fi

echo 'Creating zip archives excluding unwanted files (exclude private directories from public archive)'
echo 'Preserve symlinks as symlinks in the private archive; replace them with the referenced files in the public archive.'

echo zip -r -q ../$textName-Pri.zip * -x                   \*.DS_Store \*~ \*auto\* \*.cmd \*.command \*Old\* \*texput\* \*Web\* \*MyNotes.* \*.ftp \*.bak \*.sav \*~ \*Old\*  \*auto\* \*synctex.gz\* \*.aux\* \*.bbl\* \*.4tc\* \*.4ct\* \*.4blg\* \*.blg\* \*.dvi\* \*.ent\* \*.fff\* \*.lof\* \*.log\* \*.tmp\* \*.ttt\* \*.xref\* \*.out\* \*.nav\* \*.snm\* \*.toc\* \*.pyg\* \*_region_.tex\*
     zip -r -q ../$textName-Pri.zip * -x                   \*.DS_Store \*~ \*auto\* \*.cmd \*.command \*Old\* \*texput\* \*Web\* \*MyNotes.* \*.ftp \*.bak \*.sav \*~ \*Old\*  \*auto\* \*synctex.gz\* \*.aux\* \*.bbl\* \*.4tc\* \*.4ct\* \*.4blg\* \*.blg\* \*.dvi\* \*.ent\* \*.fff\* \*.lof\* \*.log\* \*.tmp\* \*.ttt\* \*.xref\* \*.out\* \*.nav\* \*.snm\* \*.toc\* \*.pyg\* \*_region_.tex\*
echo zip -r -q ../$textName-Pub.zip * -x                   \*.DS_Store \*~ \*auto\* \*.cmd \*.command \*Old\* \*texput\* \*Web\* \*MyNotes.* \*.ftp \*.bak \*.sav \*~ \*Old\*  \*auto\* \*synctex.gz\* \*.aux\* \*.bbl\* \*.4tc\* \*.4ct\* \*.4blg\* \*.blg\* \*.dvi\* \*.ent\* \*.fff\* \*.lof\* \*.log\* \*.tmp\* \*.ttt\* \*.xref\* \*.out\* \*.nav\* \*.snm\* \*.toc\* \*.pyg\* \*_region_.tex\* \*Private\* \*private\*
     zip -r -q ../$textName-Pub.zip * -x                   \*.DS_Store \*~ \*auto\* \*.cmd \*.command \*Old\* \*texput\* \*Web\* \*MyNotes.* \*.ftp \*.bak \*.sav \*~ \*Old\*  \*auto\* \*synctex.gz\* \*.aux\* \*.bbl\* \*.4tc\* \*.4ct\* \*.4blg\* \*.blg\* \*.dvi\* \*.ent\* \*.fff\* \*.lof\* \*.log\* \*.tmp\* \*.ttt\* \*.xref\* \*.out\* \*.nav\* \*.snm\* \*.toc\* \*.pyg\* \*_region_.tex\* \*Private\* \*private\*

echo ''
echo Making directories for public and private archives

echo cd /$pathAboveRoot
     cd /$pathAboveRoot

if [ -d ./$textName-Pub ]; then
  echo sudo rm -Rf ./$textName-Pub
       sudo rm -Rf ./$textName-Pub
fi
if [ -d ./$textName-Pri ]; then
  echo sudo rm -Rf ./$textName-Pri
       sudo rm -Rf ./$textName-Pri
fi
echo mkdir  ./$textName-Pub
     mkdir  ./$textName-Pub
echo mkdir  ./$textName-Pri
     mkdir  ./$textName-Pri

echo ''
echo Unpacking temporary zip into created $textName-Pub directory 
echo ''
echo cd /$pathAboveRoot/$textName-Pub
     cd /$pathAboveRoot/$textName-Pub
echo unzip -qo ../$textName-Pub.zip
     unzip -qo ../$textName-Pub.zip

echo Unpacking temporary zip into created $textName-Pri directory 
echo cd /$pathAboveRoot/$textName-Pri
     cd /$pathAboveRoot/$textName-Pri
echo unzip -qo ../$textName-Pri.zip
     unzip -qo ../$textName-Pri.zip

echo Now make portable versions of LaTeX directory

echo pwd
     pwd 
echo /$toolsPath/makePDF-Portable.sh /$pathAboveRoot/$textName-Pri/LaTeX $textName private
     /$toolsPath/makePDF-Portable.sh /$pathAboveRoot/$textName-Pri/LaTeX $textName private
echo /$toolsPath/makePDF-Portable.sh /$pathAboveRoot/$textName-Pub/LaTeX $textName public
     /$toolsPath/makePDF-Portable.sh /$pathAboveRoot/$textName-Pub/LaTeX $textName public

if [ $docType != "question" ]; then 
if [ $docType != "codeArchive" ]; then
echo Now make portable Web directories

echo /$toolsPath/makeWeb.sh $pathAboveRoot/$textName-Pri $textName private
     /$toolsPath/makeWeb.sh $pathAboveRoot/$textName-Pri $textName private
echo /$toolsPath/makeWeb.sh $pathAboveRoot/$textName-Pub $textName public
     /$toolsPath/makeWeb.sh $pathAboveRoot/$textName-Pub $textName public
fi
fi

cd /$pathAboveRoot/$textName-Pub
sudo rm  -f /$pathAboveRoot/$textName-Pub.zip
zip -r -q /$pathAboveRoot/$textName-Pub.zip . 

cd /$pathAboveRoot/$textName-Pri
sudo rm  -f /$pathAboveRoot/$textName-Pri.zip
zip -r -q /$pathAboveRoot/$textName-Pri.zip . 

echo Finished `pwd`/${0##*/} $pathRoot $textName $docType }}}
