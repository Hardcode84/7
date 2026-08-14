# Cost-based Wave index-expression materialization

Status: proposed design. This document does not authorize implementation beyond
the bounded vertical slice and gates described below.

## Summary

Wave should keep redistribution and symbolic-memory addresses in one canonical
symbolic form through layout composition, adjacency proof, transaction
selection, memory coalescing, and pointer normalization. The canonical form is
the semantic contract; it is not required to be the cheapest order in which to
evaluate the address.

Immediately before integer div/rem expansion, Wave should collect the surviving
`wave.index_expr` roots and build a bounded, typed materialization choice DAG.
The DAG contains exact alternatives and directed poison-refining alternatives.
A multi-root extractor jointly chooses representations, sharing, and abstract
placement domains while charging shared nodes once. A separate dominance-aware
elaborator emits the planned sharing or rematerialization of pure computations.
This deliberately separates:

1. canonical relation construction and proof;
2. representation extraction; and
3. code placement.

The proposed architecture is not an unrestricted e-graph or a general
superoptimizer. Its candidate set, cost model, and compile-time budget are
explicit and deterministic.

## Problem

The same canonical address can have materially different evaluation costs
depending on target instructions, arithmetic width, loop placement, uniformity,
other roots available for sharing, and register lifetime. Choosing a single
spelling while lowering one gather, scatter, DMA, or redistribution operation
cannot account for all of those factors. Repeatedly changing the canonical
relation to improve one kernel also makes layout and adjacency proofs harder to
reason about and merely moves the phase-ordering problem earlier.

The current pipeline already has the correct common semantic hand-off:

- `wave-lower-redistribute` emits ordinary `wave.index_expr` values for physical
  packet movement;
- `wave-lower-symbolic-memory` proves the canonical address relation, selects
  legal transactions, and emits ordinary `wave.index_expr` values for their
  addresses; and
- subsequent normalization, coalescing, and loop-stride passes preserve or
  combine those packets before integer div/rem expansion and destructive
  selection by `waveamd-to-machine`.

Today, materialization decisions are made recursively and per root in multiple
places. Caches are local to one memory access or selector invocation, and fixed
add/multiply orderings cannot value common subexpressions across roots. The GLU
address regression is the first production hypothesis for this design: the
current investigation indicates that structural memory operations match exact
known-good top-level commit `dca94eef23d1` and Wave commit `4f9cf46c8505`, while
an equivalent address relation expands to more integer address instructions.
Stage 0 must re-establish and record that evidence from controlled artifacts
before implementation. The falsifiable success metric is to recover the
known-good address instruction and resource shape without changing the
canonical relation or the selected memory transactions.

## Goals

- Keep one canonical relation for gather, scatter, DMA, and redistribution
  legality and adjacency reasoning.
- Make materialization a late, target-aware decision over all compatible roots
  in a legal scope.
- Account for CSE, arithmetic width, uniform versus divergent execution, loop
  frequency, dominance, and live-range cost.
- Lower an `index_expr` through i32 arithmetic when the existing final-result
  IntegerRangeAnalysis, symbolic u32 proof, and rational-intermediate checks
  together prove that the selected expression can be evaluated at that width.
- Preserve Wave's symbolic poison contract: division or remainder by zero is
  poison and may be refined to any result. Materialization must not add
  definedness guards merely to make an alternative total.
- Keep compile time bounded, deterministic, and observable.

## Non-goals

- Changing frontend layout composition, transaction legality, memory
  coalescing, or redistribution selection to obtain a preferred machine
  spelling.
- Reconstructing source SSA ancestry in the frontend bridge or carrying a second
  materialization/provenance packet beside the canonical relation.
- Adding proof-shape queries to ixsimpl. ixsimpl remains the canonical relation
  and legality engine, not the target cost engine.
- Moving target policy into the scheduler or repairing address expansion in
  register allocation.
- Enumerating all mathematically equivalent expressions, running unrestricted
  equality saturation, or claiming globally optimal machine code.
