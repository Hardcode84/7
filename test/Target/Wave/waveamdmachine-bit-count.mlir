// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ROUND-LABEL: func.func @bit_count_ops
// ROUND: waveamdmachine.v_ffbh_u32
// ROUND: waveamdmachine.v_ffbl_b32
// ROUND: waveamdmachine.s_flbit_i32_b32
// ROUND: waveamdmachine.s_ff1_i32_b32
// ROUND: waveamdmachine.s_flbit_i32_b64
// ROUND: waveamdmachine.s_ff1_i32_b64

// ASM-LABEL: bit_count_ops:
// ASM-DAG: v_clz_i32_u32_e32 v1, v0
// ASM-DAG: v_ctz_i32_b32_e32 v2, s0
// ASM: s_clz_i32_u32 s4, s0
// ASM-NEXT: s_ctz_i32_b32 s5, s4
// ASM-DAG: s_clz_i32_u64 s6, s[2:3]
// ASM-DAG: s_ctz_i32_b64 s7, s[2:3]
func.func @bit_count_ops(%s32: !waveamdmachine.reg<sgpr, 1, 0>,
                         %s64: !waveamdmachine.reg<sgpr, 2, 2>,
                         %v32: !waveamdmachine.reg<vgpr, 1, 0>)
    -> (!waveamdmachine.reg<vgpr, 1, 1>,
        !waveamdmachine.reg<vgpr, 1, 2>,
        !waveamdmachine.reg<sgpr, 1, 4>,
        !waveamdmachine.reg<sgpr, 1, 5>,
        !waveamdmachine.reg<sgpr, 1, 6>,
        !waveamdmachine.reg<sgpr, 1, 7>) {
  %vclz = waveamdmachine.v_ffbh_u32 %v32
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  %vctz = waveamdmachine.v_ffbl_b32 %s32
      : (!waveamdmachine.reg<sgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 2>
  %sclz32 = waveamdmachine.s_flbit_i32_b32 %s32
      : (!waveamdmachine.reg<sgpr, 1, 0>) -> !waveamdmachine.reg<sgpr, 1, 4>
  %sctz32 = waveamdmachine.s_ff1_i32_b32 %sclz32
      : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.reg<sgpr, 1, 5>
  %sclz64 = waveamdmachine.s_flbit_i32_b64 %s64
      : (!waveamdmachine.reg<sgpr, 2, 2>) -> !waveamdmachine.reg<sgpr, 1, 6>
  %sctz64 = waveamdmachine.s_ff1_i32_b64 %s64
      : (!waveamdmachine.reg<sgpr, 2, 2>) -> !waveamdmachine.reg<sgpr, 1, 7>
  return %vclz, %vctz, %sclz32, %sctz32, %sclz64, %sctz64
      : !waveamdmachine.reg<vgpr, 1, 1>,
        !waveamdmachine.reg<vgpr, 1, 2>,
        !waveamdmachine.reg<sgpr, 1, 4>,
        !waveamdmachine.reg<sgpr, 1, 5>,
        !waveamdmachine.reg<sgpr, 1, 6>,
        !waveamdmachine.reg<sgpr, 1, 7>
}

}
