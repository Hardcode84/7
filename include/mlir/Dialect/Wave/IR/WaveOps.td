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
include "mlir/IR/OpBase.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/InferIntRangeInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

class Wave_Op<string mnemonic, list<Trait> traits = []> :
    Op<Wave_Dialect, mnemonic, traits>;

def Wave_YieldOp : Wave_Op<"yield", [Pure, ReturnLike, Terminator,
                                     ParentOneOf<["WhereOp"]>]> {
  let summary = "terminator for wave structured regions";
  let description = [{
    Terminates a Wave dialect structured region.

    The MVP Wave dialect currently uses `wave.yield` only for side-effecting
    `wave.where` regions with no yielded values.
  }];

  let assemblyFormat = "attr-dict";
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
  let hasVerifier = 1;
}

def Wave_SplatOp : Wave_Op<"splat", [Pure]> {
  let summary = "broadcast a scalar value into a lane-varying SIMD value";
  let description = [{
    Broadcasts an ordinary scalar value into a `!wave.simd<T, W>`. Lowering to
    AMDGPU can keep the original scalar value as an SGPR operand when legal.
  }];

  let arguments = (ins AnyType:$source);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = "$source attr-dict `:` type($source) `->` qualified(type($result))";
  let hasVerifier = 1;
}

def Wave_BinaryOp : Wave_Op<"binary", [Pure]> {
  let summary = "lane-wise integer binary operation";
  let description = [{
    Applies an integer binary operation lane-wise to two SIMD values.
  }];

  let arguments = (ins StrAttr:$kind, Wave_Simd:$lhs, Wave_Simd:$rhs);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = "$kind $lhs `,` $rhs attr-dict `:` qualified(type($lhs)) `,` qualified(type($rhs)) `->` qualified(type($result))";
  let hasVerifier = 1;
}

def Wave_CastOp : Wave_Op<"cast", [Pure]> {
  let summary = "numeric conversion over scalar or SIMD values";
  let arguments = (ins Wave_CastKindEnum:$kind,
                       AnyType:$source,
                       OptionalAttr<DictionaryAttr>:$policy);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$kind $source (`policy` $policy^)? attr-dict `:` type($source) `->` type($result)";
  let hasVerifier = 1;
}

def Wave_PackOp : Wave_Op<"pack", [Pure, SameTypeOperands]> {
  let summary = "pack values into a vector";
  let arguments = (ins Variadic<AnyType>:$inputs);
  let results = (outs Wave_1DVectorOrSimdOf1DVector:$result);
  let assemblyFormat = [{
    $inputs attr-dict `:` type($inputs) `->` type($result)
  }];
  let hasFolder = 1;
  let hasVerifier = 1;
}

