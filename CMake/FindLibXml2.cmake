# - Find libxml2
# Find the native LIBXML2 includes and library
#
#  LIBXML2_INCLUDE_DIRS - where to find libxml, etc.
#  LIBXML2_LIBRARIES    - List of libraries when using libxml2.
#  LIBXML2_FOUND        - True if libxml2 found.

IF (LIBXML2_INCLUDE_DIRS)
  # Already in cache, be silent
  SET(LIBXML2_FIND_QUIETLY TRUE)
ENDIF (LIBXML2_INCLUDE_DIRS)

FIND_PATH(LIBXML2_INCLUDE_DIRS libxml)
message("@ LIBXML2_INCLUDE_DIRS: ${LIBXML2_INCLUDE_DIRS}")

SET(LIBXML2_NAMES libxml2)
FIND_LIBRARY(LIBXML2_LIBRARIES NAMES ${LIBXML2_NAMES})

# handle the QUIETLY and REQUIRED arguments and set LIBXML2_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBXML2 DEFAULT_MSG LIBXML2_LIBRARIES LIBXML2_INCLUDE_DIRS)

MARK_AS_ADVANCED(LIBXML2_LIBRARIES LIBXML2_INCLUDE_DIRS)
