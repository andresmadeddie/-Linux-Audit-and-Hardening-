- Audit
- Dinanic Analysis
- Hardening

---

## Audit

- ### Quick audit

    The next script give a general gist of the system. Information include Host name, Ip, user's priviledges, OS, RAM, CPU, disk, Processes, DNS, executables, and sensitive files permissions.

    Script: [QuickAudit](/quickAudit.sh)

    ` sudo ./quickAudit.sh`

    ![1](/Images/1.PNG)

    ![2](/Images/2.PNG)

    ![2a](/Images/2a.PNG)  

    ---

- ### Audit file system

    1. check auth.log for suspicious logins login attemps
        
        `cat /var/log/auth.log`
        
        ![3](/Images/3.png)
        ![3a](/Images/3a.png)

    2. check scripts in /tmp directory

        `ls -lah /tmp | grep '[-r][-w]x' | grep ^-`

        ![4](/Images/4.PNG)

    3. Check unmathched users between the /home directory and the baseline. 
        >###### note: The next script needs the file usersBaseline. You can downloades from this repository using the next link: `wget https://raw.githubusercontent.com/andresmadeddie/Linux-Hardenning-Auditing/main/Resources/usersBaseline.txt`

        `a=0; echo -e "\nUnmatched Users List:" && for user in $(ls /home); do if [ ! $(grep $user ~/usersBaseline.txt) ]; then echo $user && a=$(($a+1)); fi; done ; if [ $a -eq 0 ]; then echo "No unmatched users found"; fi`

        ![5](/Images/5.PNG)

    4. Check that only root is 0 UID

        `for user in $(ls /home); do echo -e "$user: $(id $user)"; done | grep uid=0`

        ![6](/Images/6.PNG)

    5. Check Users Sudo privileges

        `for user in $(ls /home); do echo -e "$user:\n$(sudo -lU $user)\n\n\n"; done`

        ![6a](/Images/6a.PNG)

        ![6ab](/Images/6ab.PNG)

        ![6ac](/Images/6ac.PNG)

    6. Check sudoers file

        `sudo cat /etc/sudoers`    

        ![6d](/Images/6d.PNG)

    7. Check Users and groups UID GID

        `for user in $(ls /home); do id $user; done`

        ![6e](/Images/6e.PNG)

    8. Check accounts with no passwords.

        `sudo awk -F: '$2 == "" { print $1 }' /etc/shadow`
        
        ![6f](/Images/6f.PNG)

    9. Check passwords strenght

        `sudo john /etc/shadow`
        
        ![6g](/Images/6g.PNG)

    10. View file user.hashes

        ![6h](/Images/6h.PNG)

    11. Check http user folders

        ![6i](/Images/6i.PNG)
        ![6j](/Images/6j.PNG)

    Observations: 
    
    - User Jack, http, and user .hashes does not match the baseline.
    - User Adam has 0 UID.
    - str.sh script exists on the /tmp directory owned by user Jack.
    - a9xk.sh script needs review.
    - Jack user has full sudo privilege.
    - Max user has less sudo privilege.
    - Jack is in the sudo Group.
    - Max is in the hax0rs group.
    - Weak passwords.
    - Passwords has been compromised.



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

    4. Kill all processes from user jack

        `sudo killall -u jack`

        ![10](/Images/10.PNG)

    5. Inspect processes were killed

        ![11](/Images/11.PNG)


    Observations: 

    The processes related to the script str.sh owned by user jack were consuming the CPU resources of the system generating an availability problem.

    ---

- ### Lynis Audit

    Update system, Install lynis, and audit system

    ```
    sudo apt update && apt -y upgrade

    sudo apt install -y lynis

    sudo lynis audit system
    ```

    ![11a](/Images/11a.PNG)

    >note: lynis analysis will not be included in this exercise
    ---
---

## Dinanic Analysis

After move a9xk.sh script to a sandbox, the next analysis is made.

1. Check Script
    `nano a9xk.sh`

    ![12](/Images/12.PNG)

2. run script

    `sudo ./a9xk.sh`

    ![12a](/Images/12a.PNG)

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

Observations:

Users adam, billy, sally, and max should be part only of theirs primary and deverlopers groups. User jack, user.hashes, http, and group hax0rs must be removed. hax0rs will be deleted as a file, jack will be deleted as a user, http will be  deleted as a user-service, and hax0rs as a group.

- 1. Permissions
- 2. Remove user.hashes file
- 3. Remove jack
- 4. Change Adam's UID
- 5. Assing users to corresponding group
- 6. Remove hax0rs group
- 7. Remove services http and ftp
- 8. Remove service-users http and ftp
- 9. Home Directory verificaton
- 10. Make users enter a new passwords on next login.
- 11. Aditional settings: Creating system users, Create a developers share folder

---

1. ### Permissions

    - Set sensitive files permissions and verify changes

        ```
        sudo chmod 600 /etc/shadow
        sudo chmod 600 /etc/gshadow
        sudo chmod 644 /etc/passwd
        sudo chmod 644 /etc/group
        ```       

        `ls -lah /etc | grep -e shadow -e gshadow -e passwd -e group`

        ![24](/Images/24.PNG)

        >Note: the backup files, like "shadow-", will update theirs permissions after change the files like adding or removing a user. (check remove service user at 8.5)

    - Remove max sudo privileges from the sudoers file

        `sudo visudo`

        manually remove the line `max  ALL=(ALL:ALL) /usr/bin/less` from the file
        | Before | After |
        | --- | --- |
        | ![24a](/Images/24a.PNG) | ![24b](/Images/24b.PNG) |

        ```
        Ctrl x
        y
        ```
