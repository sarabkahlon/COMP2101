#!/bin/bash

echo " `hostnamectl`"
#this command is used to read and edit  the  system hostnmae related settings.
echo "FQDN: $(hostname)"
#this command shows system hostname  information
echo "Root Filesystem Status:"
echo "`df -h /`"
# this command generally shows how much free space is availible  in the file system.
echo "IP addresses:"
echo "`hostname -I`"
#this command shows the  current  ip address used by the system
