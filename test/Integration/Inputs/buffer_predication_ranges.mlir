// Inactive DMA lanes may retain or write zero; initialize LDS before issue.
module attributes {gpu.container_module} {
gpu.module @kernels {
func.func @buffer_ranges(
    %base: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %limit: i32)
    -> !wave.mem.token attributes {gpu.kernel, wave.kernel, wave.lds_size = 256 : i64} {
  %range = arith.constant @RANGE@ : @RT@
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, @RT@ -> !wave.ptr<#waveamd.buffer, i32>
  %out_buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, @RT@ -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, @W@>
  %active = wave.cmpi ult %lane, %vlimit : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>
  %scalar_zero = wave.constant 0 : i32
  %zero = wave.splat %scalar_zero : i32 -> !wave.simd<i32, @W@>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token)
        -> (!wave.simd<i32, @W@>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<i32, @W@>, !wave.mem.token
  } otherwise {
    wave.yield %zero, %dependency : !wave.simd<i32, @W@>, !wave.mem.token
  } : !wave.mask<@W@> -> !wave.simd<i32, @W@>, !wave.mem.token
  %out_ptr = wave.ptr_add %out_buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
  %loaded = wave.store %result#0 -> %out_ptr after %result#1 : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
  %stride = arith.constant @W@ : index
  %shifted = wave.ptr_add %out_buffer, %stride : !wave.ptr<#waveamd.buffer, i32>, index -> !wave.ptr<#waveamd.buffer, i32>
  %byte_shifted = wave.ptr_cast %shifted : !wave.ptr<#waveamd.buffer, i32> -> !wave.ptr<#waveamd.buffer, i8>
  %store_base = wave.ptr_cast %byte_shifted : !wave.ptr<#waveamd.buffer, i8> -> !wave.ptr<#waveamd.buffer, i32>
  %store_ptr = wave.ptr_add %store_base, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
  %stored = wave.where %active {
    %token = wave.store %lane -> %store_ptr after %loaded : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %loaded : !wave.mem.token
  } : !wave.mask<@W@> -> !wave.mem.token
  // DMA-BEGIN
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %lds_ptr = wave.ptr_add %lds, %lane : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, @W@> -> !wave.simd<!wave.ptr<#wave.shared, i32>, @W@>
  %initialized = wave.store %zero -> %lds_ptr after %stored : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#wave.shared, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
  %ready = wave.barrier %initialized : (!wave.mem.token) -> !wave.mem.token
  %dma = wave.where %active {
    %token = waveamd.dma_load_lds %ptr -> %lds after %ready {bytes = 4 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %ready : !wave.mem.token
  } : !wave.mask<@W@> -> !wave.mem.token
  %complete = wave.barrier %dma : (!wave.mem.token) -> !wave.mem.token
  %dma_value, %read = wave.load %lds_ptr after %complete : (!wave.simd<!wave.ptr<#wave.shared, i32>, @W@>, !wave.mem.token) -> (!wave.simd<i32, @W@>, !wave.mem.token)
  %dma_base = wave.ptr_add %store_base, %stride : !wave.ptr<#waveamd.buffer, i32>, index -> !wave.ptr<#waveamd.buffer, i32>
  %dma_ptr = wave.ptr_add %dma_base, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
  %done = wave.store %dma_value -> %dma_ptr after %read : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
  // DMA-END
  return %@FINAL@ : !wave.mem.token
}
}

func.func private @wave_memref_to_ptr_global_i32(memref<@OUT@xi32>)
    -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func @check(%src: !wave.ptr<#wave.global, i32>,
                 %dst: !wave.ptr<#wave.global, i32>,
                 %output: memref<@OUT@xi32>, %limit: i32) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cw = arith.constant @W@ : index
  %cout = arith.constant @OUT@ : index
  %bias = arith.constant 100 : i32
  %sentinel = arith.constant -1 : i32
  scf.for %i = %c0 to %cout step %c1 {
    memref.store %sentinel, %output[%i] : memref<@OUT@xi32>
  }
  gpu.launch_func @kernels::@buffer_ranges
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%src : !wave.ptr<#wave.global, i32>,
           %dst : !wave.ptr<#wave.global, i32>, %limit : i32)
  scf.for %i = %c0 to %cw step %c1 {
    %lane = arith.index_cast %i : index to i32
    %active = arith.cmpi slt, %lane, %limit : i32
    %loaded = arith.addi %bias, %lane : i32
    %fallback = arith.constant 0 : i32
    %expected = arith.select %active, %loaded, %fallback : i32
    %actual = memref.load %output[%i] : memref<@OUT@xi32>
    %equal = arith.cmpi eq, %actual, %expected : i32
    cf.assert %equal, "inactive buffer load did not return zero"
    %store_index = arith.addi %i, %cw : index
    %stored = memref.load %output[%store_index] : memref<@OUT@xi32>
    %store_expected = arith.select %active, %lane, %sentinel : i32
    %store_equal = arith.cmpi eq, %stored, %store_expected : i32
    cf.assert %store_equal, "inactive buffer store changed memory"
    // DMA-BEGIN
    %dma_index = arith.addi %store_index, %cw : index
    %dma = memref.load %output[%dma_index] : memref<@OUT@xi32>
    %dma_equal = arith.cmpi eq, %dma, %expected : i32
    cf.assert %dma_equal, "inactive buffer DMA changed zero-filled LDS"
    // DMA-END
  }
  return
}

func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cw = arith.constant @W@ : index
  %cout = arith.constant @OUT@ : index
  %bias = arith.constant 100 : i32
  %none = arith.constant 0 : i32
  %mixed = arith.constant 8 : i32
  %all = arith.constant @W@ : i32
  %source = memref.alloc() : memref<@OUT@xi32>
  %output = memref.alloc() : memref<@OUT@xi32>
  scf.for %i = %c0 to %cw step %c1 {
    %lane = arith.index_cast %i : index to i32
    %value = arith.addi %bias, %lane : i32
    memref.store %value, %source[%i] : memref<@OUT@xi32>
  }
  %src_unranked = memref.cast %source : memref<@OUT@xi32> to memref<*xi32>
  %out_unranked = memref.cast %output : memref<@OUT@xi32> to memref<*xi32>
  gpu.host_register %src_unranked : memref<*xi32>
  gpu.host_register %out_unranked : memref<*xi32>
  %src = func.call @wave_memref_to_ptr_global_i32(%source)
      : (memref<@OUT@xi32>) -> !wave.ptr<#wave.global, i32>
  %dst = func.call @wave_memref_to_ptr_global_i32(%output)
      : (memref<@OUT@xi32>) -> !wave.ptr<#wave.global, i32>
  func.call @check(%src, %dst, %output, %none)
      : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>,
         memref<@OUT@xi32>, i32) -> ()
  func.call @check(%src, %dst, %output, %mixed)
      : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>,
         memref<@OUT@xi32>, i32) -> ()
  func.call @check(%src, %dst, %output, %all)
      : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>,
         memref<@OUT@xi32>, i32) -> ()
  gpu.host_unregister %src_unranked : memref<*xi32>
  gpu.host_unregister %out_unranked : memref<*xi32>
  memref.dealloc %source : memref<@OUT@xi32>
  memref.dealloc %output : memref<@OUT@xi32>
  return
}
}
