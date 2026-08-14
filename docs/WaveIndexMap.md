# Wave index-map algebra

Wave represents placement, redistribution, and memory addresses with one
private algebra: tuples of `ixsimpl` expressions over bounded integer
coordinates. There is no second Wave layout evaluator and no layout-specific
solver.

A complete placement is an ordinary composition of arithmetic maps:

```text
placement(local, wave, tile, workgroup)
  = local_layout(local)
  + wave_origin(wave)
  + tile_origin(tile)
  + workgroup_origin(workgroup)
```

The expressions may contain integer addition, multiplication, division,
remainder, bitwise operations, and rounding. Layout construction does not
enumerate packet positions into `Piecewise` arms. A `Piecewise` expression may
still arrive from real source control flow, but it is not a layout
representation.

## Closed maps and proof

`indexing::IndexMap` contains:

- named inputs, with optional finite extents and optional SSA bindings;
- producer facts;
- definedness requirements transported by partial composition;
- exact definitions for proof-only coordinates; and
- one output expression tuple.

An input of extent `n` has the canonical integer domain `0 <= x < n`. An SSA
binding identifies the exact value that can materialize that input. An
unbound input is a proof coordinate and must disappear through composition
before emission.

`pullback(source, domain, substitutions)` composes maps by simultaneous exact
substitution. It transports facts, requirements, definitions, and outputs to
the new domain; it does not infer a replacement relation or invent a range.
`materialize(map, expression)` applies the proved definitions and returns an
expression over materializable inputs.

`check(map, goals)` is the only reasoning boundary. It creates one `ixsimpl`
analysis from the map facts and canonical input domains, proves every
transported requirement, then proves each requested goal. `False` and
`Unknown` both reject a proposed lowering. Consumers may propose finite
transaction widths or vector factors, but only the complete expression proof
accepts them.

`indexing::IndexAddress` adds a typed base and the tuple
`(owner, bitOffset, active)` to an `IndexMap`. Bits are the canonical address
unit. Pointer normalization, symbolic memory, DMA, and redistribution scratch
addresses all use this type.

## Redistribution

A redistribution is the direct map

```text
R(block, item, slot) = (sourceBlock, sourceItem, sourceSlot)
```

over its complete bounded destination domain. Movement classification,
same-wave shuffles, and workgroup scratch lowering all consume `R`; none keeps
a parallel flattened packet order.

Movement is the strongest identity that `check` proves directly on `R`:

```text
alias     : R == (block, item, slot)
workitem  : R.block == block and R.item == item
wave      : R.block == block and floor(R.item / waveSize)
                                      == floor(item / waveSize)
workgroup : R.block == block
```

This classification selects only the communication scope. Workitem lowering
materializes `R.slot` directly. Wave and workgroup lowering factor the binary
slot coordinates of `R` without changing the relation. For a proposed packet
width `V`, let `D` be `log2(V)` destination-slot axes and `S` the source-slot
axes which depend on them. A candidate is legal only when toggling every axis
in `D` preserves the source owner and changes no source axis outside `S`.
`Pd` and `Ps` are the bit permutations that move `D` and `S`, respectively,
to the low-order positions:

```text
resultGroup  = floor(Pd(slot) / V)
resultWithin = Mod(Pd(slot), V)
sourceGroup  = floor(Ps(R.slot) / V)
sourceWithin = Mod(Ps(R.slot), V)
sourceLane   = Mod(R.item, waveSize)
```

Checks over bounded coordinates prove the dependency relation, exact inverses
for `Pd` and `Ps`, owner/group invariance, both quotient-remainder
reconstructions, and every range. If any proof is unknown, the target proposes
a smaller factor; `V = 1` is the singleton instance of the same algebra. Wave
emission packs source components in `Ps` order, shuffles one source group, and
places results in `Pd` order.

Workgroup movement stores and loads through one scratch expression:

