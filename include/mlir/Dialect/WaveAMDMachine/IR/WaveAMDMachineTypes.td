//===-- WaveAMDMachineTypes.td - WaveAMDMachine dialect types -----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETYPES_TD
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETYPES_TD

include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"

class WaveAMDMachine_Type<string name, string typeMnemonic,
                       list<Trait> traits = [],
                       string baseCppClass = "::mlir::Type">
    : TypeDef<WaveAMDMachine_Dialect, name, traits, baseCppClass> {
  let mnemonic = typeMnemonic;
}

def WaveAMDMachine_RegClassSGPR : I32EnumAttrCase<"SGPR", 0, "sgpr">;
def WaveAMDMachine_RegClassVGPR : I32EnumAttrCase<"VGPR", 1, "vgpr">;
def WaveAMDMachine_RegClassAGPR : I32EnumAttrCase<"AGPR", 2, "agpr">;
def WaveAMDMachine_RegClassSCC : I32EnumAttrCase<"SCC", 3, "scc">;
def WaveAMDMachine_RegClassVCC : I32EnumAttrCase<"VCC", 4, "vcc">;

def WaveAMDMachine_RegClassEnum : I32EnumAttr<"RegClass",
    "WaveAMDMachine register class",
    [WaveAMDMachine_RegClassSGPR, WaveAMDMachine_RegClassVGPR,
     WaveAMDMachine_RegClassAGPR, WaveAMDMachine_RegClassSCC,
     WaveAMDMachine_RegClassVCC]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def WaveAMDMachine_RegType : WaveAMDMachine_Type<"Reg", "reg"> {
  let summary = "machine register value";
  let description = [{
    A `!waveamdmachine.reg<class, width[, index]>` value represents a selected
    virtual or physical AMDGPU register. The `class` parameter is an enum
    (`sgpr`, `vgpr`, `agpr`, `scc`, or `vcc`), `width` is the number of
    consecutive 32-bit registers, and optional `index` is the assigned
    physical register base.
  }];

  let parameters = (ins EnumParameter<WaveAMDMachine_RegClassEnum>:$regClass,
                        "int64_t":$width,
                        DefaultValuedParameter<"int64_t", "-1">:$index);
  let assemblyFormat = "`<` $regClass `,` $width (`,` $index^)? `>`";
  let genVerifyDecl = 1;
}

def WaveAMDMachine_ImmType : WaveAMDMachine_Type<"Imm", "imm"> {
  let summary = "machine immediate operand";
  let description = [{
    A `!waveamdmachine.imm` value represents an immediate machine operand. It keeps
    immediates in SSA form so generic WaveAMDMachine operations can remain fully
    inspectable in textual MLIR.
  }];
}

def WaveAMDMachine_MemTokenType : WaveAMDMachine_Type<"MemToken", "mem.token"> {
  let summary = "machine memory dependency token";
  let description = [{
    A `!waveamdmachine.mem.token` value carries explicit WaveAMDMachine memory
    dependencies for waitcnt insertion.
  }];
}

def WaveAMDMachine_BarrierType : WaveAMDMachine_Type<"Barrier", "barrier"> {
  let summary = "static split-barrier handle";
  let description = [{
    A `!waveamdmachine.barrier` value names one static split-barrier site.
    Materialization assigns LDS state after all split sites are known.
  }];
}

def WaveAMDMachine_M0Type : WaveAMDMachine_Type<"M0", "m0"> {
  let summary = "AMDGPU M0 state";
  let description = [{
    A `!waveamdmachine.m0` value makes writes to the AMDGPU M0 register visible
    in WaveAMDMachine IR. LDS DMA and addtid DS instructions consume it for
    LDS base address state.
  }];
}

def WaveAMDMachine_Reg
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::RegType>($_self)">,
           "WaveAMDMachine register type">;

def WaveAMDMachine_Imm
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::ImmType>($_self)">,
           "WaveAMDMachine immediate type">;

def WaveAMDMachine_MemToken
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::MemTokenType>($_self)">,
           "WaveAMDMachine memory token type">;

def WaveAMDMachine_Barrier
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::BarrierType>($_self)">,
           "WaveAMDMachine barrier handle type">;

def WaveAMDMachine_M0
    : Type<CPred<"::llvm::isa<::mlir::waveamdmachine::M0Type>($_self)">,
           "WaveAMDMachine M0 state type">;

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETYPES_TD
