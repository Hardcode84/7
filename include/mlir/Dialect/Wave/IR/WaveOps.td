//===-- WaveOps.td - Wave dialect operations --------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEOPS_TD
#define MLIR_DIALECT_WAVE_IR_WAVEOPS_TD

include "mlir/Dialect/Wave/IR/WaveAttrs.td"
include "mlir/Dialect/Wave/IR/WaveBase.td"
include "mlir/Dialect/Wave/IR/WaveEnums.td"
include "mlir/Dialect/Wave/IR/WaveTypes.td"

include "mlir/Dialect/Arith/IR/ArithBase.td"
include "mlir/Dialect/Arith/IR/ArithOpsInterfaces.td"
include "mlir/IR/BuiltinAttributeInterfaces.td"
include "mlir/IR/OpBase.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/InferIntRangeInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/ViewLikeInterface.td"

class Wave_Op<string mnemonic, list<Trait> traits = []> :
    Op<Wave_Dialect, mnemonic, traits>;

def Wave_ConstantOp : Wave_Op<"constant", [
    ConstantLike, Pure,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>]> {
  let summary = "Wave scalar, SIMD, or mask constant";
  let arguments = (ins TypedAttrInterface:$value);
  let results = (outs AnyType:$result);
  let hasCustomAssemblyFormat = 1;
  let hasFolder = 1;
  let hasVerifier = 1;
  let extraClassDeclaration = [{
    static bool isBuildableWith(Attribute value, Type type);
    static ConstantOp materialize(OpBuilder &builder, Attribute value,
                                  Type type, Location loc);
  }];
}

def Wave_YieldOp : Wave_Op<"yield", [Pure, ReturnLike, Terminator,
                                     ParentOneOf<["WhereOp"]>]> {
  let summary = "terminator for wave structured regions";
  let description = [{
    Terminates a Wave dialect structured region.

    `wave.where` regions yield the values forwarded as the parent op results.
    Without an `otherwise` region, inactive lanes in yielded data values are
    unspecified.
  }];

  let arguments = (ins Variadic<AnyType>:$values);
  let builders = [
    OpBuilder<(ins), [{ build($_builder, $_state, ::mlir::ValueRange{}); }]>
  ];
  let assemblyFormat = "($values^ `:` type($values))? attr-dict";
}

def Wave_LaneIdOp : Wave_Op<"lane_id", [Pure,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>]> {
  let summary = "lane id within the current subgroup";
  let description = [{
    Returns the lane id as a lane-varying SIMD value. Each lane observes its own
    id in the subgroup/wave.
  }];

  let results = (outs Wave_Simd:$result);
  let assemblyFormat = "attr-dict `:` qualified(type($result))";
}

// Read the per-SIMD shader cycle counter. Not pure: two consecutive
// reads observe different values. Returned as a uniform i32, so it
// reaches the rest of the wave dialect (splat, store) through the
// same path as kernel scalar args. AMDGPU lowering picks the per-arch
// counter inst -- gfx11 uses `s_getreg_b32 hwreg(HW_REG_SHADER_CYCLES)`
// (20-bit, wraps at ~600us @ 1.76GHz); other archs need their own
// machine ops and are not yet wired.
def Wave_ReadCyclesOp : Wave_Op<"read_cycles"> {
  let summary = "read the per-SIMD shader cycle counter";
  let results = (outs I32:$result);
  let assemblyFormat = "attr-dict `:` type($result)";
}

def Wave_SubgroupIdOp : Wave_Op<"subgroup_id", [Pure]> {
  let summary = "subgroup id within the current workgroup";
  let description = [{
    Returns the subgroup/wave id within the current workgroup.
  }];

  let results = (outs Index:$result);
  let assemblyFormat = "attr-dict";
}

def Wave_WorkgroupIdOp : Wave_Op<"workgroup_id", [Pure,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>]> {
  let summary = "id of the current workgroup along the given grid axis";
  let description = [{
    Returns the wave-uniform workgroup id along axis 0 (`x`), 1 (`y`),
    or 2 (`z`). The value is materialized from a preloaded scalar register
    on AMDGPU targets.
  }];

  let arguments = (ins I64Attr:$axis);
  let results = (outs I32:$result);
  let assemblyFormat = "$axis attr-dict";
  let hasVerifier = 1;
}

