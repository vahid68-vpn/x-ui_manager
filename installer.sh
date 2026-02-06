#!/bin/bash
# ===============================================
# XUI Advanced Installer & Manager Script
# ===============================================
# وحید جان عزیزم، این اسکریپت مشابه xui-assistant هست
# با جزئیات کامل، بکاپ، نصب، منوی مدیریتی پیشرفته

set -euo pipefail

# ------------------------------
# Colors for better readability
# ------------------------------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# ------------------------------
# Step 0: Check root
# ------------------------------
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root${RESET}"
    exit 1
fi

echo -e "${BLUE}=== Step 1: Update & Upgrade System ===${RESET}"
apt update && apt upgrade -y

echo -e "${BLUE}=== Step 2: Install Dependencies ===${RESET}"
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
# Step 3: Backup existing configs
# ------------------------------
backup_dir="/root/xui_backup_$(date +%F_%T)"
mkdir -p "$backup_dir"
if [ -d "/etc/x-ui" ]; then
    echo -e "${BLUE}Backing up /etc/x-ui to $backup_dir${RESET}"
    cp -r /etc/x-ui "$backup_dir/"
fi

# ------------------------------
# Step 4: Download & Install Service
# ------------------------------
installer_url="https://raw.githubusercontent.com/dev-ir/xui-assistant/master/installer.sh"
tmp_script="/tmp/xui_installer.sh"

echo -e "${BLUE}Downloading installer...${RESET}"
curl -Ls "$installer_url" -o "$tmp_script"
chmod +x "$tmp_script"

echo -e "${BLUE}Running installer...${RESET}"
bash "$tmp_script"

# ------------------------------
# Step 5: Create Management Menu
# ------------------------------
menu_file="/usr/local/bin/xui-menu"
cat << 'EOF' > "$menu_file"
#!/bin/bash
# ===============================================
# XUI Management Menu
# ===============================================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

service_name="x-ui"

while true; do
    echo -e "${BLUE}==== XUI Management Menu ====${RESET}"
    echo "1) Start Service"
    echo "2) Stop Service"
    echo "3) Restart Service"
    echo "4) Enable Service on Boot"
    echo "5) Disable Service on Boot"
    echo "6) Show Service Status"
    echo "7) View Last 50 Logs"
    echo "8) Backup Current Configs"
    echo "9) Restore Last Backup"
    echo "10) Exit"
    read -p "Choose an option [1-10]: " choice
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
        10) exit 0 ;;
        *) echo -e "${RED}Invalid option${RESET}" ;;
    esac
    echo ""
done
EOF

chmod +x "$menu_file"

echo -e "${GREEN}=== Installation & Menu Setup Completed ===${RESET}"
echo -e "You can now run '${YELLOW}xui-menu${RESET}' to manage the service."
