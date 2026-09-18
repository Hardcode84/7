// REQUIRES: host-supports-amdgpu-wave, wave-python-bindings
// RUN: sed -e 's/@W@/%wave_width/g' -e 's/@OUT@/%wave_bytes/g' %s | wave-opt --wave-extract-loop-strides -o %t.extracted
// RUN: FileCheck %s < %t.extracted
// RUN: wave-opt --wave-extract-loop-strides %t.extracted -o %t.twice
// RUN: diff %t.extracted %t.twice
// RUN: wave-opt %t.twice --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner --shared-libs=%mlir_rocm_runtime --shared-libs=%mlir_runner_utils --shared-libs=%wave_runtime --entry-point-result=void
// RUN: sed 's/"wave-extract-loop-strides"/"canonicalize"/' %wave_pipelines > %t.pipeline.mlir
// RUN: env PYTHONPATH=%wave_obj_root/python_packages/wave_mlir %python %S/Inputs/select_materialization_variant.py %t.twice 0 > %t.choice0
// RUN: wave-opt %t.choice0 --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%t.pipeline.mlir},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner --shared-libs=%mlir_rocm_runtime --shared-libs=%mlir_runner_utils --shared-libs=%wave_runtime --entry-point-result=void
// RUN: env PYTHONPATH=%wave_obj_root/python_packages/wave_mlir %python %S/Inputs/select_materialization_variant.py %t.twice 1 > %t.choice1
// RUN: wave-opt %t.choice1 --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%t.pipeline.mlir},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner --shared-libs=%mlir_rocm_runtime --shared-libs=%mlir_runner_utils --shared-libs=%wave_runtime --entry-point-result=void

