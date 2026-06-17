cmake_minimum_required(VERSION 3.5...3.28)
project(RcloneBrowser)

if(POLICY CMP0048)
  cmake_policy(SET CMP0048 NEW)
endif()

# Buscamos Qt5 obligatoriamente
find_package(Qt5 COMPONENTS Widgets Network REQUIRED)

# Conectamos con la carpeta src
add_subdirectory(src)
# Instrucciones de instalación para el usuario final
install(TARGETS rclone-browser RUNTIME DESTINATION bin)
install(FILES "assets/rclone-browser.svg" DESTINATION "share/icons/hicolor/scalable/apps")
install(FILES "assets/rclone-browser.desktop" DESTINATION "share/applications")
