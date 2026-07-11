# Wave Symbolic Redistribution

## Goal

Represent layout conversion between two per-lane packets with one operation:

```mlir
%dst = wave.redistribute %src #map
    : !wave.simd<vector<NsxT>, W>
   -> !wave.simd<vector<NdxT>, W>
```

`#map` states which source workitem and source packet slot supply every
destination packet slot. Lowering selects aliasing, register movement, wave
shuffle, or workgroup LDS exchange from that relation.

The operation does not carry a movement mode, scratch plan, synchronization
scope, or memory token.

## Non-goals

- No layout parameter on `!wave.simd` or builtin vector types.
- No Wave copy of Triton's layout class hierarchy.
- No source/destination layout objects in Wave IR.
- No uniform-control or convergence check in `verify()`.
- No implicit ordering for user-visible memory.
- No cross-workgroup or cluster exchange through workgroup LDS.
- No target instruction choice in the operation contract.

## Value Model

A value of type `!wave.simd<vector<NxT>, W>` is a packet of `N` values for each
active lane of a width-`W` wave. Redistribution treats the workgroup-wide value
as a grid:

```text
value[item, slot]
```

`item` is row-major linear workitem position in the workgroup. `slot` is the
element position in the per-lane vector payload.

The operation has one source and one result. Source and result must have:

- equal SIMD width `W`;
- equal vector element type `T`;
- one-dimensional vector payloads;
- positive source and result slot counts.

Source and result slot counts may differ. Replicated destination values and
unused source replicas are legal.

## Redistribution Relation

The relation is a total gather map:

```text
(destination item, destination slot) -> (source item, source slot)
```

For every destination coordinate in the declared domain:

```text
dst[item, slot] =
    src[source_item(item, slot), source_slot(item, slot)]
```

The proposed attribute is:

```mlir
#wave.redistribution<
  items = 128,
  source_item = #wave.expr<xor(item, 64)>,
  source_slot = #wave.expr<slot>
>
```

`item` and `slot` are reserved symbolic names. Their implicit bounds are:

```text
0 <= item < items
0 <= slot < destination slot count
```

The result expressions must satisfy:

```text
0 <= source_item < items
0 <= source_slot < source slot count
```

No partial relation exists in v1. A frontend must not fabricate a source for an
uncovered destination. It rejects the conversion instead.

The attribute stores two `sym::ExprHandle`s in the Wave dialect's symbolic
store. Structural APIs import or compose the expressions. Text is only an
assembly parser/printer boundary.

## Operation Semantics

`wave.redistribute` is an abstract communication operation over an
unobservable private resource. Its result is determined only by the source
value and relation.

The operation has `NoMemoryEffect`, matching the abstract behavior of
`wave.shuffle`. It is not marked `Pure` or unconditionally speculatable.

An LDS implementation does not expose a barrier to surrounding IR. Code must
not rely on redistribution to order unrelated shared, global, buffer, or
private memory. Such ordering remains explicit through `!wave.mem.token` edges.

## Verifier

`wave.redistribute::verify()` is local. It checks only the operation's types and
attributes:

- source and result are `!wave.simd<vector<...>, W>`;
- SIMD widths and vector element types match;
- `items` is positive;
- relation expressions are valid integer expressions;
- free symbols are a subset of `item` and `slot`;
- the relation is total over the static destination domain;
- every evaluated source item and slot is in bounds.

Static-domain evaluation is exact. Symbolic range inference may discharge a
check first, but an inconclusive range result is not a verifier failure when
finite evaluation can decide it.

The verifier does not inspect:

- the parent function or kernel workgroup shape;
- surrounding `wave.where`, `scf.if`, or loop control;
- operand producers or result users;
- uniformity or convergence;
- target features;
- LDS availability or capacity;
- profitability of shuffle versus LDS.

Those checks require context and belong to lowering.

## Canonicalization

Identity relation:

```text
source_item = item
source_slot = slot
```

folds to the source when source and result types match.

Adjacent redistributions compose by symbolic substitution. Given:

```text
b = R1(a)
c = R2(b)
```

and no other use of `b`, replace them with:

```text
c = compose(R1, R2)(a)
```

The gather direction makes composition direct: substitute `R2`'s source item
and slot into `R1`. Simplify the resulting expressions in the dialect store.

Internal synchronization is not observable at this level. Removing an
intermediate redistribution cannot remove a user-visible memory-ordering edge.

## Lowering Classification

`wave-lower-redistribute` classifies the complete relation. It does not trust a
frontend movement tag.

For wave width `W`:

```text
alias:
  source_item == item
  source_slot == slot

same workitem:
  source_item == item

same wave:
  floor(source_item / W) == floor(item / W)

same workgroup:
  0 <= source_item < items
```

The pass simplifies and proves these predicates under the relation domain. If
proof is inconclusive, it evaluates every static `(item, slot)` point. The
first true class in the order above is the minimum required communication
scope.

