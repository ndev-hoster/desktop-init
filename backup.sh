#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

PARENT_DIR="dotfiles"

echo "Creating backup directories..."
mkdir -p "$PARENT_DIR/gnome/extensions"
mkdir -p "$PARENT_DIR/themes/.themes"
mkdir -p "$PARENT_DIR/themes/.icons"

ICONS_DIR="$PARENT_DIR/themes/.icons"
THEMES_DIR="$PARENT_DIR/themes/.themes"

echo "Backing up user themes..."
if [ -d "$HOME/.themes" ]; then
    cp -a "$HOME/.themes/"* "$THEMES_DIR"
fi

if [ -d "$HOME/.local/share/themes" ]; then
    cp -a "$HOME/.local/share/themes/"* "$THEMES_DIR"
fi

echo "Backing up user icons & cursors..."
if [ -d "$HOME/.icons" ]; then
    cp -a "$HOME/.icons/"* "$ICONS_DIR"
fi

if [ -d "$HOME/.local/share/icons" ]; then
    cp -a "$HOME/.local/share/icons/"* "$ICONS_DIR"
fi

echo "Backing up GNOME settings..."
dconf dump / > "$PARENT_DIR/gnome/settings.dconf"

echo "Backing up enabled extensions list..."
gnome-extensions list --enabled > "$PARENT_DIR/gnome/enabled-extensions.txt"

echo "Backing up user-installed extensions..."
if [ -d "$HOME/.local/share/gnome-shell/extensions" ]; then
    cp -a "$HOME/.local/share/gnome-shell/extensions/"* "$PARENT_DIR/gnome/extensions/"
fi

echo "Backup complete."
