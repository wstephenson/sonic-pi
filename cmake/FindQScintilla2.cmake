# - try to find QScintilla2 libraries and include files
# QSCINTILLA2_INCLUDE_DIR where to find qwt_global.h, etc.
# QSCINTILLA2_LIBRARIES libraries to link against
# QSCINTILLA2_FOUND If false, do not try to use Qwt
# qwt_global.h holds a string with the QSCINTILLA2 version;
#   test to make sure it's at least 5.2

set(QSCINTILLA2_QT_VERSION qt5)

find_path(QSCINTILLA2_INCLUDE_DIRS
  NAMES qsciglobal.h
  HINTS
  ${CMAKE_INSTALL_PREFIX}/include/qwt
  ${CMAKE_PREFIX_PATH}/include/qwt
  PATHS
  /usr/local/include/qscintilla2-${QSCINTILLA2_QT_VERSION}
  /usr/local/include/qscintilla2
  /usr/include/qscintilla2
		/usr/include/qt5/Qsci
  /usr/include/qscintilla2-${QSCINTILLA2_QT_VERSION}
  /usr/include/qscintilla2
  /usr/include/${QSCINTILLA2_QT_VERSION}/qscintilla2
  /usr/include/qscintilla2
  /opt/local/include/qscintilla2
  /sw/include/qscintilla2
  /usr/local/lib/qscintilla2.framework/Headers
)

find_library (QSCINTILLA2_LIBRARIES
  NAMES qscintilla2_${QSCINTILLA2_QT_VERSION}
  HINTS
  ${CMAKE_INSTALL_PREFIX}/lib
  ${CMAKE_INSTALL_PREFIX}/lib64
  ${CMAKE_PREFIX_PATH}/lib
  PATHS
  /usr/local/lib
  /usr/lib
  /opt/local/lib
  /sw/lib
  /usr/local/lib/qscintilla2.framework
)

set(QSCINTILLA2_FOUND FALSE)
if(QSCINTILLA2_INCLUDE_DIRS)
  file(STRINGS "${QSCINTILLA2_INCLUDE_DIRS}/qsciglobal.h"
    QSCINTILLA2_STRING_VERSION REGEX "QSCINTILLA_VERSION_STR")
  set(QSCINTILLA2_WRONG_VERSION True)
  set(QSCINTILLA2_VERSION "No Version")
  string(REGEX MATCH "[0-9]+.[0-9]+.[0-9]+" QSCINTILLA2_VERSION ${QSCINTILLA2_STRING_VERSION})
  string(COMPARE LESS ${QSCINTILLA2_VERSION} "2.0.0" QSCINTILLA2_WRONG_VERSION)
		string(COMPARE GREATER_EQUAL ${QSCINTILLA2_VERSION} "3.0.0" QSCINTILLA2_WRONG_VERSION)

  message(STATUS "QScintilla2 version: ${QSCINTILLA2_VERSION}")
  if(NOT QSCINTILLA2_WRONG_VERSION)
    set(QSCINTILLA2_FOUND TRUE)
  else(NOT QSCINTILLA2_WRONG_VERSION)
    message(STATUS "QScintilla2 version must be >= 2.0 and < 3.0.0, Found ${QSCINTILLA2_VERSION}")
  endif(NOT QSCINTILLA2_WRONG_VERSION)
else(QSCINTILLA2_INCLUDE_DIRS)
  message(STATUS "QScintilla2 not found.")
endif(QSCINTILLA2_INCLUDE_DIRS)

if(QSCINTILLA2_FOUND)
  # handle the QUIETLY and REQUIRED arguments and set QSCINTILLA2_FOUND to TRUE if
  # all listed variables are TRUE
  include ( FindPackageHandleStandardArgs )
		find_package_handle_standard_args( QScintilla2 DEFAULT_MSG QSCINTILLA2_LIBRARIES QSCINTILLA2_INCLUDE_DIRS )
  MARK_AS_ADVANCED(QSCINTILLA2_LIBRARIES QSCINTILLA2_INCLUDE_DIRS)
endif(QSCINTILLA2_FOUND)