def Wave_WorkitemIdOp : Wave_Op<"workitem_id", [Pure,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>]> {
  let summary = "id of the current workitem along the given workgroup axis";
  let description = [{
    Returns the per-lane workitem id along axis 0 (`x`), 1 (`y`), or 2
    (`z`), as a `!wave.simd<i32, 32>`. Lane `L` of wave `W` sees
    `workitem_id_x = W * 32 + L` for axis 0; axis 1 / 2 are populated only
    when the target requests them through the kernel descriptor.
  }];

  let arguments = (ins I64Attr:$axis);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = "$axis attr-dict `:` qualified(type($result))";
  let hasVerifier = 1;
}

def Wave_SubgroupSizeOp : Wave_Op<"subgroup_size", [Pure]> {
  let summary = "number of lanes in the current subgroup";
  let description = [{
    Returns the number of lanes in the current subgroup/wave.
  }];

  let results = (outs Index:$result);
  let assemblyFormat = "attr-dict";
}

def Wave_BallotOp : Wave_Op<"ballot", [NoMemoryEffect]> {
  let summary = "materialize a logical mask as integer bits";
  let description = [{
    Materializes a first-class `!wave.mask<W>` as an integer bit mask whose bit
    `N` corresponds to lane `N`.

    The result width is target-dependent. AMDGPU wave32 commonly uses `i32`;
    wave64 commonly uses `i64`.
  }];

  let arguments = (ins Wave_Mask:$mask);
  let results = (outs AnySignlessInteger:$result);
  let assemblyFormat = "$mask attr-dict `:` qualified(type($mask)) `->` type($result)";
  let hasFolder = 1;
  let hasVerifier = 1;
}

def Wave_SplatOp : Wave_Op<"splat", [Pure,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>]> {
  let summary = "broadcast a scalar value into a lane-varying SIMD value";
  let description = [{
    Broadcasts an ordinary scalar value into a `!wave.simd<T, W>`. Lowering to
    AMDGPU can keep the original scalar value as an SGPR operand when legal.
  }];

  let arguments = (ins AnyType:$source);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = "$source attr-dict `:` type($source) `->` qualified(type($result))";
  let hasFolder = 1;
  let hasVerifier = 1;
}

def Wave_BinaryOp : Wave_Op<"binary", [Pure,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>,
    DeclareOpInterfaceMethods<ArithIntegerOverflowFlagsInterface>]> {
  let summary = "integer binary operation";
  let description = [{
    Applies an integer binary operation to uniform integer/index values, SIMD
    integer/index values, or mixed uniform/SIMD operands. The result is SIMD
    when either operand is SIMD.
  }];

  let arguments = (ins Wave_BinaryKindEnum:$kind,
                       AnyType:$lhs,
                       AnyType:$rhs,
                       DefaultValuedAttr<
                         Arith_IntegerOverflowAttr,
                         "::mlir::arith::IntegerOverflowFlags::none">:$overflowFlags);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$kind $lhs `,` $rhs (`overflow` `` $overflowFlags^)? attr-dict `:` qualified(type($lhs)) `,` qualified(type($rhs)) `->` qualified(type($result))";
  let hasFolder = 1;
  let hasVerifier = 1;
}

def Wave_URecipOp : Wave_Op<"urecip", [Pure]> {
  let summary = "unsigned i32 reciprocal estimate";
  let arguments = (ins AnyType:$source);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$source attr-dict `:` type($source) `->` type($result)";
  let hasVerifier = 1;
}

def Wave_CtzOp : Wave_Op<"ctz", [Pure]> {
  let summary = "integer count trailing zeros";
  let arguments = (ins AnyType:$source);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$source attr-dict `:` type($source) `->` type($result)";
  let hasVerifier = 1;
}

def Wave_CastOp : Wave_Op<"cast", [Pure]> {
  let summary = "numeric conversion over scalar or SIMD values";
  let arguments = (ins Wave_CastKindEnum:$kind,
                       AnyType:$source,
                       OptionalAttr<DictionaryAttr>:$policy);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$kind $source (`policy` $policy^)? attr-dict `:` type($source) `->` type($result)";
  let hasFolder = 1;
  let hasVerifier = 1;
}

