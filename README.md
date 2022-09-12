Random task linux

This basic audit and hardening for a linux system consists in a quick automated audit, a manual file system check, a dinamic analysis, and hardening the system.

Quick audit
An automated Bash Script that outputs a file with audit report.

Audit file system
Check /tmp for scripts, auth.log, users in home, Root UID

Dinamic Analysis
Use a sandbox to analyse a suspicious script found in the /tmp directory.

Hardening
Correct vulnerabilities found during the audit. Manipulate Users and Groups to give the rights priviledges accordingly wiht less priviledge principle. Moreover, install packages for tripwire, lynis, and chkrootkit.

## Context
Linux Landmarks
You will act as a Junior Linux Systems Administrator at Corp X. A senior administrator has asked you to audit a malfunctioning Linux server.

Audit:
The senior administrator has sent you a list of information to collect about the target system. You will use this information for further analysis. 

After completing a basic system audit and finding some malicious script files and a user who was not supposed to be on the system, an investigation is carried out. This research includes checking all processes running on the system. 

Hardening:
Finally, corrective measures will be taken. These measures include removing unauthorized users and groups, establishing privileges following the principle of least privilege, updating permissions on sensitive files, deleting unused or insecure services and system users, and creating a new system user required by the senior system administrator.