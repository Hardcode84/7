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

#endif // MLIR_DIALECT_WAVE_IR_WAVEENUMS_TD
