#!/bin/bash
# Starting from <directory>, recursively search for files ending in extension <ext> which contain <str> and print their paths then the line(s) containing the string
# The script outputs a command that, when copied-and-pasted onto the command line, should accomplish the specified task
# If the last word in the invocation of the script is "do", the script also executes its constructed command

# 2017-03-02: Rewrote for use on either Linux or Mac, for use in Methods course 

# This is a surprisingly hard problem; many online recommendations do not work on both Macs and Linux machines
# or have other problems
# http://www.commandlinefu.com/commands/view/4707/recursively-grep-thorugh-directory-for-string-in-file.
# http://superuser.com/questions/428493/how-can-i-do-a-recursive-find-and-replace-from-the-command-line/428494#428494

if [ $# -ne 5 ]; then
  echo "usage:   ${0##*/} <path to directory> <file extension> <src string> <rpl string> show|do "
  echo "example: ${0##*/} . tex 'fisher:interestTheory' 'fisherInterestTheory' do"
  exit 1
fi

path=$1
ext=$2
original=$3
replacement=$4
showOrDo=$5

echo showOrDo=$showOrDo

Do=false # Default to not do, only show the command 
if [ $showOrDo == "do" ]; then
    Do=true
fi

# listFilesThenShowChanges bundles together a command which, when it
# receives an x, finds and lists the matching files and does the
# substitution

# It's a bit tricky to construct because it needs to contain quotes
# but the quote mark is one of the tools used in Linux to demarcate
# the string itself; we need therefore to 'escape' the quotes (\" \")
# and engage in other ugliness to make the variable such that it will
# be produced in the form needed for the user to copy and paste

# It's probably not worth even attempting the mind-bending task of
# trying to interpret all of the combinations of escapes \" and single
# and double quote marks necessary to achieve this objective; instead
# just look at the resulting command

# There are two reasons we need to determine whether we're running MacOS or Linux:
# -- the default MacOS grep command is lame so we must use the gnu grep (ggrep) command as a substitute
# -- the default MacOS sed  command is BSD unix from 2005 and has different syntax than the Linux gnu sed command 
if [ `uname` == Linux ]; then 
    grepCmd='grep'
    listFilesThenShowChanges="for x ; do $grepCmd -RI --files-with-matches \"$original\" \"\$x\" ; $grepCmd -RI \"$original\" \"\$x\" ; sudo rm -f \"\$x.rpl\" ; LANG=C sed -e \"s|$original|$replacement|w /dev/stdout \" \"\$x\" > \"\$x.rpl\" ; sudo chown --reference \"\$x\" \"\$x.rpl\" ; sudo chmod --reference \"\$x\" \"\$x.rpl\" ; sudo mv \"\$x.rpl\" \"\$x\" ; done"
else # if not Linux must be MacOS
    grepCmd=ggrep # ggrep is a replacement that works the same as on Linux
    listFilesThenShowChanges="for x ; do $grepCmd -RI --files-with-matches -e \"$original\" \"\$x\" ; $grepCmd -RI -e \"$original\" \"\$x\" ; LANG=C sed -i \"\" \"s|$original|$replacement|w /dev/stdout\" \"\$x\" ; done"
fi

# In listFilesThenShowChanges, the first grep command prints the list
# of matching files to the terminal; the second grep command feeds
# them to sed, which sends the result to stdout where it is visible to
# the user.  

# In the MacOS version of the command, sed -i "", the -i "" flag
# allows it to replace the file in place.  Ccouldn't figure out how to
# make the gnu sed command do that, so the Linux command has to write
# the result to a file ending in .rpl, then overwrite the original
# file

# Below: 
# -not -name ".local*" prevents it from decending into localized files which generate errors
# -exec sh -c  excecutes the program defined in listFilesThenShowChanges in bash
# LANG=C : Tell sed that we will be using the default language (to prevent it from getting confused and thinking the files might be in some other language)

echo ''
echo 'A command that should work and has been pasted on the clipboard is:'
echo ''

# The command we are constructing looks line this:
# export LC_All=C ; cd $path ; sudo find . -type f -name "*.$ext" -not -path ".DocumentRevisions-V100*"   -not -path ".local*" -not -path ".Trash*" -exec sh -c "$listFilesThenShowChanges" _ {} +
#
# The ugliness below is mostly to deal with the difficulty of constructing strings with quotation marks

cdToPath='cd "'$path'" ; '
findAllFilesWithThisExtensionThatAreNotJunk='sudo find . -type f -name "*.'$ext'" -not -path ".DocumentRevisions-V100*" -not -path ".local*" -not -path ".Trash*" ' # Don't want to match MacOS trash or similar files -- could add some Linux candidates here
processTheReceivedFiles='-exec sh -c "$'listFilesThenShowChanges'" _ {} +' # exec is for execute; takes the result of what was done earlier on the line and acts upon it
# -c says the  commands are read from a string; google 'what-is-bin-sh-c'

command='export LC_All=C ; ' # Make sure it is using the default language -- otherwise it can try too many options and get confused
command+=$cdToPath           # Change to the path specified in the command 
command+=$findAllFilesWithThisExtensionThatAreNotJunk 
command+=$processTheReceivedFiles

echo -n 'listFilesThenShowChanges='"'"$listFilesThenShowChanges"'" "; " # The -n option prevents a newline so the result can be a one-liner
echo  "$command"
echo 'listFilesThenShowChanges='"'"$listFilesThenShowChanges"'" " ; " $command | pbcopy # pbcopy is a MacOS command but is aliased to an equivalent Linux command

oneliner=`pbpaste`

if [ "$Do" == true ]; then
    echo 'Executing the command above.'
    eval 
    eval $oneliner
else
    echo ''
    echo 'You did not end your command with "do" so it will only be shown to you and not executed.'
    echo ''
fi
    
