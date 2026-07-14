# Wave Symbolic Memory Mapping

## Goal

Represent a tensor-to-memory layout relation with one symbolic map:

```text
packet(block, item, slot) <-> memory(base, target_block, bit_offset)
```

`wave.gather` reads through the map. `wave.scatter` writes through the same
map. Lowering uses the Wave symbolic engine to prove maximal physical runs,
then emits the most efficient legal transaction cover. Single-element accesses
are the terminal fallback.

The operation carries no Triton layout, layout name, transaction plan, or
movement class. Triton layout objects disappear after the importer constructs
the map.

This is the memory analogue of `wave.redistribute`. Redistribution maps a
destination packet point to a source packet point. Symbolic memory access maps
a packet point to a complete physical memory point.

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
M = (base, target_block, bit_offset)
```

`base` selects a pointer operand. `target_block` selects the block that owns
the addressed shared memory. `bit_offset` is relative to the selected pointer.
Single-base access defaults `base` to zero. Block-local access defaults
`target_block` to `block`.

The relation is one pointwise symbolic function:

```text
A(block, item, slot; bindings) = (base, target_block, bit_offset)
```

Each pair identifies the same logical tensor element on the packet and memory
sides. Gather and scatter differ only in dataflow direction:

```text
gather:  result[p] = read(A(p))
scatter: write(A(p), source[p])
```

The map contains only its result expressions. The packet side is the identity
domain and need not be serialized. Map outputs need only be defined for packet
points that execute. Predication and unreachable control stay outside the map.

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
and item bounds come from specialized kernel configuration; current
coordinates come from the enclosing kernel. Pointer count, address space,
element type, and base alignment come from operands and allocation facts.
Predication comes from ordinary Wave control. Memory ordering comes from
ordinary Wave tokens.

Transaction count and width are lowering results. Storing either would make
the relation describe one implementation instead of the access.

### Symbolic Representation

The proposed attribute is:

```mlir
#wave.memory_mapping<
  base = #wave.expr<...>,
  target_block = #wave.expr<...>,
  bit_offset = #wave.expr<...>
>
```

`base` and `target_block` use their defaults when absent. Every explicit field
is a structural `sym::ExprHandle` owned by the Wave dialect's symbolic store.
Bit units preserve sub-byte placement; packing and addressable container width
remain lowering decisions.

Reserved symbols are `block`, `item`, and `slot`. Runtime view origins and
similar uniform or lane-varying values are SSA operands bound to named free
symbols on the operation. Bindings are expression inputs, not layout metadata.

Indexed gather and scatter also accept packet bindings:

```text
index(block, item, slot) = indices[block, item, slot]
```

Lowering specializes `slot`, extracts that component from the packet, then
binds the resulting scalar or lane-SIMD value. This fits the existing
`wave.index_expr` binding model without teaching the symbolic store about SIMD
vectors.

Example:

```mlir
#wave.memory_mapping<
  bit_offset = #wave.expr<
    "16 * (origin + xor(item % 16, (item / 16) % 8) * 8 + slot)"
  >
>
```

Text above is illustrative assembly syntax. Builders import expression handles
structurally. Printers are not an interchange format.

### Replication

The map need not be injective.

Gather defines one read result per active packet point. Lowering may share a
read between equal mapped points, then distribute the value.

Scatter defines one unordered write per active packet point. Equal addresses do
not prove equal source values. Lowering may remove a write only with an
independent value-equality proof or a canonical-writer predicate supplied by
the importer. Runtime-index collisions are never silently quotiented.

Atomic, reduction, and ordered collision semantics use different operations.

## Operations

Both operations use `MemoryEffectsOpInterface`. Pointer operands identify the
memory resource. Tokens preserve Wave's explicit ordering model.

Conceptual gather syntax:

```mlir
%value, %done = wave.gather %base
    mapping #wave.memory_mapping<bit_offset = #wave.expr<...>>
    bindings ["origin"](%origin)
    after %dependency
    : !wave.ptr<shared, f16>
      -> !wave.simd<vector<4xf16>, 64>, !wave.mem.token
