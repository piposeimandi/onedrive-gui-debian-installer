#!/bin/bash
set -e

# En Fedora, PySide6 viene como UN SOLO paquete `python3-pyside6` (a diferencia de
# Debian, donde se parte en python3-pyside6.qt*). El paquete base incluye los
# modulos principales, y QtWebEngine viene como dependencia del mismo.

REPO_DIR="$HOME/OneDriveGUI"
REPO_URL="https://github.com/bpozdena/OneDriveGUI.git"

echo "==> Instalando dependencias del sistema (PySide6, requests)..."
sudo dnf install -y python3-pyside6 python3-requests python3-pip

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
