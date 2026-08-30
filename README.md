# OneDrive + OneDriveGUI installer

> [🇪🇸 Leer en español](README.es.md)

Automated installation of **OneDrive Client** (CLI) and **OneDriveGUI** (graphical interface) for Linux.

## Supported distributions

| Distribution | Scripts folder | Notes |
|---|---|---|
| Debian 13 (Trixie) and derivatives | `debian/` | Builds OneDrive CLI from source (apt) |
| Fedora 44 | `fedora/` | Installs the native `onedrive` package (dnf) |

## Contents

```
/
├── install_all.sh          # Entry point: auto-detects the distro and delegates
├── debian/
│   ├── install_all.sh      # Runs both scripts sequentially (Debian)
│   ├── install_onedrive.sh     # Build & install abraunegg/onedrive from source (apt)
│   └── install_onedrivegui.sh  # Install bpozdena/OneDriveGUI from source (apt + pip)
└── fedora/
    ├── install_all.sh      # Runs both scripts sequentially (Fedora)
    ├── install_onedrive.sh     # Install onedrive from Fedora repos (dnf)
    └── install_onedrivegui.sh  # Install bpozdena/OneDriveGUI from source (dnf PySide6 + pip)
```

The `OneDriveGUI-*.AppImage` is a portable alternative that can be used on either distribution.

## Requirements

- Debian 13 (Trixie)/derivatives or Fedora 44
- `sudo` configured
- Internet connection

## Quick install

From the repository root (auto-detects your distribution):

```bash
chmod +x install_all.sh
./install_all.sh
```

Or manually per distribution:

```bash
# Debian / Ubuntu / derivatives
./debian/install_all.sh

# Fedora
./fedora/install_all.sh
```

## Usage

```bash
# First-time authentication
onedrive --synchronize

# Background service
systemctl --user enable --now onedrive

# GUI launcher
onedrive-gui
```

## What each script does

### `install_onedrive.sh`

The behavior differs by distribution:

- **Debian** (`debian/install_onedrive.sh`): builds from source. Installs build
  dependencies (`ldc`, `dub`, `libcurl`, `libsqlite3`, etc.), clones the official
  OneDrive repo (abraunegg/onedrive) to `~/onedrive-src`, compiles with `make`
  and installs with `sudo make install`. Verifies `onedrive --version`.
- **Fedora** (`fedora/install_onedrive.sh`): installs the **native `onedrive` package**
  from the official Fedora repositories with `sudo dnf install -y onedrive`.
  Fedora's packages are relatively up to date; if you want the latest git build you'd
  have to compile from source, but the native way is preferred. Verifies `onedrive --version`.

### `install_onedrivegui.sh`

The system dependency step differs by distribution:

- **Debian** (`debian/install_onedrivegui.sh`): PySide6 is split into individual
  packages (`python3-pyside6.qtcore`, `python3-pyside6.qtgui`, `python3-pyside6.qtwidgets`,
  `python3-pyside6.qtwebenginewidgets`, `python3-pyside6.qtsvg`) plus `python3-requests`.
- **Fedora** (`fedora/install_onedrivegui.sh`): PySide6 is a **single package**
  (`python3-pyside6`) plus `python3-requests` and `python3-pip`.

Then, in both cases: clones OneDriveGUI (bpozdena/OneDriveGUI) to `~/OneDriveGUI`,
installs pip dependencies, creates the wrapper at `/usr/local/bin/onedrive-gui`, and
creates the `.desktop` entry for the application menu.

## Technical notes

- **Debian 13 does not include `libpcre3-dev`** — it was replaced by `libpcre2-dev` (PCRE2).
  The D compiler (LDC) and OneDrive itself do not require PCRE to build, so neither package
  is necessary.
- **PySide6 on Debian 13** is split into individual packages (`python3-pyside6.qt*`)
  at version 6.8.2. There is no `python3-pyside6` metapackage.
- **PySide6 on Fedora 44** is a single `python3-pyside6` package (6.11.1-4.fc44),
  which includes QtWebEngine as a dependency.
- **Fedora ships `onedrive` natively** in its official repositories, so it is installed
  via `dnf` instead of being compiled from source.
- **The AppImage is optional** if you install from source, but serves as an alternative
  if you prefer not to clone the repository.

## Updating

Scripts are idempotent: re-running them does `git pull` and rebuilds/reinstalls.

```bash
# Debian
./debian/install_onedrive.sh      # update CLI (rebuild)
./debian/install_onedrivegui.sh   # update GUI

# Fedora
./fedora/install_onedrive.sh      # update CLI (dnf upgrade)
./fedora/install_onedrivegui.sh   # update GUI
```

## License

The scripts in this repository are public domain.
The installed projects have their own licenses:
- [abraunegg/onedrive](https://github.com/abraunegg/onedrive) — GPLv3
- [bpozdena/OneDriveGUI](https://github.com/bpozdena/OneDriveGUI) — GPLv3
