//===- OpClassifier.cpp - wave.amd.machine -> SchedClass ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

namespace mlir::waveamdmachine {

namespace traits = ::mlir::OpTrait::waveamdmachine;

// MFMA tile shape -> pass-count bucket. Source: LLVM
// SISchedule.td gfx942 block (lines 317-319): 16X16X8/16/32
// map to Write4PassMAI. The 32x32x* family is 8-pass; 4x4x* is
// 2-pass (gfx9 only); legacy 16-pass classes don't appear on
// the archs we target.
static SchedClass classifyMFMA(Operation *op) {
  llvm::StringRef name = op->getName().stripDialect();
  if (name.contains("_16x16x"))
    return SchedClass::Write4PassMAI;
  if (name.contains("_32x32x"))
    return SchedClass::Write8PassMAI;
  if (name.contains("_4x4x"))
    return SchedClass::Write2PassMAI;
#ifndef NDEBUG
  op->emitError("classifyMFMA: unknown MFMA shape: ") << name;
  llvm_unreachable("classifyMFMA: unknown shape");
#else
  llvm::errs() << "waveamdmachine: unknown MFMA shape '" << name
               << "', falling back to Write4PassMAI\n";
  return SchedClass::Write4PassMAI;
#endif
}

// SMEMLoad trait covers both scalar memory (s_load_*) and LDS
// (ds_*) -- the dialect tags both because they share lgkmcnt
// (WaveAMDMachineOps.td comment ~line 979). Split by mnemonic.
static SchedClass classifySMEMOrLDS(Operation *op) {
  llvm::StringRef name = op->getName().stripDialect();
  return name.starts_with("ds_") ? SchedClass::WriteLDS : SchedClass::WriteSMEM;
}

// VALU. 64-bit forms (v_*_b64, v_*_u64) cost more than 32-bit;
// split them out so LatencyTable can charge separately.
static SchedClass classifyVALU(Operation *op) {
  llvm::StringRef name = op->getName().stripDialect();
  if (name.ends_with("_b64") || name.ends_with("_u64"))
    return SchedClass::Write64Bit;
  return SchedClass::Write32Bit;
}

static bool isBranchMnemonic(llvm::StringRef name) {
  return name.starts_with("s_cbranch") || name == "s_setpc_b64" ||
         name == "s_endpgm" || name == "uniform_loop" || name == "continue_if";
}

static bool isStructuralPseudo(llvm::StringRef name) {
  return name == "label" || name == "make_buffer_rsrc" || name == "after";
}

// Fallback path for ops not classified by trait or isa<>.
static SchedClass classifyByMnemonic(Operation *op) {
  llvm::StringRef name = op->getName().stripDialect();
  if (isStructuralPseudo(name))
    return SchedClass::NoInst;
  if (name == "s_barrier")
    return SchedClass::WriteBarrier;
  if (isBranchMnemonic(name))
    return SchedClass::WriteBranch;
  // Anything else starting with "s_" lives on the scalar pipe
  // (s_add, s_mul, s_lshl, s_and, s_cmp, s_mov, exec
  // manipulation, s_nop, s_delay_alu).
  if (name.starts_with("s_"))
    return SchedClass::WriteSALU;
#ifndef NDEBUG
  op->emitError("classifyOp: unmapped wave.amd.machine op: ") << name;
  llvm_unreachable("classifyOp: unmapped op");
#else
  llvm::errs() << "waveamdmachine: unmapped op '" << name
               << "', falling back to Write32Bit\n";
  return SchedClass::Write32Bit;
#endif
}

SchedClass classifyOp(Operation *op) {
  if (op->hasTrait<traits::NoMachineInst>())
    return SchedClass::NoInst;
  if (op->hasTrait<traits::MFMAOp>())
    return classifyMFMA(op);
  // WMMA (gfx11/12). No dedicated trait; dispatch by op type.
  // 16x16x16 issues over multiple SIMD cycles; the exact pass
  // count lives in LatencyTable (Stage 1.3).
  if (isa<WmmaF32_16x16x16_F16Op, WmmaI32_16x16x16_IU8Op>(op))
    return SchedClass::Write16PassWMMA;
  if (op->hasTrait<traits::VMEMLoadOp>() || op->hasTrait<traits::VMEMStoreOp>())
    return SchedClass::WriteVMEM;
  if (op->hasTrait<traits::SMEMLoadOp>())
    return classifySMEMOrLDS(op);
  if (op->hasTrait<traits::VALUOp>())
    return classifyVALU(op);
  return classifyByMnemonic(op);
}

} // namespace mlir::waveamdmachine
