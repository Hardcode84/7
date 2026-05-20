//===-- WaveMachineOps.td - WaveMachine dialect ------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEMACHINE_IR_WAVEMACHINEOPS_TD
#define MLIR_DIALECT_WAVEMACHINE_IR_WAVEMACHINEOPS_TD

include "mlir/Dialect/WaveMachine/IR/WaveMachineBase.td"
include "mlir/Dialect/WaveMachine/IR/WaveMachineInterfaces.td"
include "mlir/Dialect/WaveMachine/IR/WaveMachineTypes.td"
include "mlir/IR/OpBase.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

class WaveMachine_Op<string mnemonic, list<Trait> traits = []> :
    Op<WaveMachine_Dialect, mnemonic, traits>;

def WaveMachine_VALU : NativeOpTrait<"wavemachine::VALUOp">;
def WaveMachine_SMEMLoad : NativeOpTrait<"wavemachine::SMEMLoadOp">;
def WaveMachine_VMEMLoad : NativeOpTrait<"wavemachine::VMEMLoadOp">;
def WaveMachine_VMEMStore : NativeOpTrait<"wavemachine::VMEMStoreOp">;
def WaveMachine_Waitcnt : NativeOpTrait<"wavemachine::WaitcntOp">;
def WaveMachine_TokenTrait : NativeOpTrait<"wavemachine::TokenOp">;
def WaveMachine_TokenJoinTrait : NativeOpTrait<"wavemachine::TokenJoinOp">;

def WaveMachine_SGPR
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::SGPR">,
           "WaveMachine SGPR register">;

def WaveMachine_SGPR1
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::SGPR && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getWidth() == 1">,
           "WaveMachine scalar SGPR register">;

def WaveMachine_SGPR2
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::SGPR && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getWidth() == 2">,
           "WaveMachine SGPR pair register">;

def WaveMachine_SGPR4
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::SGPR && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getWidth() == 4">,
           "WaveMachine SGPR quad register">;

def WaveMachine_VGPR
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::VGPR">,
           "WaveMachine VGPR register">;

def WaveMachine_VGPR1
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::VGPR && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getWidth() == 1">,
           "WaveMachine scalar VGPR register">;

def WaveMachine_VGPR2
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::VGPR && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getWidth() == 2">,
           "WaveMachine VGPR pair register">;

// SCC is the status condition code: a 1-bit hardware register implicitly
// written by scalar ALU ops (s_cmp_*, s_add_i32 carry-out, ...) and read
// by s_cbranch_scc0/1. There is exactly one physical SCC, so the
// allocator skips SCC values entirely. Modelling it as a value makes the
// def-use chain (s_cmp -> continue_if / cbranch) explicit in the IR.
def WaveMachine_SCC
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::SCC">,
           "WaveMachine SCC status bit">;

def WaveMachine_SGPR1OrImm
    : Type<CPred<"(::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::SGPR && "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getWidth() == 1) || "
                 "::llvm::isa<::mlir::wavemachine::ImmType>($_self)">,
           "WaveMachine SGPR or immediate">;

def WaveMachine_RegOrImm
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) || "
                 "::llvm::isa<::mlir::wavemachine::ImmType>($_self)">,
           "WaveMachine register or immediate">;

// Any allocatable register class (SGPR, VGPR, AGPR). Excludes SCC,
// which is a 1-bit hardware flag that cannot participate in tuples.
def WaveMachine_GPR
    : Type<CPred<"::llvm::isa<::mlir::wavemachine::RegType>($_self) && "
                 "(::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::SGPR || "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::VGPR || "
                 "::llvm::cast<::mlir::wavemachine::RegType>($_self).getRegClass() == ::mlir::wavemachine::RegClass::AGPR)">,
           "WaveMachine GPR (SGPR/VGPR/AGPR)">;

class WaveMachine_ZeroResult<string mnemonic, list<Trait> traits = []>
    : WaveMachine_Op<mnemonic, traits> {
  let assemblyFormat = "attr-dict";
}

// Three memory-space bases that fold AddressFieldsOpInterface into the
// parent op. Each owns the per-space inst_offset width / soffset
// slot decision in one place. Concrete ops inherit these instead of
// WaveMachine_Op directly.
class WaveMachine_GlobalMemoryOp<string mnemonic, list<Trait> traits = []>
    : WaveMachine_Op<mnemonic,
        !listconcat(traits,
          [DeclareOpInterfaceMethods<WaveMachine_AddressFieldsOpInterface>])> {
  let extraClassDefinition = [{
    ::mlir::wavemachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/13, /*instOffsetSigned=*/true,
              /*hasSoffset=*/false};
    }
  }];
}

class WaveMachine_BufferMemoryOp<string mnemonic, list<Trait> traits = []>
    : WaveMachine_Op<mnemonic,
        !listconcat(traits,
          [DeclareOpInterfaceMethods<WaveMachine_AddressFieldsOpInterface>])> {
  let extraClassDefinition = [{
    ::mlir::wavemachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/12, /*instOffsetSigned=*/false,
              /*hasSoffset=*/true};
    }
  }];
}

class WaveMachine_DsMemoryOp<string mnemonic, list<Trait> traits = []>
    : WaveMachine_Op<mnemonic,
        !listconcat(traits,
          [DeclareOpInterfaceMethods<WaveMachine_AddressFieldsOpInterface>])> {
  let extraClassDefinition = [{
    ::mlir::wavemachine::AddressFieldSpec $cppClass::getAddressFieldSpec() {
      return {/*instOffsetBits=*/16, /*instOffsetSigned=*/false,
              /*hasSoffset=*/false};
    }
  }];
}