def Wave_PtrCastOp : Wave_Op<"ptr_cast", [Pure, ViewLikeOpInterface]> {
  let summary = "reinterpret a Wave pointer element type";
  let arguments = (ins AnyType:$source);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$source attr-dict `:` type($source) `->` type($result)";
  let hasVerifier = 1;
  let extraClassDeclaration = [{
    Value getViewSource() { return getSource(); }
  }];
}

def Wave_SelectOp : Wave_Op<"select", [
    Pure, AllTypesMatch<["true_value", "false_value", "result"]>]> {
  let summary = "select a Wave value";
  let description = [{
    Selects between two values. An `i1` condition selects the whole value,
    including uniform scalars, pointers, SIMD values, and masks. A
    `!wave.mask<W>` condition selects lane-wise and therefore requires a
    lane-shaped result with the same width (`!wave.simd<..., W>` or
    `!wave.mask<W>`).
  }];

  let arguments = (ins AnyType:$condition,
                       AnyType:$true_value,
                       AnyType:$false_value);
  let results = (outs AnyType:$result);
  let hasCustomAssemblyFormat = 1;
  let hasVerifier = 1;
}

def Wave_PackOp : Wave_Op<"pack", [Pure, SameTypeOperands]> {
  let summary = "pack values or subvectors into a vector";
  let arguments = (ins Variadic<AnyType>:$inputs);
  let results = (outs Wave_1DVectorOrSimdOf1DVector:$result);
  let assemblyFormat = [{
    $inputs attr-dict `:` type($inputs) `->` type($result)
  }];
  let hasCanonicalizer = 1;
  let hasFolder = 1;
  let hasVerifier = 1;
}

def Wave_ExtractOp : Wave_Op<"extract", [Pure]> {
  let summary = "extract one element or subvector from a vector";
  let arguments = (ins Wave_1DVectorOrSimdOf1DVector:$source,
                       ConfinedAttr<I64Attr, [IntNonNegative]>:$index);
  let results = (outs AnyType:$result);
  let assemblyFormat = [{
    $source `[` $index `]` attr-dict
    `:` type($source) `->` type($result)
  }];
  let hasFolder = 1;
  let hasVerifier = 1;
}

class Wave_FloatSimdBinary<string mnemonic>
    : Wave_Op<mnemonic,
              [Pure, DeclareOpInterfaceMethods<ArithFastMathInterface>]> {
  let arguments = (ins Wave_Simd:$lhs, Wave_Simd:$rhs,
                       DefaultValuedAttr<
                         Arith_FastMathAttr,
                         "::mlir::arith::FastMathFlags::none">:$fastmath);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = [{
    $lhs `,` $rhs (`fastmath` `` $fastmath^)? attr-dict
    `:` qualified(type($lhs)) `,` qualified(type($rhs)) `->`
    qualified(type($result))
  }];
  let hasVerifier = 1;
}

class Wave_FloatSimdTernary<string mnemonic>
    : Wave_Op<mnemonic,
              [Pure, DeclareOpInterfaceMethods<ArithFastMathInterface>]> {
  let arguments = (ins Wave_Simd:$lhs, Wave_Simd:$rhs, Wave_Simd:$acc,
                       DefaultValuedAttr<
                         Arith_FastMathAttr,
                         "::mlir::arith::FastMathFlags::none">:$fastmath);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = [{
    $lhs `,` $rhs `,` $acc (`fastmath` `` $fastmath^)? attr-dict
    `:` qualified(type($lhs)) `,` qualified(type($rhs)) `,`
    qualified(type($acc)) `->` qualified(type($result))
  }];
  let hasVerifier = 1;
}

class Wave_FloatSimdUnary<string mnemonic>
    : Wave_Op<mnemonic,
              [Pure, DeclareOpInterfaceMethods<ArithFastMathInterface>]> {
  let arguments = (ins Wave_Simd:$source,
                       DefaultValuedAttr<
                         Arith_FastMathAttr,
                         "::mlir::arith::FastMathFlags::none">:$fastmath);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = [{
    $source (`fastmath` `` $fastmath^)? attr-dict `:`
    qualified(type($source)) `->`
    qualified(type($result))
  }];
  let hasVerifier = 1;
}

def Wave_FAddOp : Wave_FloatSimdBinary<"fadd"> {
  let summary = "lane-wise floating-point add";
  let hasCanonicalizer = 1;
}

