cmake_minimum_required(VERSION 3.2)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -march=native -msse -msse2")
set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -msse -msse2")

#set(CMAKE_BUILD_TYPE Release)

set(SOURCE_FILES main.cpp)
add_executable(hdfs_benchmark ${SOURCE_FILES})
add_dependencies(hdfs_benchmark libhdfs3-static)

target_link_libraries(hdfs_benchmark pthread libhdfs3-static)