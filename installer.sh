#!/bin/bash
# ==========================================================
# manager | Rebranded XUI Installer & Manager
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

clear

# ---------------- Banner ----------------
echo -e "${CYAN}${BOLD}"
cat << 'EOF'
manager
      _  ____  ______       ___   __________ __________________    _   ________
     |   | |/ / / / /  _/      /   | / ___/ ___//  _/ ___/_  __/   |  / | / /_  __/
     |   |   / / / // / _____ / /| | \__ \\__ \ / / \__ \ / / / /| | /  |/ / / /
     |  /   / /_/ // / _____ / ___ |___/ /__/ // / ___/ // / / ___ |/ /|  / / /
     | /_/|_\____/___/      /_/  |_/____/____/___//____//_/ /_/  |_/_/ |_/ /_/
EOF
echo -e "${RESET}"
echo -e "${GREEN}${BOLD}Telegram: @vahid68_vpn${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# ---------------- System Update ----------------
echo -e "${BLUE}${BOLD}▶ Updating system...${RESET}"
apt update -y && apt upgrade -y

# ---------------- Dependencies ----------------
echo -e "${BLUE}${BOLD}▶ Installing dependencies...${RESET}"
deps=(curl wget jq sudo lsof net-tools unzip)
for p in "${deps[@]}"; do
    if ! dpkg -s "$p" &>/dev/null; then
        echo -e "${YELLOW}Installing $p...${RESET}"
        apt install -y "$p"
    else
        echo -e "${GREEN}$p already installed${RESET}"
    fi
done

# ---------------- Backup ----------------
BACKUP_DIR="/root/manager_backup_$(date +%F_%H-%M-%S)"
mkdir -p "$BACKUP_DIR"
if [ -d "/etc/x-ui" ]; then
    cp -r /etc/x-ui "$BACKUP_DIR/"
    echo -e "${GREEN}Backup saved: $BACKUP_DIR${RESET}"
fi

# ---------------- Install XUI ----------------
INSTALLER_URL="https://raw.githubusercontent.com/dev-ir/xui-assistant/master/installer.sh"
TMP_INSTALLER="/tmp/manager_installer.sh"

echo -e "${BLUE}${BOLD}▶ Downloading core installer...${RESET}"
curl -Ls "$INSTALLER_URL" -o "$TMP_INSTALLER"
chmod +x "$TMP_INSTALLER"
bash "$TMP_INSTALLER"

# ---------------- Manager Menu ----------------
MENU_FILE="/usr/local/bin/manager"
cat << 'EOF' > "$MENU_FILE"
#!/bin/bash

BOLD="\e[1m"
RESET="\e[0m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
MAGENTA="\e[35m"

SERVICE="x-ui"

while true; do
    clear
    echo -e "${MAGENTA}${BOLD}==== manager | XUI Control Panel ====${RESET}"
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
    echo ""
    read -p "Select option: " opt

    case
