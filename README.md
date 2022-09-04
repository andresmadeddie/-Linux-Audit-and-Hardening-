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