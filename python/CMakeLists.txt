# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# The python bindings build MLIR upstream sources (nanobind passes,
# extension wrappers) that emit clang-only pragmas and benign macro
# redefinitions which gcc flags. We don't own that source; opt this
# subdirectory out of the top-level `-Werror`.
add_compile_options(-Wno-error)

include(AddMLIRPython)

# Co-locate Wave dialect bindings under the upstream `mlir` package so the
# generated `_mlir_libs/_mlir.so` and core sources stay reachable through
# their stock import paths. `mlir_configure_python_dev_packages` was
# invoked at the top level.
add_compile_definitions("MLIR_PYTHON_PACKAGE_PREFIX=${MLIR_PYTHON_PACKAGE_PREFIX}.")

declare_mlir_python_sources(WavePythonSources)

declare_mlir_python_sources(WavePythonSources.dsl
  ADD_TO_PARENT WavePythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir"
  SOURCES
    dialects/wave.py
    dialects/waveamd.py
    dialects/wavemeta.py
    dialects/wave_attention.py
    dialects/wave_dsl.py
    dialects/wave_matmul.py
)

declare_mlir_dialect_python_bindings(
  ADD_TO_PARENT WavePythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir"
  TD_FILE dialects/WaveOps.td
  GEN_ENUM_BINDINGS
  SOURCES_GLOB dialects/_wave_*_gen.py
  DIALECT_NAME wave)

declare_mlir_dialect_python_bindings(
  ADD_TO_PARENT WavePythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir"
  TD_FILE dialects/WaveAMDOps.td
  GEN_ENUM_BINDINGS
  SOURCES_GLOB dialects/_waveamd_*_gen.py
  DIALECT_NAME waveamd)

declare_mlir_dialect_python_bindings(
  ADD_TO_PARENT WavePythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir"
  TD_FILE dialects/WaveMetaOps.td
  GEN_ENUM_BINDINGS
  SOURCES_GLOB dialects/_wavemeta_*_gen.py
  DIALECT_NAME wavemeta)

declare_mlir_python_extension(WavePythonSources.NanobindExtension
  MODULE_NAME _waveDialectsNanobind
  ADD_TO_PARENT WavePythonSources
  SOURCES
    WaveExtensionNanobind.cpp
  EMBED_CAPI_LINK_LIBS
    MLIRCAPIIR
    WaveCAPI
)

set(WavePythonModules_ROOT_PREFIX
  "${MLIR_BINARY_DIR}/${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}")

add_mlir_python_common_capi_library(WavePythonCAPI
  INSTALL_COMPONENT WavePythonModules
  INSTALL_DESTINATION "${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}/_mlir_libs"
  OUTPUT_DIRECTORY "${WavePythonModules_ROOT_PREFIX}/_mlir_libs"
  RELATIVE_INSTALL_ROOT "../../../.."
  DECLARED_HEADERS
    MLIRPythonCAPI.HeaderSources
  DECLARED_SOURCES
    WavePythonSources
    MLIRPythonSources
    MLIRPythonExtension.RegisterEverything
)

add_mlir_python_modules(WavePythonModules
  ROOT_PREFIX "${WavePythonModules_ROOT_PREFIX}"
  INSTALL_PREFIX "${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}"
  DECLARED_SOURCES
    WavePythonSources
    MLIRPythonSources
    MLIRPythonExtension.RegisterEverything
  COMMON_CAPI_LINK_LIBS
    WavePythonCAPI
)
