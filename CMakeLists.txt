cmake_minimum_required(VERSION 3.12)

project(sonic-pi)

#TODO set CMAKE_INSTALL_LIBEXECDIR and CMAKE_INSTALL_DATAROOTDIR on !linux
if (NOT WIN32 AND NOT APPLE)
  include(GNUInstallDirs)
endif (NOT WIN32 AND NOT APPLE)

add_subdirectory(scheduler)
add_subdirectory(server)
add_subdirectory(gui)