```text
E(item, local, within) = V * (local * items + item) + within
F = min { f > 0 | floor(sourceGroup / f) is destination-item invariant }
L = min(F, capacityGroups)
stage = floor(sourceGroup / L)
local = Mod(sourceGroup, L)
```

`F` is the smallest algebraic source-group fiber. Capacity may split that
fiber into `L` resident groups; the exact stage predicate selects the unique
split containing each destination. The same `E` is composed with the source
and destination sides of `R`, and checks prove ownership, bounds,
`sourceGroup = L*stage + local`, and complete, disjoint stage coverage. LDS
therefore holds exactly `L*items*V` elements. There is no sampled basis,
custom matrix inverse, point table, or second layout evaluator.

## Symbolic memory

A gather or scatter is normalized to one bounded address map:

```text
A(block, item, slot) = (owner, baseSelector, bitOffset, active)
```

That map must be carried by the producer as one expression over `slot`. An
arbitrary `wave.pack` of unrelated SSA arms does not define a slot expression:
symbolic memory lowering rejects it rather than interpolating the arms with
XOR, addition, a polynomial, or a selector table.

For a proposed transaction layout `L(g,u)`, lowering pulls `A` back through
`L` and proves the full tuple for every bounded `g` and `u`. A legal width must
prove common ownership and base selection, consistent activity, exact element
divisibility, and

```text
A(g,u).bitOffset == A(g,0).bitOffset + displacement(u)
```

Width one is the same map with a singleton `u` domain. Gather, scatter, target
operand transactions, and DMA therefore differ only in their proposed
coordinate map and emitter, not in their proof model.

DMA proves its two sides separately. For each source lane and transaction
group, the ordinary transaction relation proves every `u` byte address is the
lane's source origin plus `u * elementBits`; source origins may overlap or
repeat across lanes. The destination transaction independently proves the
lane-major LDS displacement
`lane * transactionBits + u * elementBits` from the wave origin consumed by
the DMA instruction. Both sides also prove their complete emitted byte window.
If either proof is unknown, the ordinary gather/scatter lowering remains; Wave
never samples or inverts either address map. The source and destination retain
separate fact domains, so a source fact cannot authorize a destination
expression.

Symbolic facts may come only from an explicit gather/scatter operand's defining
SSA chain. A masked access may also use the condition of its direct parent
`wave.where`. Lowering never scans adjacent `wave.assume` or
`wave.index_expr` operations. Parent-region walks are used only to establish
effect-safe ownership before erasure and never contribute algebraic facts.

Before moving a transaction out of a `wave.where`, lowering also verifies that
every SSA value needed by the proved address and activity expressions
dominates the new location. Failure keeps the operation inside the ordinary
checked lowering path; it never manufactures a replacement fact.

## Ownership boundary

Wave uses ixsimpl for expression construction, substitution, simplification,
and mathematical proof. Wave owns every IR fact around that algebra:

- SSA bindings, dominance, and fact lifetime;
- fixed-width wrap, truncation, extension, and target integer legality;
- packet coordinates, workgroup shape, and execution control;
- memory effects, token edges, barriers, and allocation lifetime;
- transaction selection, target address fields, and materialization cost.

`WaveSymbols` is the raw ixsimpl boundary. Transforms use typed handles and
`sym::Analysis`; they do not walk expression trees to reimplement equality,
range, divisibility, or known-bit solvers. `IndexMap` is the closed Wave-side
domain passed to those queries. It is private compiler state, not a new public
layout attribute.

One `sym::Store` belongs to the `WaveDialect`. Its immutable, hash-consed
handles live with the MLIR context. C++ and Python import nodes structurally;
stable serialization is the cross-context form. Assembly text is only for
parsing and printing. Production paths never print and reparse an expression.

An `IndexMap` input is either material or proof-only. A material input carries
the exact SSA value that can emit it. A proof-only coordinate must disappear
through pullback or an exact definition before emission. A binding producer is
opaque once a closed `wave.index_expr` exists: consumers use its serialized
expression, assumptions, names, and operand identities without reopening its
SSA producer for extra facts.