```

Conceptual scatter syntax:

```mlir
%done = wave.scatter %value -> %base
    mapping #wave.memory_mapping<bit_offset = #wave.expr<...>>
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
      bit_offset = #wave.expr<"...">
    >
```

Indexed access binds its index packet pointwise:

```mlir
%value, %done = wave.gather %base
    mapping #wave.memory_mapping<bit_offset = #wave.expr<"... index ...">>
    packet_bindings ["index"](%indices)
    : !wave.ptr<shared, i32>, !wave.simd<vector<4xi32>, 64>
      -> !wave.simd<vector<4xi32>, 64>, !wave.mem.token
```

Cache policy remains an operation attribute, matching `wave.load` and
`wave.store`. It is not part of the mapping.

V1 maps every executed packet point. A future masked form may add mask and
`other` operands to `wave.gather`, or a mask operand to `wave.scatter`. Masking
does not change the mapping attribute.

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
R_view = V compose R
A = M^-1 compose R_view
```

such that:

```text
M(A(p)) = R_view(p)
```

For linear layouts this is Triton's existing register-to-shared conversion:

```text
invertAndComposeBlockLocal(sharedLayout, registerLayout)
  == registerLayout.invertAndCompose(sharedLayout)
```

The Wave importer converts the resulting `(register, lane, warp, block) ->
(offset[, partition], block)` expressions to:

```text
(block, item, slot) -> (base, target_block, bit_offset)
```

`item` linearizes warp and lane. `slot` names the register component.
`partition` selects `base`. The result `block` becomes `target_block`.
Physical element offsets scale by element bit width after view and padding
composition.

Non-injective inversion uses Triton's smallest deterministic representative.
There is no ambiguous-representative diagnostic. This resolves the algebraic
inverse; it does not authorize dropping colliding scatter points.

### Import Recipe

Ordinary local load and store import:

1. Build `R` with `toLinearLayout` from the result or source tensor.
2. Build `M` with `toLinearLayout`; use `paddedLinearLayout` for the linear
   component of padded storage.
3. Compose the exact memdesc view contract into `R_view` or the final physical
   address.
4. Compute `invertAndComposeBlockLocal(M, R_view)`.
5. Rename and linearize hardware coordinates into Wave packet coordinates.
6. Fold partition selection, owner block, padding, and storage packing into the
   three map results.
7. Import the expressions structurally and drop all Triton layout objects.

Indexed local gather and scatter replace the selected logical axis with an
independent input, matching Triton's indexed-layout construction. Bind that
input to `index(block, item, slot)` through a packet binding.

### Physical Layout Variants

Every physical rule is compiled into the three memory-coordinate expressions:

- swizzling changes `bit_offset` through the imported XOR relation;
- padding adds `floor(raw / interval) * padding` before bit scaling;
- partitioning produces `base` and partition-local `bit_offset`;
- cluster layouts produce `target_block` independently of `base`;
- AMD rotating shared layout compiles its coordinate-derived phase into the
  static XOR relation;
- memdesc views follow their exact physical contract, including partition-base
  rotation and subslice offset composition.

Helper-generated Triton layouts follow the same path. Successful import leaves
only symbolic expressions and SSA bindings in Wave IR.

Target capability never gates import. If the importer cannot express a source
layout structurally, it leaves the source operation for later legalization; it
does not fabricate a map or attach an opaque resolver to a Wave operation.

Current Triton supports partitioned ordinary local load/store but rejects
partitioned indexed gather/scatter. The map can represent the latter; importing
it requires extending the indexed-layout path to retain the `partition` output.

## Verification

### Local Verifier

The verifier checks syntax and local type structure only:

- gather result or scatter source has a supported Wave packet type;
- pointer operands have compatible pointer and element types;
- mapping fields are integral expression handles owned by the active symbolic
  store;
- reserved symbols have their fixed meanings;
- scalar and packet binding names, operand counts, and types match.

The verifier does not evaluate the map. In particular, it does not prove:

