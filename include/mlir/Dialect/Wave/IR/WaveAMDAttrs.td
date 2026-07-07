//===-- WaveAMDAttrs.td - WaveAMD dialect attributes --------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEAMDATTRS_TD
#define MLIR_DIALECT_WAVE_IR_WAVEAMDATTRS_TD

include "mlir/Dialect/Wave/IR/WaveAMDBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"

class WaveAMD_Attr<string name, string attrMnemonic, list<Trait> traits = []>
    : AttrDef<WaveAMD_Dialect, name, traits> {
  let mnemonic = attrMnemonic;
}

def WaveAMD_LoadCacheNone : I32EnumAttrCase<"None", 0, "none">;
def WaveAMD_LoadCacheCA : I32EnumAttrCase<"CA", 1, "ca">;
def WaveAMD_LoadCacheCG : I32EnumAttrCase<"CG", 2, "cg">;
def WaveAMD_LoadCacheCS : I32EnumAttrCase<"CS", 3, "cs">;
def WaveAMD_LoadCacheCV : I32EnumAttrCase<"CV", 4, "cv">;

def WaveAMD_LoadCacheKind : I32EnumAttr<"LoadCacheKind",
    "WaveAMD load cache modifier", [
      WaveAMD_LoadCacheNone, WaveAMD_LoadCacheCA, WaveAMD_LoadCacheCG,
      WaveAMD_LoadCacheCS, WaveAMD_LoadCacheCV
    ]> {
  let cppNamespace = "::mlir::waveamd";
}

def WaveAMD_StoreCacheNone : I32EnumAttrCase<"None", 0, "none">;
def WaveAMD_StoreCacheWB : I32EnumAttrCase<"WB", 1, "wb">;
def WaveAMD_StoreCacheCG : I32EnumAttrCase<"CG", 2, "cg">;
def WaveAMD_StoreCacheCS : I32EnumAttrCase<"CS", 3, "cs">;
def WaveAMD_StoreCacheWT : I32EnumAttrCase<"WT", 4, "wt">;

def WaveAMD_StoreCacheKind : I32EnumAttr<"StoreCacheKind",
    "WaveAMD store cache modifier", [
      WaveAMD_StoreCacheNone, WaveAMD_StoreCacheWB, WaveAMD_StoreCacheCG,
      WaveAMD_StoreCacheCS, WaveAMD_StoreCacheWT
    ]> {
  let cppNamespace = "::mlir::waveamd";
}

def WaveAMD_LoadCacheAttr : WaveAMD_Attr<"LoadCache", "load_cache"> {
  let summary = "AMD load cache modifier";
  let parameters = (ins EnumParameter<WaveAMD_LoadCacheKind>:$value);
  let assemblyFormat = "`<` $value `>`";
}

def WaveAMD_StoreCacheAttr : WaveAMD_Attr<"StoreCache", "store_cache"> {
  let summary = "AMD store cache modifier";
  let parameters = (ins EnumParameter<WaveAMD_StoreCacheKind>:$value);
  let assemblyFormat = "`<` $value `>`";
}

def WaveAMD_BufferAddressSpaceAttr
    : WaveAMD_Attr<"BufferAddressSpace", "buffer"> {
  let summary = "AMD buffer resource address space";
  let description = [{
    Marks a `!wave.ptr` as referring to an AMD buffer/resource-style address
    space. The target-independent `wave` pointer type accepts this as an
    arbitrary address-space attribute; target-specific lowering can later choose
    a descriptor/resource representation.
  }];
  let assemblyFormat = "";
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEAMDATTRS_TD
