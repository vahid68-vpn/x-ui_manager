#!/bin/bash
# ==========================================
# VortexL2 Installer
# Fully standalone, no GitHub edits needed
# Maintained by: Vahid
# ==========================================

set -e

# -------- Colors --------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# -------- Paths & Config --------
INSTALL_DIR="/opt/vortexl2"
BIN_PATH="/usr/local/bin/vortexl2"
SYSTEMD_DIR="/etc/systemd/system"
CONFIG_DIR="/etc/vortexl2"

# Direct download of the ready-to-use repo zip
REPO_URL="https://codeload.github.com/iliya-Developer/VortexL2/zip/refs/heads/main"

# -------- Banner --------
clear
echo -e "${CYAN}"
echo "=========================================="
echo "        VortexL2 Installer"
echo "        Fully standalone by Vahid"
echo "=========================================="
echo -e "${NC}"

# -------- Root check --------
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Run as root${NC}"
  exit 1
fi

# -------- OS check --------
if ! command -v apt-get >/dev/null 2>&1; then
  echo -e "${RED}[ERROR] Only Debian / Ubuntu supported${NC}"
  exit 1
fi

# -------- Install dependencies --------
echo -e "${YELLOW}[+] Installing system dependencies...${NC}"
apt-get update -qq
apt-get install -y -qq python3 python3-pip python3-venv git curl unzip iproute2 haproxy

# -------- Kernel modules --------
KERNEL_VERSION="$(uname -r)"
echo -e "${YELLOW}[+] Installing kernel extra modules...${NC}"
apt-get install -y -qq "linux-modules-extra-${KERNEL_VERSION}" || true

echo -e "${YELLOW}[+] Loading L2TP kernel modules...${NC}"
modprobe l2tp_core || true
modprobe l2tp_netlink || true
modprobe l2tp_eth || true

# -------- Auto-load modules on boot --------
echo -e "${YELLOW}[+] Configuring kernel modules autoload...${NC}"
cat >/etc/modules-load.d/vortexl2.conf <<EOF
l2tp_core
l2tp_netlink
l2tp_eth
EOF

# -------- Cleanup old install --------
if [ -d "$INSTALL_DIR" ]; then
  echo -e "${YELLOW}[+] Removing old installation...${NC}"
  rm -rf "$INSTALL_DIR"
fi

# -------- Download project --------
echo -e "${GREEN}[+] Downloading VortexL2...${NC}"
mkdir -p "$INSTALL_DIR"
curl -Ls "$REPO_URL" -o /tmp/vortexl2.zip
unzip -q /tmp/vortexl2.zip -d /tmp/
mv /tmp/VortexL2-main/* "$INSTALL_DIR/"
rm -rf /tmp/vortexl2.zip /tmp/VortexL2-main

# -------- Python deps --------
echo -e "${YELLOW}[+] Installing Python dependencies...${NC}"
apt-get install -y -qq python3-yaml python3-rich || pip3 install --break-system-packages pyyaml rich

# -------- Create config dir --------
mkdir -p "$CONFIG_DIR"

# -------- Create launcher --------
echo -e "${GREEN}[+] Creating command launcher...${NC}"
cat >"$BIN_PATH" <<EOF
#!/bin/bash
exec python3 $INSTALL_DIR/main.py "\$@"
EOF

chmod +x "$BIN_PATH"

# -------- Systemd services --------
echo -e "${YELLOW}[+] Installing systemd services...${NC}"
if [ -d "$INSTALL_DIR/systemd" ]; then
    cp $INSTALL_DIR/systemd/*.service "$SYSTEMD_DIR/" || true
fi

systemctl daemon-reexec
systemctl daemon-reload

# -------- Disable legacy services --------
systemctl stop vortexl2-socat.service 2>/dev/null || true
systemctl disable vortexl2-socat.service 2>/dev/null || true

# -------- Enable main services --------
systemctl enable vortexl2.service
systemctl restart vortexl2.service

# -------- Finish --------
echo -e "${GREEN}"
echo "=========================================="
echo " VortexL2 installation completed"
echo
echo " Run: vortexl2"
echo
echo " Security notice:"
echo " L2TPv3 has NO encryption."
echo " Use IPSec / WireGuard if needed."
echo "=========================================="
echo -e "${NC}"
