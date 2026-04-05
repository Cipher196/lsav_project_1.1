#!/bin/bash

USER="$PAM_USER"
IP="$PAM_RHOST"

[[ -z "$USER" ]] && exit 0
[[ -z "$IP" ]] && IP="LOCAL"

BASE_DIR="/home/cipher/lsavproject"
mkdir -p "$BASE_DIR"

LOG_FILE="$BASE_DIR/auth_tracker.log"
ALERT_FILE="$BASE_DIR/alerts.log"



IP_SCORE_FILE="$BASE_DIR/ip_scores.db"
USER_SCORE_FILE="$BASE_DIR/user_scores.db"
PAIR_SCORE_FILE="$BASE_DIR/pair_scores.db"

touch "$IP_SCORE_FILE" "$USER_SCORE_FILE" "$PAIR_SCORE_FILE"

get_score() {
    file="$1"
    key="$2"
    val=$(grep "^$key|" "$file" | cut -d'|' -f2)
    [[ -z "$val" ]] && echo 0 || echo "$val"
}

pair="$IP->$USER"

ip_score=$(get_score "$IP_SCORE_FILE" "$IP")
user_score=$(get_score "$USER_SCORE_FILE" "$USER")
pair_score=$(get_score "$PAIR_SCORE_FILE" "$pair")

# ----------------------------
# DECISION (same logic as before)
# ----------------------------

if [[ "$IP" == "127.0.0.1" || "$IP" == "::1" ]]; then
    exit 0
fi

if [ "$pair_score" -gt 30 ]; then

    # adaptive delay
    delay=$((pair_score / 10))

    if [ "$delay" -gt 5 ]; then
        delay=5
    fi

    sleep "$delay"

    exit 1
fi


if [ "$ip_score" -gt 40 ]; then
    exit 1
fi

# DO NOT hard block user (avoid DoS)
if [ "$user_score" -gt 50 ]; then
    sleep 2   # slow down attacker
fi

exit 0   #  allow
