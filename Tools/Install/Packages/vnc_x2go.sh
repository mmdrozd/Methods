#!/bin/bash

# https://www.howtoforge.com/tutorial/x2go-server-ubuntu-14-04

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:x2go/stable
sudo apt-get update
sudo apt-get install x2goserver x2goserver-xsession

sudo apt-get install x2goclient

