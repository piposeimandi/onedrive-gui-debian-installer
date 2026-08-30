#!/bin/bash
set -e

echo "==> Instalando dependencias para compilar OneDrive desde fuente..."
sudo apt update
sudo apt install -y git curl build-essential ldc dub libcurl4-openssl-dev \
    libsqlite3-dev libpcre2-dev libssl-dev libxml2-dev uuid-dev

ONEDRIVE_DIR="$HOME/onedrive-src"

if [ -d "$ONEDRIVE_DIR" ]; then
    echo "==> Actualizando repositorio existente en $ONEDRIVE_DIR"
    cd "$ONEDRIVE_DIR"
    git pull
else
    echo "==> Clonando OneDrive desde GitHub..."
    git clone https://github.com/abraunegg/onedrive.git "$ONEDRIVE_DIR"
    cd "$ONEDRIVE_DIR"
fi

echo "==> Compilando OneDrive..."
./configure
make clean
make

echo "==> Instalando OneDrive..."
sudo make install

echo "==> Verificando instalacion..."
onedrive --version

echo ""
echo "=== OneDrive instalado correctamente ==="
echo ""
echo "Para configurarlo:     onedrive --synchronize"
echo "Como servicio:          systemctl --user enable --now onedrive"
echo "Interfaz grafica:      onedrive-gui"
