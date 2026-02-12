#!/usr/bin/env bash
set -e
shopt -s nullglob

# Make script location-aware
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
GNOME_DIR="$DOTFILES_DIR/gnome"
THEMES_DIR="$DOTFILES_DIR/themes"

# Sanity checks
command -v dconf >/dev/null || { echo "dconf not found"; exit 1; }
command -v gnome-extensions >/dev/null || { echo "gnome-extensions CLI not found"; exit 1; }

echo "Restoring themes and icons..."
mkdir -p "$HOME/.themes"
mkdir -p "$HOME/.icons"
mkdir -p "$HOME/.local/share/gnome-shell/extensions"

# Themes
if [ -d "$THEMES_DIR/.themes" ]; then
    cp -r "$THEMES_DIR/.themes/"* "$HOME/.themes/"
fi

# Icons
if [ -d "$THEMES_DIR/.icons" ]; then
    cp -r "$THEMES_DIR/.icons/"* "$HOME/.icons/"
fi

echo "Restoring extensions..."
if [ -d "$GNOME_DIR/extensions" ]; then
    cp -r "$GNOME_DIR/extensions/"* \
        "$HOME/.local/share/gnome-shell/extensions/"
fi

echo "Restoring GNOME settings..."
dconf load / < "$GNOME_DIR/settings.dconf"

echo "Re-enabling extensions..."
while read -r ext; do
    [ -n "$ext" ] && gnome-extensions enable "$ext" 2>/dev/null || true
done < "$GNOME_DIR/enabled-extensions.txt"

echo "Setting wallpaper..."

WALLPAPER_SOURCE="$DOTFILES_DIR/luffy-gear-five.jpg"
WALLPAPER_DEST="$HOME/Pictures/luffy-gear-five.jpg"

if [ -f "$WALLPAPER_SOURCE" ]; then
    mkdir -p "$HOME/Pictures"
    cp "$WALLPAPER_SOURCE" "$WALLPAPER_DEST"

    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DEST"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DEST"
fi


echo "Restarting GNOME Shell..."
if command -v busctl >/dev/null 2>&1; then
    busctl --user call org.gnome.Shell /org/gnome/Shell \
        org.gnome.Shell Eval s 'Meta.restart("restore");'
fi

echo "Restore complete. Log out and back in if needed."
