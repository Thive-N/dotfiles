#!/usr/bin/env fish

echo "·▄▄▄▄        ▄▄▄▄▄·▄▄▄▪  ▄▄▌  ▄▄▄ ..▄▄ · ";
echo "██▪ ██ ▪     •██  ▐▄▄·██ ██•  ▀▄.▀·▐█ ▀. ";
echo "▐█· ▐█▌ ▄█▀▄  ▐█.▪██▪ ▐█·██▪  ▐▀▀▪▄▄▀▀▀█▄";
echo "██. ██ ▐█▌.▐▌ ▐█▌·██▌.▐█▌▐█▌▐▌▐█▄▄▌▐█▄▪▐█";
echo "▀▀▀▀▀•  ▀█▄▀▪ ▀▀▀ ▀▀▀ ▀▀▀.▀▀▀  ▀▀▀  ▀▀▀▀ ";

#       ___  _
#     ___)  \ )\
#   __)    _/   \
#  _)    _/    _/''--._
# /__   \___.-'   {>(9 /
#  )__     ;-...;__;-''
#    )__     /)   /|))
#      )_   / \/\/ )//
#        )_/
#
# =====================================
# Dotfiles Setup Script
# =====================================

# ----------------------------
# Dry run mode
# ----------------------------
set DRY_RUN 0

function run_or_print
    if test $DRY_RUN -eq 1
        echo "[DRY RUN] $argv"
    else
        eval $argv
    end
end

read -l -P "Run in DRY-RUN mode? (y/N): " dry_choice
if test (string lower $dry_choice) = "y"
    set DRY_RUN 1
    echo "Running in DRY-RUN mode (no changes will be made)"
else
    set DRY_RUN 0
end

# ----------------------------
# Directories
# ----------------------------
set DOTFILES_DIR (pwd)
set CONFIG_DIR "$HOME/.config"

# Ensure config dir exists
run_or_print mkdir -p $CONFIG_DIR

# ----------------------------
# Targets
# ----------------------------
set TARGETS hypr quickshell nvim kitty fish

# ----------------------------
# Packages
# ----------------------------
set PACMAN_PACKAGES hyprland hyprpaper quickshell neovim jq kitty obsidian code
set AUR_PACKAGES spotify spicetify-cli

echo ""
echo "Dotfiles directory: $DOTFILES_DIR"
echo "Config directory: $CONFIG_DIR"
echo ""

# ----------------------------
# Backup prompt
# ----------------------------
read -l -P "Backup existing configs in ~/.config? (y/N): " backup_choice

if test (string lower $backup_choice) = "y"
    set BACKUP_DIR "$HOME/.config-backup-"(date +%s)
    echo "Creating backup at $BACKUP_DIR"
    run_or_print mkdir -p $BACKUP_DIR

    for folder in $TARGETS
        if test -e "$CONFIG_DIR/$folder"
            echo "Backing up $folder"
            run_or_print mv "$CONFIG_DIR/$folder" "$BACKUP_DIR/"
        end
    end
else
    echo "Skipping backups"
end

# ----------------------------
# Install packages
# ----------------------------
echo ""
echo "Installing required packages..."

if type -q pacman
    run_or_print sudo pacman -S --needed $PACMAN_PACKAGES
else
    echo "pacman not found - skipping system packages"
end

# ----------------------------
# Symlinks
# ----------------------------
echo ""
echo "Creating symlinks..."

for folder in $TARGETS
    set SOURCE "$DOTFILES_DIR/$folder"
    set DEST "$CONFIG_DIR/$folder"

    if not test -e $SOURCE
        echo "WARNING: missing source $SOURCE"
        continue
    end

    if test -e $DEST; and not test -L $DEST
        echo "Removing non-symlink $DEST"
        run_or_print rm -rf $DEST
    end

    echo "Linking $SOURCE -> $DEST"
    run_or_print ln -sfn $SOURCE $DEST
end

# ----------------------------
# Firefox theme
# ----------------------------
echo ""
echo "Creating firefox theme..."

run_or_print mkdir -p FireFox
run_or_print zip -r ./FireFox/theme.zip FireFox/manifest.json

# ----------------------------
# Extra packages
# ----------------------------
read -l -P "Install extra packages? (y/N): " custom_choice

if test (string lower $custom_choice) = "y"
    echo ""
    echo "Installing AUR + extra packages..."

    if type -q yay
        run_or_print yay -S $AUR_PACKAGES
    else
        echo "yay not installed, skipping AUR packages"
    end

    run_or_print sudo chmod a+wr /opt/spotify
    run_or_print sudo chmod a+wr /opt/spotify/Apps -R

    run_or_print curl -fsSL https://raw.githubusercontent.com/NYRI4/Comfy-spicetify/main/install.sh | sh
else
    echo "Skipping custom packages"
end

echo ""
echo "Setup complete!"
echo ""