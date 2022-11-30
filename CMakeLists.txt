CMAKE_MINIMUM_REQUIRED(VERSION 3.10)

SET(CMAKE_VERBOSE_MAKEFILE ON CACHE STRING "Verbose build." FORCE)

IF(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    MESSAGE(FATAL_ERROR "cannot build the project in the source directory! Out-of-source build is enforced!")
ENDIF()

SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH})
SET(DOXYFILE_PATH ${CMAKE_SOURCE_DIR}/docs)

include(HunterGate)
# TODO: replace with vcpkg
HunterGate(
        URL "https://${URL_BASE}/FISCO-BCOS/hunter/archive/7e7506db44502c14d9461d6b0e428fc29c5c66f6.tar.gz"
        SHA1 "fe43ce58853fa09c37c21fb073582e8fbb735b12"
)

PROJECT(libhdfs3 VERSION "3.0.0")

if (NOT DEFINED WITH_HUNTER_PKG)
	set(WITH_HUNTER_PKG OFF)
endif()

if(WITH_HUNTER_PKG)
  hunter_add_package(libxml2)
  hunter_add_package(Protobuf)
  hunter_add_package(uuid)
  set(CMAKE_PREFIX_PATH ${HUNTER_INSTALL_PREFIX})
  # prefer to use hunter library
  set(CMAKE_LIBRARY_PATH ${HUNTER_INSTALL_PREFIX}/lib)
  message("@ CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
endif()

INCLUDE(Platform)
INCLUDE(Functions)
INCLUDE(Options)

FIND_PACKAGE(LibXml2 REQUIRED)
FIND_PACKAGE(Protobuf REQUIRED)
FIND_PACKAGE(KERBEROS REQUIRED)
FIND_PACKAGE(GSasl REQUIRED)

IF(OS_LINUX)
    FIND_PACKAGE(LibUUID REQUIRED)
ENDIF(OS_LINUX)

ADD_SUBDIRECTORY(mock)
ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(gtest)
ADD_SUBDIRECTORY(gmock)
ADD_SUBDIRECTORY(test)
ADD_SUBDIRECTORY(hdfs_benchmark)

ADD_CUSTOM_TARGET(doc
	COMMAND doxygen ${CMAKE_BINARY_DIR}/src/doxyfile
	WORKING_DIRECTORY ${DOXYFILE_PATH}
	COMMENT "Generate documents..."
)

ADD_CUSTOM_TARGET(style
	COMMAND astyle --style=attach --indent=spaces=4 --indent-preprocessor --break-blocks --pad-oper --pad-header --unpad-paren --delete-empty-lines --suffix=none --align-pointer=middle --lineend=linux --indent-col1-comments ${libhdfs3_SOURCES}
	COMMAND astyle --style=attach --indent=spaces=4 --indent-preprocessor --break-blocks --pad-oper --pad-header --unpad-paren --delete-empty-lines --suffix=none --align-pointer=middle --lineend=linux --indent-col1-comments ${unit_SOURCES}
	COMMAND astyle --style=attach --indent=spaces=4 --indent-preprocessor --break-blocks --pad-oper --pad-header --unpad-paren --delete-empty-lines --suffix=none --align-pointer=middle --lineend=linux --indent-col1-comments ${function_SOURCES}
	COMMAND astyle --style=attach --indent=spaces=4 --indent-preprocessor --break-blocks --pad-oper --pad-header --unpad-paren --delete-empty-lines --suffix=none --align-pointer=middle --lineend=linux --indent-col1-comments ${secure_SOURCES}
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
	COMMENT "format code style..."
)

include(InstallConfig)
install(
    TARGETS libhdfs3-static libhdfs3-shared
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)
# install the include files for hash
INSTALL(FILES ${HEADER} DESTINATION include/hdfs)