class WaveMachine_ZeroOperandResult<string mnemonic, Type resultType,
                                    list<Trait> traits = []>
    : WaveMachine_Op<mnemonic, traits> {
  let results = (outs resultType:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

class WaveMachine_UnaryResult<string mnemonic, Type operandType, Type resultType,
                              list<Trait> traits = []>
    : WaveMachine_Op<mnemonic, traits> {
  let arguments = (ins operandType:$source);
  let results = (outs resultType:$result);
  let assemblyFormat = "$source attr-dict `:` functional-type(operands, results)";
}

class WaveMachine_BinaryResult<string mnemonic, Type operandType, Type resultType,
                               list<Trait> traits = []>
    : WaveMachine_Op<mnemonic, traits> {
  let arguments = (ins operandType:$lhs, operandType:$rhs);
  let results = (outs resultType:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

class WaveMachine_TernaryResult<string mnemonic, Type operandType, Type resultType,
                                list<Trait> traits = []>
    : WaveMachine_Op<mnemonic, traits> {
  let arguments = (ins operandType:$a, operandType:$b, operandType:$c);
  let results = (outs resultType:$result);
  let assemblyFormat = "$a `,` $b `,` $c attr-dict `:` functional-type(operands, results)";
}

class WaveMachine_UnaryNoResult<string mnemonic, Type operandType,
                                list<Trait> traits = []>
    : WaveMachine_Op<mnemonic, traits> {
  let arguments = (ins operandType:$source);
  let assemblyFormat = "$source attr-dict `:` functional-type(operands, results)";
}

class WaveMachine_BinaryNoResult<string mnemonic, Type operandType,
                                 list<Trait> traits = []>
    : WaveMachine_Op<mnemonic, traits> {
  let arguments = (ins operandType:$lhs, operandType:$rhs);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_ArgOp : WaveMachine_Op<"arg"> {
  let summary = "selected function argument";
  let arguments = (ins I64Attr:$index, BoolAttr:$pointer);
  let results = (outs WaveMachine_Reg:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

def WaveMachine_ImmOp : WaveMachine_Op<"imm", [Pure]> {
  let summary = "machine immediate";
  let arguments = (ins I64Attr:$value);
  let results = (outs WaveMachine_Imm:$result);
  let assemblyFormat = "$value attr-dict `:` type($result)";
}

def WaveMachine_TokenOp : WaveMachine_Op<"token", [
  Pure,
  WaveMachine_TokenTrait
]> {
  let summary = "empty machine memory token";
  let results = (outs WaveMachine_MemToken:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

def WaveMachine_TokenJoinOp : WaveMachine_Op<"token_join",
    [Pure, WaveMachine_TokenJoinTrait]> {
  let summary = "join machine memory tokens";
  let arguments = (ins Variadic<WaveMachine_MemToken>:$dependencies);
  let results = (outs WaveMachine_MemToken:$result);
  let assemblyFormat = "$dependencies attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_AfterOp : WaveMachine_Op<"after",
    [Pure, WaveMachine_TokenJoinTrait]> {
  let summary = "derive a machine memory token after dependencies";
  let arguments = (ins Variadic<WaveMachine_MemToken>:$dependencies);
  let results = (outs WaveMachine_MemToken:$result);
  let assemblyFormat = "$dependencies attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_WaitOp : WaveMachine_Op<"wait"> {
  let summary = "wait for machine memory token dependencies";
  let arguments = (ins Variadic<WaveMachine_MemToken>:$dependencies);
  let assemblyFormat = "$dependencies attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_LabelOp : WaveMachine_Op<"label"> {
  let summary = "assembly label";
  let arguments = (ins StrAttr:$name);
  let assemblyFormat = "$name attr-dict";
}

def WaveMachine_VMbcntLoOp
    : WaveMachine_ZeroOperandResult<"v_mbcnt_lo", WaveMachine_VGPR1,
                                    [WaveMachine_VALU]>;

// Preloaded workgroup ids live in fixed SGPRs (s2..s4 on RDNA3 when the
// kernel descriptor requests them). The selector materializes these ops
// with their result RegType pinned to the right physical index; the asm
// printer emits nothing because the value is already in the register on
// kernel entry.
def WaveMachine_SWorkgroupIdXOp
    : WaveMachine_ZeroOperandResult<"s_workgroup_id_x", WaveMachine_SGPR1, []>;
def WaveMachine_SWorkgroupIdYOp
    : WaveMachine_ZeroOperandResult<"s_workgroup_id_y", WaveMachine_SGPR1, []>;
def WaveMachine_SWorkgroupIdZOp
    : WaveMachine_ZeroOperandResult<"s_workgroup_id_z", WaveMachine_SGPR1, []>;

// Preloaded workitem id (packed) lives in `v0`. Only the X half is
// exposed today; Y/Z would need additional descriptor flags.
def WaveMachine_VWorkitemIdXOp
    : WaveMachine_ZeroOperandResult<"v_workitem_id_x", WaveMachine_VGPR1, []>;

def WaveMachine_VMovB32TupleOp
    : WaveMachine_UnaryResult<"v_mov_b32_tuple", WaveMachine_RegOrImm,
                              WaveMachine_VGPR, [WaveMachine_VALU]> {
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
def WaveMachine_TupleToElementsOp
    : WaveMachine_Op<"tuple_to_elements", [Pure, WaveMachine_TokenJoinTrait]> {
  let summary = "split a GPR tuple into mixed-width GPR pieces";
  let arguments = (ins WaveMachine_GPR:$tuple);
  let results = (outs Variadic<WaveMachine_GPR>:$elements);
  let assemblyFormat =
      "$tuple attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def WaveMachine_TupleFromElementsOp
    : WaveMachine_Op<"tuple_from_elements",
                     [Pure, WaveMachine_TokenJoinTrait]> {
  let summary = "concatenate mixed-width GPR pieces into a GPR tuple";
  let arguments = (ins Variadic<WaveMachine_GPR>:$elements);
  let results = (outs WaveMachine_GPR:$tuple);
  let assemblyFormat =
      "$elements attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}
def WaveMachine_VAddU32Op
    : WaveMachine_BinaryResult<"v_add_u32", WaveMachine_RegOrImm,
                               WaveMachine_VGPR1, [WaveMachine_VALU]>;
def WaveMachine_VAndB32Op
    : WaveMachine_BinaryResult<"v_and_b32", WaveMachine_RegOrImm,
                               WaveMachine_VGPR1, [WaveMachine_VALU]>;
def WaveMachine_VOrB32Op
    : WaveMachine_BinaryResult<"v_or_b32", WaveMachine_RegOrImm,
                               WaveMachine_VGPR1, [WaveMachine_VALU]>;
def WaveMachine_VXorB32Op
    : WaveMachine_BinaryResult<"v_xor_b32", WaveMachine_RegOrImm,
                               WaveMachine_VGPR1, [WaveMachine_VALU]>;
def WaveMachine_VLshlrevB32Op
    : WaveMachine_BinaryResult<"v_lshlrev_b32", WaveMachine_RegOrImm,
                               WaveMachine_VGPR1, [WaveMachine_VALU]>;
def WaveMachine_VLshrrevB32Op
    : WaveMachine_BinaryResult<"v_lshrrev_b32", WaveMachine_RegOrImm,
                               WaveMachine_VGPR1, [WaveMachine_VALU]>;
def WaveMachine_VMulLoU32Op
    : WaveMachine_BinaryResult<"v_mul_lo_u32", WaveMachine_RegOrImm,
                               WaveMachine_VGPR1, [WaveMachine_VALU]>;
def WaveMachine_VCmpEqU32Op
    : WaveMachine_BinaryResult<"v_cmp_eq_u32", WaveMachine_RegOrImm,
                               WaveMachine_SGPR1, [WaveMachine_VALU]>;
def WaveMachine_VCmpNeU32Op
    : WaveMachine_BinaryResult<"v_cmp_ne_u32", WaveMachine_RegOrImm,
                               WaveMachine_SGPR1, [WaveMachine_VALU]>;
def WaveMachine_VCmpLtU32Op
    : WaveMachine_BinaryResult<"v_cmp_lt_u32", WaveMachine_RegOrImm,
                               WaveMachine_SGPR1, [WaveMachine_VALU]>;
def WaveMachine_VCmpLeU32Op
    : WaveMachine_BinaryResult<"v_cmp_le_u32", WaveMachine_RegOrImm,
                               WaveMachine_SGPR1, [WaveMachine_VALU]>;
def WaveMachine_VCmpGtU32Op
    : WaveMachine_BinaryResult<"v_cmp_gt_u32", WaveMachine_RegOrImm,
                               WaveMachine_SGPR1, [WaveMachine_VALU]>;
def WaveMachine_VCmpGeU32Op
    : WaveMachine_BinaryResult<"v_cmp_ge_u32", WaveMachine_RegOrImm,
                               WaveMachine_SGPR1, [WaveMachine_VALU]>;
def WaveMachine_VReadfirstlaneB32Op
    : WaveMachine_UnaryResult<"v_readfirstlane_b32", WaveMachine_VGPR1,
                              WaveMachine_SGPR1, [WaveMachine_VALU]>;

def WaveMachine_WmmaI32_16x16x16_IU8Op
    : WaveMachine_TernaryResult<"wmma_i32_16x16x16_iu8", WaveMachine_VGPR,
                                WaveMachine_VGPR, [WaveMachine_VALU]> {
  let hasVerifier = 1;
}
def WaveMachine_WmmaF32_16x16x16_F16Op
    : WaveMachine_TernaryResult<"wmma_f32_16x16x16_f16", WaveMachine_VGPR,
                                WaveMachine_VGPR, [WaveMachine_VALU]> {
  let hasVerifier = 1;
}
def WaveMachine_MfmaF32_16x16x16_F16Op
    : WaveMachine_TernaryResult<"mfma_f32_16x16x16_f16", WaveMachine_VGPR,
                                WaveMachine_VGPR, [WaveMachine_VALU]> {
  let hasVerifier = 1;
}
def WaveMachine_MfmaF32_16x16x32_F16Op
    : WaveMachine_TernaryResult<"mfma_f32_16x16x32_f16", WaveMachine_VGPR,
                                WaveMachine_VGPR, [WaveMachine_VALU]> {
  let hasVerifier = 1;
}

def WaveMachine_SMovB32Op : WaveMachine_UnaryNoResult<"s_mov_b32",
                                                       WaveMachine_RegOrImm> {
  let arguments = (ins StrAttr:$dst, WaveMachine_RegOrImm:$source);
  let assemblyFormat = "$dst `,` $source attr-dict `:` functional-type(operands, results)";
}

// Value-producing scalar move: materialises an SGPR1 holding the
// given Imm or copies an existing SGPR1/RegOrImm into a fresh
// allocator-assigned SGPR. Used by the selector to lift loop-IV
// initialisers out of `wavemachine.imm` into a real carry register.
def WaveMachine_SMovB32ValueOp : WaveMachine_Op<"s_mov_b32_value", [Pure]> {
  let summary = "scalar 32-bit move producing an SGPR value";
  let arguments = (ins WaveMachine_RegOrImm:$source);
  let results = (outs WaveMachine_SGPR1:$result);
  let assemblyFormat = "$source attr-dict `:` functional-type(operands, results)";
}

// Wide-SGPR rename / broadcast, mirroring `v_mov_b32_tuple`. Emits
// N `s_mov_b32` instructions; source may be another same-width
// SGPR tuple (per-component copy) or a scalar value (broadcast).
def WaveMachine_SMovB32TupleOp
    : WaveMachine_UnaryResult<"s_mov_b32_tuple", WaveMachine_RegOrImm,
                              WaveMachine_SGPR, []> {
  let hasVerifier = 1;
}
def WaveMachine_SLoadB32Op : WaveMachine_UnaryResult<"s_load_b32",
                                                      WaveMachine_Imm,
                                                      WaveMachine_SGPR1,
                                                      [WaveMachine_SMEMLoad]> {
  let arguments = (ins WaveMachine_Imm:$offset, StrAttr:$base);
  let assemblyFormat = "$offset `,` $base attr-dict `:` functional-type(operands, results)";
}
def WaveMachine_SLoadB64Op : WaveMachine_UnaryResult<"s_load_b64",
                                                      WaveMachine_Imm,
                                                      WaveMachine_SGPR2,
                                                      [WaveMachine_SMEMLoad]> {
  let arguments = (ins WaveMachine_Imm:$offset, StrAttr:$base);
  let assemblyFormat = "$offset `,` $base attr-dict `:` functional-type(operands, results)";
}
def WaveMachine_SLoadB128Op : WaveMachine_UnaryResult<"s_load_b128",
                                                       WaveMachine_Imm,
                                                       WaveMachine_SGPR4,
                                                       [WaveMachine_SMEMLoad]> {
  let arguments = (ins WaveMachine_Imm:$offset, StrAttr:$base);
  let assemblyFormat = "$offset `,` $base attr-dict `:` functional-type(operands, results)";
}
def WaveMachine_SWaitcntOp : WaveMachine_UnaryNoResult<"s_waitcnt",
                                                        WaveMachine_Imm,
                                                        [WaveMachine_Waitcnt]>;
def WaveMachine_SWaitcntVscntOp : WaveMachine_UnaryNoResult<"s_waitcnt_vscnt",
                                                             WaveMachine_Imm,
                                                             [WaveMachine_Waitcnt]>;
def WaveMachine_SNopOp : WaveMachine_UnaryNoResult<"s_nop", WaveMachine_Imm>;
def WaveMachine_SDelayAluOp : WaveMachine_UnaryNoResult<"s_delay_alu",
                                                         WaveMachine_Imm>;
def WaveMachine_SAndSaveexecB32Op
    : WaveMachine_UnaryResult<"s_and_saveexec_b32", WaveMachine_SGPR1,
                              WaveMachine_SGPR1>;
def WaveMachine_SAndn2ExecB32Op
    : WaveMachine_BinaryNoResult<"s_andn2_exec_b32", WaveMachine_SGPR1>;
def WaveMachine_SCBranchExeczOp : WaveMachine_ZeroResult<"s_cbranch_execz"> {
  let arguments = (ins StrAttr:$label);
  let assemblyFormat = "$label attr-dict";
}
def WaveMachine_SMovExecLoOp : WaveMachine_UnaryNoResult<"s_mov_exec_lo",
                                                          WaveMachine_SGPR1>;
def WaveMachine_SMovM0Op
    : WaveMachine_UnaryResult<"s_mov_m0", WaveMachine_SGPR1, WaveMachine_M0>;
def WaveMachine_SEndpgmOp : WaveMachine_ZeroResult<"s_endpgm">;
def WaveMachine_SSetpcB64Op : WaveMachine_ZeroResult<"s_setpc_b64">;

def WaveMachine_GlobalLoadB32Op
    : WaveMachine_GlobalMemoryOp<"global_load_b32", [WaveMachine_VMEMLoad]> {
  let summary = "global 32-bit load through an SGPR base";
  let description = [{
    Reads one 32-bit value from `base + offset + inst_offset` into the
    result VGPR. `inst_offset` is folded into the instruction's
    13-bit signed immediate slot; it defaults to 0. gfx11 GLOBAL has
    no separate `soffset` slot -- any wave-uniform contribution must
    be folded into `offset` by the producer.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_SGPR2:$base,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveMachine_VGPR1:$result,
                      Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}

def WaveMachine_GlobalLoadTupleB32Op
    : WaveMachine_GlobalMemoryOp<"global_load_tuple_b32", [WaveMachine_VMEMLoad]> {
  let summary = "global load of N consecutive 32-bit values into a VGPR tuple";
  let description = [{
    Loads `N` consecutive dwords from `base + offset + inst_offset +
    i*4` into the `N` components of a single VGPR tuple result of
    width `N`. Expands to `N` `global_load_dword` instructions in the
    AMDGPU printer; the tuple width is therefore the result register
    width.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_SGPR2:$base,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveMachine_VGPR:$result,
                      Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $offset `,` $base (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}

def WaveMachine_GlobalLoadLdsB32Op
    : WaveMachine_GlobalMemoryOp<"global_load_lds_b32", [WaveMachine_VMEMLoad]> {
  let summary = "global-to-LDS 32-bit DMA load";
  let description = [{
    Reads one dword from global memory and writes it to LDS. `m0` carries the
    scalar LDS base; hardware adds 4*lane_id for this dword form. The op
    consumes an input memory token for global memory ordering and returns a
    token representing the global read plus LDS write.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_SGPR2:$base,
                       WaveMachine_M0:$m0, WaveMachine_MemToken:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset,
                       DefaultValuedAttr<I64Attr, "0">:$aux);
  let results = (outs WaveMachine_MemToken:$token);
  let assemblyFormat = [{
    $offset `,` $base `,` $m0 `after` $dependency
    (`offset` $inst_offset^)? (`aux` $aux^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveMachine_GlobalLoadLdsB128Op
    : WaveMachine_GlobalMemoryOp<"global_load_lds_b128", [WaveMachine_VMEMLoad]> {
  let summary = "global-to-LDS 128-bit DMA load";
  let description = [{
    Reads 16 bytes from global memory and writes them to LDS. `m0` carries the
    scalar LDS base; hardware adds 16*lane_id for this form.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_SGPR2:$base,
                       WaveMachine_M0:$m0, WaveMachine_MemToken:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset,
                       DefaultValuedAttr<I64Attr, "0">:$aux);
  let results = (outs WaveMachine_MemToken:$token);
  let assemblyFormat = [{
    $offset `,` $base `,` $m0 `after` $dependency
    (`offset` $inst_offset^)? (`aux` $aux^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveMachine_MakeBufferRsrcOp
    : WaveMachine_Op<"make_buffer_rsrc", [Pure]> {
  let summary = "construct an AMD buffer descriptor";
  let arguments = (ins WaveMachine_SGPR2:$base,
                       WaveMachine_RegOrImm:$range);
  let results = (outs WaveMachine_SGPR4:$descriptor);
  let assemblyFormat = "$base `,` $range attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_GlobalStoreB32Op
    : WaveMachine_GlobalMemoryOp<"global_store_b32", [WaveMachine_VMEMStore]> {
  let summary = "global 32-bit store through an SGPR base";
  let description = [{
    Stores `value` to `base + offset + inst_offset`. `inst_offset` is
    folded into the instruction's 13-bit signed immediate slot;
    defaults to 0.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_RegOrImm:$value,
                       WaveMachine_SGPR2:$base,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}
def WaveMachine_BufferStoreB32Op
    : WaveMachine_BufferMemoryOp<"buffer_store_b32", [WaveMachine_VMEMStore]> {
  let summary = "buffer 32-bit store through an SGPR descriptor and VGPR offset";
  let description = [{
    MUBUF OFFEN: stores `value` to `descriptor[offset + soffset +
    inst_offset]`. `soffset` is the wave-uniform contribution (SGPR
    or immediate); callers pass `wavemachine.imm 0` when there is no
    S bucket. `inst_offset` folds into the instruction's 12-bit
    signed immediate field and defaults to 0.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_VGPR1:$value,
                       WaveMachine_SGPR4:$descriptor,
                       WaveMachine_SGPR1OrImm:$soffset,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}
def WaveMachine_BufferLoadB32Op
    : WaveMachine_BufferMemoryOp<"buffer_load_b32", [WaveMachine_VMEMLoad]> {
  let summary = "buffer 32-bit load through an SGPR descriptor and VGPR offset";
  let description = [{
    MUBUF OFFEN: loads a 32-bit value from `descriptor[offset +
    soffset + inst_offset]` into the result VGPR. Callers pass
    `wavemachine.imm 0` for soffset when there is no S bucket.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_SGPR4:$descriptor,
                       WaveMachine_SGPR1OrImm:$soffset,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveMachine_VGPR1:$result,
                      Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}
def WaveMachine_BufferLoadTupleB32Op
    : WaveMachine_BufferMemoryOp<"buffer_load_tuple_b32", [WaveMachine_VMEMLoad]> {
  let summary = "buffer load of N consecutive 32-bit values into a VGPR tuple";
  let description = [{
    Loads `N` consecutive dwords from `descriptor[offset + soffset +
    inst_offset + i*4]` into the `N` components of a single VGPR
    tuple result of width `N`. Expands to `N` `buffer_load_dword`
    instructions (each with a `offset:(inst_offset + i*4)`
    immediate) in the AMDGPU printer; the tuple width is the result
    register width.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_SGPR4:$descriptor,
                       WaveMachine_SGPR1OrImm:$soffset,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs WaveMachine_VGPR:$result,
                      Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}

def WaveMachine_BufferLoadLdsB32Op
    : WaveMachine_BufferMemoryOp<"buffer_load_lds_b32", [WaveMachine_VMEMLoad]> {
  let summary = "buffer-to-LDS 32-bit DMA load";
  let description = [{
    Reads one dword through a buffer descriptor and writes it to LDS. `m0`
    carries the scalar LDS base; hardware adds 4*lane_id for this dword form.
    The op consumes an input memory token for buffer/global ordering and
    returns a token representing the memory read plus LDS write.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_SGPR4:$descriptor,
                       WaveMachine_SGPR1OrImm:$soffset, WaveMachine_M0:$m0,
                       WaveMachine_MemToken:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset,
                       DefaultValuedAttr<I64Attr, "0">:$aux);
  let results = (outs WaveMachine_MemToken:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset `,` $m0 `after` $dependency
    (`offset` $inst_offset^)? (`aux` $aux^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveMachine_BufferLoadLdsB128Op
    : WaveMachine_BufferMemoryOp<"buffer_load_lds_b128", [WaveMachine_VMEMLoad]> {
  let summary = "buffer-to-LDS 128-bit DMA load";
  let description = [{
    Reads 16 bytes through a buffer descriptor and writes them to LDS. `m0`
    carries the scalar LDS base; hardware adds 16*lane_id for this form.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_SGPR4:$descriptor,
                       WaveMachine_SGPR1OrImm:$soffset, WaveMachine_M0:$m0,
                       WaveMachine_MemToken:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset,
                       DefaultValuedAttr<I64Attr, "0">:$aux);
  let results = (outs WaveMachine_MemToken:$token);
  let assemblyFormat = [{
    $offset `,` $descriptor `,` $soffset `,` $m0 `after` $dependency
    (`offset` $inst_offset^)? (`aux` $aux^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveMachine_BufferStoreTupleB32Op
    : WaveMachine_BufferMemoryOp<"buffer_store_tuple_b32", [WaveMachine_VMEMStore]> {
  let summary = "buffer 32-bit store of a VGPR tuple component";
  let description = [{
    Stores the `component`-th 32-bit slice of the `value` VGPR tuple to
    the buffer described by `descriptor` at the lane VGPR offset plus
    `soffset + inst_offset + component * 4`. Mirrors
    `global_store_tuple_b32`: each dword-store is its own IR op so
    per-component memory tokens thread through the bucketed
    `wave.store` tuple selector in `selectGlobalOrBufferStore`.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_VGPR:$value,
                       WaveMachine_SGPR4:$descriptor,
                       WaveMachine_SGPR1OrImm:$soffset,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $offset `,` $value `,` $descriptor `,` $soffset
    (`after` $dependency^)? (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}
def WaveMachine_GlobalStoreTupleB32Op
    : WaveMachine_GlobalMemoryOp<"global_store_tuple_b32", [WaveMachine_VMEMStore]> {
  let summary = "global 32-bit store of a VGPR tuple component";
  let description = [{
    Per-component dword store: writes lane `component` of the `value`
    VGPR tuple to `base + offset + inst_offset + component * 4`.
    `inst_offset` lands in the instruction's 13-bit signed immediate
    slot together with `component * 4`.
  }];
  let arguments = (ins WaveMachine_VGPR1:$offset, WaveMachine_VGPR:$value,
                       WaveMachine_SGPR2:$base,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$inst_offset);
  let results = (outs Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $offset `,` $value `,` $base (`after` $dependency^)?
    (`offset` $inst_offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}

// LDS ("group_segment_fixed_size") loads and stores share the same
// per-workgroup arena: the address operand is a 32-bit byte offset into
// LDS and an optional immediate `offset:imm` is folded into the
// hardware instruction. Both kinds drain through `lgkmcnt`; we model
// that by tagging them with the SMEM-load trait, which the waitcnt pass
// already routes to the LGKM counter.
def WaveMachine_DsLoadB32Op
    : WaveMachine_DsMemoryOp<"ds_load_b32", [WaveMachine_SMEMLoad]> {
  let summary = "LDS 32-bit load";
  let arguments = (ins WaveMachine_VGPR1:$addr,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveMachine_VGPR1:$result,
                      Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveMachine_DsLoadTupleB32Op
    : WaveMachine_DsMemoryOp<"ds_load_tuple_b32", [WaveMachine_SMEMLoad]> {
  let summary = "LDS load of N consecutive 32-bit values into a VGPR tuple";
  let description = [{
    Loads `N` consecutive dwords from LDS at `addr + offset + i*4` for
    `i` in `[0, N)` into the `N` components of a single VGPR tuple
    result of width `N`. Expands to `N` `ds_read_b32` instructions in
    the AMDGPU printer; the tuple width is the result register width.
  }];
  let arguments = (ins WaveMachine_VGPR1:$addr,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs WaveMachine_VGPR:$result,
                      Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $addr (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}

def WaveMachine_DsStoreB32Op
    : WaveMachine_DsMemoryOp<"ds_store_b32", [WaveMachine_SMEMLoad]> {
  let summary = "LDS 32-bit store";
  let arguments = (ins WaveMachine_VGPR1:$addr, WaveMachine_VGPR1:$value,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
}

def WaveMachine_DsStoreTupleB32Op
    : WaveMachine_DsMemoryOp<"ds_store_tuple_b32", [WaveMachine_SMEMLoad]> {
  let summary = "LDS store of a VGPR tuple as N consecutive 32-bit values";
  let description = [{
    Stores the `N` components of the `value` VGPR tuple to LDS at
    `addr + offset + i*4` for `i` in `[0, N)`. Expands to `N`
    `ds_write_b32` instructions in the AMDGPU printer; the tuple
    width is the value register width.
  }];
  let arguments = (ins WaveMachine_VGPR1:$addr, WaveMachine_VGPR:$value,
                       Optional<WaveMachine_MemToken>:$dependency,
                       DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = [{
    $addr `,` $value (`after` $dependency^)? (`offset` $offset^)?
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}

def WaveMachine_SBarrierOp : WaveMachine_Op<"s_barrier"> {
  let summary = "workgroup-wide barrier";
  let description = [{
    Synchronizes all waves of the workgroup. Surrounding waitcnts must
    be inserted by `wave-amd-insert-ticket-waits` based on the
    dependencies passed through the higher-level `wave.barrier`.
  }];

  let arguments = (ins Variadic<WaveMachine_MemToken>:$dependencies);
  let results = (outs Variadic<WaveMachine_MemToken>:$tokens);
  let assemblyFormat = "$dependencies attr-dict `:` functional-type(operands, results)";
}

//===----------------------------------------------------------------------===//
// Scalar ALU + branches (used by structured uniform loops)
//===----------------------------------------------------------------------===//

// Wave-uniform scalar add. Produces both an SGPR sum and an SCC
// carry-out so that any IR consumer of SCC (e.g. an immediately
// following s_cmp / continue_if) cannot accidentally be reordered
// across this op without the dependence being visible.
def WaveMachine_SAddI32Op : WaveMachine_Op<"s_add_i32", [Pure]> {
  let summary = "scalar 32-bit add (sets SCC)";
  let arguments = (ins WaveMachine_SGPR1:$lhs, WaveMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveMachine_SGPR1:$result, WaveMachine_SCC:$scc);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// Signed scalar 32-bit multiply. AMDGPU `s_mul_i32` does not set SCC, so
// there's no carry-out result to model; callers that need the high half
// or unsigned behaviour will get separate ops later.
def WaveMachine_SMulI32Op : WaveMachine_Op<"s_mul_i32", [Pure]> {
  let summary = "scalar 32-bit signed multiply (low half)";
  let arguments = (ins WaveMachine_SGPR1OrImm:$lhs,
                       WaveMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveMachine_SGPR1:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// Scalar 32-bit logical left shift. `s_lshl_b32` does set SCC, but the
// offset-math path that uses this op throws the SCC away; model it as
// SCC-clobbering rather than SCC-producing so consumers can't reach for
// it accidentally.
def WaveMachine_SLshlB32Op : WaveMachine_Op<"s_lshl_b32", [Pure]> {
  let summary = "scalar 32-bit logical left shift";
  let arguments = (ins WaveMachine_SGPR1OrImm:$lhs,
                       WaveMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveMachine_SGPR1:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_SLshrB32Op : WaveMachine_Op<"s_lshr_b32", [Pure]> {
  let summary = "scalar 32-bit logical right shift";
  let arguments = (ins WaveMachine_SGPR1OrImm:$lhs,
                       WaveMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveMachine_SGPR1:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_SAndB32Op : WaveMachine_Op<"s_and_b32", [Pure]> {
  let summary = "scalar 32-bit bitwise AND";
  let arguments = (ins WaveMachine_SGPR1OrImm:$lhs,
                       WaveMachine_SGPR1OrImm:$rhs);
  let results = (outs WaveMachine_SGPR1:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// 64-bit scalar add. The asm printer expands this into the carry-chain
// pair `s_add_u32` (low) + `s_addc_u32` (high). The intermediate SCC is
// consumed by the second instruction and discarded after.
def WaveMachine_SAddU64Op : WaveMachine_Op<"s_add_u64", [Pure]> {
  let summary = "scalar 64-bit unsigned add";
  let arguments = (ins WaveMachine_SGPR2:$lhs, WaveMachine_SGPR2:$rhs);
  let results = (outs WaveMachine_SGPR2:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// 64-bit vector add. Expanded to `v_add_co_u32` (low) +
// `v_addc_co_u32` (high) with the carry threaded through `vcc_lo` on
// wave32. Documented constraint: vcc_lo must not be live across the
// pair -- our offset-math path doesn't touch it, so we leave that to
// the producer to enforce.
def WaveMachine_VAddU64Op : WaveMachine_Op<"v_add_u64", [Pure]> {
  let summary = "vector 64-bit unsigned add";
  let arguments = (ins WaveMachine_VGPR2:$lhs, WaveMachine_VGPR2:$rhs);
  let results = (outs WaveMachine_VGPR2:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// 64-bit unsigned multiply (low half). gfx11 has no native u64 mul, so
// the asm printer expands this into the four-mul-plus-two-add canonical
// sequence using the `$scratch` SGPR for the cross-product temporaries
// (a_lo*b_hi and a_hi*b_lo). `$scratch` is a real allocated register
// that's dead after the op; the regalloc just sees one extra short-
// lived live range per op.
def WaveMachine_SMulU64Op : WaveMachine_Op<"s_mul_u64", [Pure]> {
  let summary = "scalar 64-bit unsigned multiply (low half)";
  let arguments = (ins WaveMachine_SGPR2:$lhs, WaveMachine_SGPR2:$rhs);
  let results = (outs WaveMachine_SGPR2:$result, WaveMachine_SGPR1:$scratch);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_VMulU64Op : WaveMachine_Op<"v_mul_u64", [Pure]> {
  let summary = "vector 64-bit unsigned multiply (low half)";
  let arguments = (ins WaveMachine_VGPR2:$lhs, WaveMachine_VGPR2:$rhs);
  let results = (outs WaveMachine_VGPR2:$result, WaveMachine_VGPR1:$scratch);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

// 64-bit logical left shift. Single-instruction on gfx11 in both the
// scalar and vector worlds. The shift operand is i64 to match
// `wave.shli`'s "operands have the same type" rule -- the printer
// extracts the low 32 bits since that's what the hardware reads.
def WaveMachine_SLshlB64Op : WaveMachine_Op<"s_lshl_b64", [Pure]> {
  let summary = "scalar 64-bit logical left shift";
  let arguments = (ins WaveMachine_SGPR2:$lhs, WaveMachine_SGPR2:$shift);
  let results = (outs WaveMachine_SGPR2:$result);
  let assemblyFormat = "$lhs `,` $shift attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_VLshlrevB64Op : WaveMachine_Op<"v_lshlrev_b64", [Pure]> {
  let summary = "vector 64-bit logical left shift";
  let arguments = (ins WaveMachine_VGPR2:$shift,
                       WaveMachine_VGPR2:$value);
  let results = (outs WaveMachine_VGPR2:$result);
  let assemblyFormat = "$shift `,` $value attr-dict `:` functional-type(operands, results)";
}

// Materializes a 64-bit immediate as a 2-wide SGPR via two
// `s_mov_b32` instructions for the low and high halves. Used by the
// selector to lift `arith.constant : i64` into the 2-wide register
// world the i64 ops consume.
def WaveMachine_SMovB64ImmOp : WaveMachine_Op<"s_mov_b64_imm", [Pure]> {
  let summary = "materialize a 64-bit immediate into an SGPR pair";
  let arguments = (ins I64Attr:$value);
  let results = (outs WaveMachine_SGPR2:$result);
  let assemblyFormat = "$value attr-dict `:` type($result)";
}

def WaveMachine_SCmpLtI32Op : WaveMachine_Op<"s_cmp_lt_i32", [Pure]> {
  let summary = "scalar signed less-than compare (sets SCC)";
  let arguments = (ins
    WaveMachine_SGPR1OrImm:$lhs,
    WaveMachine_SGPR1OrImm:$rhs
  );
  let results = (outs WaveMachine_SCC:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_SCmpLgU32Op : WaveMachine_Op<"s_cmp_lg_u32", [Pure]> {
  let summary = "scalar unsigned not-equal compare (sets SCC)";
  let arguments = (ins
    WaveMachine_SGPR1OrImm:$lhs,
    WaveMachine_SGPR1OrImm:$rhs
  );
  let results = (outs WaveMachine_SCC:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` functional-type(operands, results)";
}

def WaveMachine_SCBranchScc0Op : WaveMachine_Op<"s_cbranch_scc0"> {
  let summary = "branch if SCC is zero";
  let arguments = (ins WaveMachine_SCC:$cond, StrAttr:$label);
  let assemblyFormat = "$cond `:` type($cond) `,` $label attr-dict";
}

def WaveMachine_SCBranchScc1Op : WaveMachine_Op<"s_cbranch_scc1"> {
  let summary = "branch if SCC is one";
  let arguments = (ins WaveMachine_SCC:$cond, StrAttr:$label);
  let assemblyFormat = "$cond `:` type($cond) `,` $label attr-dict";
}

//===----------------------------------------------------------------------===//
// Structured uniform loop
//===----------------------------------------------------------------------===//

def WaveMachine_UniformLoopOp : WaveMachine_Op<"uniform_loop", [
  AttrSizedOperandSegments,
  SingleBlock,
  DeclareOpInterfaceMethods<RegionBranchOpInterface,
    ["getEntrySuccessorOperands", "getSuccessorInputs"]>,
  RecursiveMemoryEffects
]> {
  let summary = "structured wave-uniform loop with explicit IV bookkeeping";
  let description = [{
    Wave-uniform structured loop with one body region whose block
    arguments shadow `$inits`. The terminator `wavemachine.continue_if`
    branches either back to the body (continue) or out of the op
    (results = continue_if.carries).

    When `$entry_cond` is present, the loop is pre-tested: if the SCC
    becomes false on entry, the body is skipped entirely and the
    results take the `$inits` values. When absent, the loop is
    post-tested (do/while) and the body always runs at least once.

    All IV arithmetic / comparisons are materialised as explicit
    `wavemachine.s_add_i32` / `s_cmp_*` ops in the body; this op only
    establishes the region boundary and the back-edge that the waitcnt
    pass needs to see via `RegionBranchOpInterface`.
  }];

  let arguments = (ins Optional<WaveMachine_SCC>:$entry_cond,
                       Variadic<WaveMachine_Reg>:$inits);
  let results = (outs Variadic<WaveMachine_Reg>:$results);
  let regions = (region SizedRegion<1>:$body);

  let assemblyFormat = [{
    (`if` $entry_cond^ `:` type($entry_cond))?
    (`carries` `(` $inits^ `:` type($inits) `)`)?
    $body
    attr-dict (`->` type($results)^)?
  }];

  let hasVerifier = 1;
}

def WaveMachine_ContinueIfOp : WaveMachine_Op<"continue_if", [
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

  let arguments = (ins WaveMachine_SCC:$cond,
                       Variadic<WaveMachine_Reg>:$carries);

  let assemblyFormat = [{
    $cond `:` type($cond)
    (`carries` `(` $carries^ `:` type($carries) `)`)?
    attr-dict
  }];

  let hasVerifier = 1;
}

#endif // MLIR_DIALECT_WAVEMACHINE_IR_WAVEMACHINEOPS_TD
