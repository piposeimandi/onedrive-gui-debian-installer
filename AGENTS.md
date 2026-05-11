# OneDrive Debian Installer - Project Context

## Repo
- URL: `https://github.com/piposeimandi/onedrive-gui-debian-installer`
- Default branch: `main`
- README principal: `README.md` (inglés), con link a `README.es.md` (español)

## Structure
```
/
├── install_all.sh          # Run both scripts sequentially
├── install_onedrive.sh     # Build & install abraunegg/onedrive from source
├── install_onedrivegui.sh  # Install bpozdena/OneDriveGUI from source
├── OneDriveGUI-*.AppImage  # Portable alternative (optional)
├── AGENTS.md               # This file
├── README.md               # English (default)
└── README.es.md            # Spanish
```

## What each script does

### install_onedrive.sh
1. Installs build deps: `ldc`, `dub`, `libcurl4-openssl-dev`, `libsqlite3-dev`, `libssl-dev`, `libxml2-dev`, `uuid-dev`
2. Clones `https://github.com/abraunegg/onedrive.git` to `~/onedrive-src`
3. Runs `./configure && make clean && make && sudo make install`
4. Verifies `onedrive --version`

**Note:** On Debian 13 `libpcre3-dev` does not exist. It was replaced by `libpcre2-dev`, but neither is needed for compilation.

### install_onedrivegui.sh
1. Installs system deps: `python3-pyside6.qtcore`, `python3-pyside6.qtgui`, `python3-pyside6.qtwidgets`, `python3-pyside6.qtwebenginewidgets`, `python3-pyside6.qtsvg`, `python3-requests`, `python3-pip`
2. Clones `https://github.com/bpozdena/OneDriveGUI.git` to `~/OneDriveGUI`
3. Installs pip deps: `urllib3<2.0`
4. Creates wrapper `/usr/local/bin/onedrive-gui`
5. Creates `.desktop` entry at `~/.local/share/applications/onedrive-gui.desktop`

**Note:** On Debian 13 PySide6 is split into individual packages (`python3-pyside6.qt*`). No `python3-pyside6` metapackage exists.

### install_all.sh
Executes both scripts in order: `install_onedrive.sh` then `install_onedrivegui.sh`.

## Key technical details
- OneDrive CLI is written in D, needs LDC compiler
- OneDriveGUI is Python/PySide6
- Scripts are idempotent (re-running does `git pull` + rebuild)
- AppImage is optional, exists as alternative to source install

## Common fixes
- If `.desktop` entry fails: `Exec` line must use `python3 $HOME/OneDriveGUI/src/OneDriveGUI.py`
- If `onedrive` command not found after install: check `sudo make install` succeeded
- If PySide6 import errors: verify the correct submodules are installed via apt
