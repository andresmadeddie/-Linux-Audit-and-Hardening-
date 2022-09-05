- Audit
- Dinanic Analysis
- Hardening

---

## Audit

- ### Quick audit

    The next script give a general gist of the system. Information include Host name, Ip, user's priviledges, OS, RAM, CPU, disk, Processes, DNS, executables, and sensitive files permissions.

    Script: [QuickAudit](/QuickAudit.sh)

    ` sudo ./quickAudit.sh`

    ![1](/Images/1.PNG)

    ![2](/Images/2.PNG)

    ---

- ### Audit file system

    1. check auth.log for suspicious logins login attemps

         ![3](/Images/3.PNG)      

    2. check scripts in /tmp directory

        `ls -lah /tmp | grep '[-r][-w]x' | grep ^-`

         ![4](/Images/4.PNG)

    3. Check unmathched users between the /home directory and the baseline. 

        `a=0; echo -e "\nUnmatched Users List:" && for user in $(ls /home); do if [ ! $(grep $user ~/usersBaseline.txt) ]; then echo $user && a=$(($a+1)); fi; done ; if [ $a -eq 0 ]; then echo "No unmatched users found"; fi`

        ![5](/Images/5.PNG)

    4. Check that only root is 0 UID

        `for user in $(ls /home); do echo -e "$user: $(id $user)"; done | grep uid=0`

        ![6](/Images/6.PNG)

    5. Check Users Sudo privileges

        `for user in $(ls /home); do echo -e "$user:\n$(sudo -lU $user)\n\n\n"; done`

        ![6a](/Images/6a.PNG)

    6. Check sudoers file

        `sudo cat /etc/sudoers`    

        ![6b](/Images/6b.PNG)

    7. Check Users and groups UID GID

        `for user in $(ls /home); do id $user; done`

        ![6c](/Images/6c.PNG)

    Observations: 
    
    - User Jack does not match the baseline.
    - User Adam has 0 UID
    - str.sh script exists on the /tmp directory owned by user Jack.
    - Jack user has full sudo privilege
    - Max user has less sudo privilege
    - Jack is in the sudo Group
    - Max is in the hax0rs group

        ---

- ### Audit processes

    1. Check running processes, sort by CPU

            ```
            top
            x
            ```

        ![7](/Images/7.PNG)

    2. Account: task started by host, sleeping tasks, and CPU usage.

        ![8](/Images/8.PNG)

    3. Sort by user of interest

        ```
        u
        jack
        ```

        ![9](/Images/9.PNG)

    4. Kill all processes from user

        `sudo killall -u jack`

        ![10](/Images/10.PNG)

    5. Inspect processes

        ![11](/Images/11.PNG)


    Observations: 

    Processes were running in the system related to the script str.sh owned by user jack.

    ---

- ### Lynis Audit

    Update system, Install lynis, and audit system

        ```
        sudo apt update && apt upgrade

        sudo apt install -y linys

        sudo lynis audit system
        ```

    ---
---

## Dinanic Analysis

Use a sandbox to analyse a suspicious script.

1. Check Script
    `nano a9xk.sh`

    ![12](/Images/12.PNG)

2. run script

    `sudo ./a9xk.sh`

3. inspect processes

    `top`

    ![13](/Images/13.PNG)

4. Kill processes by command

    `sudo killall stress`

    ![14](/Images/14.PNG)

5. Inspect processes


    ![15](/Images/15.PNG)

---

## Hardening

- ### Groups - Users
    Observations:

    Users adam, billy, sally, and max should be part only of thir primary and deverlopers groups. User Jack must be removed.

    1. Remove Jack user
        - Lock account

            `sudo usermod -L jack`      

        - Remove user

            `sudo deluser --remove-home --remove-all-files jack`

        - Check user does not exists in the passwd file

            `cat /etc/passwd |grep jack`

        - Check user does not exists in the sudo group 

            `cat /etc/group | grep sudo`

        ![16](/Images/16.PNG)

    2. Change Adam's UID

        - Look for a GID availability

            `cat /etc/group | awk '{print $3}' FS=':' | sort`

            ![17](/Images/17.PNG)

        - Check UID availablity
            
            `cat /etc/passwd | awk '{print $3}' FS=':' | sort`
            
            ![18](/Images/18.PNG)

        - Change UID and GID
        
            'sudo usermod -u 1014 -G 1014
        
        `sudo usermod -u 

    3. Made users adam, billy, sally, and max part only of their primary and developers groups.
        - Create developers group

            `sudo addgroup developers`

        - Add users to developers group and exclude them form any other group

            `users=(adam billy, sally, max); for user in ${users[@]}; do sudo usermod -G developers $user; done`

    4. Check changes

        `for user in ${users[@]}; do echo -e "$user: $(id $user)"; done`





Correct vulnerabilities found during the audit. Manipulate Users and Groups to give the rights priviledges accordingly wiht less priviledge principle. Moreover, install packages for tripwire, lynis, and chkrootkit.
Audit with lynis
    
2) Dinamic analysis
run script in sandbox
top
ps aux |less
sudo kill <PID>
killall <PROCESS NAME>
Check with top and ps aux

HARDENING
Disable unused SERVICES
systemctl -t service --all
systemctl status smbd
sudo systemctl stop smbd
sudo apt remove samba
//enable and start //

Disable correponding service USERS
grep ftp /etc/passwd
grep ftp /etc/group
sudo deluser --remove-all-files ftp


INSTALLING TRIPWARE
sudo adduser --system --no-create-home tripware
suoders

chkrootkit

put users in the correct group



