#!/bin/bash

LOG_FILE="install_scientific_tools.log"
touch "$LOG_FILE"

log() {
  echo -e "$1" | tee -a "$LOG_FILE"
}

update_system() {
  log "[*] Updating system..."
  sudo pacman -Syu --noconfirm
}

install_base_dev() {
  log "\n[+] Installing base development tools and Python venv support..."
  sudo pacman -S --noconfirm git zsh bash-completion base-devel python python-virtualenv
}

install_python_stack() {
  log "\n[+] Installing Python tools globally (you should use a venv)..."
  pip install --upgrade pip
  pip install --user numpy pandas scipy matplotlib seaborn \
                    scikit-learn statsmodels xgboost lightgbm catboost \
                    shap lime optuna plotly dash streamlit \
                    sqlalchemy psycopg2-binary pymysql jupyterlab jupyterlab-git
}

install_r_stack() {
  log "\n[+] Installing R and RStudio..."
  sudo pacman -S --noconfirm r

  if ! command -v yay &> /dev/null; then
    log "[!] yay not found. Installing yay from AUR..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si --noconfirm
  fi

  yay -S --noconfirm rstudio-desktop-bin

  # Check for Hyprland and configure RStudio wrapper if needed
  if [[ "$XDG_CURRENT_DESKTOP" == *Hyprland* ]] || pgrep -x hyprland > /dev/null; then
    log "[+] Hyprland detected. Creating RStudio launcher with Electron fix..."
    mkdir -p ~/.local/bin
    cat << 'EOF' > ~/.local/bin/rstudio
#!/bin/bash
unset ELECTRON_OZONE_PLATFORM_HINT
exec /usr/bin/rstudio "$@"
EOF
    chmod +x ~/.local/bin/rstudio

    # Ensure ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
      log "[+] Added ~/.local/bin to PATH in .bashrc"
    fi

    log "[✓] RStudio wrapper created at ~/.local/bin/rstudio"
  else
    log "[i] Hyprland not detected. Using default RStudio launch."
  fi
}

install_latex_tools() {
  log "\n[+] Installing LaTeX tools..."
  sudo pacman -S --noconfirm texlive-core texmaker latexmk
}

install_ides_and_utils() {
  log "\n[+] Installing IDEs and productivity tools..."
  sudo pacman -S --noconfirm \
    code neovim geany qtcreator tmux htop ncdu fzf bat ripgrep
}

install_gpu_stack() {
  log "\n[+] Checking for NVIDIA GPU..."
  if lspci | grep -i nvidia > /dev/null; then
    log "[+] NVIDIA GPU detected. Installing drivers and CUDA stack..."
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings cuda cudnn nvtop
    log "[+] Install PyTorch and TensorFlow (you should do this inside your venv)..."
    log "[!] Run manually inside your venv:"
    log "    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121"
    log "    pip install tensorflow==2.15.0"
  else
    log "[!] No NVIDIA GPU found. Skipping GPU installation."
  fi
}

main() {
  update_system
  install_base_dev

  case "$1" in
    --minimal)
      log "[*] Running MINIMAL installation..."
      install_python_stack
      install_r_stack
      install_latex_tools
      ;;
    --full|"")
      log "[*] Running FULL installation for Data Science..."
      install_python_stack
      install_r_stack
      install_latex_tools
      install_ides_and_utils
      ;;
    --gpu)
      log "[*] Installing GPU support only..."
      install_gpu_stack
      ;;
    --full-gpu)
      log "[*] Running FULL installation with GPU support..."
      install_python_stack
      install_r_stack
      install_latex_tools
      install_ides_and_utils
      install_gpu_stack
      ;;
    *)
      log "[!] Unknown option: $1"
      log "Usage: $0 [--minimal | --full | --gpu | --full-gpu]"
      exit 1
      ;;
  esac

  log "\n✅ Installation complete."
  log "💡 Tip: Create your virtual environment with:"
  log "   python -m venv ~/myenv && source ~/myenv/bin/activate"
}

main "$1"

