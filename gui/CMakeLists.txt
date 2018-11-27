set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Qt5 COMPONENTS Core Gui Concurrent Network OpenGL Widgets REQUIRED)
find_package(PkgConfig)
find_package(QScintilla2 REQUIRED)
find_package(Qwt REQUIRED)
find_package(Threads REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_AUTORCC ON)

set(sonicpi_SRCS
    main.cpp
    mainwindow.cpp
    sonicpilexer.cpp
    sonicpiapis.cpp
    sonicpiscintilla.cpp
    oschandler.cpp
    oscsender.cpp
    sonicpilog.cpp
    sonic_pi_osc_server.cpp
    sonic_pi_udp_osc_server.cpp
    sonic_pi_tcp_osc_server.cpp
    sonicpitheme.cpp
    scope.cpp
    infowidget.cpp)

set(sonicpi_RESOURCES
    SonicPi.qrc
    help_files.qrc
    info_files.qrc)

add_executable(sonic-pi ${sonicpi_SRCS} ${sonicpi_RESOURCES})

include_directories(${QWT_INCLUDE_DIRS} ${QSCINTILLA2_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/gui)
target_link_libraries(sonic-pi Threads::Threads Qt5::Core Qt5::Gui Qt5::Network Qt5::Concurrent Qt5::OpenGL Qt5::Widgets rt ${QSCINTILLA2_LIBRARIES} ${QWT_LIBRARIES})

install(PROGRAMS sonic-pi DESTINATION ${CMAKE_INSTALL_BINDIR})