- Predicting exact final VGPR allocation in the extractor.

## Existing ownership boundary

### Frontend bridge

The frontend owns mechanical composition of source integer expressions with
final LinearLayouts. It serializes the resulting physical-to-logical relation
and its ordinary scalar bindings. It does not choose an arithmetic evaluation
order, recover target SSA ancestry, or provide a materialization carrier.

Global memory composes a small forward integer expression with the final
distributed layout. Local memory rebases physical inputs and composes
distributed and shared LinearLayouts. Redistribution emits one total physical
gather relation.

### Wave relation and transaction lowering

`WaveLowerRedistribute` and `WaveLowerSymbolicMemory` own interpretation and
proof of those relations. Memory lowering specializes packet coordinates,
proves transaction adjacency and ownership, and selects a legal transaction
cover. Those decisions operate on one canonical expression. They must not
generate a family of target-dependent materializations.

Both lowerings already converge on `wave.index_expr`, whose bindings are opaque
SSA identities and whose expression and assumptions are a closed symbolic
packet. `WaveGenerateIndexExprs` remains a mechanical serializer of supported
SSA trees; it does not own cross-root selection or placement.

### Late Wave boundary

The materialization planner is a dedicated Wave pass immediately before
`wave-expand-integer-div-rem`, after:

- redistribution and symbolic-memory lowering;
- pointer normalization and combination;
- memory coalescing;
- the second index-expression serialization and simplification;
- loop-stride extraction, DMA zero-fill formation, LICM, and mask optimization.

At this point all shipping consumers are known, target information is available,
IntegerRangeAnalysis is available, and no machine arithmetic has yet been
destructively emitted. Planning here also lets memory and redistribution roots
share the same mechanism without coupling their proof passes.

Planning has two ordered parts. First, the target address interface projects
each canonical pointer root into its fixed `(inst_offset, soffset, voffset)`
field roots. This projection uses only the canonical expression, binding kinds,
facts, and hardware field constraints. Second, the materialization choice graph
is built independently inside those field roots. Numeric reassociation,
quotient/remainder selection, width choice, sharing, and placement may not
flatten or move terms across the chosen field boundary. The selected pure
sub-DAGs are emitted as ordinary Wave SSA and rebound into residual canonical
field `wave.index_expr` roots. The existing div/rem pass then expands dynamic
integer division and remainder, and `waveamd-to-machine` consumes the already
planned fields.

Address-field projection must therefore be shared with the existing machine
address planner rather than estimated from pointer users and rediscovered after
numeric rewriting. Placing all choice construction inside machine selection is
still rejected because it would move or duplicate the Wave div/rem lowering;
only the target field projection is reused at the late Wave boundary.

The current symbolic-memory materializer eagerly emits some dynamic division
and remainder leaves before this boundary. The GLU corpus therefore contains
the canonical relation but not those leaves in the final `wave.index_expr`
roots. Deferring them is part of the vertical slice, not an independent
optimization: the deferral and planner must land together, and the planner must
elaborate every deferred dynamic quotient or remainder before
`wave-expand-integer-div-rem`. A valid deferred node reaching machine selection
is an internal compiler error, not an unsupported-case fallback.

## Semantic model

### Canonical root

Each surviving `wave.index_expr` is the canonical semantic root. Its expression,
fixed-width interpretation, assumptions, ordered SSA bindings, binding kinds,
and result use are immutable inputs to planning. The original materialization is
always one valid choice.

For a pointer consumer, the canonical root also has one target field projection.
That projection is not an alternative spelling and is not selected by the
numeric cost model. It is a structural input to candidate construction. A
candidate is comparable with the canonical plan only when it preserves each
term's `inst_offset`, `soffset`, or `voffset` ownership.

Canonical relation simplification may happen before this boundary, but the
planner never writes a chosen spelling back into the relation or asks proof
passes to accept a code-generation-oriented form.

### Exact alternatives and refinements

