# OneDrive Multi-Distro Installer - Project Context

## Repo
- URL: `https://github.com/piposeimandi/onedrive-gui-debian-installer`
- Default branch: `main`
- README principal: `README.md` (inglés), con link a `README.es.md` (español)

## Structure
```
/
├── install_all.sh          # Entrada principal: detecta la distro y delega
├── debian/
│   ├── install_all.sh      # Run both scripts sequentially (Debian)
│   ├── install_onedrive.sh     # Build & install abraunegg/onedrive from source (apt)
│   └── install_onedrivegui.sh  # Install bpozdena/OneDriveGUI from source (apt + pip)
├── fedora/
│   ├── install_all.sh      # Run both scripts sequentially (Fedora)
│   ├── install_onedrive.sh     # Install onedrive from Fedora repos (dnf)
│   └── install_onedrivegui.sh  # Install bpozdena/OneDriveGUI from source (dnf PySide6 + pip)
├── AGENTS.md
├── README.md               # English (default)
└── README.es.md            # Spanish
```

## What each script does

### debian/install_onedrive.sh (build from source)
1. Installs build deps: `ldc`, `dub`, `libcurl4-openssl-dev`, `libsqlite3-dev`, `libssl-dev`, `libxml2-dev`, `uuid-dev`
2. Clones `https://github.com/abraunegg/onedrive.git` to `~/onedrive-src`
3. Runs `./configure && make clean && make && sudo make install`
4. Verifies `onedrive --version`

**Note:** On Debian 13 `libpcre3-dev` does not exist. It was replaced by `libpcre2-dev`, but neither is needed for compilation.

### fedora/install_onedrive.sh (native package)
1. Installs `onedrive` from Fedora's official repos with `sudo dnf install -y onedrive`
2. Verifies `onedrive --version`

**Note:** Fedora ships `onedrive` natively, unlike Debian, so no compilation is needed. Fedora's packages are relatively up to date; compiling from source is only needed for the latest git build (native is preferred).

### install_onedrivegui.sh
1. Installs system deps:
   - **Debian:** `python3-pyside6.qtcore`, `python3-pyside6.qtgui`, `python3-pyside6.qtwidgets`, `python3-pyside6.qtwebenginewidgets`, `python3-pyside6.qtsvg`, `python3-requests`, `python3-pip`
   - **Fedora:** `python3-pyside6` (single package), `python3-requests`, `python3-pip`
2. Clones `https://github.com/bpozdena/OneDriveGUI.git` to `~/OneDriveGUI`
3. Installs pip deps: `urllib3<2.0`
4. Creates wrapper `/usr/local/bin/onedrive-gui`
5. Creates `.desktop` entry at `~/.local/share/applications/onedrive-gui.desktop`

**Note:** On Debian 13 PySide6 is split into individual packages (`python3-pyside6.qt*`). No `python3-pyside6` metapackage exists. On Fedora, PySide6 is a single `python3-pyside6` package (6.11.1-4.fc44) that includes QtWebEngine as a dependency.

### install_all.sh
- **Root** (`./install_all.sh`): auto-detects the distro from `/etc/os-release` (`$ID`) and delegates to `debian/` (debian|ubuntu|linuxmint|pop|elementary|zorin|neon) or `fedora/` (fedora). Exits with an error for unsupported distros.
- **debian/install_all.sh** and **fedora/install_all.sh**: execute their folder's two scripts in order: `install_onedrive.sh` then `install_onedrivegui.sh`.

## Key technical details
- OneDrive CLI is written in D: on Debian it needs the LDC compiler to build from source; on Fedora it is installed as a native package (no compiler needed)
- OneDriveGUI is Python/PySide6
- Scripts are idempotent (re-running does `git pull` + rebuild/reinstall)
- AppImage is optional, exists as alternative to source install
- PySide6 packaging differs: Debian splits it into `python3-pyside6.qt*`; Fedora uses a single `python3-pyside6`

## Common fixes
- If `.desktop` entry fails: `Exec` line must use `python3 $HOME/OneDriveGUI/src/OneDriveGUI.py`
- If `onedrive` command not found after install:
  - Debian: check `sudo make install` succeeded
  - Fedora: check `dnf install onedrive` succeeded
- If PySide6 import errors:
  - Debian: verify the correct submodules are installed via apt
  - Fedora: verify `python3-pyside6` (single package) is installed via dnf
