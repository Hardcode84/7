# RUN: %PYTHON %s | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx1100},transform-interpreter)' --verify-diagnostics | FileCheck %s

# End-to-end autotune over a real WMMA f16 matmul: vary
# `wave_k_tiles`, run the full wave-to-machine backend per trial,
# silenceably skip trials that overflow the artificial VGPR budget,
# decompose regalloc memory tuples, score by `vgpr_count_max`, pick the largest
# count that fits.
#
# The Python builder is asked for pre-specialise MLIR
# (skip_specialize=True). The tune body then binds the tile factor,
# specialises, lowers, regalloc-mark-overflow, runs post-regalloc ticket
# waits, hazard-waits, resource-info; the score reads vgpr_count_max off the
# module.

from mlir.dialects.wave_matmul import build_wmma_f16_matmul_module
from mlir.ir import Module, UnitAttr

MAX_K_TILES = 8

module = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=128,
    wave_k_tiles=MAX_K_TILES,
    BM=1,
    BN=1,
    matrix_intrinsic="wmma",
    skip_specialize=True,
)

TRANSFORM_OPS = """
module attributes {transform.with_named_sequence} {
  transform.named_sequence @body(
      %mod: !transform.any_op {transform.consumed},
      %k: !transform.param<i64> {transform.readonly}) {
    wave.transform.bind_param %mod "wave_k_tiles" = %k as index
        : (!transform.any_op, !transform.param<i64>) -> ()
    %m1 = transform.apply_registered_pass "wavemeta-specialize" to %mod
        : (!transform.any_op) -> !transform.any_op
    %m2 = transform.apply_registered_pass "waveamd-to-machine" to %m1
        : (!transform.any_op) -> !transform.any_op
    %m3 = transform.apply_registered_pass "waveamd-abi-lowering" to %m2
        : (!transform.any_op) -> !transform.any_op
    %m4 = transform.apply_registered_pass "waveamd-decompose-mem-tuples" to %m3
        : (!transform.any_op) -> !transform.any_op
    %m7 = transform.apply_registered_pass "waveamd-reg-alloc" with
        options = { "mark-overflow" = true }
        to %m4 : (!transform.any_op) -> !transform.any_op
    %overflowed = wave.transform.get_int_attr
        "waveamdmachine.regalloc_overflowed_count" from %m7
        : (!transform.any_op) -> !transform.param<i64>
    %zero = transform.param.constant 0 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %overflowed, %zero
        : !transform.param<i64>
    %m8 = transform.apply_registered_pass "waveamd-decompose-mem-tuples" to %m7
        : (!transform.any_op) -> !transform.any_op
    %m9 = transform.apply_registered_pass "waveamd-insert-ticket-waits" to %m8
        : (!transform.any_op) -> !transform.any_op
    %m10 = transform.apply_registered_pass "waveamd-insert-hazard-waits" to %m9
        : (!transform.any_op) -> !transform.any_op
    %m11 = transform.apply_registered_pass "waveamd-resource-info" to %m10
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @score(
      %mod: !transform.any_op {transform.readonly},
      %k: !transform.param<i64> {transform.readonly})
      -> !transform.param<i64> {
    %vgprs = wave.transform.get_int_attr
        "waveamdmachine.vgpr_count_max" from %mod
        : (!transform.any_op) -> !transform.param<i64>
    transform.yield %vgprs : !transform.param<i64>
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.consumed}) {
    %w, %s = wave.transform.tune %root body = @body score = @score {
      variables = {wave_k_tiles = #wave.tune_enum<[1, 2, 4, 8]>}
    } : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
    transform.yield
  }
}
"""

# Splice the autotune sequences into the matmul module and stamp the
# trait attr that lets `transform-interpreter` find `@__transform_main`.
# Set the attr first so the parsed snippet's `transform.named_sequence`
# ops survive the matmul-module verifier they will end up under.
with module.context:
    module.operation.attributes["transform.with_named_sequence"] = UnitAttr.get()
    snippet = Module.parse(TRANSFORM_OPS)
    for op in list(snippet.body.operations):
        op.detach_from_parent()
        module.body.append(op)

print(module)

# With the builder packing A/B frags into nested parametric ptuple
# iter-args (`ptuple<ptuple<af, M>, "wave_k_tiles">`), the K-loop
# iter-arg width scales with the bound `wave_k_tiles`. On gfx1100
# (256 VGPRs / wave): K = 8 reaches the VGPR cap and fits after scratch
# relief. Tune picks K = 8.
# CHECK-LABEL: module
# CHECK-SAME: waveamdmachine.vgpr_count_max = 256 : i64
# CHECK-SAME: wavemeta.params = {wave_k_tiles = 8 : index
