// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt --wave-generate-index-exprs --wave-lower-symbolic-memory %s \
// RUN:   | FileCheck %s --check-prefix=LOWER

// ASM-LABEL: symbolic_memory_scoped_assumption_codegen:
// ASM: v_cmp_lt_i32
// ASM: s_and_saveexec_b64
// ASM: buffer_load_dword
// ASM: s_and_saveexec_b64
// ASM: buffer_load_dword
// ASM-NOT: global_load_dword
// ASM: s_waitcnt vmcnt(0)
// ASM: buffer_store_dwordx2
// ASM: s_endpgm

// LOWER-LABEL: func.func @symbolic_memory_scoped_assumption_codegen(
// LOWER-SAME: %[[SOURCE:[^,]+]]: !wave.ptr<#wave.global, i32>
// LOWER: [[ACTIVE0:%.*]] = wave.cmpi slt
// LOWER: [[ACTIVE1:%.*]] = wave.cmpi slt
// LOWER: [[DEP:%.*]] = wave.token
// LOWER: [[BYTE_SOURCE0:%.*]] = wave.ptr_cast %[[SOURCE]]
// LOWER: [[ADDR0:%.*]] = wave.index_expr <"4*item"> assuming
// LOWER: [[PTR0:%.*]] = wave.ptr_add [[BYTE_SOURCE0]], [[ADDR0]]
// LOWER: [[GUARD0:%.*]]:2 = wave.where [[ACTIVE0]]
// LOWER-NOT: wave.index_expr
// LOWER: {{%.*}}, {{%.*}} = wave.load [[PTR0]] after [[DEP]]
// LOWER-NOT: wave.ptr_cast %[[SOURCE]]
// LOWER-NOT: wave.index_expr
// LOWER: [[DELTA:%.*]] = wave.constant 4 : index
// LOWER: [[PTR1:%.*]] = wave.ptr_add [[PTR0]], [[DELTA]]
// LOWER: [[GUARD1:%.*]]:2 = wave.where [[ACTIVE1]]
// LOWER-NOT: wave.index_expr
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
// LOWER-COUNT-1: [[GUARDED:%.*]]:2 = wave.where
// LOWER-COUNT-1: wave.load
// LOWER-SAME: -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
// LOWER-NOT: wave.gather
// LOWER: wave.store {{.*}} after [[GUARDED]]#1

// ASM-LABEL: symbolic_memory_wrapping_relation_codegen:
// ASM-COUNT-1: global_load_dword
// ASM-NOT: global_load_ushort
// ASM: s_waitcnt vmcnt(0)
// ASM-COUNT-1: global_store_dword
// ASM: s_endpgm

// LOWER-LABEL: func.func @symbolic_memory_wrapping_relation_codegen(
// LOWER-COUNT-1: wave.load
// LOWER-SAME: -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
// LOWER-NOT: wave.gather
// LOWER-COUNT-1: wave.store

// A mandatory exact byte quotient is allowed to be predicate-valued.
// LOWER-LABEL: func.func @symbolic_memory_predicate_quotient_codegen(
// LOWER-NOT: wave.index_expr <"item == 0">
// LOWER: wave.cmpi eq
// LOWER: %[[PREDICATE_OFFSET:.*]] = wave.select
// LOWER: wave.ptr_add {{.*}}, %[[PREDICATE_OFFSET]]
// LOWER-NOT: wave.gather
// LOWER: wave.store

