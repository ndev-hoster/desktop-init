#!/usr/bin/env bash
set -e

echo "Creating backup directories..."
mkdir -p gnome/extensions
mkdir -p themes/.themes
mkdir -p themes/.icons

echo "Backing up user themes..."
if [ -d "$HOME/.themes" ]; then
    cp -r "$HOME/.themes/"* themes/.themes/ 2>/dev/null || true
fi

if [ -d "$HOME/.local/share/themes" ]; then
    cp -r "$HOME/.local/share/themes/"* themes/.themes/ 2>/dev/null || true
fi

echo "Backing up user icons & cursors..."
if [ -d "$HOME/.icons" ]; then
    cp -r "$HOME/.icons/"* themes/.icons/ 2>/dev/null || true
fi

if [ -d "$HOME/.local/share/icons" ]; then
    cp -r "$HOME/.local/share/icons/"* themes/.icons/ 2>/dev/null || true
fi

echo "Backing up GNOME settings..."
dconf dump / > gnome/settings.dconf

echo "Backing up enabled extensions list..."
gnome-extensions list --enabled > gnome/enabled-extensions.txt

echo "Backing up user-installed extensions..."
if [ -d "$HOME/.local/share/gnome-shell/extensions" ]; then
    cp -r "$HOME/.local/share/gnome-shell/extensions/"* gnome/extensions/ 2>/dev/null || true
fi

echo "Backup complete."