### Frontend composition

Frontends finish layout algebra before emitting Wave operations. For source
layout `S` and destination layout `D`, redistribution imports the total gather
relation from `D.invertAndCompose(S)`. Standard distributed coordinates map as:

```text
register = slot
lane     = Mod(item, waveSize)
warp     = floor(item / waveSize)
block    = block
```

Source register, lane, warp, and block outputs become `R.slot`, `R.item`, and
`R.block`. Non-injective source layouts use the frontend algebra's deterministic
representative; Wave does not run a second layout inverse.

Named dimensions remain named through composition. A helper dimension may fold
into `slot` only when a structural adapter proves it is simultaneously resident
in the packet and the flattening is bijective. Sequential iteration, transfer
message, and physical partition dimensions need external lowering context or
reject. Multiple cluster axes flatten into `block` only through a proved
row-major bijection.

For memory, the frontend composes the register layout and exact view transform
with the physical memory layout, then imports base selection, owner block, and
bit offset. Swizzle, padding, partition, rotation, cluster ownership, and view
subslice offsets are arithmetic inside that relation. No frontend layout object,
kind switch, opaque resolver, or printed expression survives in Wave IR.

## Proof contract

Map facts are mathematical predicates whose SSA validity Wave has already
established. `check` adds canonical extent facts, proves every transported
definedness requirement, then proves the requested goals atomically. It accepts
only `True`. `False`, `Unknown`, contradictory domains, exhausted limits, and
analysis-construction failure cannot authorize a lowering.

Failure has two distinct meanings:

- A candidate proof failure rejects that candidate. A transaction provider may
  try a narrower shape; redistribution may try a smaller packet factor.
- A required final proof failure aborts the transform. No path fabricates a
  coordinate, silently drops a requirement, or installs a compatibility map.

`CheckMemo` is scoped to one planning attempt and keys the exact closed fact
domain plus predicate. It caches proof results, not layout policy. It never
turns `Unknown` into false and never outlives the map domain that produced it.

One `sym::Analysis` serves one related proof batch. It owns its fact set and
holds the store lock for its lifetime. Expression handles remain valid after
the analysis is destroyed; its facts do not. A failed fact mutator poisons
fact-backed queries, so the caller discards that analysis instead of continuing
with a silently weaker domain. Structural builders remain available for
reporting the failure.

Assumption roots are comparisons, canonical true/false, or AND trees of those
roots. Unsupported boolean shapes reject as a unit. Ordered construction may
derive later facts from earlier roots; direct construction imports one already
closed domain without that closure. The choice is part of the caller's proof
contract, not a retry that changes semantics.

Fact transfer follows expression transfer. Renaming inputs substitutes facts,
requirements, definitions, and outputs simultaneously. Replacements are not
recursively substituted through one another. A destination fact whose symbols
lack destination bindings is invalid; it is not filtered into a weaker domain.

Use the dedicated query for the required property:

- `simplify` for canonical expressions under facts;
- `check` for predicate truth;
- `tryExactDivide` for a proved quotient;
- total equivalence for equal complete expressions;
- range, congruence, known-bit, or finite-difference queries through
  `sym::Analysis` when Wave policy needs them.

Do not simplify a predicate and inspect its printed spelling. Do not prove
divisibility and then reconstruct a quotient by walking coefficients.

When two addresses or packets use different binding namespaces, pull both maps
into one exact namespace before comparison. Missing SSA-binding parity, stale
symbols, or contradictory facts keep the operations separate. Similar printed
expressions do not establish common identity.

## Fixed-width boundary

Index-map expressions are exact mathematical integers and rationals. They do
not inherit MLIR integer width or signedness. Wave must separately establish:

- no-wrap or an explicit modulo envelope for fixed-width arithmetic;
- signed versus unsigned division and remainder semantics;
- representability of every emitted literal and coefficient;
- exact bit-to-byte division for pointer offsets;
- intermediate width, not only final-result range;
- target immediate, scalar-offset, vector-offset, and address-pair limits.

