//===-- WaveAMDMachineOps.td - WaveAMDMachine dialect ------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEOPS_TD
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEOPS_TD

include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineBase.td"
include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInterfaces.td"
include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTypes.td"
include "mlir/IR/OpBase.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/InferIntRangeInterface.td"
include "mlir/Interfaces/LoopLikeInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

defvar WaveAMDMachine_Gfx90APlus =
    "isa.Major == 9 && ((isa.Minor == 0 && isa.Stepping == 10) || " #
    "(isa.Minor == 4 && isa.Stepping == 2) || " #
    "(isa.Minor == 5 && isa.Stepping == 0))";
defvar WaveAMDMachine_Gfx940Plus =
    "isa.Major == 9 && (isa.Minor == 4 || " #
    "(isa.Minor == 5 && isa.Stepping == 0))";
defvar WaveAMDMachine_Gfx950 =
    "isa.Major == 9 && isa.Minor == 5 && isa.Stepping == 0";
defvar WaveAMDMachine_AGPRTarget =
    "isa.Major == 9 && ((isa.Minor == 0 && " #
    "(isa.Stepping == 8 || isa.Stepping == 10)) || " #
    "isa.Minor == 4 || (isa.Minor == 5 && isa.Stepping == 0))";
defvar WaveAMDMachine_Gfx8To13 =
    "isa.Major >= 8 && isa.Major <= 13";

// Every WaveAMDMachine op gets a static `isSupportedOnIsa(IsaVersion)`
// classifier. The default is "supported everywhere"; gated ops
// override `archPredicate` with a C++ expression. The expression
// runs with `isa` in scope as `const llvm::AMDGPU::IsaVersion &`,
// so predicates can read `isa.Major`, `isa.Minor`, `isa.Stepping`
// freely.
//
// Callers query at op construction time -- before any instance
// exists -- via `XxxOp::isSupportedOnIsa(isa)`. This is the
// statically-typed gate the selector / decompose passes use to
// pick between alternative ops for the same operation.
class WaveAMDMachine_Op<string mnemonic, list<Trait> traits = []> :
    Op<WaveAMDMachine_Dialect, mnemonic,
       !listconcat(traits, [WaveAMDMachine_WaitcntInfoOpInterface])> {
  string archPredicate = "true";
  string waitcntCounter = "None";
  string waitcntEvent = "None";
  string waitcntIssueCount = "0";
  bit waitcntOutOfOrder = 0;

  let extraClassDeclaration = [{
    static bool isSupportedOnIsa(const ::llvm::AMDGPU::IsaVersion &isa) {
      (void)isa;
      return }] # archPredicate # [{;
    }

    ::mlir::waveamdmachine::WaitcntInfo getWaitcntInfo() {
      return {::mlir::waveamdmachine::WaitcntCounter::}] # waitcntCounter # [{,
              ::mlir::waveamdmachine::WaitcntEvent::}] # waitcntEvent # [{,
              static_cast<unsigned>(}] # waitcntIssueCount # [{),
              }] # !if(waitcntOutOfOrder, "true", "false") # [{};
    }
  }];
}

class WaveAMDMachine_WaitcntInfo<string counter, string event,
                                 string count = "1", bit outOfOrder = 0> {
  string waitcntCounter = counter;
  string waitcntEvent = event;
  string waitcntIssueCount = count;
  bit waitcntOutOfOrder = outOfOrder;
}

class WaveAMDMachine_VMEMLoadInfo
    : WaveAMDMachine_WaitcntInfo<"Vmem", "Vmem">;
class WaveAMDMachine_VMEMStoreInfo
    : WaveAMDMachine_WaitcntInfo<"Vscnt", "VmemStore">;
class WaveAMDMachine_LDSInfo<string count = "1">
    : WaveAMDMachine_WaitcntInfo<"Lgkm", "Lds", count>;
class WaveAMDMachine_SMEMInfo<string count = "1">
    : WaveAMDMachine_WaitcntInfo<"Lgkm", "Smem", count, 1>;

defvar WaveAMDMachine_ResultRegWidth =
    "::llvm::cast<::mlir::waveamdmachine::RegType>(" #
    "this->getOperation()->getResult(0).getType()).getWidth()";
defvar WaveAMDMachine_ValueRegWidth =
    "::llvm::cast<::mlir::waveamdmachine::RegType>(" #
    "this->getOperation()->getOperand(1).getType()).getWidth()";
defvar WaveAMDMachine_ResultRegChunkCount =
    "((::llvm::cast<::mlir::waveamdmachine::RegType>(" #
    "this->getOperation()->getResult(0).getType()).getWidth() + 3) / 4)";
defvar WaveAMDMachine_ValueRegChunkCount =
    "((::llvm::cast<::mlir::waveamdmachine::RegType>(" #
    "this->getOperation()->getOperand(1).getType()).getWidth() + 3) / 4)";

class WaveAMDMachine_VMEMTupleLoadInfo
    : WaveAMDMachine_WaitcntInfo<"Vmem", "Vmem",
                                 WaveAMDMachine_ResultRegChunkCount>;
class WaveAMDMachine_VMEMTupleStoreInfo
    : WaveAMDMachine_WaitcntInfo<"Vscnt", "VmemStore",
                                 WaveAMDMachine_ValueRegChunkCount>;
class WaveAMDMachine_LDSTupleLoadInfo
    : WaveAMDMachine_WaitcntInfo<"Lgkm", "Lds",
                                 WaveAMDMachine_ResultRegChunkCount>;
class WaveAMDMachine_LDSTupleStoreInfo
    : WaveAMDMachine_WaitcntInfo<"Lgkm", "Lds",
                                 WaveAMDMachine_ValueRegChunkCount>;

def WaveAMDMachine_VALU : NativeOpTrait<"waveamdmachine::VALUOp">;
def WaveAMDMachine_SMEMLoad : NativeOpTrait<"waveamdmachine::SMEMLoadOp">;
def WaveAMDMachine_LDSLoad : NativeOpTrait<"waveamdmachine::LDSLoadOp">;
def WaveAMDMachine_LDSStore : NativeOpTrait<"waveamdmachine::LDSStoreOp">;
def WaveAMDMachine_VMEMLoad : NativeOpTrait<"waveamdmachine::VMEMLoadOp">;
def WaveAMDMachine_VMEMStore : NativeOpTrait<"waveamdmachine::VMEMStoreOp">;
def WaveAMDMachine_TupleMemory : NativeOpTrait<"waveamdmachine::TupleMemoryOp">;
def WaveAMDMachine_Waitcnt : NativeOpTrait<"waveamdmachine::WaitcntOp">;
def WaveAMDMachine_TokenTrait : NativeOpTrait<"waveamdmachine::TokenOp">;
def WaveAMDMachine_TokenJoinTrait : NativeOpTrait<"waveamdmachine::TokenJoinOp">;
def WaveAMDMachine_NoMachineInst : NativeOpTrait<"waveamdmachine::NoMachineInst">;
def WaveAMDMachine_NoAsmEmission : NativeOpTrait<"waveamdmachine::NoAsmEmission">;
def WaveAMDMachine_MFMA : NativeOpTrait<"waveamdmachine::MFMAOp">;
def WaveAMDMachine_ReadsExec : NativeOpTrait<"waveamdmachine::ReadsExecOp">;
def WaveAMDMachine_WritesExec : NativeOpTrait<"waveamdmachine::WritesExecOp">;

def WaveAMDMachine_SGPR
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::SGPR">,
           "WaveAMDMachine SGPR register">;

def WaveAMDMachine_SGPR1
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::SGPR && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getWidth() == 1">,
           "WaveAMDMachine scalar SGPR register">;

def WaveAMDMachine_SGPR2
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::SGPR && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getWidth() == 2">,
           "WaveAMDMachine SGPR pair register">;

def WaveAMDMachine_SGPR4
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::SGPR && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getWidth() == 4">,
           "WaveAMDMachine SGPR quad register">;

def WaveAMDMachine_VGPR
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VGPR">,
           "WaveAMDMachine VGPR register">;

def WaveAMDMachine_VGPR1
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VGPR && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getWidth() == 1">,
           "WaveAMDMachine scalar VGPR register">;

def WaveAMDMachine_VGPR2
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VGPR && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getWidth() == 2">,
           "WaveAMDMachine VGPR pair register">;

def WaveAMDMachine_VGPR3
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VGPR && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getWidth() == 3">,
           "WaveAMDMachine VGPR triple register">;

def WaveAMDMachine_VGPR4
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VGPR && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getWidth() == 4">,
           "WaveAMDMachine VGPR quad register">;

def WaveAMDMachine_AGPR
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::AGPR">,
           "WaveAMDMachine AGPR register">;

def WaveAMDMachine_AVGPR
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "(::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VGPR || "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::AGPR)">,
           "WaveAMDMachine VGPR or AGPR register">;

// SCC is the status condition code: a 1-bit hardware register implicitly
// written by scalar ALU ops (s_cmp_*, s_add_i32 carry-out, ...) and read
// by s_cbranch_scc0/1. There is exactly one physical SCC, so the
// allocator skips SCC values entirely. Modelling it as a value makes the
// def-use chain (s_cmp -> continue_if / cbranch) explicit in the IR.
def WaveAMDMachine_SCC
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::SCC">,
           "WaveAMDMachine SCC status bit">;

// VCC is the vector carry / compare state. Like SCC, it is a single
// physical flag resource outside normal register allocation.
def WaveAMDMachine_VCC
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VCC">,
           "WaveAMDMachine VCC state">;

def WaveAMDMachine_SGPR1OrImm
    : Type<CPred<"(::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::SGPR && "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getWidth() == 1) || "
                 "::llvm::isa<::mlir::waveamdmachine::ImmType>($_self)">,
           "WaveAMDMachine SGPR or immediate">;

def WaveAMDMachine_RegOrImm
    : Type<CPred<"(::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "(::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::SGPR || "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VGPR)) || "
                 "::llvm::isa<::mlir::waveamdmachine::ImmType>($_self)">,
           "WaveAMDMachine SGPR/VGPR register or immediate">;

def WaveAMDMachine_RegOrMemToken
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) || "
                 "::llvm::isa<::mlir::waveamdmachine::MemTokenType>($_self)">,
           "WaveAMDMachine register or memory token">;

def WaveAMDMachine_PackedOpSel2Attr
    : ConfinedAttr<I64Attr, [IntMinValue<0>, IntMaxValue<3>]>;
def WaveAMDMachine_PackedOpSel3Attr
    : ConfinedAttr<I64Attr, [IntMinValue<0>, IntMaxValue<7>]>;