A conventional e-class represents symmetric equality. That is insufficient for
poison: replacing a poison result with a concrete result is a valid refinement,
but the reverse is not. The planner therefore uses a materialization choice DAG:

- exact, same-definedness alternatives may share an equivalence class; and
- alternatives that are only valid refinements are directed edges away from
  the canonical root.

For Wave symbolic integer division and remainder, a zero divisor produces
poison. A candidate need only agree with the canonical expression whenever the
canonical expression is defined; it may choose a concrete result or remain
poison in a poison case. It may not introduce immediate target undefined
behavior: source poison can remain unconsumed and therefore does not authorize
an immediately undefined target operation. The selected Wave/AMDGPU operation
sequence must implement a valid refinement. No rewrite may turn a defined input
into poison, and no guard may be introduced solely to assign semantics to a
poison input.

Signed `INT_MIN / -1` and `INT_MIN % -1` require the same explicit treatment.
Until the Wave symbolic contract for that overflow is recorded in the operation
semantics, a quotient/remainder alternative is available only when existing
facts exclude it or when its selected implementation is total and refines the
canonical result. Candidate construction may not inherit immediate UB from an
MLIR or LLVM operation accidentally.

This is a local Wave symbolic contract. LLVM and MLIR arithmetic operations have
their own undefined-behavior contracts, so lowering must establish that the
selected target sequence is a valid refinement rather than assuming that a
standard e-graph equality is sufficient.

### Arithmetic width

Width is part of node identity and legality. Existing machine selection combines
IntegerRangeAnalysis of the final SSA result, symbolic proof that an address slot
fits u32, and structural checks for wide rational intermediates. A new i32
alternative must provide the corresponding structural intermediate-width check;
IntegerRangeAnalysis of the final result alone is insufficient. Integer add and
multiply inside an explicit modulo-2^32 envelope may use their fixed-width ring
semantics, but a rational or rounding subtree may not be narrowed merely because
its final result fits in 32 bits.

The bridge does not decide width from operand types. The late planner reuses the
machine selector's range information, and an unproved narrowing candidate is
simply absent.

## Materialization choice DAG

### Roots and scopes

The planner collects `wave.index_expr` roots and their consuming pointer or
memory contexts, then partitions them by legal control and placement scope. An
`AddressPlan` is selector-internal and is not an IR root available here. The
planner must not form one unsafe function-global DAG. Two roots can share a node
only if:

- the node has identical typed semantics and assumptions for both roots;
- its ordered SSA bindings are identical;
- all operands dominate a legal common insertion point;
- speculation across the relevant control boundary is valid; and
- placing it there preserves the poison-refinement contract.

A synthetic tuple root represents all roots in one compatible partition. This
makes common subexpressions visible to extraction without changing program
semantics.

The bounded slice uses deliberately conservative partitions. Stage 1 shares
only within one block and region. Stage 2 additionally permits one structurally
proved loop-invariant value to be placed in the immediate loop preheader.
`wave.where`, divergent control, sibling regions, and arbitrary cross-block
placement are hard boundaries. General control-dependence placement requires a
separate production witness and is not part of the first implementation.

### Node identity

A semantic node is keyed by at least:

```
(operation,
 result width and signed/rational semantics,
 operand semantic classes,
 applicable assumptions,
 referenced SSA bindings and binding kinds in canonical symbol order)
```

Only the bindings referenced by that node participate in its identity; irrelevant
root bindings do not block sharing. Stage 1 conservatively requires identical
complete fact packets and does not attempt fact-dependency minimization.

Placement is not encoded as a different mathematical expression. Each selected
node instead has a set of legal placement domains derived from the bounded scope
rules above. Keeping these concepts separate permits the same representation to
be shared, hoisted, or rematerialized according to cost.

### Initial candidate families

The first implementation may construct alternatives only from audited rewrite
families already required by the production witness:

- associative grouping of integer add and multiply;
- factoring and the existing shallow multiply-over-add distribution;
- quotient/remainder versus `x - (x / y) * y`, with exact signed and fixed-width
  semantics;
