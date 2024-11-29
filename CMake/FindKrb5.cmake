# - Find kerberos
# Find the native KERBEROS includes and library
#
#  KERBEROS_INCLUDE_DIRS - where to find krb5.h, etc.
#  KERBEROS_LIBRARIES    - List of libraries when using krb5.
#  KERBEROS_FOUND        - True if krb5 found.

find_path(KERBEROS_INCLUDE_DIRS krb5.h PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include" NO_DEFAULT_PATH)

set(LIB_DIR "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib")
# libkrb5
find_library(Krb5_LIB_PATH NAMES krb5 PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
list(APPEND KERBEROS_LIBRARY ${Krb5_LIB_PATH})
message("*** Krb5_LIB_PATH: ${Krb5_LIB_PATH} **")

# libk5crypto
find_library(K5crypto_LIB_PATH NAMES k5crypto PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
list(APPEND KERBEROS_LIBRARY ${K5crypto_LIB_PATH})
message("*** K5crypto_LIB_PATH: ${K5crypto_LIB_PATH} **")

# libcom_err
find_library(Com_err_LIB_PATH NAMES com_err PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
list(APPEND KERBEROS_LIBRARY ${Com_err_LIB_PATH})
message("*** Com_err_LIB_PATH: ${Com_err_LIB_PATH} **")

# handle the QUIETLY and REQUIRED arguments and set KERBEROS_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(KERBEROS DEFAULT_MSG KERBEROS_LIBRARIES KERBEROS_INCLUDE_DIRS)

MARK_AS_ADVANCED(KERBEROS_LIBRARIES KERBEROS_INCLUDE_DIRS)

message("*** KERBEROS_LIBRARIES: ${KERBEROS_LIBRARIES} **")
message("*** KERBEROS_INCLUDE_DIRS: ${KERBEROS_INCLUDE_DIRS} **")