def WaveAMDMachine_ScaleIndexAttr
    : ConfinedAttr<I64Attr, [IntMinValue<0>, IntMaxValue<3>]>;
def WaveAMDMachine_NonNegativeI64Attr
    : ConfinedAttr<I64Attr, [IntMinValue<0>]>;

// Any allocatable register class (SGPR, VGPR, AGPR). Excludes hardware flags.
def WaveAMDMachine_GPR
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self) && "
                 "(::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::SGPR || "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::VGPR || "
                 "::llvm::cast<::mlir::waveamdmachine::RegType>($_self).getRegClass() == ::mlir::waveamdmachine::RegClass::AGPR)">,
           "WaveAMDMachine GPR (SGPR/VGPR/AGPR)">;

class WaveAMDMachine_ZeroResult<string mnemonic, list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic, traits> {
  let assemblyFormat = "attr-dict";
}

// Three memory-space bases that fold AddressFieldsOpInterface into the
// parent op. Each owns the per-space inst_offset width / soffset
// slot decision in one place. Concrete ops inherit these instead of
// WaveAMDMachine_Op directly.
class WaveAMDMachine_GlobalMemoryOp<string mnemonic, list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic,
        !listconcat(traits,
          [DeclareOpInterfaceMethods<WaveAMDMachine_AddressFieldsOpInterface>])> {
  let extraClassDefinition = [{
    ::mlir::waveamdmachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/13, /*instOffsetSigned=*/true,
              /*hasSoffset=*/false};
    }
  }];
}

class WaveAMDMachine_BufferMemoryOp<string mnemonic, list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic,
        !listconcat(traits,
          [DeclareOpInterfaceMethods<WaveAMDMachine_AddressFieldsOpInterface>])> {
  let extraClassDefinition = [{
    ::mlir::waveamdmachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/12, /*instOffsetSigned=*/false,
              /*hasSoffset=*/true,
              ::mlir::waveamdmachine::SOffsetImmPolicy::ZeroImmOnly};
    }
  }];
}

class WaveAMDMachine_DsOp<string mnemonic, list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic,
        !listconcat(traits,
          [DeclareOpInterfaceMethods<WaveAMDMachine_AddressFieldsOpInterface>])> {
  let extraClassDefinition = [{
    ::mlir::waveamdmachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/16, /*instOffsetSigned=*/false,
              /*hasSoffset=*/false};
    }
  }];
}

class WaveAMDMachine_DsMemoryOp<string mnemonic, list<Trait> traits = []>
    : WaveAMDMachine_DsOp<mnemonic, traits> {}

