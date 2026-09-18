// RUN: sed -e 's/@RANGE@/4096/g' -e 's/@RT@/i64/g' %s | wave-opt --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | FileCheck %s --check-prefix=FLAT
// RUN: sed -e 's/@RANGE@/-2147483648/g' -e 's/@RT@/i32/g' %s | wave-opt --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | FileCheck %s --check-prefix=FLAT
// RUN: sed -e 's/@RANGE@/-1/g' -e 's/@RT@/i32/g' %s | wave-opt --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | FileCheck %s --check-prefix=FLAT
// RUN: sed -e 's/@RANGE@/4294967295/g' -e 's/@RT@/i64/g' %s | wave-opt --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | FileCheck %s --check-prefix=FLAT
// RUN: sed -e 's/@RANGE@/4294967296/g' -e 's/@RT@/i64/g' %s | wave-opt --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | FileCheck %s --check-prefix=KEEP
// RUN: sed -e 's/@RANGE@/-1/g' -e 's/@RT@/i64/g' %s | wave-opt --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | FileCheck %s --check-prefix=KEEP
// RUN: sed -e 's/@RANGE@/0/g' -e 's/@RT@/i64/g' %s | wave-opt --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | FileCheck %s --check-prefix=FLAT

// FLAT-LABEL: func.func @buffer_ranges
// FLAT: [[RANGE:%.*]] = arith.constant
// FLAT: [[BASE:%.*]] = waveamd.make_buffer {{.*}}, [[RANGE]]
// FLAT: [[OUT:%.*]] = waveamd.make_buffer {{.*}}, [[RANGE]]
// FLAT-NOT: wave.where
// FLAT: wave.cast intconvert [[RANGE]]{{( policy \{extension = #wave.cast_extension<zero>\})?}} : {{i32|i64}} -> index
// FLAT: wave.select
// FLAT: {{%.*}}, [[LOAD_TOKEN:%.*]] = wave.load
// FLAT: [[LOADED:%.*]] = wave.store {{.*}} after [[LOAD_TOKEN]]
// FLAT: wave.ptr_cast [[OUT]] : !wave.ptr<#waveamd.buffer, i32> -> !wave.ptr<#waveamd.buffer, i8>
// FLAT: wave.select
// FLAT: [[STORED:%.*]] = wave.store {{.*}} after [[LOADED]]
// FLAT: [[INIT:%.*]] = wave.store {{.*}} after [[STORED]]
// FLAT: [[READY:%.*]] = wave.barrier [[INIT]]
// FLAT: wave.select
// FLAT: [[DMA:%.*]] = waveamd.dma_load_lds {{.*}} after [[READY]] {bytes = 4 : i64}
// FLAT: wave.barrier [[DMA]]
// FLAT-NOT: wave.where
// FLAT: return
// KEEP-LABEL: func.func @buffer_ranges
// KEEP-NOT: wave.select
// KEEP: wave.where
// KEEP: wave.load
// KEEP: wave.where
// KEEP: wave.store
// KEEP: wave.where
// KEEP: waveamd.dma_load_lds {{.*}}zero_fill_inactive
// KEEP-NOT: wave.select
// KEEP: return

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @buffer_ranges(
    %base: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %limit: i32)
    -> !wave.mem.token attributes {wave.kernel, wave.lds_size = 256 : i64} {
  %range = arith.constant @RANGE@ : @RT@
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, @RT@ -> !wave.ptr<#waveamd.buffer, i32>
  %out_buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, @RT@ -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %scalar_zero = wave.constant 0 : i32
  %zero = wave.splat %scalar_zero : i32 -> !wave.simd<i32, 32>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<i32, 32>, !wave.mem.token
  } otherwise {
    wave.yield %zero, %dependency : !wave.simd<i32, 32>, !wave.mem.token
  } : !wave.mask<32> -> !wave.simd<i32, 32>, !wave.mem.token
  %out_ptr = wave.ptr_add %out_buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %loaded = wave.store %result#0 -> %out_ptr after %result#1 : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  %stride = arith.constant 32 : index
  %store_base = wave.ptr_add %out_buffer, %stride : !wave.ptr<#waveamd.buffer, i32>, index -> !wave.ptr<#waveamd.buffer, i32>
  %store_ptr = wave.ptr_add %store_base, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %stored = wave.where %active {
    %token = wave.store %lane -> %store_ptr after %loaded : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %loaded : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %lds_ptr = wave.ptr_add %lds, %lane : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %initialized = wave.store %zero -> %lds_ptr after %stored : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  %ready = wave.barrier %initialized : (!wave.mem.token) -> !wave.mem.token
  %dma = wave.where %active {
    %token = waveamd.dma_load_lds %ptr -> %lds after %ready {bytes = 4 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %ready : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %complete = wave.barrier %dma : (!wave.mem.token) -> !wave.mem.token
  %dma_value, %read = wave.load %lds_ptr after %complete : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token) -> (!wave.simd<i32, 32>, !wave.mem.token)
  %dma_base = wave.ptr_add %store_base, %stride : !wave.ptr<#waveamd.buffer, i32>, index -> !wave.ptr<#waveamd.buffer, i32>
  %dma_ptr = wave.ptr_add %dma_base, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %done = wave.store %dma_value -> %dma_ptr after %read : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return %done : !wave.mem.token
}
}
