#!/bin/bash

# install_scientific_tools.sh
# Parses data_sci_pkg.lst and installs selected categories using pacman, yay or pip.

PKG_LIST="data_sci_pkg.lst"
LOG_FILE="install_scientific_tools.log"
touch "$LOG_FILE"

log() {
  echo -e "$1" | tee -a "$LOG_FILE"
}

usage() {
  echo "Usage: $0 [--full | --mlops | --productivity | --base | --visualization]"
  exit 1
}

# Parse .lst file and group by selected category
install_category() {
  local CATEGORY=$1
  log "\n[+] Installing category: $CATEGORY"

  grep "\[$CATEGORY\]" "$PKG_LIST" | while read -r line; do
    method=$(echo "$line" | awk '{print $2}')
    pkg=$(echo "$line" | awk '{print $3}')

    case "$method" in
      pacman)
        log "[pacman] Installing $pkg"
        sudo pacman -S --noconfirm "$pkg"
        ;;
      yay)
        if ! command -v yay &>/dev/null; then
          log "[yay] Not found. Installing yay..."
          cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm
        fi
        log "[yay] Installing $pkg"
        yay -S --noconfirm "$pkg"
        ;;
      pip)
        log "[pip] Installing $pkg"
        pip install --user "$pkg"
        ;;
      wget)
        log "[wget] Downloading $pkg"
        wget "$pkg"
        ;;
      *)
        log "[!] Unknown install method for $pkg"
        ;;
    esac
  done
}

# Parse input flags
if [ $# -eq 0 ]; then
  usage
fi

for arg in "$@"; do
  case "$arg" in
    --full)
      install_category BASE
      install_category PYTHON_PKGS
      install_category MLOPS
      install_category PRODUCTIVITY
      install_category VISUALIZATION
      ;;
    --mlops)
      install_category MLOPS
      ;;
    --productivity)
      install_category PRODUCTIVITY
      ;;
    --base)
      install_category BASE
      install_category PYTHON_PKGS
      ;;
    --visualization)
      install_category VISUALIZATION
      ;;
    *)
      usage
      ;;
  esac
done

log "\n✅ Installation complete. See log: $LOG_FILE"
