#!/bin/bash

# --- Color definitions ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PLAIN='\033[0m'

# Check root access
[[ $EUID -ne 0 ]] && echo -e "${RED}Error: ${PLAIN}Lotfan ba karbare Root vared shavid.\n" && exit 1

# --- Main Menu Function ---
show_menu() {
    clear
    echo -e "${GREEN}======================================${PLAIN}"
    echo -e "${GREEN}      X-UI PANEL ASSISTANT           ${PLAIN}"
    echo -e "${GREEN}======================================${PLAIN}"
    echo -e "  ${YELLOW}0.${PLAIN} Exit (Khorooj)"
    echo -e "  ${YELLOW}1.${PLAIN} Install X-UI (Nasbe Panel)"
    echo -e "  ${YELLOW}2.${PLAIN} Update X-UI (Update)"
    echo -e "  ${YELLOW}3.${PLAIN} Uninstall X-UI (Hazf)"
    echo -e "  ${YELLOW}4.${PLAIN} Reset Settings (Baz-neshani)"
    echo -e "  ${YELLOW}5.${PLAIN} Change Port (Taghyire Port)"
    echo -e "  ${YELLOW}6.${PLAIN} Check Panel Info (Etelaat)"
    echo -e "  ${YELLOW}7.${PLAIN} Enable BBR (Sor-at bakhsh)"
    echo -e "${GREEN}======================================${PLAIN}"
    echo -ne "Yek gozine ra entekhab konid [0-7]: "
    read choice

    case $choice in
        0) exit 0 ;;
        1) install_xui ;;
        2) update_xui ;;
        3) uninstall_xui ;;
        4) reset_config ;;
        5) change_port ;;
        6) check_info ;;
        7) enable_bbr ;;
        *) echo -e "${RED}Gozine eshtebah ast!${PLAIN}"; sleep 2; show_menu ;;
    esac
}

# --- Functions (Hamane script-e avaliye) ---

install_xui() {
    echo -e "${YELLOW}Dar hal-e nasbe x-ui...${PLAIN}"
    bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
    back_to_menu
}

update_xui() {
    x-ui update
    back_to_menu
}

uninstall_xui() {
    x-ui uninstall
    back_to_menu
}

reset_config() {
    x-ui setting -reset
    back_to_menu
}

change_port() {
    read -p "Porte jadid ra vared konid: " port
    x-ui setting -port $port
    back_to_menu
}

check_info() {
    x-ui show
    back_to_menu
}

enable_bbr() {
    echo -e "${YELLOW}Dar hal-e faalsazi BBR...${PLAIN}"
    # In dastoor BBR ra dar akasre serverha faal mikonad
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    echo -e "${GREEN}BBR faal shod.${PLAIN}"
    back_to_menu
}

back_to_menu() {
    echo -e "\n${BLUE}Amalyat tamam shod.${PLAIN}"
    read -p "Baraye barghasht be menu [Enter] ra bezanid..."
    show_menu
}

# Start Script
show_menu
