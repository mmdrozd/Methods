#!/bin/bash

cd "$(dirname "$0")"

sudo cp -p ./010_Basic_Config_/home/methods/.config/autostart/start_terminal.desktop /home/methods/.config/autostart
sudo chown methods:methods /home/methods/.config/autostart
