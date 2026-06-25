// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=5 agpr-limit=0' --waveamd-resource-info %s >/dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @compile_multi_wave_lds_pressure()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 128, 1, 1>,
                wave.waves_per_workgroup = 2 : i64,
                wave.lds_size = 0 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %a = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %kill0 = waveamdmachine.v_add_u32 %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %kill1 = waveamdmachine.v_add_u32 %kill0, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %a, %kill1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32 %off, %use, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