- expression definedness;
- `base` range;
- `target_block` reachability or target support;
- bit-offset range, alignment, or allocation bounds;
- scatter uniqueness;
- vector width or addressability;
- any target capability.

Those properties depend on specialization, reachability, operands, or target
state. Code in an unreachable branch remains well-formed even when its map
would be invalid if executed. MLIR verification must not reject it.

### Reachability And Lowerability

Run metadata specialization and dead-region cleanup before symbolic memory
lowering. A proven-dead operation is erased or ignored without interpreting
its map. If reachability is unknown, treat the operation as live.

For a live operation, lowering needs the map only at packet points that can
execute. It simplifies those points using the specialized launch shape,
predication, and SSA bindings. A failed proof is not an invalid configuration:
it rejects that transaction candidate and tries the next narrower candidate.
Proof-budget exhaustion has the same result. Neither scalarizes the whole
operation eagerly.

Pointer bounds follow the same contract as ordinary `wave.load` and
`wave.store`. A known `wave.alloc` gives the pass extra range facts. An unknown
external pointer leaves in-bounds access as the frontend's obligation. No
extent array belongs in the mapping.

Alignment is also derived. Known base alignment plus symbolic bit-offset facts
may enable a wide access. Failure to prove wide alignment forces a narrower
access; it does not invalidate the map.

An actually executed map may still have no legal interpretation: for example,
it may select a missing base or require unsupported remote-block access. Such
an operation can remain in mixed IR. It may fail only when a pipeline requires
complete legalization and no semantics-preserving single-element or container
fallback exists. Detection and diagnostic detail are best effort.

## Lowering

`wave-lower-symbolic-memory` lowers live packet points. Full target pipelines
require no live symbolic gather or scatter to reach WaveAMD selection.

### 1. Specialize Live Packet Points

Bind `block`, `item`, and `slot` to their specialized ranges. Substitute scalar
bindings and simplify the three map results with the Wave symbolic engine.

Specialize each static `slot` before binding packet operands. Extracting one
packet component produces a scalar or lane-SIMD binding that existing
`wave.index_expr` materialization can consume. Dynamic gather/scatter indices
need no new expression value kind.

Do not turn extracted components into unrelated opaque symbols immediately.
Run the existing symbolic-offset builder through `wave.index_expr`, splat,
arithmetic, and select producers first. Reuse one symbol for each irreducible
SSA leaf across all slots. An index packet built as `origin + slot` then retains
that relation, so contiguity can be proved after extraction. Arbitrary runtime
indices remain opaque and take narrower candidates.

Skip packet points proven inactive. Unknown activity stays active.

### 2. Prove Physical Runs

Specialize `slot` but keep `block`, `item`, and runtime bindings symbolic. For
each live slot `s`, normalize:

```text
A_s = (base_s, target_block_s, bit_offset_s)
```

First test packet-order runs. For candidate slots `s .. s + n - 1`, prove for
every `k`:

```text
base(block, item, s + k) = base(block, item, s)
target_block(block, item, s + k) = target_block(block, item, s)
bit_offset(block, item, s + k) = bit_offset(block, item, s) + k * element_bits
```

Build each equality with `sym::composePredCmp` and query it with
`sym::checkPredicate` under launch-range and binding assumptions.
Only `True` forms an edge. `False` and `Unknown` leave the points separate.

Packet order is only the fast path. A layout may place packet slots in a
different physical order. Build a symbolic successor graph as well:

```text
successor(a, b) iff
  base_b = base_a and
  target_block_b = target_block_a and
  bit_offset_b = bit_offset_a + element_bits
```

Keep all proven successor edges. Unbranched components become maximal physical
runs. Competing paths remain alternatives for the transaction planner. Gather
may collapse proven equal physical points before building runs, then replicate
the loaded value. Scatter keeps every point; equal addresses do not remove
writes or create successor edges.

A swizzle, padding, partition, rotation, cluster, or dynamic-index boundary
splits a run only where the symbolic engine cannot prove the successor. Cache
normalized expressions and proof results across candidate widths.

### 3. Choose The Widest Legal Cover

