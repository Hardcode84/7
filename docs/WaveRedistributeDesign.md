# Wave Symbolic Redistribution

## Goal

Represent layout conversion between two per-lane packets with one operation:

```mlir
%dst = wave.redistribute %src,
    <items = 128, source_item = "xor(item, 64)", source_slot = "slot">
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
- No scratch lifetime or offset-reuse policy. Generic Wave allocation owns it.

## Value Model

A value of type `!wave.simd<vector<NxT>, W>` is a packet of `N` values for each
lane of a width-`W` wave. V1 requires full-wave execution: every lane is active
at each dynamic redistribution instance. Redistribution treats the
workgroup-wide value as a grid:

```text
value[item, slot]
```

`item` is row-major linear workitem position in the workgroup. `slot` is the
element position in the per-lane vector payload.

The operation has one source and one result. Source and result must have:

- equal SIMD width `W`;
- equal vector element type `T`;
- fixed, one-dimensional vector payloads;
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
Equal operations may CSE: collective epoch and internal synchronization are not
semantic state. Lack of speculatability prevents motion into a new control
context.

An LDS implementation does not expose a barrier to surrounding IR. Code must
not rely on redistribution to order unrelated shared, global, buffer, or
private memory. Such ordering remains explicit through `!wave.mem.token` edges.

## Verifier

`wave.redistribute::verify()` is local. It checks only the operation's types and
attributes:

- source and result are `!wave.simd<vector<...>, W>`;
- SIMD widths and vector element types match;
- vector payloads are fixed, not scalable;
- `items` is positive;
- relation expressions are valid integer expressions;
- free symbols are a subset of `item` and `slot`;
- the relation is total over the static destination domain;
- every evaluated source item and slot is in bounds.

Static-domain evaluation is exact and uses checked arithmetic. Symbolic range
inference runs first. If it is inconclusive, the verifier exhausts at most
`2^20` destination points. Larger domains require a symbolic proof; they do not
start unbounded enumeration.

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

These rewrites run inside `wave-lower-redistribute` after contextual validation.
They are not generic op folders or canonicalizers: a used identity must not
erase its `items` check before lowering.

Identity relation:

```text
source_item = item
source_slot = slot
```

folds to the source when source and result types match.

Adjacent redistributions with equal `items` compose by symbolic substitution.
Given:

```text
b = R1(a)
c = R2(b)
```

and no other use of `b`, replace them with:

```text
c = compose(R1, R2)(a)
```

The gather direction makes composition direct: substitute `R2`'s source item
and slot into `R1`. Reverify the composed relation over the shared item domain,
then simplify it in the dialect store. Different item domains do not compose.

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
  source type == result type

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
wave.alloc_release after the release barrier
```

Stores are siblings, not a component-by-component chain. Loads are siblings and
all depend on the publish barrier. The release barrier consumes all load tokens
and `wave.alloc_release` binds that completion token to the scratch allocation.
The release result orders accesses to any later allocation sharing its storage.

Scratch lifetime, overlapping offsets, reuse dependencies, and loop-carried
reuse are general `wave.alloc` concerns. `wave.redistribute` neither changes nor
duplicates that policy. The allocator may reuse this scratch only under its
ordinary explicit-token contract.

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
V1 requires full-wave execution for every movement class. Frontend facts or
context analysis establish that invariant before lowering; `verify()` does not.

After establishing full-wave execution, local movement needs no workgroup
participation proof beyond the requirements of the selected Wave operations.

After selecting workgroup LDS, lowering must prove that every participating
wave executes the same dynamic redistribution instance. The proof may come
from control-flow analysis or explicit trusted frontend facts already modeled
outside the operation verifier.

If workgroup participation is not proven:

- an optional same-wave LDS choice falls back to shuffle;
- an inherently cross-wave relation fails lowering with a convergence
  diagnostic.

`wave.where` and other lane-masked contexts reject for every movement class in
V1. Cross-wave lowering may additionally accept only straight-line kernel
control and regions proven workgroup-uniform. Loops with unproven common trip
counts reject only when lowering needs workgroup LDS.