def Wave_ExtractOp : Wave_Op<"extract", [Pure]> {
  let summary = "extract one element from a vector";
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

//===----------------------------------------------------------------------===//
// Width-independent integer arithmetic over uniform-or-SIMD operands.
//
// Each op accepts a signless integer or `!wave.simd<iN, W>` per operand.
// Element bit-widths must agree across operands; SIMD wave widths must
// agree across SIMD operands. The result is `!wave.simd<iN, W>` if any
// operand is SIMD, otherwise the bare `iN`.
//
// Lowering to WaveAMDMachine picks the per-target instruction sequence
// based on width and uniformity. Only i32 ships today; other widths
// fail at selection with a clear diagnostic. Unsigned variants
// (addui/mului/shlui) will follow when needed -- for these three
// operations the two's-complement bits are identical to the signed
// case, so the upstream MLIR convention (no sign suffix) applies.
//===----------------------------------------------------------------------===//

class Wave_IntBinaryArith<string mnemonic> : Wave_Op<mnemonic, [
    Pure,
    DeclareOpInterfaceMethods<InferIntRangeInterface, ["inferResultRanges"]>
  ]> {
  let arguments = (ins AnyType:$lhs, AnyType:$rhs);
  let results = (outs AnyType:$result);
  let assemblyFormat = [{
    $lhs `,` $rhs attr-dict
    `:` type($lhs) `,` type($rhs) `->` type($result)
  }];
  let hasVerifier = 1;
}

def Wave_AddiOp : Wave_IntBinaryArith<"addi"> {
  let summary = "integer add over uniform or SIMD operands";
  let description = [{
    Two's-complement addition. Mixed uniform / SIMD is legal: the result
    follows the SIMD operand's wave width. Lowers per-target to
    `s_add_i32`, `v_add_u32`, or their wider equivalents.
  }];
}

def Wave_MuliOp : Wave_IntBinaryArith<"muli"> {
  let summary = "integer multiply (low) over uniform or SIMD operands";
  let description = [{
    Two's-complement multiply, low half. Sign is bit-identical to
    unsigned mul-low so no `s`/`u` suffix. Lowers per-target to
    `s_mul_i32`, `v_mul_lo_u32`, or wider equivalents.
  }];
}

def Wave_ShliOp : Wave_IntBinaryArith<"shli"> {
  let summary = "logical left shift over uniform or SIMD operands";
  let description = [{
    Shift `$lhs` left by `$rhs` bits. The shift amount must have the
    same element bit-width as `$lhs`. Behaviour for shift amounts equal
    to or exceeding the element width is target-defined; producers
    should mask before shifting if they care.
  }];
}

class Wave_FloatSimdBinary<string mnemonic> : Wave_Op<mnemonic, [Pure]> {
  let arguments = (ins Wave_Simd:$lhs, Wave_Simd:$rhs);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = [{
    $lhs `,` $rhs attr-dict
    `:` qualified(type($lhs)) `,` qualified(type($rhs)) `->`
    qualified(type($result))
  }];
  let hasVerifier = 1;
}

class Wave_FloatSimdTernary<string mnemonic> : Wave_Op<mnemonic, [Pure]> {
  let arguments = (ins Wave_Simd:$lhs, Wave_Simd:$rhs, Wave_Simd:$acc);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = [{
    $lhs `,` $rhs `,` $acc attr-dict
    `:` qualified(type($lhs)) `,` qualified(type($rhs)) `,`
    qualified(type($acc)) `->` qualified(type($result))
  }];
  let hasVerifier = 1;
}

class Wave_FloatSimdUnary<string mnemonic> : Wave_Op<mnemonic, [Pure]> {
  let arguments = (ins Wave_Simd:$source);
  let results = (outs Wave_Simd:$result);
  let assemblyFormat = [{
    $source attr-dict `:` qualified(type($source)) `->`
    qualified(type($result))
  }];
  let hasVerifier = 1;
}

def Wave_FAddOp : Wave_FloatSimdBinary<"fadd"> {
  let summary = "lane-wise floating-point add";
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

def Wave_AssumeRangeOp : Wave_Op<"assume_range", [
    Pure, AllTypesMatch<["value", "result"]>,
    DeclareOpInterfaceMethods<InferIntRangeInterface,
                              ["inferResultRangesFromOptional"]>
  ]> {
  let summary = "assert a signed integer range on a value";
  let description = [{
    Identity at runtime. Producer-side assertion that `$value`, treated
    as a signed integer, satisfies `lo <= value <= hi`. The op feeds
    upstream `IntRangeAnalysis` through `InferIntRangeInterface` so
    consuming ops that also implement the interface (the `arith.*`
    family, plus any wave op that opts in later) can propagate the
    bound.

    The op overrides `inferResultRangesFromOptional` rather than
    `inferResultRanges` so that it produces a range even when the
    operand's incoming range is uninitialized -- which is the common
    case for function args and other "first observation" points where
    `assume_range` actually earns its keep.

    The op is intentionally permissive:
      * `lo > hi` is legal -- signals an empty range. Useful inside a
        dead branch where the producer wants to assert unreachability.
      * `lo` / `hi` need not fit the value's representable range. The
        analysis clamps to the bit-width.

    Accepts a signless integer or `!wave.simd<iN, W>` value; the latter
    means "every lane is in `[lo, hi]`" and is published on the SIMD
    value's lattice entry using the element bit-width.
  }];

  let arguments = (ins
      AnyTypeOf<[AnySignlessInteger, Wave_SimdOfSignlessInteger]>:$value,
      SI64Attr:$lo,
      SI64Attr:$hi);
  let results = (outs
      AnyTypeOf<[AnySignlessInteger, Wave_SimdOfSignlessInteger]>:$result);
  let assemblyFormat = [{
    $value `,` `[` $lo `,` $hi `]` attr-dict `:` type($value)
  }];
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
  let hasVerifier = 1;
}

def Wave_ReadFirstOp : Wave_Op<"read_first", [
    NoMemoryEffect]> {
  let summary = "broadcast the first active lane's value";
  let description = [{
    Returns the value from the first active lane, broadcast to all active lanes.
    This is the explicit lane-varying to scalar-uniform boundary.
  }];

  let arguments = (ins Wave_Simd:$source);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$source attr-dict `:` qualified(type($source)) `->` type($result)";
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
}

def Wave_WaitOp : Wave_Op<"wait", []> {
  let summary = "wait for explicit memory dependencies";
  let arguments = (ins Variadic<Wave_MemToken>:$dependencies);
  let assemblyFormat = "$dependencies attr-dict `:` type($dependencies)";
}

def Wave_LdsBaseOp : Wave_Op<"lds_base", [Pure]> {
  let summary = "base pointer to the kernel's workgroup-local LDS arena";
  let description = [{
    Returns a wave-uniform pointer to the start of the workgroup-local LDS
    arena reserved for this kernel. The pointer addresses element type
    `T` at the offset given by the optional `offset` attribute (in bytes
    from the start of the arena, default 0).

    The kernel is expected to carry a `wave.lds_size` integer attribute
    expressing the total number of bytes of LDS reserved; lowering uses
    that value to populate `group_segment_fixed_size` on the kernel
    descriptor.
  }];

  let arguments = (ins DefaultValuedAttr<I64Attr, "0">:$offset);
  let results = (outs Wave_Ptr:$result);
  let assemblyFormat = "attr-dict `:` qualified(type($result))";
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

def Wave_PtrAddOp : Wave_Op<"ptr_add", [Pure]> {
  let summary = "add an element offset to a Wave pointer";
  let arguments = (ins AnyType:$base, AnyType:$offset);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$base `,` $offset attr-dict `:` type($base) `,` type($offset) `->` type($result)";
  let hasVerifier = 1;
}

def Wave_IndexExprOp : Wave_Op<"index_expr", [Pure]> {
  let summary = "materialize a symbolic offset as a wave index value";
  let description = [{
    Produces a `!wave.index` value defined by a symbolic expression and a
    list of bindings. Each binding pairs an SSA operand with the name of
    a free symbol referenced by the expression. The free-symbol set of
    `$expr` must equal the set of `$names` (bijective).

    Binding operand types are restricted to either wave-uniform scalars
    (signless integer, `!wave.index` with no width) or lane-varying
    SIMD values (`!wave.simd<i32, W>`, `!wave.index<W>`). The result
    width is the unique non-zero wave width across the lane-varying
    bindings; with no lane-varying binding the result is `!wave.index`
    (uniform).

    Built-in `index` is intentionally not accepted -- offset math here
    stays in fixed-width integer land. Cast `index` SSA values to i32
    at the producer before feeding them in.

    The op is pure: equal `$expr`, `$bindings`, and `$names` CSE.
  }];

  let arguments = (ins Wave_ExprAttr:$expr,
                       StrArrayAttr:$names,
                       Variadic<AnyType>:$bindings);
  let results = (outs Wave_Index:$result);
  let assemblyFormat = [{
    $expr $names `(` $bindings `)` attr-dict
    `:` functional-type($bindings, $result)
  }];
  let hasVerifier = 1;
}

def Wave_StoreOp : Wave_Op<"store", [MemoryEffects<[MemWrite]>]> {
  let summary = "store a lane-varying SIMD value to memory";
  let description = [{
    Stores a value to a `!wave.ptr<T, space>` or lane-varying
    `!wave.simd<!wave.ptr<T, space>, W>` pointer.
  }];

  let arguments = (ins Wave_Simd:$value,
                       AnyType:$ptr,
                       Optional<Wave_MemToken>:$dependency);
  let results = (outs Wave_MemToken:$token);
  let assemblyFormat = "$value `->` $ptr (`after` $dependency^)? attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def Wave_LoadOp : Wave_Op<"load", [MemoryEffects<[MemRead]>]> {
  let summary = "load a lane-varying SIMD value from memory";
  let description = [{
    Each active lane loads from the address derived from `$ptr`:

    * With a plain `!wave.ptr<T, space>`, every lane reads the same
      pointer (a wave-uniform broadcast load).
    * With `!wave.simd<!wave.ptr<T, space>, W>`, each lane reads from its
      own pointer.

    The result shape is driven entirely by the result SIMD type:

    * `!wave.simd<T, W>` -- each lane loads exactly one 16- or 32-bit
      `T` element.
    * `!wave.simd<vector<N x T'>, W>` -- each lane loads `N` consecutive
      32-bit transport elements `T'` starting at its pointer. The total
      per-lane payload is `N * 32` bits; the pointer element type may be
      any 16- or 32-bit type as long as `N * 32 % bitwidth(T_ptr) == 0`,
      i.e. the destination tuple covers an integer number of pointer
      elements.

    Memory ordering follows the usual Wave token discipline: the optional
    `dependency` token sequences this load after a prior memory op, and
    the returned token can be threaded into a later consumer to express
    a happens-before constraint.
  }];

  let arguments = (ins AnyType:$ptr,
                       Optional<Wave_MemToken>:$dependency);
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

    In the MVP lowering, this operation is converted to `scf.if` and relies on
    target lowering to preserve divergent-control semantics. Later target-specific
    lowerings can consume `wave.where` directly and lower it to EXEC/predicate
    manipulation without reconstructing structure from generic control flow.
  }];

  let arguments = (ins Wave_Mask:$condition);
  let regions = (region SizedRegion<1>:$thenRegion,
                        MaxSizedRegion<1>:$elseRegion);

  let assemblyFormat = [{
    $condition $thenRegion (`otherwise` $elseRegion^)? attr-dict `:` qualified(type($condition))
  }];
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEOPS_TD
