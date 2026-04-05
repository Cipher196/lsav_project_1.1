# LSAV – SSH Login Security Project

## About the Project

This project is a simple SSH intrusion detection system made for Linux System Administration course.
It monitors failed SSH login attempts and assigns risk scores to IP addresses and users. Based on these scores, the system can delay or block suspicious login attempts using PAM.

The goal of the project is to understand:

* Linux logs
* PAM (Pluggable Authentication Modules)
* Basic intrusion detection ideas
* Bash scripting

## Files in Project

monitor.sh
Main script that monitors failed SSH logins and updates risk scores.

pam_decision.sh
PAM script that decides whether to allow or block login.

## How it works

1. monitor.sh reads failed SSH attempts from journalctl
2. Scores are updated for IP and user
3. Alerts are generated if suspicious behaviour is detected
4. pam_decision.sh checks scores during login
5. Login is allowed, delayed or denied

## Setup

Make scripts executable:

chmod +x monitor.sh
chmod +x pam_decision.sh

Create working directory:

mkdir -p /home/cipher/lsavproject

Add PAM rule:

sudo nano /etc/pam.d/sshd

Add line:

auth required pam_exec.so /home/cipher/debian_codespace/linux_project/pam_decision.sh

Restart ssh:

sudo systemctl restart ssh

## Running

Start monitor:

sudo ./monitor.sh

## Testing

Generate failed logins:

for i in {1..30}; do ssh wronguser@127.0.0.1; done

Check scores:

cat /home/cipher/lsavproject/pair_scores.db

Check alerts:

cat /home/cipher/lsavproject/alerts.log



