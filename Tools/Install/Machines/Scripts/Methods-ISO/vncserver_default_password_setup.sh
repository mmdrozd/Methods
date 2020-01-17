#!/bin/bash
# https://askubuntu.com/questions/328240/assign-vnc-password-using-script
myuser="econ-ark"
mypass="kra-noce"
echo "$mypass" >  /tmp/vncpasswd # First is the read-write password
echo "$myuser" >> /tmp/vncpasswd # Next  is the read-only  password (useful for sharing screen with students)

[[ -e /home/$myuser/.vnc ]] && rm -Rf /home/$myuser/.vnc  # If a previous version exists, delete it
mkdir /home/$myuser/.vnc

vncpasswd -f < /tmp/vncpasswd > /home/$myuser/.vnc/passwd  # Create encrypted versions

# Give the files the right permissions
chown -R $myuser:$myuser /home/$myuser/.vnc
chmod 0600 /home/$myuser/.vnc/passwd

touch /home/$myuser/.bashrc_aliases

echo '# If not already running, launch the vncserver whenever an interactive shell starts' >> /home/$myuser/.bashrc_aliases
echo 'pgrep x0vncserver'  >> /home/$myuser/.bashrc_aliases
echo '[[ $? -eq 1 ]] && x0vncserver -display :0 -PasswordFile=/home/'$myuser'/.vnc/passwd >/dev/null 2>&1 &' >> /home/$myuser/.bashrc_aliases

