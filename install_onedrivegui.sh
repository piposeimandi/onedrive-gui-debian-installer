#!/bin/bash
set -e

REPO_DIR="$HOME/OneDriveGUI"
REPO_URL="https://github.com/bpozdena/OneDriveGUI.git"

echo "==> Instalando dependencias del sistema (PySide6, requests)..."
sudo apt update
sudo apt install -y python3-pyside6.qtcore python3-pyside6.qtgui \
    python3-pyside6.qtwidgets python3-pyside6.qtwebenginewidgets \
    python3-pyside6.qtsvg python3-requests python3-pip

if [ -d "$REPO_DIR" ]; then
    echo "==> Actualizando repositorio existente en $REPO_DIR"
    cd "$REPO_DIR"
    git pull
else
    echo "==> Clonando OneDriveGUI desde GitHub..."
    git clone "$REPO_URL" "$REPO_DIR"
    cd "$REPO_DIR"
fi

echo "==> Instalando dependencias pip..."
python3 -m pip install -r requirements.txt 2>/dev/null || true

echo "==> Creando wrapper en /usr/local/bin/onedrive-gui..."
sudo tee /usr/local/bin/onedrive-gui > /dev/null <<'WRAPPER'
#!/bin/bash
cd "$HOME/OneDriveGUI/src" || { echo "Error: $HOME/OneDriveGUI/src no existe"; exit 1; }
exec python3 OneDriveGUI.py "$@"
WRAPPER
sudo chmod +x /usr/local/bin/onedrive-gui

echo "==> Creando entrada .desktop para el menu..."
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/onedrive-gui.desktop" <<DESKTOP
[Desktop Entry]
Name=OneDriveGUI
Comment=Interfaz grafica para OneDrive Client for Linux
Exec=python3 $HOME/OneDriveGUI/src/OneDriveGUI.py
Icon=$HOME/OneDriveGUI/src/resources/images/icons8-cloud-80.png
Terminal=false
Type=Application
Categories=Network;FileTransfer;
StartupNotify=false
DESKTOP

echo ""
echo "=== OneDriveGUI instalado correctamente ==="
echo ""
echo "Para ejecutarlo: onedrive-gui"
echo "O desde el menu de aplicaciones: OneDriveGUI"