// ASM-LABEL: symbolic_memory_predicate_quotient_codegen:
// ASM: v_cmp_eq_u32
// ASM: v_cndmask_b32
// ASM: buffer_load_ubyte
// ASM-NOT: global_load_ubyte
// ASM: buffer_store_dword
// ASM-NOT: global_store_dword
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_scoped_assumption_codegen(
    %source: !wave.ptr<#wave.global, i32>,
    %destination: !wave.ptr<#wave.global, i32>, %limit_raw: i32)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %launch_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %next = wave.binary addi %launch_item, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %limit = wave.splat %limit_raw : i32 -> !wave.simd<i32, 64>
  %active0 = wave.cmpi slt %launch_item, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %active1 = wave.cmpi slt %next, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<2xi32>, 64>
  %guarded:2 = wave.where %active0, %active1 {
    %value, %read = wave.gather %source mapping
        <bit_offset = <"32*(item + slot)">>
        bindings ["item"](%launch_item)
        after %dependency
        : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>, !wave.mem.token)
        -> (!wave.simd<vector<2xi32>, 64>, !wave.mem.token)
    wave.yield %value, %read
        : !wave.simd<vector<2xi32>, 64>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 64>, !wave.mem.token
  } : !wave.mask<64>, !wave.mask<64>
      -> !wave.simd<vector<2xi32>, 64>, !wave.mem.token
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %output_offset = wave.binary muli %launch_item, %two overflow<nsw>
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
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %origin = wave.binary muli %bounded_item, %two overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %candidate = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %next = wave.shuffle %candidate from %bounded_item
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %delta = wave.binary subi %next, %origin overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %unit = wave.assume %delta as "x"
      [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x <= 0">]
      : !wave.simd<i32, 64>
  // Keep the raw item carrier shared so the combined facts prove unit == 1.
  %origin_index = wave.index_expr <"2*item"> assuming
      [#wave.pred<"item >= 0">, #wave.pred<"-63 + item <= 0">]
      ["item"](%item)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %limit = wave.splat %limit_raw : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %bounded_item, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0.0 : f16 -> !wave.simd<f16, 64>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<f16, 64>, !wave.simd<f16, 64>
      -> !wave.simd<vector<2xf16>, 64>
  %guarded:2 = wave.where %active, %active {
    %value, %read = wave.gather %source mapping
        <bit_offset = <"16*(origin + slot*unit)">>
        bindings ["origin", "unit"](%origin_index, %unit)
        after %dependency
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 64>,
           !wave.simd<i32, 64>,
           !wave.mem.token)
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

func.func @symbolic_memory_wrapping_relation_codegen(
    %source: !wave.ptr<#wave.global, f16>,
    %destination: !wave.ptr<#wave.global, f16>,
    %stride_raw: i32, %bias_raw: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %stride = wave.splat %stride_raw : i32 -> !wave.simd<i32, 64>
  %bias = wave.splat %bias_raw : i32 -> !wave.simd<i32, 64>
  %product = wave.binary muli %bounded_item, %stride
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %lhs_raw = wave.binary addi %product, %bias
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %lhs = wave.assume %lhs_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">]
      : !wave.simd<i32, 64>
  %value, %read = wave.gather %source mapping
      <bit_offset = <"16*(offset + slot)">> bindings ["offset"](%lhs)
      : (!wave.ptr<#wave.global, f16>, !wave.simd<i32, 64>)
      -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
  %output = wave.ptr_add %destination, %lhs
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 64>
  %written = wave.store %value -> %output after %read
      : (!wave.simd<vector<2xf16>, 64>,
         !wave.simd<!wave.ptr<#wave.global, f16>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

func.func @symbolic_memory_predicate_quotient_codegen(
    %source: !wave.ptr<#wave.global, i8>,
    %destination: !wave.ptr<#wave.global, i8>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %value, %read = wave.gather %source mapping
      <bit_offset = <"8*Piecewise((1, item == 0), (0, True))">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.global, i8>, !wave.simd<i32, 64>)
      -> (!wave.simd<vector<1xi8>, 64>, !wave.mem.token)
  %output_offset = wave.index_expr <"4*item"> assuming
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
      ["item"](%bounded_item)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %output = wave.ptr_add %destination, %output_offset
      : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
  %byte = wave.extract %value[0]
      : !wave.simd<vector<1xi8>, 64> -> !wave.simd<i8, 64>
  %packed = wave.pack %byte, %byte, %byte, %byte
      : !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>
      -> !wave.simd<vector<4xi8>, 64>
  %written = wave.store %packed -> %output after %read
      : (!wave.simd<vector<4xi8>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
