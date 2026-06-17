#!/bin/bash

# Asegurarse de que estamos en la carpeta del script
cd "$(dirname "$0")"

echo "--- Iniciando instalación de Rclone Browser ---"

# 1. Preparar la carpeta de construcción
mkdir -p build && cd build

# 2. Configurar y compilar
echo "--- Generando compilación (cmake) ---"
cmake ..
echo "--- Compilando código (make) ---"
make

# 3. Instalación al sistema
# Esto copiará el ejecutable a /usr/local/bin y los recursos a /usr/share
echo "--- Instalando en el sistema (requiere sudo) ---"
sudo make install

# 4. Asegurar que el icono y el lanzador sean reconocidos
echo "--- Actualizando base de datos de aplicaciones ---"
sudo update-desktop-database

echo "----------------------------------------------------"
echo "¡Instalación finalizada con éxito!"
echo "Ya puedes encontrar Rclone Browser en tu menú de aplicaciones."
echo "----------------------------------------------------"

# Pausa para que el usuario pueda ver el resultado si ejecutó con doble clic
read -p "Presiona Enter para cerrar esta ventana..."
