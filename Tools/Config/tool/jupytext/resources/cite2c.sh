#!/bin/bash

source ~/.bashrc
[[ ! `pip list | grep cite2c` != '' ]] && pip install cite2c && python -m cite2c.install


