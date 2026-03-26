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
set TARGETS hypr quickshell nvim kitty fish

# Required packages
set PACKAGES hyprland hyprpaper quickshell neovim jq kitty

#custom packages
set CUSTOM_PACKAGES obsidian code
set CUSTOM_PACKAGES_YAY spotify spicetify-cli


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

# Zip firefox theme

echo ""
echo "Creating firefox theme..."

zip -r ./FireFox/theme.zip FireFox/manifest.json


read -l -P "Install extra packages? (y/N): " custom_package_choice

# Backing up
if test "$custom_package_choice" = "y" -o "$custom_package_choice" = "Y"
    echo ""
    echo "Installing custom packages..."
    sudo pacman -S --needed $CUSTOM_PACKAGES
    yay -S $CUSTOM_PACKAGES_YAY

    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R

    # comfy theme
    curl -fsSL https://raw.githubusercontent.com/NYRI4/Comfy-spicetify/main/install.sh | sh

else
    echo "Skipping custom packages"
end



echo ""
echo "Setup complete!"
echo ""

