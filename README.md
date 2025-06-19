# Arch Linux for Data Science – Customized Setup

This repository provides a setup script and configuration guide to turn your Arch Linux installation into a powerful, GPU-ready development environment tailored for:

- 📊 Data Science
- 🤖 Machine Learning
- 🧪 Scientific Computing
- 🎛️ Visualization and Dashboards

It is also fully compatible with **Wayland compositors** like **Hyprland** and includes special handling for Electron-based apps like **RStudio**.

---

## 🚀 Features

- ⚙️ Minimal or full installation modes
- 🧮 Scientific Python stack (numpy, pandas, matplotlib, scikit-learn, etc.)
- 🧠 Machine Learning libraries (xgboost, lightgbm, catboost, optuna)
- 📈 Visualization tools (plotly, dash, streamlit)
- 🧬 R and RStudio (with Wayland fix for Hyprland)
- 💻 IDEs and editors: VS Code, RStudio, Geany, QtCreator, Neovim
- 🧵 CLI tools: zsh, fzf, ripgrep, bat, htop, etc.
- 🎮 NVIDIA GPU support (drivers, CUDA, cuDNN, PyTorch, TensorFlow)
- 🔒 Python `venv` support (no environment is auto-created)

---

## 📦 Installation

### 1. Clone this repository

```bash
git clone https://github.com/yourusername/arch-ds-setup.git
cd arch-ds-setup
chmod +x install_scientific_tools_arch.sh
```

### 2. Run the script

Choose an installation mode:

| Mode         | Description                                 |
|--------------|---------------------------------------------|
| `--minimal`  | Python, R, LaTeX only                        |
| `--full`     | Full Data Science environment                |
| `--gpu`      | Only GPU stack (NVIDIA drivers + CUDA)       |
| `--full-gpu` | Full environment + GPU support               |

```bash
./install_scientific_tools_arch.sh --full-gpu
```

---

## 🖥️ RStudio on Hyprland / Wayland

RStudio is an Electron-based app and may not render correctly under Wayland (e.g., Hyprland).

This script **automatically detects Hyprland** and creates a wrapper:

```bash
~/.local/bin/rstudio
```

That runs:

```bash
unset ELECTRON_OZONE_PLATFORM_HINT
exec /usr/bin/rstudio "$@"
```

This ensures proper rendering. The script also ensures `~/.local/bin` is in your `$PATH`.

---

## 💡 VS Code on Wayland

VS Code works best when launched with Wayland flags:

```bash
ELECTRON_OZONE_PLATFORM_HINT=auto code --ozone-platform=wayland
```

You may optionally create your own wrapper in `~/.local/bin/code`.

---

## 🧪 Python Virtual Environment

This setup **does not automatically create a virtual environment**, but includes `venv` support:

```bash
python -m venv ~/ds-env
source ~/ds-env/bin/activate
```

You are encouraged to isolate dependencies this way.

---

## 🗂️ Files in this Repo

```
arch-ds-setup/
├── install_scientific_tools_arch.sh  # Main setup script
└── README.md                         # Documentation
```

---

## 🛠️ To-Do

- Add Conda/Mamba integration
- Create archiso-based bootable ISO image
- Add `.desktop` entries for Wayland-compatible RStudio
- Optional tiling WM workflow setup (e.g., Hyprland, i3, Sway)

---

## 📜 License

MIT License

---

## 🙌 Credits

Developed by [Your Name](https://github.com/yourusername) to enable reproducible, high-performance data science on Arch Linux.
