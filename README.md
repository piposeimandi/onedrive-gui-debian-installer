# OneDrive on Debian 13 (Trixie)

> [🇪🇸 Leer en español](README.es.md)

Automated installation of **OneDrive Client** (CLI) and **OneDriveGUI** (graphical interface) from source code.

## Contents

| File | Description |
|---|---|
| `install_all.sh` | Runs both installation scripts in order |
| `install_onedrive.sh` | Builds and installs [abraunegg/onedrive](https://github.com/abraunegg/onedrive) |
| `install_onedrivegui.sh` | Installs [bpozdena/OneDriveGUI](https://github.com/bpozdena/OneDriveGUI) from source |

## Requirements

- Debian 13 (Trixie) — also works on Debian 12 (Bookworm) and derivatives
- `sudo` configured
- Internet connection

## Quick install

```bash
chmod +x install_all.sh install_onedrive.sh install_onedrivegui.sh
./install_all.sh
```

Or step by step:

```bash
# 1. CLI client
./install_onedrive.sh

# 2. Graphical interface
./install_onedrivegui.sh
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

1. Installs build dependencies: `ldc`, `dub`, `libcurl`, `libsqlite3`, etc.
2. Clones the official OneDrive repo (abraunegg/onedrive) to `~/onedrive-src`
3. Compiles with `make` and installs with `sudo make install`
4. Verifies `onedrive --version` works

### `install_onedrivegui.sh`

1. Installs system dependencies: `python3-pyside6.qtcore`, `python3-pyside6.qtgui`,
   `python3-pyside6.qtwidgets`, `python3-pyside6.qtwebenginewidgets`, `python3-requests`
2. Clones OneDriveGUI (bpozdena/OneDriveGUI) to `~/OneDriveGUI`
3. Installs pip dependencies (`urllib3<2.0`)
4. Creates wrapper at `/usr/local/bin/onedrive-gui`
5. Creates `.desktop` entry for the application menu

## Technical notes

- **Debian 13 does not include `libpcre3-dev`** — it was replaced by `libpcre2-dev` (PCRE2).
  The D compiler (LDC) and OneDrive itself do not require PCRE to build, so neither package
  is necessary.
- **PySide6 on Debian 13** is split into individual packages (`python3-pyside6.qt*`)
  at version 6.8.2. There is no `python3-pyside6` metapackage.
- **The AppImage is optional** if you install from source, but serves as an alternative
  if you prefer not to clone the repository.

## Updating

Scripts are idempotent: re-running them does `git pull` and rebuilds/reinstalls.

```bash
./install_onedrive.sh      # update CLI
./install_onedrivegui.sh   # update GUI
```

## License

The scripts in this repository are public domain.
The installed projects have their own licenses:
- [abraunegg/onedrive](https://github.com/abraunegg/onedrive) — GPLv3
- [bpozdena/OneDriveGUI](https://github.com/bpozdena/OneDriveGUI) — GPLv3
