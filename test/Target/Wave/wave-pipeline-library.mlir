// RUN: FileCheck %s --check-prefix=PIPELINE < %wave_pipelines

// PIPELINE: transform.apply_registered_pass "wave-lower-symbolic-memory"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-lower-redistribute"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-strength-reduce-modulo"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-normalize-pointer-offsets"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-generate-index-exprs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-promote-global-to-buffer"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-combine-pointer-offsets"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-simplify-index-exprs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-coalesce-memory"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "canonicalize"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "cse"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-form-packed-math"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "canonicalize"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "cse"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-normalize-pointer-offsets"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-generate-index-exprs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-combine-pointer-offsets"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-simplify-index-exprs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-promote-global-to-buffer"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-extract-loop-strides"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-dma-zero-fill"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "loop-invariant-code-motion"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-expand-integer-div-rem"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "canonicalize"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "cse"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-cleanup-allocs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: // First canon picks constant arms; second cleans joins and dead conditions.
// PIPELINE-NEXT: transform.apply_registered_pass "canonicalize"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-lower-token-selects"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "canonicalize"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-resolve-allocs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-delay-loop-carried-packs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-coalesce-where"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-to-machine"
// PIPELINE: transform.apply_registered_pass "waveamd-buffer-rsrc-to-tuples"
// PIPELINE: transform.apply_registered_pass "waveamd-decompose-mem-tuples"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-pair-ds-ops"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE: transform.apply_registered_pass "waveamd-form-fused-int"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-cross-lane-peepholes"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-machine-cleanup"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "canonicalize"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "cse"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "loop-invariant-code-motion"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "cse"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-elide-scc-bool-roundtrip"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE: transform.named_sequence @waveamd_backend_post_regalloc
// PIPELINE: transform.apply_registered_pass "waveamd-decompose-mem-tuples"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-pair-ds-ops"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-pack-vgpr-zero-moves"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: // Preserve structured exec_if until waits see real control flow.
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-insert-ticket-waits"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-insert-hazard-waits"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-resource-info"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-verify-machine-operands"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-metadata"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-clear-regalloc-transform-state"
// PIPELINE: transform.named_sequence @waveamd_backend_finish_transform_regalloc
// PIPELINE: transform.apply_registered_pass "waveamd-clear-regalloc-assignments"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-preserve-hw-regs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "canonicalize"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "cse"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-late-tuples"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-prepare-regalloc"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-pack-vgpr-zero-moves"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-hazard-repair"
// PIPELINE-NEXT: options = { "hoist-m0-across-regions" = false }
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.include @waveamd_regalloc_transform_loop
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.include @waveamd_backend_post_regalloc
// PIPELINE: transform.named_sequence @waveamd_backend_finish
// PIPELINE: transform.include @waveamd_backend_finish_transform_regalloc
// PIPELINE: transform.named_sequence @waveamd_regalloc_transform_loop
// PIPELINE: wave.transform.regalloc_loop from
// PIPELINE-NEXT: body = @waveamd_regalloc_transform_iteration
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE: transform.named_sequence @waveamd_regalloc_transform_iteration
// PIPELINE: wave.transform.regalloc_build_alias_state from
// PIPELINE-NEXT: {coalesce_mfma_acc_result = true}
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: wave.transform.regalloc_linear_scan from
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: wave.transform.regalloc_agpr_relief from
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: wave.transform.regalloc_remat_relief from
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: wave.transform.regalloc_sgpr_to_vgpr_relief from
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: wave.transform.regalloc_lds_relief from
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: wave.transform.regalloc_scratch_relief from
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE: transform.named_sequence @waveamd_backend_preschedule
// PIPELINE: transform.include @waveamd_backend_lower
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-split-barriers"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-mma-reuse-preschedule"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-scalar-mask-preschedule"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-hazard-repair"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE: transform.named_sequence @waveamd_backend_postschedule
// PIPELINE: transform.apply_registered_pass "waveamd-barrier-cleanup"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-finalize-barrier-protocols"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-materialize-split-barriers"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-scalar-mask-postschedule"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.include @waveamd_backend_finish
// PIPELINE: transform.named_sequence @waveamd_backend_unscheduled
// PIPELINE: transform.include @waveamd_backend_preschedule
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.include @waveamd_backend_postschedule
// PIPELINE: transform.named_sequence @waveamd_backend
// PIPELINE: transform.include @waveamd_backend_preschedule
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: %{{.*}} = transform.apply_registered_pass
// PIPELINE-NEXT: "waveamd-machine-multi-wave-specialize"
// PIPELINE-NEXT: to %{{.*}} : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-machine-schedule"
// PIPELINE-NEXT: options = { "apply-schedule" = true,
// PIPELINE-NEXT: "require-selected-input" = true }
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.include @waveamd_backend_postschedule
