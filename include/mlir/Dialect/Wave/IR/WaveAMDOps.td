//===-- WaveAMDOps.td - WaveAMD dialect operations --------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEAMDOPS_TD
#define MLIR_DIALECT_WAVE_IR_WAVEAMDOPS_TD

include "mlir/Dialect/Wave/IR/WaveAMDBase.td"
include "mlir/Dialect/Wave/IR/WaveAMDTypes.td"
include "mlir/Dialect/Wave/IR/WaveTypes.td"

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

class WaveAMD_Op<string mnemonic, list<Trait> traits = []> :
    Op<WaveAMD_Dialect, mnemonic, traits>;

def WaveAMD_MakeBufferOp : WaveAMD_Op<"make_buffer", [Pure]> {
  let summary = "construct an AMD buffer pointer from a flat/global pointer";
  let description = [{
    Constructs a `!wave.ptr<#waveamd.buffer, T>` value from a uniform base
    pointer and a uniform byte range. The resulting pointer is represented by a
    uniform AMD buffer descriptor plus the lane-varying i32 offset carried by
    subsequent `wave.ptr_add` operations.
  }];
  let arguments = (ins Wave_Ptr:$base,
                       AnySignlessInteger:$range);
  let results = (outs Wave_Ptr:$result);
  let assemblyFormat = "$base `,` $range attr-dict `:` type($base) `,` type($range) `->` type($result)";
  let hasVerifier = 1;
}

def WaveAMD_FragmentFillOp : WaveAMD_Op<"fragment_fill", [Pure]> {
  let summary = "fill an AMD matrix fragment with a scalar bit pattern";
  let arguments = (ins AnySignlessInteger:$source);
  let results = (outs WaveAMD_Fragment:$result);
  let assemblyFormat = "$source attr-dict `:` type($source) `->` qualified(type($result))";
  let hasVerifier = 1;
}

def WaveAMD_FragmentPackOp : WaveAMD_Op<"fragment_pack", [Pure]> {
  let summary = "bind per-lane register groups into a wave-cooperative fragment";
  let description = [{
    Bitcast-style assembly of a `!waveamd.fragment<role, T, M, N, W, R>`
    from a `!wave.simd<vector<N x E>, W>` whose per-lane vector holds
    `R * 32` bits of destination fragment payload in canonical WMMA order.

    The op is a zero-cost rename at the WaveAMDMachine level: the input and
    output share the same physical `R`-wide VGPR tuple. It exists so the
    DSL can build fragments out of the result of `wave.load` (or any
    other producer of per-lane register tuples) without forcing the
    target to grow a dedicated `fragment_load` opcode.

    Verifier constraints:

    * The SIMD width must match the fragment wave size.
    * The per-lane vector payload must be exactly `R` 32-bit registers wide.
  }];

  let arguments = (ins Wave_Simd:$registers);
  let results = (outs WaveAMD_Fragment:$result);
  let assemblyFormat = "$registers attr-dict `:` qualified(type($registers)) `->` qualified(type($result))";
  let hasVerifier = 1;
}

def WaveAMD_FragmentUnpackOp : WaveAMD_Op<"fragment_unpack", [Pure]> {
  let summary = "expose a wave-cooperative fragment as per-lane register groups";
  let description = [{
    Inverse rename for `fragment_pack`: views a
    `!waveamd.fragment<role, T, M, N, W, R>` as a
    `!wave.simd<vector<R x i32>, W>` so callers can route the underlying
    per-lane VGPR tuple through generic wave-dialect plumbing (e.g.
    `wave.store`) without a dedicated fragment-store opcode.

    Zero-cost at the WaveAMDMachine level: input and output share the
    physical `R`-wide VGPR tuple.

    Verifier constraints mirror `fragment_pack`:

    * SIMD width matches the fragment wave size.
    * Per-lane vector holds exactly `R` 32-bit elements.
  }];

  let arguments = (ins WaveAMD_Fragment:$fragment);
  let results = (outs Wave_Simd:$registers);
  let assemblyFormat = "$fragment attr-dict `:` qualified(type($fragment)) `->` qualified(type($registers))";
  let hasVerifier = 1;
}

def WaveAMD_MmaOp : WaveAMD_Op<"mma", [Pure]> {
  let summary = "AMD wave-cooperative matrix multiply-accumulate";
  let arguments = (ins StrAttr:$kind,
                       WaveAMD_Fragment:$a,
                       WaveAMD_Fragment:$b,
                       WaveAMD_Fragment:$acc);
  let results = (outs WaveAMD_Fragment:$result);
  let assemblyFormat = "$kind $a `,` $b `,` $acc attr-dict `:` qualified(type($a)) `,` qualified(type($b)) `,` qualified(type($acc)) `->` qualified(type($result))";
  let hasVerifier = 1;
}

def WaveAMD_MmaScaleOp : WaveAMD_Op<"mma_scale", [Pure]> {
  let summary = "AMD scaled matrix multiply-accumulate";
  let arguments = (ins StrAttr:$kind,
                       WaveAMD_Fragment:$a,
                       Wave_Simd:$a_scale,
                       WaveAMD_Fragment:$b,
                       Wave_Simd:$b_scale,
                       WaveAMD_Fragment:$acc,
                       DefaultValuedAttr<ConfinedAttr<I64Attr, [IntMinValue<0>, IntMaxValue<3>]>, "0">:$scale_idx_a,
                       DefaultValuedAttr<ConfinedAttr<I64Attr, [IntMinValue<0>, IntMaxValue<3>]>, "0">:$scale_idx_b);
  let results = (outs WaveAMD_Fragment:$result);
  let assemblyFormat = "$kind $a `,` $a_scale `,` $b `,` $b_scale `,` $acc attr-dict `:` qualified(type($a)) `,` qualified(type($a_scale)) `,` qualified(type($b)) `,` qualified(type($b_scale)) `,` qualified(type($acc)) `->` qualified(type($result))";
  let hasCanonicalizer = 1;
  let hasVerifier = 1;
}

def WaveAMD_DmaLoadLdsOp : WaveAMD_Op<"dma_load_lds", [MemoryEffects<[MemRead, MemWrite]>]> {
  let summary = "DMA one dword from global or buffer memory into LDS";
  let description = [{
    Starts a global/buffer to LDS transfer. The source pointer may be lane
    varying. The destination must be a scalar shared pointer: hardware takes
    that address through M0 and writes a contiguous wave block at `base +
    4*lane_id` for the dword form. The input token models source memory
    ordering; the result token models both the read and the LDS write.
  }];
  let arguments = (ins AnyType:$source,
                       Wave_Ptr:$dest,
                       Wave_MemToken:$dependency,
                       I64Attr:$bytes,
                       DefaultValuedAttr<I64Attr, "0">:$aux,
                       OptionalAttr<UnitAttr>:$zero_fill_inactive);
  let results = (outs Wave_MemToken:$token);
  let assemblyFormat = [{
    $source `->` $dest `after` $dependency
    attr-dict `:` functional-type(operands, results)
  }];
  let hasVerifier = 1;
}

def WaveAMD_TransposeLoadOp : WaveAMD_Op<"transpose_load", [MemoryEffects<[MemRead]>]> {
  let summary = "gfx950 LDS transpose load";
  let arguments = (ins Wave_PtrOrSimdPtr:$source,
                       Optional<Wave_MemToken>:$dependency);
  let results = (outs Wave_SimdOf1DVector:$value,
                      Wave_MemToken:$token);
  let assemblyFormat = "$source (`after` $dependency^)? attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEAMDOPS_TD
