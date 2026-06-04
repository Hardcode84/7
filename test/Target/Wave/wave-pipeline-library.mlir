// RUN: FileCheck %s --check-prefix=PIPELINE < %wave_pipelines

// PIPELINE: transform.apply_registered_pass "wave-normalize-pointer-offsets"
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
// PIPELINE-NEXT: transform.apply_registered_pass "wave-combine-pointer-offsets"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-simplify-index-exprs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "wave-extract-loop-strides"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "loop-invariant-code-motion"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "canonicalize"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-to-machine"
// PIPELINE: transform.apply_registered_pass "waveamd-preserve-hw-regs"
// PIPELINE-NEXT: : (!transform.any_op) -> !transform.any_op
// PIPELINE-NEXT: transform.apply_registered_pass "waveamd-reg-alloc" with
// PIPELINE-NEXT: options = { "agpr-bank-spill" = true }
// PIPELINE-NEXT: to {{.*}} : (!transform.any_op) -> !transform.any_op