A final u32 range does not prove that a rational numerator can be evaluated in
i32. Non-power-of-two remainder requires the complete dividend to survive the
chosen width. Power-of-two modulo may use low-bit masking only when the emitted
expression preserves those bits. Failure selects a wide path or rejects the
candidate; it never licenses truncation.

Proof form and material form may differ. Proof form may be expanded and
simplified aggressively. Material form is the expression emitted as
`wave.index_expr` or target arithmetic. A proof result does not silently replace
material form. Any material rewrite is compared against the original supported
form under the owning target-independent or target-specific cost policy.

## Redistribution IR contract

`wave.redistribute` applies a total gather relation to one private SIMD packet.
Source and result have equal SIMD width and element type; packet slot counts may
differ. Replication and unused source replicas are legal. The operation carries
no movement mode, scratch plan, synchronization scope, or memory token.

The op has `NoMemoryEffect`, matching its abstract private-resource semantics,
but is not unconditionally speculatable. An LDS implementation cannot order
surrounding memory. User-visible ordering remains explicit through
`!wave.mem.token` edges.

The op verifier is local. It checks packet structure, element and SIMD parity,
positive relation extents, integral coordinate expressions, and the reserved
`block`, `item`, and `slot` symbol set. It does not inspect workgroup metadata,
control, users, target features, LDS capacity, or profitability. Complete
definedness, source bounds, and movement proofs belong to
`wave-lower-redistribute`, where the full bounded `IndexMap` exists.

Lowering requires a known X-linear workgroup `[items, 1, 1]`, exact parity with
the relation item count, a workgroup size divisible by SIMD width, and execution
outside `wave.where`. Cross-block movement remains a diagnosed cluster case.
Same-block lowering also requires the material relation to eliminate an
unavailable block coordinate.

Adjacent equal-domain redistributions compose by simultaneous pullback. The
complete chain is checked before any IR mutation. Identity folds only after the
contextual domain has been validated; removing a redistribution never removes
a user memory-ordering edge.

### Local and wave movement

Same-workitem movement materializes `R.slot` and emits extracts, packet builds,
and lane selects. Same-wave movement proves the widest legal packet group,
materializes the source lane and group, shuffles reachable source groups, and
places results in destination permutation order. A failed wider group retries a
smaller factor down to the singleton form.

This lowering is target-independent. Later WaveAMD peepholes may replace a
proved generic shuffle/select graph with an architecture-specific instruction.
Target mnemonic availability never changes the redistribution relation.

### Workgroup movement and scratch

Workgroup movement emits sibling stores, one publish barrier, sibling loads,
a join of load completions, and `wave.alloc_release`. Store and load addresses
are pullbacks of the same proved scratch map. Loads depend on the publish
barrier; siblings are not serialized component by component. `wave.join`
combines token completion without adding synchronization.

Token order alone does not authorize physical LDS aliasing. Reuse requires a
path through a workgroup barrier that proves collective quiescence. A join is
only per-wave completion. `workgroup_collective` permits allocation resolution
to materialize the required barrier for a repeated lifetime.

Scratch lifetime follows source and result SSA flow plus the generated access
tokens. Region analysis follows `RegionBranchOpInterface` and
`RegionBranchTerminatorOpInterface` edges, unions mixed incoming paths, and
recomputes after IR rewrites. It never infers lifetime from block position,
nearby barriers, enclosing operations, or token ancestry.

Repetitive regions receive allocator-private token recurrences. Inactive paths
forward that private token; backedges carry generated completion only. The
allocator never selects or rewrites a user memory-token carry. Mutually
exclusive region paths may share storage only when complete allocation
lifetimes cannot coexecute.

Scratch planning uses one target-scored vector and swizzle map for stores and
loads. Capacity can split the exact source-group fiber into stages without
changing the relation. Each stage proves ownership, bounds, reconstruction,
and complete disjoint coverage. Storage codecs preserve payload bits; numeric
conversion is not a codec.

