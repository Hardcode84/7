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

def WaveAMD_TDMDescriptorD2 :
    I32EnumAttrCase<"D2", 0, "d2">;
def WaveAMD_TDMDescriptorD4 :
    I32EnumAttrCase<"D4", 1, "d4">;

def WaveAMD_TDMDescriptorKind : I32EnumAttr<"TDMDescriptorKind",
    "gfx1250 TDM descriptor form", [
      WaveAMD_TDMDescriptorD2, WaveAMD_TDMDescriptorD4
    ]> {
  let cppNamespace = "::mlir::waveamd";
}

def WaveAMD_TDMPrefetchRegular :
    I32EnumAttrCase<"Regular", 0, "regular">;
def WaveAMD_TDMPrefetchSpeculative :
    I32EnumAttrCase<"Speculative", 1, "speculative">;

def WaveAMD_TDMPrefetchMode : I32EnumAttr<"TDMPrefetchMode",
    "gfx1250 TDM prefetch mode", [
      WaveAMD_TDMPrefetchRegular, WaveAMD_TDMPrefetchSpeculative
    ]> {
  let cppNamespace = "::mlir::waveamd";
}

def WaveAMD_MmaWmmaI32_16x16x16_IU8 :
    I32EnumAttrCase<"WmmaI32_16x16x16_IU8", 0,
                    "wmma.i32.16x16x16.iu8">;
def WaveAMD_MmaWmmaF32_16x16x16_F16 :
    I32EnumAttrCase<"WmmaF32_16x16x16_F16", 1,
                    "wmma.f32.16x16x16.f16">;
def WaveAMD_MmaWmmaF32_16x16x16_BF16 :
    I32EnumAttrCase<"WmmaF32_16x16x16_BF16", 2,
                    "wmma.f32.16x16x16.bf16">;
def WaveAMD_MmaMfmaF32_16x16x16_F16 :
    I32EnumAttrCase<"MfmaF32_16x16x16_F16", 3,
                    "mfma.f32.16x16x16.f16">;
def WaveAMD_MmaMfmaF32_16x16x16_BF16 :
    I32EnumAttrCase<"MfmaF32_16x16x16_BF16", 4,
                    "mfma.f32.16x16x16.bf16">;
def WaveAMD_MmaMfmaF32_16x16x32_F16 :
    I32EnumAttrCase<"MfmaF32_16x16x32_F16", 5,
                    "mfma.f32.16x16x32.f16">;
def WaveAMD_MmaMfmaF32_16x16x32_BF16 :
    I32EnumAttrCase<"MfmaF32_16x16x32_BF16", 6,
                    "mfma.f32.16x16x32.bf16">;
def WaveAMD_MmaMfmaF32_32x32x16_F16 :
    I32EnumAttrCase<"MfmaF32_32x32x16_F16", 7,
                    "mfma.f32.32x32x16.f16">;
def WaveAMD_MmaMfmaF32_32x32x16_BF16 :
    I32EnumAttrCase<"MfmaF32_32x32x16_BF16", 8,
                    "mfma.f32.32x32x16.bf16">;
def WaveAMD_MmaMfmaScaleF32_16x16x128_F4F4 :
    I32EnumAttrCase<"MfmaScaleF32_16x16x128_F4F4", 9,
                    "mfma.scale.f32.16x16x128.f4.f4">;
def WaveAMD_MmaMfmaScaleF32_32x32x64_F4F4 :
    I32EnumAttrCase<"MfmaScaleF32_32x32x64_F4F4", 12,
                    "mfma.scale.f32.32x32x64.f4.f4">;
def WaveAMD_MmaWmmaF32_16x16x32_F16 :
    I32EnumAttrCase<"WmmaF32_16x16x32_F16", 10,
                    "wmma.f32.16x16x32.f16">;
def WaveAMD_MmaWmmaF32_16x16x32_BF16 :
    I32EnumAttrCase<"WmmaF32_16x16x32_BF16", 11,
                    "wmma.f32.16x16x32.bf16">;

def WaveAMD_MmaKind : I32EnumAttr<"MmaKind", "WaveAMD matrix operation kind", [
    WaveAMD_MmaWmmaI32_16x16x16_IU8,
    WaveAMD_MmaWmmaF32_16x16x16_F16,
    WaveAMD_MmaWmmaF32_16x16x16_BF16,
    WaveAMD_MmaMfmaF32_16x16x16_F16,
    WaveAMD_MmaMfmaF32_16x16x16_BF16,
    WaveAMD_MmaMfmaF32_16x16x32_F16,
    WaveAMD_MmaMfmaF32_16x16x32_BF16,
    WaveAMD_MmaMfmaF32_32x32x16_F16,
    WaveAMD_MmaMfmaF32_32x32x16_BF16,
    WaveAMD_MmaMfmaScaleF32_16x16x128_F4F4,
    WaveAMD_MmaMfmaScaleF32_32x32x64_F4F4,
    WaveAMD_MmaWmmaF32_16x16x32_F16,
    WaveAMD_MmaWmmaF32_16x16x32_BF16
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
