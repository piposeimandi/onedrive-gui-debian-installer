#!/bin/bash
set -e

# Fedora ofrece `onedrive` en sus repositorios oficiales (a diferencia de Debian,
# donde hay que compilarlo desde fuente). Por eso instalamos el paquete nativo.
# Los paquetes de Fedora son relativamente actuales (el CLI se actualiza seguido).
# Si se quisiera la version mas reciente de git, habria que compilar desde fuente;
# pero la via nativa es la preferida.

echo "==> Instalando OneDrive CLI desde los repositorios de Fedora..."
sudo dnf install -y onedrive

echo "==> Verificando instalacion..."
onedrive --version

echo ""
echo "=== OneDrive instalado correctamente ==="
echo ""
echo "Para configurarlo:     onedrive --synchronize"
echo "Como servicio:          systemctl --user enable --now onedrive"
echo "Interfaz grafica:      onedrive-gui"
