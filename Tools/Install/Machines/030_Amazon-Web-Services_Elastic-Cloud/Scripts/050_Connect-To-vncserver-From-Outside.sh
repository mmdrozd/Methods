#!/bin/bash
# Client needs to connect to EC2 Server

# 0. login again from the CONNECTING machine with a command something like this

ssh -L 5901:localhost:5901 -i carrollcd-methods.pem ubuntu@ec2–52–90–172–228.compute-1.amazonaws.com

# 0. Make sure the vncserver is running on the remote machine via the `vncserver` command (once the above command connects)

# 0. Connect to it from the original machine via a client like remmina
# You will need to direct the vnc server to localhost:5901



