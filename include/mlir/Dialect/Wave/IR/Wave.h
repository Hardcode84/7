//===- Wave.h - Wave dialect ------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVE_H_
#define MLIR_DIALECT_WAVE_IR_WAVE_H_

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/InferIntRangeInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

#include <memory>

#include "mlir/Dialect/Wave/IR/WaveOpsDialect.h.inc"

#define GET_ATTRDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOpsAttributes.h.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOpsTypes.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOps.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveTransformOps.h.inc"

#endif // MLIR_DIALECT_WAVE_IR_WAVE_H_
