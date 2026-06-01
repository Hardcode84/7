// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' | FileCheck %s --check-prefix=DEFAULT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100", wavemeta.params = {}} {
func.func @load_source_dialects(%p: !wave.ptr<#wave.global, i32>, %range: i32) {
  %buf = waveamd.make_buffer %p, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  return
}

// DEFAULT-LABEL: func.func @default_pipeline_extracted_strided_kloop
// DEFAULT: waveamdmachine.metadata
// DEFAULT: waveamdmachine.uniform_loop
// DEFAULT: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1{{.*}}>, %[[VOFF:.*]]: !waveamdmachine.reg<vgpr, 1{{.*}}>, %[[BASE:.*]]: !waveamdmachine.reg<sgpr, 2{{.*}}>):
// DEFAULT: global_load_b128 %[[VOFF]], %[[BASE]]
// DEFAULT-NOT: waveamdmachine.v_add_u32
// DEFAULT: waveamdmachine.s_add_u64_u32 %[[BASE]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2{{.*}}>, !waveamdmachine.imm)
func.func @default_pipeline_extracted_strided_kloop(
    %a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"128*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}

// DEFAULT-LABEL: func.func @default_pipeline_extracted_nested_symbolic_stride
// DEFAULT: waveamdmachine.metadata
// DEFAULT: waveamdmachine.uniform_loop
// DEFAULT: waveamdmachine.uniform_loop
func.func @default_pipeline_extracted_nested_symbolic_stride(
    %a: !wave.ptr<#wave.global, f16>, %n_raw: i32, %m: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %n = wave.assume_range %n_raw, [0, 31] : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    scf.for %j = %c1 to %m step %c1 : i32 {
      %off = wave.index_expr <"16*i*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
          -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    }
  }
  return
}
}
