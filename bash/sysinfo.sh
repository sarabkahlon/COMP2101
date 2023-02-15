#!/bin/bash
#The purpose of this script is to display some important identity information about a computer 


A=$(lsb_release -d | awk '{print $2,$3,$4}')

B=$(hostname -I | awk '{print $1}')

C=$(df -h / |grep Avail -v |awk '{print $4}')


cat << EOF
Report for myvm
===============
FQDN: $(hostname)
Operating System name and version: $A
IP Address: $B
Root Filesystem Free Space: $C	
===============
EOF
