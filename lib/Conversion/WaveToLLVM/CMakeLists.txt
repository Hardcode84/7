# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

add_mlir_conversion_library(MLIRWaveToLLVM
  WaveToLLVM.cpp

  ADDITIONAL_HEADER_DIRS
  ${PROJECT_SOURCE_DIR}/include/mlir/Conversion/WaveToLLVM

  LINK_COMPONENTS
  Core

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRLLVMCommonConversion
  MLIRLLVMDialect
  MLIRSupport
  MLIRWaveDialect
  )
