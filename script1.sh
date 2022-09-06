# Define packages list
packages=(
    'nano'
    'wget'
    'net-tools'
)

# Loop though the list of packages and check to see if they are installed

for package in ${packages[@]}

do
    if [ $(which $package) ]
    then
        echo "$package is installed at $(which $package)."
    else
        echo "$package is not installed."
    fi
done


# Search each user's home directory for scripts and provide a formatted output.
for user in $(ls /home)
do   
    for item in $(find /home/$user -iname '*.sh')
    do
        echo -e "Found a script in $user's home folder! \n$item"
    done
done


# Loop through scripts in my scripts folder and set permissions to executable
for script in $(ls ~/scripts)
do
    if [ ! -x ~/scripts/$script ]
    then
        chmod +x ~/scripts/$script
    fi
done


# Command to see the exit code or exit value. 0 success and 1 for failure
echo $


# Loop through a list of files and create a hash of each file.
for file in $(ls ~/Documents/files_for_hashing/)
do
    sha256sum $file
done

# For loops on command line
for user in $(ls /home); do echo "Username is: $user"; done

# Create 10 directories
for num in {1..10}; do mkdir my_dir_$num; done

###############################################################################################
# QUICK SETUP SCRIPT FOR NEW SERVER
#! /bin/bash

# Make sure the script is run as root.
if [ ! $UID -ne 0 ]
then
echo "Please run this script with sudo."
  exit
fi

# Create a log file that our script will use to track its progress
log_file=/var/log/setup_script.log

#-------------------------------------------------------------------------------------------#

# Log file header
echo "Log file for general server setup script." >> $log_file
echo "############################" >> $log_file
echo "Log generated on: $(date)" >> $log_file
echo "############################" >> $log_file
echo "" >> $log_file

#-------------------------------------------------------------------------------------------#
# CHECK AND INSTALL PACKAGES
# List of necessary packages
packages=(
  'nano'
  'wget'
  'net-tools'
  'python'
  'tripwire'
  'tree'
  'curl'
)

# Ensure all packages are installed
for package in ${packages[@]}
do
  if [ ! $(which $package) ]
  then
    apt install -y $package
  fi
done

# Print it out and Log it
echo "$(date) Installed needed pacakges: ${packages[@]}" | tee -a $logfile

#-------------------------------------------------------------------------------------------#
#CREATE ADMIN USERS
# Create the user sysadmin with no password (password to be created upon login)
useradd sysadmin
chage -d 0 sysadmin

# Add the ryan user to the `sudo` group
usermod -aG sudo ryan

# Print and log
echo "$(date) Created sys_admin user. Password to be created upon login" | tee -a $log_file

#-------------------------------------------------------------------------------------------#
# HARDEN THE SYSTEM
# Remove roots login shell and lock the root account.
usermod -s /sbin/nologin root
usermod -L root

# Print and log
echo "$(date) Disabled root shell. Root user cannot login." | tee -a $log_file

# Change permissions on sensitive files
chmod 600 /etc/shadow
chmod 600 /etc/gshadow
chmod 644 /etc/group
chmod 644 /etc/passwd

# Print and log
echo "$(date) Changed permissions on sensitive /etc files." | tee -a $log_file

#-------------------------------------------------------------------------------------------#
#CREATE PERSONAL SCRIPT FOLDER
# Setup scripts folder
if [ ! -d /home/ryan/scripts ]
then
mkdir /home/ryan/scripts
chown ryan:ryan /home/ryan/scripts
fi

# Add scripts folder to .bashrc for ryan
echo "" >> /home/ryan/.bashrc
echo "PATH=$PATH:/home/ryan/scripts" >> /home/ryan/.bashrc
echo "" >> /home/ryan/.bashrc


# Print and log
echo "$(date) Added ~/scripts directory to sysadmin's PATH." | tee -a $log_file


Adding a few custom aliases might be nice too!

```bash
# Add custom aliases to /home/ryan/.bashrc
echo "#Custom Aliases" >> /home/ryan/.bashrc
echo "alias reload='source ~/.bashrc && echo Bash config reloaded'" >> /home/ryan/.bashrc
echo "alias lsa='ls -a'" >> /home/ryan/.bashrc
echo "alias docs='cd ~/Documents'" >> /home/ryan/.bashrc
echo "alias dwn='cd ~/Downloads'" >> /home/ryan/.bashrc
echo "alias etc='cd /etc'" >> /home/ryan/.bashrc
echo "alias rc='nano ~/.bashrc'" >> /home/ryan/.bashrc

# Print and log
echo "$(date) Added custom alias collection to sysadmin's bashrc." | tee -a $log_file

#-------------------------------------------------------------------------------------------#
#END OF THE SCRIPT
#Print out and log Exit
echo "$(date) Script Finished. Exiting."
echo "$(date) Script Finished. Exiting." >> $log_file

exit