- existing power-of-two mask, shift, and modulo forms;
- proved i32 versus wide materialization; and
- exact splitting of loop-invariant and loop-varying additive terms.

Every family has an explicit matcher, constructor, semantic precondition, and
unit test. Candidate construction does not use `Analysis::check(E == E)` or a
new equivalence query. Exact algebraic identities are structural; narrowing uses
the existing range analysis; refinement rules encode their direction directly.

### Bounded construction

Candidate construction uses a deterministic worklist with explicit limits on
rewrite rounds, alternatives per semantic class, and total nodes per scope.
Stable ordering and structural interning make the result reproducible. The
initial registry orients rewrites with a well-founded rank, and an occurs check
rejects any alternative whose class dependencies would create a cycle. A finite
node budget alone is not an acyclicity proof.

Reaching a limit stops candidate growth, records a diagnostic statistic, and
extracts from the acyclic graph already constructed; the canonical seed remains
available. This is a bounded optimizer decision, not a semantic fallback or a
silently accepted producer error.

The limits are part of the implementation contract and are exercised by tests.
They may only be raised with compile-time and production evidence.

## Extraction

Ordinary cheapest-tree extraction charges a shared subtree once for every root
and therefore chooses poorly in the presence of CSE. Exact globally optimal DAG
covering and combined placement are intractable in general. The Wave planner
must state and test its bounded objective rather than claim global optimality.

The initial extractor should be deterministic and profit-driven. Extraction is
run over the fixed field roots, never over a flattened full address. Because
sharing profit depends on placement, extraction jointly chooses an abstract
legal placement domain for each selected node; scoped elaboration realizes that
plan but does not make a second profitability decision:

1. Compute per-node local costs and per-root cheapest-tree lower bounds.
2. Identify shared candidates within each legal placement scope.
3. Select a closed multi-root DAG and legal placement domains jointly, charging
   each shared computation once at its selected placement.
4. Recompute root choices after accepting or rejecting sharing opportunities.
5. Break equal-cost choices by stable structural order.

Small connected components may use bounded branch-and-bound as a test oracle,
but an ILP solver is not a production dependency. The selected result is the
best plan found under the registered candidates and cost model, not necessarily
the global optimum.

### Cost model

The first decision is lexicographic and structural: preserve the canonical
`(inst_offset, soffset, voffset)` projection. Only candidates with that same
field tuple reach the numeric cost model. This is not a target-weight guess: a
single flattened `voffset` extends per-lane arithmetic and VGPR lifetime even
when it has fewer syntax nodes than the split hardware encoding.

Within each field, the numeric cost is the reachable typed primitive Wave-op DAG
that the existing `wave-expand-integer-div-rem`, canonicalization, and CSE
pipeline would emit. Symbolic syntax count is only a deterministic tie-break:
experiments below show that it can rank the same two candidates in the opposite
order from their actual expansion. Candidate primitive DAGs are hash-consed
across compatible roots of the same field class, unreachable nodes are
discarded, and each selected node is charged once per placement domain.

The Wave scheduler model operates on already-emitted machine instructions and
is not reused here. Primitive identity and cost include:

- target instruction weight;
- scalar versus vector execution;
- i32 versus register-pair arithmetic;
- dynamic loop-depth weighting;
- materialization cost charged once per selected placement;
- cost of casts, packing, and extracting a low dword; and
- a bounded lifetime penalty for the immediate-preheader case.

The first extractor does not commit to one fragile scalar weighting. It rejects
any candidate that increases wide or register-pair arithmetic, divergent live
words, or the reachable primitive DAG under any point in a small fixed
sensitivity grid over scalar/vector weight, loop execution weight, and
one-/two-dword cost. Among candidates that are non-worse at every point and
strictly better at one, a central target weight and then stable structural order
choose the result. Address fields are not credits in this scalar cost: they were
fixed before numeric comparison. Sharing never crosses field classes merely
because two numeric subexpressions are equal.

