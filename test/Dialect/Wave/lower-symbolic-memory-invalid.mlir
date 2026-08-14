// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file --verify-diagnostics %s

func.func @mismatched_packet_control(
    %base: !wave.ptr<#wave.global, i32>,
    %first: !wave.mask<32>, %second: !wave.mask<32>,
    %third: !wave.mask<32>) {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %dependency = wave.token : !wave.mem.token
  // expected-error @+1 {{mask packet length must match symbolic memory packet length}}
  %result:2 = wave.where %first, %second, %third {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []() after %dependency
        : (!wave.ptr<#wave.global, i32>, !wave.mem.token)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield %value, %token
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  return
}

// -----

// A local binding may be imported before packet control only when its entire
// decoded SSA expression is rooted in values that dominate the Where. An
// unsupported local producer cannot silently become an out-of-scope leaf.
func.func @packet_local_opaque_binding_does_not_escape(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %first: !wave.mask<32>, %second: !wave.mask<32>) {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  // expected-error @+1 {{packet-predicated symbolic memory binding 'item' is not fully representable outside its control region}}
  wave.where %first, %second {
    %local = wave.urecip %item
        : !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %token = wave.scatter %value to %base mapping
        <bit_offset = <"32*(item + slot)">> bindings ["item"](%local)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// An existing index packet is a complete serialization boundary. The direct
// Assume producer behind its opaque binding does not donate an unrecorded
// nonzero fact to the access mapping.
func.func @serialized_binding_does_not_reopen_assume(
    %base: !wave.ptr<#wave.shared, i32>, %raw: !wave.simd<i32, 32>) {
  %bounded = wave.assume %raw as "x"
      [#wave.pred<"x >= 1">, #wave.pred<"x <= 1">]
      : !wave.simd<i32, 32>
  %packet = wave.index_expr <"x"> ["x"](%bounded)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32*floor(slot/x)">> bindings ["x"](%packet)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

// A sibling visit to an Assume result cannot leak that result's facts through
// an opaque index packet and retroactively prove a partial producer.
func.func @serialized_binding_facts_do_not_leak_from_sibling(
    %base: !wave.ptr<#wave.shared, i32>, %raw: !wave.simd<i32, 32>) {
  %bounded = wave.assume %raw as "x"
      [#wave.pred<"x >= 1">, #wave.pred<"x <= 1">]
      : !wave.simd<i32, 32>
  %packet = wave.index_expr <"x"> ["x"](%bounded)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %bounded_index = wave.cast intconvert %bounded
      policy {extension = #wave.cast_extension<sign>}
      : !wave.simd<i32, 32> -> !wave.simd<index, 32>
  %one = wave.constant 1 : index -> !wave.simd<index, 32>
  %quotient = wave.binary divui %one, %packet
      : !wave.simd<index, 32>, !wave.simd<index, 32>
      -> !wave.simd<index, 32>
  %outer = wave.binary addi %bounded_index, %quotient
      : !wave.simd<index, 32>, !wave.simd<index, 32>
      -> !wave.simd<index, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32*floor(slot/outer)">> bindings ["outer"](%outer)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @remote_block(%base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{mapping is not a byte-addressable local memory point}}
  %value, %token = wave.gather %base mapping
      <target_block = <"1">, bit_offset = <"32 * slot">>
      bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @dynamic_base(%first: !wave.ptr<#wave.shared, i32>,
                        %second: !wave.ptr<#wave.shared, i32>,
                        %which: index) {
  // Nonconstant scalar base remains unsupported.
  // expected-error @+1 {{mapping is not a byte-addressable local memory point}}
  %value, %token = wave.gather %first, %second mapping
      <base = <"which">, bit_offset = <"32 * slot">>
      bindings ["which"](%which)
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>, index)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @non_byte_addressable(%base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{mapping is not a byte-addressable local memory point}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"1 + 32 * slot">>
      bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @unsupported_i4(%base: !wave.ptr<#wave.shared, i4>) {
  // expected-error @+1 {{lowering requires 8-, 16-, or 32-bit packet elements}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"4 * slot">>
      bindings []()
      : (!wave.ptr<#wave.shared, i4>)
      -> (!wave.simd<vector<4xi4>, 32>, !wave.mem.token)
  return
}

// -----

func.func @unknown_workgroup(%base: !wave.ptr<#wave.shared, i32>) {
  // Explicit SSA bounds are sufficient without ambient launch metadata.
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (2 * item + slot)">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @partial_item_domain(%base: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * floor(slot / (item - 16))">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @block_origin_is_composed(%base: !wave.ptr<#wave.shared, i32>) {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (block + slot)">>
      bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @lane_partition_base(%first: !wave.ptr<#wave.shared, i32>,
                               %second: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  // A lane-varying selector is legal when its SSA domain proves that it names
  // one of the supplied bases and is invariant over the packet slot.
  %value, %token = wave.gather %first, %second mapping
      <base = <"Mod(item, 2)">, bit_offset = <"32 * slot">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>,
         !wave.simd<i32, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @private_address_space(%base: !wave.ptr<#wave.private, i32>) {
  // expected-error @+1 {{lowering requires global, shared, or AMD buffer pointer bases}}
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * slot">>
      bindings []()
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
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * floor(slot / (x - 16))">>
      bindings ["x"](%x)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @enclosing_where_sibling_facts_are_not_used(
    %x: !wave.simd<i32, 32>, %base: !wave.ptr<#wave.shared, i32>) {
  %limit = wave.constant 32 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active {
    %unused_assume = wave.assume %x as "x" [#wave.pred<"x <= 15">]
        : !wave.simd<i32, 32>
    %unused_index = wave.index_expr <"x"> assuming [#wave.pred<"x <= 15">]
        ["x"](%x) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * floor(slot / (x - 16))">>
        bindings ["x"](%x)
        : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield
  } : !wave.mask<32>
  return
}

// -----

func.func @enclosing_where_ancestor_is_not_a_fact(
    %x: !wave.simd<i32, 32>, %base: !wave.ptr<#wave.shared, i32>) {
  %limit = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active {
    scf.execute_region {
      %value, %token = wave.gather %base mapping
          <bit_offset = <"32 * floor(slot / (x - 16))">>
          bindings ["x"](%x)
          : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
          -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
      scf.yield
    }
    wave.yield
  } : !wave.mask<32>
  return
}

// -----

// The exact Assume result severs the address from its poison-producing source;
// the unrelated enclosing branch fact must not constrain address planning.
func.func @where_guard_does_not_validate_atomic_assume_source(
    %numerator: !wave.simd<i32, 32>, %divisor: !wave.simd<i32, 32>,
    %base: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ne %divisor, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %quotient = wave.binary divui %numerator, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %lane = wave.workitem_id 0 : !wave.simd<i32, 32>
  %shuffled = wave.shuffle %quotient from %lane
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %unit = wave.assume %shuffled as "unit"
      [#wave.pred<"unit >= 1">, #wave.pred<"unit <= 1">]
      : !wave.simd<i32, 32>
  wave.where %active {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32*floor(slot/unit)">> bindings ["unit"](%unit)
        : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield
  } : !wave.mask<32>
  return
}

// -----

func.func @enclosing_scf_if_is_not_a_fact(
    %x: index, %base: !wave.ptr<#wave.shared, i32>) {
  %limit = arith.constant 16 : index
  %active = arith.cmpi slt, %x, %limit : index
  scf.if %active {
    %unused = wave.assume %x as "x" [#wave.pred<"x <= 15">] : index
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * floor(slot / (x - 16))">>
        bindings ["x"](%x)
        : (!wave.ptr<#wave.shared, i32>, index)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  }
  return
}

// -----

// A zero divisor produces poison, which can be refined to the zero remainder
// used by the simplified address.
func.func @partial_mapping_cancellation(
    %base: !wave.ptr<#wave.shared, i32>, %divisor: index) {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32*slot + Mod(divisor, divisor)">>
      bindings ["divisor"](%divisor)
      : (!wave.ptr<#wave.shared, i32>, index)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return
}

// -----

func.func @packet_gather_region_local_fallback(
    %first: !wave.mask<32>, %second: !wave.mask<32>,
    %base: !wave.ptr<#wave.shared, i32>) {
  %dependency = wave.token : !wave.mem.token
  // expected-error @+1 {{packet-predicated gather fallback must be defined before its control region}}
  %result:2 = wave.where %first, %second {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []() after %dependency
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield %value, %token
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } otherwise {
    %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
    %fallback = wave.pack %one, %one
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<vector<2xi32>, 32>
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  return
}

// -----

func.func @packet_gather_region_local_subvector_fallback(
    %first: !wave.mask<32>, %second: !wave.mask<32>,
    %third: !wave.mask<32>, %fourth: !wave.mask<32>,
    %base: !wave.ptr<#wave.shared, i32>) {
  %dependency = wave.token : !wave.mem.token
  // expected-error @+1 {{packet-predicated gather fallback must be defined before its control region}}
  %result:2 = wave.where %first, %second, %third, %fourth {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []() after %dependency
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
        -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
    wave.yield %value, %token
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } otherwise {
    %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
    %pair = wave.pack %one, %one
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<vector<2xi32>, 32>
    %fallback = wave.pack %pair, %pair
        : !wave.simd<vector<2xi32>, 32>, !wave.simd<vector<2xi32>, 32>
        -> !wave.simd<vector<4xi32>, 32>
    wave.yield %fallback, %dependency
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  return
}

// -----

func.func @packet_scatter_region_local_inactive_token(
    %value: !wave.simd<vector<2xi32>, 32>,
    %first: !wave.mask<32>, %second: !wave.mask<32>,
    %base: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{packet-predicated scatter inactive token must be defined before its control region}}
  %result = wave.where %first, %second {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32 * slot">>
        bindings []()
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.shared, i32>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    %inactive = wave.token : !wave.mem.token
    wave.yield %inactive : !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32> -> !wave.mem.token
  return
}