// CHECK-LABEL: func.func @uniform_stride
// CHECK: wave.token
// CHECK: [[BASE:%.*]] = wave.index_expr
// CHECK: [[INIT:%.*]] = wave.splat [[BASE]] : index -> !wave.simd<index, {{32|64}}>
// CHECK: scf.for {{.*}} iter_args({{.*}}, [[CARRY:%.*]] = [[INIT]])
// CHECK: [[ORIGINAL:%.*]] = wave.cast intconvert {{%.*}} policy
// CHECK: wave.materialization_variants [[ORIGINAL]], [[CARRY]]
// CHECK: wave.load {{.*}} after
// CHECK: wave.store {{.*}} after
// CHECK-LABEL: func.func @varying_stride
// CHECK: scf.for {{.*}} iter_args({{.*}}, [[CARRY:%.*]] = {{%.*}})
// CHECK: [[ORIGINAL:%.*]] = wave.cast intconvert {{%.*}} policy
// CHECK: wave.materialization_variants [[ORIGINAL]], [[CARRY]]
// CHECK: wave.load {{.*}} after
// CHECK: wave.store {{.*}} after
module attributes {gpu.container_module} {
gpu.module @kernels {
func.func @uniform_stride(%source: !wave.ptr<#wave.global, i32>,
                 %output: !wave.ptr<#wave.global, i32>,
                 %lower: i32, %upper: i32, %step: i32)
    -> !wave.mem.token attributes {gpu.kernel, wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %range = arith.constant 2048 : i32
  %byte_source = wave.ptr_cast %source : !wave.ptr<#wave.global, i32> -> !wave.ptr<#wave.global, i8>
  %buffer = waveamd.make_buffer %byte_source, %range : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  %item = wave.index_expr <"4*lane"> ["lane"](%lane) : (!wave.simd<i32, @W@>) -> !wave.simd<index, @W@>
  %lane_bytes = wave.cast intconvert %item : !wave.simd<index, @W@> -> !wave.simd<i32, @W@>
  %root = wave.token : !wave.mem.token
  %result:2 = scf.for %i = %lower to %upper step %step iter_args(%dependency = %root, %row = %c0) -> (!wave.mem.token, i32) : i32 {
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%i) : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %lanes = wave.splat %scaled : i32 -> !wave.simd<i32, @W@>
    %offset = wave.cast intconvert %lanes policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, @W@> -> !wave.simd<index, @W@>
    %bytes = wave.ptr_add %buffer, %offset : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>
    %ptr = wave.ptr_cast %bytes : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    %value, %read = wave.load %ptr after %dependency : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> (!wave.simd<i32, @W@>, !wave.mem.token)
    %out_offset = wave.index_expr <"@W@*row + lane"> ["row", "lane"](%row, %lane) : (i32, !wave.simd<i32, @W@>) -> !wave.simd<index, @W@>
    %out_ptr = wave.ptr_add %output, %out_offset : !wave.ptr<#wave.global, i32>, !wave.simd<index, @W@> -> !wave.simd<!wave.ptr<#wave.global, i32>, @W@>
    %stored = wave.store %value -> %out_ptr after %read : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#wave.global, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
    %next_row = wave.binary addi %row, %c1 : i32, i32 -> i32
    scf.yield %stored, %next_row : !wave.mem.token, i32
  }
  return %result#0 : !wave.mem.token
}

func.func @varying_stride(%source: !wave.ptr<#wave.global, i32>,
                 %output: !wave.ptr<#wave.global, i32>,
                 %lower: i32, %upper: i32, %step: i32)
    -> !wave.mem.token attributes {gpu.kernel, wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %range = arith.constant 2048 : i32
  %byte_source = wave.ptr_cast %source : !wave.ptr<#wave.global, i32> -> !wave.ptr<#wave.global, i8>
  %buffer = waveamd.make_buffer %byte_source, %range : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  %item = wave.index_expr <"4*lane"> ["lane"](%lane) : (!wave.simd<i32, @W@>) -> !wave.simd<index, @W@>
  %lane_bytes = wave.cast intconvert %item : !wave.simd<index, @W@> -> !wave.simd<i32, @W@>
  %root = wave.token : !wave.mem.token
  %result:2 = scf.for %i = %lower to %upper step %step iter_args(%dependency = %root, %row = %c0) -> (!wave.mem.token, i32) : i32 {
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%i) : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %lanes = wave.splat %scaled : i32 -> !wave.simd<i32, @W@>
    %sum = wave.binary addi %lanes, %lane_bytes : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
    %offset = wave.cast intconvert %sum policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, @W@> -> !wave.simd<index, @W@>
    %bytes = wave.ptr_add %buffer, %offset : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>
    %ptr = wave.ptr_cast %bytes : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
    %value, %read = wave.load %ptr after %dependency : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> (!wave.simd<i32, @W@>, !wave.mem.token)
    %out_offset = wave.index_expr <"@W@*row + lane"> ["row", "lane"](%row, %lane) : (i32, !wave.simd<i32, @W@>) -> !wave.simd<index, @W@>
    %out_ptr = wave.ptr_add %output, %out_offset : !wave.ptr<#wave.global, i32>, !wave.simd<index, @W@> -> !wave.simd<!wave.ptr<#wave.global, i32>, @W@>
    %stored = wave.store %value -> %out_ptr after %read : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#wave.global, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
    %next_row = wave.binary addi %row, %c1 : i32, i32 -> i32
    scf.yield %stored, %next_row : !wave.mem.token, i32
  }
  return %result#0 : !wave.mem.token
}
}

func.func private @wave_memref_to_ptr_global_i32(memref<?xi32>) -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func private @abort()

