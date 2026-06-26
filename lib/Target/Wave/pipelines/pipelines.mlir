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
  transform.named_sequence @waveamd_backend_lower(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %rclr = transform.apply_registered_pass "waveamd-clear-regalloc-assignments" to %root
        : (!transform.any_op) -> !transform.any_op
    %rm = transform.apply_registered_pass "wavemeta-specialize" to %rclr
        : (!transform.any_op) -> !transform.any_op
    %rmeta = transform.apply_registered_pass "canonicalize" to %rm
        : (!transform.any_op) -> !transform.any_op
    %rnorm = transform.apply_registered_pass "wave-normalize-pointer-offsets" to %rmeta
        : (!transform.any_op) -> !transform.any_op
    %rgen0 = transform.apply_registered_pass "wave-generate-index-exprs" to %rnorm
        : (!transform.any_op) -> !transform.any_op
    %rbuf0 = transform.apply_registered_pass "wave-promote-global-to-buffer" to %rgen0
        : (!transform.any_op) -> !transform.any_op
    %roff0 = transform.apply_registered_pass "wave-combine-pointer-offsets" to %rbuf0
        : (!transform.any_op) -> !transform.any_op
    %rsimp0 = transform.apply_registered_pass "wave-simplify-index-exprs" to %roff0
        : (!transform.any_op) -> !transform.any_op
    %rmem = transform.apply_registered_pass "wave-coalesce-memory" to %rsimp0
        : (!transform.any_op) -> !transform.any_op
    %rcanon0 = transform.apply_registered_pass "canonicalize" to %rmem
        : (!transform.any_op) -> !transform.any_op
    %rcse0 = transform.apply_registered_pass "cse" to %rcanon0
        : (!transform.any_op) -> !transform.any_op
    %rpack = transform.apply_registered_pass "wave-form-packed-math" to %rcse0
        : (!transform.any_op) -> !transform.any_op
    %rcanon1 = transform.apply_registered_pass "canonicalize" to %rpack
        : (!transform.any_op) -> !transform.any_op
    %rcse1 = transform.apply_registered_pass "cse" to %rcanon1
        : (!transform.any_op) -> !transform.any_op
    %rnorm1 = transform.apply_registered_pass "wave-normalize-pointer-offsets" to %rcse1
        : (!transform.any_op) -> !transform.any_op
    %rgen1 = transform.apply_registered_pass "wave-generate-index-exprs" to %rnorm1
        : (!transform.any_op) -> !transform.any_op
    %roff1 = transform.apply_registered_pass "wave-combine-pointer-offsets" to %rgen1
        : (!transform.any_op) -> !transform.any_op
    %rsimp = transform.apply_registered_pass "wave-simplify-index-exprs" to %roff1
        : (!transform.any_op) -> !transform.any_op
    %rbuf = transform.apply_registered_pass "wave-promote-global-to-buffer" to %rsimp
        : (!transform.any_op) -> !transform.any_op
    %rstride = transform.apply_registered_pass "wave-extract-loop-strides" to %rbuf
        : (!transform.any_op) -> !transform.any_op
    %rzf = transform.apply_registered_pass "waveamd-dma-zero-fill" to %rstride
        : (!transform.any_op) -> !transform.any_op
    %rlicm = transform.apply_registered_pass "loop-invariant-code-motion" to %rzf
        : (!transform.any_op) -> !transform.any_op
    %rdiv = transform.apply_registered_pass "wave-expand-integer-div-rem" to %rlicm
        : (!transform.any_op) -> !transform.any_op
    %rdivc = transform.apply_registered_pass "canonicalize" to %rdiv
        : (!transform.any_op) -> !transform.any_op
    %rdivcs = transform.apply_registered_pass "cse" to %rdivc
        : (!transform.any_op) -> !transform.any_op
    %r0 = transform.apply_registered_pass "waveamd-to-machine" to %rdivcs
        : (!transform.any_op) -> !transform.any_op
    // Fold duplicate imm / v_mov constant materializations selection
    // emits per address add, before reg-alloc.
    %rk = transform.apply_registered_pass "canonicalize" to %r0
        : (!transform.any_op) -> !transform.any_op
    %rc = transform.apply_registered_pass "cse" to %rk
        : (!transform.any_op) -> !transform.any_op
    // Hoist loop-invariant body ops out of waveamdmachine.uniform_loop.
    %rl = transform.apply_registered_pass "loop-invariant-code-motion" to %rc
        : (!transform.any_op) -> !transform.any_op
    %r1 = transform.apply_registered_pass "waveamd-abi-lowering" to %rl
        : (!transform.any_op) -> !transform.any_op
    %r2 = transform.apply_registered_pass "waveamd-decompose-mem-tuples" to %r1
        : (!transform.any_op) -> !transform.any_op
    %rnwi = transform.apply_registered_pass "waveamd-narrow-wide-int" to %r2
        : (!transform.any_op) -> !transform.any_op
    %rfi = transform.apply_registered_pass "waveamd-form-fused-int" to %rnwi
        : (!transform.any_op) -> !transform.any_op
    %rclane = transform.apply_registered_pass "waveamd-cross-lane-peepholes" to %rfi
        : (!transform.any_op) -> !transform.any_op
    %rcl = transform.apply_registered_pass "waveamd-machine-cleanup" to %rclane
        : (!transform.any_op) -> !transform.any_op
    %rfc = transform.apply_registered_pass "canonicalize" to %rcl
        : (!transform.any_op) -> !transform.any_op
    %rfcs = transform.apply_registered_pass "cse" to %rfc
        : (!transform.any_op) -> !transform.any_op
    %rfl = transform.apply_registered_pass "loop-invariant-code-motion" to %rfcs
        : (!transform.any_op) -> !transform.any_op
    %rflc = transform.apply_registered_pass "cse" to %rfl
        : (!transform.any_op) -> !transform.any_op
    %rscc = transform.apply_registered_pass "waveamd-elide-scc-bool-roundtrip" to %rflc
        : (!transform.any_op) -> !transform.any_op
    transform.yield %rscc : !transform.any_op
  }

  transform.named_sequence @waveamd_backend_finish(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %rclr = transform.apply_registered_pass "waveamd-clear-regalloc-assignments" to %root
        : (!transform.any_op) -> !transform.any_op
    %r4 = transform.apply_registered_pass "waveamd-preserve-hw-regs" to %rclr
        : (!transform.any_op) -> !transform.any_op
    %rc = transform.apply_registered_pass "canonicalize" to %r4
        : (!transform.any_op) -> !transform.any_op
    %rcs = transform.apply_registered_pass "cse" to %rc
        : (!transform.any_op) -> !transform.any_op
    %r5 = transform.apply_registered_pass "waveamd-reg-alloc" to %rcs
        : (!transform.any_op) -> !transform.any_op
    %rd = transform.apply_registered_pass "waveamd-decompose-mem-tuples" to %r5
        : (!transform.any_op) -> !transform.any_op
    %rpz = transform.apply_registered_pass "waveamd-pack-vgpr-zero-moves" to %rd
        : (!transform.any_op) -> !transform.any_op
    // Preserve structured exec_if until waits see real control flow.
    %r6 = transform.apply_registered_pass "waveamd-insert-ticket-waits" to %rpz
        : (!transform.any_op) -> !transform.any_op
    %r7 = transform.apply_registered_pass "waveamd-insert-hazard-waits" to %r6
        : (!transform.any_op) -> !transform.any_op
    %r8 = transform.apply_registered_pass "waveamd-resource-info" to %r7
        : (!transform.any_op) -> !transform.any_op
    %rv = transform.apply_registered_pass "waveamd-verify-machine-operands" to %r8
        : (!transform.any_op) -> !transform.any_op
    %r9 = transform.apply_registered_pass "waveamd-metadata" to %rv
        : (!transform.any_op) -> !transform.any_op
    transform.yield %r9 : !transform.any_op
  }

  transform.named_sequence @waveamd_regalloc_transform_loop(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %r0 = wave.transform.regalloc_loop from %root
        : (!transform.any_op) -> !transform.any_op
    transform.yield %r0 : !transform.any_op
  }

  transform.named_sequence @waveamd_backend_unscheduled(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %r0 = transform.include @waveamd_backend_lower failures(propagate) (%root)
        : (!transform.any_op) -> !transform.any_op
    %r1 = transform.include @waveamd_backend_finish failures(propagate) (%r0)
        : (!transform.any_op) -> !transform.any_op
    transform.yield %r1 : !transform.any_op
  }

  transform.named_sequence @waveamd_backend(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %r0 = transform.include @waveamd_backend_lower failures(propagate) (%root)
        : (!transform.any_op) -> !transform.any_op
    %rs = transform.apply_registered_pass "waveamd-machine-schedule" with
        options = { "apply-schedule" = true,
                    "pressure-aware-selection" = true,
                    "max-region-ops" = 512 }
        to %r0 : (!transform.any_op) -> !transform.any_op
    %r1 = transform.include @waveamd_backend_finish failures(propagate) (%rs)
        : (!transform.any_op) -> !transform.any_op
    transform.yield %r1 : !transform.any_op
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
