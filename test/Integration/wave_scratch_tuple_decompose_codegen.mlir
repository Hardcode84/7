// RUN: wave-opt --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: scratch_tuple_decompose_codegen:
// ASM: scratch_store_b32 off, v1, s6
// ASM: scratch_store_b32 off, v2, s6 offset:4
// ASM: scratch_store_b32 off, v3, s6 offset:8
// ASM: scratch_store_b32 off, v4, s6 offset:12
// ASM: scratch_load_b32 v5, off, s6 offset:16
// ASM: scratch_load_b32 v6, off, s6 offset:20
// ASM: scratch_load_b32 v7, off, s6 offset:24
// ASM: scratch_load_b32 v8, off, s6 offset:28
// ASM: scratch_store_b32 off, v5, s6 offset:32
func.func @scratch_tuple_decompose_codegen()
    attributes {
      wave.kernel,
      waveamdmachine.private_segment_fixed_size = 36 : i64,
      waveamdmachine.sgpr_count = 7 : i64,
      waveamdmachine.uses_flat_scratch = true
    } {
  %off = waveamdmachine.imm 0 : !waveamdmachine.imm
  %saddr = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 6>
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 1>
  %store = waveamdmachine.scratch_store_tuple_b32 %off, %value, %saddr
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 4, 1>,
         !waveamdmachine.reg<sgpr, 1, 6>) -> !waveamdmachine.mem.token
  %load, %token = waveamdmachine.scratch_load_tuple_b32 %off, %saddr
      after %store offset 16
      : (!waveamdmachine.imm, !waveamdmachine.reg<sgpr, 1, 6>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 4, 5>, !waveamdmachine.mem.token)
  %parts:4 = waveamdmachine.tuple_to_elements %load
      : (!waveamdmachine.reg<vgpr, 4, 5>)
        -> (!waveamdmachine.reg<vgpr, 1, 5>,
            !waveamdmachine.reg<vgpr, 1, 6>,
            !waveamdmachine.reg<vgpr, 1, 7>,
            !waveamdmachine.reg<vgpr, 1, 8>)
  %store2 = waveamdmachine.scratch_store_b32 %off, %parts#0, %saddr
      after %token offset 32
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1, 5>,
         !waveamdmachine.reg<sgpr, 1, 6>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
