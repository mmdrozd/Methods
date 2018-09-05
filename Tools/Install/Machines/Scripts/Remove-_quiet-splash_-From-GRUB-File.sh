#!/bin/bash

su -

cd /etc/default
cp grub grub.orig
sed -i 's/quiet splash//g' grub
diff grub grub.orig
update-grub


