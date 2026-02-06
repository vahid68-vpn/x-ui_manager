#!/bin/bash
# ==========================================================
# manager | XUI Installer & Manager
# Telegram: @vahid68_vpn
# ==========================================================

set -euo pipefail

# ---------------- Colors ----------------
BOLD="\e[1m"
RESET="\e[0m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[97m"

# ---------------- Root Check ----------------
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}${BOLD}Please run as root${RESET}"
    exit 1
fi

# ---------------- Center Print ----------------
center_print() {
    local term_width
    term_width=$(tput cols)
    while IFS= read -r line; do
        local len=${#line}
        if (( len < term_width )); then
            local pad=$(( (term_width - len) / 2 ))
            printf "%*s%s\n" "$pad" "" "$line"
        else
            echo "$line"
        fi
    done
}

# ---------------- Banner ----------------
clear
echo -e "${CYAN}${BOLD}"
cat << 'EOF' | center_print
manager
      _  ____  ______       ___   __________ __________________    _   ________
     |   | |/ / / / /  _/      /   | / ___/ ___//  _/ ___/_  __/   |  / | / /_  __/
     |   |   / / / // / _____ / /| | \__ \\__ \ / / \__ \ / / / /| | /  |/ / / /
     |  /   / /_/ // / _____ / ___ |___/ /__/ // / ___/ // / / ___ |/ /|  / / /
     | /_/|_\____/___/      /_/  |_/____/____/___//____//_/ /_/  |_/_/ |_/ /_/
EOF
echo -e "${RESET}"

echo
printf "%*s%s\n" $(( ($(tput cols) - 22)/2 )) "" "Telegram: @vahid68_vpn"
echo

# ---------------- Manager Menu ----------------
SERVICE="x-ui"
while true; do
    echo -e "${MAGENTA}${BOLD}==== manager | Control Panel ====${RESET}"
    echo -e "${CYAN}1) Start Service${RESET}"
    echo -e "${CYAN}2) Stop Service${RESET}"
    echo -e "${CYAN}3) Restart Service${RESET}"
    echo -e "${CYAN}4) Enable on Boot${RESET}"
    echo -e "${CYAN}5) Disable on Boot${RESET}"
    echo -e "${CYAN}6) Service Status${RESET}"
    echo -e "${CYAN}7) View Logs (last 50)${RESET}"
    echo -e "${CYAN}8) Backup Configs${RESET}"
    echo -e "${CYAN}9) Restore Last Backup${RESET}"
    echo -e "${CYAN}10) Telegram Info${RESET}"
    echo -e "${CYAN}0) Exit${RESET}"
    echo
    read -p "Select option: " opt

    case $opt in
        1) systemctl start $SERVICE ;;
        2) systemctl stop $SERVICE ;;
        3) systemctl restart $SERVICE ;;
        4) systemctl enable $SERVICE ;;
        5) systemctl disable $SERVICE ;;
        6) systemctl status $SERVICE ;;
        7) journalctl -u $SERVICE -n 50 ;;
        8)
            BD="/root/manager_backup_$(date +%F_%H-%M-%S)"
            mkdir -p "$BD"
            cp -r /etc/x-ui "$BD/"
            echo -e "${GREEN}Backup created: $BD${RESET}"
            sleep 2
            ;;
        9)
            LAST=$(ls -dt /root/manager_backup_* 2>/dev/null | head -1)
            if [ -n "$LAST" ]; then
                cp -r "$LAST"/* /etc/x-ui/
                echo -e "${GREEN}Restored from $LAST${RESET}"
            else
                echo -e "${RED}No backup found${RESET}"
            fi
            sleep 2
            ;;
        10)
            echo -e "${GREEN}${BOLD}Telegram: @vahid68_vpn${RESET}"
            sleep 3
            ;;
        0) exit 0 ;;
        *) echo -e "${RED}Invalid option${RESET}"; sleep 1 ;;
    esac
done
