# LSAV – SSH Security Project

## About the Project

In this project we try to detect ssh attack on users and ip on our server.
we monitor failed ssh login attempts by assigning risk scores to users and ip and user-ip pairs. These risk score help us to take action.

The goal of the project is to:

* Read Logs in linux using journalctl.
* Understand and Use PAM (Pluggable Authentication Modules).
* Detect Diffrent type of attack.

## Files in Project

monitor.sh
Main script that monitors failed SSH logins and updates risk scores accordingly. 

pam_decision.sh
Script that decides whether to allow or block login.

report.sh
script to generate report of attack.

## How it works

1. monitor.sh reads failed SSH attempts from journalctl.
2. Scores get updated for users, ip and user-ip pairs.
3. Alerts are also generated if suspicious behaviour is detected.
4. pam_decision.sh checks scores during login.
5. Login can be allowed, delayed or denied.

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


## Testing ( local )

Run ./monitor.sh

In Other Tab:

Generate failed logins:

for i in {1..30}; do ssh wronguser@127.0.0.1; done

Check scores:

cat /home/cipher/lsavproject/pair_scores.db

Check alerts:

cat /home/cipher/lsavproject/alerts.log