def Wave_FSubOp : Wave_FloatSimdBinary<"fsub"> {
  let summary = "lane-wise f32 subtract";
}

def Wave_FMulOp : Wave_FloatSimdBinary<"fmul"> {
  let summary = "lane-wise floating-point multiply";
}

def Wave_FMaxOp : Wave_FloatSimdBinary<"fmax"> {
  let summary = "lane-wise floating-point maximum";
}

def Wave_FmaOp : Wave_FloatSimdTernary<"fma"> {
  let summary = "lane-wise fused multiply-add";
}

def Wave_FExp2Op : Wave_FloatSimdUnary<"fexp2"> {
  let summary = "lane-wise base-2 f32 exponential";
}

def Wave_FRcpOp : Wave_FloatSimdUnary<"frcp"> {
  let summary = "lane-wise f32 reciprocal";
}

def Wave_AssumeOp : Wave_Op<"assume", [
    Pure, AllTypesMatch<["value", "result"]>,
    DeclareOpInterfaceMethods<InferIntRangeInterface,
                              ["inferResultRangesFromOptional"]>
  ]> {
  let summary = "assert symbolic integer predicates on a value";
  let description = [{
    Identity at runtime. Producer-side assertion that `$value`, bound to
    `$name`, satisfies every predicate in `$assumptions`. SIMD operands
    assert the predicates lane-wise.
  }];

  let arguments = (ins
      AnyTypeOf<[AnySignlessInteger, Wave_SimdOfSignlessInteger,
                 Wave_IndexValue]>:$value,
      StrAttr:$name,
      Wave_PredArrayAttr:$assumptions);
  let results = (outs
      AnyTypeOf<[AnySignlessInteger, Wave_SimdOfSignlessInteger,
                 Wave_IndexValue]>:$result);
  let assemblyFormat = [{
    $value `as` $name $assumptions attr-dict `:` type($value)
  }];
  let hasVerifier = 1;
  let hasCanonicalizer = 1;
}

def Wave_CmpIOp : Wave_Op<"cmpi", [Pure]> {
  let summary = "lane-wise integer comparison";
  let description = [{
    Compares two SIMD integer values lane-wise and returns a first-class
    `!wave.mask<W>`.
  }];

  let arguments = (ins Arith_CmpIPredicateAttr:$predicate,
                       Wave_Simd:$lhs,
                       Wave_Simd:$rhs);
  let results = (outs Wave_Mask:$result);
  let assemblyFormat = "$predicate $lhs `,` $rhs attr-dict `:` qualified(type($lhs)) `,` qualified(type($rhs)) `->` qualified(type($result))";
  let hasFolder = 1;
  let hasVerifier = 1;
}

def Wave_ReadFirstOp : Wave_Op<"read_first", [NoMemoryEffect,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>]> {
  let summary = "broadcast the first active lane's value";
  let description = [{
    Returns the value from the first active lane, broadcast to all active lanes.
    This is the explicit lane-varying to scalar-uniform boundary.
  }];

  let arguments = (ins Wave_Simd:$source);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$source attr-dict `:` qualified(type($source)) `->` type($result)";
  let hasVerifier = 1;
  let hasFolder = 1;
}

def Wave_ShuffleOp : Wave_Op<"shuffle", [NoMemoryEffect]> {
  let summary = "read values from indexed source lanes";
  let description = [{
    Gather-shaped cross-lane movement. For each active destination lane `d`,
    reads the source lane selected by `$source_lane[d]` from `$source`.
    Results for inactive destination lanes are unspecified. If the selected
    source lane is inactive or out of range, the active result lane is
    unspecified.

    `$source_lane` may be scalar `i32` / `index` or
    `!wave.simd<i32/index, W>`. Static lane-map attributes are out of scope for
    v1.
  }];

  let arguments = (ins Wave_Simd:$source, AnyType:$source_lane);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = [{
    $source `from` $source_lane attr-dict `:`
    qualified(type($source)) `,` type($source_lane) `->`
    qualified(type($result))
  }];
  let hasVerifier = 1;
}

def Wave_TokenOp : Wave_Op<"token", [Pure]> {
  let summary = "create an empty memory dependency token";
  let results = (outs Wave_MemToken:$result);
  let assemblyFormat = "attr-dict `:` qualified(type($result))";
}

