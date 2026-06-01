// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ROUND-LABEL: func.func @shader_cycles_pair
// ROUND: waveamdmachine.s_getreg_shader_cycles : !waveamdmachine.reg<sgpr, 1>
// ROUND: waveamdmachine.s_getreg_shader_cycles : !waveamdmachine.reg<sgpr, 1>

// Two reads must both lower; reassembling the output confirms the
// hwreg encoding (0xF81D) is what llvm-mc expects.
// ASM-LABEL: shader_cycles_pair:
// ASM: s_getreg_b32 s{{[0-9]+}}, hwreg(HW_REG_SHADER_CYCLES)
// ASM: s_getreg_b32 s{{[0-9]+}}, hwreg(HW_REG_SHADER_CYCLES)
func.func @shader_cycles_pair() attributes {wave.kernel} {
  %t0 = waveamdmachine.s_getreg_shader_cycles : !waveamdmachine.reg<sgpr, 1>
  %t1 = waveamdmachine.s_getreg_shader_cycles : !waveamdmachine.reg<sgpr, 1>
  return
}

// wave.read_cycles + wave.splat + wave.store must lower end-to-end:
//   - read_cycles -> s_getreg_b32 hwreg(HW_REG_SHADER_CYCLES) into SGPR
//   - splat is a no-op identity (SGPR stays scalar)
//   - store materializes the SGPR into a VGPR via v_mov_b32 before
//     the buffer_store_b32 (the load-store selector inserts the
//     ensureVGPRForVSrc1 bridge for SGPR-typed store values).
// ASM-LABEL: store_one_cycle:
// ASM: s_getreg_b32 s{{[0-9]+}}, hwreg(HW_REG_SHADER_CYCLES)
// ASM: v_mov_b32_e32 v{{[0-9]+}}, s{{[0-9]+}}
// ASM: buffer_store_b32
func.func @store_one_cycle(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %t = wave.read_cycles : i32
  %t_simd = wave.splat %t : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %t_simd -> %ptrs
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> !wave.mem.token
  return
}

}
