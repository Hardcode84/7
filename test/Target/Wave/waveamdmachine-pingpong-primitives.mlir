// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// Primitives the ping-pong transform builds on:
//   - s_barrier   (whole-workgroup checkpoint; gfx<=11)
//   - s_setprio N (issue-arbiter bias, available everywhere)

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ROUND-LABEL: func.func @pingpong_primitives_roundtrip
// ROUND: waveamdmachine.s_setprio %{{.+}} : (!waveamdmachine.imm) -> ()
// ROUND: waveamdmachine.s_barrier
// ROUND: waveamdmachine.s_setprio %{{.+}} : (!waveamdmachine.imm) -> ()

// ASM-LABEL: pingpong_primitives_roundtrip:
// ASM: s_setprio 3
// ASM: s_barrier
// ASM: s_setprio 0
func.func @pingpong_primitives_roundtrip() attributes {wave.kernel} {
  %hi = waveamdmachine.imm 3 : !waveamdmachine.imm
  %lo = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_setprio %hi : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_barrier : () -> ()
  waveamdmachine.s_setprio %lo : (!waveamdmachine.imm) -> ()
  return
}

}
