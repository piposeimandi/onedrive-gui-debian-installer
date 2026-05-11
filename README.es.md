# OneDrive en Debian 13 (Trixie)

> [🇬🇧 Read in English](README.md)

Instalacion automatizada de **OneDrive Client** (CLI) y **OneDriveGUI** (interfaz grafica) desde codigo fuente.

## Contenido

| Archivo | Descripcion |
|---|---|
| `install_all.sh` | Ejecuta ambos scripts de instalacion en orden |
| `install_onedrive.sh` | Compila e instala [abraunegg/onedrive](https://github.com/abraunegg/onedrive) |
| `install_onedrivegui.sh` | Instala [bpozdena/OneDriveGUI](https://github.com/bpozdena/OneDriveGUI) desde codigo fuente |
| `OneDriveGUI-*.AppImage` | Version portatil de OneDriveGUI (alternativa) |

## Requisitos

- Debian 13 (Trixie) — tambien compatible con Debian 12 (Bookworm) y derivados
- `sudo` configurado
- Conexion a internet

## Instalacion rapida

```bash
chmod +x install_all.sh install_onedrive.sh install_onedrivegui.sh
./install_all.sh
```

O paso a paso:

```bash
# 1. Cliente CLI
./install_onedrive.sh

# 2. Interfaz grafica
./install_onedrivegui.sh
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

1. Instala dependencias de compilacion: `ldc`, `dub`, `libcurl`, `libsqlite3`, etc.
2. Clona el repositorio oficial de OneDrive (abraunegg/onedrive) en `~/onedrive-src`
3. Compila con `make` e instala con `sudo make install`
4. Verifica que `onedrive --version` funciona

### `install_onedrivegui.sh`

1. Instala dependencias del sistema: `python3-pyside6.qtcore`, `python3-pyside6.qtgui`,
   `python3-pyside6.qtwidgets`, `python3-pyside6.qtwebenginewidgets`, `python3-requests`
2. Clona OneDriveGUI (bpozdena/OneDriveGUI) en `~/OneDriveGUI`
3. Instala dependencias pip (`urllib3<2.0`)
4. Crea el wrapper `/usr/local/bin/onedrive-gui`
5. Crea entrada `.desktop` para el menu de aplicaciones

## Notas tecnicas

- **Debian 13 no incluye `libpcre3-dev`** — fue reemplazado por `libpcre2-dev` (PCRE2).
  El compilador D (LDC) y OneDrive no requieren PCRE para compilar, por lo que no es necesario
  instalar ninguno de los dos.
- **PySide6 en Debian 13** viene partido en paquetes individuales (`python3-pyside6.qt*`)
  en version 6.8.2. No existe el meta-paquete `python3-pyside6`.
- **No es necesario el AppImage** si instalas desde fuente, pero queda como alternativa
  si prefieres no clonar el repositorio.

## Actualizar

Los scripts son idempotentes: volver a ejecutarlos hace `git pull` y recompila/reinstala.

```bash
./install_onedrive.sh      # actualiza CLI
./install_onedrivegui.sh   # actualiza GUI
```

## Licencia

Los scripts de este repositorio son de dominio publico.
Los proyectos instalados tienen sus propias licencias:
- [abraunegg/onedrive](https://github.com/abraunegg/onedrive) — GPLv3
- [bpozdena/OneDriveGUI](https://github.com/bpozdena/OneDriveGUI) — GPLv3
