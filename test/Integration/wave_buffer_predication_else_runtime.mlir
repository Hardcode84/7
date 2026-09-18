// REQUIRES: host-supports-amdgpu-wave
// RUN: sed -e 's/@W@/%wave_width/g' -e 's/@BYTES@/%wave_bytes/g' %s \
// RUN:   | wave-opt - --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},waveamd-lower-buffer-predication,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner --shared-libs=%mlir_rocm_runtime --shared-libs=%mlir_runner_utils --shared-libs=%wave_runtime --entry-point-result=void

module attributes {gpu.container_module} {
gpu.module @kernels {
func.func @computed_fallback(
    %base: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %limit: i32)
    -> !wave.mem.token attributes {gpu.kernel, wave.kernel} {
  %range = arith.constant @BYTES@ : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, @W@>
  %active = wave.cmpi slt %lane, %vlimit : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.mask<@W@>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token)
        -> (!wave.simd<i32, @W@>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<i32, @W@>, !wave.mem.token
  } otherwise {
    %else_value = wave.binary addi %lane, %lane : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
    wave.yield %else_value, %dependency : !wave.simd<i32, @W@>, !wave.mem.token
  } : !wave.mask<@W@> -> !wave.simd<i32, @W@>, !wave.mem.token
  %out_buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %out_ptr = wave.ptr_add %out_buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
  %done = wave.store %result#0 -> %out_ptr after %result#1 : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
  return %done : !wave.mem.token
}

}

func.func private @wave_memref_to_ptr_global_i32(memref<@W@xi32>)
    -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func @check(%src: !wave.ptr<#wave.global, i32>,
                 %dst: !wave.ptr<#wave.global, i32>,
                 %output: memref<@W@xi32>, %limit: i32) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cw = arith.constant @W@ : index
  %bias = arith.constant 100 : i32
  %sentinel = arith.constant -1 : i32
  scf.for %i = %c0 to %cw step %c1 {
    memref.store %sentinel, %output[%i] : memref<@W@xi32>
  }
  gpu.launch_func @kernels::@computed_fallback
      blocks in (%c1, %c1, %c1) threads in (%cw, %c1, %c1)
      args(%src : !wave.ptr<#wave.global, i32>,
           %dst : !wave.ptr<#wave.global, i32>, %limit : i32)
  scf.for %i = %c0 to %cw step %c1 {
    %lane = arith.index_cast %i : index to i32
    %active = arith.cmpi slt, %lane, %limit : i32
    %loaded = arith.addi %bias, %lane : i32
    %fallback = arith.addi %lane, %lane : i32
    %expected = arith.select %active, %loaded, %fallback : i32
    %actual = memref.load %output[%i] : memref<@W@xi32>
    %equal = arith.cmpi eq, %actual, %expected : i32
    cf.assert %equal, "computed buffer fallback mismatch"
  }
  return
}

func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cw = arith.constant @W@ : index
  %bias = arith.constant 100 : i32
  %none = arith.constant 0 : i32
  %mixed = arith.constant 8 : i32
  %all = arith.constant @W@ : i32
  %source = memref.alloc() : memref<@W@xi32>
  %output = memref.alloc() : memref<@W@xi32>
  scf.for %i = %c0 to %cw step %c1 {
    %lane = arith.index_cast %i : index to i32
    %value = arith.addi %bias, %lane : i32
    memref.store %value, %source[%i] : memref<@W@xi32>
  }
  %src_unranked = memref.cast %source : memref<@W@xi32> to memref<*xi32>
  %out_unranked = memref.cast %output : memref<@W@xi32> to memref<*xi32>
  gpu.host_register %src_unranked : memref<*xi32>
  gpu.host_register %out_unranked : memref<*xi32>
  %src = func.call @wave_memref_to_ptr_global_i32(%source)
      : (memref<@W@xi32>) -> !wave.ptr<#wave.global, i32>
  %dst = func.call @wave_memref_to_ptr_global_i32(%output)
      : (memref<@W@xi32>) -> !wave.ptr<#wave.global, i32>
  func.call @check(%src, %dst, %output, %none)
      : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>,
         memref<@W@xi32>, i32) -> ()
  func.call @check(%src, %dst, %output, %mixed)
      : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>,
         memref<@W@xi32>, i32) -> ()
  func.call @check(%src, %dst, %output, %all)
      : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>,
         memref<@W@xi32>, i32) -> ()
  gpu.host_unregister %src_unranked : memref<*xi32>
  gpu.host_unregister %out_unranked : memref<*xi32>
  memref.dealloc %source : memref<@W@xi32>
  memref.dealloc %output : memref<@W@xi32>
  return
}
}
