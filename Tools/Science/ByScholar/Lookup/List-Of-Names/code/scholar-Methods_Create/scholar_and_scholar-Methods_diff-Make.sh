#!/bin/bash

diff -u ../scholar.py ../scholar-Methods.py | tee scholar_and_scholar-Methods.diff

# If you have DeltaWalker installed, try
# DeltaWalker ../scholar.py ../scholar-Methods.py 
