#!/bin/bash

# ================= Center Print =================
center_print() {
  local width
  width=$(tput cols)

  while IFS= read -r line; do
    local len=${#line}
    if (( len < width )); then
      printf "%*s%s\n" $(( (width - len) / 2 )) "" "$line"
    else
      echo "$line"
    fi
  done
}

clear

# ================= Banner =================
cat << 'EOF' | center_print
manager
      MANAGER
EOF

echo
echo "------------------------------------------------------------" | center_print
echo "Telegram: @vahid68_vpn" | center_print
echo "------------------------------------------------------------" | center_print
echo
