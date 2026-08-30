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

# En Fedora, PySide6 y requests vienen como paquetes del sistema. NO correr
# `pip install -r requirements.txt` porque el requirements incluye PySide6 y
# pip instalaria una build en ~/.local que PISA al del sistema y rompe shiboken
# (PEP 668 / externally-managed-environment). Solo aseguramos urllib3<2.0,
# que es la unica dependencia pip que OneDriveGUI exige y puede no venir del sistema.
echo "==> Instalando dependencias pip (solo urllib3<2.0)..."
# No instalar PySide6 desde pip. Si urllib3 del sistema es 2.x (como en Fedora),
# OneDriveGUI pide <2.0 -> lo instalamos con --user como fallback.
python3 - <<'EOF'
import urllib3
major = int(urllib3.__version__.split('.')[0])
exit(0 if major < 2 else 1)
EOF
if [ $? -ne 0 ]; then
    echo "==> urllib3 >= 2.0 detectado, instalando urllib3<2.0 en ~/.local (requiere flag --break-system-packages por PEP 668)..."
    python3 -m pip install --user --break-system-packages 'urllib3<2.0' 2>/dev/null || \
        python3 -m pip install --user 'urllib3<2.0' 2>/dev/null || echo "Omitido: urllib3<2.0 no se pudo instalar (el sistema ya lo provee o falta permiso de red)"
else
    echo "==> urllib3 < 2.0 ya disponible, no hace falta pip"
fi

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
