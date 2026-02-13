#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

PARENT_DIR="dotfiles"

echo "Creating backup directories..."
mkdir -p "$PARENT_DIR/gnome"
mkdir -p "$PARENT_DIR/themes"

echo "Backing up user themes..."
if [ -d "$HOME/.themes" ] && [ -n "$(ls -A "$HOME/.themes" 2>/dev/null)" ]; then
    tar -czf "$PARENT_DIR/themes/themes.tar.gz" -C "$HOME" .themes
fi

echo "Backing up user icons & cursors..."
if [ -d "$HOME/.icons" ] && [ -n "$(ls -A "$HOME/.icons" 2>/dev/null)" ]; then
    tar -czf "$PARENT_DIR/themes/icons.tar.gz" -C "$HOME" .icons
fi

echo "Backing up GNOME settings..."
dconf dump / > "$PARENT_DIR/gnome/settings.dconf"

echo "Backing up enabled extensions list..."
gnome-extensions list --enabled > "$PARENT_DIR/gnome/enabled-extensions.txt"

echo "Backing up user-installed extensions..."
if [ -d "$HOME/.local/share/gnome-shell/extensions" ] && [ -n "$(ls -A "$HOME/.local/share/gnome-shell/extensions" 2>/dev/null)" ]; then
    tar -czf "$PARENT_DIR/gnome/extensions.tar.gz" -C "$HOME/.local/share/gnome-shell" extensions
fi

echo "Backup complete."