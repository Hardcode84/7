# Wave Symbolic Memory Mapping

## Goal

Represent a tensor-to-memory layout relation with one symbolic map:

```text
packet(block, item, slot) <-> memory(base, offset)
```

`wave.gather` reads through the map. `wave.scatter` writes through the same
map. Lowering asks the Wave symbolic engine how to split the map into legal
loads or stores.

The operation carries no Triton layout, layout name, transaction plan, or
movement class. Triton layout objects disappear after the importer constructs
the map.

This is the memory analogue of `wave.redistribute`. Redistribution maps a
destination packet point to a source packet point. Symbolic memory access maps
a packet point to a physical memory point.

## Non-goals

- No layout attribute on an operation or type.
- No Wave copy of Triton's layout hierarchy.
- No physical access plan in the symbolic map.
- No implicit memory dependency, barrier, or alias edge.
- No general atomic or reduction scatter semantics.
- No string round-trip for symbolic expressions.

V1 targets Triton shared-memory loads and stores. The map also fits global and
private memory once those paths need it.

## One Map

Let `P` be the packet coordinate space:

```text
P = (block, item, slot)
```

`block` is the row-major block position in the cluster. `item` is the
row-major workitem position in that block. `slot` is the element position in
the per-lane vector payload.

Let `M` be the physical memory coordinate space:

```text
M = (base, offset)
```

`base` selects a pointer operand. `offset` is measured in elements of that
pointer's pointee type. A single-base access omits `base`; it is constant zero.

The complete relation is one total symbolic function:

```text
A(block, item, slot) = (base, offset)
```

Each pair identifies the same logical tensor element on the packet and memory
sides. Gather and scatter differ only in dataflow direction:

```text
gather:  result[p] = load(bases[A(p).base] + A(p).offset)
scatter: store(bases[A(p).base] + A(p).offset, source[p])
```

The map contains only its result expressions. The packet side is the identity
domain and need not be serialized.

### Derived Facts

Do not store these in the map:

- packet extents;
- pointer extents;
- base alignment;
- active predicates;
- access or transaction count;
- transaction width;
- source packet coordinates;
- vectorization or movement mode.

Packet slot count comes from the gather result or scatter source type. Block
and item bounds come from the enclosing kernel configuration. Pointer count,
address space, element type, and base alignment come from operands and
allocation facts. Predication comes from ordinary Wave control. Memory
ordering comes from ordinary Wave tokens.

Transaction count and width are lowering results. Storing either would make
the relation describe one implementation instead of the access.

### Symbolic Representation

The proposed attribute is:

```mlir
#wave.memory_mapping<
  base = #wave.expr<...>,
  offset = #wave.expr<...>
>
```

`base` is absent for a single pointer operand. Both fields are structural
`sym::ExprHandle`s owned by the Wave dialect's symbolic store.

Reserved symbols are `block`, `item`, and `slot`. Runtime view origins,
indices, rotation phases, and similar values are SSA operands bound to named
free symbols on the operation. Bindings are expression inputs, not layout
metadata.

Example:

```mlir
#wave.memory_mapping<
  offset = #wave.expr<
    "origin + xor(item % 16, (item / 16) % 8) * 8 + slot"
  >
>
```

Text above is illustrative assembly syntax. Builders import expression handles
structurally. Printers are not an interchange format.

### Replication

Gather permits multiple packet points to map to the same memory point.

Scatter removes packet dimensions that the map broadcasts before emitting
stores. One deterministic packet representative writes each distinct memory
point. This is the same information exposed by Triton's register-to-shared
conversion map; no writer predicate belongs in the attribute.

The symbolic engine must prove the quotient. An unproved collision is rejected.
Atomic, reduction, and last-writer scatters use different operations.

V1 requires one memory point per packet equivalence class. A layout that stores
one logical element in multiple physical replicas must be expanded into
separate symbolic accesses or rejected.

## Operations

Both operations use `MemoryEffectsOpInterface`. Pointer operands identify the
memory resource. Tokens preserve Wave's explicit ordering model.

Conceptual gather syntax:

