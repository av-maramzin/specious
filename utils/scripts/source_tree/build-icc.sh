#!/usr/bin/env bash

[[ -z $1 ]] && echo "error: source directory was not provided" && exit 1
SRC_DIR=$1

INSTALL_PREFIX="$2"
[[ -z $2 ]] && INSTALL_PREFIX="${SRC_DIR}/../install/"

BMK_CONFIG_FILE="${SRC_DIR}/configs/all_except_fortran.txt"

#

# use Intel ICC specific flags
ICC_FLAGS="${ICC_FLAGS} -O2"
ICC_FLAGS="${ICC_FLAGS} -parallel"
ICC_FLAGS="${ICC_FLAGS} -ipo"
ICC_FLAGS="${ICC_FLAGS} -mcmodel=medium"
#ICC_FLAGS="${ICC_FLAGS} -xT -axT"
#ICC_FLAGS="${ICC_FLAGS} -xcore2 -axcore2"
ICC_FLAGS="${ICC_FLAGS} -xcorei7 -axcorei7"
ICC_FLAGS="${ICC_FLAGS} -par-threshold0"
ICC_FLAGS="${ICC_FLAGS} -qopt-report=5"
ICC_FLAGS="${ICC_FLAGS} -qopt-report-phase=par"
#ICC_FLAGS="${ICC_FLAGS} -qopt-report-phase=par,loop"
ICC_FLAGS="${ICC_FLAGS} -qopt-report-file=report.txt"

C_FLAGS="${CMAKE_C_FLAGS} ${ICC_FLAGS}"
CXX_FLAGS="${CMAKE_CXX_FLAGS} ${ICC_FLAGS}"


#C_FLAGS="-g -Wall -O3"
#LINKER_FLAGS="-Wl,-L$(llvm-config --libdir) -Wl,-rpath=$(llvm-config --libdir)"
#LINKER_FLAGS="${LINKER_FLAGS} -lc++ -lc++abi" 

CC=icc CXX=icpc \
cmake \
  -DCMAKE_POLICY_DEFAULT_CMP0056=NEW \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS="${C_FLAGS}" \
  -DCMAKE_CXX_FLAGS="${CXX_FLAGS}" \
  -DCMAKE_EXE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_SHARED_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_MODULE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
  -DHARNESS_BMK_CONFIG_FILE=${BMK_CONFIG_FILE} \
  -DBMK_CLASS=${BMK_CLASS} \
  -DMG_BMK_CLASS=${MG_BMK_CLASS} \
  -DIS_BMK_CLASS=${IS_BMK_CLASS} \
  "${SRC_DIR}"

exit $?