The model must permit recomputation of cheap nodes. CSE is not unconditionally
profitable: hoisting a shared expression can increase lifetime and register
pressure enough that two local computations are cheaper. Stage 2 models only
the immediate-preheader lifetime case. General pressure estimation requires a
production witness before it is added. Final scheduling and register allocation
remain the owners of scheduling and physical register decisions.

## Dominance-aware scoped elaboration

Representation extraction chooses operators, dependencies, sharing, and abstract
placement domains. A separate elaborator turns that checked plan into Wave SSA:

- place an in-block shared node before its first use;
- place a selected immediate-loop invariant at the loop preheader;
- emit planned duplicate nodes when sharing was rejected by the cost model;
- memoize values for dominated uses at the chosen scope; and
- never move effectful operations or control-dependent memory activity.

If a planned placement is not legal, elaboration reports an internal compiler
error; it does not silently choose another plan. This stage uses MLIR dominance
and loop nesting. It does not inspect source-dialect operations, rebuild layout
provenance, or ask ixsimpl for a preferred insertion point.

## Pipeline and implementation shape

The implementation is a private Wave transform immediately before
`wave-expand-integer-div-rem`. Its target weights may be shared with WaveAMD
lowering, but the pass emits ordinary Wave SSA while its binding values still
exist. A tentative division of responsibility is:

```
SymbolicAddressFieldProjector
  collectPointerConsumers()
  projectCanonicalFields()
  emitFieldIndexExprRoots()

IndexExprMaterializationPlanner
  collectFieldRoots()
  buildChoices()
  extractRepresentationsAndPlacementDomains()

IndexExprScopedElaborator
  validatePlacements()
  emitSelectedWaveDAG()
  rebindResidualIndexExprs()
```

The pass uses the same target field projector as machine lowering to obtain the
canonical field roots before building choices. Machine lowering consumes that
projection; it does not make a second field-selection decision after numeric
rewriting. Existing canonicalization and CSE after machine lowering remain
cleanup; they are not responsible for discovering alternative representations.

Projection is represented with existing `wave.index_expr` operations, not a new
memory carrier or frontend schema. A scalar `soffset` field and a SIMD
`voffset` field become child roots; the residual full root binds those children
and any literal instruction offset. Numeric elaboration rewrites only the
children. If one
canonical root has consumers with incompatible target field specifications, the
projector clones the root per specification before planning rather than merging
their constraints or flattening either address.

`WaveGenerateIndexExprs`, `WaveLowerSymbolicMemory`, and
`WaveLowerRedistribute` require no new analysis. Their tests should assert the
canonical packet and legal transaction, not one early machine evaluation order.

## Corpus experiments

The permanent gfx950 sweep corpus was used to compare bounded algebra sets
without changing the shipping bridge or proof forms.  The measurements below
are wall-clock Python experiments over the complete corpus on 2026-08-13; they
are design evidence, not compiler benchmarks:

| Candidate set | Aggregate expression cost | Experiment time |
|---|---:|---:|
| Canonical roots | 275,986 | 3.3 s |
| Balanced add/multiply grouping | 208,680 | 3.1 s |
| Compact five-family registry | 206,704 | 11.5 s |
| Bounded eight-family registry | 207,264 | 18.3 s |

The broader registry costs more compile time and selects a slightly worse
result than the compact registry.  Unrestricted RePair-style factoring and
broad rewrite search grew beyond these bounds without a compensating corpus
gain.  They are rejected.

Two production transplants establish the limits of a syntax-only cost model:

- Splitting uniform and lane-varying additive address terms reduced the FA
  witness HSACO to 10.5 KiB, but measured only 481--483 TFLOP/s.  Smaller code
  was not faster.
- Replacing a compact three-bit lane field with its exact per-bit sum changed an
  intermediate machine snapshot from 48 packed/35 scalar multiplies to 65
  packed/1 scalar multiply.  Running the same alternative through the complete
  shipping pipeline still produced 48 packed/35 scalar multiplies and about
  480 TFLOP/s.  The intermediate count was a phase-boundary artifact, not a
  valid profitability signal.

