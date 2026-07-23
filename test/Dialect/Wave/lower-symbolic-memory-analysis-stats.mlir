// RUN: split-file %s %t
// RUN: wave-opt --wave-lower-symbolic-memory %t/eight.mlir | FileCheck %s --check-prefix=EIGHT-IR
// RUN: wave-opt --wave-lower-symbolic-memory %t/sixteen.mlir | FileCheck %s --check-prefix=SIXTEEN-IR
// RUN: wave-opt --wave-lower-symbolic-memory %t/sixty-four.mlir | FileCheck %s --check-prefix=SIXTY-FOUR-IR
// RUN: wave-opt --wave-lower-symbolic-memory %t/sixty-five.mlir | FileCheck %s --check-prefix=SIXTY-FIVE-IR
// RUN: wave-opt --wave-lower-symbolic-memory --mlir-pass-statistics %t/eight.mlir 2>&1 >/dev/null | FileCheck %s --check-prefix=EIGHT
// RUN: wave-opt --wave-lower-symbolic-memory --mlir-pass-statistics %t/sixteen.mlir 2>&1 >/dev/null | FileCheck %s --check-prefix=SIXTEEN
// RUN: wave-opt --wave-lower-symbolic-memory --mlir-pass-statistics %t/sixty-four.mlir 2>&1 >/dev/null | FileCheck %s --check-prefix=SIXTY-FOUR
// RUN: wave-opt --wave-lower-symbolic-memory --mlir-pass-statistics %t/sixty-five.mlir 2>&1 >/dev/null | FileCheck %s --check-prefix=SIXTY-FIVE

// EIGHT-IR-LABEL: func.func @eight_slots(
// EIGHT-IR-NOT: wave.gather
// EIGHT-IR-COUNT-1: wave.load
// EIGHT-IR-SAME: -> (!wave.simd<vector<8xf16>, 32>, !wave.mem.token)
// EIGHT-IR-NOT: wave.gather
// SIXTEEN-IR-LABEL: func.func @sixteen_slots(
// SIXTEEN-IR-NOT: wave.gather
// SIXTEEN-IR-COUNT-1: wave.load
// SIXTEEN-IR-SAME: -> (!wave.simd<vector<16xf16>, 32>, !wave.mem.token)
// SIXTEEN-IR-NOT: wave.gather
// SIXTY-FOUR-IR-LABEL: func.func @sixty_four_slots(
// SIXTY-FOUR-IR-NOT: wave.scatter
// SIXTY-FOUR-IR-COUNT-8: wave.store
// SIXTY-FOUR-IR-SAME: !wave.simd<vector<8xf16>, 32>
// SIXTY-FOUR-IR-NOT: wave.scatter
// SIXTY-FIVE-IR-LABEL: func.func @sixty_five_slots(
// SIXTY-FIVE-IR-NOT: wave.scatter
// SIXTY-FIVE-IR: wave.store
// SIXTY-FIVE-IR-SAME: !wave.simd<vector<64xf16>, 32>
// SIXTY-FIVE-IR-NOT: wave.store
// SIXTY-FIVE-IR: wave.store
// SIXTY-FIVE-IR-SAME: !wave.simd<f16, 32>
// SIXTY-FIVE-IR-NOT: wave.store
// SIXTY-FIVE-IR-NOT: wave.scatter

// EIGHT: WaveLowerSymbolicMemory
// EIGHT: (S) 0 relation-planning-fact-domains
// SIXTEEN: WaveLowerSymbolicMemory
// SIXTEEN: (S) 0 relation-planning-fact-domains
// SIXTY-FOUR: WaveLowerSymbolicMemory
// SIXTY-FOUR: (S) 14 relation-planning-fact-domains
// SIXTY-FIVE: WaveLowerSymbolicMemory
// SIXTY-FIVE: (S) 1 relation-planning-fact-domains

//--- eight.mlir

func.func @eight_slots(%base: !wave.ptr<#wave.global, f16>,
                       %raw: !wave.simd<index, 32>)
    -> !wave.simd<vector<8xf16>, 32> {
  %offset = wave.assume %raw as "x" [#wave.pred<"x >= 0">]
      : !wave.simd<index, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"16 * offset + 16 * slot">>
      bindings ["offset"](%offset) packet_bindings []()
      : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 32>)
      -> (!wave.simd<vector<8xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<8xf16>, 32>
}

//--- sixteen.mlir

func.func @sixteen_slots(%base: !wave.ptr<#wave.global, f16>,
                         %raw: !wave.simd<index, 32>)
    -> !wave.simd<vector<16xf16>, 32> {
  %offset = wave.assume %raw as "x" [#wave.pred<"x >= 0">]
      : !wave.simd<index, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"16 * offset + 16 * slot">>
      bindings ["offset"](%offset) packet_bindings []()
      : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 32>)
      -> (!wave.simd<vector<16xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<16xf16>, 32>
}

//--- sixty-four.mlir

func.func @sixty_four_slots(
    %value: !wave.simd<vector<64xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin: !wave.simd<i32, 32>, %limit: !wave.simd<i32, 32>) {
  %c1 = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %c2 = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %c3 = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %c4 = wave.constant 4 : i32 -> !wave.simd<i32, 32>
  %c5 = wave.constant 5 : i32 -> !wave.simd<i32, 32>
  %c6 = wave.constant 6 : i32 -> !wave.simd<i32, 32>
  %c7 = wave.constant 7 : i32 -> !wave.simd<i32, 32>
  %i1 = wave.binary addi %origin, %c1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i2 = wave.binary addi %origin, %c2
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i3 = wave.binary addi %origin, %c3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i4 = wave.binary addi %origin, %c4
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i5 = wave.binary addi %origin, %c5
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i6 = wave.binary addi %origin, %c6
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i7 = wave.binary addi %origin, %c7
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %m0 = wave.cmpi slt %origin, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi slt %i1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m2 = wave.cmpi slt %i2, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m3 = wave.cmpi slt %i3, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m4 = wave.cmpi slt %i4, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m5 = wave.cmpi slt %i5, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m6 = wave.cmpi slt %i6, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m7 = wave.cmpi slt %i7, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %initial = wave.token : !wave.mem.token
  %result = wave.where
      %m0, %m0, %m0, %m0, %m0, %m0, %m0, %m0,
      %m1, %m1, %m1, %m1, %m1, %m1, %m1, %m1,
      %m2, %m2, %m2, %m2, %m2, %m2, %m2, %m2,
      %m3, %m3, %m3, %m3, %m3, %m3, %m3, %m3,
      %m4, %m4, %m4, %m4, %m4, %m4, %m4, %m4,
      %m5, %m5, %m5, %m5, %m5, %m5, %m5, %m5,
      %m6, %m6, %m6, %m6, %m6, %m6, %m6, %m6,
      %m7, %m7, %m7, %m7, %m7, %m7, %m7, %m7 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"16 * slot">>
        bindings []() packet_bindings []()
        : (!wave.simd<vector<64xf16>, 32>, !wave.ptr<#wave.global, f16>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %initial : !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
      !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.mem.token
  return
}

//--- sixty-five.mlir

func.func @sixty_five_slots(
    %value: !wave.simd<vector<65xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>, %raw: !wave.simd<index, 32>) {
  %offset = wave.assume %raw as "x" [#wave.pred<"x >= 0">]
      : !wave.simd<index, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * offset + 16 * slot">>
      bindings ["offset"](%offset) packet_bindings []()
      : (!wave.simd<vector<65xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<index, 32>) -> !wave.mem.token
  return
}
