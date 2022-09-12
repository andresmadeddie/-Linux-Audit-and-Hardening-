# Hardening

Observations:

Users adam, billy, sally, and max should be part of their primary groups and developers group only. The jack user, the user.hashes file, the http system user with its respective service, and the hax0rs group must be removed. Sensitive file permissions must be updated and passwords must be reset at the next login. Additionally, the removal of the ftp service and the addition of a system user for tripwire have been required. Likewise, a shared folder should be created for the group of developers.

- 1. Permissions.
- 2. Remove user.hashes file.
- 3. Remove jack.
- 4. Change Adam's UID.
- 5. Assing users to the corresponding group.
- 6. Remove hax0rs group.
- 7. Remove services http and ftp.
- 8. Remove system-users http and ftp.
- 9. Home Directory verification.
- 10. Make users enter new passwords on the next login.
- 11. Remove roots login shell and lock the root account.
- 12. Additional settings: 
    - Create a system user for tripwire.
    - Create developers share folder.

---
---

1. ## Permissions

    - Set sensitive files permissions and verify changes.

        ```
        sudo chmod 600 /etc/shadow
        sudo chmod 600 /etc/gshadow
        sudo chmod 644 /etc/passwd
        sudo chmod 644 /etc/group
        ```       

        `ls -lah /etc | grep -e shadow -e gshadow -e passwd -e group`
        
        ![24](/Images/24.PNG)

        >Note: backup files, such as "shadow-", will update their permissions after a change to the parent file, such as adding or removing a user. (check image at [8.5](https://github.com/andresmadeddie/Linux-Hardenning-Auditing/blob/main/Main/Linux%20Hardening.md#remove-service-users-http-and-ftp))

    - Remove user max sudo privileges from the sudoers file.

        `sudo visudo`

        manually remove the line `max  ALL=(ALL:ALL) /usr/bin/less` from the file.
        | Before | After |
        | --- | --- |
        | ![24a](/Images/24a.PNG) | ![24b](/Images/24b.PNG) |

        ```
        Ctrl x
        y
        ```
---

2. ## Remove user.hashes file

    - Delete user.hashes.
        
        `sudo rm /home/user.hashes`

        ![16](/Images/16.PNG)

---

3. ## Remove jack
       
    - Lock jack account.

        `sudo usermod -L jack`

        ![16a](/Images/16a.PNG)

    - Remove jack user.

        `sudo deluser --remove-home jack`

        ![16b](/Images/16b.PNG)

    - Check jack does not exist in the passwd file.

        `cat /etc/passwd | grep jack`

        ![16c](/Images/16c.PNG)

    - Check jack does not exist in the sudo group. 

        `cat /etc/group | grep sudo`

        ![16d](/Images/16d.PNG)

    - Check jack's home directory is removed.

        `ls /home | grep jack`
        
        ![16e](/Images/16e.PNG)

---

4. ## Change Adam's UID

    - Check if adam's group exists.

        `cat /etc/group | grep adam` 

        ![17](/Images/17.PNG)

    - Check for an unassigned UID. (1007 is available)

        `cat /etc/passwd | awk -F : '{print $3}' | sort` 

        ![18](/Images/18.PNG)

    - Change UID and GID.
        
        `sudo nano /etc/passwd`

        Manually Change adam's UID and GID from 0 to 1007 and 1009 respectively.

        ![19](/Images/19.PNG)

        ```
        Ctrl x
        y
        enter
        ```   

    - Check changes.

        `id adam`

        ![20](/Images/20.PNG)
         
---

5. ## Assing users to the corresponding group. 

    > Adam, billy, sally, and max should belong only to developers and their main groups.

    - Create a developers group.

        `sudo addgroup developers`

        ![21](/Images/21.PNG)

    - Add users to the developer's group and exclude them from any other group.

        `users=(adam billy sally max); for user in ${users[@]}; do sudo usermod -G developers $user; done`

        ![21a](/Images/21a.PNG)

    - Verify changes.

        `users=(adam billy sally max); for user in ${users[@]}; do echo -e "$user: $(id $user)"; done`
        
        ![21b](/Images/21b.PNG)

---

6. ## Remove hax0rs group

    - Remove hx0rs.

        `sudo delgroup hax0rs`

        ![22](/Images/22.PNG)

    - Verify changes.

        `cat /etc/group | grep hax0rs`

        ![23](/Images/23.PNG)

---

7. ## Remove services http and ftp
    Services to remove:   

    - FTP. (vsftpd.service)  
    - HTTP. (apache2.service) (nginx.service)
    
    ---

    1. Check services.

        `systemctl -t service --all`
        
        ![25](/Images/25.PNG)

        `q`

    2. Remove FTP. (vsftpd.service)

        ```
        systemctl status vsftpd
        sudo systemctl stop vsftpd
        systemctl status vsftpd
        sudo systemctl disable vsftpd
        sudo apt remove -y ftp
        ```

        ![26](/Images/26.PNG)

        ![26a](/Images/26a.PNG)

    3. Remove HTTP. (apache2.service)

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

8. ## Remove service-users http and ftp
    Service Users to remove:
  
    - FTP
    - HTTP

    ---

    1. Check services Users.

        `users=(ftp http); for user in ${users[@]}; do grep $user /etc/passwd && grep $user /etc/group; done`

        ![28](/Images/28.PNG)

    2. Remove Users.
        
        `users=(ftp http); for user in ${users[@]}; do sudo deluser --remove-all-files $user; done`

        ![28a](/Images/28a.PNG)
        
    3. Verified Changes.

          `users=(ftp http); for user in ${users[@]}; do grep $user /etc/passwd && grep $user /etc/group; done`

        ![29](/Images/29.PNG)

    4. Verify the home directories http, jack, and user.hashes are removed.

        `ls /home`
        
        ![29a](/Images/29a.PNG)

    5. Check shadow file permissions

        `ls -lah /etc | grep -e shadow -e gshadow -e passwd -e group`

        ![29b](/Images/29b.PNG)

---

10. ## Make users enter new passwords on the next login

    `for user in $(ls /home); do sudo passwd -e $user; done`

    ![29c](/Images/29c.PNG)

---


11. ## Remove roots login shell and lock the root account.

```
sudo usermod -s /sbin/nologin root
sudo usermod -L root
```

![29d](/Images/29d.PNG)

---

12. ## Aditional settings: 

    1. Tripwire:

        - Create a system user.
            
            `sudo adduser --system --no-create-home tripwire`

        - Verified user has no password, no login shell, and a UID of less than 1000.

            `cat /etc/passwd | grep tripwire`
        
        - Verified user has no home directory

            `ls /home | grep tripwire`

            ![30](/Images/30.PNG)

        - Give system user sudo privilege when run.

            `sudo visudo`
            `tripwire ALL= NOPASSWD: /usr/sbin/tripwire`

            ![31](/Images/31.PNG)
    
    1. Create a developer's share folder.

        - Create a Folder.

            `sudo mkdir -p /home/developers`

        - change ownership of the directory to the developer's group

            `sudo chown :developers /home/developers`
            
        ![31](/Images/31.PNG)
