# Instalador OneDrive + OneDriveGUI

> [🇬🇧 Read in English](README.md)

Instalacion automatizada de **OneDrive Client** (CLI) y **OneDriveGUI** (interfaz grafica) para Linux.

## Distribuciones soportadas

| Distribucion | Carpeta de scripts | Notas |
|---|---|---|
| Debian 13 (Trixie) y derivados | `debian/` | Compila OneDrive CLI desde fuente (apt) |
| Fedora 44 | `fedora/` | Instala el paquete nativo `onedrive` (dnf) |

## Contenido

```
/
├── install_all.sh          # Entrada principal: detecta la distro y delega
├── debian/
│   ├── install_all.sh      # Ejecuta ambos scripts en orden (Debian)
│   ├── install_onedrive.sh     # Compila e instala abraunegg/onedrive desde fuente (apt)
│   └── install_onedrivegui.sh  # Instala bpozdena/OneDriveGUI desde fuente (apt + pip)
└── fedora/
    ├── install_all.sh      # Ejecuta ambos scripts en orden (Fedora)
    ├── install_onedrive.sh     # Instala onedrive desde los repos de Fedora (dnf)
    └── install_onedrivegui.sh  # Instala bpozdena/OneDriveGUI desde fuente (dnf PySide6 + pip)
```

El `OneDriveGUI-*.AppImage` es una alternativa portable que se puede usar en cualquiera de las dos distribuciones.

## Requisitos

- Debian 13 (Trixie)/derivados o Fedora 44
- `sudo` configurado
- Conexion a internet

## Instalacion rapida

Desde la raiz del repositorio (detecta automaticamente tu distribucion):

```bash
chmod +x install_all.sh
./install_all.sh
```

O manualmente por distribucion:

```bash
# Debian / Ubuntu / derivados
./debian/install_all.sh

# Fedora
./fedora/install_all.sh
```

## Uso

```bash
# Primera autenticacion
onedrive --synchronize

# Servicio en segundo plano
systemctl --user enable --now onedrive

# Interfaz grafica
onedrive-gui
```

## Que hace cada script?

### `install_onedrive.sh`

El comportamiento difiere segun la distribucion:

- **Debian** (`debian/install_onedrive.sh`): compila desde fuente. Instala dependencias
  de compilacion (`ldc`, `dub`, `libcurl`, `libsqlite3`, etc.), clona el repositorio
  oficial de OneDrive (abraunegg/onedrive) en `~/onedrive-src`, compila con `make`
  e instala con `sudo make install`. Verifica que `onedrive --version` funciona.
- **Fedora** (`fedora/install_onedrive.sh`): instala el **paquete nativo `onedrive`**
  desde los repositorios oficiales de Fedora con `sudo dnf install -y onedrive`.
  Los paquetes de Fedora son relativamente actuales; si se quisiera la version mas reciente
  de git, habria que compilar desde fuente, pero la via nativa es la preferida.
  Verifica que `onedrive --version` funciona.

### `install_onedrivegui.sh`

El paso de dependencias del sistema difiere segun la distribucion:

- **Debian** (`debian/install_onedrivegui.sh`): PySide6 viene partido en paquetes
  individuales (`python3-pyside6.qtcore`, `python3-pyside6.qtgui`,
  `python3-pyside6.qtwidgets`, `python3-pyside6.qtwebenginewidgets`,
  `python3-pyside6.qtsvg`) mas `python3-requests`.
- **Fedora** (`fedora/install_onedrivegui.sh`): PySide6 es un **unico paquete**
  (`python3-pyside6`) mas `python3-requests` y `python3-pip`.

En ambos casos, luego: clona OneDriveGUI (bpozdena/OneDriveGUI) en `~/OneDriveGUI`,
instala las dependencias pip, crea el wrapper en `/usr/local/bin/onedrive-gui` y crea
la entrada `.desktop` para el menu de aplicaciones.

## Notas tecnicas

- **Debian 13 no incluye `libpcre3-dev`** — fue reemplazado por `libpcre2-dev` (PCRE2).
  El compilador D (LDC) y OneDrive no requieren PCRE para compilar, por lo que no es necesario
  instalar ninguno de los dos.
- **PySide6 en Debian 13** viene partido en paquetes individuales (`python3-pyside6.qt*`)
  en version 6.8.2. No existe el meta-paquete `python3-pyside6`.
- **PySide6 en Fedora 44** es un unico paquete `python3-pyside6` (6.11.1-4.fc44),
  que incluye QtWebEngine como dependencia.
- **Fedora incluye `onedrive` de forma nativa** en sus repositorios oficiales, por lo que
  se instala via `dnf` en lugar de compilarse desde fuente.
- **No es necesario el AppImage** si instalas desde fuente, pero queda como alternativa
  si prefieres no clonar el repositorio.

## Actualizar

Los scripts son idempotentes: volver a ejecutarlos hace `git pull` y recompila/reinstala.

```bash
# Debian
./debian/install_onedrive.sh      # actualiza CLI (recompila)
./debian/install_onedrivegui.sh   # actualiza GUI

# Fedora
./fedora/install_onedrive.sh      # actualiza CLI (dnf upgrade)
./fedora/install_onedrivegui.sh   # actualiza GUI
```

## Licencia

Los scripts de este repositorio son de dominio publico.
Los proyectos instalados tienen sus propias licencias:
- [abraunegg/onedrive](https://github.com/abraunegg/onedrive) — GPLv3
- [bpozdena/OneDriveGUI](https://github.com/bpozdena/OneDriveGUI) — GPLv3
