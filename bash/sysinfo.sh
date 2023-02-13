#!/bin/bash
#The purpose of this script is to display some important identity information about a computer 

echo "Report for $(hostname)" 
echo "==============="
echo "FQDN:""`hostname`"
echo "Operating System name and version:""`lsb_release -d | awk '{print $2,$3,$4}'`"
#this script is used to display  operating system name and version tha only have only the distro name and version.
echo "IP addresses:""`hostname -I | awk '{print $1}'`"
echo "Root Filesystem Free Space: ""`df -h / | awk '{print $4}' | grep -v Avail`"
#this script is used to display  Only  free disk space number on the root filesystem space line
echo "==============="