Examples for `W = 64`, `items = 128`:

| Relation | Minimum movement |
|---|---|
| `source_item = item`, `source_slot = 3 - slot` | register packet remap |
| `source_item = xor(item, 1)`, `source_slot = slot` | same-wave shuffle |
| `source_item = xor(item, 64)`, `source_slot = slot` | cross-wave LDS |

The cost model may select a broader implementation than the minimum. A
same-wave relation may use LDS when profitable. Broader selection remains
subject to control and resource legality.

## Local Lowering

### Same workitem

Substitute each constant destination slot into `source_slot`.

When the result is a constant, lower to `wave.extract` and `wave.pack`. When it
depends on `item`, extract candidate source slots and select per lane from the
materialized source-slot expression.

### Same wave

Materialize:

```text
source_lane = Mod(source_item, W)
```

For each result slot, shuffle candidate source components from `source_lane`,
then select the component named by `source_slot`. Group equal lane expressions
and shuffle whole vector packets when legal.

Local lowering introduces no memory token or workgroup barrier.

## Workgroup LDS Lowering

The correctness-first scratch layout gives every source coordinate a unique
cell:

```text
scratch_index(item, slot) = item * source_slots + slot
```

Every participating workitem stores its source packet. After a publish barrier,
each destination slot loads:

```text
scratch_index(source_item(item, slot), source_slot(item, slot))
```

Canonical expansion:

```text
wave.alloc
parallel wave.store operations
wave.barrier after all store tokens
parallel wave.load operations after the publish barrier
wave.pack
wave.barrier after all load tokens
```

Stores are siblings. They may consume one common incoming dependency when
scratch reuse requires it; they are not chained component by component. Loads
are siblings and all depend on the publish barrier.

V1 emits the release barrier after loads. The high-level operation has no token
result, and current LDS allocation may reuse offsets from lexical lifetimes.
The release barrier prevents a later exchange or loop iteration from
overwriting a cell while another wave still reads it.

A later scratch planner may omit the release barrier only when it proves the
allocation cannot be reused before all participating waves finish their loads.
Any reuse plan must materialize the required token and barrier edges before
`wave-resolve-allocs` assigns overlapping offsets.

### Scratch optimization

The planner may replace the canonical layout with a proven bijection:

```text
physical_cell = P(item, slot)
```

Store and load addressing use the same `P`. Swizzling, padding, row stride,
bank-conflict avoidance, and vector packetization belong here. They do not
change the redistribution relation.

The storage codec must preserve `T` bits. Directly storable payloads use Wave
memory operations. Other payloads require a structural, equal-bitwidth codec,
potentially a dedicated Wave bitcast, or produce a clear unsupported-payload
diagnostic. Numeric conversion is not a storage codec.

## Control Legality

Control legality is a lowering concern, not an operation verification concern.

After selecting local movement, lowering needs no workgroup participation
proof beyond the requirements of the selected Wave operations.

After selecting workgroup LDS, lowering must prove that every participating
wave executes the same dynamic redistribution instance. The proof may come
from control-flow analysis or explicit trusted frontend facts already modeled
outside the operation verifier.

If workgroup participation is not proven:

- an optional same-wave LDS choice falls back to shuffle;
- an inherently cross-wave relation fails lowering with a convergence
  diagnostic.

V1 may conservatively accept only straight-line kernel control and regions
proven workgroup-uniform. `wave.where`, lane-varying branches, and loops with
unproven common trip counts reject only when lowering needs workgroup LDS.

Do not add an `assume_uniform` escape-hatch attribute to
`wave.redistribute`. Control facts need provenance and scope outside this op.

## Workgroup Shape

The relation carries `items` so its finite domain is self-contained. Lowering
checks that `items` matches the enclosing kernel's known flattened workgroup
size.

For a three-dimensional workgroup:

```text
item = x + size_x * (y + size_y * z)
```

Lowering materializes the target's available workitem coordinates and this
linearization. Unknown or inconsistent workgroup shape rejects a cross-wave
lowering. A local lowering may proceed when its required coordinate expression
can still be materialized and proven.

## Triton LinearLayout Import

Triton layouts map named hardware coordinates to logical tensor coordinates.
For source layout `S` and destination layout `D`:

```text
C = D.invertAndCompose(S)
D(destination_hardware) == S(C(destination_hardware))
```

`C` is already the destination-to-source gather direction required by
`wave.redistribute`. Use the full `C` for semantics. Quotienting common slow
dimensions, as in Triton's `minimalCvtLayout()`, is an optimization aid, not a
movement mode carried into Wave IR.

For standard distributed dimensions:

```text
destination register = slot
destination lane     = Mod(item, W)
destination warp     = floor(item / W)

(source register, source lane, source warp, source block) = C(...)

source_slot = source register
source_item = source lane + W * source warp
```

