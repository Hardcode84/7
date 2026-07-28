// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: llvm-objdump -D -j .rodata --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=KD
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: llvm-readobj --notes %t.hsaco \
// RUN:   | FileCheck %s --check-prefix=META
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.hsaco \
// RUN:   | FileCheck %s --check-prefix=DIS

// IR-LABEL: func.func @gfx1250_pressure(
// IR-SAME: waveamdmachine.regalloc_assignments
// IR-SAME: waveamdmachine.vgpr_count = [[HIGH_VGPRS:(2(5[6-9]|[6-9][0-9])|[3-9][0-9][0-9]|[1-9][0-9][0-9][0-9]+)]] : i64
// IR: !waveamdmachine.reg<vgpr, 4, [[HIGH_BASE:(2(5[6-9]|[6-9][0-9])|[3-9][0-9][0-9]|[1-9][0-9][0-9][0-9]+)]]>

// ASM-LABEL: gfx1250_pressure:
// ASM: s_set_vgpr_msb [[HIGH_MODE:(0x[1-9a-f][0-9a-f]*|[1-9][0-9]*)]]
// ASM-NEXT: buffer_load_b128
// ASM: s_set_vgpr_msb [[BASE_MODE:(0x[1-9a-f][0-9a-f]*|[1-9][0-9]*)]]
// ASM-NEXT: s_cbranch_execz [[ELSE:.+]]
// ASM-NEXT: s_set_vgpr_msb [[HIGH_MODE]]
// ASM: buffer_store_b128
// ASM: s_set_vgpr_msb [[BASE_MODE]]
// ASM-NEXT: [[ELSE]]:
// ASM: s_cbranch_execz [[ENDIF:.+]]
// ASM-NOT: s_set_vgpr_msb
// ASM: buffer_store_b128
// ASM-NOT: s_set_vgpr_msb
// ASM: [[ENDIF]]:
// ASM-NOT: s_set_vgpr_msb
// ASM: buffer_store_b128
// ASM: s_set_vgpr_msb [[HIGH_MODE]]
// ASM: buffer_store_b128
// ASM: s_set_vgpr_msb [[BASE_MODE]]
// ASM: buffer_store_b128
// ASM: .amdhsa_next_free_vgpr [[ASM_VGPRS:(2(5[6-9]|[6-9][0-9])|[3-9][0-9][0-9]|[1-9][0-9][0-9][0-9]+)]]
// ASM: .vgpr_count: [[ASM_VGPRS]]
// ASM: wave.regalloc.iterations: 1
// ASM: wave.regalloc.scratch.dwords: 0

// KD-LABEL: <gfx1250_pressure.kd>:
// KD: .amdhsa_next_free_vgpr {{(2(5[6-9]|[6-9][0-9])|[3-9][0-9][0-9]|[1-9][0-9][0-9][0-9]+)}}

// META: .name: gfx1250_pressure
// META: .vgpr_count: [[META_VGPRS:(2(5[6-9]|[6-9][0-9])|[3-9][0-9][0-9]|[1-9][0-9][0-9][0-9]+)]]
// META: amdhsa.target: amdgcn-amd-amdhsa--gfx1250

// DIS-LABEL: <gfx1250_pressure>:
// DIS: s_set_vgpr_msb [[DIS_HIGH_MODE:(0x[1-9a-f][0-9a-f]*|[1-9][0-9]*)]]
// DIS: buffer_load_b128
// DIS: s_set_vgpr_msb [[DIS_BASE_MODE:(0x[1-9a-f][0-9a-f]*|[1-9][0-9]*)]]
// DIS: s_cbranch_execz
// DIS: s_set_vgpr_msb [[DIS_HIGH_MODE]]
// DIS: buffer_store_b128
// DIS: s_set_vgpr_msb [[DIS_BASE_MODE]]

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @gfx1250_pressure(
    %src0: !wave.ptr<#wave.global, i32>,
    %src1: !wave.ptr<#wave.global, i32>,
    %src2: !wave.ptr<#wave.global, i32>,
    %dst0: !wave.ptr<#wave.global, i32>,
    %dst1: !wave.ptr<#wave.global, i32>,
    %dst2: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 32, 1, 1>,
                wave.waves_per_workgroup = 1 : i64,
                waveamdmachine.target_waves = 1 : i64} {
  %range = arith.constant 1048576 : i32
  %buffer = waveamd.make_buffer %src0, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %limit_scalar = arith.constant 16 : i32
  %limit = wave.splat %limit_scalar : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src_ptr0 = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %src_ptr1 = wave.ptr_add %src1, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %src_ptr2 = wave.ptr_add %src2, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %dst_ptr0 = wave.ptr_add %dst0, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %dst_ptr1 = wave.ptr_add %dst1, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %dst_ptr2 = wave.ptr_add %dst2, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value0, %loaded0 = wave.load %src_ptr0
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> (!wave.simd<vector<128xi32>, 32>, !wave.mem.token)
  %value1, %loaded1 = wave.load %src_ptr1
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<vector<128xi32>, 32>, !wave.mem.token)
  %value2, %loaded2 = wave.load %src_ptr2
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<vector<128xi32>, 32>, !wave.mem.token)
  %loaded = wave.join %loaded0, %loaded1, %loaded2
      : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %conditional = wave.where %active {
    %then = wave.store %value2 -> %dst_ptr2 after %loaded
        : (!wave.simd<vector<128xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield %then : !wave.mem.token
  } otherwise {
    %else = wave.store %value0 -> %dst_ptr0 after %loaded
        : (!wave.simd<vector<128xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield %else : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %stored1 = wave.store %value1 -> %dst_ptr1 after %conditional
      : (!wave.simd<vector<128xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  %stored2 = wave.store %value2 -> %dst_ptr2 after %stored1
      : (!wave.simd<vector<128xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  %stored0 = wave.store %value0 -> %dst_ptr0 after %stored2
      : (!wave.simd<vector<128xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}
