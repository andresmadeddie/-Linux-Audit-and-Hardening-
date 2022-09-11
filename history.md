Linux Landmarks

you will act as a Junior Linux Systems Administrator at Corp X. A senior administrator has asked you to audit a malfunctioning Linux server.

Audit:

The senior administrator has sent you a list of information to gather about the target system. You will use this information for further analysis. After completed a basic audit of the system and found some malicious script files and a user that was not supposed to be on the system, an investigation takes place. This investigation includes to check all the processes running on the system to check if there are any obvious processes that should not be running. Likewise to review the a script in a isolate environment. 


Your senior administrator has asked that you record snapshots of processes, as well as review the processes in real time for anything suspicious.


You must review the processes that are running on the system to make sure nothing is amiss. If it is, you will want to kill that process and add what you found to your report


---
Now that we have stopped a malicious service from running and completed a basic audit, we're now going to cover some of the miscellaneous utilities that we can install onto our VMs. Specifically we'll install the following services:


emacs is a traditional file editor.

cowsay is a utility that takes in input and displays a cow repeating it.

fortune is a utility that will give you a random proverb that may be interesting to the user.

---
n this activity, your senior administrator has asked you to audit the strength of users' passwords by using the john program and document any passwords that you find.
To complete these tasks, you will use the program john the ripper on the password file you viewed from Day 1. You will use john to crack the passwords for several users on the system.

---
So far, we have been using administrator privileges to stop processes, install software, copy sensitive files, run programs, and edit configuration files.
Now that we know users had weak passwords, we want to make sure none of them have unauthorized sudo access. The next steps provided by your senior administrator have to do with locking access to the compromised system, including sudo access.
In this activity, you will explore the sudo + less exploit, shown in the previous demonstration, and check the compromised system in order to determine if it is vulnerable. You will also edit the sudoers file to remove sudo access. Being able to determine what users or processes have root access and why is a core skill for a system administrator.

---

In our previous activity, we tightened sudo access across the system by editing the sudoers file. The administrator has asked that we audit all the users and groups on the system, create a new group for the standard users, and remove users from the sudo group. In our previous activities we found some malicious users, and we will want to remove them from the system altogether.
We want to follow the principle of least privilege to make sure that users on the system only have the correct access. Despite the changes we have made so far, there are still unauthorized users in groups who have access to sensitive data.
Your senior systems administrator has asked you to audit these groups and remove both unauthorized users as well as suspicious groups.
To complete these tasks, your senior administrator has asked that you do the following:


Check every user's UID and GID.


Make sure that only the sysadmin account is in the sudoers group.


If you find a user that is part of the sudoers group, remove them from that group and document your findings.


Remove any users from the system that should not be there.


Verify that all non-admin users are part of the group developers. If the developers group doesn't exist, create it and add the users. We can use this group later to configure file sharing among these users.


The users adam, billy, sally, and max should only be members of the developers group and their own ("primary") groups. If you find any groups other than this, document the group and remove it.

---
During the last activity, we cleaned up the system's groups and users and removed all the malicious users. We also removed users from the sudo group and found and removed a rogue group.
Your senior administrator now wants you to secure a few important files and directories. Recall that during our scavenger hunt yesterday, we talked about the sensitive files on the system that contain all the users (/etc/passwd), the passwords (/etc/shadow), and the groups (/etc/group).
This activity will give you an opportunity to practice inspecting and setting file permissions on these sensitive files. Use the checklist provided by your senior administrator in the Instructions section for information on which files to inspect and modify permissions for.
You'll use the same lab environment you used in the previous exercises:


---
n this activity, you will continue with an audit of the services running on the server.
Your senior administrator wants you to audit the services and shut down insecure and/or unused services. They have provided a list of services to check.
You will check for these services and shut down and remove any that you find running on the server.

Instructions
Your senior administrator provided the following notes:


Some of our systems may have old services running that are no longer used. Because services can be exploited, we want to run as few of them as possible. The services we should check for are:


File Transfer Protocol (FTP): This file sharing service is outdated, insecure, and easily exploitable. Cybercriminals often use it to upload malicious files, so we need it removed immediately.


Telnet: We used to use Telnet to get a shell on this server from a remote computer. This allowed us to easily reconfigure the server while not being in the office. Unfortunately, Telnet is notoriously insecure and easily hacked. Remove it so no one can log in to this machine remotely.


HTTP: HTTP is used to send files over the Internet and host websites. This server is not supposed to be hosting websites, so stop and remove this service.


Bonus: IMAP and/or POP3: These services are used to send and receive email. This server should not be managing emails, so stop and remove these services.


Bonus: Network Information Service: This is an old service that provides information about the entire network. Attackers often use this to gather information about this server and other machines on the network, which they can use to break in more easily. Stop and remove this service to prevent attackers from doing so.

---
In the previous activity, we stopped and removed a few old services from the system.


In this activity, you will continue auditing the same server for your senior administrator.


The senior administrator would like you to remove any old service users from the system and create a new user that will be dedicated to running the Tripwire program.


To complete this activity, you will use the adduser and deluser commands with the correct flags to clean up the system and create this new Tripwire user.

Tripwire can only be run as root, so you will also need to add a line to the sudoers file to allow this.




Instructions


To clean up our system and to prevent any unwanted abuse of remnant service users, remove the following service users associated with the services that you removed in the previous activity:


Service users for the vsftpd service


Note: If you are stuck on where to find these service users, you can search through /etc/passwd for clues.




Create a tripwire user that will be dedicated to running Tripwire.





