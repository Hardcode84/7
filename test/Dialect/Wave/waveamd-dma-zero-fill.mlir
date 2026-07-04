// RUN: wave-opt --split-input-file --waveamd-dma-zero-fill %s | FileCheck %s
// RUN: wave-opt --split-input-file --waveamd-dma-zero-fill --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @zero_fill_marked_buffer
// CHECK: [[RANGE:%.*]] = arith.constant 2147483647 : i32
// CHECK: [[BUF:%.*]] = waveamd.make_buffer {{.*}}, [[RANGE]]
// CHECK: [[MASK:%.*]] = wave.cmpi
// CHECK: [[SRC:%.*]] = wave.ptr_add [[BUF]]
// CHECK-NOT: wave.where
// CHECK: [[BYTE_BUF:%.*]] = wave.ptr_cast [[BUF]] : !wave.ptr<#waveamd.buffer, i32> -> !wave.ptr<#waveamd.buffer, i8>
// CHECK: [[OOB_OFF:%.*]] = wave.splat [[RANGE]] : i32 -> !wave.simd<i32, 32>
// CHECK: [[OOB:%.*]] = wave.ptr_add [[BYTE_BUF]], [[OOB_OFF]] : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
// CHECK: [[TYPED_OOB:%.*]] = wave.ptr_cast [[OOB]] : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// CHECK: [[SELECTED:%.*]] = wave.select [[MASK]], [[SRC]], [[TYPED_OOB]]
// CHECK: [[TOK:%.*]] = waveamd.dma_load_lds [[SELECTED]]
// CHECK: wave.barrier [[TOK]]
// MACHINE-LABEL: func.func @zero_fill_marked_buffer
// MACHINE: waveamdmachine.buffer_load_lds_b128
func.func @zero_fill_marked_buffer(%in: !wave.ptr<#wave.global, i32>,
                                   %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 2147483647 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = wave.where %active {
    %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %tok1 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %bar = wave.barrier %tok : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @keep_unmarked_dma
// CHECK: wave.where
// CHECK: waveamd.dma_load_lds
// CHECK-NOT: wave.select
func.func @keep_unmarked_dma(%in: !wave.ptr<#wave.global, i32>,
                             %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = wave.where %active {
    %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %tok1 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %bar = wave.barrier %tok : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @keep_global_source
// CHECK: wave.where
// CHECK: waveamd.dma_load_lds
// CHECK-NOT: wave.select
func.func @keep_global_source(%in: !wave.ptr<#wave.global, i32>,
                              %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = wave.where %active {
    %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %tok1 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %bar = wave.barrier %tok : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @keep_non_dma_side_effect
// CHECK: wave.where
// CHECK: waveamd.dma_load_lds
// CHECK: wave.store
// CHECK-NOT: wave.select
func.func @keep_non_dma_side_effect(%in: !wave.ptr<#wave.global, i32>,
                                    %out: !wave.ptr<#wave.global, i32>,
                                    %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %dst = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  wave.where %active {
    %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %tok2 = wave.store %lane -> %dst after %tok1
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}

}
