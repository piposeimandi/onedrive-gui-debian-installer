#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo " OneDrive + OneDriveGUI para Fedora 44"
echo "========================================"
echo ""

echo "[1/2] Instalando OneDrive CLI..."
echo "----------------------------------------"
bash "$DIR/install_onedrive.sh"

echo ""
echo "[2/2] Instalando OneDriveGUI..."
echo "----------------------------------------"
bash "$DIR/install_onedrivegui.sh"

echo ""
echo "========================================"
echo " Instalacion completada"
echo "========================================"
echo ""
echo " Pasos siguientes:"
echo "   1. onedrive --synchronize   (autenticar)"
echo "   2. systemctl --user enable --now onedrive"
echo "   3. onedrive-gui             (interfaz grafica)"
echo ""
