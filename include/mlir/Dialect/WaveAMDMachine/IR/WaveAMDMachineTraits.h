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

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineWaitcnt.h"
#include "mlir/IR/OpDefinition.h"

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
class ScratchMemoryOp : public TraitBase<ConcreteType, ScratchMemoryOp> {};

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

// Token result keeps issue SSA edges but drops completion events.
template <typename ConcreteType>
class CompletionFreeTokenOp
    : public TraitBase<ConcreteType, CompletionFreeTokenOp> {};

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
class WMMAOp : public TraitBase<ConcreteType, WMMAOp> {};

template <typename ConcreteType>
class ReadsExecOp : public TraitBase<ConcreteType, ReadsExecOp> {};

template <typename ConcreteType>
class WritesExecOp : public TraitBase<ConcreteType, WritesExecOp> {};

} // namespace mlir::OpTrait::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETRAITS_H
