# Arch Linux for Data Science – Modular Setup

This repository provides a modular and customizable setup for turning your Arch Linux environment into a professional-grade platform for:

- 📊 Data Science
- 🤖 Machine Learning
- ⚙️ MLOps & Deployment
- 🧠 Scientific Computing
- 🖥️ GPU-ready Workloads

It uses a list-driven approach (`data_sci_pkg.lst`) to declaratively manage the installation of categorized tools via `pacman`, `yay`, and `pip`.

---

## 📦 Structure

### 🔹 `data_sci_pkg.lst`

This file contains a categorized list of applications in the format:

```
[CATEGORY] install_method package_name
```

For example:

```
[MLOPS] pacman docker
[PYTHON_PKGS] pip numpy
```

Categories currently supported:
- `BASE` – Core Python/R stack
- `PYTHON_PKGS` – Scientific & ML Python libraries
- `MLOPS` – Tools for deployment, tracking, monitoring
- `PRODUCTIVITY` – Terminal utilities & automation
- `VISUALIZATION` – Tools for rendering or presenting data

---

### 🔹 `install_scientific_tools.sh`

This script reads the `.lst` file and installs tools according to category.

#### 🛠 Usage

```bash
chmod +x install_scientific_tools.sh

# Install the full environment
./install_scientific_tools.sh --full

# Or selectively install categories
./install_scientific_tools.sh --mlops
./install_scientific_tools.sh --base
./install_scientific_tools.sh --productivity
```

A log file will be generated: `install_scientific_tools.log`

---

## 🔧 What’s Included (Highlights)

### ✅ Core Tools
- Python, pip, JupyterLab, IPython
- R and RStudio (Hyprland-safe wrapper if applicable)
- Virtual environment support (`python-virtualenv`)
- LaTeX tools: `texlive-core`, `latexmk`, `texmaker`

### ✅ Python Data Stack
- `numpy`, `pandas`, `scipy`, `matplotlib`, `seaborn`
- `scikit-learn`, `statsmodels`, `xgboost`, `lightgbm`, `catboost`
- `optuna`, `shap`, `lime`, `sqlalchemy`, `psycopg2-binary`

### ✅ MLOps Stack
- `docker`, `docker-compose`
- `mlflow`, `dvc`
- `prometheus`
- `uvicorn`, `gunicorn`

### ✅ Productivity Tools
- `tmux`, `fzf`, `ripgrep`, `bat`, `direnv`, `httpie`, `ncdu`, `htop`

### ✅ Visualization & Docs
- `streamlit`, `pandoc`, `marp-cli`

---

## 🖥️ Hyprland Compatibility

If RStudio is installed and Hyprland is detected, the script creates a wrapper at:

```
~/.local/bin/rstudio
```

This ensures proper Electron rendering via:

```bash
unset ELECTRON_OZONE_PLATFORM_HINT && rstudio
```

---

## ✅ Extending This Setup

You can add more tools by editing `data_sci_pkg.lst` and adding new blocks:

```
[MYTOOLS] pip somepackage
```

And then extending the script to parse `[MYTOOLS]` as needed.

---
## TO DO List

- [X] Bring nvim configurations for data science development
- [ ] change $EDITOR depending on type of IDE (nvim or VSCode)
  - this change should take place in the .zshrc file 
- [ ] Need to check error messages in docker/docker-compose in sci install script
- [ ] Need to mix installations from Alternative and unchanged sci install script
---

## 📜 License

MIT License

---

## 🙌 Credits

Developed by [Luis Antolin](https://github.com/antolin-luis) to simplify and modularize high-performance data science setup on Arch Linux.
