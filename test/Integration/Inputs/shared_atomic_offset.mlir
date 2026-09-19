module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @shared_atomic_offset(
    %counters: !wave.ptr<#wave.global>,
    %out: !wave.ptr<#wave.global>, %increment: i32) -> !wave.mem.token attributes {
      wave.kernel,
      wave.workgroup_size = array<i32: WAVE_WIDTH, 1, 1>
    } {
  %root = wave.token : !wave.mem.token
  %lane = wave.lane_id : !wave.simd<i32, WAVE_WIDTH>
  %index_lane = wave.cast intconvert %lane policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, WAVE_WIDTH> -> !wave.simd<index, WAVE_WIDTH>
  %one = wave.constant 4 : index -> !wave.simd<index, WAVE_WIDTH>
  %scaled_lane = wave.binary muli %index_lane, %one overflow<nsw> : !wave.simd<index, WAVE_WIDTH>, !wave.simd<index, WAVE_WIDTH> -> !wave.simd<index, WAVE_WIDTH>
  %offset = wave.binary addi %scaled_lane, %one overflow<nsw> : !wave.simd<index, WAVE_WIDTH>, !wave.simd<index, WAVE_WIDTH> -> !wave.simd<index, WAVE_WIDTH>
  %counter_ptrs = wave.ptr_add %counters, %offset
      : !wave.ptr<#wave.global>, !wave.simd<index, WAVE_WIDTH>
        -> !wave.simd<!wave.ptr<#wave.global>, WAVE_WIDTH>
  %value = wave.splat %increment : i32 -> !wave.simd<i32, WAVE_WIDTH>
  %old, %atomic = waveamd.global_atomic_add_acq_rel
      %value to %counter_ptrs after %root
      : (!wave.simd<!wave.ptr<#wave.global>, WAVE_WIDTH>,
         !wave.simd<i32, WAVE_WIDTH>, !wave.mem.token)
        -> (!wave.simd<i32, WAVE_WIDTH>, !wave.mem.token)
  %out_ptrs = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global>, !wave.simd<index, WAVE_WIDTH>
        -> !wave.simd<!wave.ptr<#wave.global>, WAVE_WIDTH>
  %stored = wave.store %old -> %out_ptrs after %atomic
      : (!wave.simd<i32, WAVE_WIDTH>, !wave.simd<!wave.ptr<#wave.global>, WAVE_WIDTH>,
         !wave.mem.token) -> !wave.mem.token
  return %stored : !wave.mem.token
}

}
