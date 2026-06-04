//===-- WaveAttrs.td - Wave dialect attributes ------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEATTRS_TD
#define MLIR_DIALECT_WAVE_IR_WAVEATTRS_TD

include "mlir/Dialect/Wave/IR/WaveBase.td"
include "mlir/Dialect/Wave/IR/WaveEnums.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/CommonAttrConstraints.td"

class Wave_Attr<string name, string attrMnemonic, list<Trait> traits = []>
    : AttrDef<Wave_Dialect, name, traits> {
  let mnemonic = attrMnemonic;
}

def Wave_CastRoundingPolicyAttr
    : Wave_Attr<"CastRoundingPolicy", "cast_rounding"> {
  let summary = "wave.cast floating-point rounding policy";
  let parameters = (ins EnumParameter<Wave_CastRoundingEnum>:$value);
  let assemblyFormat = "`<` $value `>`";
}

def Wave_CastSignednessPolicyAttr
    : Wave_Attr<"CastSignednessPolicy", "cast_signedness"> {
  let summary = "wave.cast integer signedness policy";
  let parameters = (ins EnumParameter<Wave_CastSignednessEnum>:$value);
  let assemblyFormat = "`<` $value `>`";
}

def Wave_CastExtensionPolicyAttr
    : Wave_Attr<"CastExtensionPolicy", "cast_extension"> {
  let summary = "wave.cast integer extension policy";
  let parameters = (ins EnumParameter<Wave_CastExtensionEnum>:$value);
  let assemblyFormat = "`<` $value `>`";
}

//===----------------------------------------------------------------------===//
// Symbolic offset algebra: opaque ixsimpl-node handles, round-tripped via
// the dialect-owned `sym::Store`. Attribute parameters carry pointer-typed
// handles; text only appears in the parser/printer hooks below.
//===----------------------------------------------------------------------===//

def Wave_ExprHandleParameter
    : AttrParameter<"::mlir::wave::sym::ExprHandle",
                    "symbolic expression handle"> {
  let parser = "::mlir::wave::sym::parseExprHandle($_parser)";
  let printer = "::mlir::wave::sym::printExprHandle($_printer, $_self)";
}

def Wave_PredHandleParameter
    : AttrParameter<"::mlir::wave::sym::PredHandle",
                    "symbolic predicate handle"> {
  let parser = "::mlir::wave::sym::parsePredHandle($_parser)";
  let printer = "::mlir::wave::sym::printPredHandle($_printer, $_self)";
}

def Wave_ExprAttr : Wave_Attr<"Expr", "expr"> {
  let summary = "Symbolic expression attribute";
  let description = [{
    Wave-dialect symbolic expression attribute backed by an imported
    `ixsimpl` expression node in the dialect-owned `sym::Store`. The
    attribute parameter is a pointer-typed handle: passes inspect and
    rebuild it structurally without ever round-tripping through text.
  }];
  let parameters = (ins Wave_ExprHandleParameter:$value);
  let assemblyFormat = "`<` $value `>`";
  let genVerifyDecl = 1;
}

def Wave_PredAttr : Wave_Attr<"Pred", "pred"> {
  let summary = "Symbolic predicate attribute";
  let description = [{
    Wave-dialect symbolic predicate attribute backed by an imported
    `ixsimpl` predicate node in the dialect-owned `sym::Store`.
  }];
  let parameters = (ins Wave_PredHandleParameter:$value);
  let assemblyFormat = "`<` $value `>`";
  let genVerifyDecl = 1;
}

def Wave_PredArrayAttr
    : TypedArrayAttrBase<Wave_PredAttr, "wave predicate array attribute">;

def Wave_GlobalAddressSpaceAttr : Wave_Attr<"GlobalAddressSpace", "global"> {
  let summary = "global memory address space";
  let assemblyFormat = "";
}

def Wave_SharedAddressSpaceAttr : Wave_Attr<"SharedAddressSpace", "shared"> {
  let summary = "shared/workgroup memory address space";
  let assemblyFormat = "";
}

def Wave_PrivateAddressSpaceAttr : Wave_Attr<"PrivateAddressSpace", "private"> {
  let summary = "private memory address space";
  let assemblyFormat = "";
}

//===----------------------------------------------------------------------===//
// Tune-op variable domains. Each variant describes one variable's
// enumeration set for `wave.transform.tune`'s Cartesian product.
//===----------------------------------------------------------------------===//

def Wave_TuneEnumAttr : Wave_Attr<"TuneEnum", "tune_enum"> {
  let summary = "Explicit enumeration of i64 values";
  let description = [{
    Domain expressed as a literal list of integers, e.g.
    `#wave.tune_enum<[1, 2, 4, 8]>`. Order of the list is the order the
    tune op explores the variable.
  }];
  let parameters = (ins ArrayRefParameter<"int64_t">:$values);
  let assemblyFormat = "`<` `[` $values `]` `>`";
  let genVerifyDecl = 1;
}

def Wave_TuneRangeAttr : Wave_Attr<"TuneRange", "tune_range"> {
  let summary = "Half-open integer range with positive stride";
  let description = [{
    Domain `{lo, lo + step, lo + 2*step, ...}` up to but excluding
    `hi`. `step` must be positive; `hi > lo` (so the domain is
    non-empty).
  }];
  let parameters = (ins "int64_t":$lower, "int64_t":$upper, "int64_t":$step);
  let assemblyFormat = "`<` $lower `,` $upper `,` $step `>`";
  let genVerifyDecl = 1;
}

def Wave_TunePow2InAttr : Wave_Attr<"TunePow2In", "tune_pow2_in"> {
  let summary = "Powers of two within a closed range";
  let description = [{
    Domain is the set of `2^k` values that fall within `[lower, upper]`
    inclusive. `lower` and `upper` must be positive and at least one
    power of two has to fit in the range.
  }];
  let parameters = (ins "int64_t":$lower, "int64_t":$upper);
  let assemblyFormat = "`<` `[` $lower `,` $upper `]` `>`";
  let genVerifyDecl = 1;
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEATTRS_TD
