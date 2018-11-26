cmake_minimum_required(VERSION 3.12)

project(sonic-pi)

list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)

#TODO set CMAKE_INSTALL_LIBEXECDIR and CMAKE_INSTALL_DATAROOTDIR on !linux
if (NOT WIN32 AND NOT APPLE)
  include(GNUInstallDirs)
endif (NOT WIN32 AND NOT APPLE)

# If vendor/bundle does not exist, run bundle install

#if (NOT EXISTS vendor/bundle)
add_custom_target(bundled_gems ALL bundle install --path vendor/bundle
								BYPRODUCTS Gemfile.lock
								COMMENT "Running bundle install"
								VERBATIM)

add_subdirectory(scheduler)
add_subdirectory(server)
add_subdirectory(gui)

# Install gems
#TODO remove tests, specs, examples and other unnecessary stuff
if (NOT WIN32 AND NOT APPLE)
  install(DIRECTORY vendor DESTINATION ${CMAKE_INSTALL_DATAROOTDIR})
endif (NOT WIN32 AND NOT APPLE)
