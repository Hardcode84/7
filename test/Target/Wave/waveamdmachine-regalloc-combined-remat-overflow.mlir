// RUN: wave-opt --verify-diagnostics --waveamd-reg-alloc %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// expected-error @below {{VGPR/AGPR live pressure exceeds target-waves budget}}
func.func @combined_pressure_remat_temps_can_overflow()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
  %base_lo = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %base_hi = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.tuple_from_elements %base_lo, %base_hi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2>
  %offset_lo = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %offset_hi = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %offset = waveamdmachine.tuple_from_elements %offset_lo, %offset_hi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2>
  %addr, %vcc = waveamdmachine.v_add_u64 %base, %offset
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %u0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u1 = waveamdmachine.v_add_u32 %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u2 = waveamdmachine.v_add_u32 %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u3 = waveamdmachine.v_add_u32 %u0, %u1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u4 = waveamdmachine.v_add_u32 %u2, %v6
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u5 = waveamdmachine.v_add_u32 %u3, %u4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr_parts:2 = waveamdmachine.tuple_to_elements %addr
      : (!waveamdmachine.reg<vgpr, 2>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %u6 = waveamdmachine.v_add_u32 %u5, %addr_parts#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 120>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 60>)
  waveamdmachine.s_endpgm
  return
}

}