Ask the target for supported transaction shapes in descending payload width.
Generic shapes supply payload width, required alignment, operation kind, and
cost. Target-specific matchers may also propose a shape such as a transpose
load by supplying its expected packet-to-memory relation. Prove that relation
against the same symbolic map. All candidate state is transient; none becomes
an operation attribute.

For every physical run or target-specific match, enumerate candidates in
descending payload width and prove the remaining requirements:

- first-point alignment satisfies the transaction;
- element type and bit packing cover the payload exactly;
- address space, cache policy, and `target_block` support the operation;
- every slot has the same active-lane semantics;
- the access stays within any known allocation facts.

Use the symbolic engine for alignment and range predicates. Target legality is
queried only after contiguity succeeds.

Choose a non-overlapping cover of all live packet points with this
lexicographic objective:

1. minimize packet points lowered as single-element accesses;
2. minimize target transaction cost, then transaction count;
3. prefer wider payloads and stable packet order as tie-breakers.

Use interval dynamic programming for unbranched physical runs. Use a bounded
exact-cover search only for components with competing successor paths or
target-specific relation candidates. If the widest candidate fails, try every
smaller supported vector shape covering those points before admitting a
single-element candidate. One failed or exhausted proof never scalarizes an
unrelated part of the map.

Spend proof budget where it can remove scalar accesses. Run cheap widest-first
queries first. If the selected cover still contains a single-element access,
retry unresolved multi-element candidates that could replace it with the
remaining proof budget before finalizing the cover. Cache every result; never
repeat an identical predicate query.

Do not combine unrelated `item` points into a vector payload. `wave.load` and
`wave.store` already execute their item dimension across SIMD lanes; widening
adds per-lane slot payload. A target-specific candidate may cover an item
permutation only when its relation matcher proves the complete mapping.

Here, scalar fallback means one logical element per active lane. The planner
minimizes scalarized points across the whole run and admits them only when no
non-overlapping all-vector cover exists among proved candidates. `Unknown`
cannot be emitted for correctness, so necessity is relative to the available
proofs and target operations.

Sub-byte points still use an addressable container: gather extracts selected
bits; scatter packs all owned fields or uses a legal target bit update. A live
sub-byte scatter with neither option has no generic fallback.

Example: four `f16` packet slots map to bit offsets:

```text
[B, B + 32, B + 16, B + 48]
```

The successor proof produces physical order `[0, 2, 1, 3]`. If the target
accepts a 64-bit transaction at `B`, gather emits one load and repacks its four
components into packet order. If only 32-bit transactions are proved legal, it
emits two. It never starts with four `f16` loads and waits for coalescing.

### 4. Emit Ordinary Wave IR

For each chosen transaction:

1. Materialize `base`, `target_block`, and `bit_offset`.
2. Select the pointer base.
3. Split byte address from any intra-byte bit position.
4. Emit local or target-block address construction.
5. Emit the selected vector, transpose, scalar, or remote memory operation.
6. Gather: unpack physical order into packet order.
7. Scatter: pack packet values into physical order before the store.

Generated memory operations are siblings after the input dependency. Join their
tokens for the symbolic operation's result. Do not serialize them unless an
explicit source token requires it.

Pointer simplification and `wave-coalesce-memory` may clean up interactions
between independently lowered operations. Symbolic memory lowering itself must
emit the efficient per-operation cover; no later pass is expected to rebuild
wide transactions from scalar accesses.

## Memory Ordering

The mapping says which bits carry which packet elements. It says nothing about
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

Run symbolic memory lowering after metadata specialization and dead-region
canonicalization, but before redistribution and pointer-index lowering:

```text
wavemeta-specialize
canonicalize
wave-lower-symbolic-memory
wave-lower-redistribute
wave-strength-reduce-modulo
wave-normalize-pointer-offsets
wave-generate-index-exprs
wave-promote-global-to-buffer
wave-combine-pointer-offsets
wave-simplify-index-exprs
wave-coalesce-memory
wave-resolve-allocs
waveamd-to-machine
```

Lowering may create redistribution while packing gather results. It also
creates `wave.index_expr` and pointer arithmetic, so both consumers must run
after it.

