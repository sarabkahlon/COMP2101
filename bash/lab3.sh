#!/bin/bash

#task1: installing lxd 
if [ -e "/var/snap/lxd" ];then
	echo "lxd is already installed"
else
	echo "Installing lxd"
	sudo snap install lxd
fi

#task2:lxdbr0 interface exists or not 
if [ ["ip l | grep lxdbr0 >/dev/null" ];then
	echo "lxdbr0 interface exists"
else
	echo "Initializing lxdbr0 interface"
	lxd init --auto
fi

#task3:  launching a container 
if [ "lxc list | grep COMP2101-S22 >/dev/null" ];then
	echo "lxd container COMP2101-S22 is already exist"
else
	echo "Launching Com2101-22 container"
	lxc launch ubuntu:22.04 COMP2101-S22
fi

#task4:add or update the entry in /etc/hosts for hostname COMP2101-S22 with the container’s current IP address
if [ "grep -q COMP2101-S22 /etc/hosts >/dev/null" ];then
	echo "COMP2101-S22 host entry updated"
else
	echo "Adding COMP2101-S22 entry in hosts file"
	echo "$IP COMP2101-S22" | sudo gedit /etc/hosts
fi

#task5:instalingl Apache2 in the container
if [ "lxc exec COMP2101-S22 service apache2 status >/dev/null" ];then
	echo "apache2 is already installed"
else
	echo "Installing apache2 in Container"
	lxc exec COMP2101-S22 -- apt install apache2
fi

#task6:  retrieve the default web page from the container’s web service with curl http://COMP2101-S22 and notify the user of success or failure
if [ "curl -s COMP2101-S22 >/dev/null" ];then
	echo "the default web page is successfully retrieve"
else
	echo "error exists"
fi 



