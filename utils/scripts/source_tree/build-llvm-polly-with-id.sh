#!/usr/bin/env bash

PRJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)"
SRC_DIR=${1:-$PRJ_ROOT_DIR}
INSTALL_PREFIX=${2:-../install/}

PIPELINE_CONFIG_FILE=${3:-${SRC_DIR}/configs/pipelines/polly_with_id.txt}
BMK_CONFIG_FILE=${4:-${SRC_DIR}/configs/all_except_fortran.txt}

[[ -z "${LLVMPOLLY_ROOT}" ]] && echo "error: LLVMPOLLY_ROOT is not set" && exit 1
[[ -z "${AnnotateLoops_DIR}" ]] && echo "error: AnnotateLoops_DIR is not set" && exit 1

LINKER_FLAGS="-Wl,-L$(llvm-config --libdir) -Wl,-rpath=$(llvm-config --libdir)"
LINKER_FLAGS="${LINKER_FLAGS} -lc++ -lc++abi"

CC=clang CXX=clang++ \
  cmake \
  -GNinja \
  -DCMAKE_POLICY_DEFAULT_CMP0056=NEW \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_FLAGS="-stdlib=libc++" \
  -DCMAKE_EXE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_SHARED_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_MODULE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
  -DHARNESS_USE_LLVM=On \
  -DHARNESS_PIPELINE_CONFIG_FILE="${PIPELINE_CONFIG_FILE}" \
  -DHARNESS_BMK_CONFIG_FILE="${BMK_CONFIG_FILE}" \
  -DLLVMPOLLY_ROOT="${LLVMPOLLY_ROOT}" \
  -DAnnotateLoops_DIR="${AnnotateLoops_DIR}" \
  "${SRC_DIR}"