The optimized asynchronous GLU witness provides a stronger typed-DAG control.
The counts below are after `wave-expand-integer-div-rem`, canonicalization, and
CSE over the same canonical roots:

| Materialization | `wave.binary` | `wave.cast` | `wave.urecip` | `wave.select` |
|---|---:|---:|---:|---:|
| Current quotient-expanded roots | 601 | 152 | 4 | 144 |
| Direct remainder without proved i32 width | 6,742 | 130 | 4 | 2,187 |
| Direct remainder with proved signed-i32 quotient/remainder | 470 | 166 | 6 | 141 |

The first direct-remainder transplant looked cheaper in symbolic syntax but
expanded catastrophically at index width. It is a permanent negative control.
Proving the quotient and remainder operands are signed i32 makes the same
semantic choice smaller at the Wave-op boundary, but that is still not enough.
In a machine dry run, the partially narrowed candidate changed
`v_mul_u64` from 26 to 107 even while reducing `wave.binary`, because the
surrounding additive/multiplicative ring remained index-width. It is rejected.
The lawful candidate must keep integer Add/Mul ancestors inside the explicit
modulo-2^32 envelope at i32 while independently proving every rational or
rounding subtree.

The multi-root requirement is also measured rather than hypothetical. In the
optimized GLU corpus, 98 weighted references to `Trunc` collapse to 14 exact
typed quotient semantic nodes after binding identity is applied. One quotient
node is referenced 46 times by 13 roots in one block. A per-root choice followed
by ordinary CSE cannot price that choice correctly because it decides whether
to construct the shared node before the sharing exists.

A correctly typed older transplant reached the following machine shape:

| Materialization | `v_add3` | `v_add_u32` | `v_add_lshl` | `v_lshl_add` | `v_mul_lo` | `v_mul_u64` |
|---|---:|---:|---:|---:|---:|---:|
| Canonical structural checkpoint | 124 | 49 | 0 | 7 | 129 | 26 |
| Typed direct-remainder transplant | 42 | 75 | 28 | 7 | 39 | 8 |

That proves the representation can recover most of the known-good address
shape, but controlled K=512 measurements were still about 1.3% below the exact
known-good baseline in all seven pairs. It therefore remains experiment
evidence, not an implementation to land or a cost model to tune around.

Consequently, aggregate expression nodes, serialized bytes, and pre-selection
packed-op counts are insufficient costs.  A production extractor must score a
candidate from its typed post-expansion primitive DAG and then validate the
selected vertical slice through actual machine lowering. The smallest cost
vector justified by these experiments is:

1. selected target operation cost, including scalar/vector and one-/two-dword
   width;
2. loop execution weight;
3. a placement-domain lifetime cost;
4. shared nodes charged once only when they actually share a legal placement;
5. a packet-pair fragmentation penalty for choices that extend divergent
   integer values across packed math.

The last item is intentionally a bounded structural proxy, not a prediction of
the final physical register assignment.  No candidate family should land until
the complete production pipeline improves its witness.  Candidate generation
must remain linear in corpus nodes, with no more than one registered alternative
per matched family and a compile-time gate of at most 5% on the protected sweep.
The current canonical checkpoint adds no search to compilation; its measured
compile times are within noise of the immediately preceding structural
checkpoint.  The branch still carries older refactor compile-time debt versus
the last-known-good revision, so that debt is a separate required gate for any
future planner.

## Bounded vertical slice

Implementation proceeds only through the following evidence-backed stages.

### Stage 0: restore and freeze the boundary

- Exclude manual `__wave_address_invariant_` bindings, early loop-invariant
  modulo splitting, broad rational rewrites, and tests prescribing one early
  `divsi`/`remsi` order from the proposed architecture.
- Treat the fixed-width signed source relation and its exact i32
  quotient/remainder materialization as a separate semantic correction. It is
  independently tested and is not candidate-generation or placement machinery.