---

2. ### Remove user.hashes file
    - Delete user.hashes
        
        `sudo rm /home/user.hashes`

        ![16](/Images/16.PNG)

---

3. ### Remove jack
       
    - Lock jack account.

        `sudo usermod -L jack`

        ![16a](/Images/16a.PNG)

    - Remove jack user.

        `sudo deluser --remove-home jack`

        ![16b](/Images/16b.PNG)

    - Check jack does not exists in the passwd file.

        `cat /etc/passwd | grep jack`

        ![16c](/Images/16c.PNG)

    - Check jack does not exists in the sudo group. 

        `cat /etc/group | grep sudo`

        ![16d](/Images/16d.PNG)

    - Check jack home directory is removed

    `ls /home | grep jack`
    
    ![16e](/Images/16e.PNG)

---

4. ### Change Adam's UID

    - Check if adam's group exists

        `cat /etc/group | grep adam` 

        ![17](/Images/17.PNG)

    - Check for an unassigned UID (1007 is available)

        `cat /etc/passwd | awk -F : '{print $3}' | sort` 

        ![18](/Images/18.PNG)

    - Change UID and GID
        
        `sudo nano /etc/passwd`

        Manually Change adam's UID and GID from 0 to 1007 and 1009 respectively

        ![19](/Images/19.PNG)

        ```
        Ctrl x
        y
        enter
        ```   

    - Check changes

        `id adam`

        ![20](/Images/20.PNG)
         
---

5. ### Assing users to corresponding group. Adam, billy, sally and max should belong only to developers and their main groups.

    - Create developers group

        `sudo addgroup developers`

        ![21](/Images/21.PNG)

    - Add users to developers group and exclude them form any other group

        `users=(adam billy sally max); for user in ${users[@]}; do sudo usermod -G developers $user; done`

        ![21a](/Images/21a.PNG)

    - Check changes

        `users=(adam billy sally max); for user in ${users[@]}; do echo -e "$user: $(id $user)"; done`
        
        ![21b](/Images/21b.PNG)

---

6. ### Remove hax0rs group

    - remove hx0rs

        `sudo delgroup hax0rs`

        ![22](/Images/22.PNG)

    - Verified Changes

        `cat /etc/group | grep hax0rs`

        ![23](/Images/23.PNG)

---

7. ### Remove services http and ftp
    Serivices to remove:
   
    - FTP (vsftpd.service)  
    - HTTP (apache2.service) (nginx.service)
   
    1. Check services

        `systemctl -t service --all`
        
        ![25](/Images/25.PNG)

        `q`

    3. FTP (vsftpd.service)

        ```
        systemctl status vsftpd
        sudo systemctl stop vsftpd
        systemctl status vsftpd
        sudo systemctl disable vsftpd
        sudo apt remove -y ftp
        ```

        ![26](/Images/26.PNG)

        ![26a](/Images/26a.PNG)

    5. HTTP (apache2.service)

        ```
        systemctl status apache2
        q
        sudo systemctl stop apache2
        systemctl status apache2
        q
        sudo systemctl disable apache2
        sudo apt remove -y apache2
        ```

        ![27](/Images/27.PNG)

        ![27a](/Images/27a.PNG)

---

8. ### Remove service-users http and ftp
    Service Users to remove:
  
    - FTP
    - HTTP

    1. Check services Users

        `users=(ftp http); for user in ${users[@]}; do grep $user /etc/passwd && grep $user /etc/group; done`

        ![28](/Images/28.PNG)

    2. Remove Users
        
        `users=(ftp http); for user in ${users[@]}; do sudo deluser --remove-all-files $user; done`

        ![28a](/Images/28a.PNG)
        
    3. Verified Changes

          `users=(ftp http); for user in ${users[@]}; do grep $user /etc/passwd && grep $user /etc/group; done`

        ![29](/Images/29.PNG)

    4. Check jack, http, and user.hashes home directory is removed.

        `ls /home`
        
        ![29a](/Images/29a.PNG)

    5. Check shadow file permissions

        `ls -lah /etc | grep -e shadow -e gshadow -e passwd -e group`

        ![29b](/Images/29b.PNG)


---
10. ### Make users enter a new passwords on next login.

    `for user in $(ls /home); do sudo passwd -e $user; done`

    ![29c](/Images/29c.PNG)

---

11. ### Aditional settings: 




    1. Tripwire: create and verified, no home, system UID, No password, no loginshell. Give sudo privilege

        `sudo adduser --system --no-create-home tripware`
        `cat /etc/passwd | grep tripware`
        `ls /home | grep tripware`

        ![30](/Images/30.PNG)

        `sudo visudo`
        `tripwire ALL= NOPASSWD: /usr/sbin/tripwire`

        ![31](/Images/31.PNG)
    
    1. Create Developers share folder

        ```
        mkdir /home/Developers
        chown Developers:Developers