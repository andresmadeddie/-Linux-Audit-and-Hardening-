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

    8. Check accounts with no passwords.

    `sudo awk -F: '$2 == "" { print $1 }' /etc/shadow`
    
    ![6d](/Images/6d.PNG)

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

    Users adam, billy, sally, and max should be part only of theirs primary and deverlopers groups. User Jack and group hax0rs must be removed.

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

        - Check if adam's group exists

            `cat /etc/group | grep adam` 

            ![17](/Images/17.PNG)

        - Check for an unassigned UID

            `cat /etc/passwd | awk -F : '{print $3}' | sort` 

            ![18](/Images/18.PNG)

        - Change UID and GID
            
            `sudo nano /etc/passwd`
        
            Manually Change adam's UID and GID from 0 to 1014 and 1009 respectively
        
           ![19](/Images/19.PNG)

           `Ctrl x`

           `y` 
           
           `enter`    
        
        - Check changes

            `id adam`

            ![20](/Images/20.PNG)

       
    3. Made users adam, billy, sally, and max part only of their primary and developers groups.
        - Create developers group

            `sudo addgroup developers`

        - Add users to developers group and exclude them form any other group

            `users=(adam billy sally max); for user in ${users[@]}; do sudo usermod -G developers $user; done`

        - Check changes

            `users=(adam billy sally max); for user in ${users[@]}; do echo -e "$user: $(id $user)"; done`
            
            ![21](/Images/21.PNG)

    4. Remove Group hax0rs

        - remove hx0rs

            `sudo delgroup hax0rs`

            ![22](/Images/22.PNG)

        - Verified Changes

            `cat /etc/group | grep hax0rs`

            ![23](/Images/23.PNG)

---

- ### Permissions

    1. Set sensitive files permissions and verify changes

        ```
        sudo chmod 600 /etc/shadow
        sudo chmod 600 /etc/gshadow
        sudo chmod 644 /etc/passwd
        sudo chmod 644 /etc/group
        ```       

        `ls -lah /etc | grep -e shadow -e gshadow -e psswd -e group`

        ![24](/Images/24.PNG)

---

- ### Disabling unused services
    Serivices to disable:
   
    - FTP (vsftpd.service)  
    - HTTP (apache2.service) (nginx.service)
   
    1. Check services
        `systemctl -t service --all`

        ![25](/Images/25.PNG)

    3. FTP (vsftpd.service)

        ```
        systemctl status vsftpd
        sudo systemctl stop vsftpd
        systemctl status vsftpd
        sudo systemctl disable vsftpd
        sudo apt remove -y ftp
        ```

        ![26](/Images/26.PNG)

    5. HTTP (apache2.service)

        ```
        systemctl status apache2
        sudo systemctl stop apache2
        systemctl status apache2
        sudo systemctl disable apache2
        sudo apt remove -y apache2
        ```

        ![27](/Images/27.PNG)

---

- ### Removing correponding service USERS
    Users to remove:
  
    - FTP
    - HTTP

    1. Check services Users

        `users=(ftp http); for user in ${users[@]}; do grep $user /etc/passwd && grep $user /etc/group; done`

        ![28](/Images/28.PNG)

    2. Remove Users
        
        `users=(ftp http); for user in ${users[@]}; do sudo deluser --remove-all-files $user; done`

    3. Verified Changes

          `users=(ftp http); for user in ${users[@]}; do grep $user /etc/passwd && grep $user /etc/group; done`

        ![29](/Images/29.PNG)
       
---

- ### Creating system users for software
    System users to install:

    - Tripware
    - Chkrootkit

    1. Tripware: create and verified, no home, system UID, No password, no loginshell. Give sudo privilege

        `sudo adduser --system --no-create-home tripware`
        `cat /etc/passwd | grep tripware`
        `ls /home | grep tripware`

        ![30](/Images/30.PNG)

        `sudo visudo`
        `tripwire ALL= NOPASSWD: /usr/sbin/tripwire`

        ![31](/Images/31.PNG)

    2. Chkrootkit

        `sudo adduser --system --no-create-home chkrootkit`
        `cat /etc/passwd | grep chkrootkit`
        `ls /home | grep chkrootkit`

        ![32](/Images/32.PNG)