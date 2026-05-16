// Kernel side of the Wave integration e2e. Compiled by `wave-translate`
// into an AMDGPU assembly blob, then assembled and linked into a HSACO that
// the host file (`wave.mlir`) splices in via `--wave-attach-gpu-binary`.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @write_lane_ids(%dst: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %dst, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>)
      -> !wave.mem.token
  return
}

}
