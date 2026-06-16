//===-- WaveEnums.td - Wave dialect enums ------------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEENUMS_TD
#define MLIR_DIALECT_WAVE_IR_WAVEENUMS_TD

include "mlir/Dialect/Wave/IR/WaveBase.td"
include "mlir/IR/EnumAttr.td"

def Wave_CastKindFpConvert : I32EnumAttrCase<"FpConvert", 0, "fpconvert">;
def Wave_CastKindIntConvert : I32EnumAttrCase<"IntConvert", 1, "intconvert">;
def Wave_CastKindIntToFp : I32EnumAttrCase<"IntToFp", 2, "int_to_fp">;
def Wave_CastKindFpToInt : I32EnumAttrCase<"FpToInt", 3, "fp_to_int">;

def Wave_CastKindEnum : I32EnumAttr<"CastKind", "Wave cast kind", [
    Wave_CastKindFpConvert, Wave_CastKindIntConvert, Wave_CastKindIntToFp,
    Wave_CastKindFpToInt]> {
  let cppNamespace = "::mlir::wave";
}

def Wave_BinaryKindAddI : I32EnumAttrCase<"AddI", 0, "addi">;
def Wave_BinaryKindSubI : I32EnumAttrCase<"SubI", 1, "subi">;
def Wave_BinaryKindMulI : I32EnumAttrCase<"MulI", 2, "muli">;
def Wave_BinaryKindShLI : I32EnumAttrCase<"ShLI", 3, "shli">;
def Wave_BinaryKindShRUI : I32EnumAttrCase<"ShRUI", 4, "shrui">;
def Wave_BinaryKindShRSI : I32EnumAttrCase<"ShRSI", 5, "shrsi">;
def Wave_BinaryKindAndI : I32EnumAttrCase<"AndI", 6, "andi">;
def Wave_BinaryKindOrI : I32EnumAttrCase<"OrI", 7, "ori">;
def Wave_BinaryKindXOrI : I32EnumAttrCase<"XOrI", 8, "xori">;
def Wave_BinaryKindDivUI : I32EnumAttrCase<"DivUI", 9, "divui">;
def Wave_BinaryKindDivSI : I32EnumAttrCase<"DivSI", 10, "divsi">;
def Wave_BinaryKindRemUI : I32EnumAttrCase<"RemUI", 11, "remui">;
def Wave_BinaryKindRemSI : I32EnumAttrCase<"RemSI", 12, "remsi">;
def Wave_BinaryKindMulHUI : I32EnumAttrCase<"MulHUI", 13, "mulhui">;

def Wave_BinaryKindEnum : I32EnumAttr<"BinaryKind", "Wave binary op kind", [
    Wave_BinaryKindAddI, Wave_BinaryKindSubI, Wave_BinaryKindMulI,
    Wave_BinaryKindShLI, Wave_BinaryKindShRUI, Wave_BinaryKindShRSI,
    Wave_BinaryKindAndI, Wave_BinaryKindOrI, Wave_BinaryKindXOrI,
    Wave_BinaryKindMulHUI, Wave_BinaryKindDivUI, Wave_BinaryKindDivSI,
    Wave_BinaryKindRemUI, Wave_BinaryKindRemSI]> {
  let cppNamespace = "::mlir::wave";
}

def Wave_CastRoundingRNE : I32EnumAttrCase<"RNE", 0, "rne">;
def Wave_CastRoundingRTZ : I32EnumAttrCase<"RTZ", 1, "rtz">;
def Wave_CastRoundingRTP : I32EnumAttrCase<"RTP", 2, "rtp">;
def Wave_CastRoundingRTN : I32EnumAttrCase<"RTN", 3, "rtn">;

def Wave_CastRoundingEnum : I32EnumAttr<"CastRounding", "Wave cast rounding mode", [
    Wave_CastRoundingRNE, Wave_CastRoundingRTZ, Wave_CastRoundingRTP,
    Wave_CastRoundingRTN]> {
  let cppNamespace = "::mlir::wave";
}

def Wave_CastSignednessSigned : I32EnumAttrCase<"Signed", 0, "signed">;
def Wave_CastSignednessUnsigned : I32EnumAttrCase<"Unsigned", 1, "unsigned">;

def Wave_CastSignednessEnum : I32EnumAttr<"CastSignedness",
    "Wave cast integer signedness",
    [Wave_CastSignednessSigned, Wave_CastSignednessUnsigned]> {
  let cppNamespace = "::mlir::wave";
}

def Wave_CastExtensionSign : I32EnumAttrCase<"Sign", 0, "sign">;
def Wave_CastExtensionZero : I32EnumAttrCase<"Zero", 1, "zero">;

def Wave_CastExtensionEnum : I32EnumAttr<"CastExtension",
    "Wave cast integer extension mode",
    [Wave_CastExtensionSign, Wave_CastExtensionZero]> {
  let cppNamespace = "::mlir::wave";
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEENUMS_TD
