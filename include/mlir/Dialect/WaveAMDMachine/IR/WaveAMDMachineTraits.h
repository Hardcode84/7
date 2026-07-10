//===- WaveAMDMachineTraits.h - WaveAMDMachine op traits -------------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETRAITS_H
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETRAITS_H

#include "mlir/IR/OpDefinition.h"

namespace mlir::waveamdmachine {

enum class WaitcntCounter : unsigned { None = 0, Vmem, Lgkm, Vscnt };

enum class WaitcntEvent : unsigned {
  None = 0,
  Vmem = 1u << 0,
  VmemStore = 1u << 1,
  Lds = 1u << 2,
  Smem = 1u << 3,
  Flat = 1u << 4,
  Gds = 1u << 5,
  Message = 1u << 6,
  ScratchStore = 1u << 7,
};

struct WaitcntInfo {
  WaitcntCounter counter = WaitcntCounter::None;
  WaitcntEvent event = WaitcntEvent::None;
  unsigned issueCount = 0;
  bool outOfOrder = false;

  bool isIssuer() const { return counter != WaitcntCounter::None; }
};

} // namespace mlir::waveamdmachine

namespace mlir::OpTrait::waveamdmachine {

template <typename ConcreteType>
class VALUOp : public TraitBase<ConcreteType, VALUOp> {};

template <typename ConcreteType>
class SALUOp : public TraitBase<ConcreteType, SALUOp> {};

template <typename ConcreteType>
class SMEMLoadOp : public TraitBase<ConcreteType, SMEMLoadOp> {};

template <typename ConcreteType>
class LDSLoadOp : public TraitBase<ConcreteType, LDSLoadOp> {};

template <typename ConcreteType>
class LDSStoreOp : public TraitBase<ConcreteType, LDSStoreOp> {};

template <typename ConcreteType>
class LDSDmaOp : public TraitBase<ConcreteType, LDSDmaOp> {};

template <typename ConcreteType>
class VMEMLoadOp : public TraitBase<ConcreteType, VMEMLoadOp> {};

template <typename ConcreteType>
class VMEMStoreOp : public TraitBase<ConcreteType, VMEMStoreOp> {};

template <typename ConcreteType>
class TupleMemoryOp : public TraitBase<ConcreteType, TupleMemoryOp> {};

template <typename ConcreteType>
class TupleAliasOp : public TraitBase<ConcreteType, TupleAliasOp> {};

template <typename ConcreteType>
class WaitcntOp : public TraitBase<ConcreteType, WaitcntOp> {};

template <typename ConcreteType>
class TokenOp : public TraitBase<ConcreteType, TokenOp> {};

template <typename ConcreteType>
class TokenJoinOp : public TraitBase<ConcreteType, TokenJoinOp> {};

// Does not advance instruction-distance hazards. May still emit asm.
template <typename ConcreteType>
class NoMachineInst : public TraitBase<ConcreteType, NoMachineInst> {};

// Pseudo value/bookkeeping op. Emitter drops it.
template <typename ConcreteType>
class NoAsmEmission : public TraitBase<ConcreteType, NoAsmEmission> {};

// Tags ops that emit a real MFMA instruction. Used by the hazard
// pass to detect the producer side of the MFMA-result-as-VMEM-store
// pipeline hazard.
template <typename ConcreteType>
class MFMAOp : public TraitBase<ConcreteType, MFMAOp> {};

template <typename ConcreteType>
class ReadsExecOp : public TraitBase<ConcreteType, ReadsExecOp> {};

template <typename ConcreteType>
class WritesExecOp : public TraitBase<ConcreteType, WritesExecOp> {};

} // namespace mlir::OpTrait::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETRAITS_H
