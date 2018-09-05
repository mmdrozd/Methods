#!/bin/bash
# This is how to change the current working directory (cwd) in a script to the directory that the script ives in

cd "$(dirname "$0")" # http://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script

