#!/bin/bash

# Color definitions
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# Check root access
[[ $EUID -ne 0 ]] && echo -e "${red}Error: ${plain} Must be root to run this script\n" && exit 1

# Check OS
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

# Main Menu
show_menu() {
    echo -e "
  ${green}x-ui assistant مدیریت پنل${plain}
  ${green}0.${plain} خروج
  ${green}1.${plain} نصب x-ui
  ${green}2.${plain} آپدیت x-ui
  ${green}3.${plain} حذف x-ui
  ${green}4.${plain} بازنشانی تنظیمات
  ${green}5.${plain} تغییر پورت پنل
  ${green}6.${plain} مشاهده اطلاعات پنل
  ${green}7.${plain} فعالسازی BBR
  "
    echo -ne "گزینه مورد نظر را انتخاب کنید: "
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
        *) echo -e "${red}گزینه نامعتبر${plain}" ;;
    esac
}

install_xui() {
    bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
}

# ... سایر توابع اسکریپت مشابه این هستند ...

show_menu
