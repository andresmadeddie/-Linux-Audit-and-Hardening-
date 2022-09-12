# Linux Landmarks - Linux Audit and Hardening 

| Project links:| | |
| --- | --- | --- |
| [Linux Audit](/Main/Linux%20Audit.md) | [Dinamic Analysis](/Main/Dinamic%20Analysis.md) | [Linux Hardening](/Main/Linux%20Hardening.md) |


## About this Project 
This basic audit and hardening for a Linux system consist of a rapid automated audit, a file system verification, an audit of the processes, a dynamic analysis, and a system hardening.

![portada](/Images/portada.png)

## Content

- **Audit**

    - **Quick audit:**
    An automated Bash Script generates a file with the audit report.

    - **Audit File System:**
    Checks auth.log, scripts in the /tmp directory, user baseline, UIDs, GIDs, sudo privileges, sudoers file, passwords strength, and passwordless accounts.

    - **Audit of the processes:**
    Check for anomalies in processes behavior, such as excess CPU and memory usage.

- **Dynamic Analysis:** Use a sandbox to analyze a script.

- **Hardening:** Correct vulnerabilities found during the audit. Removing unauthorized users and unused services, updating permissions on sensitive files, and creating a new system user

## The Narrative behind the project

You will act as a Junior Linux Systems Administrator at Corp X. A senior administrator has asked you to audit a malfunctioning Linux server.

Audit:
The senior administrator has sent you a list of information to collect about the target system. You will use this information for further analysis. 

After completing a basic system audit and finding malicious script files and a user who was not supposed to be on the system, an investigation is carried out. This research includes checking all processes running on the system. 

Hardening:
Finally, corrective measures are taken. These measures include removing unauthorized users and groups, establishing privileges following the principle of least privilege, updating permissions on sensitive files, deleting unused or insecure services and system users, and creating a new system user required by the senior system administrator.

## Tools

|||||
|---|---|---|---|
| sudo | chmod | chown | usermod |
| rm | deluser | nano | id |
| systemctl | addgroup | delgroup | passwd |
| visudo | top | kill | apt |
|| grep | for Loops | find | adduser |
| If | cat | head | arrays |
| echo | nano | ls | mkdir |
| Built-In variables | Command Expansions | Brace Expansions | awk |