Do not add an `assume_uniform` escape-hatch attribute to
`wave.redistribute`. Control facts need provenance and scope outside this op.

## Workgroup Shape

The relation carries `items` so its finite domain is self-contained. Every
lowering requires a known workgroup shape whose flattened size equals `items`.
Unknown or inconsistent shape rejects before folding or classification.

V1 supports X-linear workgroups:

```text
wave.workgroup_size = [items, 1, 1]
item = workitem_id_x
items % W == 0
```

Y/Z workgroup shapes require target support for all coordinate operands plus
row-major linearization. Until then they reject with a shape diagnostic; using
X alone would alias scratch rows.

## Triton LinearLayout Import

Triton layouts map named hardware coordinates to logical tensor coordinates.
For source layout `S` and destination layout `D`:

```text
C = D.invertAndCompose(S)
D(destination_hardware) == S(C(destination_hardware))
```

`C` is already the destination-to-source gather direction required by
`wave.redistribute`. The full map is the logical-equivalence witness. Import
then projects away coordinates that Wave does not represent.

For a nontrivial `block` dimension:

1. Build `C_local = invertAndComposeBlockLocal(S, D)` to select current-block
   representatives for broadcast source block bits.
2. Require `C_local.quotient(block)` to succeed.
3. Use the quotient as the Wave gather map.

Call the quotient `C_wave`. When `block` is absent or has size one, structurally
dropping it from `C` defines `C_wave`.

Block output identity alone is insufficient: destination block bits may still
affect source register, lane, or warp. Such a map cannot be expressed using only
`item` and `slot`. Quotienting `block` is required projection; quotienting other
common slow dimensions remains an optimization aid.

For standard distributed dimensions:

```text
destination register = slot
destination lane     = Mod(item, W)
destination warp     = floor(item / W)

(source register, source lane, source warp) = C_wave(...)

source_slot = source register
source_item = source lane + W * source warp
```

Failure to select a block-local representative or quotient `block` rejects the
import. Nonlocal block movement needs a future cluster-distribution operation;
workgroup LDS cannot implement it.

### Basis translation

`LinearLayout` is linear over GF(2). Translate each result coordinate with:

```text
bit(x, k) = Mod(floor(x / 2^k), 2)

result_coordinate =
  xor over input dimensions d and basis bits k:
    bit(d, k) * basis[d][k][result_coordinate]
```

Wave's symbolic algebra already represents integer arithmetic, floor, modulo,
and XOR. Triton performs inversion, composition, block-local representative
selection, quotienting, and deterministic representative selection for
remaining non-injective source layouts. ixsimpl carries, composes, simplifies,
and proves the resulting expressions; it is not a second layout solver.

### Named-dimension normalization

The importer keeps Triton's named dimensions until it has built `C`. It then
uses structural source and destination adapters between named layout inputs and
Wave's `(item, slot)` coordinates.

Standard distributed values bind `register`, `lane`, `warp`, and `block` as
above. An additional dimension may fold into `slot` only when its adapter proves
that every coordinate is simultaneously resident in the vector packet and that
the flattening is bijective.

Sequential `iteration`, transfer `message`, cluster `block`, and physical-memory
`partition` dimensions are not packet coordinates. They require external
lowering context or reject. Scale or other helper dimensions follow the same
resident-packet rule; their names do not grant slot ownership.

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

Run `wave-lower-redistribute` after metadata specialization and early generic
canonicalization, before:

```text
wave-normalize-pointer-offsets
wave-generate-index-exprs
wave-simplify-index-exprs
wave-coalesce-memory
wave-resolve-allocs
waveamd-to-machine
```

The pass first validates every redistribution's execution and workgroup domain.
It then composes, folds, classifies, and expands relations. This lets generated
scratch addresses reuse `wave.index_expr` simplification, memory coalescing,
normal allocation placement, and ordinary WaveAMD machine selection. Generic
allocation/resource planning owns aggregate LDS capacity and reuse ordering. No
`wave.redistribute` may reach `waveamd-to-machine`.

