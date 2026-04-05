#!/bin/bash

BASE="/home/cipher/lsavproject"

echo "===== BLOCKED PAIRS ====="
awk -F'|' '$2 > 30 {print $1,"score:",$2}' $BASE/pair_scores.db

echo
echo "===== RISKY IPS ====="
awk -F'|' '$2 > 40 {print $1,"score:",$2}' $BASE/ip_scores.db

echo
echo "===== SUSPICIOUS USERS ====="
awk -F'|' '$2 > 50 {print $1,"score:",$2}' $BASE/user_scores.db

echo
echo "===== RECENT ALERTS ====="
tail -10 $BASE/alerts.log