def Wave_AfterOp : Wave_Op<"after", [Pure]> {
  let summary = "derive a memory token after one or more dependencies";
  let arguments = (ins Variadic<Wave_MemToken>:$dependencies);
  let results = (outs Wave_MemToken:$result);
  let assemblyFormat = "$dependencies attr-dict `:` type($dependencies) `->` qualified(type($result))";
}

def Wave_JoinOp : Wave_Op<"join", [Pure]> {
  let summary = "join multiple memory dependency tokens";
  let arguments = (ins Variadic<Wave_MemToken>:$dependencies);
  let results = (outs Wave_MemToken:$result);
  let assemblyFormat = "$dependencies attr-dict `:` type($dependencies) `->` qualified(type($result))";
  let hasCanonicalizer = 1;
  let hasFolder = 1;
}

def Wave_SharedMemoryBaseOp : Wave_Op<"shared_memory_base", [Pure]> {
  let summary = "base pointer to the kernel's workgroup-local shared memory";
  let description = [{
    Returns a wave-uniform pointer to the start of workgroup-local shared
    memory reserved for this kernel. The pointer addresses element type
    `T` at the offset given by the optional `offset` attribute (in bytes
    from the start of shared memory, default 0).

    `wave.lds_size` reserves fixed descriptor shared-memory bytes. Optional
    `wave.dynamic_lds_size` reserves launch-provided shared-memory bytes.
  }];

  let arguments = (ins DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Wave_Ptr:$result);
  let assemblyFormat = "attr-dict `:` qualified(type($result))";
  let hasVerifier = 1;
}

def Wave_AllocOp : Wave_Op<"alloc"> {
  let summary = "allocate workgroup-local memory";
  let description = [{
    Produces a wave-uniform pointer to a fixed-size workgroup-local allocation.
  }];

  let arguments = (ins I64Attr:$bytesize, I64Attr:$align);
  let results = (outs Res<Wave_Ptr, "",
                          [MemAlloc<DefaultResource, 0, FullEffect>]>:$result);
  let assemblyFormat = "`(` `)` attr-dict `:` qualified(type($result))";
  let hasVerifier = 1;
}

def Wave_AllocReleaseOp : Wave_Op<"alloc_release"> {
  let summary = "end a workgroup allocation lifetime";
  let description = [{
    Marks `$allocation` reusable after `$dependency`. The dependency must cover
    every memory access through the allocation. The result forwards that
    ordering to accesses of a later allocation that may share the same storage.

    This is a logical lifetime operation. Allocation resolution removes it; it
    emits no target instruction.
  }];

  let arguments = (ins Arg<Wave_Ptr, "", [MemFree]>:$allocation,
                       Wave_MemToken:$dependency);
  let results = (outs Wave_MemToken:$token);
  let assemblyFormat = "$allocation `after` $dependency attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def Wave_BarrierOp : Wave_Op<"barrier", [MemoryEffects<[MemWrite, MemRead]>]> {
  let summary = "workgroup-wide barrier";
  let description = [{
    Synchronizes all waves of the workgroup. Lowering must ensure that
    all memory operations preceding the barrier in any wave are visible
    to all waves after the barrier, via the usual hardware fences
    (`s_waitcnt lgkmcnt(0)` before `s_barrier` on RDNA3).

    The optional `dependencies` carry token-level ordering: a barrier
    that depends on an earlier LDS store cannot be moved above it, and
    the returned token sequences subsequent LDS loads after the barrier.
  }];

  let arguments = (ins Variadic<Wave_MemToken>:$dependencies);
  let results = (outs Wave_MemToken:$token);
  let assemblyFormat = "($dependencies^)? attr-dict `:` functional-type(operands, results)";
}

def Wave_PtrAddOp : Wave_Op<"ptr_add", [Pure, ViewLikeOpInterface]> {
  let summary = "add an element offset to a Wave pointer";
  let arguments = (ins AnyType:$base, AnyType:$offset);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$base `,` $offset attr-dict `:` type($base) `,` type($offset) `->` type($result)";
  let hasVerifier = 1;
  let extraClassDeclaration = [{
    Value getViewSource() { return getBase(); }
  }];
}

