// Wave compilation pipeline library.
//
// `transform-preload-library{transform-library-paths=$<this>}` followed
// by `transform-interpreter{entry-point=<name>}` runs the named
// sequence against the payload module. The default entry
// (`@__transform_main`) is the wave-to-AMDGPU backend, picked up
// without an explicit entry-point by `translateWaveToAMDGPU`. Tests
// that need a larger slice select a richer entry by name.

module attributes {transform.with_named_sequence} {
  // Lower wave / waveamd ops to WaveAMDMachine IR and prepare for ISA
  // emission. Caller must have stamped `waveamdmachine.target` on the
  // module (e.g. via `wave-set-target-attr`) -- the passes below read
  // it for subtarget feature selection.
  transform.named_sequence @waveamd_backend(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %r0 = transform.apply_registered_pass "waveamd-to-machine" to %root
        : (!transform.any_op) -> !transform.any_op
    // Fold duplicate imm / v_mov constant materializations selection
    // emits per address add, before reg-alloc.
    %rk = transform.apply_registered_pass "canonicalize" to %r0
        : (!transform.any_op) -> !transform.any_op
    %rc = transform.apply_registered_pass "cse" to %rk
        : (!transform.any_op) -> !transform.any_op
    %r1 = transform.apply_registered_pass "waveamd-abi-lowering" to %rc
        : (!transform.any_op) -> !transform.any_op
    %r2 = transform.apply_registered_pass "waveamd-decompose-mem-tuples" to %r1
        : (!transform.any_op) -> !transform.any_op
    %r3 = transform.apply_registered_pass "waveamd-insert-ticket-waits" to %r2
        : (!transform.any_op) -> !transform.any_op
    %r4 = transform.apply_registered_pass "waveamd-insert-hazard-waits" to %r3
        : (!transform.any_op) -> !transform.any_op
    %r5 = transform.apply_registered_pass "waveamd-reg-alloc" to %r4
        : (!transform.any_op) -> !transform.any_op
    %r6 = transform.apply_registered_pass "waveamd-resource-info" to %r5
        : (!transform.any_op) -> !transform.any_op
    %r7 = transform.apply_registered_pass "waveamd-metadata" to %r6
        : (!transform.any_op) -> !transform.any_op
    transform.yield %r7 : !transform.any_op
  }

  // Wave backend + final assembly + lld into a `gpu.binary` per
  // `gpu.module`. The `wave-compile-kernels` pass expects the funcs
  // it walks to already be WaveAMDMachine IR -- the backend sequence
  // above lowers them.
  transform.named_sequence @compile_kernels(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %r0 = transform.include @waveamd_backend failures(propagate) (%root)
        : (!transform.any_op) -> !transform.any_op
    %r1 = transform.apply_registered_pass "wave-compile-kernels" to %r0
        : (!transform.any_op) -> !transform.any_op
    transform.yield %r1 : !transform.any_op
  }

  // Default entry: the wave-to-AMDGPU backend. `wave-translate` picks
  // this up implicitly via `__transform_main`.
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %r = transform.include @waveamd_backend failures(propagate) (%root)
        : (!transform.any_op) -> !transform.any_op
    transform.yield %r : !transform.any_op
  }
}
