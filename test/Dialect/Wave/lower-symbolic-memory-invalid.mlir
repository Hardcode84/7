// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file --verify-diagnostics %s

func.func @remote_block(%base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point}}
  %value, %token = wave.gather %base mapping
      <target_block = <"1">, bit_offset = <"32 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @dynamic_base(%first: !wave.ptr<#wave.shared, i32>,
                        %second: !wave.ptr<#wave.shared, i32>,
                        %which: index) {
  // Nonconstant scalar base remains unsupported.
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point}}
  %value, %token = wave.gather %first, %second mapping
      <base = <"which">, bit_offset = <"32 * slot">>
      bindings ["which"](%which) packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>, index)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @non_byte_addressable(%base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"1 + 32 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @packet_slot_diagnostic(
    %base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point at packet slot 1}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"Piecewise((0, slot == 0), (1, True))">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @unsupported_i4(%base: !wave.ptr<#wave.shared, i4>) {
  // expected-error @+1 {{lowering requires 8-, 16-, or 32-bit packet elements}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"4 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i4>)
      -> (!wave.simd<vector<4xi4>, 32>, !wave.mem.token)
  return
}

// -----

func.func @unknown_workgroup(%base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{requires a known workgroup shape}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (2 * item + slot)">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @live_item_after_slot_specialization(
    %base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{requires a known workgroup shape}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"Piecewise((32 * slot, slot < 1), (32 * item, True))">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @partial_item_domain(%base: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"Piecewise((32 * slot, item < 16))">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @block_dependent_offset(%base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (block + slot)">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @lane_partition_base(%first: !wave.ptr<#wave.shared, i32>,
                               %second: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point}}
  %value, %token = wave.gather %first, %second mapping
      <base = <"Mod(item, 2)">, bit_offset = <"32 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @multidim_axis_is_not_item(
    %first: !wave.ptr<#wave.shared, i32>,
    %second: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 4, 2, 1>} {
  %x = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %x, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %x, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point}}
  %value, %token = wave.gather %first, %second mapping
      <base = <"idx - item">, bit_offset = <"32 * slot">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>,
         !wave.simd<vector<2xi32>, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @private_address_space(%base: !wave.ptr<#wave.private, i32>) {
  // expected-error @+1 {{lowering requires global, shared, or AMD buffer pointer bases}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.private, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @inactive_control_fact(%x: !wave.simd<i32, 32>,
                                 %base: !wave.ptr<#wave.shared, i32>) {
  %limit = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active {
    wave.yield
  } : !wave.mask<32>
  // expected-error @+1 {{mapping is not a defined, byte-addressable local memory point}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"Piecewise((32 * slot, x < 16))">>
      bindings ["x"](%x) packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @packet_gather_unrelated_prefix(
    %base: !wave.ptr<#wave.global, i32>,
    %raw0: !wave.simd<i32, 32>, %raw1: !wave.simd<i32, 32>,
    %active0: !wave.mask<32>, %active1: !wave.mask<32>) {
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  // expected-error @+1 {{packet-predicated symbolic memory then region must contain only leading symbolic index producers and the memory access}}
  %result:2 = wave.where %active0, %active1 {
    %bounded = wave.assume %raw0 as "x" [#wave.pred<"x >= 0">]
        : !wave.simd<i32, 32>
    %unrelated = wave.constant 1 : i32 -> !wave.simd<i32, 32>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32*offset">> bindings []()
        packet_bindings ["offset", "offset"](%bounded, %raw1)
        after %dependency
        : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>,
           !wave.simd<i32, 32>, !wave.mem.token)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield %value, %token
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  return
}

// -----

func.func @packet_scatter_unrelated_prefix(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %raw0: !wave.simd<i32, 32>, %raw1: !wave.simd<i32, 32>,
    %active0: !wave.mask<32>, %active1: !wave.mask<32>) {
  %dependency = wave.token : !wave.mem.token
  // expected-error @+1 {{packet-predicated symbolic memory then region must contain only leading symbolic index producers and the memory access}}
  %result = wave.where %active0, %active1 {
    %bounded = wave.assume %raw0 as "x" [#wave.pred<"x >= 0">]
        : !wave.simd<i32, 32>
    %unrelated = wave.constant 1 : i32 -> !wave.simd<i32, 32>
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*offset">> bindings []()
        packet_bindings ["offset", "offset"](%bounded, %raw1)
        after %dependency
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.mem.token)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32> -> !wave.mem.token
  return
}
