# https://askubuntu.com/questions/328240/assign-vnc-password-using-script
myuser="econ-ark"
mypasswd="kra-noce"

mkdir /home/$myuser/.vnc
echo "$mypasswd" | vncpasswd -f > /home/$myuser/.vnc/passwd
chown -R $myuser:$myuser /home/$myuser/.vnc
chmod 0600 /home/$myuser/.vnc/passwd

touch /home/$myuser/.bashrc_aliases
echo 'x0vncserver -display :0 >/dev/null 2>&1 &' >> /home/$myuser/.bashrc_aliases

