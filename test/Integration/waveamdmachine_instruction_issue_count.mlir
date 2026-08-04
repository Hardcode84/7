// RUN: wave-sim-report --func=expanded_salu --timeline %s | FileCheck %s --check-prefix=EXPAND
// RUN: wave-sim-report --func=wide_smem --timeline %s | FileCheck %s --check-prefix=SMEM
// RUN: wave-sim-report --func=vcc_restore_spacing --arch=gfx1100 --wave-size=32 --timeline %s | FileCheck %s --check-prefix=VCC-W32
// RUN: wave-sim-report --func=vcc_restore_spacing --arch=gfx1100 --wave-size=64 --timeline %s | FileCheck %s --check-prefix=VCC-W64

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @expanded_salu(%base: !waveamdmachine.reg<sgpr, 2>,
                           %offset: !waveamdmachine.reg<sgpr, 1>,
                           %value: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %sum:2 = waveamdmachine.s_add_u64_u32 %base, %offset
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
    %next:2 = waveamdmachine.s_add_i32 %value, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @wide_smem(%value: !waveamdmachine.reg<sgpr, 1>) {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %loaded = waveamdmachine.s_load_b64 %zero, "s[0:1]"
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
    %next:2 = waveamdmachine.s_add_i32 %value, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @vcc_restore_spacing(
      %flag: !waveamdmachine.reg<sgpr, 1>,
      %value: !waveamdmachine.reg<sgpr, 1>) {
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %restored = waveamdmachine.s_mov_vcc_b32 %flag
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vcc, 1>
    %next:2 = waveamdmachine.s_add_i32 %value, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }
}

// EXPAND-LABEL: func: expanded_salu
// EXPAND: issue cycle=0 fu=SALU op=waveamdmachine.s_add_u64_u32
// EXPAND: issue cycle=8 fu=SALU op=waveamdmachine.s_add_i32

// SMEM-LABEL: func: wide_smem
// SMEM: issue cycle=0 fu=LGKM op=waveamdmachine.s_load_b64
// SMEM: issue cycle=4 fu=SALU op=waveamdmachine.s_add_i32
// SMEM-DAG: counter_drained cycle=5 fu=LGKM counter=lgkm op=waveamdmachine.s_load_b64
// SMEM-DAG: counter_drained cycle=9 fu=LGKM counter=lgkm op=waveamdmachine.s_load_b64

// VCC-W32-LABEL: func: vcc_restore_spacing
// VCC-W32: wave_size: 32
// VCC-W32: issue cycle=0 fu=SALU op=waveamdmachine.s_mov_vcc_b32
// VCC-W32: issue cycle=1 fu=SALU op=waveamdmachine.s_add_i32

// VCC-W64-LABEL: func: vcc_restore_spacing
// VCC-W64: wave_size: 64
// VCC-W64: issue cycle=0 fu=SALU op=waveamdmachine.s_mov_vcc_b32
// VCC-W64: issue cycle=4 fu=SALU op=waveamdmachine.s_add_i32