## Symbolic memory IR contract

`wave.gather` and `wave.scatter` carry physical coordinates only: base
selection, owner block, and bit offset. Packet extents, pointer facts, activity,
transaction width, and ordering stay outside the mapping. Gather and scatter
differ in dataflow direction, not address algebra.

The op verifier checks local packet, pointer, mapping, name, and binding
structure. It does not prove definedness, base range, owner reachability,
alignment, allocation bounds, scatter uniqueness, vector width, or target
support. Dead-region cleanup may erase a structurally valid access before
lowering interprets it.

Bindings are ordinary scalar or lane-SIMD SSA values. Symbolic-memory
preparation follows their defining chains and imports supported arithmetic,
`wave.index_expr`, assumptions attached to the exact result chain, and direct
`wave.where` control. It never scans adjacent assumptions, sibling operations,
or enclosing regions for algebraic facts. An arbitrary `wave.pack` of unrelated
SSA arms has no slot expression and is rejected.

Predication stays in `wave.where`; mappings have no mask field. Lowered memory
operations remain under the controlling region unless every required address
and activity value dominates a proved legal hoist point. Inactive gather values
remain unspecified unless an explicit else path supplies a fallback. Scatter
performs no inactive write.

### Transaction selection

For each proposed coordinate layout, lowering pulls the address map back to the
candidate domain and proves the complete tuple. A legal transaction proves:

- common base and owner;
- exact bit-to-element or bit-to-byte divisibility;
- candidate alignment and any known allocation bounds;
- consistent active-lane semantics;
- exact displacement for every covered element;
- target address-space and operation support.

Candidates are widest-first, but width is not trusted metadata. A failed proof
tries every smaller supported shape before the singleton candidate. Failure for
one group does not scalarize an independently provable group. Scatter never
drops colliding writes without an independent value-equality or canonical-writer
proof.

Generated transactions are siblings after the incoming dependency and return
one joined completion token. Equal maps do not infer aliasing, store-to-load
order, or a barrier. Shared-memory publication remains an explicit store,
barrier, load chain.

DMA proves source and destination independently. Source lanes may overlap or
repeat; each transaction still proves its complete byte window. Destination
proofs establish lane-major LDS displacement from the wave origin consumed by
the instruction. Source facts cannot authorize destination expressions.

Materialization is transactional. The pass prepares every selected address and
activity expression before mutating IR. If preparation or emission fails, it
rolls back the attempted rewrite; partially lowered access graphs are invalid.

## Pipeline and validation

The backend orders the current boundary as:

```text
metadata specialization and canonicalization
wave-normalize-integer-div-rem
wave-lower-redistribute
wave-lower-symbolic-memory
pointer normalization and wave.index_expr generation
memory promotion, offset combination, simplification, and coalescing
loop-stride extraction, DMA zero fill, LICM, and mask optimization
wave-expand-integer-div-rem
wave-resolve-allocs
waveamd-to-machine
```

No redistribution, symbolic gather/scatter, unresolved allocation, or
unsupported dynamic index expression may cross its required legalization
boundary. Internal producer bugs fail loudly; candidate uncertainty uses only
the explicitly proved narrower path.

Validation covers both acceptance and conservative rejection:

- direct `IndexMap` pullback, requirement, definition, range, and memo tests;
- local verifier tests that keep contextual checks out of `verify()`;
- movement classification, permutation, capacity, control, and cluster cases;
- symbolic-memory activity, base, owner, adjacency, DMA, and rollback cases;
- allocator-private recurrence and mutually exclusive lifetime cases;
- Integration tests through final WaveAMD instructions;
- PerfGolden review whenever emitted assembly changes.

Proof optimizations must measure the exact production pass and kernel. Build one
analysis per related fact domain, batch roots with shared DAGs, keep caches
fact-scoped, and bound recursive or enumerative work. Assembly drift requires
same-hardware performance evidence before a golden is replaced.
