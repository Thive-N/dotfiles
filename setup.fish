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

# Directories
set DOTFILES_DIR (pwd)
set CONFIG_DIR "$HOME/.config"

# Folders to symlink to config
set TARGETS hypr quickshell nvim

# Required packages
set PACKAGES hyprland hyprpaper quickshell neovim jq


echo ""
echo "Dotfiles directory: $DOTFILES_DIR"
echo "Config directory: $CONFIG_DIR"
echo ""


# Ask for backup
read -l -P "Backup existing configs in ~/.config? (y/N): " backup_choice


# Backing up
if test "$backup_choice" = "y" -o "$backup_choice" = "Y"
    set BACKUP_DIR "$HOME/.config-backup-"(date +%s)
    echo "Creating backup at $BACKUP_DIR"
    mkdir -p $BACKUP_DIR

    for folder in $TARGETS
        if test -e "$CONFIG_DIR/$folder"
            echo "Backing up $folder"
            mv "$CONFIG_DIR/$folder" "$BACKUP_DIR/"
        end
    end
else
    echo "Skipping backups"
end


# Install packages
echo ""
echo "Installing required packages..."

sudo pacman -S --needed $PACKAGES

# Create symlinks

echo ""
echo "Creating symlinks..."

for folder in $TARGETS
    set SOURCE "$DOTFILES_DIR/$folder"
    set DEST "$CONFIG_DIR/$folder"


    if test -e $DEST
        echo "Removing existing $DEST"
        rm -rf $DEST
    end

    echo "Linking $SOURCE -> $DEST"
    ln -s $SOURCE $DEST
end

echo ""
echo "Setup complete!"
echo ""