func.func @check(%source: !wave.ptr<#wave.global, i32>, %output: !wave.ptr<#wave.global, i32>,
                 %data: memref<@OUT@xi32>, %lower: i32, %step: i32, %varying: i1) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c4 = arith.constant 4 : i32
  %zero = arith.constant 0 : i32
  %width = arith.constant @W@ : index
  %size = arith.constant @OUT@ : index
  %sentinel = arith.constant -1 : i32
  %delta = arith.muli %c4, %step : i32
  %upper = arith.addi %lower, %delta : i32
  scf.for %idx = %c0 to %size step %c1 {
    memref.store %sentinel, %data[%idx] : memref<@OUT@xi32>
  }
  scf.if %varying {
    gpu.launch_func @kernels::@varying_stride blocks in (%c1, %c1, %c1) threads in (%width, %c1, %c1)
        args(%source : !wave.ptr<#wave.global, i32>, %output : !wave.ptr<#wave.global, i32>, %lower : i32, %upper : i32, %step : i32)
  } else {
    gpu.launch_func @kernels::@uniform_stride blocks in (%c1, %c1, %c1) threads in (%width, %c1, %c1)
        args(%source : !wave.ptr<#wave.global, i32>, %output : !wave.ptr<#wave.global, i32>, %lower : i32, %upper : i32, %step : i32)
  }
  %bias = arith.constant 100 : i32
  %c64 = arith.constant 64 : i64
  %bound = arith.constant 2048 : i64
  %four = arith.constant 4 : i64
  scf.for %idx = %c0 to %size step %c1 {
    %row_index = arith.divui %idx, %width : index
    %lane_index = arith.remui %idx, %width : index
    %row = arith.index_cast %row_index : index to i32
    %lane = arith.index_cast %lane_index : index to i32
    %scaled_row = arith.muli %row, %step : i32
    %iv = arith.addi %lower, %scaled_row : i32
    %iv64 = arith.extui %iv : i32 to i64
    %biased_iv = arith.addi %iv64, %four : i64
    %uniform_bytes = arith.muli %biased_iv, %c64 : i64
    %lane_scaled = arith.muli %lane, %c4 : i32
    %lane_bytes = arith.select %varying, %lane_scaled, %zero : i32
    %lane64 = arith.extui %lane_bytes : i32 to i64
    %exact = arith.addi %uniform_bytes, %lane64 : i64
    %wrapped = arith.trunci %exact : i64 to i32
    %unsigned = arith.extui %wrapped : i32 to i64
    %in_bounds = arith.cmpi ult, %unsigned, %bound : i64
    %word64 = arith.divui %unsigned, %four : i64
    %word = arith.trunci %word64 : i64 to i32
    %loaded = arith.addi %bias, %word : i32
    %expected = arith.select %in_bounds, %loaded, %zero : i32
    %actual = memref.load %data[%idx] : memref<@OUT@xi32>
    %equal = arith.cmpi eq, %actual, %expected : i32
    scf.if %equal {
    } else {
      func.call @abort() : () -> ()
    }
  }
  return
}

func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %count = arith.constant 512 : index
  %bias = arith.constant 100 : i32
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %two = arith.constant 2 : i32
  %three = arith.constant 3 : i32
  %wrap = arith.constant 67108859 : i32
  %uniform = arith.constant false
  %varying = arith.constant true
  %source = memref.alloc() : memref<512xi32>
  %output = memref.alloc() : memref<@OUT@xi32>
  scf.for %i = %c0 to %count step %c1 {
    %idx = arith.index_cast %i : index to i32
    %value = arith.addi %bias, %idx : i32
    memref.store %value, %source[%i] : memref<512xi32>
  }
  %source_unranked = memref.cast %source : memref<512xi32> to memref<*xi32>
  %output_unranked = memref.cast %output : memref<@OUT@xi32> to memref<*xi32>
  gpu.host_register %source_unranked : memref<*xi32>
  gpu.host_register %output_unranked : memref<*xi32>
  %source_dynamic = memref.cast %source : memref<512xi32> to memref<?xi32>
  %output_dynamic = memref.cast %output : memref<@OUT@xi32> to memref<?xi32>
  %src = func.call @wave_memref_to_ptr_global_i32(%source_dynamic) : (memref<?xi32>) -> !wave.ptr<#wave.global, i32>
  %out = func.call @wave_memref_to_ptr_global_i32(%output_dynamic) : (memref<?xi32>) -> !wave.ptr<#wave.global, i32>
  func.call @check(%src, %out, %output, %zero, %one, %uniform) : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>, memref<@OUT@xi32>, i32, i32, i1) -> ()
  func.call @check(%src, %out, %output, %zero, %one, %varying) : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>, memref<@OUT@xi32>, i32, i32, i1) -> ()
  func.call @check(%src, %out, %output, %three, %two, %uniform) : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>, memref<@OUT@xi32>, i32, i32, i1) -> ()
  func.call @check(%src, %out, %output, %three, %two, %varying) : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>, memref<@OUT@xi32>, i32, i32, i1) -> ()
  func.call @check(%src, %out, %output, %wrap, %one, %uniform) : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>, memref<@OUT@xi32>, i32, i32, i1) -> ()
  func.call @check(%src, %out, %output, %wrap, %one, %varying) : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>, memref<@OUT@xi32>, i32, i32, i1) -> ()
  gpu.host_unregister %source_unranked : memref<*xi32>
  gpu.host_unregister %output_unranked : memref<*xi32>
  memref.dealloc %source : memref<512xi32>
  memref.dealloc %output : memref<@OUT@xi32>
  return
}
}