```mlir
%value, %done = wave.gather %base
    mapping #wave.memory_mapping<offset = #wave.expr<...>>
    bindings ["origin"](%origin)
    after %dependency
    : !wave.ptr<shared, f16>
      -> !wave.simd<vector<4xf16>, 64>, !wave.mem.token
```

Conceptual scatter syntax:

```mlir
%done = wave.scatter %value -> %base
    mapping #wave.memory_mapping<offset = #wave.expr<...>>
    bindings ["origin"](%origin)
    after %dependency
    : !wave.simd<vector<4xf16>, 64>, !wave.ptr<shared, f16>
      -> !wave.mem.token
```

Multiple pointer operands admit a `base` expression:

```mlir
wave.gather %partition0, %partition1
    mapping #wave.memory_mapping<
      base = #wave.expr<"item % 2">,
      offset = #wave.expr<"...">
    >
```

Cache policy remains an operation attribute, matching `wave.load` and
`wave.store`. It is not part of the mapping.

V1 maps every packet point. A future masked form may add mask and `other`
operands to `wave.gather`, or a mask operand to `wave.scatter`. Masking does not
change the mapping attribute.

## Triton Import

The importer uses Triton layout algebra to build the map, then drops the
layouts.

Let:

```text
R : packet hardware coordinates -> logical tensor coordinates
M : memory hardware coordinates -> logical tensor coordinates
V : logical view transform
```

For a local load, `R` is the result register layout. For a local store, `R` is
the source register layout. In both cases construct:

```text
A = M^-1 compose V compose R
```

such that:

```text
M(A(p)) = V(R(p))
```

For linear layouts this is Triton's existing register-to-shared conversion:

```text
sharedLayout.invertAndCompose(registerLayout)
```

The Wave importer converts the resulting `(register, lane, warp, block) ->
(offset[, partition])` expressions to `(block, item, slot) -> (base, offset)`.
`item` linearizes warp and lane. `slot` names the register component.

Non-injective inversion uses Triton's deterministic representative. Missing or
ambiguous representatives are import failures, not reasons to retain a layout
object.

### Physical Layout Variants

Every physical rule is compiled into `base` and `offset` expressions:

- swizzling changes `offset`;
- padding adds its floor-division terms to `offset`;
- partitioning produces `base` and partition-local `offset`;
- rotation binds its phase operand and changes `base` or `offset`;
- memdesc views compose origin, stride, slice, and transpose expressions before
  physical placement.

Helper-generated Triton layouts follow the same path. Successful import leaves
only symbolic expressions and SSA bindings in Wave IR.

If a physical rule cannot be expressed in Wave's symbolic algebra, reject it at
the import boundary. Do not leave an opaque resolver on the operation.

## Verification

### Local Verifier

The operation verifier checks only local structure:

- gather result or scatter source is a fixed one-dimensional Wave SIMD packet;
- pointer operands have compatible address space and pointee type;
- `base` exists exactly when required by the pointer arity;
- mapping expressions are integral and structurally valid;
- free symbols are reserved packet symbols or named SSA bindings;
- binding names and operands match;
- static `base` range proofs hold when multiple pointers are present.

The verifier does not inspect producers, users, allocation ops, kernel
metadata, target features, or control context.

### Contextual Validation

`wave-lower-symbolic-memory` obtains the packet domain from the operation and
kernel context. It then proves:

- map definedness over that domain;
- selected base is in range;
- address calculation does not overflow;
- scatter broadcast quotient and collision freedom;
- every emitted access is legal for the target and control context.

Pointer bounds follow the same contract as ordinary `wave.load` and
`wave.store`. A known `wave.alloc` gives the pass extra range facts. An unknown
external pointer leaves in-bounds access as the frontend's obligation. No
extent array belongs in the mapping.

Alignment is also derived. Known base alignment plus symbolic offset facts may
enable a wide access. Failure to prove wide alignment forces a narrower access;
it does not invalidate the map.

## Lowering

`wave-lower-symbolic-memory` lowers the full map. No symbolic gather or scatter
reaches WaveAMD selection.

### 1. Build The Domain

