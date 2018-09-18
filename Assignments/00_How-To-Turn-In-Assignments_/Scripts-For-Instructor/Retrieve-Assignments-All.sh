#!/bin/bash

cd "$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script

for week in 01 02 03 04 05 06 07 08 09 10 11 12 13 14; do
    ./Retrieve-Assignments-For-Week.sh $week
done