class WaveAMDMachine_ZeroOperandResult<string mnemonic, Type resultType,
                                    list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic, traits> {
  let results = (outs resultType:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

class WaveAMDMachine_UnaryResult<string mnemonic, Type operandType, Type resultType,
                              list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic, traits> {
  let arguments = (ins operandType:$source);
  let results = (outs resultType:$result);
  let assemblyFormat = "$source attr-dict `:` functional-type(operands, results)";
}

class WaveAMDMachine_BinaryResult<string mnemonic, Type operandType, Type resultType,
                               list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic, !listconcat(traits, [Pure])> {
  let arguments = (ins operandType:$lhs, operandType:$rhs);
  let results = (outs resultType:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

class WaveAMDMachine_TernaryResult<string mnemonic, Type operandType, Type resultType,
                                list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic, !listconcat(traits, [Pure])> {
  let arguments = (ins operandType:$a, operandType:$b, operandType:$c);
  let results = (outs resultType:$result);
  let assemblyFormat = "$a `,` $b `,` $c attr-dict `:` functional-type(operands, results)";
}

class WaveAMDMachine_TernaryIntResult<string mnemonic>
    : WaveAMDMachine_Op<mnemonic, [WaveAMDMachine_VALU, Pure]> {
  let archPredicate = WaveAMDMachine_Gfx8To13;
  let arguments = (ins WaveAMDMachine_RegOrImm:$a,
                       WaveAMDMachine_RegOrImm:$b,
                       WaveAMDMachine_RegOrImm:$c);
  let results = (outs WaveAMDMachine_VGPR1:$result);
  let assemblyFormat = "$a `,` $b `,` $c attr-dict `:` functional-type(operands, results)";
}

class WaveAMDMachine_BinaryU32Result<string mnemonic>
    : WaveAMDMachine_BinaryResult<mnemonic, WaveAMDMachine_RegOrImm,
                                  WaveAMDMachine_VGPR1,
                                  [WaveAMDMachine_VALU,
                                   DeclareOpInterfaceMethods<
                                       InferIntRangeInterface,
                                       ["inferResultRanges"]>]>;

class WaveAMDMachine_PackedBinaryResult<string mnemonic>
    : WaveAMDMachine_Op<mnemonic, [WaveAMDMachine_VALU, Pure]> {
  let archPredicate = "isa.Major == 9 || isa.Major == 11";
  let arguments = (ins WaveAMDMachine_VGPR1:$lhs,
                       WaveAMDMachine_VGPR1:$rhs,
                       DefaultValuedAttr<BoolAttr, "false">:$clamp,
                       DefaultValuedAttr<WaveAMDMachine_PackedOpSel2Attr,
                                         "0">:$op_sel,
                       DefaultValuedAttr<WaveAMDMachine_PackedOpSel2Attr,
                                         "3">:$op_sel_hi);
  let results = (outs WaveAMDMachine_VGPR1:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

class WaveAMDMachine_PackedTernaryResult<string mnemonic>
    : WaveAMDMachine_Op<mnemonic, [WaveAMDMachine_VALU, Pure]> {
  let archPredicate = "isa.Major == 9 || isa.Major == 11";
  let arguments = (ins WaveAMDMachine_VGPR1:$a,
                       WaveAMDMachine_VGPR1:$b,
                       WaveAMDMachine_VGPR1:$c,
                       DefaultValuedAttr<BoolAttr, "false">:$clamp,
                       DefaultValuedAttr<WaveAMDMachine_PackedOpSel3Attr,
                                         "0">:$op_sel,
                       DefaultValuedAttr<WaveAMDMachine_PackedOpSel3Attr,
                                         "7">:$op_sel_hi);
  let results = (outs WaveAMDMachine_VGPR1:$result);
  let assemblyFormat =
      "$a `,` $b `,` $c attr-dict `:` functional-type(operands, results)";
}

class WaveAMDMachine_UnaryNoResult<string mnemonic, Type operandType,
                                list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic, traits> {
  let arguments = (ins operandType:$source);
  let assemblyFormat = "$source attr-dict `:` functional-type(operands, results)";
}

class WaveAMDMachine_BinaryNoResult<string mnemonic, Type operandType,
                                 list<Trait> traits = []>
    : WaveAMDMachine_Op<mnemonic, traits> {
  let arguments = (ins operandType:$lhs, operandType:$rhs);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_ArgOp : WaveAMDMachine_Op<"arg", [
  WaveAMDMachine_NoMachineInst,
  WaveAMDMachine_NoAsmEmission,
  Pure
]> {
  let summary = "selected function argument";
  let arguments = (ins I64Attr:$index, BoolAttr:$pointer);
  let results = (outs WaveAMDMachine_Reg:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

def WaveAMDMachine_KernargPreloadOp : WaveAMDMachine_Op<"kernarg_preload", [
  WaveAMDMachine_NoMachineInst,
  WaveAMDMachine_NoAsmEmission,
  Pure
]> {
  let summary = "preloaded kernel argument live-in";
  let arguments = (ins WaveAMDMachine_NonNegativeI64Attr:$dword_offset);
  let results = (outs WaveAMDMachine_SGPR:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

def WaveAMDMachine_UninitOp : WaveAMDMachine_Op<"uninit", [
  WaveAMDMachine_NoMachineInst,
  WaveAMDMachine_NoAsmEmission,
  Pure
]> {
  let summary = "uninitialized machine register";
  let results = (outs WaveAMDMachine_GPR:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

def WaveAMDMachine_ImmOp : WaveAMDMachine_Op<"imm", [
  Pure,
  WaveAMDMachine_NoMachineInst,
  WaveAMDMachine_NoAsmEmission,
  DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>
]> {
  let summary = "machine immediate";
  let arguments = (ins I64Attr:$value);
  let results = (outs WaveAMDMachine_Imm:$result);
  let assemblyFormat = "$value attr-dict `:` type($result)";
}

def WaveAMDMachine_TokenOp : WaveAMDMachine_Op<"token", [
  Pure,
  WaveAMDMachine_TokenTrait,
  WaveAMDMachine_NoMachineInst,
  WaveAMDMachine_NoAsmEmission
]> {
  let summary = "empty machine memory token";
  let results = (outs WaveAMDMachine_MemToken:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

def WaveAMDMachine_TokenJoinOp : WaveAMDMachine_Op<"token_join",
    [Pure, WaveAMDMachine_TokenJoinTrait, WaveAMDMachine_NoMachineInst,
     WaveAMDMachine_NoAsmEmission]> {
  let summary = "join machine memory tokens";
  let arguments = (ins Variadic<WaveAMDMachine_MemToken>:$dependencies);
  let results = (outs WaveAMDMachine_MemToken:$result);
  let assemblyFormat = "$dependencies attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_AfterOp : WaveAMDMachine_Op<"after",
    [Pure, WaveAMDMachine_TokenJoinTrait]> {
  let summary = "derive a machine memory token after dependencies";
  let arguments = (ins Variadic<WaveAMDMachine_MemToken>:$dependencies);
  let results = (outs WaveAMDMachine_MemToken:$result);
  let assemblyFormat = "$dependencies attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_WaitOp : WaveAMDMachine_Op<"wait",
    [WaveAMDMachine_NoMachineInst, WaveAMDMachine_NoAsmEmission]> {
  let summary = "wait for machine memory token dependencies";
  let arguments = (ins Variadic<WaveAMDMachine_MemToken>:$dependencies);
  let assemblyFormat = "$dependencies attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_LabelOp : WaveAMDMachine_Op<"label"> {
  let summary = "assembly label";
  let arguments = (ins StrAttr:$name);
  let assemblyFormat = "$name attr-dict";
}

def WaveAMDMachine_VMbcntLoOp
    : WaveAMDMachine_ZeroOperandResult<"v_mbcnt_lo", WaveAMDMachine_VGPR1,
                                    [WaveAMDMachine_VALU, Pure]>;
def WaveAMDMachine_VMbcntHiOp
    : WaveAMDMachine_UnaryResult<"v_mbcnt_hi", WaveAMDMachine_VGPR1,
                                 WaveAMDMachine_VGPR1,
                                 [WaveAMDMachine_VALU, Pure]>;

// Descriptor-loaded workgroup ids live in layout-assigned system SGPRs.
def WaveAMDMachine_SWorkgroupIdXOp
    : WaveAMDMachine_ZeroOperandResult<"s_workgroup_id_x", WaveAMDMachine_SGPR1,
                                       [WaveAMDMachine_NoMachineInst,
                                        WaveAMDMachine_NoAsmEmission, Pure]>;
def WaveAMDMachine_SWorkgroupIdYOp
    : WaveAMDMachine_ZeroOperandResult<"s_workgroup_id_y", WaveAMDMachine_SGPR1,
                                       [WaveAMDMachine_NoMachineInst,
                                        WaveAMDMachine_NoAsmEmission, Pure]>;
def WaveAMDMachine_SWorkgroupIdZOp
    : WaveAMDMachine_ZeroOperandResult<"s_workgroup_id_z", WaveAMDMachine_SGPR1,
                                       [WaveAMDMachine_NoMachineInst,
                                        WaveAMDMachine_NoAsmEmission, Pure]>;

// Packed workitem id X lives in layout-assigned entry VGPR.
def WaveAMDMachine_VWorkitemIdXOp
    : WaveAMDMachine_ZeroOperandResult<"v_workitem_id_x", WaveAMDMachine_VGPR1,
                                       [WaveAMDMachine_NoMachineInst,
                                        WaveAMDMachine_NoAsmEmission, Pure]>;

def WaveAMDMachine_VMovB32TupleOp
    : WaveAMDMachine_UnaryResult<"v_mov_b32_tuple", WaveAMDMachine_RegOrImm,
                              WaveAMDMachine_VGPR, [WaveAMDMachine_VALU, Pure]> {
  let hasVerifier = 1;
}

def WaveAMDMachine_VCndmaskB32TupleOp
    : WaveAMDMachine_Op<"v_cndmask_b32_tuple",
                        [WaveAMDMachine_VALU, Pure]> {
  let summary = "vector lane select using an SGPR mask";
  let arguments = (ins WaveAMDMachine_RegOrImm:$false_value,
                       WaveAMDMachine_RegOrImm:$true_value,
                       WaveAMDMachine_SGPR:$condition);
  let results = (outs WaveAMDMachine_VGPR:$result);
  let assemblyFormat =
      "$false_value `,` $true_value `,` $condition attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def WaveAMDMachine_VAccvgprReadB32TupleOp
    : WaveAMDMachine_UnaryResult<"v_accvgpr_read_b32_tuple",
                                 WaveAMDMachine_AGPR, WaveAMDMachine_VGPR,
                                 [WaveAMDMachine_VALU, Pure]> {
  let summary = "copy an AGPR tuple into VGPRs";
  let archPredicate = WaveAMDMachine_AGPRTarget;
  let hasVerifier = 1;
}

def WaveAMDMachine_VAccvgprWriteB32TupleOp
    : WaveAMDMachine_UnaryResult<"v_accvgpr_write_b32_tuple",
                                 WaveAMDMachine_VGPR, WaveAMDMachine_AGPR,
                                 [WaveAMDMachine_VALU, Pure]> {
  let summary = "copy a VGPR tuple into AGPRs";
  let archPredicate = WaveAMDMachine_AGPRTarget;
  let hasVerifier = 1;
}

// Pure SSA renames between a GPR tuple (SGPR/VGPR/AGPR) and its
// constituent GPR pieces. Elements may be any width as long as
// their widths sum to the tuple width, and all pieces must share
// the tuple's register class. The regalloc places each element at
// `tuple_phys + cumulative_offset`, where the offset is the sum of
// the preceding elements' widths. Both ops are zero-cost at asm
// emit time. `tuple_to_elements` is the natural before-store
// hand-off (splits a tuple value into pieces the per-instruction
// stores can consume); `tuple_from_elements` is the after-load
// gather (assembles per-instruction load results into one tuple).
def WaveAMDMachine_TupleToElementsOp
    : WaveAMDMachine_Op<"tuple_to_elements",
                       [Pure, WaveAMDMachine_TokenJoinTrait,
                        WaveAMDMachine_NoMachineInst,
                        WaveAMDMachine_NoAsmEmission]> {
  let summary = "split a GPR tuple into mixed-width GPR pieces";
  let arguments = (ins WaveAMDMachine_GPR:$tuple);
  let results = (outs Variadic<WaveAMDMachine_GPR>:$elements);
  let assemblyFormat =
      "$tuple attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def WaveAMDMachine_TupleFromElementsOp
    : WaveAMDMachine_Op<"tuple_from_elements",
                     [Pure, WaveAMDMachine_TokenJoinTrait,
                      WaveAMDMachine_NoMachineInst,
                      WaveAMDMachine_NoAsmEmission]> {
  let summary = "concatenate mixed-width GPR pieces into a GPR tuple";
  let arguments = (ins Variadic<WaveAMDMachine_GPR>:$elements);
  let results = (outs WaveAMDMachine_GPR:$tuple);
  let assemblyFormat =
      "$elements attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}
def WaveAMDMachine_VAddU32Op
    : WaveAMDMachine_BinaryU32Result<"v_add_u32">;
def WaveAMDMachine_VAddU32VccOp
    : WaveAMDMachine_Op<"v_add_u32_vcc", [WaveAMDMachine_VALU, Pure]> {
  let summary = "vector 32-bit add (sets VCC)";
  let arguments = (ins WaveAMDMachine_RegOrImm:$lhs,
                       WaveAMDMachine_RegOrImm:$rhs);
  let results = (outs WaveAMDMachine_VGPR1:$result, WaveAMDMachine_VCC:$vcc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}
def WaveAMDMachine_VAndB32Op
    : WaveAMDMachine_BinaryU32Result<"v_and_b32">;
def WaveAMDMachine_VOrB32Op
    : WaveAMDMachine_BinaryU32Result<"v_or_b32">;
def WaveAMDMachine_VXorB32Op
    : WaveAMDMachine_BinaryU32Result<"v_xor_b32">;
def WaveAMDMachine_VLshlrevB32Op
    : WaveAMDMachine_BinaryU32Result<"v_lshlrev_b32">;
def WaveAMDMachine_VLshrrevB32Op
    : WaveAMDMachine_BinaryU32Result<"v_lshrrev_b32">;
def WaveAMDMachine_VMulLoU32Op
    : WaveAMDMachine_BinaryU32Result<"v_mul_lo_u32">;
def WaveAMDMachine_VAdd3U32Op
    : WaveAMDMachine_TernaryIntResult<"v_add3_u32">;
def WaveAMDMachine_VMadI32I24Op
    : WaveAMDMachine_TernaryIntResult<"v_mad_i32_i24">;
def WaveAMDMachine_VMadU32U24Op
    : WaveAMDMachine_TernaryIntResult<"v_mad_u32_u24">;
def WaveAMDMachine_VLshlAddU32Op
    : WaveAMDMachine_TernaryIntResult<"v_lshl_add_u32">;
def WaveAMDMachine_VAddLshlU32Op
    : WaveAMDMachine_TernaryIntResult<"v_add_lshl_u32">;
def WaveAMDMachine_VAndOrB32Op
    : WaveAMDMachine_TernaryIntResult<"v_and_or_b32">;
def WaveAMDMachine_VOr3B32Op
    : WaveAMDMachine_TernaryIntResult<"v_or3_b32">;
def WaveAMDMachine_VXadU32Op
    : WaveAMDMachine_TernaryIntResult<"v_xad_u32">;
def WaveAMDMachine_VAddF32Op
    : WaveAMDMachine_BinaryResult<"v_add_f32", WaveAMDMachine_VGPR1,
                               WaveAMDMachine_VGPR1, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VSubF32Op
    : WaveAMDMachine_BinaryResult<"v_sub_f32", WaveAMDMachine_VGPR1,
                               WaveAMDMachine_VGPR1, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VMulF32Op
    : WaveAMDMachine_BinaryResult<"v_mul_f32", WaveAMDMachine_VGPR1,
                               WaveAMDMachine_VGPR1, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VMaxF32Op
    : WaveAMDMachine_BinaryResult<"v_max_f32", WaveAMDMachine_VGPR1,
                               WaveAMDMachine_VGPR1, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VExpF32Op
    : WaveAMDMachine_UnaryResult<"v_exp_f32", WaveAMDMachine_VGPR1,
                              WaveAMDMachine_VGPR1,
                              [WaveAMDMachine_VALU, Pure]>;
def WaveAMDMachine_VRcpF32Op
    : WaveAMDMachine_UnaryResult<"v_rcp_f32", WaveAMDMachine_VGPR1,
                              WaveAMDMachine_VGPR1,
                              [WaveAMDMachine_VALU, Pure]>;
def WaveAMDMachine_VCvtF16F32Op
    : WaveAMDMachine_UnaryResult<"v_cvt_f16_f32", WaveAMDMachine_VGPR1,
                              WaveAMDMachine_VGPR1,
                              [WaveAMDMachine_VALU, Pure]>;
def WaveAMDMachine_VCvtF32F16Op
    : WaveAMDMachine_UnaryResult<"v_cvt_f32_f16", WaveAMDMachine_VGPR1,
                              WaveAMDMachine_VGPR1,
                              [WaveAMDMachine_VALU, Pure]>;
def WaveAMDMachine_VCvtPkRtzF16F32Op
    : WaveAMDMachine_BinaryResult<"v_cvt_pk_rtz_f16_f32",
                               WaveAMDMachine_VGPR1,
                               WaveAMDMachine_VGPR1,
                               [WaveAMDMachine_VALU]> {
  let archPredicate = "isa.Major == 11";
}
def WaveAMDMachine_VPkAddF16Op
    : WaveAMDMachine_PackedBinaryResult<"v_pk_add_f16">;
def WaveAMDMachine_VPkMulF16Op
    : WaveAMDMachine_PackedBinaryResult<"v_pk_mul_f16">;
def WaveAMDMachine_VPkFmaF16Op
    : WaveAMDMachine_PackedTernaryResult<"v_pk_fma_f16">;
class WaveAMDMachine_VCmpU32Vcc<string mnemonic>
    : WaveAMDMachine_Op<mnemonic, [WaveAMDMachine_VALU, Pure]> {
  let arguments = (ins WaveAMDMachine_RegOrImm:$lhs,
                       WaveAMDMachine_RegOrImm:$rhs);
  let results = (outs WaveAMDMachine_SGPR:$result, WaveAMDMachine_VCC:$vcc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}
class WaveAMDMachine_VCmpxU32<string mnemonic>
    : WaveAMDMachine_Op<mnemonic, [WaveAMDMachine_VALU,
                                   WaveAMDMachine_WritesExec]> {
  let arguments = (ins WaveAMDMachine_RegOrImm:$lhs,
                       WaveAMDMachine_RegOrImm:$rhs);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}
def WaveAMDMachine_VCmpEqU32Op
    : WaveAMDMachine_BinaryResult<"v_cmp_eq_u32", WaveAMDMachine_RegOrImm,
                               WaveAMDMachine_SGPR, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VCmpEqU32VccOp
    : WaveAMDMachine_VCmpU32Vcc<"v_cmp_eq_u32_vcc">;
def WaveAMDMachine_VCmpxEqU32Op
    : WaveAMDMachine_VCmpxU32<"v_cmpx_eq_u32">;
def WaveAMDMachine_VCmpNeU32Op
    : WaveAMDMachine_BinaryResult<"v_cmp_ne_u32", WaveAMDMachine_RegOrImm,
                               WaveAMDMachine_SGPR, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VCmpNeU32VccOp
    : WaveAMDMachine_VCmpU32Vcc<"v_cmp_ne_u32_vcc">;
def WaveAMDMachine_VCmpxNeU32Op
    : WaveAMDMachine_VCmpxU32<"v_cmpx_ne_u32">;
def WaveAMDMachine_VCmpLtU32Op
    : WaveAMDMachine_BinaryResult<"v_cmp_lt_u32", WaveAMDMachine_RegOrImm,
                               WaveAMDMachine_SGPR, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VCmpLtU32VccOp
    : WaveAMDMachine_VCmpU32Vcc<"v_cmp_lt_u32_vcc">;
def WaveAMDMachine_VCmpxLtU32Op
    : WaveAMDMachine_VCmpxU32<"v_cmpx_lt_u32">;
def WaveAMDMachine_VCmpLeU32Op
    : WaveAMDMachine_BinaryResult<"v_cmp_le_u32", WaveAMDMachine_RegOrImm,
                               WaveAMDMachine_SGPR, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VCmpLeU32VccOp
    : WaveAMDMachine_VCmpU32Vcc<"v_cmp_le_u32_vcc">;
def WaveAMDMachine_VCmpxLeU32Op
    : WaveAMDMachine_VCmpxU32<"v_cmpx_le_u32">;
def WaveAMDMachine_VCmpGtU32Op
    : WaveAMDMachine_BinaryResult<"v_cmp_gt_u32", WaveAMDMachine_RegOrImm,
                               WaveAMDMachine_SGPR, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VCmpGtU32VccOp
    : WaveAMDMachine_VCmpU32Vcc<"v_cmp_gt_u32_vcc">;
def WaveAMDMachine_VCmpxGtU32Op
    : WaveAMDMachine_VCmpxU32<"v_cmpx_gt_u32">;
def WaveAMDMachine_VCmpGeU32Op
    : WaveAMDMachine_BinaryResult<"v_cmp_ge_u32", WaveAMDMachine_RegOrImm,
                               WaveAMDMachine_SGPR, [WaveAMDMachine_VALU]>;
def WaveAMDMachine_VCmpGeU32VccOp
    : WaveAMDMachine_VCmpU32Vcc<"v_cmp_ge_u32_vcc">;
def WaveAMDMachine_VCmpxGeU32Op
    : WaveAMDMachine_VCmpxU32<"v_cmpx_ge_u32">;
def WaveAMDMachine_VReadfirstlaneB32Op
    : WaveAMDMachine_UnaryResult<"v_readfirstlane_b32", WaveAMDMachine_VGPR1,
                              WaveAMDMachine_SGPR1, [WaveAMDMachine_VALU, Pure]>;

def WaveAMDMachine_WmmaI32_16x16x16_IU8Op
    : WaveAMDMachine_TernaryResult<"wmma_i32_16x16x16_iu8", WaveAMDMachine_VGPR,
                                WaveAMDMachine_VGPR, [WaveAMDMachine_VALU]> {
  let hasVerifier = 1;
  let archPredicate = "isa.Major == 11";
}
def WaveAMDMachine_WmmaF32_16x16x16_F16Op
    : WaveAMDMachine_TernaryResult<"wmma_f32_16x16x16_f16", WaveAMDMachine_VGPR,
                                WaveAMDMachine_VGPR, [WaveAMDMachine_VALU]> {
  let hasVerifier = 1;
  let archPredicate = "isa.Major == 11";
}
def WaveAMDMachine_WmmaF32_16x16x16_BF16Op
    : WaveAMDMachine_TernaryResult<"wmma_f32_16x16x16_bf16", WaveAMDMachine_VGPR,
                                WaveAMDMachine_VGPR, [WaveAMDMachine_VALU]> {
  let hasVerifier = 1;
  let archPredicate = "isa.Major == 11";
}
def WaveAMDMachine_MfmaF32_16x16x16_F16Op
    : WaveAMDMachine_TernaryResult<"mfma_f32_16x16x16_f16", WaveAMDMachine_AVGPR,
                                   WaveAMDMachine_AVGPR,
                                   [WaveAMDMachine_VALU, WaveAMDMachine_MFMA,
                                    WaveAMDMachine_ReadsExec]> {
  let hasVerifier = 1;
  let archPredicate = WaveAMDMachine_Gfx90APlus;
}
def WaveAMDMachine_MfmaF32_16x16x16_BF16Op
    : WaveAMDMachine_TernaryResult<"mfma_f32_16x16x16_bf16", WaveAMDMachine_AVGPR,
                                   WaveAMDMachine_AVGPR,
                                   [WaveAMDMachine_VALU, WaveAMDMachine_MFMA,
                                    WaveAMDMachine_ReadsExec]> {
  let hasVerifier = 1;
  let archPredicate = WaveAMDMachine_Gfx940Plus;
}
def WaveAMDMachine_MfmaF32_16x16x32_F16Op
    : WaveAMDMachine_TernaryResult<"mfma_f32_16x16x32_f16", WaveAMDMachine_AVGPR,
                                   WaveAMDMachine_AVGPR,
                                   [WaveAMDMachine_VALU, WaveAMDMachine_MFMA,
                                    WaveAMDMachine_ReadsExec]> {
  let hasVerifier = 1;
  let archPredicate = WaveAMDMachine_Gfx950;
}
def WaveAMDMachine_MfmaF32_16x16x32_BF16Op
    : WaveAMDMachine_TernaryResult<"mfma_f32_16x16x32_bf16", WaveAMDMachine_AVGPR,
                                   WaveAMDMachine_AVGPR,
                                   [WaveAMDMachine_VALU, WaveAMDMachine_MFMA,
                                    WaveAMDMachine_ReadsExec]> {
  let hasVerifier = 1;
  let archPredicate = WaveAMDMachine_Gfx950;
}
def WaveAMDMachine_MfmaScaleF32_16x16x128_F4F4Op
    : WaveAMDMachine_Op<"mfma_scale_f32_16x16x128_f4_f4",
                        [WaveAMDMachine_VALU, WaveAMDMachine_MFMA,
                         WaveAMDMachine_ReadsExec, Pure]> {
  let arguments = (ins WaveAMDMachine_AVGPR:$a,
                       WaveAMDMachine_AVGPR:$b,
                       WaveAMDMachine_AVGPR:$acc,
                       WaveAMDMachine_VGPR1:$a_scale,
                       WaveAMDMachine_VGPR1:$b_scale,
                       DefaultValuedAttr<WaveAMDMachine_ScaleIndexAttr, "0">:$scale_idx_a,
                       DefaultValuedAttr<WaveAMDMachine_ScaleIndexAttr, "0">:$scale_idx_b);
  let results = (outs WaveAMDMachine_AVGPR:$result);
  let assemblyFormat = "$a `,` $b `,` $acc `,` $a_scale `,` $b_scale attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
  let archPredicate = WaveAMDMachine_Gfx950;
}

def WaveAMDMachine_SMovB32Op : WaveAMDMachine_UnaryNoResult<"s_mov_b32",
                                                       WaveAMDMachine_RegOrImm> {
  let arguments = (ins StrAttr:$dst, WaveAMDMachine_RegOrImm:$source);
  let assemblyFormat = "$dst `,` $source attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_SCSelectB32Op : WaveAMDMachine_Op<"s_cselect_b32", [Pure]> {
  let summary = "select scalar value using SCC";
  let arguments = (ins WaveAMDMachine_SCC:$cond,
                       WaveAMDMachine_SGPR1OrImm:$true_value,
                       WaveAMDMachine_SGPR1OrImm:$false_value);
  let results = (outs WaveAMDMachine_SGPR1:$result);
  let assemblyFormat = "$cond `,` $true_value `,` $false_value attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_SReadVccB32Op : WaveAMDMachine_Op<"s_read_vcc_b32", [Pure]> {
  let summary = "copy VCC low bits into SGPR";
  let arguments = (ins WaveAMDMachine_VCC:$source);
  let results = (outs WaveAMDMachine_SGPR1:$result);
  let assemblyFormat = "$source attr-dict `:` functional-type(operands, results)";
}

// VCC reload writes singleton flag state; LICM must keep it local.
def WaveAMDMachine_SMovVccB32Op
    : WaveAMDMachine_UnaryResult<"s_mov_vcc_b32", WaveAMDMachine_SGPR1,
                                 WaveAMDMachine_VCC>;

// Value-producing scalar move: materialises an SGPR1 holding the
// given Imm or copies an existing SGPR1/RegOrImm into a fresh
// allocator-assigned SGPR. Used by the selector to lift loop-IV
// initialisers out of `waveamdmachine.imm` into a real carry register.
def WaveAMDMachine_SMovB32ValueOp : WaveAMDMachine_Op<"s_mov_b32_value", [Pure]> {
  let summary = "scalar 32-bit move producing an SGPR value";
  let arguments = (ins WaveAMDMachine_RegOrImm:$source);
  let results = (outs WaveAMDMachine_SGPR1:$result);
  let assemblyFormat = "$source attr-dict `:` functional-type(operands, results)";
}

// Wide-SGPR rename / broadcast, mirroring `v_mov_b32_tuple`. Emits
// N `s_mov_b32` instructions; source may be another same-width
// SGPR tuple (per-component copy) or a scalar value (broadcast).
def WaveAMDMachine_SMovB32TupleOp
    : WaveAMDMachine_UnaryResult<"s_mov_b32_tuple", WaveAMDMachine_RegOrImm,
                              WaveAMDMachine_SGPR, [Pure]> {
  let hasVerifier = 1;
}
def WaveAMDMachine_SLoadB32Op : WaveAMDMachine_UnaryResult<"s_load_b32",
                                                      WaveAMDMachine_Imm,
                                                      WaveAMDMachine_SGPR1,
                                                      [WaveAMDMachine_SMEMLoad]>,
                                  WaveAMDMachine_SMEMInfo<"1"> {
  let arguments = (ins WaveAMDMachine_Imm:$offset, StrAttr:$base);
  let assemblyFormat = "$offset `,` $base attr-dict `:` functional-type(operands, results)";
}
def WaveAMDMachine_SLoadB64Op : WaveAMDMachine_UnaryResult<"s_load_b64",
                                                      WaveAMDMachine_Imm,
                                                      WaveAMDMachine_SGPR2,
                                                      [WaveAMDMachine_SMEMLoad]>,
                                  WaveAMDMachine_SMEMInfo<"2"> {
  let arguments = (ins WaveAMDMachine_Imm:$offset, StrAttr:$base);
  let assemblyFormat = "$offset `,` $base attr-dict `:` functional-type(operands, results)";
}
def WaveAMDMachine_SLoadB128Op : WaveAMDMachine_UnaryResult<"s_load_b128",
                                                       WaveAMDMachine_Imm,
                                                       WaveAMDMachine_SGPR4,
                                                       [WaveAMDMachine_SMEMLoad]>,
                                   WaveAMDMachine_SMEMInfo<"2"> {
  let arguments = (ins WaveAMDMachine_Imm:$offset, StrAttr:$base);
  let assemblyFormat = "$offset `,` $base attr-dict `:` functional-type(operands, results)";
}
// Read the per-SIMD shader-cycles HW register via
// `s_getreg_b32 sN, hwreg(HW_REG_SHADER_CYCLES)`. RDNA3-only.
// gfx11 returns a 32-bit value with only the low 20 bits valid
// (counter wraps at ~600us @ 1.76GHz, which is more than enough
// for microbench bodies but lethal for whole-kernel timing of
// realistic workloads). gfx12 exposes LO/HI pairs and gfx1250
// has `s_get_shader_cycles_u64`; those need their own ops.
def WaveAMDMachine_SGetregShaderCyclesOp
    : WaveAMDMachine_ZeroOperandResult<"s_getreg_shader_cycles",
                                       WaveAMDMachine_SGPR1> {
  let archPredicate = "isa.Major == 11";
  let summary = "read HW_REG_SHADER_CYCLES via s_getreg_b32 (RDNA3)";
}
def WaveAMDMachine_SWaitcntOp
    : WaveAMDMachine_Op<"s_waitcnt",
                        [WaveAMDMachine_Waitcnt,
                         WaveAMDMachine_NoMachineInst]> {
  let arguments = (ins OptionalAttr<I32Attr>:$vmcnt,
                       OptionalAttr<I32Attr>:$expcnt,
                       OptionalAttr<I32Attr>:$lgkmcnt);
  let assemblyFormat = [{
    oilist(`vmcnt` `(` $vmcnt `)`
         | `expcnt` `(` $expcnt `)`
         | `lgkmcnt` `(` $lgkmcnt `)`) attr-dict
  }];
}
def WaveAMDMachine_SWaitcntVscntOp
    : WaveAMDMachine_Op<"s_waitcnt_vscnt",
                        [WaveAMDMachine_Waitcnt,
                         WaveAMDMachine_NoMachineInst]> {
  let arguments = (ins I32Attr:$vscnt);
  let assemblyFormat = "`vscnt` `(` $vscnt `)` attr-dict";
}
def WaveAMDMachine_SNopOp : WaveAMDMachine_UnaryNoResult<"s_nop", WaveAMDMachine_Imm>;
// Set wave issue priority (0..3). Free, dynamic nudge for the HW
// issue arbiter -- prefer this over cycle counting when biasing
// multi-wave co-execution (e.g. ping-pong phase entry: the wave
// group that should issue MFMAs bumps prio while the other group
// is loading). Available on every arch the project supports.
def WaveAMDMachine_SSetprioOp : WaveAMDMachine_UnaryNoResult<"s_setprio",
                                                             WaveAMDMachine_Imm>;
def WaveAMDMachine_SDelayAluOp : WaveAMDMachine_UnaryNoResult<"s_delay_alu",
                                                         WaveAMDMachine_Imm>;
def WaveAMDMachine_SAndSaveexecB32Op
    : WaveAMDMachine_Op<"s_and_saveexec_b32",
                        [WaveAMDMachine_ReadsExec,
                         WaveAMDMachine_WritesExec]> {
  let summary = "save EXEC, mask EXEC, and set SCC";
  let arguments = (ins WaveAMDMachine_SGPR1:$mask);
  let results = (outs
    WaveAMDMachine_SGPR1:$saved_exec,
    WaveAMDMachine_SCC:$scc
  );
  let assemblyFormat = "$mask attr-dict `:` functional-type(operands, results)";
}
def WaveAMDMachine_SAndSaveexecB64Op
    : WaveAMDMachine_Op<"s_and_saveexec_b64",
                        [WaveAMDMachine_ReadsExec,
                         WaveAMDMachine_WritesExec]> {
  let summary = "save EXEC, mask EXEC, and set SCC";
  let arguments = (ins WaveAMDMachine_SGPR2:$mask);
  let results = (outs
    WaveAMDMachine_SGPR2:$saved_exec,
    WaveAMDMachine_SCC:$scc
  );
  let assemblyFormat = "$mask attr-dict `:` functional-type(operands, results)";
}
def WaveAMDMachine_SAndn2ExecB32Op
    : WaveAMDMachine_Op<"s_andn2_exec_b32", [WaveAMDMachine_WritesExec]> {
  let summary = "set EXEC to lhs & ~rhs and set SCC";
  let arguments = (ins WaveAMDMachine_SGPR1:$lhs, WaveAMDMachine_SGPR1:$rhs);
  let results = (outs WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}
def WaveAMDMachine_SAndn2ExecB64Op
    : WaveAMDMachine_Op<"s_andn2_exec_b64", [WaveAMDMachine_WritesExec]> {
  let summary = "set EXEC to lhs & ~rhs and set SCC";
  let arguments = (ins WaveAMDMachine_SGPR2:$lhs, WaveAMDMachine_SGPR2:$rhs);
  let results = (outs WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}
def WaveAMDMachine_SCBranchExeczOp
    : WaveAMDMachine_ZeroResult<"s_cbranch_execz", [WaveAMDMachine_ReadsExec]> {
  let arguments = (ins StrAttr:$label);
  let assemblyFormat = "$label attr-dict";
}
def WaveAMDMachine_SMovExecLoOp : WaveAMDMachine_UnaryNoResult<"s_mov_exec_lo",
                                                          WaveAMDMachine_SGPR1,
                                                          [WaveAMDMachine_WritesExec]>;
def WaveAMDMachine_SMovExecB64Op : WaveAMDMachine_UnaryNoResult<"s_mov_exec_b64",
                                                          WaveAMDMachine_SGPR2,
                                                          [WaveAMDMachine_WritesExec]>;
def WaveAMDMachine_SMovM0Op
    : WaveAMDMachine_UnaryResult<"s_mov_m0", WaveAMDMachine_SGPR1, WaveAMDMachine_M0>;
def WaveAMDMachine_SEndpgmOp : WaveAMDMachine_ZeroResult<"s_endpgm">;
def WaveAMDMachine_SSetpcB64Op : WaveAMDMachine_ZeroResult<"s_setpc_b64">;

def WaveAMDMachine_YieldOp : WaveAMDMachine_Op<"yield", [
  Pure,
  ReturnLike,
  Terminator,
  HasParent<"ExecIfOp">,
  DeclareOpInterfaceMethods<RegionBranchTerminatorOpInterface,
    ["getMutableSuccessorOperands"]>
]> {
  let summary = "exec_if region terminator";
  let arguments = (ins Variadic<AnyType>:$values);
  let builders = [
    OpBuilder<(ins), [{ build($_builder, $_state, ::mlir::ValueRange{}); }]>
  ];
  let assemblyFormat = "($values^ `:` type($values))? attr-dict";
}

def WaveAMDMachine_ExecIfOp : WaveAMDMachine_Op<"exec_if", [
  SingleBlockImplicitTerminator<"YieldOp">,
  DeclareOpInterfaceMethods<RegionBranchOpInterface,
    ["getEntrySuccessorOperands", "getSuccessorInputs",
     "areTypesCompatible"]>,
  RecursiveMemoryEffects,
  NoRegionArguments,
  WaveAMDMachine_ReadsExec,
  WaveAMDMachine_WritesExec
]> {
  let summary = "structured EXEC-masked region";
  let arguments = (ins WaveAMDMachine_SGPR:$condition);
  let results = (outs Variadic<AnyType>:$results);
  let regions = (region SizedRegion<1>:$thenRegion,
                        MaxSizedRegion<1>:$elseRegion);
  let assemblyFormat = [{
    $condition $thenRegion (`otherwise` $elseRegion^)? attr-dict
    `:` type($condition) (`->` type($results)^)?
  }];
  let hasVerifier = 1;
}

def WaveAMDMachine_GlobalLoadU8Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_u8", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global unsigned 8-bit load through an SGPR base";
  let description = [{
    Zero-extends the loaded byte into the result VGPR.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadI8Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_i8", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global signed 8-bit load through an SGPR base";
  let description = [{
    Sign-extends the loaded byte into the result VGPR.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadB16Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_b16", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global 16-bit load through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadB32Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_b32", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global 32-bit load through an SGPR base";
  let description = [{
    Reads one 32-bit value from `base + offset + inst_offset` into the
    result VGPR. `inst_offset` is folded into the instruction's
    13-bit signed immediate slot; it defaults to 0. gfx11 GLOBAL has
    no separate `soffset` slot -- any wave-uniform contribution must
    be folded into `offset` by the producer.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadU8Addr64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_u8_addr64", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global unsigned 8-bit load through a VGPR64 address";
  let description = [{
    Zero-extends the loaded byte into the result VGPR.
  }];
  let arguments = (ins WaveAMDMachine_VGPR2:$address,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $address (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadI8Addr64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_i8_addr64", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global signed 8-bit load through a VGPR64 address";
  let description = [{
    Sign-extends the loaded byte into the result VGPR.
  }];
  let arguments = (ins WaveAMDMachine_VGPR2:$address,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $address (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadB16Addr64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_b16_addr64", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global 16-bit load through a VGPR64 address";
  let arguments = (ins WaveAMDMachine_VGPR2:$address,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $address (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadB32Addr64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_b32_addr64", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global 32-bit load through a VGPR64 address";
  let arguments = (ins WaveAMDMachine_VGPR2:$address,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $address (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

// HW-fused multi-dword global loads. The single op corresponds 1:1 to
// one `global_load_dwordx{2,3,4}` instruction on gfx9 (and the
// `_b{64,96,128}` syntax on gfx11/12). Operand shape mirrors
// `global_load_b32`; result width is fixed by the op's mnemonic.
def WaveAMDMachine_GlobalLoadB64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_b64", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global 64-bit load through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR2:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadB96Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_b96", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global 96-bit load through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR3:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadB128Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_b128", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global 128-bit load through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR4:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalLoadTupleB32Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_tuple_b32", [WaveAMDMachine_VMEMLoad, WaveAMDMachine_TupleMemory, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMTupleLoadInfo {
  let summary = "global load of N consecutive 32-bit values into a VGPR tuple";
  let description = [{
    Loads `N` consecutive dwords from `base + offset + inst_offset +
    i*4` into the `N` components of a single VGPR tuple result of
    width `N`. Waitcnt issue count matches the b32/b64/b96/b128 chunks
    produced by `waveamd-decompose-mem-tuples`.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

// Global LDS DMA ops have no inst-offset slot in the hardware
// encoding (the `global_load_lds_*` form addresses through V + base
// only). The `inst_offset` attribute remains for IR shape uniformity
// but always emits as 0; address planning sinks constants into `voffset`.
def WaveAMDMachine_GlobalLoadLdsB32Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_lds_b32", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead, MemWrite]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global-to-LDS 32-bit DMA load";
  let description = [{
    Reads one dword from global memory and writes it to LDS. `m0` carries the
    scalar LDS base; hardware adds 4*lane_id for this dword form. The op
    consumes an input memory token for global memory ordering and returns a
    token representing the global read plus LDS write.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       WaveAMDMachine_M0:$m0, WaveAMDMachine_MemToken:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset,
                       DefaultValuedAttr<I64Attr, "0">:$aux);
  let results = (outs WaveAMDMachine_MemToken:$token);
  let assemblyFormat = [{
    $offset `,` $base `,` $m0 `after` $dependency
    (`offset` $inst_offset^)? (`aux` $aux^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let extraClassDefinition = [{
    ::mlir::waveamdmachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/0, /*instOffsetSigned=*/false,
              /*hasSoffset=*/false};
    }
  }];
}

def WaveAMDMachine_GlobalLoadLdsB128Op
    : WaveAMDMachine_GlobalMemoryOp<"global_load_lds_b128", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead, MemWrite]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "global-to-LDS 128-bit DMA load";
  let description = [{
    Reads 16 bytes from global memory and writes them to LDS. `m0` carries the
    scalar LDS base; hardware adds 16*lane_id for this form.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR2:$base,
                       WaveAMDMachine_M0:$m0, WaveAMDMachine_MemToken:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset,
                       DefaultValuedAttr<I64Attr, "0">:$aux);
  let results = (outs WaveAMDMachine_MemToken:$token);
  let assemblyFormat = [{
    $offset `,` $base `,` $m0 `after` $dependency
    (`offset` $inst_offset^)? (`aux` $aux^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let extraClassDefinition = [{
    ::mlir::waveamdmachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/0, /*instOffsetSigned=*/false,
              /*hasSoffset=*/false};
    }
  }];
}

def WaveAMDMachine_MakeBufferRsrcOp
    : WaveAMDMachine_Op<"make_buffer_rsrc", [Pure]> {
  let summary = "construct an AMD buffer descriptor";
  let arguments = (ins WaveAMDMachine_SGPR2:$base,
                       WaveAMDMachine_RegOrImm:$range);
  let results = (outs WaveAMDMachine_SGPR4:$descriptor);
  let assemblyFormat = "$base `,` $range attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_GlobalStoreB8Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b8", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 8-bit store through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_RegOrImm:$value,
                       WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalStoreB16Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b16", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 16-bit store through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_RegOrImm:$value,
                       WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalStoreB32Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b32", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 32-bit store through an SGPR base";
  let description = [{
    Stores `value` to `base + offset + inst_offset`. `inst_offset` is
    folded into the instruction's 13-bit signed immediate slot;
    defaults to 0.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_RegOrImm:$value,
                       WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalStoreB8Addr64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b8_addr64", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 8-bit store through a VGPR64 address";
  let arguments = (ins WaveAMDMachine_VGPR2:$address, WaveAMDMachine_VGPR1:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $address `,` $value (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalStoreB16Addr64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b16_addr64", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 16-bit store through a VGPR64 address";
  let arguments = (ins WaveAMDMachine_VGPR2:$address, WaveAMDMachine_VGPR1:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $address `,` $value (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalStoreB32Addr64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b32_addr64", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 32-bit store through a VGPR64 address";
  let arguments = (ins WaveAMDMachine_VGPR2:$address, WaveAMDMachine_VGPR1:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $address `,` $value (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalStoreB64Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b64", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 64-bit store through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR2:$value,
                       WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalStoreB96Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b96", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 96-bit store through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR3:$value,
                       WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_GlobalStoreB128Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_b128", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "global 128-bit store through an SGPR base";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR4:$value,
                       WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}
def WaveAMDMachine_BufferStoreB8Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_store_b8", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "buffer 8-bit store through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR1:$value,
                       WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferStoreB16Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_store_b16", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "buffer 16-bit store through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR1:$value,
                       WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferStoreB32Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_store_b32", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "buffer 32-bit store through an SGPR descriptor and VGPR offset";
  let description = [{
    MUBUF OFFEN: stores `value` to `descriptor[offset + soffset +
    inst_offset]`. `soffset` is the wave-uniform contribution (SGPR
    or immediate); callers pass `waveamdmachine.imm 0` when there is no
    S bucket. `inst_offset` folds into the instruction's 12-bit
    unsigned immediate field and defaults to 0.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR1:$value,
                       WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}
def WaveAMDMachine_BufferLoadU8Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_u8", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer unsigned 8-bit load through an SGPR descriptor and VGPR offset";
  let description = [{
    Zero-extends the loaded byte into the result VGPR.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferLoadI8Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_i8", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer signed 8-bit load through an SGPR descriptor and VGPR offset";
  let description = [{
    Sign-extends the loaded byte into the result VGPR.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferLoadB16Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_b16", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer 16-bit load through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferLoadB32Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_b32", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer 32-bit load through an SGPR descriptor and VGPR offset";
  let description = [{
    MUBUF OFFEN: loads a 32-bit value from `descriptor[offset +
    soffset + inst_offset]` into the result VGPR. Callers pass
    `waveamdmachine.imm 0` for soffset when there is no S bucket.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}
def WaveAMDMachine_BufferLoadB64Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_b64", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer 64-bit load through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR2:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferLoadB96Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_b96", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer 96-bit load through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR3:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferLoadB128Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_b128", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer 128-bit load through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR4:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferStoreB64Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_store_b64", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "buffer 64-bit store through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR2:$value,
                       WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferStoreB96Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_store_b96", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "buffer 96-bit store through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR3:$value,
                       WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferStoreB128Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_store_b128", [WaveAMDMachine_VMEMStore, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMStoreInfo {
  let summary = "buffer 128-bit store through an SGPR descriptor and VGPR offset";
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR4:$value,
                       WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_BufferLoadTupleB32Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_tuple_b32", [WaveAMDMachine_VMEMLoad, WaveAMDMachine_TupleMemory, MemoryEffects<[MemRead]>]>,
      WaveAMDMachine_VMEMTupleLoadInfo {
  let summary = "buffer load of N consecutive 32-bit values into a VGPR tuple";
  let description = [{
    Loads `N` consecutive dwords from `descriptor[offset + soffset +
    inst_offset + i*4]` into the `N` components of a single VGPR
    tuple result of width `N`. Waitcnt issue count matches the
    b32/b64/b96/b128 chunks produced by `waveamd-decompose-mem-tuples`.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveAMDMachine_VGPR:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

// Buffer LDS DMA ops have no inst-offset slot. Constants route to
// `soffset`, but nonzero immediates must materialize through SGPR.
def WaveAMDMachine_BufferLoadLdsB32Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_lds_b32", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead, MemWrite]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer-to-LDS 32-bit DMA load";
  let description = [{
    Reads one dword through a buffer descriptor and writes it to LDS. `m0`
    carries the scalar LDS base; hardware adds 4*lane_id for this dword form.
    The op consumes an input memory token for buffer/global ordering and
    returns a token representing the memory read plus LDS write.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset, WaveAMDMachine_M0:$m0,
                       WaveAMDMachine_MemToken:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset,
                       DefaultValuedAttr<I64Attr, "0">:$aux);
  let results = (outs WaveAMDMachine_MemToken:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset `,` $m0 `after` $dependency
    (`offset` $inst_offset^)? (`aux` $aux^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let extraClassDefinition = [{
    ::mlir::waveamdmachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/0, /*instOffsetSigned=*/false,
              /*hasSoffset=*/true,
              ::mlir::waveamdmachine::SOffsetImmPolicy::ZeroImmOnly};
    }
  }];
}

def WaveAMDMachine_BufferLoadLdsB128Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_load_lds_b128", [WaveAMDMachine_VMEMLoad, MemoryEffects<[MemRead, MemWrite]>]>,
      WaveAMDMachine_VMEMLoadInfo {
  let summary = "buffer-to-LDS 128-bit DMA load";
  let description = [{
    Reads 16 bytes through a buffer descriptor and writes them to LDS. `m0`
    carries the scalar LDS base; hardware adds 16*lane_id for this form.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset, WaveAMDMachine_M0:$m0,
                       WaveAMDMachine_MemToken:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset,
                       DefaultValuedAttr<I64Attr, "0">:$aux);
  let results = (outs WaveAMDMachine_MemToken:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset `,` $m0 `after` $dependency
    (`offset` $inst_offset^)? (`aux` $aux^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let extraClassDefinition = [{
    ::mlir::waveamdmachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/0, /*instOffsetSigned=*/false,
              /*hasSoffset=*/true,
              ::mlir::waveamdmachine::SOffsetImmPolicy::ZeroImmOnly};
    }
  }];
}

def WaveAMDMachine_BufferStoreTupleB32Op
    : WaveAMDMachine_BufferMemoryOp<"buffer_store_tuple_b32", [WaveAMDMachine_VMEMStore, WaveAMDMachine_TupleMemory, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMTupleStoreInfo {
  let summary = "buffer 32-bit store of a VGPR tuple component";
  let description = [{
    Stores `N` consecutive dwords from the `value` VGPR tuple to the
    buffer described by `descriptor` at the lane VGPR offset plus
    `soffset + inst_offset + i*4`. Waitcnt issue count matches the
    b32/b64/b96/b128 chunks produced by `waveamd-decompose-mem-tuples`.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR:$value,
                       WaveAMDMachine_SGPR4:$descriptor,
                       WaveAMDMachine_SGPR1OrImm:$soffset,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}
def WaveAMDMachine_GlobalStoreTupleB32Op
    : WaveAMDMachine_GlobalMemoryOp<"global_store_tuple_b32", [WaveAMDMachine_VMEMStore, WaveAMDMachine_TupleMemory, MemoryEffects<[MemWrite]>]>,
      WaveAMDMachine_VMEMTupleStoreInfo {
  let summary = "global 32-bit store of a VGPR tuple component";
  let description = [{
    Per-component dword store: writes lane `component` of the `value`
    VGPR tuple to `base + offset + inst_offset + component * 4`.
    `inst_offset` lands in the instruction's 13-bit signed immediate
    slot together with `component * 4`. Waitcnt issue count matches the
    b32/b64/b96/b128 chunks produced by `waveamd-decompose-mem-tuples`.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$offset, WaveAMDMachine_VGPR:$value,
                       WaveAMDMachine_SGPR2:$base,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

// LDS ("group_segment_fixed_size") loads and stores share the same
// per-workgroup arena: the address operand is a 32-bit byte offset into
// LDS and an optional immediate `offset:imm` is folded into the
// hardware instruction. Both kinds drain through `lgkmcnt`.
def WaveAMDMachine_DsLoadU8Op
    : WaveAMDMachine_DsMemoryOp<"ds_load_u8", [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS unsigned 8-bit load";
  let description = [{
    Zero-extends the loaded byte into the result VGPR.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsLoadI8Op
    : WaveAMDMachine_DsMemoryOp<"ds_load_i8", [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS signed 8-bit load";
  let description = [{
    Sign-extends the loaded byte into the result VGPR.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsLoadB16Op
    : WaveAMDMachine_DsMemoryOp<"ds_load_b16", [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 16-bit load";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsLoadB32Op
    : WaveAMDMachine_DsMemoryOp<"ds_load_b32", [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 32-bit load";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR1:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsLoadTupleB32Op
    : WaveAMDMachine_DsMemoryOp<"ds_load_tuple_b32", [WaveAMDMachine_LDSLoad, WaveAMDMachine_TupleMemory]>,
      WaveAMDMachine_LDSTupleLoadInfo {
  let summary = "LDS load of N consecutive 32-bit values into a VGPR tuple";
  let description = [{
    Loads `N` consecutive dwords from LDS at `addr + offset + i*4` for
    `i` in `[0, N)` into the `N` components of a single VGPR tuple
    result of width `N`. Waitcnt issue count matches the b32/b64/b96/b128
    chunks produced by `waveamd-decompose-mem-tuples`.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsStoreB16Op
    : WaveAMDMachine_DsMemoryOp<"ds_store_b16", [WaveAMDMachine_LDSStore]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 16-bit store";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr, WaveAMDMachine_VGPR1:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsStoreB32Op
    : WaveAMDMachine_DsMemoryOp<"ds_store_b32", [WaveAMDMachine_LDSStore]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 32-bit store";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr, WaveAMDMachine_VGPR1:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsStoreB8Op
    : WaveAMDMachine_DsMemoryOp<"ds_store_b8", [WaveAMDMachine_LDSStore]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 8-bit store";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr, WaveAMDMachine_VGPR1:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsLoadB64Op
    : WaveAMDMachine_DsMemoryOp<"ds_load_b64", [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 64-bit load";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR2:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsReadTrB64B4Op
    : WaveAMDMachine_DsMemoryOp<"ds_read_tr_b64_b4",
                                [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "gfx950 LDS 64-bit transposed read over 4 lanes";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR2:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let archPredicate = WaveAMDMachine_Gfx950;
}

def WaveAMDMachine_DsReadTrB64B8Op
    : WaveAMDMachine_DsMemoryOp<"ds_read_tr_b64_b8",
                                [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "gfx950 LDS 64-bit transposed read over 8 lanes";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR2:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let archPredicate = WaveAMDMachine_Gfx950;
}

def WaveAMDMachine_DsLoadB96Op
    : WaveAMDMachine_DsMemoryOp<"ds_load_b96", [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 96-bit load";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR3:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsLoadB128Op
    : WaveAMDMachine_DsMemoryOp<"ds_load_b128", [WaveAMDMachine_LDSLoad]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 128-bit load";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR4:$result,
                      Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsStoreB64Op
    : WaveAMDMachine_DsMemoryOp<"ds_store_b64", [WaveAMDMachine_LDSStore]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 64-bit store";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr, WaveAMDMachine_VGPR2:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsStoreB96Op
    : WaveAMDMachine_DsMemoryOp<"ds_store_b96", [WaveAMDMachine_LDSStore]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 96-bit store";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr, WaveAMDMachine_VGPR3:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsStoreB128Op
    : WaveAMDMachine_DsMemoryOp<"ds_store_b128", [WaveAMDMachine_LDSStore]>,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "LDS 128-bit store";
  let arguments = (ins WaveAMDMachine_VGPR1:$addr, WaveAMDMachine_VGPR4:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsStoreTupleB32Op
    : WaveAMDMachine_DsMemoryOp<"ds_store_tuple_b32", [WaveAMDMachine_LDSStore, WaveAMDMachine_TupleMemory]>,
      WaveAMDMachine_LDSTupleStoreInfo {
  let summary = "LDS store of a VGPR tuple as N consecutive 32-bit values";
  let description = [{
    Stores the `N` components of the `value` VGPR tuple to LDS at
    `addr + offset + i*4` for `i` in `[0, N)`. Waitcnt issue count
    matches the b32/b64/b96/b128 chunks produced by
    `waveamd-decompose-mem-tuples`.
  }];
  let arguments = (ins WaveAMDMachine_VGPR1:$addr, WaveAMDMachine_VGPR:$value,
                       Optional<WaveAMDMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Optional<WaveAMDMachine_MemToken>:$token);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsSwizzleB32Op
    : WaveAMDMachine_DsOp<"ds_swizzle_b32">,
      WaveAMDMachine_LDSInfo<"1"> {
  let summary = "DS lane swizzle";
  let archPredicate = WaveAMDMachine_Gfx8To13;
  let arguments = (ins WaveAMDMachine_VGPR1:$source,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR1:$result);
  let assemblyFormat = [{
    $source (`offset` $offset^)? attr-dict `:`
    functional-type(operands, results)
  }];
}

class WaveAMDMachine_DsPermuteB32Base<string mnemonic>
    : WaveAMDMachine_DsOp<mnemonic>,
      WaveAMDMachine_LDSInfo<"1"> {
  let archPredicate = WaveAMDMachine_Gfx8To13;
  let arguments = (ins WaveAMDMachine_VGPR1:$addr,
                       WaveAMDMachine_VGPR1:$data,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveAMDMachine_VGPR1:$result);
  let assemblyFormat = [{
    $addr `,` $data (`offset` $offset^)? attr-dict `:`
    functional-type(operands, results)
  }];
}

def WaveAMDMachine_DsPermuteB32Op
    : WaveAMDMachine_DsPermuteB32Base<"ds_permute_b32"> {
  let summary = "DS lane permute";
}

def WaveAMDMachine_DsBpermuteB32Op
    : WaveAMDMachine_DsPermuteB32Base<"ds_bpermute_b32"> {
  let summary = "DS lane broadcast permute";
}

def WaveAMDMachine_SBarrierOp : WaveAMDMachine_Op<"s_barrier"> {
  let summary = "workgroup-wide barrier";
  let description = [{
    Synchronizes all waves of the workgroup. Surrounding waitcnts must
    be inserted by `wave-amd-insert-ticket-waits` based on the
    dependencies passed through the higher-level `wave.barrier`.
  }];

  let arguments = (ins Variadic<WaveAMDMachine_MemToken>:$dependencies);
  let results = (outs Variadic<WaveAMDMachine_MemToken>:$tokens);
  let assemblyFormat = "$dependencies attr-dict `:` functional-type(operands, results)";
}

//===----------------------------------------------------------------------===//
// Scalar ALU + branches (used by structured uniform loops)
//===----------------------------------------------------------------------===//

// Wave-uniform scalar add. Produces both an SGPR sum and an SCC
// carry-out so that any IR consumer of SCC (e.g. an immediately
// following s_cmp / continue_if) cannot accidentally be reordered
// across this op without the dependence being visible.
def WaveAMDMachine_SAddI32Op : WaveAMDMachine_Op<"s_add_i32", [Pure]> {
  let summary = "scalar 32-bit add (sets SCC)";
  let arguments = (ins
    WaveAMDMachine_SGPR1:$lhs,
    WaveAMDMachine_SGPR1OrImm:$rhs
  );
  let results = (outs WaveAMDMachine_SGPR1:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// Signed scalar 32-bit multiply. AMDGPU `s_mul_i32` does not set SCC, so
// there's no carry-out result to model; callers that need the high half
// or unsigned behaviour will get separate ops later.
def WaveAMDMachine_SMulI32Op : WaveAMDMachine_Op<"s_mul_i32", [Pure]> {
  let summary = "scalar 32-bit signed multiply (low half)";
  let arguments = (ins WaveAMDMachine_SGPR1OrImm:$lhs,
                       WaveAMDMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveAMDMachine_SGPR1:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// Scalar 32-bit logical left shift. `s_lshl_b32` does set SCC, but the
// offset-math path that uses this op throws the SCC away; model it as
// SCC-clobbering rather than SCC-producing so consumers can't reach for
// it accidentally.
def WaveAMDMachine_SLshlB32Op : WaveAMDMachine_Op<"s_lshl_b32", [Pure]> {
  let summary = "scalar 32-bit logical left shift";
  let arguments = (ins WaveAMDMachine_SGPR1OrImm:$lhs,
                       WaveAMDMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveAMDMachine_SGPR1:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_SLshrB32Op : WaveAMDMachine_Op<"s_lshr_b32", [Pure]> {
  let summary = "scalar 32-bit logical right shift";
  let arguments = (ins WaveAMDMachine_SGPR1OrImm:$lhs,
                       WaveAMDMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveAMDMachine_SGPR1:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_SAndB32Op : WaveAMDMachine_Op<"s_and_b32", [Pure]> {
  let summary = "scalar 32-bit bitwise AND";
  let arguments = (ins WaveAMDMachine_SGPR1OrImm:$lhs,
                       WaveAMDMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveAMDMachine_SGPR1:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_SOrB32Op : WaveAMDMachine_Op<"s_or_b32", [Pure]> {
  let summary = "scalar 32-bit bitwise OR";
  let arguments = (ins WaveAMDMachine_SGPR1OrImm:$lhs,
                       WaveAMDMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveAMDMachine_SGPR1:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_SXorB32Op : WaveAMDMachine_Op<"s_xor_b32", [Pure]> {
  let summary = "scalar 32-bit bitwise XOR";
  let arguments = (ins WaveAMDMachine_SGPR1OrImm:$lhs,
                       WaveAMDMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveAMDMachine_SGPR1:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_SXorB64Op : WaveAMDMachine_Op<"s_xor_b64", [Pure]> {
  let summary = "scalar 64-bit bitwise XOR";
  let arguments = (ins WaveAMDMachine_SGPR2:$lhs, WaveAMDMachine_SGPR2:$rhs);
  let results = (outs WaveAMDMachine_SGPR2:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// 64-bit scalar add. The asm printer expands this into the carry-chain
// pair `s_add_u32` (low) + `s_addc_u32` (high). The intermediate SCC is
// consumed by the second instruction and discarded after.
def WaveAMDMachine_SAddU64Op : WaveAMDMachine_Op<"s_add_u64", [Pure]> {
  let summary = "scalar 64-bit unsigned add";
  let arguments = (ins WaveAMDMachine_SGPR2:$lhs, WaveAMDMachine_SGPR2:$rhs);
  let results = (outs WaveAMDMachine_SGPR2:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// 64-bit base + zero-extended 32-bit offset. Expands to `s_add_u32`
// (low) + `s_addc_u32 hi, hi, 0` (high) -- the high addend is an
// immediate, so unlike a full `s_add_u64` it needs no second register
// pair and no `tuple_from_elements` to widen the offset.
def WaveAMDMachine_SAddU64U32Op : WaveAMDMachine_Op<"s_add_u64_u32", [Pure]> {
  let summary = "scalar 64-bit base + zero-extended 32-bit offset";
  let arguments = (ins
    WaveAMDMachine_SGPR2:$base,
    WaveAMDMachine_SGPR1OrImm:$offset
  );
  let results = (outs WaveAMDMachine_SGPR2:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$base `,` $offset attr-dict `:` functional-type(operands, results)";
}

// 64-bit vector add. Expanded as a target carry-chain pair through VCC.
def WaveAMDMachine_VAddU64Op : WaveAMDMachine_Op<"v_add_u64", [Pure]> {
  let summary = "vector 64-bit unsigned add";
  let arguments = (ins WaveAMDMachine_VGPR2:$lhs, WaveAMDMachine_VGPR2:$rhs);
  let results = (outs WaveAMDMachine_VGPR2:$result, WaveAMDMachine_VCC:$vcc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// 64-bit unsigned multiply (low half). gfx11 has no native u64 mul, so
// the asm printer expands this into the four-mul-plus-two-add canonical
// sequence using the `$scratch` SGPR for the cross-product temporaries
// (a_lo*b_hi and a_hi*b_lo). `$scratch` is a real allocated register
// that's dead after the op; the regalloc just sees one extra short-
// lived live range per op.
def WaveAMDMachine_SMulU64Op : WaveAMDMachine_Op<"s_mul_u64", [Pure]> {
  let summary = "scalar 64-bit unsigned multiply (low half)";
  let arguments = (ins WaveAMDMachine_SGPR2:$lhs, WaveAMDMachine_SGPR2:$rhs);
  let results = (outs
    WaveAMDMachine_SGPR2:$result,
    WaveAMDMachine_SGPR1:$scratch,
    WaveAMDMachine_SCC:$scc
  );
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_VMulU64Op : WaveAMDMachine_Op<"v_mul_u64", [Pure]> {
  let summary = "vector 64-bit unsigned multiply (low half)";
  let arguments = (ins WaveAMDMachine_VGPR2:$lhs, WaveAMDMachine_VGPR2:$rhs);
  let results = (outs
    WaveAMDMachine_VGPR2:$result,
    WaveAMDMachine_VGPR1:$scratch
  );
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_VXorB64Op
    : WaveAMDMachine_Op<"v_xor_b64", [WaveAMDMachine_VALU, Pure]> {
  let summary = "vector 64-bit bitwise XOR";
  let arguments = (ins WaveAMDMachine_VGPR2:$lhs, WaveAMDMachine_VGPR2:$rhs);
  let results = (outs WaveAMDMachine_VGPR2:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// 64-bit logical left shift. Single-instruction on gfx11 in both the
// scalar and vector worlds. The shift operand is i64 to match
// `wave.binary shli`'s "operands have the same type" rule -- the printer
// extracts the low 32 bits since that's what the hardware reads.
def WaveAMDMachine_SLshlB64Op : WaveAMDMachine_Op<"s_lshl_b64", [Pure]> {
  let summary = "scalar 64-bit logical left shift (sets SCC)";
  let arguments = (ins WaveAMDMachine_SGPR2:$lhs, WaveAMDMachine_SGPR2:$shift);
  let results = (outs WaveAMDMachine_SGPR2:$result, WaveAMDMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $shift attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_VLshlrevB64Op : WaveAMDMachine_Op<"v_lshlrev_b64", [Pure]> {
  let summary = "vector 64-bit logical left shift";
  let arguments = (ins WaveAMDMachine_VGPR2:$shift,
                       WaveAMDMachine_VGPR2:$value);
  let results = (outs WaveAMDMachine_VGPR2:$result);
  let assemblyFormat = "$shift `,` $value attr-dict `:` functional-type(operands, results)";
}

// Materializes a 64-bit immediate as a 2-wide SGPR via two
// `s_mov_b32` instructions for the low and high halves. Used by the
// selector to lift `arith.constant : i64` into the 2-wide register
// world the i64 ops consume.
def WaveAMDMachine_SMovB64ImmOp : WaveAMDMachine_Op<"s_mov_b64_imm", [Pure]> {
  let summary = "materialize a 64-bit immediate into an SGPR pair";
  let arguments = (ins I64Attr:$value);
  let results = (outs WaveAMDMachine_SGPR2:$result);
  let assemblyFormat = "$value attr-dict `:` type($result)";
}

def WaveAMDMachine_SCmpLtI32Op : WaveAMDMachine_Op<"s_cmp_lt_i32", [Pure]> {
  let summary = "scalar signed less-than compare (sets SCC)";
  let arguments = (ins
    WaveAMDMachine_SGPR1OrImm:$lhs,
    WaveAMDMachine_SGPR1OrImm:$rhs
  );
  let results = (outs WaveAMDMachine_SCC:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// SCC reload form writes singleton flag state; LICM must keep it local.
def WaveAMDMachine_SCmpLgU32Op : WaveAMDMachine_Op<"s_cmp_lg_u32"> {
  let summary = "scalar unsigned not-equal compare (sets SCC)";
  let arguments = (ins
    WaveAMDMachine_SGPR1OrImm:$lhs,
    WaveAMDMachine_SGPR1OrImm:$rhs
  );
  let results = (outs WaveAMDMachine_SCC:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveAMDMachine_SCBranchScc0Op : WaveAMDMachine_Op<"s_cbranch_scc0"> {
  let summary = "branch if SCC is zero";
  let arguments = (ins WaveAMDMachine_SCC:$cond, StrAttr:$label);
  let assemblyFormat = "$cond `:` type($cond) `,` $label attr-dict";
}

def WaveAMDMachine_SCBranchScc1Op : WaveAMDMachine_Op<"s_cbranch_scc1"> {
  let summary = "branch if SCC is one";
  let arguments = (ins WaveAMDMachine_SCC:$cond, StrAttr:$label);
  let assemblyFormat = "$cond `:` type($cond) `,` $label attr-dict";
}

//===----------------------------------------------------------------------===//
// Structured uniform loop
//===----------------------------------------------------------------------===//

def WaveAMDMachine_UniformLoopOp : WaveAMDMachine_Op<"uniform_loop", [
  AttrSizedOperandSegments,
  SingleBlock,
  DeclareOpInterfaceMethods<RegionBranchOpInterface,
    ["getEntrySuccessorOperands", "getSuccessorInputs"]>,
  DeclareOpInterfaceMethods<LoopLikeOpInterface,
    ["getLoopRegions", "getRegionIterArgs", "getYieldedValuesMutable",
     "getLoopResults"]>,
  RecursiveMemoryEffects
]> {
  let summary = "structured wave-uniform loop with explicit IV bookkeeping";
  let description = [{
    Wave-uniform structured loop with one body region whose block
    arguments shadow `$inits`. The terminator `waveamdmachine.continue_if`
    branches either back to the body (continue) or out of the op
    (results = continue_if.carries).

    When `$entry_cond` is present, the loop is pre-tested: if the SCC
    becomes false on entry, the body is skipped entirely and the
    results take the `$inits` values. When absent, the loop is
    post-tested (do/while) and the body always runs at least once.

    All IV arithmetic / comparisons are materialised as explicit
    `waveamdmachine.s_add_i32` / `s_cmp_*` ops in the body; this op only
    establishes the region boundary and the back-edge that the waitcnt
    pass needs to see via `RegionBranchOpInterface`.
  }];

  let arguments = (ins Optional<WaveAMDMachine_SCC>:$entry_cond,
                       Variadic<WaveAMDMachine_RegOrMemToken>:$inits);
  let results = (outs Variadic<WaveAMDMachine_RegOrMemToken>:$results);
  let regions = (region SizedRegion<1>:$body);

  let assemblyFormat = [{
    (`if` $entry_cond^ `:` type($entry_cond))?
    (`carries` `(` $inits^ `:` type($inits) `)`)?
    $body
    attr-dict (`->` type($results)^)?
  }];

  let hasVerifier = 1;
}

def WaveAMDMachine_ContinueIfOp : WaveAMDMachine_Op<"continue_if", [
  Terminator,
  HasParent<"UniformLoopOp">,
  DeclareOpInterfaceMethods<RegionBranchTerminatorOpInterface,
    ["getMutableSuccessorOperands"]>
]> {
  let summary = "uniform_loop back-edge terminator";
  let description = [{
    Conditional branch to the head of the parent `uniform_loop`'s body
    if `$cond` (SCC) is one; otherwise the loop exits with `$carries`
    as the op's results.

    Only `$carries` are forwarded across the back-edge; `$cond` is the
    SCC bit (already set by an upstream `s_cmp_*` op) consumed locally
    by the `s_cbranch_scc1` the printer emits.
  }];

  let arguments = (ins WaveAMDMachine_SCC:$cond,
                       Variadic<WaveAMDMachine_RegOrMemToken>:$carries);

  let assemblyFormat = [{
    $cond `:` type($cond)
    (`carries` `(` $carries^ `:` type($carries) `)`)?
    attr-dict
  }];

}

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEOPS_TD
