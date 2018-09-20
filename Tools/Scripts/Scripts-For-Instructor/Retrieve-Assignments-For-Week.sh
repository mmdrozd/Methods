#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage:   ${0##*/} <week>" 
    echo "example: ${0##*/} 02"
    exit
fi

week=$1
# week=03
scriptRoot="$(dirname "$0")"
echo scriptRoot=$scriptRoot

for assignmentPath in /Methods/Assignments/$week*; do
    echo assignmentPath=$assignmentPath
    assignmentBase="$(basename $assignmentPath)"
    echo assignmentBase=$assignmentBase
    assignmentName="${assignmentBase%.*}"
    echo assignmentName=$assignmentName
echo $scriptRoot/Assignment-Gather_By-Assignment_For-All-Students.sh $assignmentName
     $scriptRoot/Assignment-Gather_By-Assignment_For-All-Students.sh $assignmentName
done

		  
		  
