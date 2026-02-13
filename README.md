# Desktop Init
## Restoring your desktop
Verify these commands work:
```sh
command -v dconf
command -v gnome-extensions
```

## Restoring on a New Machine
1. install tesseract-ocr package
```sh
sudo pacman -S tesseract-ocr
```

2. Just run these
```shell
git clone https://github.com/ndev-hoster/desktop-init.git
cd desktop-init
chmod +x restore.sh
./restore.sh
```

The script will:

- Copy themes and icons into your home directory
- Restore GNOME extensions
- Load GNOME settings via dconf
- Re-enable extensions
- Restart GNOME Shell

If anything looks off, log out and back in.

## Updating the baseline
Backing Up Current Setup

From the root of this repository:

```sh
chmod +x backup.sh
./backup.sh
```

This will:

- Export GNOME settings to settings.dconf
- Save enabled extensions list
- Copy user-installed extensions
- Copy user themes and icons

Then commit and push:
```sh
git add .
git commit -m "Update desktop snapshot"
git push
```

**Notes**

- This is a baseline configuration.
  Machine-specific extensions or tweaks can be added afterward.

- Extensions are GNOME-version dependent.
  If restoring to a significantly newer GNOME version, some extensions may fail to load.

- This repository only handles user-level configuration.
  System-wide themes or extensions installed via package manager are not managed here.

