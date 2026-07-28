// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: not grep -w r128 %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

// IR-LABEL: func.func @gfx1250_tdm
// IR: waveamdmachine.s_cselect_b32
// IR: waveamdmachine.tdm_load
// IR: waveamdmachine.tdm_load
// IR: waveamdmachine.s_waitcnt_split tensorcnt(1)
// IR: waveamdmachine.tdm_store
// IR: waveamdmachine.tdm_prefetch
// IR: waveamdmachine.tdm_prefetch
// IR: waveamdmachine.tdm_store

// ASM-LABEL: gfx1250_tdm:
// ASM: s_cselect_b32
// ASM: tensor_load_to_lds {{s\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}
// ASM: tensor_load_to_lds {{s\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}
// ASM: s_wait_tensorcnt 0x1
// ASM: tensor_store_from_lds {{s\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}
// ASM: global_prefetch_b8 {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} scope:SCOPE_SE
// ASM: global_prefetch_b8 {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} th:TH_LOAD_NT scope:SCOPE_SE
// ASM: tensor_store_from_lds {{s\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}
// ASM: s_endpgm

// DIS-LABEL: <gfx1250_tdm>:
// DIS: tensor_load_to_lds
// DIS: tensor_load_to_lds
// DIS: s_wait_tensorcnt 0x1
// DIS: tensor_store_from_lds
// DIS: global_prefetch_b8
// DIS: global_prefetch_b8
// DIS: tensor_store_from_lds

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @gfx1250_tdm(%raw: i32, %alternate: i32, %choose: i1) attributes {
      wave.kernel,
      wave.workgroup_size = array<i32: 32, 1, 1>
    } {
    %d0 = wave.pack %raw, %raw, %raw, %raw
        : i32, i32, i32, i32 -> vector<4xi32>
    %d1 = wave.pack %raw, %raw, %raw, %raw, %raw, %raw, %raw, %raw
        : i32, i32, i32, i32, i32, i32, i32, i32 -> vector<8xi32>
    %d2 = wave.pack %raw, %raw, %raw, %raw
        : i32, i32, i32, i32 -> vector<4xi32>
    %d3 = wave.pack %raw, %raw, %raw, %raw
        : i32, i32, i32, i32 -> vector<4xi32>
    %d0_alt = wave.pack %alternate, %alternate, %alternate, %alternate
        : i32, i32, i32, i32 -> vector<4xi32>
    %d1_alt = wave.pack
        %alternate, %alternate, %alternate, %alternate,
        %alternate, %alternate, %alternate, %alternate
        : i32, i32, i32, i32, i32, i32, i32, i32 -> vector<8xi32>
    %d2_alt = wave.pack %alternate, %alternate, %alternate, %alternate
        : i32, i32, i32, i32 -> vector<4xi32>
    %d3_alt = wave.pack %alternate, %alternate, %alternate, %alternate
        : i32, i32, i32, i32 -> vector<4xi32>
    %d0_selected = wave.select %choose, %d0, %d0_alt : vector<4xi32>
    %d1_selected = wave.select %choose, %d1, %d1_alt : vector<8xi32>
    %d2_selected = wave.select %choose, %d2, %d2_alt : vector<4xi32>
    %d3_selected = wave.select %choose, %d3, %d3_alt : vector<4xi32>
    %offset = wave.lane_id : !wave.simd<i32, 32>
    %root = wave.token : !wave.mem.token
    %first = waveamd.tdm_load d2 %d0, %d1 after %root
        : (vector<4xi32>, vector<8xi32>, !wave.mem.token)
          -> !wave.mem.token
    %issued = wave.issue_token %first
        : !wave.mem.token -> !wave.mem.token
    %second = waveamd.tdm_load d4
        %d0_selected, %d1_selected, %d2_selected, %d3_selected after %issued
        : (vector<4xi32>, vector<8xi32>, !wave.mem.token,
           vector<4xi32>, vector<4xi32>) -> !wave.mem.token
    %stored2 = waveamd.tdm_store d2 %d0, %d1 after %first
        : (vector<4xi32>, vector<8xi32>, !wave.mem.token)
          -> !wave.mem.token
    %prefetched = waveamd.tdm_prefetch regular %d0, %offset after %issued
        : (vector<4xi32>, !wave.simd<i32, 32>, !wave.mem.token)
          -> !wave.mem.token
    %prefetched_spec = waveamd.tdm_prefetch speculative
        %d0, %offset after %prefetched
        : (vector<4xi32>, !wave.simd<i32, 32>, !wave.mem.token)
          -> !wave.mem.token
    %stored4 = waveamd.tdm_store d4
        %d0_selected, %d1_selected, %d2_selected, %d3_selected after %second
        : (vector<4xi32>, vector<8xi32>, !wave.mem.token,
           vector<4xi32>, vector<4xi32>) -> !wave.mem.token
    return
  }
}
