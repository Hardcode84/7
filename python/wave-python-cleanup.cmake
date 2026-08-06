# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

file(GLOB stale_libs
  "${WAVE_PYTHON_MLIR_LIBS}/libMLIRPythonSupport-mlir.so*"
  "${WAVE_PYTHON_MLIR_LIBS}/libWavePythonCAPI.so*"
  "${WAVE_PYTHON_MLIR_LIBS}/libnanobind-mlir.so*")
file(REMOVE ${stale_libs})

file(GLOB stale_aliases "${WAVE_PYTHON_MLIR_LIBS}/_*.so")
foreach(alias IN LISTS stale_aliases)
  if(IS_SYMLINK "${alias}")
    file(REMOVE "${alias}")
  endif()
endforeach()
