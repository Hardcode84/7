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
// DEFAULT: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1{{.*}}>, %{{[^:]+}}: !waveamdmachine.mem.token, %[[BASE:.*]]: !waveamdmachine.reg<sgpr, 2{{.*}}>):
// DEFAULT: global_load_b128 %[[VOFF:.*]], %[[BASE]]
// DEFAULT-NOT: waveamdmachine.v_add_u32
// DEFAULT: waveamdmachine.s_add_u64_u32 %[[BASE]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2{{.*}}>, !waveamdmachine.imm)
func.func @default_pipeline_extracted_strided_kloop(
    %a: !wave.ptr<#wave.global, f16>, %n: i32) -> !wave.mem.token attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %observe_seed_1 = wave.token : !wave.mem.token
  %observe_region_2 = scf.for %i = %c0 to %n step %c1 iter_args(%observe_carry_3 = %observe_seed_1) -> (!wave.mem.token) : i32  {
    %off = wave.index_expr <"128*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    %observed_store_1 = wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    %observe_join_4 = wave.join %observe_carry_3, %observed_store_1 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    scf.yield %observe_join_4 : !wave.mem.token
  }
  return %observe_region_2 : !wave.mem.token
}

// DEFAULT-LABEL: func.func @default_pipeline_extracted_nested_symbolic_stride
// DEFAULT: waveamdmachine.metadata
// DEFAULT: waveamdmachine.uniform_loop
// DEFAULT: waveamdmachine.uniform_loop
func.func @default_pipeline_extracted_nested_symbolic_stride(
    %a: !wave.ptr<#wave.global, f16>, %n_raw: i32, %m: i32) -> !wave.mem.token attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %n = wave.assume %n_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %observe_seed_9 = wave.token : !wave.mem.token
  %observe_region_10 = scf.for %i = %c0 to %n step %c1 iter_args(%observe_carry_11 = %observe_seed_9) -> (!wave.mem.token) : i32  {
    %observe_seed_5 = wave.token : !wave.mem.token
    %observe_region_6 = scf.for %j = %c1 to %m step %c1 iter_args(%observe_carry_7 = %observe_seed_5) -> (!wave.mem.token) : i32  {
      %off = wave.index_expr <"16*i*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
          -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      %observed_store_2 = wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
      %observe_join_8 = wave.join %observe_carry_7, %observed_store_2 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      scf.yield %observe_join_8 : !wave.mem.token
    }
    %observe_join_12 = wave.join %observe_carry_11, %observe_region_6 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    scf.yield %observe_join_12 : !wave.mem.token
  }
  return %observe_region_10 : !wave.mem.token
}
}
