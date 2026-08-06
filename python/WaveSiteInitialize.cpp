//===- WaveSiteInitialize.cpp - Wave Python site registry ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Wave-c/Dialects.h"
#include "mlir-c/Dialect/Arith.h"
#include "mlir-c/Dialect/Func.h"
#include "mlir-c/Dialect/GPU.h"
#include "mlir-c/Dialect/MemRef.h"
#include "mlir-c/Dialect/SCF.h"
#include "mlir-c/Dialect/Transform.h"
#include "mlir-c/Dialect/UB.h"
#include "mlir/Bindings/Python/Nanobind.h"
#include "mlir/Bindings/Python/NanobindAdaptors.h"

namespace {

static void insertDialect(MlirDialectRegistry registry,
                          MlirDialectHandle dialect) {
  mlirDialectHandleInsertDialect(dialect, registry);
}

} // namespace

NB_MODULE(_site_initialize_0, m) {
  m.doc() = "Wave MLIR dialect registration";
  m.def("register_dialects", [](MlirDialectRegistry registry) {
    insertDialect(registry, mlirGetDialectHandle__arith__());
    insertDialect(registry, mlirGetDialectHandle__func__());
    insertDialect(registry, mlirGetDialectHandle__gpu__());
    insertDialect(registry, mlirGetDialectHandle__memref__());
    insertDialect(registry, mlirGetDialectHandle__scf__());
    insertDialect(registry, mlirGetDialectHandle__transform__());
    insertDialect(registry, mlirGetDialectHandle__ub__());
    insertDialect(registry, mlirGetDialectHandle__wave__());
    insertDialect(registry, mlirGetDialectHandle__waveamd__());
    insertDialect(registry, mlirGetDialectHandle__waveamdmachine__());
    insertDialect(registry, mlirGetDialectHandle__wavemeta__());
  });
}
