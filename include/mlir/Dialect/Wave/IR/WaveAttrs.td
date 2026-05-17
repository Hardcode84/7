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
include "mlir/IR/AttrTypeBase.td"

class Wave_Attr<string name, string attrMnemonic, list<Trait> traits = []>
    : AttrDef<Wave_Dialect, name, traits> {
  let mnemonic = attrMnemonic;
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
  let extraClassDeclaration = [{
    const ixs_node *getNode() const { return getValue().raw(); }
  }];
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
  let extraClassDeclaration = [{
    const ixs_node *getNode() const { return getValue().raw(); }
  }];
}

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

#endif // MLIR_DIALECT_WAVE_IR_WAVEATTRS_TD
