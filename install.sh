#!/bin/bash
echo "--- Iniciando instalación de Rclone Browser ---"

# 1. Verificar dependencias
echo "Verificando dependencias..."
sudo apt update && sudo apt install -y cmake g++ qtbase5-dev qt5-qmake || { echo "Error instalando dependencias"; exit 1; }

# 2. Compilación segura
echo "Compilando código fuente..."
mkdir -p build
cd build || exit 1
rm -rf CMakeCache.txt CMakeFiles/

# Ejecutar cmake y make
cmake .. -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations" || { echo "Error en CMake"; exit 1; }
make -j$(nproc) || { echo "Error en la compilación"; exit 1; }

# 3. Instalación (Moviendo archivos al destino final)
echo "Instalando binarios en /opt/rclone-browser/..."
sudo mkdir -p /opt/rclone-browser/

# Copiar el binario compilado (buscando en ambos lugares probables)
if [ -f "rclone-browser" ]; then
    sudo cp rclone-browser /opt/rclone-browser/rclone-browser
elif [ -f "src/rclone-browser" ]; then
    sudo cp src/rclone-browser /opt/rclone-browser/rclone-browser
else
    echo "Error: No se encontró el ejecutable 'rclone-browser' ni en build/ ni en build/src/"
    exit 1
fi

# Copiar el icono (buscando en la carpeta assets original)
cd ..
if [ -f "assets/rclone-browser-256x256.png" ]; then
    sudo cp assets/rclone-browser-256x256.png /opt/rclone-browser/rclone_logo.png
else
    echo "Advertencia: Icono no encontrado, el acceso directo no tendrá imagen."
fi

# 4. Crear lanzador (Desktop Entry)
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

sudo update-desktop-database
echo "--- ¡Instalación exitosa! Ya puedes buscar 'Rclone Browser' en tu menú ---"
