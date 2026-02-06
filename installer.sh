#!/bin/bash

# --- تعریف رنگ‌های درخشان ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m' 

# تابع کشیدن خط
draw_line() {
    echo -e "${CYAN}------------------------------------------------------------${NC}"
}

# تابع منوی اصلی (برای قابلیت برگشت)
main_menu() {
    clear
    draw_line
    echo -e "      ${BOLD}${PURPLE}🚀 X-UI ASSISTANT | DASTYAR-E MODIRIYAT 🚀${NC}"
    draw_line
    echo -e "${BLUE}IP Server:${NC} $(curl -s https://api.ipify.org || echo "Unknown")"
    draw_line
    
    echo -e "\n${BOLD}Lotfan yek gozine ra entekhab konid:${NC}"
    echo -e "  ${BLUE}1)${NC} 🛠  Nasbe Pishniyazha (Update & Tools)"
    echo -e "  ${BLUE}2)${NC} 📥 Nasbe Panel (Install X-UI)"
    echo -e "  ${BLUE}3)${NC} 👤 Modiriyat Karbaran (User Management)"
    echo -e "  ${BLUE}4)${NC} 📊 Vaziyat-e Server (System Status)"
    echo -e "  ${BLUE}5)${NC} ❌ Khorooj (Exit)"
    echo ""
    read -p "Adad-e gozine [1-5]: " main_choice

    case $main_choice in
        1) install_requirements ;;
        2) install_panel ;;
        3) user_management ;;
        4) system_status ;;
        5) exit_script ;;
        *) echo -e "${RED}Gozine eshtebah!${NC}"; sleep 2; main_menu ;;
    esac
}

# ۱. نصب پیش‌نیازها
install_requirements() {
    draw_line
    echo -e "${YELLOW}🔄 Dar hal-e update va nasbe abzarha...${NC}"
    apt update -y && apt install curl wget git socat -y
    echo -e "${GREEN}✅ Anjam shod.${NC}"
    back_to_menu
}

# ۲. نصب پنل (مشابه اسکریپت اولیه)
install_panel() {
    draw_line
    echo -e "${YELLOW}📥 Dar hal-e nasbe X-UI Panel...${NC}"
    # اجرای اسکریپت نصب اصلی پنل
    bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
    echo -e "${GREEN}✅ Panel ba movafaghiyat nasb shod.${NC}"
    back_to_menu
}

# ۳. مدیریت کاربران (منوی داخلی)
user_management() {
    clear
    draw_line
    echo -e "      ${BOLD}${YELLOW}👤 USER MANAGEMENT MENU 👤${NC}"
    draw_line
    echo -e "  ${BLUE}1)${NC} List-e Karbaran (Show Users)"
    echo -e "  ${BLUE}2)${NC} Hazf-e Karbar (Delete User)"
    echo -e "  ${BLUE}3)${NC} 🔙 Barghasht be Menuye Asli (Back)"
    echo ""
    read -p "Entekhab konid: " user_choice
    
    case $user_choice in
        1) x-ui list; back_to_menu ;;
        2) x-ui delete; back_to_menu ;;
        3) main_menu ;;
        *) user_management ;;
    esac
}

# ۴. وضعیت سیستم
system_status() {
    draw_line
    echo -e "${CYAN}📈 Vaziyat-e lahze-i server:${NC}"
    echo -e "${YELLOW}RAM Usage:${NC}"
    free -h
    echo -e "${YELLOW}Disk Usage:${NC}"
    df -h | grep '^/dev/'
    back_to_menu
}

# تابع برگشت به منو
back_to_menu() {
    echo ""
    draw_line
    read -p "Baraye barghasht be menuye asli [Enter] ra bezanid..."
    main_menu
}

# خروج
exit_script() {
    echo -e "${RED}👋 Khodafez!${NC}"
    exit 0
}

# شروع اسکریپت
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Lotfan ba sudo ejra konid.${NC}"
   exit 1
fi

main_menu