The importer requires source block to equal destination block. Non-identity
block movement needs a future cluster-distribution operation; workgroup LDS
cannot implement it.

### Basis translation

`LinearLayout` is linear over GF(2). Translate each result coordinate with:

```text
bit(x, k) = Mod(floor(x / 2^k), 2)

result_coordinate =
  xor over input dimensions d and basis bits k:
    bit(d, k) * basis[d][k][result_coordinate]
```

Wave's symbolic algebra already represents integer arithmetic, floor, modulo,
and XOR. Triton performs inversion, composition, quotienting, and deterministic
representative selection for non-injective source layouts. ixsimpl carries,
composes, simplifies, and proves the resulting expressions; it is not a second
layout solver.

### Named-dimension normalization

The importer keeps Triton's named dimensions until it has built `C`. It then
uses structural source and destination adapters between named layout inputs and
Wave's `(item, slot)` coordinates.

Standard adapters bind `register`, `lane`, `warp`, and `block` as above.
Helper-generated dimensions such as `iteration`, `partition`, `message`, or
scale dimensions must have an explicit structural packet encoding. The adapter
folds packet-local dimensions into `slot`. Missing or non-bijective adapters
reject the conversion.

This normalization keeps Wave IR independent of Triton dimension names without
assuming every frontend layout starts with one fixed tuple.

Dot-operand and AMD MMA layouts use their Triton `toLinearLayout` helpers and
the same normalization. Values remain `!wave.simd<vector<...>, W>` during
redistribution. WaveAMD fragments may be constructed immediately around MMA
emission; they are not layout carriers.

Shared-memory layouts do not enter this value-to-value operation. Their padded,
swizzled, partitioned, or rotating physical offsets remain a separate memory
layout problem.

## Pass Placement

Run `wave-lower-redistribute` after metadata specialization and early
canonicalization, before:

```text
wave-normalize-pointer-offsets
wave-generate-index-exprs
wave-simplify-index-exprs
wave-coalesce-memory
wave-resolve-allocs
waveamd-to-machine
```

This lets generated scratch addresses reuse `wave.index_expr` simplification,
memory coalescing, normal allocation placement, and ordinary WaveAMD machine
selection. No `wave.redistribute` may reach `waveamd-to-machine`.

## Diagnostics

Diagnostics name the failed contract:

- malformed or non-total relation: operation verifier;
- source coordinate outside relation domain: operation verifier;
- workgroup item count mismatches kernel shape: lowering;
- required cross-wave participation is not proven: lowering;
- relation crosses workgroups: frontend import;
- target lacks LDS capacity: lowering;
- payload has no bit-preserving storage codec: lowering;
- symbolic expression cannot be selected on the target: lowering.

No failure fabricates values or silently changes the relation.

## Test Plan

### Dialect

- Parse/print structural redistribution attributes.
- Reject unknown free symbols, invalid types, and out-of-range maps.
- Verify redistribution under `wave.where` without performing a control check.
- Compose adjacent relations and fold identity.

### Classification

- Identity.
- Per-workitem slot reversal.
- Item-dependent source-slot selection.
- Adjacent-lane XOR.
- Register/lane mixed transpose.
- Cross-wave XOR.
- Replicated source representative.

### Lowering

- Same-workitem conversion emits only extract/select/pack.
- Same-wave conversion emits shuffle without LDS or barrier.
- Cross-wave conversion emits sibling stores, publish barrier, sibling loads,
  and release barrier with explicit token edges.
- Same-wave conversion under lane control remains locally lowerable.
- Cross-wave conversion under unproven control passes operation verification
  and fails only `wave-lower-redistribute`.
- Unsupported scratch payload reports its storage-codec diagnostic.

### Triton parity

For blocked, linear, generic-linear, slice, dot-operand, MFMA, and supported
WMMA layouts:

1. Build `C = D.invertAndCompose(S)`.
2. Import the symbolic redistribution relation.
3. Exhaust the static destination domain.
4. Check `D(dst) == S(relation(dst))` at every point.
5. Check non-injective cases select Triton's representative.

Add an integration test for cross-wave code generation. Run PerfGolden when a
new lowering changes checked-in assembly; ASM drift still requires hardware
measurement before golden replacement.

## Acceptance Criteria

- One `wave.redistribute` operation represents all supported movement classes.
- Operation verifier contains no uniformity, convergence, parent-control, or
  target-resource check.
- Lowering derives movement scope from the complete symbolic relation.
- Cross-wave lowering emits explicit LDS token and barrier edges.
- Internal barriers do not become user-visible memory-ordering semantics.
- Triton `LinearLayout` conversions import through structural gather relations,
  not layout-kind cases or component-count guesses.
- Wave values stay `!wave.simd<vector<...>, W>`; MMA fragments remain local to
  MMA emission.
- Unsupported relations fail with a specific diagnostic.
