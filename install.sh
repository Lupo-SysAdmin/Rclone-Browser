#!/bin/bash
echo "--- Iniciando instalación de Rclone Browser ---"

# Verificar dependencias
sudo apt update && sudo apt install -y cmake g++ qtbase5-dev qt5-qmake || exit 1

# Compilación segura
echo "Compilando..."
mkdir -p build
cd build || exit 1
rm -rf CMakeCache.txt CMakeFiles/
cmake .. -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations" || { echo "Error en CMake"; exit 1; }
make -j$(nproc) || { echo "Error en la compilación"; exit 1; }

# Instalación
echo "Instalando en /opt/..."
sudo mkdir -p /opt/rclone-browser/
sudo cp rclone-browser /opt/rclone-browser/rclone-browser

# Crear lanzador
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

sudo update-desktop-database
echo "--- ¡Instalación exitosa! ---"
