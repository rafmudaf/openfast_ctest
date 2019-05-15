### OpenFAST regression test steering script

### Set host name & build name
find_program(UNAME NAMES uname)
macro(getuname name flag)
  exec_program("${UNAME}" ARGS "${flag}" OUTPUT_VARIABLE "${name}")
endmacro(getuname)

getuname(osname -s)
getuname(cpu    -m)

set(CTEST_BRANCH_NAME "dev")
set(CTEST_BUILD_NAME "${osname}-${COMPILERFLAG}-${CTEST_BRANCH_NAME}")
set(CTEST_SITE "eagle.hpc.nrel.gov")

### Environment setup
set(CTEST_SOURCE_DIRECTORY "$ENV{HOME}/Development/cdash/openfast_head_${COMPILERFLAG}")
set(CTEST_BINARY_DIRECTORY "${CTEST_SOURCE_DIRECTORY}/build")


### Commands
find_program(CTEST NAMES ctest)
find_program(GIT NAMES git)
find_program(CMAKE NAMES cmake)
find_program(MAKE NAMES make)
find_program(COMPILER NAMES ${COMPILERFLAG} PATHS ${COMPILERPATH})
set(CTEST_UPDATE_COMMAND "${GIT}")
set(CTEST_CONFIGURE_COMMAND " \
  ${CMAKE} \
  ${CTEST_SOURCE_DIRECTORY} \
  -DCMAKE_Fortran_COMPILER:PATH=${COMPILERFLAG} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX:PATH=${CTEST_SOURCE_DIRECTORY}/install \
  -DBUILD_TESTING:BOOL=ON \
  -DCTEST_REGRESSION_TOL=0.00001"
)
set(CTEST_BUILD_COMMAND "${MAKE} -j4 install")
set(CTEST_COMMAND "${CTEST} -j4")

### Run CTest
message(" -- Start ${MODEL} - ${CTEST_BUILD_NAME} --")
ctest_start(${MODEL} TRACK ${MODEL})

# Update
message(" -- Update - ${CTEST_BUILD_NAME} --")
ctest_update(RETURN_VALUE res)
message("ctest_update - number of files updated: ${res}")

# Configure
message(" -- Configure - ${CTEST_BUILD_NAME} --")
# file(REMOVE_RECURSE "${CTEST_BINARY_DIRECTORY}/reg_tests")  # The turbine model files seem to get corrupted, so copy again every time
ctest_configure(RETURN_VALUE res)
message("ctest_configure - return value of native command: ${res}")

# Build
message(" -- Build - ${CTEST_BUILD_NAME} --")
ctest_build(RETURN_VALUE res)
message("ctest_build - return value of native command: ${res}")

# Test
message(" -- Test - ${CTEST_BUILD_NAME} --")
ctest_test(
#  INCLUDE bd_
#  INCLUDE_LABEL "openfast"
  RETURN_VALUE res
)
message("ctest_test - 0 if all tests pass: ${res}")

# Submit
message(" -- Submit - ${CTEST_BUILD_NAME} --")
ctest_submit(RETRY_COUNT 20 RETRY_DELAY 20 RETURN_VALUE res)
message(" -- Finished - ${CTEST_BUILD_NAME} --")
