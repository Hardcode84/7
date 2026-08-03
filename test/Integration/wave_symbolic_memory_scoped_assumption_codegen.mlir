// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt --wave-lower-symbolic-memory %s \
// RUN:   | FileCheck %s --check-prefix=LOWER

// ASM-LABEL: symbolic_memory_scoped_assumption_codegen:
// ASM-COUNT-2: buffer_load_dword
// ASM: s_waitcnt vmcnt(0)
// ASM: buffer_store_dwordx2
// ASM: s_endpgm

// LOWER-LABEL: func.func @symbolic_memory_scoped_assumption_codegen(
// LOWER-SAME: %[[SOURCE:[^,]+]]: !wave.ptr<#wave.global, i32>
// LOWER: [[NEXT:%.*]] = wave.binary addi
// LOWER: [[DEP:%.*]] = wave.token
// LOWER: [[GUARD0:%.*]]:2 = wave.where
// LOWER: [[ADDR0:%.*]] = wave.index_expr <"raw0"> assuming
// LOWER-SAME: #wave.pred<"raw0 >= 0">
// LOWER-SAME: #wave.pred<"-1073741823 + raw0 <= 0">
// LOWER: [[PTR0:%.*]] = wave.ptr_add %[[SOURCE]], [[ADDR0]]
// LOWER: {{%.*}}, {{%.*}} = wave.load [[PTR0]] after [[DEP]]
// LOWER: [[GUARD1:%.*]]:2 = wave.where
// LOWER: [[PTR1:%.*]] = wave.ptr_add %[[SOURCE]], [[NEXT]]
// LOWER: {{%.*}}, {{%.*}} = wave.load [[PTR1]] after [[DEP]]
// LOWER: [[READ:%.*]] = wave.join [[GUARD0]]#1, [[GUARD1]]#1
// LOWER: wave.store {{%.*}} -> {{%.*}} after [[READ]]

// ASM-LABEL: symbolic_memory_ssa_assumption_codegen:
// ASM-COUNT-1: buffer_load_dword
// ASM-NOT: buffer_load_ushort
// ASM: s_waitcnt vmcnt(0)
// ASM-COUNT-1: buffer_store_dword
// ASM: s_endpgm

// LOWER-LABEL: func.func @symbolic_memory_ssa_assumption_codegen(
// LOWER-COUNT-1: wave.where
// LOWER-COUNT-1: wave.load
// LOWER-SAME: -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
// LOWER-NOT: wave.gather
// LOWER: wave.store

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_scoped_assumption_codegen(
    %source: !wave.ptr<#wave.global, i32>,
    %destination: !wave.ptr<#wave.global, i32>, %limit_raw: i32)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %limit = wave.splat %limit_raw : i32 -> !wave.simd<i32, 64>
  %active0 = wave.cmpi slt %item, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %active1 = wave.cmpi slt %next, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<2xi32>, 64>
  %guarded:2 = wave.where %active0, %active1 {
    %bounded0 = wave.assume %item as "x"
        [#wave.pred<"x >= 0">,
         #wave.pred<"-1073741823 + x <= 0">]
        : !wave.simd<i32, 64>
    %bounded1 = wave.assume %next as "x"
        [#wave.pred<"x >= 0">,
         #wave.pred<"-1073741823 + x <= 0">]
        : !wave.simd<i32, 64>
    %value, %read = wave.gather %source mapping
        <bit_offset = <"32*offset">> bindings []()
        packet_bindings ["offset", "offset"](%bounded0, %bounded1)
        after %dependency
        : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>,
           !wave.simd<i32, 64>, !wave.mem.token)
        -> (!wave.simd<vector<2xi32>, 64>, !wave.mem.token)
    wave.yield %value, %read
        : !wave.simd<vector<2xi32>, 64>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 64>, !wave.mem.token
  } : !wave.mask<64>, !wave.mask<64>
      -> !wave.simd<vector<2xi32>, 64>, !wave.mem.token
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %output_offset = wave.binary muli %item, %two
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %output = wave.ptr_add %destination, %output_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %written = wave.store %guarded#0 -> %output after %guarded#1
      : (!wave.simd<vector<2xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

func.func @symbolic_memory_ssa_assumption_codegen(
    %source: !wave.ptr<#wave.global, f16>,
    %destination: !wave.ptr<#wave.global, f16>, %limit_raw: i32)
    attributes {wave.kernel, wave.address_arithmetic_no_overflow,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %origin = wave.binary muli %item, %two overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %candidate = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %next = wave.shuffle %candidate from %item
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %limit = wave.splat %limit_raw : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %item, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0.0 : f16 -> !wave.simd<f16, 64>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<f16, 64>, !wave.simd<f16, 64>
      -> !wave.simd<vector<2xf16>, 64>
  %guarded:2 = wave.where %active, %active {
    %delta = wave.binary subi %next, %origin
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %unit = wave.assume %delta as "x"
        [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x <= 0">]
        : !wave.simd<i32, 64>
    %normalized = wave.binary addi %origin, %unit
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %value, %read = wave.gather %source mapping
        <bit_offset = <"16*offset">> bindings []()
        packet_bindings ["offset", "offset"](%origin, %normalized)
        after %dependency
        : (!wave.ptr<#wave.global, f16>, !wave.simd<i32, 64>,
           !wave.simd<i32, 64>, !wave.mem.token)
        -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
    wave.yield %value, %read
        : !wave.simd<vector<2xf16>, 64>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xf16>, 64>, !wave.mem.token
  } : !wave.mask<64>, !wave.mask<64>
      -> !wave.simd<vector<2xf16>, 64>, !wave.mem.token
  %output = wave.ptr_add %destination, %origin
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 64>
  %written = wave.store %guarded#0 -> %output after %guarded#1
      : (!wave.simd<vector<2xf16>, 64>,
         !wave.simd<!wave.ptr<#wave.global, f16>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
