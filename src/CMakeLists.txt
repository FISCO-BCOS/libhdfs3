CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(libhdfs3_VERSION_MAJOR 2)
SET(libhdfs3_VERSION_MINOR 2)
SET(libhdfs3_VERSION_PATCH 30)
SET(libhdfs3_VERSION_STRING "${libhdfs3_VERSION_MAJOR}.${libhdfs3_VERSION_MINOR}.${libhdfs3_VERSION_PATCH}")
SET(libhdfs3_VERSION_API 1)
SET(libhdfs3_ROOT_SOURCES_DIR ${CMAKE_SOURCE_DIR}/src)
SET(libhdfs3_COMMON_SOURCES_DIR ${libhdfs3_ROOT_SOURCES_DIR}/common)

IF(ENABLE_DEBUG)
    SET(libhdfs3_VERSION_STRING "${libhdfs3_VERSION_STRING}d")
ENDIF(ENABLE_DEBUG)

CONFIGURE_FILE(platform.h.in platform.h)
CONFIGURE_FILE(doxyfile.in doxyfile)

AUTO_SOURCES(files "*.cpp" "RECURSE" "${CMAKE_CURRENT_SOURCE_DIR}")
LIST(APPEND libhdfs3_SOURCES ${files})

AUTO_SOURCES(files "*.cc" "RECURSE" "${CMAKE_CURRENT_SOURCE_DIR}")
LIST(APPEND libhdfs3_SOURCES ${files})

AUTO_SOURCES(files "*.c" "RECURSE" "${CMAKE_CURRENT_SOURCE_DIR}")
LIST(APPEND libhdfs3_SOURCES ${files})

AUTO_SOURCES(files "*.h" "RECURSE" "${CMAKE_CURRENT_SOURCE_DIR}")
LIST(APPEND libhdfs3_SOURCES ${files})

set(PROTO_INPUT_PATH ${CMAKE_SOURCE_DIR}/src/proto)
set(PROTO_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/generated)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR}/generated)

set(libhdfs3_PROTO_FILES "ClientDatanodeProtocol.proto;ClientNamenodeProtocol.proto;IpcConnectionContext.proto;ProtobufRpcEngine.proto;RpcHeader.proto;Security.proto;datatransfer.proto;hdfs.proto")
foreach(proto_file ${libhdfs3_PROTO_FILES})
    get_filename_component(bcos_proto_abs "${PROTO_INPUT_PATH}" ABSOLUTE)
    set(proto_file_abs ${bcos_proto_abs}/${proto_file})
    get_filename_component(rel_dir ${proto_file} DIRECTORY)
    get_filename_component(basename ${proto_file} NAME_WE)
    set(generated_files ${PROTO_OUTPUT_PATH}/${basename}.pb.cc)

    list(APPEND PROTO_SRCS ${generated_files})
    message("Command: protoc --cpp_out ${PROTO_OUTPUT_PATH} -I ${PROTO_INPUT_PATH} ${proto_file}")
    add_custom_command(
        OUTPUT ${generated_files}
        COMMAND protobuf::protoc --cpp_out ${PROTO_OUTPUT_PATH} -I ${PROTO_INPUT_PATH} ${proto_file}
        COMMENT "Generating ${generated_files} from ${proto_file_abs}"
        VERBATIM
    )
endforeach()

SET(HEADER 
    client/BlockLocation.h
    client/DirectoryIterator.h
    client/FileStatus.h
    client/FileSystem.h
    client/FileSystemStats.h
    client/hdfs.h
    client/InputStream.h
    client/OutputStream.h
    client/Permission.h
    common/Exception.h
    common/XmlConfig.h)

ADD_LIBRARY(${HDFS3_TARGET} ${libhdfs3_SOURCES} ${libhdfs3_PROTO_SOURCES} ${PROTO_SRCS})
ADD_CUSTOM_COMMAND(
    TARGET ${HDFS3_TARGET}
    PRE_BUILD
    COMMAND echo ${libhdfs3_VERSION_STRING} > version
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

if(NEED_BOOST)
find_package(Boost COMPONENTS atomic chrono iostreams thread system)
TARGET_LINK_LIBRARIES(${HDFS3_TARGET} PUBLIC pthread Boost::thread Boost::chrono Boost::system Boost::iostreams Boost::thread)
endif()

IF(NEED_GCCEH)
    TARGET_LINK_LIBRARIES(${HDFS3_TARGET} PUBLIC gcc_eh)
ENDIF(NEED_GCCEH)

IF(OS_LINUX)
    TARGET_LINK_LIBRARIES(${HDFS3_TARGET} PUBLIC unofficial::UUID::uuid)
ENDIF(OS_LINUX)

INCLUDE_DIRECTORIES(${libhdfs3_ROOT_SOURCES_DIR})
INCLUDE_DIRECTORIES(${libhdfs3_COMMON_SOURCES_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${KERBEROS_INCLUDE_DIRS})

INCLUDE_DIRECTORIES(${GSASL_INCLUDE_DIRS})
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/mock)

# Note: pthread maybe conflict with libc when build static library, so should put it into the first place when linking
TARGET_LINK_LIBRARIES(${HDFS3_TARGET} PUBLIC pthread ${GSASL_LIBRARIES} ${KERBEROS_LIBRARIES} protobuf::libprotobuf LibXml2::LibXml2 resolv)

SET_TARGET_PROPERTIES(${HDFS3_TARGET} PROPERTIES OUTPUT_NAME "hdfs3")

include(InstallConfig)
install(
    TARGETS ${HDFS3_TARGET}
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)
INSTALL(FILES ${HEADER} DESTINATION include/hdfs)
INSTALL(FILES libhdfs3.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

SET(libhdfs3_SOURCES ${libhdfs3_SOURCES} PARENT_SCOPE)
SET(libhdfs3_PLATFORM_HEADER_DIR ${CMAKE_CURRENT_BINARY_DIR} PARENT_SCOPE)
SET(libhdfs3_ROOT_SOURCES_DIR ${libhdfs3_ROOT_SOURCES_DIR} PARENT_SCOPE)
SET(libhdfs3_COMMON_SOURCES_DIR ${libhdfs3_COMMON_SOURCES_DIR} PARENT_SCOPE)
