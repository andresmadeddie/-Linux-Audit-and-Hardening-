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

        `for users in $(ls /home); do id $users; done | grep uid=0`

        ![6](/Images/6.PNG)

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

# Hardening

## Hardening
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