## Failure Boundary

Optimization-proof failure and budget exhaustion reject one candidate. The
planner continues through narrower vector shapes and admits a single-element
access only after none is proved legal. Target uncertainty follows the same
rule when a generic fallback exists; otherwise the operation remains for
required legalization. None diagnoses at this stage.

A proven-dead operation never diagnoses. A live operation may fail only at a
required legalization boundary when no semantics-preserving fallback exists.
Examples include an unmaterializable base, unsupported remote-block access, or
a sub-byte scatter with no legal container update. These examples do not define
a promised diagnostic set. Invalid configurations and diagnostic wording are
detected on a best-effort basis, not as a verifier contract.

## Triton Bridge Sequence

The current bridge has hard-coded dense, swizzled, and padded physical plans
and recognizes only a narrow local-load subset. Replace that surface in stages:

1. Add the structural mapping attribute and gather/scatter operations.
2. Export Triton `LinearLayout` relations for ordinary local load/store and
   compile them into the three mapping expressions.
3. Compose memdesc views before import; never reconstruct them from printed
   attributes.
4. Add packet bindings for indexed local gather/scatter.
5. Preserve partition and cluster outputs as `base` and `target_block`.
6. Add sub-byte container lowering and target-specific remote access.
7. Add target transaction candidates, including transpose forms, to the same
   widest-cover planner.

At every stage, an unsupported source operation stays in its source dialect
until a later required legalization. No Triton layout attaches to a Wave
operation.

## Test Plan

Attribute and verifier tests:

- structural expression round-trip;
- single-base and partitioned maps;
- free-symbol and binding mismatch rejection;
- malformed pointer or packet types;
- structurally valid undefined, out-of-range, remote, and target-unsupported
  maps pass verification;
- unsupported mapping in a dead branch passes verification.

Lowering tests:

- packet binding specializes and extracts each dynamic-index slot;
- affine packet-index producers retain cross-slot contiguity;
- opaque runtime indices scalarize only after vector proofs fail;
- a proved contiguous run emits the widest legal access without coalescing;
- permuted packet slots emit one physical-order vector access plus repacking;
- failed maximum-width alignment selects the next vector width, not scalars;
- mixed contiguous and strided points scalarize only the isolated points;
- swizzle and padded boundaries get the widest cover on each side;
- partition expression selects the right base;
- cluster output preserves `target_block`;
- rotating layout uses its static coordinate-derived phase;
- sub-byte gather extracts from its addressable container;
- sub-byte scatter preserves unrelated container bits;
- gather replication loads every packet result;
- colliding scatter points emit every write;
- independently proved equal scatter values may share one writer;
- a failed or exhausted proof affects only its transaction candidate;
- last-chance proof budget is spent on candidates that remove scalar accesses;
- disabling `wave-coalesce-memory` does not change transaction width;
- a dead unsupported mapping is erased without a diagnostic;
- a live unsupported mapping fails only at required legalization;
- generated transactions share one dependency and join tokens.

Integration tests import representative Triton blocked, linear, swizzled,
padded, partitioned, rotating, indexed, and cluster shared layouts. Checks stop
at Wave IR where target support is incomplete: no Triton layout attribute
survives, and supported symbolic maps lower to ordinary Wave memory operations.

## Acceptance Criteria

- Gather and scatter share one packet-to-memory mapping attribute.
- Mapping stores only complete symbolic physical coordinates: pointer base,
  owner block, and bit offset.
- Packet domain, bounds, alignment, masks, ordering, and transaction shape stay
  outside the mapping.
- Triton layout composition ends before Wave operation emission.
- Verifiers remain structural; unreachable invalid configurations are
  well-formed.
- Symbolic proofs form maximal physical runs and drive a widest-legal target
  cover during symbolic memory lowering.
- The planner minimizes single-element accesses globally and uses them only
  when proved vector candidates cannot form a complete non-overlapping cover.
- Memory coalescing is cleanup, not the source of per-operation vectorization.
- Only live operations with no legal fallback may fail required legalization;
  diagnostics are best effort.
