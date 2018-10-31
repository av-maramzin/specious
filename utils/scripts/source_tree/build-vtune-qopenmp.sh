#!/usr/bin/env bash

PRJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)"
SRC_DIR=${1:-$PRJ_ROOT_DIR}
INSTALL_PREFIX=${2:-../install/}

BMK_CONFIG_FILE="${SRC_DIR}/configs/all_except_fortran.txt"

# use Intel ICC specific flags
ICC_FLAGS="${ICC_FLAGS} -O3"
ICC_FLAGS="${ICC_FLAGS} -parallel"
ICC_FLAGS="${ICC_FLAGS} -ipo"
ICC_FLAGS="${ICC_FLAGS} -mcmodel=medium"
ICC_FLAGS="${ICC_FLAGS} -xHOST"
ICC_FLAGS="${ICC_FLAGS} -g"
ICC_FLAGS="${ICC_FLAGS} -qopenmp"

C_FLAGS="${CMAKE_C_FLAGS} ${ICC_FLAGS}"
CXX_FLAGS="${CMAKE_CXX_FLAGS} ${ICC_FLAGS}"

#C_FLAGS="-g -Wall -O3"
#LINKER_FLAGS="-Wl,-L$(llvm-config --libdir) -Wl,-rpath=$(llvm-config --libdir)"
#LINKER_FLAGS="${LINKER_FLAGS} -lc++ -lc++abi"

CC=icc CXX=icpc \
  cmake \
  -DCMAKE_POLICY_DEFAULT_CMP0056=NEW \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS="${C_FLAGS}" \
  -DCMAKE_CXX_FLAGS="${CXX_FLAGS}" \
  -DCMAKE_EXE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_SHARED_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_MODULE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
  -DHARNESS_BMK_CONFIG_FILE="${BMK_CONFIG_FILE}" \
  "${SRC_DIR}"