Bind `block`, `item`, and `slot` to their contextual ranges. Substitute SSA
bindings and simplify `base` and `offset` with the Wave symbolic engine.

### 2. Quotient Replicas

For scatter, find packet input dimensions that do not change `(base, offset)`.
Remove those dimensions and choose the smallest packet representative. This
matches Triton's broadcast-register removal.

Gather keeps replicas: each result packet point receives a value.

### 3. Partition The Map

Partition packet points into maximal groups for which the engine proves:

```text
base(p_k) = base(p_0)
offset(p_k) = offset(p_0) + k
```

Then intersect each group with target constraints:

- legal load or store payload type;
- required alignment;
- address-space limits;
- control and convergence requirements.

Swizzle, padding, partition, and rotation boundaries split groups because the
equalities stop holding. The splitter needs no layout-specific branch.

Search widest legal groups first. Fall back deterministically to smaller
groups, including one element. Budget exhaustion takes the conservative split;
it never assumes contiguity.

### 4. Emit Ordinary Wave IR

For each group:

1. Materialize its first offset with `wave.index_expr`.
2. Select the mapped base.
3. Build `wave.ptr_add`.
4. Emit `wave.load` or `wave.store` with the proved packet width.
5. Extract, pack, or redistribute components into packet order when required.

Generated memory operations are siblings after the input dependency. Join their
tokens for the symbolic operation's result. Do not serialize them unless an
explicit source token requires it.

Existing pointer simplification and memory coalescing may improve the emitted
IR. Correctness does not depend on them reconstructing the original layout.

## Memory Ordering

The mapping says which bytes carry which packet elements. It says nothing about
when an access occurs.

Gather and scatter preserve the optional input dependency and return a joined
completion token. They never infer:

- a store-to-load dependency;
- an alias edge;
- a workgroup barrier;
- ordering from equal mappings.

A shared-memory publish sequence remains explicit:

```text
wave.scatter
wave.barrier after scatter token
wave.gather after barrier token
```

## Pass Placement

Run symbolic memory lowering after metadata specialization and before pointer
index lowering:

```text
wavemeta-specialize
canonicalize
wave-lower-symbolic-memory
wave-lower-redistribute
wave-strength-reduce-modulo
wave-normalize-pointer-offsets
wave-generate-index-exprs
wave-coalesce-memory
wave-resolve-allocs
waveamd-to-machine
```

Run before redistribution because scatter replica selection may require packet
movement. Run before index-expression lowering because it creates
`wave.index_expr` and `wave.ptr_add` operations.

## Diagnostics

Diagnostics report the failed proof, not a guessed layout kind:

- mapping undefined at a packet point;
- memory base selector out of range;
- scatter collision is not a proved broadcast;
- symbolic address cannot be materialized;
- no legal scalar memory access for the element type;
- target split exceeds the configured proof budget.

## Test Plan

Attribute and verifier tests:

- structural expression round-trip;
- single-base and partitioned maps;
- free-symbol and binding mismatch rejection;
- malformed pointer or packet types;
- verifier remains local.

Lowering tests:

- contiguous map becomes one vector access;
- strided map splits into scalar accesses;
- swizzle boundary splits a vector;
- padded boundary splits a vector;
- partition expression selects the right base;
- rotating layout uses an SSA phase binding;
- gather replication loads every packet result;
- scatter broadcast emits one representative store;
- unproved scatter collision rejects;
- generated transactions share one dependency and join tokens.

Integration tests import representative Triton blocked, linear, swizzled,
padded, partitioned, and rotating shared layouts. Checks stop at Wave IR: no
Triton layout attribute survives, and the symbolic map lowers to ordinary Wave
memory operations.

## Acceptance Criteria

- Gather and scatter share one packet-to-memory mapping attribute.
- Mapping stores only symbolic memory coordinates.
- Packet domain, bounds, alignment, masks, ordering, and transaction shape stay
  outside the mapping.
- Triton layout composition ends before Wave operation emission.
- Symbolic lowering derives every load/store split from address equalities and
  target legality.
- Unsupported relations fail with a concrete proof or target diagnostic.
