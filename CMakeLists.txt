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

# vcpkg init
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    find_package(Git REQUIRED)
    execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake" CACHE STRING "Vcpkg toolchain file")
endif()

PROJECT(libhdfs3 VERSION "3.0.0")

find_package(libxml2 REQUIRED)

find_package(protobuf REQUIRED)

if ("${CMAKE_SYSTEM_NAME}" MATCHES "Linux")
	find_package(unofficial-libuuid REQUIRED)
	set(LIBUUID_LIBRARIES unofficial::UUID::uuid)
endif()

INCLUDE(Platform)
INCLUDE(Functions)
INCLUDE(Options)

IF (WITH_KERBEROS)
    FIND_PACKAGE(KERBEROS REQUIRED)
ENDIF()

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