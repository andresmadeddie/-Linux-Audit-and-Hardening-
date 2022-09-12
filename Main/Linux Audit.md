# Audit

- Quick Audit
- File System Audit
- Process Audit
- Lynis
- Chkrootkit

---
---

- ## Quick audit

    Script: [quickAudit](/Resources/quickAudit.sh)

    The quickAudit script gives a general gist of the system. Information includes:


    | | | |
    | --- | --- | --- |
    | - Host name | - Ip | - User's privileges |
    | - OS | - RAM | - CPU |
    | - Disk | - Processes | - DNS |
    | - Executables | - Sensitive files permissions.

    | `sudo ./quickAudit.sh` | ![1](/Images/1.PNG) |
    |--|--|
    | ![2](/Images/2.PNG) | ![2a](/Images/2a.PNG) |

---
---

- ## File System Audit

    1. check auth.log for suspicious logins login attempts.
        
        `cat /var/log/auth.log`
        
        ![3](/Images/3.png)
        ![3a](/Images/3a.png)

    2. check scripts in the /tmp directory.

        `ls -lah /tmp | grep '[-r][-w]x' | grep ^-`

        ![4](/Images/4.PNG)

    3. Check unmatched users between the /home directory and the baseline.
        
        >###### note: The following script requires the file usersBaseline. To download from this repository use this: 
        >###### `wget https://raw.githubusercontent.com/andresmadeddie/Linux-Hardenning-Auditing/main/Resources/usersBaseline.txt`

        `a=0; echo -e "\nUnmatched Users List:" && for user in $(ls /home); do if [ ! $(grep $user ~/usersBaseline.txt) ]; then echo $user && a=$(($a+1)); fi; done ; if [ $a -eq 0 ]; then echo "No unmatched users found"; fi`

        ![5](/Images/5.PNG)

    4. Check that only the root user has UID 0.

        `for user in $(ls /home); do echo -e "$user: $(id $user)"; done | grep uid=0`

        ![6](/Images/6.PNG)

    5. Check Users' sudo privileges.

        `for user in $(ls /home); do echo -e "$user:\n$(sudo -lU $user)\n\n\n"; done`

        ![6a](/Images/6a.PNG)

        ![6ab](/Images/6ab.PNG)

        ![6ac](/Images/6ac.PNG)

    6. Check the sudoers file.

        `sudo cat /etc/sudoers`    

        ![6d](/Images/6d.PNG)

    7. Check users' UID and groups' GID.

        `for user in $(ls /home); do id $user; done`

        ![6e](/Images/6e.PNG)

    8. Check accounts with no passwords.

        `sudo awk -F: '$2 == "" { print $1 }' /etc/shadow`
        
        ![6f](/Images/6f.PNG)

    9. Check users' password strength.

        `sudo john /etc/shadow`
        
        ![6g](/Images/6g.PNG)

    10. View file user.hashes.

        ![6h](/Images/6h.PNG)

    11. Check http user folders.

        ![6i](/Images/6i.PNG)
        ![6j](/Images/6j.PNG)

    ---
        
    **Observations:** 

    - Users Jack, http, and user .hashes do not match the baseline.
    - User Adam has a 0 UID.
    - str.sh script exists on the /tmp directory owned by user Jack.
    - a9xk.sh script needs review.
    - Jack user has full sudo privilege.
    - Max user has sudo privilege through command less.
    - Jack is in the sudo group.
    - Max is in the hax0rs group.
    - Users have weak passwords.
    - Passwords have been compromised.

---
---

- ## Process Audit

    1. Check running processes, and sort by CPU.

        ```
        top
        x
        ```

        ![7](/Images/7.PNG)

    2. **Be aware of:** tasks started by the host, sleeping tasks, and CPU usage.

        ![8](/Images/8.PNG)

    3. Sort by the user of interest.

        ```
        u
        jack
        ```

        ![9](/Images/9.PNG)

    4. Kill all processes from user jack.

        `sudo killall -u jack`

        ![10](/Images/10.PNG)

    5. Inspect processes were killed.

        ![11](/Images/11.PNG)

    ---

    **Observations:** 

    Processes related to the str.sh script owned by user jack were consuming the system's CPU resources, causing an availability issue.

---
---

- ### Lynis Audit

    Update system, Install lynis, and audit system.

    ```
    sudo apt update && apt -y upgrade

    sudo apt install -y lynis

    sudo lynis audit system
    ```

    ![11a](/Images/11a.PNG)

---
---

- ### Chkrootkit

    sudo apt install chrootkit

    ![11b](/Images/11b.PNG)

    sudo chkrootkit -x

    ![11c](/Images/11c.PNG)