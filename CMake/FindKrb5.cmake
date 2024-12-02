# - Find kerberos
# Find the native KERBEROS includes and library
#
#  KERBEROS_INCLUDE_DIRS - where to find krb5.h, etc.
#  KERBEROS_LIBRARIES    - List of libraries when using krb5.
#  KERBEROS_FOUND        - True if krb5 found.

find_path(KERBEROS_INCLUDE_DIRS krb5.h PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include" NO_DEFAULT_PATH)

set(LIB_DIR "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib")
# libgssapi_krb5
find_library(Gssapi_krb5_LIB_PATH NAMES gssapi_krb5 PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
message("*** Gssapi_krb5_LIB_PATH: ${Gssapi_krb5_LIB_PATH} **")
# libkrb5_otp
find_library(Krb5_otp_LIB_PATH NAMES krb5_otp PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
message("*** Krb5_otp_LIB_PATH: ${Krb5_otp_LIB_PATH} **")
# libkrb5_k5tls
find_library(Krb5_k5tls_LIB_PATH NAMES krb5_k5tls PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
message("*** Krb5_k5tls_LIB_PATH: ${Krb5_k5tls_LIB_PATH} **")
# libkrb5support
find_library(Krb5support_LIB_PATH NAMES krb5support PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
message("*** Krb5support_LIB_PATH: ${Krb5support_LIB_PATH} **")
# libkrb5
find_library(Krb5_LIB_PATH NAMES krb5 PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
message("*** Krb5_LIB_PATH: ${Krb5_LIB_PATH} **")

# libk5crypto
find_library(K5crypto_LIB_PATH NAMES k5crypto PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
message("*** K5crypto_LIB_PATH: ${K5crypto_LIB_PATH} **")

# libcom_err
find_library(Com_err_LIB_PATH NAMES com_err PATHS "${LIB_DIR}" NO_DEFAULT_PATH)
message("*** Com_err_LIB_PATH: ${Com_err_LIB_PATH} **")

# Note: Must notice the library link orders
set(KERBEROS_LIBRARIES ${Gssapi_krb5_LIB_PATH} 
    ${Krb5_LIB_PATH} 
    ${Com_err_LIB_PATH} ${Krb5_otp_LIB_PATH}
    ${Krb5_k5tls_LIB_PATH}  ${K5crypto_LIB_PATH} 
    ${Krb5support_LIB_PATH})

MARK_AS_ADVANCED(KERBEROS_LIBRARIES KERBEROS_INCLUDE_DIRS)

message("*** KERBEROS_LIBRARIES: ${KERBEROS_LIBRARIES} **")
message("*** KERBEROS_INCLUDE_DIRS: ${KERBEROS_INCLUDE_DIRS} **")