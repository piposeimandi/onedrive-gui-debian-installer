#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"

# Detectar distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
fi

case "$ID" in
    debian|ubuntu|linuxmint|pop|elementary|zorin|neon)
        DISTRO="debian"
        ;;
    fedora)
        DISTRO="fedora"
        ;;
    *)
        echo "Error: distro no soportada (ID=\"$ID\")." >&2
        echo "Soportadas: Debian/Ubuntu/derivados, Fedora." >&2
        exit 1
        ;;
esac

echo "========================================"
echo " OneDrive + OneDriveGUI para $PRETTY_NAME"
echo "========================================"
echo ""

exec bash "$DIR/$DISTRO/install_all.sh"
