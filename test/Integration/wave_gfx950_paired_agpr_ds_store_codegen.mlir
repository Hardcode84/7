// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: paired_agpr_store_codegen:
// ASM: buffer_load_dwordx4
// ASM-NOT: ds_write2
// ASM: v_mfma_scale_f32_32x32x64_f8f6f4 {{a\[[0-9]+:[0-9]+\]}}
// ASM-COUNT-8: ds_write2st64_b32 {{v[0-9]+}}, {{a[0-9]+}}, {{a[0-9]+}}
// ASM-NOT: ds_write2
// ASM: s_barrier
// ASM-NOT: ds_write2
// ASM: ds_read
// ASM-COUNT-4: buffer_store_dwordx4
// ASM-NOT: buffer_store
// ASM-NOT: ds_write2
// ASM: .amdhsa_kernel paired_agpr_store_codegen
// ASM: .amdhsa_group_segment_fixed_size 4096
// ASM: .amdhsa_private_segment_fixed_size 0
func.func @paired_agpr_store_codegen(
    %input: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64,
                waveamdmachine.vgpr_count_max = 16 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %four = wave.constant 4 : i32 -> !wave.simd<i32, 64>
  %input_offset = wave.binary muli %lane, %four
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %input_ptr = wave.ptr_add %input, %input_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %input_regs, %input_ready = wave.load %input_ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %a = waveamd.fragment_pack %input_regs
      : !wave.simd<vector<4xi32>, 64>
      -> !waveamd.fragment<0, i8, 32, 32, 64, 4>
  %b = waveamd.fragment_pack %input_regs
      : !wave.simd<vector<4xi32>, 64>
      -> !waveamd.fragment<1, i8, 32, 32, 64, 4>
  %zero = arith.constant 0 : i32
  %scale_bits = arith.constant 2139062143 : i32
  %scale = wave.splat %scale_bits : i32 -> !wave.simd<i32, 64>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
  %result = waveamd.mma_scale "mfma.scale.f32.32x32x64.f4.f4"
      %a, %scale, %b, %scale, %acc
      {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64}
      : !waveamd.fragment<0, i8, 32, 32, 64, 4>,
        !wave.simd<i32, 64>,
        !waveamd.fragment<1, i8, 32, 32, 64, 4>,
        !wave.simd<i32, 64>,
        !waveamd.fragment<2, f32, 32, 32, 64, 16>
     -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 32, 32, 64, 16>
      -> !wave.simd<vector<16xi32>, 64>
  %scratch = wave.alloc() {align = 16 : i64, bytesize = 4096 : i64}
      : !wave.ptr<#wave.shared, i32>
  %written = wave.scatter %regs to %scratch mapping
      <bit_offset = <"32 * (item + 64 * slot)">>
      bindings []() packet_bindings []() after %input_ready
      : (!wave.simd<vector<16xi32>, 64>, !wave.ptr<#wave.shared, i32>,
         !wave.mem.token)
      -> !wave.mem.token
  %visible = wave.barrier %written
      : (!wave.mem.token) -> !wave.mem.token
  %sixteen = wave.constant 16 : i32 -> !wave.simd<i32, 64>
  %out_lane_offset = wave.binary muli %lane, %sixteen
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>

  %loaded0, %read0 = wave.gather %scratch mapping
      <bit_offset = <"32 * (item + 64 * slot)">>
      bindings []() packet_bindings []() after %visible
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %out_ptr0 = wave.ptr_add %out, %out_lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored0 = wave.store %loaded0 -> %out_ptr0 after %read0
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token

  %c256 = arith.constant 256 : i32
  %scratch1 = wave.ptr_add %scratch, %c256
      : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %loaded1, %read1 = wave.gather %scratch1 mapping
      <bit_offset = <"32 * (item + 64 * slot)">>
      bindings []() packet_bindings []() after %stored0
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %c4 = arith.constant 4 : i32
  %out1 = wave.ptr_add %out, %c4
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %out_ptr1 = wave.ptr_add %out1, %out_lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored1 = wave.store %loaded1 -> %out_ptr1 after %read1
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token

  %c512 = arith.constant 512 : i32
  %scratch2 = wave.ptr_add %scratch, %c512
      : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %loaded2, %read2 = wave.gather %scratch2 mapping
      <bit_offset = <"32 * (item + 64 * slot)">>
      bindings []() packet_bindings []() after %stored1
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %c8 = arith.constant 8 : i32
  %out2 = wave.ptr_add %out, %c8
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %out_ptr2 = wave.ptr_add %out2, %out_lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored2 = wave.store %loaded2 -> %out_ptr2 after %read2
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token

  %c768 = arith.constant 768 : i32
  %scratch3 = wave.ptr_add %scratch, %c768
      : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %loaded3, %read3 = wave.gather %scratch3 mapping
      <bit_offset = <"32 * (item + 64 * slot)">>
      bindings []() packet_bindings []() after %stored2
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %c12 = arith.constant 12 : i32
  %out3 = wave.ptr_add %out, %c12
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %out_ptr3 = wave.ptr_add %out3, %out_lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored3 = wave.store %loaded3 -> %out_ptr3 after %read3
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

}
