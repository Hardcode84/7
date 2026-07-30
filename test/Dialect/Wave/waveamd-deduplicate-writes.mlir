// RUN: wave-opt --split-input-file --waveamd-deduplicate-writes %s \
// RUN:   | FileCheck %s

// CHECK-LABEL: func.func @distinct_identical_dma
// CHECK: [[DMA:%.*]] = waveamd.dma_load_lds
// CHECK-NOT: waveamd.dma_load_lds
// CHECK: [[JOIN:%.*]] = wave.join [[DMA]]
func.func @distinct_identical_dma(
    %source: !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
    %destination: !wave.ptr<#wave.shared, i32>) {
  %dependency = wave.token : !wave.mem.token
  %first = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %duplicate = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %joined = wave.join %first, %duplicate
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @repeated_token_retains_dma
// CHECK: [[DMA:%.*]] = waveamd.dma_load_lds
// CHECK-NOT: waveamd.dma_load_lds
// CHECK: wave.join [[DMA]], [[DMA]]
func.func @repeated_token_retains_dma(
    %source: !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
    %destination: !wave.ptr<#wave.shared, i32>) {
  %dependency = wave.token : !wave.mem.token
  %dma = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %joined = wave.join %dma, %dma
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @repeated_token_and_distinct_duplicate
// CHECK: [[DMA:%.*]] = waveamd.dma_load_lds
// CHECK-NOT: waveamd.dma_load_lds
// CHECK: wave.join [[DMA]], [[DMA]]
func.func @repeated_token_and_distinct_duplicate(
    %source: !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
    %destination: !wave.ptr<#wave.shared, i32>) {
  %dependency = wave.token : !wave.mem.token
  %first = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %duplicate = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %joined = wave.join %first, %first, %duplicate
      : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @distinct_joins_stay
// CHECK-COUNT-2: waveamd.dma_load_lds
// CHECK-COUNT-2: wave.join
func.func @distinct_joins_stay(
    %source: !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
    %destination: !wave.ptr<#wave.shared, i32>) {
  %dependency = wave.token : !wave.mem.token
  %first = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %second = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %first_group = wave.join %first
      : !wave.mem.token -> !wave.mem.token
  %second_group = wave.join %second
      : !wave.mem.token -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @external_token_use_stays
// CHECK-COUNT-2: waveamd.dma_load_lds
// CHECK: wave.join
// CHECK: wave.barrier
func.func @external_token_use_stays(
    %source: !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
    %destination: !wave.ptr<#wave.shared, i32>) {
  %dependency = wave.token : !wave.mem.token
  %first = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %second = waveamd.dma_load_lds %source -> %destination after %dependency
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %joined = wave.join %first, %second
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %barrier = wave.barrier %first
      : (!wave.mem.token) -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @distinct_identical_store
// CHECK: [[STORE:%.*]] = wave.store
// CHECK-NOT: wave.store
// CHECK: wave.join [[STORE]]
func.func @distinct_identical_store(
    %value: !wave.simd<i32, 64>,
    %destination: !wave.ptr<#wave.global, i32>) {
  %dependency = wave.token : !wave.mem.token
  %first = wave.store %value -> %destination after %dependency
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> !wave.mem.token
  %duplicate = wave.store %value -> %destination after %dependency
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> !wave.mem.token
  %joined = wave.join %first, %duplicate
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @repeated_token_retains_store
// CHECK: [[STORE:%.*]] = wave.store
// CHECK-NOT: wave.store
// CHECK: wave.join [[STORE]], [[STORE]]
func.func @repeated_token_retains_store(
    %value: !wave.simd<i32, 64>,
    %destination: !wave.ptr<#wave.global, i32>) {
  %dependency = wave.token : !wave.mem.token
  %stored = wave.store %value -> %destination after %dependency
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> !wave.mem.token
  %joined = wave.join %stored, %stored
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @external_store_token_use_stays
// CHECK-COUNT-2: wave.store
// CHECK: wave.join
// CHECK: wave.barrier
func.func @external_store_token_use_stays(
    %value: !wave.simd<i32, 64>,
    %destination: !wave.ptr<#wave.global, i32>) {
  %dependency = wave.token : !wave.mem.token
  %first = wave.store %value -> %destination after %dependency
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> !wave.mem.token
  %second = wave.store %value -> %destination after %dependency
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> !wave.mem.token
  %joined = wave.join %first, %second
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %barrier = wave.barrier %first
      : (!wave.mem.token) -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @different_store_values_stay
// CHECK-COUNT-2: wave.store
// CHECK: wave.join
func.func @different_store_values_stay(
    %first_value: !wave.simd<i32, 64>,
    %second_value: !wave.simd<i32, 64>,
    %destination: !wave.ptr<#wave.global, i32>) {
  %dependency = wave.token : !wave.mem.token
  %first = wave.store %first_value -> %destination after %dependency
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> !wave.mem.token
  %second = wave.store %second_value -> %destination after %dependency
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> !wave.mem.token
  %joined = wave.join %first, %second
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return
}
