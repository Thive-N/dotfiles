<div align=center>
<h1>
DotFiles
</h1>

![GitHub last commit](https://img.shields.io/github/last-commit/Thive-N/dotfiles?style=for-the-badge&labelColor=101418&color=9ccbfb)
![GitHub Repo stars](https://img.shields.io/github/stars/Thive-N/dotfiles?style=for-the-badge&labelColor=101418&color=b9c8da)
![GitHub repo size](https://img.shields.io/github/repo-size/Thive-N/dotfiles?style=for-the-badge&labelColor=101418&color=d3bfe6)
</div>

# ⚙️ Dotfiles Setup

This repository includes a `setup.fish` script to quickly install dependencies and link configs.

Also Contains a Firefox and Obsidian theme.

## What it does

* Optionally backs up existing `~/.config` folders
* Installs required packages using `pacman`
* Creates symlinks for:

  * `hypr`
  * `quickshell`
  * `nvim`

---

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/Thive-N/dotfiles.git
cd dotfiles
```

### 2. Run the setup script

```bash
fish setup.fish
```


## Symlinks

The script creates symlinks like:

```
~/.config/hypr        → <repo>/hypr
~/.config/quickshell  → <repo>/quickshell
~/.config/nvim        → <repo>/nvim
```

This keeps your system configs in sync with the repository.

---


## Notes

* Arch Linux / Arch-based distro required
* Requires `sudo` privileges
* Make sure `fish` is installed

---