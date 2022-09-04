#Copy system log, shadow, passwd, and hosts files into a research directory
mkdir /~reseach && sudo cp -r /var/log/* /etc/passwd /etc/shadow /etc/hosts ~/research

# List of executables files
sudo find /home -type f -perm 777 > ~/research/execlist.txt

# List 10 most active processes
ps aux --sort -%mem " awk {'print $1, $2, $3, $4, $11'} " head > ~/research/topproceess.txt

# List users with UID > 1000
ls /home > ~research/users.txt && cat /etc/passw | awk -F":" '{if ($3 >= 1000 print $0}' >> ~/research/users.txt

#list ip
echo -e 'IP info: $(ip.addr | head -9 | tail -1) \n'

$SUPER $HOME $SHELL $PWD $BASH $HOSTNAME $MACHTYPE $UID $PATH
