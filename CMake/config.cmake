# add CMAKE_POSITION_INDEPENDENT_CODE flag for link with dynamic library of libhdfs3

hunter_config(Protobuf VERSION "3.19.4-p0"
    URL https://github.com/cpp-pm/protobuf/archive/v3.19.4-p0.tar.gz
    SHA1 e5b797dbc4e6ad92d0924ae86c130be4354c35b6
    CMAKE_ARGS CMAKE_POSITION_INDEPENDENT_CODE=TRUE
)
hunter_config(libxml2 VERSION "2.9.7-p0" CMAKE_ARGS CMAKE_POSITION_INDEPENDENT_CODE=TRUE)
hunter_config(uuid VERSION 1.0.3 CMAKE_ARGS CMAKE_POSITION_INDEPENDENT_CODE=TRUE)