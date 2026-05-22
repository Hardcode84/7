// Default wave-to-AMDGPU compilation pipeline.
//
// `runWaveAMDMachinePipeline` (in AMDGPU.cpp) feeds the entry-point
// named sequence to the transform interpreter on the staging module
// produced by `WaveCompileKernels` / `translateWaveToAMDGPU`. Edit
// this file to reorder, drop, or insert wave passes; no C++ change
// required.

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.consumed}) {
    %m0 = transform.apply_registered_pass "waveamd-to-machine" to %root
        : (!transform.any_op) -> !transform.any_op
    %m1 = transform.apply_registered_pass "waveamd-abi-lowering" to %m0
        : (!transform.any_op) -> !transform.any_op
    %m2 = transform.apply_registered_pass "waveamd-decompose-mem-tuples" to %m1
        : (!transform.any_op) -> !transform.any_op
    %m3 = transform.apply_registered_pass "waveamd-insert-ticket-waits" to %m2
        : (!transform.any_op) -> !transform.any_op
    %m4 = transform.apply_registered_pass "waveamd-insert-hazard-waits" to %m3
        : (!transform.any_op) -> !transform.any_op
    %m5 = transform.apply_registered_pass "waveamd-reg-alloc" to %m4
        : (!transform.any_op) -> !transform.any_op
    %m6 = transform.apply_registered_pass "waveamd-resource-info" to %m5
        : (!transform.any_op) -> !transform.any_op
    %m7 = transform.apply_registered_pass "waveamd-metadata" to %m6
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}
