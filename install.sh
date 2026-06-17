#!/bin/bash

echo "--- Iniciando instalación de Rclone Browser ---"

# 1. Instalar dependencias
sudo apt update && sudo apt install -y cmake g++ qtbase5-dev qt5-qmake

# 2. Preparar el directorio de build
mkdir -p build
# Borramos el contenido de build, pero mantenemos la carpeta
rm -rf build/*

# 3. Compilar
echo "Compilando... esto puede tardar unos minutos."
# Cambiamos '..' por '.' para que busque en la carpeta actual
cmake -S . -B build -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations"
cd build
make -j$(nproc)

# 4. Instalar en el sistema
echo "Instalando en /opt/..."
sudo mkdir -p /opt/rclone-browser/
# Buscamos el binario donde realmente se genera (que en este proyecto suele ser en build/src o build/build)
# Si 'make' lo dejó en build/src o build, lo copiaremos
find . -name "rclone-browser" -type f -exec sudo cp {} /opt/rclone-browser/rclone-browser \;
sudo cp ../assets/rclone-browser-256x256.png /opt/rclone-browser/rclone_logo.png

# 5. Crear lanzador .desktop
echo "Creando acceso directo..."
cat <<EOF | sudo tee /usr/share/applications/rclone-browser.desktop
[Desktop Entry]
Name=Rclone Browser
Comment=Interfaz grafica nativa para Rclone
Exec=/opt/rclone-browser/rclone-browser
Icon=/opt/rclone-browser/rclone_logo.png
Terminal=false
Type=Application
Categories=Utility;FileTools;
EOF

# 6. Refrescar menú
sudo update-desktop-database
echo "--- ¡Instalación exitosa! Ya puedes buscar 'Rclone Browser' en tu menú ---"
