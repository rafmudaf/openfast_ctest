### OpenFAST regression test steering script

### Set host name & build name
find_program(UNAME NAMES uname)
macro(getuname name flag)
  exec_program("${UNAME}" ARGS "${flag}" OUTPUT_VARIABLE "${name}")
endmacro(getuname)

getuname(osname -s)
getuname(cpu    -m)

set(CTEST_BUILD_NAME "${osname}-${COMPILERFLAG}-dev")
set(CTEST_SITE "eagle.hpc.nrel.gov")

### Environment setup
set(CTEST_SOURCE_DIRECTORY "$ENV{HOME}/Development/cdash/openfast_head_${COMPILERFLAG}")
set(CTEST_BINARY_DIRECTORY "${CTEST_SOURCE_DIRECTORY}/build")


### Commands
find_program(CTEST_COMMAND NAMES ctest)
find_program(CTEST_UPDATE_COMMAND NAMES git)
find_program(CTEST_CONFIGURE_COMMAND NAMES cmake)
find_program(CTEST_BUILD_COMMAND NAMES make)
find_program(COMPILER NAMES ${COMPILERFLAG} PATHS ${COMPILERPATH})


### Run CTest
message(" -- Start ${MODEL} - ${CTEST_BUILD_NAME} --")
ctest_start(${MODEL} TRACK ${MODEL})

# Update
message(" -- Update - ${CTEST_BUILD_NAME} --")
set(CTEST_GIT_INIT_SUBMODULES "ON")
# ctest_update(
#   SOURCE "${CTEST_SOURCE_DIRECTORY}"
#   RETURN_VALUE res
# )
message("ctest_update - number of files updated: ${res}")

# Configure
message(" -- Configure - ${CTEST_BUILD_NAME} --")
file(REMOVE_RECURSE "${CTEST_BINARY_DIRECTORY}/reg_tests")  # The turbine model files seem to get corrupted, so copy again every time
set(options
  -DCMAKE_Fortran_COMPILER:PATH=${COMPILERFLAG}
  -DBUILD_TESTING:BOOL=ON
  -DCMAKE_INSTALL_PREFIX:PATH=${CTEST_SOURCE_DIRECTORY}/install
  -DCTEST_REGRESSION_TOL=0.00001
)
ctest_configure(
  BUILD "${CTEST_BINARY_DIRECTORY}"
  SOURCE "${CTEST_SOURCE_DIRECTORY}"
  OPTIONS "${options}"
  RETURN_VALUE res
)
message("ctest_configure - return value of native command: ${res}")

# # Build
# message(" -- Build - ${CTEST_BUILD_NAME} --")
# set(CTEST_BUILD_COMMAND "${CTEST_BUILD_COMMAND} -j4")
# # set(CTEST_BUILD_FLAGS "-j4")
# set(CTEST_BUILD_TARGET "install")
# ctest_build(
#   BUILD "${CTEST_BINARY_DIRECTORY}"
#   CONFIGURATION Release
#   RETURN_VALUE res
# )
# message("ctest_build - return value of native command: ${res}")

# # # Test
# message(" -- Test - ${CTEST_BUILD_NAME} --")
# ctest_test(
#   BUILD "${CTEST_BINARY_DIRECTORY}"
#   # INCLUDE AWT_YFix_WSt
#   # INCLUDE_LABEL "openfast"
#   # INCLUDE_LABEL "beamdyn"
#   # EXCLUDE_LABEL "openfast"
#   PARALLEL_LEVEL 4 #32  # the 5MW cases fail with -j32 due to multiple threads opening the same file for reading
#   RETURN_VALUE res
# )
# message("ctest_test - 0 if all tests pass: ${res}")

# # # Submit
# # message(" -- Submit - ${CTEST_BUILD_NAME} --")
# # # ctest_submit(RETRY_COUNT 20
# # #              RETRY_DELAY 20
# # #              RETURN_VALUE res)
# # message(" -- Finished - ${CTEST_BUILD_NAME} --")