- Keep any transpose/frame changes in
  `WaveAMDMemoryTransactionProvider.cpp` separate. None of these changes is a
  foundation for the planner.
- Preserve the canonical relation and the already-correct structural memory and
  redistribution lowering.
- Record the exact GLU known-good and current address instruction, resource, and
  performance measurements used by the gate.
- Defer only the audited dynamic quotient/remainder leaves that the planner can
  represent and elaborate. This deferral and the planner are one atomic change;
  deferral alone is invalid because current machine `index_expr` lowering does
  not support every dynamic divisor or dynamic `Trunc` denominator.

### Stage 1: identity graph and shared CSE

- Project each pointer root into its canonical target address fields before
  constructing numeric nodes. Assert that elaboration preserves that field
  tuple through machine selection.
- Collect two or more roots in one legal scope.
- Build only their canonical nodes.
- Extract and elaborate exact common subexpressions once within one block and
  region.
- Prove that roots with different facts, bindings, widths, or control scopes do
  not share.

This stage validates ownership, multi-root accounting, and placement without
algebraic search.

### Stage 2: GLU address family

- Add only the signed i32 quotient/remainder, modulo-2^32, additive factoring,
  and one immediate-preheader loop-invariant alternative needed by the
  checked-in GLU witness.
- Construct and compare those alternatives independently inside the projected
  `soffset` and `voffset` roots; a flattened full-address candidate is invalid,
  regardless of its arithmetic cost.
- Build and cost the actual typed div/rem primitive DAG, with quotient and
  remainder as shared outputs of one semantic node. Do not estimate it from
  symbolic operator count.
- Preserve the exact selected loads, stores, DMA transactions, masks, and
  redistribution operations.
- Reject any candidate that increases wide/pair operations or divergent live
  words at the dry machine boundary. Require a material reduction toward the
  known-good address instruction and resource floor and no statistically
  credible performance regression.

If Stage 2 does not improve the exact production witness, stop and remove the
new planner rather than adding candidate families or cost knobs.

### Stage 3: evidence-gated expansion

Only after Stage 2 passes may another candidate family be added. Each addition
requires a production witness, an independent semantic test, a cost-model test,
and full protected-sweep validation. Expansion is not authorized merely because
a synthetic expression becomes cheaper.

## Validation

### Direct semantic tests

Permanent direct layout tests continue to cover:

```
LinearLayout -> canonical symbolic expression -> adjacency/contiguity
```

They do not invoke the full frontend pipeline and do not prescribe a materialization
order. They prove the relation handed to Wave is correct.

Materialization rule tests independently cover exactness or directed refinement
at each supported bit width. Small bit widths may be exhaustively enumerated.
Tests include zero divisors and verify that no definedness guard is introduced.

### Wave integration tests

Integration tests must cover:

- two roots with a profitable shared subexpression;
- sharing rejected for different bindings, facts, widths, or control scopes;
- one structurally loop-invariant term shared in its immediate preheader;
- a cheap term deliberately duplicated instead of hoisted to that preheader;
- an `index_expr` lowered with i32 operations when final-result range, symbolic
  u32, and structural intermediate checks prove it safe;
- a rational intermediate that remains wide even though the final result is
  bounded to u32;
- bounded candidate growth and deterministic extraction; and
- unchanged canonical symbolic-memory and redistribution transactions.

The existing machine index-expression and loop-strided-pointer tests are the
natural homes for these cases. The checked-in optimized asynchronous GLU fixture
is the first end-to-end production witness.

### Completion gates

Before landing implementation:

1. rebuild Wave and the frontend integration explicitly;
2. pass direct layout math, Wave symbolic-memory, redistribution, and WaveAMD
   machine tests;
3. pass the frontend Wave integration suite with parallel execution;
4. compare the checked-in GLU witness against the exact known-good structural,
   ISA, resource, correctness, and repeated performance measurements; and
5. pass every configuration in the protected performance sweep against both
   LLVM and the exact known-good Wave baseline.

