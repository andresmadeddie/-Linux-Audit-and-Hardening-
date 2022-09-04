#!/bin/bash

# Check that the script runs as root
if [ $UID -ne 0 ]; then echo "Please run this script with sudo privileges." && exit; fi

# Define Commands Variables
ip=$(ip addr | grep inet | tail -2 | head -1)
execs=$(sudo find /home -type f -perm 777 2>/dev/null)
cpu=$(lscpu | grep CPU)
disk=$(df -H | head -2)
processes=$(ps -aux --sort -%mem | awk {'print $1, $2, $3, $4, $11'} | head)

# Define Path and create file
sysInfo=$HOME/audit/sys_info$(date +"%Y%m%d%H%M%S").txt

# Sensitive files
files=('/etc/passwd /etc/shadow')

#Check for audit directory. Create it if needed.
if [ ! -d $HOME/audit ]; then mkdir $HOME/audit; fi

# Audit Information
echo -e "\n\nQuick System Audit\n\n$(date)\n\n" >>$sysInfo
echo -e "Machine Type     : $MACHTYPE" >>$sysInfo
echo -e "Host name        : $(hostname -s)" >>$sysInfo
echo -e "Ip Address       : $ip" >>$sysInfo
echo -e "Current user     : /n$(who -a | tail -1 | awk {'print $1'})" >>$sysInfo
echo -e "User's privileges: $(sudo -l | tail -n +5)\n" >>$sysInfo
echo -e "OS & Hardware: \n$(uname -a)\n" >>$sysInfo
echo -e "Memory:\n$(free)\n" >>$sysInfo
echo -e "CPU:\n$cpu\n" >>$sysInfo
echo -e "Disk Usage:\n$disk\n" >>$sysInfo
echo -e "DNS:$(cat /etc/resolv.conf | tail -n +5)\n" >>$sysInfo
echo -e "Top 10 processes:\n$processes" >>$sysInfo
echo -e "\nList of current user's executable files:" >>$sysInfo
for exec in $execs; do echo $exec; done >>$sysInfo
echo -e "\nSensitive files permisisions:" >>$sysInfo
for file in $files; do echo $(ls -l $file); done >>$sysInfo

# End
echo -e "\nEnd of Audit\n" >>$sysInfo
echo "View report at $sysInfo"