def Wave_IndexExprOp : Wave_Op<"index_expr", [Pure,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>]> {
  let summary = "materialize a symbolic offset as a wave index value";
  let description = [{
    Produces an index-shaped value defined by a symbolic expression and a
    list of bindings. Each binding pairs an SSA operand with the name of
    a free symbol referenced by the expression. The free-symbol set of
    `$expr` must equal the set of `$names` (bijective).

    Binding operand types are restricted to either wave-uniform scalars
    (builtin `index`, signless integer) or lane-varying SIMD values
    (`!wave.simd<i32, W>`, `!wave.simd<index, W>`). Results use builtin
    `index` for uniform offsets and `!wave.simd<index, W>` for lane-varying
    offsets.

    The op is pure: equal `$expr`, `$bindings`, and `$names` CSE.
  }];

  let arguments = (ins Wave_ExprAttr:$expr,
                       DefaultValuedAttr<Wave_PredArrayAttr, "{}">:$assumptions,
                       StrArrayAttr:$names,
                       Variadic<AnyType>:$bindings);
  let results = (outs Wave_IndexValue:$result);
  let assemblyFormat = [{
    $expr (`assuming` $assumptions^)? $names `(` $bindings `)` attr-dict
    `:` functional-type($bindings, $result)
  }];
  let hasVerifier = 1;
  let hasCanonicalizer = 1;
}

def Wave_StoreOp : Wave_Op<"store"> {
  let summary = "store a lane-varying SIMD value to memory";
  let description = [{
    Stores a value to a `!wave.ptr<space, T>` or lane-varying
    `!wave.simd<!wave.ptr<space, T>, W>` pointer.
  }];

  let arguments = (ins Wave_Simd:$value,
                       Arg<AnyType, "", [MemWrite]>:$ptr,
                       Optional<Wave_MemToken>:$dependency,
                       OptionalAttr<AnyAttr>:$cache);
  let results = (outs Wave_MemToken:$token);
  let assemblyFormat = "$value `->` $ptr (`after` $dependency^)? attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def Wave_LoadOp : Wave_Op<"load"> {
  let summary = "load a lane-varying SIMD value from memory";
  let description = [{
    Each active lane loads from the address derived from `$ptr`:

    * With a plain `!wave.ptr<space, T>`, every lane reads the same
      pointer (a wave-uniform broadcast load).
    * With `!wave.simd<!wave.ptr<space, T>, W>`, each lane reads from its
      own pointer.

    The result shape is driven entirely by the result SIMD type:

    * `!wave.simd<T, W>` -- each lane loads one 16- or 32-bit `T` element.
    * `!wave.simd<vector<N x T'>, W>` -- each lane loads `N` consecutive
      byte-sized elements. The payload must fit a 16-bit memory op or whole
      32-bit dword ops, and must cover an integer number of pointer elements.

    Memory ordering follows the usual Wave token discipline: the optional
    `dependency` token sequences this load after a prior memory op, and
    the returned token can be threaded into a later consumer to express
    a happens-before constraint.
  }];

  let arguments = (ins Arg<AnyType, "", [MemRead]>:$ptr,
                       Optional<Wave_MemToken>:$dependency,
                       OptionalAttr<AnyAttr>:$cache);
  let results = (outs Wave_Simd:$value, Wave_MemToken:$token);
  let assemblyFormat = "$ptr (`after` $dependency^)? attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def Wave_WhereOp : Wave_Op<"where", [
    SingleBlockImplicitTerminator<"YieldOp">,
    RecursiveMemoryEffects,
    NoRegionArguments]> {
  let summary = "structured lane-mask predication";
  let description = [{
    Executes the `then` region under a lane-varying mask. If an `otherwise`
    region is present, it executes under the complementary mask within the
    original active lanes.

    WaveAMDMachine lowering consumes `wave.where` directly: it saves EXEC,
    installs the then-mask, emits the nested region, optionally installs the
    else-mask, then restores EXEC. Other targets may lower the same op to
    predicate manipulation or structured divergent control.
  }];

  let arguments = (ins Wave_Mask:$condition);
  let results = (outs Variadic<AnyType>:$results);
  let regions = (region SizedRegion<1>:$thenRegion,
                        MaxSizedRegion<1>:$elseRegion);

  let assemblyFormat = [{
    $condition $thenRegion (`otherwise` $elseRegion^)? attr-dict `:` qualified(type($condition))
    (`->` type($results)^)?
  }];
  let hasVerifier = 1;
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEOPS_TD
