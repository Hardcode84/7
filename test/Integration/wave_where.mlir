// REQUIRES: host-supports-amdgpu-wave
//
// Masked store/load leave inactive lanes at sentinel.
//
// RUN: sed -e 's/@W@/%wave_width/g' -e 's/@BYTES@/%wave_bytes/g' %s \
// RUN:   | wave-opt - --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s --check-prefix=W%wave_width

module attributes {gpu.container_module} {

gpu.module @kernels {
  func.func @write_under_mask(%dst: !wave.ptr<#wave.global, i32>, %limit: i32)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant @BYTES@ : i32
    %buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %lane = wave.lane_id : !wave.simd<i32, @W@>
    %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, @W@>
    %active = wave.cmpi ult %lane, %vlimit
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>
    %ptrs = wave.ptr_add %buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    wave.where %active {
      %tok = wave.store %lane -> %ptrs
          : (!wave.simd<i32, @W@>,
             !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>)
          -> !wave.mem.token
      wave.yield
    } : !wave.mask<@W@>
    return
  }

  func.func @load_under_mask(%src: !wave.ptr<#wave.global, i32>,
                             %dst: !wave.ptr<#wave.global, i32>,
                             %limit: i32)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant @BYTES@ : i32
    %src_buffer = waveamd.make_buffer %src, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %dst_buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %lane = wave.lane_id : !wave.simd<i32, @W@>
    %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, @W@>
    %active = wave.cmpi ult %lane, %vlimit
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>
    %src_ptrs = wave.ptr_add %src_buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    %dst_ptrs = wave.ptr_add %dst_buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    %loaded, %load_token = wave.where %active {
      %value, %token = wave.load %src_ptrs
          : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>)
          -> (!wave.simd<i32, @W@>, !wave.mem.token)
      wave.yield %value, %token : !wave.simd<i32, @W@>, !wave.mem.token
    } : !wave.mask<@W@> -> !wave.simd<i32, @W@>, !wave.mem.token
    wave.where %active {
      %store_token = wave.store %loaded -> %dst_ptrs after %load_token
          : (!wave.simd<i32, @W@>,
             !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>,
             !wave.mem.token)
          -> !wave.mem.token
      wave.yield
    } : !wave.mask<@W@>
    return
  }

  func.func @load_then_store_otherwise(%src: !wave.ptr<#wave.global, i32>,
                                       %dst: !wave.ptr<#wave.global, i32>,
                                       %limit: i32)
      attributes {gpu.kernel, wave.kernel} {
    %range = arith.constant @BYTES@ : i32
    %fallback_scalar = arith.constant 5 : i32
    %src_buffer = waveamd.make_buffer %src, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %dst_buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %lane = wave.lane_id : !wave.simd<i32, @W@>
    %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, @W@>
    %active = wave.cmpi ult %lane, %vlimit
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>
    %src_ptrs = wave.ptr_add %src_buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    %dst_ptrs = wave.ptr_add %dst_buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    %loaded, %load_token = wave.where %active {
      %value, %token = wave.load %src_ptrs
          : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>)
          -> (!wave.simd<i32, @W@>, !wave.mem.token)
      wave.yield %value, %token : !wave.simd<i32, @W@>, !wave.mem.token
    } : !wave.mask<@W@> -> !wave.simd<i32, @W@>, !wave.mem.token
    %store_token = wave.where %active {
      %token = wave.store %loaded -> %dst_ptrs after %load_token
          : (!wave.simd<i32, @W@>,
             !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>,
             !wave.mem.token)
          -> !wave.mem.token
      wave.yield %token : !wave.mem.token
    } otherwise {
      %fallback = wave.splat %fallback_scalar : i32 -> !wave.simd<i32, @W@>
      %token = wave.store %fallback -> %dst_ptrs
          : (!wave.simd<i32, @W@>,
             !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>)
          -> !wave.mem.token
      wave.yield %token : !wave.mem.token
    } : !wave.mask<@W@> -> !wave.mem.token
    wave.wait %store_token : !wave.mem.token
    return
  }

  func.func @masked_load_other_global_f32(
      %src: !wave.ptr<#wave.global, f32>, %dst: !wave.ptr<#wave.global, f32>,
      %limit: i32) attributes {gpu.kernel, wave.kernel} {
    %cw_i32 = arith.constant @W@ : i32
    %five = arith.constant 5.000000e+00 : f32
    %pid = wave.workgroup_id 0
    %base = wave.binary muli %pid, %cw_i32 : i32, i32 -> i32
    %vbase = wave.splat %base : i32 -> !wave.simd<i32, @W@>
    %lane = wave.lane_id : !wave.simd<i32, @W@>
    %idx = wave.binary addi %vbase, %lane
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
    %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, @W@>
    %active = wave.cmpi ult %idx, %vlimit
        : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>
    %off = wave.index_expr <"lid + cw*pid"> ["pid", "cw", "lid"](%pid, %cw_i32, %lane)
        : (i32, i32, !wave.simd<i32, @W@>) -> !wave.simd<index, @W@>
    %src_ptrs = wave.ptr_add %src, %off
        : !wave.ptr<#wave.global, f32>, !wave.simd<index, @W@>
        -> !wave.simd<!wave.ptr<#wave.global, f32>, @W@>
    %dst_ptrs = wave.ptr_add %dst, %off
        : !wave.ptr<#wave.global, f32>, !wave.simd<index, @W@>
        -> !wave.simd<!wave.ptr<#wave.global, f32>, @W@>
    %loaded, %load_token = wave.where %active {
      %value, %token = wave.load %src_ptrs
          : (!wave.simd<!wave.ptr<#wave.global, f32>, @W@>)
          -> (!wave.simd<f32, @W@>, !wave.mem.token)
      wave.yield %value, %token : !wave.simd<f32, @W@>, !wave.mem.token
    } : !wave.mask<@W@> -> !wave.simd<f32, @W@>, !wave.mem.token
    %store_token = wave.where %active {
      %token = wave.store %loaded -> %dst_ptrs after %load_token
          : (!wave.simd<f32, @W@>,
             !wave.simd<!wave.ptr<#wave.global, f32>, @W@>,
             !wave.mem.token)
          -> !wave.mem.token
      wave.yield %token : !wave.mem.token
    } otherwise {
      %fallback = wave.splat %five : f32 -> !wave.simd<f32, @W@>
      %token = wave.store %fallback -> %dst_ptrs
          : (!wave.simd<f32, @W@>,
             !wave.simd<!wave.ptr<#wave.global, f32>, @W@>)
          -> !wave.mem.token
      wave.yield %token : !wave.mem.token
    } : !wave.mask<@W@> -> !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<@W@xi32>)
    -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func private @wave_memref_to_ptr_global_f32(memref<?xf32>)
    -> !wave.ptr<#wave.global, f32> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

func.func private @printMemrefF32(memref<*xf32>)
    attributes {llvm.emit_c_interface}

// W32: [0, 1, 2, 3, 4, 5, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
// W32: [100, 101, 102, 103, 104, 105, 106, 107, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
// W32: [100, 101, 102, 103, 104, 105, 106, 107, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
// W64: [0, 1, 2, 3, 4, 5, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
// W64: [100, 101, 102, 103, 104, 105, 106, 107, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
// W64: [100, 101, 102, 103, 104, 105, 106, 107, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
// W32: 5, 5, 5, 5, 5, 5, 5, 5
// W32: 100, 101, 102, 103{{.*}}128, 129, 130, 131{{.*}}5, 5, 5, 5
// W32: 100, 101, 102, 103{{.*}}141, 142, 143, 144{{.*}}5, 5, 5, 5
// W64: 5, 5, 5, 5, 5, 5, 5, 5
// W64: 100, 101, 102, 103{{.*}}128, 129, 130, 131{{.*}}5, 5, 5, 5
// W64: 100, 101, 102, 103{{.*}}141, 142, 143, 144{{.*}}5, 5, 5, 5
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c0_i32 = arith.constant 0 : i32
  %c32_i32 = arith.constant 32 : i32
  %c45_i32 = arith.constant 45 : i32
  %cw = arith.constant @W@ : index
  %fsize = arith.muli %cw, %c2 : index
  %limit = arith.constant 8 : i32
  %bias = arith.constant 100 : i32
  %sentinel = arith.constant -1 : i32
  %fallback_f32 = arith.constant -1.000000e+00 : f32

  %storage = memref.alloc() : memref<@W@xi32>
  %src_storage = memref.alloc() : memref<@W@xi32>
  %load_storage = memref.alloc() : memref<@W@xi32>
  %otherwise_storage = memref.alloc() : memref<@W@xi32>
  %f32_src = memref.alloc(%fsize) : memref<?xf32>
  %f32_limit0 = memref.alloc(%fsize) : memref<?xf32>
  %f32_limit32 = memref.alloc(%fsize) : memref<?xf32>
  %f32_limit45 = memref.alloc(%fsize) : memref<?xf32>
  scf.for %i = %c0 to %cw step %c1 {
    %iv = arith.index_cast %i : index to i32
    %src_value = arith.addi %bias, %iv : i32
    memref.store %sentinel, %storage[%i] : memref<@W@xi32>
    memref.store %src_value, %src_storage[%i] : memref<@W@xi32>
    memref.store %sentinel, %load_storage[%i] : memref<@W@xi32>
    memref.store %sentinel, %otherwise_storage[%i] : memref<@W@xi32>
  }
  scf.for %i = %c0 to %fsize step %c1 {
    %iv = arith.index_cast %i : index to i32
    %src_i32 = arith.addi %bias, %iv : i32
    %src_f32 = arith.sitofp %src_i32 : i32 to f32
    memref.store %src_f32, %f32_src[%i] : memref<?xf32>
    memref.store %fallback_f32, %f32_limit0[%i] : memref<?xf32>
    memref.store %fallback_f32, %f32_limit32[%i] : memref<?xf32>
    memref.store %fallback_f32, %f32_limit45[%i] : memref<?xf32>
  }

  %unranked = memref.cast %storage : memref<@W@xi32> to memref<*xi32>
  %src_unranked = memref.cast %src_storage : memref<@W@xi32> to memref<*xi32>
  %load_unranked = memref.cast %load_storage : memref<@W@xi32> to memref<*xi32>
  %otherwise_unranked = memref.cast %otherwise_storage
      : memref<@W@xi32> to memref<*xi32>
  %f32_src_unranked = memref.cast %f32_src : memref<?xf32> to memref<*xf32>
  %f32_limit0_unranked = memref.cast %f32_limit0 : memref<?xf32> to memref<*xf32>
  %f32_limit32_unranked = memref.cast %f32_limit32 : memref<?xf32> to memref<*xf32>
  %f32_limit45_unranked = memref.cast %f32_limit45 : memref<?xf32> to memref<*xf32>
  gpu.host_register %unranked : memref<*xi32>
  gpu.host_register %src_unranked : memref<*xi32>
  gpu.host_register %load_unranked : memref<*xi32>
  gpu.host_register %otherwise_unranked : memref<*xi32>
  gpu.host_register %f32_src_unranked : memref<*xf32>
  gpu.host_register %f32_limit0_unranked : memref<*xf32>
  gpu.host_register %f32_limit32_unranked : memref<*xf32>
  gpu.host_register %f32_limit45_unranked : memref<*xf32>

  %p = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<@W@xi32>) -> !wave.ptr<#wave.global, i32>
  %src_p = func.call @wave_memref_to_ptr_global_i32(%src_storage)
      : (memref<@W@xi32>) -> !wave.ptr<#wave.global, i32>
  %load_p = func.call @wave_memref_to_ptr_global_i32(%load_storage)
      : (memref<@W@xi32>) -> !wave.ptr<#wave.global, i32>
  %otherwise_p = func.call @wave_memref_to_ptr_global_i32(%otherwise_storage)
      : (memref<@W@xi32>) -> !wave.ptr<#wave.global, i32>
  %f32_src_p = func.call @wave_memref_to_ptr_global_f32(%f32_src)
      : (memref<?xf32>) -> !wave.ptr<#wave.global, f32>
  %f32_limit0_p = func.call @wave_memref_to_ptr_global_f32(%f32_limit0)
      : (memref<?xf32>) -> !wave.ptr<#wave.global, f32>
  %f32_limit32_p = func.call @wave_memref_to_ptr_global_f32(%f32_limit32)
      : (memref<?xf32>) -> !wave.ptr<#wave.global, f32>
  %f32_limit45_p = func.call @wave_memref_to_ptr_global_f32(%f32_limit45)
      : (memref<?xf32>) -> !wave.ptr<#wave.global, f32>

  gpu.launch_func @kernels::@write_under_mask
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%p : !wave.ptr<#wave.global, i32>, %limit : i32)
  gpu.launch_func @kernels::@load_under_mask
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%src_p : !wave.ptr<#wave.global, i32>,
           %load_p : !wave.ptr<#wave.global, i32>,
           %limit : i32)
  gpu.launch_func @kernels::@load_then_store_otherwise
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%src_p : !wave.ptr<#wave.global, i32>,
           %otherwise_p : !wave.ptr<#wave.global, i32>,
           %limit : i32)
  gpu.launch_func @kernels::@masked_load_other_global_f32
      blocks in (%c2, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%f32_src_p : !wave.ptr<#wave.global, f32>,
           %f32_limit0_p : !wave.ptr<#wave.global, f32>,
           %c0_i32 : i32)
  gpu.launch_func @kernels::@masked_load_other_global_f32
      blocks in (%c2, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%f32_src_p : !wave.ptr<#wave.global, f32>,
           %f32_limit32_p : !wave.ptr<#wave.global, f32>,
           %c32_i32 : i32)
  gpu.launch_func @kernels::@masked_load_other_global_f32
      blocks in (%c2, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%f32_src_p : !wave.ptr<#wave.global, f32>,
           %f32_limit45_p : !wave.ptr<#wave.global, f32>,
           %c45_i32 : i32)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  func.call @printMemrefI32(%load_unranked) : (memref<*xi32>) -> ()
  func.call @printMemrefI32(%otherwise_unranked) : (memref<*xi32>) -> ()
  func.call @printMemrefF32(%f32_limit0_unranked) : (memref<*xf32>) -> ()
  func.call @printMemrefF32(%f32_limit32_unranked) : (memref<*xf32>) -> ()
  func.call @printMemrefF32(%f32_limit45_unranked) : (memref<*xf32>) -> ()
  return
}

}