No performance golden is rebaselined to accept a regression.

## Rejected designs

- **Optimize the canonical relation for each kernel.** This couples proof shape
  to target cost and recreates phase ordering before all consumers are visible.
- **Recover source values or carry materialization packets through the frontend
  bridge.** This violates the mechanical bridge boundary and duplicates
  information already represented by the canonical relation and ordinary
  bindings.
- **Teach ixsimpl target profitability.** Proof canonicalization and target code
  selection have different objectives and lifetimes.
- **Choose independently per root and run CSE afterward.** Per-root extraction
  cannot value a shared alternative that is not individually cheapest.
- **Always share common expressions.** This ignores placement, live ranges, and
  profitable rematerialization.
- **Use unrestricted equality saturation plus exact ILP extraction.** Published
  systems show both candidate growth and joint extraction can dominate compile
  time. It is unnecessary for the first production witness.
- **Union refinement-only alternatives into e-classes.** This makes an unsound
  reverse rewrite available when poison is refined to a concrete value.
- **Repair the result in scheduling or register allocation.** Those stages see
  an already selected arithmetic graph and do not own semantic alternatives.

## Prior art

This design combines established ideas rather than introducing a new general
optimization model:

- Tate et al., [Equality Saturation: A New Approach to
  Optimization](https://www.cs.cornell.edu/~lerner/papers/popl09.pdf), POPL
  2009: compact equality representation followed by global profitability-based
  extraction, with explicit evidence that saturation and extraction need
  compile-time bounds.
- Willsey et al., [egg: Fast and Extensible Equality
  Saturation](https://arxiv.org/abs/2004.03082), POPL 2021: e-classes and
  analysis-conditional rewrites; egg's standard recursive extractor does not by
  itself value shared nodes across multiple roots.
- Yang et al., [Equality Saturation for Tensor Graph
  Superoptimization](https://proceedings.mlsys.org/paper_files/paper/2021/file/cc427d934a7f6c0663e5923f49eba531-Paper.pdf),
  MLSys 2021: synthetic multi-output roots and extraction that charges shared
  nodes once, together with practical warnings about graph growth and ILP cost.
- Cranelift, [E-graph optimization and scoped
  elaboration](https://bytecodealliance.org/articles/cranelift-progress-2022)
  and its current [e-graph source
  documentation](https://docs.rs/cranelift-codegen/latest/src/cranelift_codegen/egraph/mod.rs.html):
  a fixed effect/control skeleton, bounded pure-expression alternatives, then
  separate dominance-aware placement, GVN, LICM, and rematerialization.
- Click, [Global Code Motion / Global Value
  Numbering](https://courses.cs.washington.edu/courses/cse501/04wi/papers/click-pldi95.pdf),
  PLDI 1995: separation of value equivalence from dependency- and
  dominance-constrained placement.
- Knoop, Rüthing, and Steffen, [Lazy Code
  Motion](https://rsim.cs.uiuc.edu/arch/qual_papers/compilers/knoop92.pdf), PLDI
  1992: avoiding unnecessary early placement and its live-range cost.
- Koes and Goldstein, [Near-Optimal Instruction Selection on
  DAGs](https://llvm.org/pubs/2008-CGO-DagISel.pdf), CGO 2008: DAG covering with
  shared subexpressions is NP-complete, motivating bounded heuristics.
- Sasnauskas et al., [Souper: A Synthesizing
  Superoptimizer](https://arxiv.org/abs/1711.04422), arXiv 2017, and Lopes et
  al., [Alive2](https://users.cs.utah.edu/~regehr/alive2-pldi21.pdf), PLDI
  2021: fixed-width integer optimization and refinement-aware validation. Their
  solver-heavy approach is prior art for semantic validation, not the proposed
  production architecture.

The closest description of the proposed Wave mechanism is therefore:

> bounded, multi-root, CSE-aware cost-based extraction over a typed
> materialization choice DAG, followed by dominance-aware scoped elaboration.
