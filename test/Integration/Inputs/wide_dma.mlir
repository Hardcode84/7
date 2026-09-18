module {
func.func @wide_dma(%base: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %u_raw: i32, %limit: i32)
    -> !wave.mem.token attributes {wave.kernel, wave.lds_size = 256 : i64,
      wave.workgroup_size = array<i32: 64, 1, 1>, wave.waves_per_workgroup = 1 : i64} {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %two = arith.constant 2 : i32
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %u = wave.assume %u_raw as "u" [#wave.pred<"u >= 0">, #wave.pred<"u <= 1023">] : i32
  %start = wave.index_expr <"1073741824*u"> ["u"](%u) : (i32) -> index
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi ult %lane, %vlimit : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %zeros = wave.splat %zero : i32 -> !wave.simd<i32, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %lds_ptr = wave.ptr_add %lds, %lane : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %root = wave.token : !wave.mem.token
  %result:2 = scf.for %row = %zero to %two step %one iter_args(%carry = %start, %token = %root) -> (index, !wave.mem.token) : i32 {
    %bounded = wave.assume %carry as "offset" [#wave.pred<"offset >= 0">] : index
    %offset = wave.index_expr <"offset + lane"> ["offset", "lane"](%bounded, %lane) : (index, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %src = wave.ptr_add %buffer, %offset : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %initialized = wave.store %zeros -> %lds_ptr after %token : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> !wave.mem.token
    %ready = wave.barrier %initialized : (!wave.mem.token) -> !wave.mem.token
    %dma = wave.where %active {
      %read = waveamd.dma_load_lds %src -> %lds after %ready {bytes = 4 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      wave.yield %read : !wave.mem.token
    } otherwise {
      wave.yield %ready : !wave.mem.token
    } : !wave.mask<64> -> !wave.mem.token
    %done = wave.barrier %dma : (!wave.mem.token) -> !wave.mem.token
    %value, %read = wave.load %lds_ptr after %done : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<i32, 64>, !wave.mem.token)
    %out_offset = wave.index_expr <"64*row + lane"> ["row", "lane"](%row, %lane) : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %out_ptr = wave.ptr_add %out, %out_offset : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
    %stored = wave.store %value -> %out_ptr after %read : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
    %next = wave.index_expr <"offset + 64"> ["offset"](%carry) : (index) -> index
    scf.yield %next, %stored : index, !wave.mem.token
  }
  return %result#1 : !wave.mem.token
}
}
