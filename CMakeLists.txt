CMAKE_MINIMUM_REQUIRED(VERSION 3.10)

SET(CMAKE_VERBOSE_MAKEFILE ON CACHE STRING "Verbose build." FORCE)

IF(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    MESSAGE(FATAL_ERROR "cannot build the project in the source directory! Out-of-source build is enforced!")
ENDIF()

SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH})
SET(DOXYFILE_PATH ${CMAKE_SOURCE_DIR}/docs)

if (NOT DEFINED URL_BASE)
    set(URL_BASE "github.com")
endif()

include(HunterGate)
# TODO: replace with vcpkg
HunterGate(
        URL "https://${URL_BASE}/FISCO-BCOS/hunter/archive/6f5b62b2f3a063146ba9e99039449c9f966c465b.tar.gz"
        SHA1 "ba678314e36f4761c94206f873960d7e91d2f88f"
        FILEPATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake/config.cmake"
)

PROJECT(libhdfs3 VERSION "3.0.0")

if (NOT DEFINED WITH_HUNTER_PKG)
	set(WITH_HUNTER_PKG OFF)
endif()

hunter_add_package(libxml2)
find_package(libxml2 CONFIG REQUIRED)

hunter_add_package(Protobuf)
find_package(Protobuf CONFIG REQUIRED)

hunter_add_package(uuid)
find_package(uuid CONFIG REQUIRED)

INCLUDE(Platform)
INCLUDE(Functions)
INCLUDE(Options)

FIND_PACKAGE(Protobuf REQUIRED)
FIND_PACKAGE(KERBEROS REQUIRED)
FIND_PACKAGE(GSasl REQUIRED)

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