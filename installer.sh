#!/bin/bash
# ===============================================
# XUI Advanced Installer & Manager Script (Enhanced)
# ===============================================
# وحید جان عزیزم، نسخه زیبا با رنگ‌بندی و مدیریت کامل

set -euo pipefail

# ------------------------------
# Color Palette
# ------------------------------
BOLD="\e[1m"
RESET="\e[0m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[97m"

# ------------------------------
# Check root
# ------------------------------
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}${BOLD}Please run as root${RESET}"
    exit 1
fi

# ------------------------------
# Step 1: Update & Upgrade
# ------------------------------
echo -e "${CYAN}${BOLD}=== Step 1: Update & Upgrade System ===${RESET}"
apt update && apt upgrade -y

# ------------------------------
# Step 2: Install Dependencies
# ------------------------------
echo -e "${CYAN}${BOLD}=== Step 2: Install Dependencies ===${RESET}"
dependencies=(curl wget jq sudo lsof net-tools unzip)
for pkg in "${dependencies[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        echo -e "${YELLOW}Installing $pkg...${RESET}"
        apt install -y "$pkg"
    else
        echo -e "${GREEN}$pkg already installed${RESET}"
    fi
done

# ------------------------------
# Step 3: Backup Existing Configs
# ------------------------------
backup_dir="/root/xui_backup_$(date +%F_%T)"
mkdir -p "$backup_dir"
if [ -d "/etc/x-ui" ]; then
    echo -e "${CYAN}Backing up /etc/x-ui to $backup_dir${RESET}"
    cp -r /etc/x-ui "$backup_dir/"
fi

# ------------------------------
# Step 4: Download & Install XUI
# ------------------------------
installer_url="https://raw.githubusercontent.com/dev-ir/xui-assistant/master/installer.sh"
tmp_script="/tmp/xui_installer.sh"

echo -e "${CYAN}Downloading installer...${RESET}"
curl -Ls "$installer_url" -o "$tmp_script"
chmod +x "$tmp_script"

echo -e "${CYAN}Running installer...${RESET}"
bash "$tmp_script"

# ------------------------------
# Step 5: Create Enhanced Menu
# ------------------------------
menu_file="/usr/local/bin/xui-menu"
cat << 'EOF' > "$menu_file"
#!/bin/bash
# ===============================================
# XUI Management Menu (Enhanced)
# ===============================================
BOLD="\e[1m"
RESET="\e[0m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[97m"

service_name="x-ui"

while true; do
    echo -e "${MAGENTA}${BOLD}==== XUI Management Menu ====${RESET}"
    echo -e "${CYAN}1) Start Service${RESET}"
    echo -e "${CYAN}2) Stop Service${RESET}"
    echo -e "${CYAN}3) Restart Service${RESET}"
    echo -e "${CYAN}4) Enable Service on Boot${RESET}"
    echo -e "${CYAN}5) Disable Service on Boot${RESET}"
    echo -e "${CYAN}6) Show Service Status${RESET}"
    echo -e "${CYAN}7) View Last 50 Logs${RESET}"
    echo -e "${CYAN}8) Backup Current Configs${RESET}"
    echo -e "${CYAN}9) Restore Last Backup${RESET}"
    echo -e "${CYAN}10) Telegram Channel Info${RESET}"
    echo -e "${CYAN}11) Exit${RESET}"
    read -p "Choose an option [1-11]: " choice
    case $choice in
        1) systemctl start $service_name ;;
        2) systemctl stop $service_name ;;
        3) systemctl restart $service_name ;;
        4) systemctl enable $service_name ;;
        5) systemctl disable $service_name ;;
        6) systemctl status $service_name ;;
        7) journalctl -u $service_name -n 50 ;;
        8) 
            backup_dir="/root/xui_backup_$(date +%F_%T)"
            mkdir -p "$backup_dir"
            cp -r /etc/x-ui "$backup_dir/"
            echo -e "${GREEN}Backup saved to $backup_dir${RESET}"
            ;;
        9) 
            last_backup=$(ls -dt /root/xui_backup_* | head -1)
            if [ -d "$last_backup" ]; then
                cp -r "$last_backup"/* /etc/x-ui/
                echo -e "${GREEN}Restored backup from $last_backup${RESET}"
            else
                echo -e "${RED}No backup found!${RESET}"
            fi
            ;;
        10)
            echo -e "${YELLOW}Join our Telegram Channel: ${BOLD}@vahid68_vpn${RESET}"
            ;;
        11) exit 0 ;;
        *) echo -e "${RED}Invalid option${RESET}" ;;
    esac
    echo ""
done
EOF

chmod +x "$menu_file"

echo -e "${GREEN}${BOLD}=== Installation & Enhanced Menu Setup Completed ===${RESET}"
echo -e "Run '${YELLOW}xui-menu${RESET}' to manage the service and access Telegram info."
