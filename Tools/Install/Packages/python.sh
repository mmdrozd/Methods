#!/bin/bash

# https://www.digitalocean.com/community/tutorials/how-to-install-python-3-and-set-up-a-programming-environment-on-an-ubuntu-16-04-server

sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get install -y python-pip
sudo apt-get install -y python-setuptools

sudo apt-get install -y python3-pip
sudo apt-get install -y python3-setuptools
