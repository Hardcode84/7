# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

add_mlir_public_c_api_library(WaveCAPI
  Dialects.cpp

  LINK_LIBS PUBLIC
  MLIRWaveDialect
  MLIRWaveAMDDialect
  MLIRWaveMachineDialect
)
