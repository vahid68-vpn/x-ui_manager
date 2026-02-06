#!/bin/bash

# --- Color Definitions ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m' 

draw_line() {
    echo -e "${CYAN}------------------------------------------------------------${NC}"
}

clear
draw_line
echo -e "      ${BOLD}${PURPLE}🚀 MANAGER ASSISTANT | DASTYAR-E MODIRIYAT 🚀${NC}"
draw_line

# 1. Root Check
echo -ne "${YELLOW}🔍 Barresi dastresi Root... ${NC}"
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[Error]${NC}"
   echo -e "${RED}Lotfan ba dastresi Root (sudo) ejra konid.${NC}"
   draw_line
   exit 1
else
   echo -e "${GREEN}[OK]${NC}"
fi

# 2. Information
echo -e "${BLUE}IP Server:${NC} $(curl -s https://api.ipify.org)"
echo -e "${BLUE}Zaman:${NC} $(date)"
draw_line

# 3. Menu
echo -e "\n${BOLD}Lotfan yek gozine ra entekhab konid:${NC}"
echo -e "  ${BLUE}1)${NC} 🛠  Nasbe Pishniyazha (Update & Tools)"
echo -e "  ${BLUE}2)${NC} 👤 Modiriyat Karbaran (User Management)"
echo -e "  ${BLUE}3)${NC} 📊 Vaziyat-e Server (System Status)"
echo -e "  ${BLUE}4)${NC} ❌ Khorooj (Exit)"
echo ""
read -p "Adad-e gozine [1-4]: " choice

case $choice in
    1)
        draw_line
        echo -e "${YELLOW}🔄 Dar hal-e update va nasbe abzarha...${NC}"
        apt update -y && apt install curl wget git -y
        echo -e "${GREEN}✅ Amalyat ba movafaghiyat anjam shod.${NC}"
        ;;
    2)
        echo -e "${PURPLE}Bakhsh-e Modiriyat dar noskhe-haye badi ezafe mishavad.${NC}"
        ;;
    3)
        draw_line
        echo -e "${CYAN}📈 Vaziyat-e lahze-i server:${NC}"
        uptime
        free -h
        ;;
    4)
        echo -e "${RED}👋 Khodafez! Movafagh bashid.${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}⚠ Gozine eshtebah ast! Dubare talash konid.${NC}"
        ;;
esac

draw_line
