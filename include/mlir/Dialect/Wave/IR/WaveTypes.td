//===-- WaveTypes.td - Wave dialect types -----------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVETYPES_TD
#define MLIR_DIALECT_WAVE_IR_WAVETYPES_TD

include "mlir/Dialect/Wave/IR/WaveAttrs.td"
include "mlir/Dialect/Wave/IR/WaveBase.td"
include "mlir/IR/AttrTypeBase.td"

class Wave_Type<string name, string typeMnemonic, list<Trait> traits = [],
                string baseCppClass = "::mlir::Type">
    : TypeDef<Wave_Dialect, name, traits, baseCppClass> {
  let mnemonic = typeMnemonic;
}

def Wave_SimdType : Wave_Type<"Simd", "simd"> {
  let summary = "lane-varying SIMD value";
  let description = [{
    A `!wave.simd<T, W>` value is one logical `T` value per active lane of a
    subgroup with width `W`. Lowering to AMDGPU erases the type to the element
    type `T`; the value is then represented by the usual divergent VGPR
    semantics in the AMDGPU backend.
  }];

  let parameters = (ins "mlir::Type":$elementType, "int64_t":$width);
  let assemblyFormat = "`<` $elementType `,` $width `>`";
}

def Wave_MaskType : Wave_Type<"Mask", "mask"> {
  let summary = "logical lane mask";
  let description = [{
    A `!wave.mask<W>` value is one logical predicate bit per lane of a subgroup
    with width `W`. Lowering may choose a divergent `i1`, AMDGPU EXEC-width
    scalar mask, target predicate register, or another physical form.
  }];

  let parameters = (ins "int64_t":$width);
  let assemblyFormat = "`<` $width `>`";
}

def Wave_MemTokenType : Wave_Type<"MemToken", "mem.token"> {
  let summary = "explicit memory dependency token";
  let description = [{
    A `!wave.mem.token` value represents an explicit ordering dependency
    between Wave memory operations. Memory operations that exchange tokens are
    ordered; operations with no token relationship may be scheduled
    independently.
  }];
}

def Wave_PtrType : Wave_Type<"Ptr", "ptr"> {
  let summary = "Wave pointer";
  let description = [{
    A `!wave.ptr<T, #space>` value is a pointer to an element of type `T` in an
    arbitrary address space attribute. The `wave` dialect defines
    `#wave.global`, `#wave.shared`, and `#wave.private`; target-specific
    dialects may provide additional address-space attributes.
  }];

  let parameters = (ins "mlir::Type":$elementType,
                        "mlir::Attribute":$addressSpace);
  let assemblyFormat = "`<` $elementType `,` $addressSpace `>`";
}

def Wave_IndexType : Wave_Type<"WaveIndex", "index"> {
  let summary = "symbolic-offset index value";
  let description = [{
    A `!wave.index` value is the result of a `wave.index_expr` op: an integer
    offset whose defining op carries a `#wave.expr` symbolic form plus the
    bindings of its free symbols.

    The optional `W` parameter is the subgroup wave width when the value is
    lane-varying. `!wave.index` (no width) is wave-uniform and behaves like a
    scalar `index`. `!wave.index<W>` is lane-varying and behaves like a
    `!wave.simd<i32, W>` at the addressing layer.

    The C++ class is `mlir::wave::WaveIndexType` to avoid colliding with the
    built-in `mlir::IndexType`; the IR mnemonic remains `wave.index`.
  }];

  let parameters = (ins DefaultValuedParameter<"int64_t", "0">:$width);
  let assemblyFormat = "(`<` $width^ `>`)?";
  let genVerifyDecl = 1;
  let extraClassDeclaration = [{
    bool isUniform() const { return getWidth() == 0; }
  }];
}

def Wave_Simd : Type<CPred<"::llvm::isa<::mlir::wave::SimdType>($_self)">,
                     "wave SIMD type">;

def Wave_Mask : Type<CPred<"::llvm::isa<::mlir::wave::MaskType>($_self)">,
                     "wave mask type">;

def Wave_MemToken
    : Type<CPred<"::llvm::isa<::mlir::wave::MemTokenType>($_self)">,
           "wave memory token type">;

def Wave_Ptr : Type<CPred<"::llvm::isa<::mlir::wave::PtrType>($_self)">,
                    "wave pointer type">;

def Wave_Index
    : Type<CPred<"::llvm::isa<::mlir::wave::WaveIndexType>($_self)">,
           "wave index type">;

#endif // MLIR_DIALECT_WAVE_IR_WAVETYPES_TD