## Diagnostics

Diagnostics name the failed contract:

- malformed or non-total relation: operation verifier;
- source coordinate outside relation domain: operation verifier;
- scalable vector payload: operation verifier;
- exhaustive verifier budget exceeded without symbolic proof: operation
  verifier;
- workgroup item count mismatches kernel shape: lowering;
- unsupported multidimensional workgroup shape: lowering;
- partial-wave workgroup violates the full-wave V1 contract: lowering;
- redistribution is not in full-wave control: lowering;
- required cross-wave participation is not proven: lowering;
- block cannot be projected from the relation: frontend import;
- non-resident named dimension has no external adapter: frontend import;
- relation crosses workgroups: frontend import;
- aggregate LDS capacity exceeded: generic allocation/resource planning;
- payload has no bit-preserving storage codec: lowering;
- symbolic expression cannot be selected on the target: lowering.

No failure fabricates values or silently changes the relation.

## Test Plan

### Dialect

- Parse/print structural redistribution attributes.
- Reject unknown free symbols, invalid or scalable types, and out-of-range maps.
- Reject an oversized exhaustive fallback when symbolic proof is inconclusive.
- Verify redistribution under `wave.where` without performing a control check.
- Compose equal-domain adjacent relations and fold identity after context
  validation.
- Refuse composition across different item domains.

### Classification

- Identity.
- Identity slots with different packet sizes classify as same-workitem.
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
- Any redistribution under lane-masked control fails the V1 full-wave contract.
- Local and cross-wave conversions require exact `items`/workgroup-size parity.
- A workgroup whose size is not divisible by `W` fails the full-wave contract.
- Multidimensional workgroup shape reports the V1 shape diagnostic.
- Cross-wave conversion under unproven control passes operation verification
  and fails only `wave-lower-redistribute`.
- Cross-wave conversion under a `wave.subgroup_id`-dependent scalar branch
  fails the workgroup-participation proof.
- Unsupported scratch payload reports its storage-codec diagnostic.
- Generic resource planning diagnoses aggregate redistribution scratch plus
  existing LDS allocations that exceed target capacity.

### Triton parity

For blocked, linear, generic-linear, slice, dot-operand, MFMA, and supported
WMMA layouts:

1. Build `C = D.invertAndCompose(S)`.
2. Select block-local representatives and quotient `block`.
3. Import the symbolic redistribution relation.
4. Exhaust the static destination domain.
5. Reinsert the current block coordinate and check
   `D(dst) == S(relation(dst))` at every point and block.
6. Check remaining non-injective cases select Triton's representative.

Cover a broadcast source block that projects locally and a map whose block
output is identity but whose block input affects source lane or register; the
latter rejects. Cover resident helper dimensions and reject `iteration`,
`message`, or `partition` without external context.

Add an integration test for cross-wave code generation. Run PerfGolden when a
new lowering changes checked-in assembly; ASM drift still requires hardware
measurement before golden replacement.

## Acceptance Criteria

- One `wave.redistribute` operation represents all supported movement classes.
- Operation verifier contains no uniformity, convergence, parent-control, or
  target-resource check.
- V1 lowering accepts only full-wave, X-linear execution with exact static
  workgroup-domain parity.
- Lowering derives movement scope from the complete symbolic relation.
- Cross-wave lowering emits explicit LDS token and barrier edges.
- Scratch reuse and aggregate LDS capacity stay in generic allocation/resource
  planning.
- Internal barriers do not become user-visible memory-ordering semantics.
- Triton `LinearLayout` conversions import through structural gather relations,
  not layout-kind cases or component-count guesses.
- Triton block coordinates are projected only after block-local representative
  selection and successful quotienting.
- Only simultaneously resident packet dimensions flatten into `slot`.
- Wave values stay `!wave.simd<vector<...>, W>`; MMA fragments remain local to
  MMA emission.
- Unsupported relations fail with a specific diagnostic.
