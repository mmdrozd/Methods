#!/bin/bash 

if [ $# -ne 3 ]
then
  echo "usage:   ${0##*/} <path> <file>"
  echo "example: ${0##*/} Methods/Data/Courses/Choice/LectureNotes/Investment/Handouts EntrepreneurPF private"
  exit 1
fi

pathName=$1
textName=$2
PubOrPri=$3

toolRoot=/Methods/Tools/Scripts

echo 'pathName='$pathName
echo 'textName='$textName
echo 'PubOrPri='$PubOrPri$

echo {{{ Starting $toolRoot/${0##*/} $pathName $textName $PubOrPri

if [ ! -e /$pathName ]; then
    echo Unable to cd /$pathName
    echo Pausing for user to fix
    read answer
fi
	    
echo cd /$pathName
     cd /$pathName

echo 'Compiling files in ' /$pathName

     sudo rm -Rf Web
echo sudo rm -Rf Web
     
mkdir Web
echo pwd
     pwd

if [ ! -e /$pathName/LaTeX ] ; then
    echo 'No LaTeX subdirectory in /$pathName/$textName.  Aborting in makeWeb.sh'
fi


echo cp  LaTeX/*.t*  Web
     cp  LaTeX/*.t*  Web
     # echo cp  LaTeX/*.bib Web
#      cp  LaTeX/*.bib Web
echo cp  LaTeX/*.sty Web
     cp  LaTeX/*.sty Web

if [ -e Figures ]; then
echo cp  Figures/*.* Web
     cp  Figures/*.* Web
fi

if [ -e Tables ]; then
echo cp  Tables/*.* Web
     cp  Tables/*.* Web
fi
if [ -e Equations ]; then
echo cp  Equations/*.* Web
     cp  Equations/*.* Web
fi
echo cp  LaTeX/*.bst Web
     cp  LaTeX/*.bst Web
echo cp  LaTeX/*.cls Web
     cp  LaTeX/*.cls Web
if [ -e LaTeX/config ]; then
echo cp  LaTeX/config/*  Web
     cp  LaTeX/config/*  Web
fi

# Have handled equations directories in far too many different ways     
if [ -f equations ];  then 
  echo cp  equations/* Web
       cp  equations/* Web
fi

if [ -f Equations ]; then 
  echo cp  Equations/* Web
       cp  Equations/* Web
fi

if [ -f eq ];  then 
  echo cp  eq/* Web
       cp  eq/* Web
fi

if [ ! -e /$pathName ]; then
    echo Unable to cd /$pathName/$textName
    echo Pausing for user to fix
    read answer
fi

echo cd /$pathName
     cd /$pathName

cd LaTeX
if [ -f LaTeX/eqns ]; then 
  echo cp  eqns/* ../Web
       cp  eqns/* ../Web
fi
if [ -f LaTeX/eq ]; then 
  echo cp  eq/* ../Web
       cp  eq/* ../Web
fi
cd ..

echo cd Web 
     cd Web
   pwd

if [ -f economics.bib ]; then
    rm economics.bib
fi

if [ -f $textName.bib ]; then
    rm $textName.bib
fi

echo Replacing tables figures etc
pwd 

# Replace '../[subdirectory]/' with ' ' in all files in the directory                                                               
# No need to use rpl because the whole point is to put everything on the first level                                                
# Also rpl doesn't work on network drives because of permissions problems

# syntax is that material between the first _ and the next one is to be replaced by material between the second _ and the final one

sed -i.bak  's_\.\./Tables/_\./_g' *.tex     # change ../Tables/    to ./
sed -i.bak  's_\.\./Equations/_\./_g' *.tex  # change ../Equations/ to ./
sed -i.bak  's_\./equations/_\./_g' *.tex    # change  ./equations/ to ./
sed -i.bak  's_\.\./eq/_\./_g' *.tex         # change ../eq/        to ./
sed -i.bak  's_\.\./Figures/_./_g' *.tex     # change ../Figures    to ./

# Sometimes equations have been put in a subdirectory ./eqns ./eq ./equations
sed -i.bak  's_\./eqns/_\./_g' *.tex       # change ./eqns/        to ./
sed -i.bak  's_\./eq/_\./_g' *.tex         # change ./eq/          to ./
sed -i.bak  's_\./equations/_\./_g' *.tex  # change ./equations/   to ./


# Replace other things to make the html version look better (larger tables, etc)                                                    
sed -i.bak  's/begin{table}[h]/begin{table}/g' *.tex
sed -i.bak  's/begin{table}[ht]/begin{table}/g' *.tex
sed -i.bak  's/begin{table}/begin{table} \\large/g' *.tex
sed -i.bak  's/begin{sidewaystable}\\small/begin{sidewaystable} \\large/g' *.tex
sed -i.bak  's/begin{table}\\small/begin{table} \\large/g' *.tex
sed -i.bak  's/{@{\\extracolsep{\\fill}}/{/g' *.tex
sed -i.bak  's/{tabular*}{\\textwidth}/{tabular}/g' *.tex
sed -i.bak  's/tabular*/tabular/g' *.tex
sed -i.bak  's/begin{document}/begin{document}\\large/g' *.tex
sed -i.bak  's/begin{abstract}/begin{abstract}\\large/g' *.tex

sudo rm *.bak

if [ $PubOrPri == "public" ];
  then
        echo "Removing private components from $f"
        echo "  -- First remove material between begin{CDCPrivate} and end{CDCPrivate} delimiters"
        echo "  -- Next remove any line that contains the string CDCPrivate"
        echo '  -- Then remove any lines containing two %% signs in a row'
  for f in $(find . -name '*.tex')
  do
        sed '/begin{CDCPrivate}/,/end{CDCPrivate}/d' $f > $f-tmp
        grep -v CDCPrivate $f-tmp > $f-tmp2
        sed '/%%/d' $f-tmp2 > $f
        rm $f-tmp $f-tmp2
  done
fi

# Needs to compile as dvi once (and with bibtex -terse  once) before invoking htlatex
echo rm  -f *.fff
     rm  -f *.fff

# In some former epoch, it was necessary to compile as a dvi once before invoking htlatex
# For some reason, now that appears to make htlatex fail with a mysterious error having to do with the bibliography
# So this is comented out (and should be eliminated if further experience indicates that it is really no longer useful)

# echo pwd
#      pwd
#      echo pdflatex -halt-on-error    -output-format dvi --shell-escape $textName '1> /dev/null' 
#           pdflatex -halt-on-error    -output-format dvi --shell-escape $textName  1> /dev/null
# [[ $? -eq 1 ]] && pdflatex -output-format dvi --shell-escape $textName  # If it failed, run visibly without capturing output

echo bibtex -terse  $textName
bibtex -terse  $textName

tex4htMakeCFG=`kpsewhich tex4htMakeCFG.sh`

echo /bin/bash $tex4htMakeCFG $textName
/bin/bash $tex4htMakeCFG $textName

if [ ! -f $textName.bib ]; then # The default bibliography system expects a file with this name (even if it is empty)
   touch $textName.bib
fi

if [ ! -f $textName-Add.bib ]; then  # The default bibliography system expects a file with this name (even if it is empty)
   touch $textName-Add.bib
fi

echo htlatex $textName \"tex4ht.styOptions\" \"tex4htPostProcessorOptions\" \"t4htPostProcessorOptions\" LaTeXCompilerOptions 
echo htlatex $textName "$textName,html,pic-tabular,pic-m,pic-array,pic-eqnarray,info" "" "" --shell-escape # > /dev/null
     htlatex $textName "$textName,html,pic-tabular,pic-m,pic-array,pic-eqnarray,info" "" "" --shell-escape # > /dev/null
#     htlatex $textName "$textName,html,pic-tabular,pic-tabbing,pic-m,pic-array,pic-eqnarray,pic-fbox,pic-align,pic-eqalign,pic-equation,info" "" "" --shell-escape
#     htlatex $textName "$textName,html,info" "" "" --shell-escape

bibexport -o $textName.bib $textName
sudo rm -f *-save-*

cp  $textName.html index.html
open index.html
echo pwd ; pwd

echo $toolRoot/${0##*/} $pathName $textName $PubOrPri Finishing }}}
