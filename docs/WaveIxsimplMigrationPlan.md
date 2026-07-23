# Wave Symbolic Reasoning and ixsimpl Migration

## Status

This document audits symbolic reasoning in Wave lowering and defines which
parts belong in ixsimpl.

Original audit baseline:

- Wave: `01f668ad2bca39a657ac907dc513992f2a89fc7c`
- vendored ixsimpl: `d7e536dd2fbe61dcea5ea727ebcfa45142f38791`
- audit date: 2026-07-22

Imported implementation baseline:

- Wave integration base: `1c238072`
- Wave symbolic migration: `369437af70b8a0f21a92800cbae7ddf962c5b7e6`
- upstream ixsimpl: `56a3f9deb40e292567fd7c2fff1f1eed56bc83ca`
- profiled ixsimpl fixes: `59371133aee997f9983fc882162587a181589567`

At `56a3f9d`, all general P0/P1 APIs identified below are public: reusable
facts, fact-backed simplification, definedness, integrality, divisibility,
exact division, total equivalence, known bits, congruence, expanded ranges,
constant difference, affine decomposition, finite difference, additive split,
and simultaneous fact substitution. This revision also canonicalizes nested
XOR cancellation, lets atomic check APIs consume canonical true/false, and
makes node ownership validation expected constant time.
Wave now has a scoped `sym::Analysis` boundary and uses core check,
definedness, and finite-difference queries. Remaining work is Wave call-site
migration plus the narrower gaps listed below.

### Import validation status

The Wave integration is implemented. gfx950 runtime and performance validation
remains open. Current validation at Wave `369437af` and ixsimpl `5937113`:

- all 416 supported Wave tests pass, including 16 PerfGoldens; 24
  target-dependent tests are unsupported;
- wavec passes 6 of 6 tests;
- Integration passes 102 tests; 24 target-dependent tests are unsupported;
- standalone ixsimpl passes 13 of 13 strict source/ASAN C tests, 10 of 10
  amalgamated C tests, and 178 of 178 fresh-wheel Python quick tests;
- all 16 PerfGoldens pass after regenerating 6 reviewed ASM drifts; those 6
  still require gfx950 A/B.

The `my/goldens` branch update is already present as Wave commit `1c238072`.
The six regenerated files below are subsequent effects of the ixsimpl import.

Four non-Perf expectations changed under stronger or corrected core proofs:

| Test | Imported behavior | Review action |
|---|---|---|
| `lower-redistribute-invalid.mlir` | Range propagation from `3bded15` proves `Mod(floor(1/-1), 2) == 1`, so the first real division failure moves from item 0 to item 1; Piecewise ranges reach the later movement-classification limit | Assert item 1 and the deterministic classification-limit diagnostic |
| `wave_symbolic_memory_component_cover_codegen.mlir` | Expanded ranges from `3bded15` prove the exact-packet offset fits the buffer form | Require `buffer_store_dword` and reject the short global form |
| `waveamdmachine-full-address.mlir` | `3bded15` bounds the XOR/floor offset for a 32-bit global-store offset; known-bit fixes in `a9fb4ee` turn disjoint-bit XOR into addition while retaining addr64 for the overflowing byte offset | Assert both the narrow safe case and the high constant plus addr64 addition |
| `waveamdmachine-gfx950-dma-matmul.mlir` | Expanded ranges prove the descriptor-relative address and select `buffer_load_dwordx4 ... lds` | Require both the buffer opcode and the LDS modifier |

Six gfx950 PerfGoldens drifted:

- `a4w4_mxfp_k16k`;
- `tlx_fa_8k_async_prefetch`;
- `tlx_fa_8k_persistent_causal`;
- `tlx_glu_optimized`;
- `tlx_glu_optimized_async`;
- `tlx_glu_persistent`.

All six generated files assemble for gfx950 with `llvm-mc`; this proves
encoding validity, not runtime performance.

Static old/new ASM review found identical ordered wait/barrier streams,
unchanged MFMA/DS/VMEM/wait/barrier counts, unchanged LDS/private sizes, and no
spills. This is triage, not performance proof:

| Golden | Instruction delta | Register delta | Review focus |
|---|---:|---|---|
| `a4w4_mxfp_k16k` | -26 | 436 VGPR / 46 SGPR / 180 AGPR unchanged | Hot-loop address/swizzle allocation |
| `tlx_fa_8k_async_prefetch` | -81 | 440 / 84 / 184 unchanged | Shared prologue swizzles |
| `tlx_fa_8k_persistent_causal` | -49 | 512 VGPR / 100 SGPR unchanged | Outer-loop LDS addresses; barrier-neighbor scheduling changed |
| `tlx_glu_optimized_async` | -93 | 136 VGPR / 44 SGPR unchanged | Post-loop LDS addressing |
| `tlx_glu_persistent` | -38 | 218 / 90 unchanged | New `v_bitop3` folds |
| `tlx_glu_optimized` | -37 | VGPR 196 unchanged; SGPR 44 -> 46 | Highest risk: three extra scalar multiplies |

Temporarily restoring Wave's assumption-array simplify, range, power-of-two,
and predicate wrappers does not remove these drifts. Restoring the old
loop-stride substitute/subtract ladder also produces byte-identical generated
ASM to the new finite-difference query. The drift therefore comes from the
imported core, not facade scope or the finite-difference migration.

Commit-by-commit tracing places representative golden drift at `3bded15`:
finite ranges for nested layout XORs unlock an older disjoint-XOR-to-add rule.
This matches the reduced XOR/AND/shift/multiply counts while memory-operation
counts stay fixed. Correctness is expected; gfx950 performance remains
unproven.

The local GPU is gfx1100; all six regenerated goldens target gfx950. Static
review accepted the sound codegen canonicalization, but cannot close the
same-hardware performance gate. On a gfx950 host:

1. Materialize pre-import ASM from commit `1c238072` and current ASM from the
   worktree. Assemble and link both into separate HSACOs with the same
   `llvm-mc` and `ld.lld`.
2. Run identical inputs, warmups, and repeat counts. Record medians and output
   checks, not only instruction counts.
3. For `a4w4_mxfp_k16k`, use the `a4w4-mxfp-k16k` calibration profile and
   `--run-hsaco` for each artifact.
4. Supply equivalent FA and GLU harness runs for the five TLX kernels.
5. Record the accepted A/B evidence. If performance regresses, repair the
   lowering or restore the affected golden before merge.

Scope covers production code under `lib/Dialect/Wave`, Wave conversions,
Python kernel builders, and wavec. Tests and tracker entries provide examples;
they do not define the ownership boundary.

## Executive Summary

Wave should not move symbolic lowering wholesale into ixsimpl. Wave owns IR,
SSA, target, and memory policy. ixsimpl owns mathematical expression facts and
proofs.

One substantial duplicate solver exists in
`WaveLowerSymbolicMemory.cpp`. It implements known-bit propagation, exact
division, modular-grid reasoning, expression equality, and predicate
equivalence over ixsimpl nodes. Those mechanisms belong in ixsimpl. The
surrounding access planning, loop/workitem projection, and transaction cover
remain in Wave.

`WaveSymbols.cpp` is the other migration surface. Store ownership, typed
handles, structural import, and MLIR parse/print stay there. Definedness,
integrality, divisibility, compound fact ingestion, and generic range
extensions move into ixsimpl.

Core APIs in this priority order are landed; Wave deletions follow the same
order:

1. Fix compound assumption ingestion.
2. Export integrality and divisibility; remove denominator-based legality
   proofs.
3. Resolve the negative-Mod contract, then add a core definedness query.
4. Expose known bits and query-specific congruence; add fact-backed
   equivalence.
5. Reuse one fact context across related Wave queries.
6. Extend ranges for integer powers, XOR, and Piecewise.
7. Add affine-difference helpers, then remove local proof ladders.

## Ownership Rule

Use semantics, not argument types, when placing code:

> Reusable algebra and fact reasoning belong in ixsimpl. Wave-domain
> interpretation and policy stay in Wave, even when implemented using only
> expression nodes and integers. Code requiring MLIR values, types, regions,
> fixed-width semantics, workitems, memory transactions, or target
> instructions necessarily stays in Wave.

For example, `positiveAddendsFitU32` answers whether a chosen sequence of
32-bit additions is safe. Generic range propagation belongs in ixsimpl; the
decision to use that range for a low-word AMD address sequence remains in
Wave. Python helpers such as `_score_slot_expr`, `_dma_logical_col`,
`_dma_slot_expr`, and `_mxfp4_scale_layout` also stay in Wave: their inputs are
symbolic, but their meaning is an accumulator, DMA, or MXFP4 layout.

### ixsimpl owns

- expression construction and canonicalization;
- substitution and expansion;
- interval and rational range propagation;
- predicate entailment over its mathematical domain;
- definedness of its own partial operators;
- structural and fact-aware integrality;
- divisibility, congruence, and low-64-bit known bits;
- expression and predicate equivalence under a fact set;
- exact algebraic quotient construction;
- affine coefficient, residual, and constant-difference extraction.

### Wave owns

- `sym::Store`, locking, typed handles, and diagnostics;
- MLIR parser/printer integration and structural FFI import;
- converting SSA ranges and `wave.assume` operations into symbolic facts;
- fixed-width signed, unsigned, wrapping, and overflow semantics;
- dominance, control flow, loops, workitem projections, and rematerialization;
- memory-map legality and explicit token ordering;
- transaction grouping, adjacency policy, target legality, and profitability;
- materializing symbolic expressions into WaveAMDMachine operations;
- Python layout formulas and kernel scheduling policy.

## Current Architecture

The intended boundary already exists:

```text
Python ixsimpl nodes
        |
        | node_ptr / stable serialization
        v
Wave sym::Store ---- wave.expr / wave.pred attributes
        |
        v
wave.index_expr + bound SSA values + assumptions
        |
        +--> symbolic memory / redistribution / pointer transforms
        |
        +--> loop stride and div/rem transforms
        |
        `--> WaveAMDMachine selection and address materialization
```

Python imports nodes structurally through `wave_dsl.py` and
`lib/CAPI/Dialects.cpp`. No active `str(expr)` then parse round-trip exists.
Text constructors remain human-facing parser and test APIs.

The default lowering pipeline repeatedly normalizes symbolic address forms:

```text
lower-symbolic-memory
lower-redistribute
strength-reduce-modulo
normalize-pointer-offsets
generate-index-exprs
promote-global-to-buffer
combine-pointer-offsets
simplify-index-exprs
coalesce-memory
...
extract-loop-strides
expand-integer-div-rem
...
WaveAMDMachine selection
```

This repetition makes shared facts valuable. Rebuilding bounds independently in
each query loses both time and information.

## Existing ixsimpl Capability

The migration must reuse current machinery before adding new solvers.

| Capability | Current state |
|---|---|
| Hash-consed expression DAG | Complete |
| Structural import, serialization, substitution | Complete |
| Expansion and assumption-aware simplification | Complete |
| Batch simplification | Public for assumption arrays and reusable facts |
| Comparison and predicate-tree entailment | Public through fact sets |
| Rational interval range | Public for powers, XOR, Piecewise, and existing arithmetic |
| Power-of-two, known-bit, and congruence facts | Public through fact sets |
| Mutable fact sets | Public and session-owned |
| Explicit expression ranges and affine derivation | Public through fact sets |
| Fact substitution | Public simultaneous multi-target transfer |
| Structural and fact-aware integrality | Public |
| Arbitrary-expression divisibility and exact quotient | Public |
| Total definedness and equivalence | Public through fact sets |
| Constant, affine, finite-difference, and additive-split algebra | Public through fact sets |
| Predicate-tree expansion | Public through `ixs_expand` |

Fact sets accept conjunctions, explicit ranges, affine derivation, and
simultaneous substitution. Failed mutation poisons the set. Wave must treat
construction as atomic and keep one session alive for the complete proof
batch.

### Resolved import gap: nested XOR checks

The first import exposed an atomic-check failure around nested XOR. The initial
diagnosis was wrong: at `d7e536d` and `be4ac2d`, both assumption-array and
fact-backed checks returned unknown. Fact ingestion was not the difference.
The expression constructor retained `a ^ (a ^ b)`, and the resulting equality
could not be proved.

Upstream `56395e1` fixes the algebra and the query boundary:

- `a ^ (a ^ b)` canonicalizes to `b`, in either operand order;
- comparison construction then returns canonical true/false;
- `ixs_check` and `ixs_check_facts` accept those canonical predicates;
- contradictory fact domains still return unknown.

```c
ixs_node *x = ixs_sym(s, "x");
ixs_node *lo = ixs_cmp(s, x, IXS_CMP_GE, ixs_int(s, 0));
ixs_node *hi = ixs_cmp(s, x, IXS_CMP_LE, ixs_int(s, 31));
ixs_node *range = ixs_and(s, lo, hi);
ixs_node *nested = ixs_xor(s, ixs_int(s, 1),
                           ixs_xor(s, ixs_int(s, 1), x));
ixs_node *equal = ixs_cmp(s, nested, IXS_CMP_EQ, x);
ixs_node *assumptions[] = {range};

assert(nested == x);
assert(ixs_check(s, equal, assumptions, 1) == IXS_CHECK_TRUE);

ixs_facts *facts = ixs_facts_create(s);
assert(ixs_facts_assume_pred(facts, range));
assert(ixs_check_facts(facts, equal) == IXS_CHECK_TRUE);
```

The finite range is retained to exercise reusable fact ingestion; cancellation
itself is unconditional. Upstream C and Python regressions cover legacy check,
fact check, predicate check, and equivalence. Wave's `checkPredicate` wrapper
now uses `sym::Analysis`, including conservative three-valued checks for
AND/OR/NOT trees. Correct stronger proofs are accepted; unknown remains
conservative.

### Remaining semantic gaps after `5937113`

These are narrower sufficient rules, not blockers for the scoped facade:

| Issue | Actionable example | Wave use after landing |
|---|---|---|
| `4-3ay` symbolic-denominator floor reasoning | Prove `floor(A/D) - floor((A + delta)/D)` when `D > 0` and facts prove no quotient-boundary crossing | Replace cyclic/remainder floor subproofs; keep wrap policy local |
| `4-xr1c` relational symbolic Mod bounds | Simplify `Mod(a, 8*d) -> a` from `d > 0` and `0 <= a < 8*d` | Remove bounded enumeration around symbolic transaction/layout moduli |
| `4-bev` interval/congruence intersection | From `0 <= x <= 15` and `x == 2 (mod 4)`, tighten the hull to `[2, 14]` | Improve address and packet bounds without a Wave residue solver |
| `4-1p9q` equal Mod residues | Prove `Mod(A,m) - Mod(B,m) == 0` when `m` divides `A-B` | Replace remainder-adjacency and activation equality ladders |
| `4-1kb` batch shared-DAG memoization | Simplify many roots sharing one address subtree once per fact context | Reduce proof cost; no legality or output change allowed |

`5937113` adds deterministic single-node transform caches and atomic
`assume_many`; it does not implement `4-1kb`'s fact-sensitive shared-DAG
simplification.

The profiled node-ownership gap is closed by `e05626f`: ownership probes the
intern table by immutable hash and pointer identity. `56a3f9d` records the
expected-O(1) hot-path contract.

Fact substitution already handles the inverse affine case: `8 | y, y -> 2*K`
implies `4 | K`, never `8 | K`. Nonlinear replacements retain facts on the
complete substituted expression but do not invent symbol congruence or bit
records. Fixed-width arithmetic, OR assumption branch/join, and unbounded
relational solving remain deliberate non-goals unless a concrete Wave proof
requires them.

## Decision Matrix

| Priority | Core work | Core status | Wave result |
|---|---|---|---|
| P0 | Compound assumption ingestion | Landed | `flattenAssumption` deleted. |
| P0 | Public integrality, divisibility, and exact quotient | Landed | Stop using `collectDenominator` for legality; delete local exact division. |
| P0 | Resolve Mod contract and add definedness | Landed | Recursive definedness solver deleted. |
| P0 | Fact-backed simplification and a reusable fact context | Landed | `sym::Analysis` added; migrate proof batches. |
| P1 | Known bits, query-specific congruence, total equivalence | Landed | Delete possible-bit, modular-equivalence, and `proveEqual` ladders. |
| P1 | Integer-power, XOR, and Piecewise ranges | Landed | Delete generic U32 range recursion; keep U32 target policy. |
| P1 | Constant difference, affine decomposition, finite difference | Landed | Loop stride delta migrated; address algebra remains. |
| P2 | Predicate facade and rational endpoint helpers | Partial | Delete predicate rebuilding and repeated endpoint arithmetic. |
| P2 | Multi-substitution transfer and Python fact provenance | Core landed | Simplify builders without transporting opaque fact objects. |

P0 fixes correctness contracts or removes unsafe legality checks. P1 removes
duplicate solver mechanisms. P2 consolidates plumbing after those APIs settle.

## Audit Inventory

### Symbol facade and Wave IR

| File | Symbolic work | Disposition |
|---|---|---|
| `lib/Dialect/Wave/IR/WaveSymbols.cpp` | Store adapters, simplify/check/range wrappers, definedness, U32 proofs, target-delta bounds, denominator walk | Keep adapters and target U32 policy. Move generic proofs. |
| `lib/Dialect/Wave/IR/Wave.cpp` | Assumption collection, predicate implication/conflict handling, range-interface models, Redistribute integrality verification | Keep MLIR plumbing and conflict policy. Move compound entailment and integrality. |
| `lib/Dialect/Wave/IR/WaveMemoryAddress.cpp` | Converts SSA address trees into symbolic expressions, remaps bindings, computes deltas | Keep bridge. Remap and combine both sides' facts before a core constant-difference query. |

`Wave.cpp` contains two policies that must not be confused with generic
predicate simplification:

- dropping stale facts contradicted by a trusted producer range;
- retaining only predicates whose symbols remain bound.

Those are IR fact-lifetime decisions and stay in Wave.

### Index and pointer transforms

| File | Symbolic work | Disposition |
|---|---|---|
| `WaveGenerateIndexExprs.cpp` | Converts fixed-width SSA arithmetic into mathematical expressions after proving no-wrap conditions | Keep in Wave. |
| `WaveSimplifyIndexExprs.cpp` | Imports `IntegerRangeAnalysis` facts and rewrites expression attributes | Keep transform; use a shared fact-backed adapter. |
| `WaveNormalizePointerOffsets.cpp` | Scales offsets and range assumptions | Keep transform; share endpoint conversion. |
| `WaveCombinePointerOffsets.cpp` | Composes nested address expressions and remaps assumptions | Keep transform; use batch substitution and facts. |
| `WavePromoteGlobalToBuffer.cpp` | Proves buffer offset ranges and scales assumptions | Keep target policy; replace proof ladders with core queries. |
| `WaveCoalesceMemory.cpp` | Consumes normalized address deltas and groups accesses | Keep in Wave. |

These files contain repeated rational endpoint conversion. Consolidate it in
the Wave facade or expose safe endpoint comparison helpers from ixsimpl. It is
not a reason to move the transforms.

### Symbolic memory and redistribution

| File | Symbolic work | Disposition |
|---|---|---|
| `WaveLowerSymbolicMemory.cpp` | Exact byte division, known-bit/XOR analysis, predicate equivalence, modular-grid proofs, remainder adjacency, transaction cover | Move generic algebra. Keep SSA projection and access policy. |
| `WaveLowerRedistribute.cpp` | Finite relation specialization, exact enumeration, equality checks, shuffle/LDS selection | Keep enumeration and selection. Use core equivalence. |
| `WaveAMDMemoryTransactionProvider.cpp` | Samples and validates AMD B8/B16 transaction grammars; carries a private `proveEqual` ladder | Keep transaction grammar. Use core equivalence throughout validation. |

Generic solver code in `WaveLowerSymbolicMemory.cpp` starts with the
`divideExpanded*` exact-division helpers. The known-bit and predicate block
starts at `possibleOneBits`, continues through modular predicate equivalence,
and ends with `proveEqual`. It should disappear after the corresponding
ixsimpl APIs land.

`RemainderProofContext` remains Wave-owned. It reasons about SSA uses,
`wave.assume`, loop induction variables, workitem axes, execution projections,
and whether proof-only projection would duplicate runtime div/rem. Its calls
into modular, equality, and nonnegativity reasoning should become thin core
queries. `collectExpressionModuli` collects syntactic periods used to project
workitems; congruence facts do not replace it. Keep that traversal local unless
ixsimpl gains a distinct expression-period or static-modulus query.

### Loop and integer transforms

| File | Symbolic work | Disposition |
|---|---|---|
| `WaveExtractLoopStrides.cpp` | Expands an expression, substitutes `iv + step`, subtracts the original, and matches cyclic offsets | Move finite-difference and affine decomposition helpers. Keep SCF rewrite policy. |
| `WaveExpandIntegerDivRem.cpp` | Combines constants, `IntegerRangeAnalysis`, assumptions, loop bounds, and symbolic predicates | Keep typed proof ladder and target lowering. Share core range primitives. |

`WaveExpandIntegerDivRem` cannot move wholesale. MLIR division and remainder
carry bit width, signedness, and wrapping behavior. ixsimpl uses unbounded
mathematical values, exact rational division, explicit floor, and
floor-derived Mod semantics.

### WaveAMDMachine

| File | Symbolic work | Disposition |
|---|---|---|
| `lib/Dialect/Wave/Transforms/WaveAMDMachine.cpp` | Imports ranges, proves U32 address fits, materializes rational address expressions | Move generic nonnegativity and divisibility. Keep instruction selection. |
| `WaveAMDMachineIndexExpr.cpp` | Recursively tracks rational denominators and power-of-two numerator divisibility | Move integrality/divisibility queries. Keep materialization. |
| `WaveAMDMachineLoopCarryPlan.cpp` | Builds symbolic trip/stride expressions and proves carry widths | Keep plan; use shared facts. |
| `WaveAMDMachineScfFor.cpp` | Chooses narrow/wide loop representations from fixed-width SSA ranges | Keep in Wave. |
| `WaveAMDMachineSelectedBufferSources.cpp` | Evaluates small Add/Mul expressions after binding constants | Replace with structural substitution plus core literal query. |

Reviewed near-misses stay local:

| File or area | Why it is not an ixsimpl migration |
|---|---|
| `WaveAMDFormFusedInt.cpp` | U24/I24 range legality, byte provenance, permutation selectors, and target truth tables use fixed-width values and SSA identity. |
| `WaveAMDNarrowWideInt.cpp` | High-word representation and U32 narrowing are bitvector questions. |
| `WaveMetaSpecialize.cpp` | Constant trip counts and unroll arithmetic drive transform mechanics. |
| `WaveResolveAllocs.cpp` | Alignment and interval packing describe storage placement. |
| `WaveAMDPairDsOps.cpp` | Immediate arithmetic is tied to DS encodings. |
| `lib/Conversion/WaveToLLVM/WaveToLLVM.cpp` | Performs address-space and type conversion; no generic symbolic solver exists there. |
| Regalloc, scheduling, barriers, hazards | Operate on physical resources, execution order, or machine instructions. |

Arithmetic-looking code is not enough to make a migration candidate. These
sites lack reusable expression-domain facts or prove a different, typed
property.

### Python and wavec

Python attention and matmul builders already construct ixsimpl expressions.
Their CTA, DMA, LDS, MMA, and epilogue formulas remain Wave layout policy.
A Python builder helper can carry:

```text
expression + MLIR bindings + structural assumptions + intended index shape
```

This is not a transported `ixsimpl.Facts` object. Opaque facts do not cross the
Python-to-MLIR boundary. Host-side facts must be emitted as structural
`#wave.pred` assumptions or explicit ranges. `wave.index_expr` still returns
builtin index or SIMD-index; fixed-width results require an explicit cast and
the existing no-wrap proof. A standalone `wave.assume` names one SSA value.
Multi-value relations belong on an `index_expr` whose predicates reference its
bindings, unless the IR gains a new relational fact operation.

First builder-helper migration targets in
`python/mlir/dialects/wave_matmul.py`:

| Area | Functions or region | Range provenance |
|---|---|---|
| CTA remap | `_emit_cta_coords`, `_emit_tile_coords` | Grid contract; keep explicit unless grid dimensions enter IR metadata. |
| DMA state and offsets | `_dma_subpanel_read_bases` through `_dma_subpanel_lds_byte_base` | Derived affine facts; infer from expression and bindings. |
| MXFP4 K step | `_mxfp4_raw_k_step` | Derived affine fact. |
| Epilogue offsets | coalesced and non-coalesced store builders | Workitem range comes from `wave.workgroup_size`; derived offsets use core range propagation. |
| Pipeline state | `_emit_dma_subpanel_step`, loop, and kernel state | SCF IV ranges come from loop analysis; external dynamic-trip contracts stay explicit. |

Do not delete range annotations by shape alone. Classify their source:

- workitem ranges already available to `IntegerRangeAnalysis`: remove the
  duplicate Python annotation;
- grid-size and external dynamic-trip contracts absent from IR: keep them;
- derived affine ranges: build them from bindings and facts;
- SCF induction-variable ranges: consume loop analysis.

`python/mlir/dialects/wave_dsl.py` also contains an `IndexExpr` wrapper around
SSA `arith.addi` and `arith.muli`. It has one production consumer in the matmul
MMA grid. Replace it independently with `wave.index_expr`; it needs no new
ixsimpl facts API.

Host-time validation and reference math are not migration candidates. Keep
attention shape validation and greedy zero-region chunking, plus matmul
configuration validation and input/reference computation, in Python. Their
`%`, `//`, power-of-two, and interval-like arithmetic do not model runtime
symbolic lowering. `_mod_expr` and `_floor_div_expr` in
`python/mlir/dialects/wave_attention.py` expose only a low-priority Python
ergonomics gap for int-or-expression operands.

wavec must not depend on ixsimpl in its C lexer, parser, AST, or semantic
analysis. No direct wavec migration is currently justified: its AST and sema do
not record the nonnegative and no-wrap proofs needed to select mathematical
subtrees. `lowerIntBinary` mixes index and fixed-width operators, and even
`lowerWaveIdCall` emits i32 arithmetic. Keep signed/unsigned division,
remainder, shifts, masks, and wrapping arithmetic as typed SSA. Let downstream
`WaveGenerateIndexExprs` recognize safe arithmetic. A future direct path first
needs typed AST legality analysis and an exact operation whitelist; use
`wavec/test/e2e/good/integer_index_ops.wave` as the mixed-semantics regression.

## Gap 1: Compound Assumption Ingestion

Gap sections preserve the original audit reproducer and implementation action.
The decision matrix above records current status; gaps 1 through 7 are landed
in the imported core, while their Wave-side deletions remain incremental.

### Audit-baseline behavior (`d7e536d`)

The public `ixs_simplify` contract accepts CMP/AND/OR assumption nodes.
`ixs_bounds_build_ctx` sends each array entry to
`ixs_bounds_add_assumption`, which silently ignores non-CMP nodes.

Wave compensates with `flattenAssumption`, recursively exploding AND trees
before every simplify, check, power-of-two, and range query. Fact sets have a
separate iterative AND walker and reject OR.

This is a contract bug and duplicated ingestion logic.

### Reproducer

```c
ixs_node *x = ixs_sym(s, "x");
ixs_node *lo = ixs_cmp(s, x, IXS_CMP_GE, ixs_int(s, 0));
ixs_node *hi = ixs_cmp(s, x, IXS_CMP_LE, ixs_int(s, 31));
ixs_node *both = ixs_and(s, lo, hi);
ixs_range_result range;

/* Must return [0, 31]. The legacy array path currently ignores `both`. */
bool ok = ixs_range(s, x, &both, 1, &range);
```

### Action

Add one internal iterative predicate-ingestion routine and use it from both
legacy assumption arrays and fact sets.

Required semantics:

- CMP: ingest normally;
- AND: ingest every child;
- OR: either fork each branch and join facts, or reject it explicitly;
- NOT and other nodes: reject explicitly unless supported;
- depth: bounded explicit stack, no recursive caller workaround;
- contradiction: preserve current unknown/no-result behavior.

Do not continue documenting OR support while silently ignoring it. Branch/join
is useful but not required for the first patch; explicit rejection is enough.

### Tests

Add C tests in `third_party/ixsimpl/test/test_bounds.c`:

- one AND passed through each legacy query API;
- a 300-node conjunction to verify iterative traversal;
- OR rejected or branch-joined according to the chosen contract;
- malformed/sentinel children produce no fabricated facts;
- legacy arrays and `ixs_facts_assume_pred` return the same range.

After importing the updated submodule, delete `flattenAssumption` from
`WaveSymbols.cpp` and add a Wave test with a single `#wave.pred<"x >= 0 & x <=
31">` assumption.

## Gap 2: Reusable Facts for Simplification

### Audit-baseline behavior (`d7e536d`)

`ixs_facts` supports range, check, and power-of-two queries. Simplification
still takes an assumption array and rebuilds bounds. Wave creates a fresh
`sym::Session` in most facade calls, so one logical proof sequence repeatedly
parses the same assumptions.

Typical current sequence:

```text
simplify(expr, assumptions)
inferRange(expr, assumptions)
check(expr >= 0, assumptions)
check(expr <= limit, assumptions)
getPow2Fact(expr, assumptions)
```

Every line rebuilds a bounds context.

### Action

Add fact-backed simplification:

```c
ixs_node *ixs_simplify_facts(ixs_facts *facts, ixs_node *expr);
void ixs_simplify_batch_facts(ixs_facts *facts, ixs_node **exprs, size_t n);
```

Add a Wave scoped analysis object:

```c++
class Analysis {
public:
  static FailureOr<std::unique_ptr<Analysis>>
  create(Store &store, ArrayRef<PredHandle> assumptions);

  LogicalResult assume(PredHandle pred);
  LogicalResult assumeRange(ExprHandle expr, InferredRange range);
  LogicalResult deriveAffine(ExprHandle base, int64_t scale, int64_t offset,
                             ExprHandle derived);

  FailureOr<ExprHandle> compose(ExprHandle lhs, ExprBinaryOp op,
                                ExprHandle rhs);
  FailureOr<PredHandle> compare(ExprHandle lhs, PredCmpOp op,
                                ExprHandle rhs);
  FailureOr<ExprHandle>
  substitute(ExprHandle expr, ArrayRef<ExprSubstitution> substitutions);

  FailureOr<ExprHandle> simplify(ExprHandle expr);
  std::optional<InferredRange> range(ExprHandle expr);
  CheckResult check(PredHandle pred);
  CheckResult defined(ExprHandle expr);
  CheckResult integerValued(ExprHandle expr);
};
```

The exact name is not important. Lifetime is.

`Analysis` owns one `Session` and one fact set. A `Session` holds the Store
lock, so do not make it pass-global. Scope it around one operation, address
family, or proof batch. Construction is fallible: fact allocation or rejected
assumption ingestion must not silently produce a weaker context. Any later
fact-ingestion failure makes the object unusable for proofs.

All node construction, substitution, and fact mutation performed while the
object is live must go through session-aware methods on `Analysis`. Store-level
facades currently nest through the recursive Store lock, but they create an
extra session and rely on scratch-state save/restore. That is supported by core,
not the Wave integration contract. Alternatively, construct every query node
before creating the analysis object; this is too restrictive for
symbolic-memory proof code and is not the preferred contract. The sketch shows
representative builders; implementation needs session-aware equivalents for
every compose and expression/predicate substitution operation used by migrated
callers.

### First migration targets

1. `IndexExprOp::inferResultRanges`.
2. U32 address checks in `WaveSymbols.cpp`.
3. each slot family in `WaveLowerSymbolicMemory`.
4. pointer-carry validation in `WaveExtractLoopStrides`.
5. address planning in WaveAMDMachine selection.

### Acceptance criteria

- no result or ASM change;
- one bounds/fact build per logical proof batch;
- no nested Store sessions;
- contradictory facts remain conservative;
- profiling reports fact-build count and time before/after.

The imported core no longer adds context-size-linear ownership work. Repeated
fact construction in Wave remains the scaling limit.

Core tests for `ixs_simplify_facts` must cover:

- parity with assumption-array simplification;
- explicit range and affine facts that cannot be reconstructed as predicates;
- substituted facts;
- repeated simplification without corrupting the reusable fact set;
- contradictory facts;
- wrong-context nodes and expired/reset sessions;
- rejected OR, sentinel input, and fault-injected OOM.

Wave tests must also prove that failure to ingest any assumption aborts the
analysis. Dropping one rejected fact and continuing is unsound.

### Profiled scaling failure

At `56395e1`, `tlx_fa_8k_persistent_causal` took over six minutes in
`wave-translate`. A 30-second, 99 Hz DWARF-callgraph sample of the exact golden
command collected 3,000 samples with none lost:

```bash
perf record -F 99 --call-graph dwarf,16384 \
  -o build/profiles/tlx_fa_8k_persistent_causal.perf.data -- \
  timeout --signal=INT 30s build/bin/wave-translate \
  --wave-to-amdgpu-asm \
  test/PerfGolden/Inputs/tlx_fa_8k_persistent_causal.mlir
```

| Profile node | Inclusive cycles | Self cycles |
|---|---:|---:|
| `bounds_ingest_predicate` | 89.67% | 0.17% |
| assumption-array `sym::simplifyExpr` | 75.55% | 0.00% |
| `ixs_bounds_build_ctx` | 74.18% | 0.07% |
| `ixs_arena_contains` | 54.43% | 53.95% |
| `planGatherTransactions` | 51.72% | 0.00% |
| `proveEqual` | 46.35% | 0.00% |
| `verifyB16OutputSlot` | 38.35% | 0.03% |
| `checkPredicate` | 16.12% | 0.00% |
| `Analysis::create` | 15.96% | 0.00% |

After migrating B16 verification to one reusable `Analysis`, an identical
30-second sample moved `verifyB16OutputSlot` from 38.35% to 5.92% inclusive
and `ixs_arena_contains` from 53.95% to 33.41% self. Generic adjacency then
dominated: `adjacent` 73.28%, `proveEqual` 69.87%, and legacy
assumption-array simplification 57.06% inclusive. Sample shares are
phase-local; they show hotspot movement, not an end-to-end speedup.

Pair-scoped `Analysis` reuse in adjacency moved bounds ingestion from 77.98%
to 57.71%, legacy assumption-array simplification from 57.06% to 29.92%, and
`checkPredicate` from 23.89% to 9.48% in the next identical sample. Fact-set
creation itself became 29.69% inclusive and arena scanning remained 31.34%
self. Per-pair reuse removes duplicate queries inside one comparison.

At `56a3f9d`, the same sample contains no `ixs_arena_contains` symbol;
`ixs_ctx_owns_node` is 0.17% self. Bounds ingestion remains 49.12% inclusive
because pair-scoped fact construction still repeats. Full causal regeneration
fell to 143.99 seconds and produced byte-identical ASM.

The next profile was taken after two ixsimpl caches, not a lowering shortcut:

- `ixs_bounds_has_empty` caches contradiction scans until fact mutation;
- successful top-level expansion is memoized by immutable node identity.

Exact regeneration fell to 107.62 seconds (`101.63` user, `5.93` system),
again with byte-identical ASM. A fresh 30-second profile showed the intended
hotspot movement:

| ixsimpl path | Inclusive | Self |
|---|---:|---:|
| `bounds_ingest_predicate` | 31.65% | 0.28% |
| `bounds_expr_without_add_const` | 24.98% | below 0.1% |
| `Analysis::create` | 18.46% | below 0.1% |
| `ixs_bounds_check_defined` | 6.71% | below 0.1% |
| `ixs_bounds_has_empty` | 0.92% | 0.61% |
| `expand_impl` | 0.77% | below 0.1% |

This exposed two core costs. Shifted ADD bounds rebuilt the same immutable
ADD-minus-constant node through `simp_add` for every assumption. `Analysis`
also called `ixs_facts_assume_pred` once per root; every call forked, copied,
and committed the growing fact set.

ixsimpl now addresses both mechanisms:

- a context-local node-transform table memoizes expansion and
  ADD-minus-constant results at most 75% load;
- `ixs_facts_assume_preds` ingests an array through one fork and one commit;
  C++ `Facts::assume_many`, Python `Facts.assume_many`, and Wave
  `Analysis::create` use the same atomic batch.

The exact post-transform/batch regeneration took 101.88 seconds (`96.68`
user, `5.14` system). ASM remained byte-identical. In its fresh 30-second
profile, `bounds_expr_without_add_const` disappeared above 0.05%,
`bounds_ingest_predicates` fell to 3.92% inclusive, and `Analysis::create`
fell to 1.82%. The new leading core costs are definedness scratch-table clears
and integral rational arithmetic:

| ixsimpl path | Inclusive | Self |
|---|---:|---:|
| `ixs_bounds_check_defined` | 17.42% | below 0.1% |
| `defined_cache_scope_init` | 9.58% | below 0.1% |
| `memset` | 19.43% | 5.78% |
| `ixs_rat_mul` | 4.51% | 0.75% |
| `ixs_gcd` | 4.05% | 3.35% |
| `bounds_get_expr_overrides` | 2.11% | 1.62% |

The first three percentages overlap. They identify fixed 8K/16K table clears,
not three independent savings. The remaining target is below 100 seconds;
run-to-run variance is not acceptance.

The final core pass fixes those measured costs:

- definedness' existing bounded DAG walk returns its visit count; the
  temporary interval cache is the smallest power-of-two table from 32 through
  8192 with at least two slots per visit;
- rational normalize, add, multiply, and equal-positive-denominator compare
  bypass GCD/cross-products for exact integral inputs while retaining checked
  overflow and `INT64_MIN` behavior.

The first final-core run took 89.17 seconds, but final Wave review found two
callers bypassing total equivalence on unknown. After deleting those fallbacks,
the latest observed exact run takes 92.98 seconds (`92.18` user, `0.76`
system) and emits byte-identical ASM. This is 51.01 seconds, or 35.4%, below
the 143.99-second upstream-ownership baseline and 7.02 seconds below the
target. This is one observed run, not a variance claim.

The output and checked-in golden both hash to
`f916b8ad2c51c40dc924ee508663b2388f6de564a9acd25186973bcb7fe6e039`.
Timing output is
`build/profiles/tlx_fa_8k_persistent_causal.total-equivalence.time`; the fresh
profile is
`build/profiles/tlx_fa_8k_persistent_causal.total-equivalence.perf.data`.
The final 30-second, 3,132-sample profile lost no samples and confirms
mechanism removal:

| Profile node | Before final core pass | Final |
|---|---:|---:|
| `adjacent` inclusive | 37.28% | 16.18% |
| `ixs_bounds_check_defined` inclusive | 17.42% | 3.30% |
| `defined_relation_zero` inclusive | 13.24% | 0.72% |
| `memset` self | 5.78% | 3.61% |
| `ixs_rat_mul` inclusive | 4.51% | 1.42% |
| `ixs_gcd` self | 3.35% | 0.54% |

Residual cost is equivalence-driven simplification, not batch ingestion:

| Final profile node | Inclusive |
|---|---:|
| `simp_simplify_bounds` | 10.89% |
| `ixs_equivalent_facts` | 10.93% |
| `Analysis::create` | 1.80% |
| `ixs_simplify_batch` | 0.54% |

Within `simp_simplify_bounds`, equivalence paths account for 6.86 percentage
points, scalar simplify 3.53, and batch simplify 0.48. Issue `4-1kb` remains
useful for general shared-DAG batches, but it is not the next 10.89% fix for
this kernel. First measure query-local memoization in `equivalence_core`, which
simplifies both operands, their difference, and both expanded operands under
the same immutable facts.

No Wave address cache, assumption grouping, or candidate pruning is part of
this result.

Before `e05626f`, two costs multiplied. B16 output verification and adjacency
proofs rebuilt the same bounds from assumption arrays for each slot or pair.
Every predicate and CMP child called `ixs_ctx_owns_node`, which used
`ixs_arena_contains` to linearly walk all context arena chunks. Mature stores
made validation proportional to arena age, not query size.

The linear lookup came from `1bbc1d39` (structural cross-context import).
`537629c2` (unified compound-assumption ingestion) made it hot by validating
each predicate root and both CMP children during every bounds build. The safety
check is correct; the lookup and repeated builds are the scaling failure.

The exact pass is `wave-lower-symbolic-memory`. This input has 128 four-slot
gathers plus two 64-slot gathers and two 64-slot scatters. Each large access
tries 4,032 ordered adjacency pairs. Two large gathers can also try 2,016
deduplication pairs each. `proveEqual` rebuilds facts up to three times per
nontrivial comparison. Static call-count analysis estimates about 59,976 fact
builds for the four 64-slot operations before remainder fallbacks.

Wave action:

1. Landed: create one `Analysis` for B16 provider verification and pass it
   through `getB16AddressOffset`, `verifyB16OutputSlot`, and per-item
   substitution.
2. Landed intermediate: create one `Analysis` per adjacency/dedup pair and
   reuse total equivalence, simplification, and check results within the pair.
3. Do not use address/assumption grouping as the performance repair. It moves
   repeated work around Wave while leaving the profiled core mechanisms intact.
4. Keep pair-specific assumptions separate. Never accumulate one pair's facts
   into another pair.
5. Count legacy bounds builds, `Analysis::create`, ingested assumptions,
   adjacency pairs, and remainder binding pairs. Counting only Analysis
   objects misses assumption-array simplification.

ixsimpl action:

1. Landed upstream: constant-time intern-table ownership validation.
2. Vendored in `5937113`: contradiction, expansion, and ADD-minus-constant
   caches keyed by fact mutation or immutable node identity as appropriate.
3. Vendored in `5937113`: atomic batch fact ingestion with C, C++, and Python
   parity.
4. Vendored in `5937113`: size definedness scratch caches from the bounded
   query DAG and bypass GCD/normalization for exact integral rational
   operations.

Add an 8/16-slot `16*offset` regression. Proof queries may scale with the
candidate graph; fact builds must scale with access/address families, not slot
pairs. Use counters or pass statistics, never wall time, in lit. For manual
pass timing, `wave-translate` accepts `--mlir-timing` and
`--mlir-timing-display=list|tree`.

ixsimpl resolution (`e05626f`):

1. Replace arena-range scanning with exact interning-table membership. Every
   public node is interned, the table has no deletion, and pointer identity
   still rejects same-shaped foreign nodes:

   ```c
   mask = ctx->htab_cap - 1;
   index = node->hash & mask;
   for (probes = 0; probes < ctx->htab_cap; ++probes) {
     if (!ctx->htab[index])
       return false;
     if (ctx->htab[index] == node)
       return true;
     index = (index + 1) & mask;
   }
   return false;
   ```

   This is expected constant time, adds no metadata, and avoids relational
   pointer comparisons between unrelated allocations.
2. Same-store import now always takes the structural path. Tests cover owned,
   foreign, and deliberately non-interned nodes plus same/cross-store import.
3. Benchmark old, middle, newest, post-rehash, and wrong-context nodes through
   public import and proof APIs. Linear degradation with node age fails.
4. Land shared-DAG batch memoization only after fact-build reuse; it cannot
   compensate for rebuilding and revalidating the same assumptions.

Existing wrong-context bounds, facts, import, and Python tests remain. Add old,
middle, newest, post-rehash, same-shaped foreign, non-interned, and interior
pointer cases. `test_bounds.c` must construct malformed nodes through the raw
interning constructor; retaining stack-backed children in a hand-allocated
arena node is invalid test setup.

Ownership acceptance is met: ownership validation is no longer a material
self-time symbol. The measured core fixes retain exact ASM and reduce the
full-command wall time from 143.99 to 92.98 seconds. Wave-side adjacency fact
grouping is deliberately not part of the repair.

## Gap 3: Integrality, Divisibility, and Exact Quotients

### Audit-baseline behavior (`d7e536d`)

Wave legality uses `collectDenominator`. It walks rational coefficients but
ignores MUL exponents. A factor with exponent `-1` can therefore look
structurally integral.

ixsimpl already has two correct internal mechanisms:

- `ixs_node_is_integer_valued` rejects negative powers and non-integral
  coefficients;
- `ixs_bounds_is_integer_with_divinfo` uses congruence facts, allowing values
  such as `K/32` when facts prove `K` divisible by 32.

Wave also manually expands and divides every coefficient in
`divideCoefficientsExactly`.

### Reproducers

Structural false positive:

```text
expr = 2*x**-1
```

`collectDenominator(expr)` can return one even though `expr` is not
structurally integer-valued.

Fact-aware positive case:

```text
expr = K/32
fact = Mod(K, 32) == 0
```

Structural integrality is false. Integrality under facts is true.

Exact quotient cases:

```text
(64*item + 32*slot) / 8  -> 8*item + 4*slot
(item + 1) / 8           -> not proven exact
```

### Action

Export structural and fact-aware queries:

```c
bool ixs_node_is_integer_valued(const ixs_node *expr);

ixs_check_result ixs_check_integer_valued(
    ixs_session *s, ixs_node *expr,
    ixs_node *const *assumptions, size_t n_assumptions);

ixs_check_result ixs_check_integer_valued_facts(
    ixs_facts *facts, ixs_node *expr);

ixs_check_result ixs_check_divisible_facts(
    ixs_facts *facts, ixs_node *expr, int64_t modulus);
```

For the tri-state APIs, current internal proof helpers map success to `TRUE`
and failure to `UNKNOWN`. `FALSE` is valid only when the implementation proves
nonintegrality or nondivisibility for every feasible valuation. It must not be
the negation of a sufficient-proof boolean. Divisibility rejects modulus zero
and normalizes negative moduli without overflowing on `INT64_MIN`.

Then choose one exact-division interface:

```c
typedef enum {
  IXS_EXACT_DIVIDE_PROVEN,
  IXS_EXACT_DIVIDE_NOT_EXACT,
  IXS_EXACT_DIVIDE_UNKNOWN,
  IXS_EXACT_DIVIDE_ERROR
} ixs_exact_divide_status;

typedef struct {
  ixs_exact_divide_status status;
  ixs_node *quotient;
} ixs_exact_divide_result;

ixs_exact_divide_result ixs_try_exact_divide_facts(
    ixs_facts *facts, ixs_node *expr, int64_t divisor);
```

or make `ixs_simplify_facts(expr/divisor)` reliably construct the quotient
after `ixs_check_divisible_facts` succeeds. A plain `ixs_check_result` is not
enough here: it cannot distinguish unknown from OOM or a domain error. Session
diagnostics carry the detailed error after `IXS_EXACT_DIVIDE_ERROR`.

### Wave migration

Before:

```c++
std::optional<int64_t> denominator = sym::collectDenominator(expr);
if (!denominator || *denominator != 1)
  return failure();
```

After:

```c++
if (analysis.integerValued(expr) != sym::CheckResult::True)
  return failure();
```

Replace legality uses in Redistribute verification and symbolic-memory byte
division. Keep an exact denominator-LCM query only if a diagnostic or machine
materializer truly needs the value.

### Tests

Core tests:

- negative exponent is not structurally integral;
- rational coefficient without facts is not integral;
- congruence proves `K/32` integral;
- `1/x` and `K/32` without sufficient facts return unknown, not false;
- sum requires every term integral;
- Piecewise requires every reachable value integral;
- exact quotient succeeds and simplifies the positive example;
- exact quotient returns unknown for the negative example;
- zero divisor reports an error;
- fault-injected OOM is distinguishable from an unknown proof;
- `INT64_MIN`, large LCMs, and negative divisors do not overflow.

Wave tests:

- Redistribute rejects a reciprocal coordinate;
- symbolic memory rejects a reciprocal byte offset;
- congruence-backed exact byte division still lowers;
- WaveAMDMachine rational power-of-two materialization remains unchanged.

## Gap 4: Definedness

### Audit-baseline behavior (`d7e536d`)

ixsimpl constructors catch literal domain errors such as division by zero, but
there is no public query asking whether a symbolic expression is defined for
every value admitted by a fact set.

Wave implements a recursive evaluator in `WaveSymbols.cpp`:

- negative MUL exponents require nonzero bases;
- Mod requires a nonzero divisor;
- children of arithmetic nodes must be defined;
- Piecewise values are checked under branch conditions;
- Piecewise conditions must cover the execution domain.

Partial definedness currently collapses to a boolean "not proven" result.

### Reproducers

```text
facts: 0 <= x <= 31

floor(1/(x + 1))                         -> defined
floor(1/(x - 1))                         -> unknown; x may equal 1
Mod(x, m), with m > 0                    -> defined under either contract
Mod(x, m), with m != 0                   -> contract-dependent; see below
Piecewise((x, x < 16), (0, True))        -> defined
Piecewise((x, x < 16)), with x < 16      -> defined
Piecewise((x, x < 16)), with 0 <= x < 32 -> unknown
```

Current ixsimpl sources disagree about negative Mod divisors:

- the public header calls Mod Python/SymPy-floored and documents only zero as
  an error;
- `DESIGN.md` requires a positive divisor;
- constant folding rejects a negative divisor;
- the symbolic constructor rejects zero but admits an unproven or negative
  symbolic divisor;
- Wave's local definedness check proves only nonzero.

Resolve this contract before exporting definedness. Two coherent choices
exist: support signed Python/SymPy Mod and make only zero undefined, or require
a positive modulus everywhere. The first requires fixing constant folding and
documenting signed result ranges. The second requires fixing the public header
and rejecting or guarding symbolic nonpositive divisors. Wave machine lowering
still requires a positive static divisor regardless.

### Action

Add assumption-array and fact-backed APIs:

```c
ixs_check_result ixs_check_defined(
    ixs_session *s, ixs_node *expr,
    ixs_node *const *assumptions, size_t n_assumptions);

ixs_check_result ixs_check_defined_facts(
    ixs_facts *facts, ixs_node *expr);
```

The API follows the resolved Mod contract. It must not encode the current
header/design/implementation disagreement as accidental behavior.

Return semantics:

- `TRUE`: defined for every feasible valuation;
- `FALSE`: necessarily undefined for every feasible valuation;
- `UNKNOWN`: mixed domain, insufficient facts, unsupported proof, or detected
  contradictory facts.

Piecewise is first-match. For branch `i`, evaluate the value under:

```text
!condition[0] & ... & !condition[i - 1] & condition[i]
```

Use branch-local bounds forks. Coverage requires the disjunction of effective
branch domains to be true under incoming facts. A final `True` branch proves
coverage immediately after earlier conditions are known defined.

### Tests

- the examples above;
- nested reciprocal and Mod nodes;
- literal negative Mod and symbolic `m < 0`, `m != 0`, and `m > 0` cases;
- a dead undefined branch does not poison the result;
- an earlier matching branch suppresses later undefined branches;
- undefined branch conditions remain conservative;
- Piecewise without a default is proven only when facts imply coverage;
- depth limits and shared DAG nodes do not cause exponential traversal.

After import, delete `provablyDefined`'s recursive implementation from Wave and
retain only the typed adapter.

## Gap 5: Known Bits, Congruence, and Equivalence

### Audit-baseline behavior (`d7e536d`)

ixsimpl internally tracks:

```c
known_zero
known_one
power-of-two state
symbol congruence: value == residue (mod modulus)
```

It already rewrites disjoint XOR to addition. Only the power-of-two lattice is
public.

`WaveLowerSymbolicMemory.cpp` duplicates part of this engine through
`possibleOneBits`, then implements modular comparison equivalence and recursive
commutative predicate matching.

### Known-bit example

```text
a = 16*item
b = slot
facts: 0 <= slot < 16
```

The low four bits of `a` are zero. A bounded `slot` can set only those low four
bits. Therefore:

```text
xor(a, b) == a + b
```

Wave currently proves this by computing possible-one masks recursively. Core
known-bit propagation already has the relevant information.

### Congruence example

```text
lhs = Mod(x, 16) < 8
rhs = Mod(x + 16, 16) < 8
```

These predicates are equivalent. A caller should not need to collect modulus
nodes, normalize comparison residuals, compare additive constants, and run a
bipartite match over AND/OR children.

### Action

Expose low-64-bit known bits and the existing symbol-congruence store:

```c
typedef struct {
  uint64_t known_zero;
  uint64_t known_one;
  ixs_pow2_fact pow2;
} ixs_known_bits;

bool ixs_get_known_bits_facts(
    ixs_facts *facts, ixs_node *expr, ixs_known_bits *out);

bool ixs_get_symbol_congruence_facts(
    ixs_facts *facts, ixs_node *symbol,
    int64_t *modulus, int64_t *residue);

ixs_check_result ixs_check_congruent_facts(
    ixs_facts *facts, ixs_node *expr,
    int64_t modulus, int64_t residue);
```

For known bits, zero in both masks is a valid "nothing known" result. The
boolean reports whether the query accepted the node/context and produced a
sound abstraction; errors remain distinguishable through session diagnostics.

The stored full modulus/remainder record is currently symbol-only. Exporting
it is small. Returning a strongest congruence for an arbitrary expression
would require a new propagation lattice and a precise ordering over candidate
moduli. Wave does not need that API. A query-specific
`ixs_check_congruent_facts` matches existing Add/Mul/divisibility machinery
and answers the actual question.

Add general predicate-tree checking:

```c
ixs_check_result ixs_check_predicate_facts(
    ixs_facts *facts, ixs_node *predicate);

ixs_check_result ixs_equivalent_facts(
    ixs_facts *facts, ixs_node *lhs, ixs_node *rhs);
```

Compound query semantics are straightforward:

- AND true when every child is true, false when any child is false;
- OR true when any child is true, false when every child is false;
- NOT inverts true/false;
- unknown propagates conservatively.

These rules apply only when `ixs_node_is_pred(predicate)` is true. Numeric
bitwise `x & 7` and `x | y` share AND/OR node tags but are not predicate trees;
reject them instead of treating them as conjunctions.

This is distinct from assuming an OR predicate, which requires branch/join.

Define equivalence as total over the incoming fact domain: both operands must
be defined for every feasible valuation. This matches Wave legality. An API
for equality only on the intersection of defined domains can be added later if
a caller needs it.

Expression equivalence should try, in order:

1. prove both operands defined;
2. pointer equality;
3. fact-backed simplify of `lhs - rhs` to zero;
4. expansion plus shared batch simplification;
5. congruence-aware sufficient rules;
6. unknown.

Do not add unbounded theorem proving.

### Wave migration

- delete `possibleOneBits` and `linearizeDisjointXors`;
- delete modular-grid predicate equivalence;
- delete recursive AND/OR bipartite matching;
- replace `proveEqual` ladders with `analysis.equivalent(lhs, rhs)`;
- migrate the independent `proveEqual` ladder in
  `WaveAMDMemoryTransactionProvider.cpp`;
- keep activation policy, packet-condition identity, and transaction adjacency
  decisions in Wave.

### Tests

- disjoint and overlapping XOR operands;
- masks above bit 63 remain unknown rather than truncated proofs;
- congruence through Add/Mul and exact substitution;
- reordered AND/OR predicates compare equivalent;
- numeric `x & 7` and `x | y` are rejected as predicate queries;
- equivalent Mod predicates compare equal;
- pointer-equal and algebraically equal reciprocals remain unknown when zero is
  possible;
- `x == 0` is not inferred from `x == 0 (mod 16)`;
- a residual delta divisible by 16 does not make arbitrary comparisons
  equivalent;
- non-equivalent predicates remain unknown/false as appropriate;
- contradictory facts never prove arbitrary equivalence.

## Gap 6: Range Propagation

### Audit-baseline behavior (`d7e536d`)

`ixs_range` propagates through Add, Mul factors with exponent `-1` or `1`, Mod,
floor, ceiling, Min, Max, and constant-mask AND. It does not propagate ranges
through:

- positive powers other than one;
- negative powers below minus one;
- XOR;
- Piecewise.

Wave supplies U32-only fallbacks for powers, XOR, and Piecewise. Generic range
semantics should not be tied to U32 address selection.

### Positive-power example

```text
facts: 0 <= x <= 15
expr: x**2
range: [0, 225]
```

Handle parity and sign:

```text
-3 <= x <= 5, x**2 -> [0, 25]
-5 <= x <= -3, x**3 -> [-125, -27]
```

Use checked rational arithmetic and widen endpoints on overflow. Exponentiation
by squaring avoids a linear loop for large exponents. Preserve the existing
expression-domain exponent cap where required.

### Negative-power example

```text
2 <= x <= 4, x**-2   -> [1/16, 1/4]
-4 <= x <= -2, x**-3 -> [-1/8, -1/64]
-1 <= x <= 1, x**-2  -> unknown; zero is reachable
```

Compute the corresponding positive power, then take its reciprocal only when
the interval excludes zero. The range API has no possibly-undefined result, so
a reachable zero makes the propagated range unknown.

### XOR example

```text
facts: 0 <= a <= 15, 0 <= b <= 15
expr: xor(a, b)
range: [0, 15]
```

Use known bits and nonnegativity. If sign or high bits are unknown, return an
unbounded/unknown side rather than treating ixsimpl as a fixed-width solver.

### Piecewise example

```text
facts: 0 <= x <= 31
expr: Piecewise((x, x < 16), (31 - x, True))
range: [0, 15]
```

Fork facts per effective first-match branch, infer each reachable value range,
and take the hull. Ignore proven-dead branches. If coverage is not proven,
return unknown unless the API explicitly represents a possibly undefined
range.

### Action

Extend `bounds_get_propagated` with general supported integer powers, XOR, and
Piecewise. Keep
`provablyFitsU32` as Wave policy, but implement it from core ranges and known
bits. `positiveAddendsFitU32` remains Wave policy because it constrains the
chosen evaluation order rather than the mathematical result alone.

### Tests

- sign/parity cases for powers;
- reciprocal powers below minus one, including zero crossing;
- large exponent and endpoint overflow widening;
- XOR from exact, interval, and known-bit facts;
- Piecewise reachability, first-match behavior, default coverage, and hulls;
- property tests comparing every inferred bound against numerical evaluation;
- no regression in existing Mod and rational-range soundness tests.

## Gap 7: Affine Differences and Correlated Bounds

### Audit-baseline behavior (`d7e536d`)

ixsimpl stores expression range facts under raw and expanded aliases. This
already handles spelling differences such as:

```text
2*(A + 8*B) == 2*A + 16*B
```

It intentionally does not solve general cross-variable relations such as
`x < K`.

At the audit baseline, Wave performed local affine work:

- canonicalizes a query target and comparison residuals together;
- subtracts them and accepts constant deltas;
- substitutes `iv + step`, subtracts the original expression, and expects a
  loop-invariant finite difference;
- manually matches `scale*Mod(iv + constant, modulus) + base`.

These are bounded algebraic decompositions, not general relational solving.
`buildStrideExpr` now uses `Analysis::finiteDifference`; the other address and
predicate ladders above remain migration work.

### Action

Add narrow helpers:

```c
bool ixs_constant_difference_facts(
    ixs_facts *facts, ixs_node *lhs, ixs_node *rhs, int64_t *delta);

bool ixs_affine_decompose_facts(
    ixs_facts *facts, ixs_node *expr, ixs_node *symbol,
    ixs_node **coefficient, ixs_node **residual);

bool ixs_finite_difference_facts(
    ixs_facts *facts, ixs_node *expr, ixs_node *symbol,
    ixs_node *step, ixs_node **difference);

bool ixs_split_additive_constant_facts(
    ixs_facts *facts, ixs_node *expr,
    ixs_node **residual, int64_t *constant);
```

Each helper is sufficient and conservative:

- simplify and expand in one shared fact context;
- require the returned coefficient/delta to be exact;
- reject symbol references in both coefficient and residual for affine
  decomposition;
- return false on unknown, nonlinear dependence, domain uncertainty, or
  overflow.

### Examples

```text
constant_difference(4*x + 4, 4*x + 1) -> 3
affine_decompose(8*i + base, i)        -> coefficient 8, residual base
affine_decompose(i*i, i)               -> false
affine_decompose(Mod(i, 8), i)         -> false
finite_difference(i*i, i, 1)          -> 2*i + 1, not loop invariant
finite_difference(8*i + base, i, 1)   -> 8
split_additive_constant(base + 96)     -> residual base, constant 96
```

### Scope of `f(x + N) - f(x) == N`

The exact identity is not a complete replacement for any audited Wave proof
family. `finiteDifference` returns normalized `f(x + N) - f(x)` only after
proving `f(x)`, `N`, and `f(x + N)` defined. It proves neither equality with an
expected stride nor loop invariance. Those require `equivalent(diff,
expected)` and Wave's `bindLiveExpr` check. Most callers need an expected
physical stride other than `N`.

| Wave family | Correct core query | Replacement scope |
|---|---|---|
| Loop stride construction | `finiteDifference(f, iv, loopStep)` | Fully replaces substitute/add/subtract/expand/simplify; `bindLiveExpr` rejects an IV-dependent result |
| Cyclic pointer carry | None | Keep ring shape, wrap point, power-of-two legality, and update materialization in Wave |
| Specialized slot adjacency | `constantDifference(rhs, lhs) == elementBits`, plus base/block equivalence | Replaces direct equality algebra; remainder fallback stays Wave-owned |
| Remainder successor | Constant difference for dividends; equivalence for divisor/residual | Replaces equality subproofs only; sign, definedness, modular grid, and SSA projection stay local |
| Coalescing address delta | `constantDifference` after binding and fact remap | Replaces delta construction; parameterizing two existing addresses as one `f(x)` adds no value |
| Activation comparison residuals | Constant difference plus total predicate equivalence | Moves delta extraction; aligned-grid policy stays local |
| Point dedup, projection invariance, Redistribute, transaction grammar | Total equivalence | No finite-difference role |
| Sparse address grouping | `splitAdditiveConstant` | No finite-difference role |

Two conditional fast paths remain plausible:

- before slot specialization, test
  `finiteDifference(bitOffset, slot, 1) == elementBits` when packet bindings and
  activation are slot-invariant;
- before per-lane transaction enumeration, test
  `finiteDifference(expr, lane, 1) == 0`, then separately prove domain
  coverage.

Concrete cases:

```text
f(x) = base + x,       N = 4  -> difference 4       step-preserving proof
f(x) = base + 8*x,     N = 4  -> difference 32      valid stride; `== N` rejects
f(x) = x*x,            N = 1  -> difference 2*x+1   not loop invariant
f(x) = x + Mod(x, 4),  N = 4  -> difference 4       passes only this step
f(x) = Mod(x, 8),      N = 1  -> 1 or -7            cyclic carry policy still needed
```

The fourth case admits an `N`-periodic component. Do not promote a fixed-step
proof to a global affine fact. Other constraints:

- `N` must not contain `x`; `N == 0` makes the identity vacuous;
- expected strides use element, byte, or bit units and usually differ from
  the loop step;
- symbolic expected strides need total equivalence, not literal comparison;
- success may return an IV-dependent result such as `2*x + 1`;
- facts must describe iterations with a successor; exclude terminal iterations
  with no successor or partial `f(x + N)` fails conservatively;
- the result must be integer-valued and materializable as an index;
- definedness must hold at `x` and `x + N`; `Mod` needs a positive divisor;
- fixed-width no-wrap remains a separate Wave proof;
- `constantDifference(lhs, rhs)` returns `lhs - rhs`, so direction matters.

Coverage count:

- exact `difference == N`: zero production callers and zero complete audited
  families;
- general finite difference: one production caller (`buildStrideExpr`) and two
  optional fast paths;
- total Wave symbolic lowering: below 10%, because constant difference,
  equivalence, ranges, divisibility, SSA, memory policy, fixed-width legality,
  and materialization remain separate.

`buildStrideExpr` now calls `Analysis::finiteDifference` and requires the
result to be provably integer-valued. `reject_fractional_stride` covers the
`i/2` case: finite difference `1/2` must not become an index carry. Address and
adjacency migrations need fact/binding unification first.

Core regressions should also cover `x + Mod(x, 4)` at steps four and one, an
`x`-free symbolic step, the vacuous zero step, and a successor crossing a
partial-operator domain boundary. The step-four result is four; step one must
not be promoted to a step-preserving identity.

`WaveExtractLoopStrides` keeps the rule that only a legal, profitable pointer
carry is formed. It delegates only the decomposition.

`canonicalizeAddressExpr` and `splitAddressConstant` in sparse symbolic-memory
grouping become `split_additive_constant_facts` calls. Group construction and
profitability stay in Wave.

Coalescing needs more than a new query. `computeMemoryAddressDelta` currently
remaps RHS bindings and simplifies the delta with no assumptions. It must
remap and combine both addresses' assumptions first. Regression shape:

```text
left:  expression x,       fact x == 4*i
right: expression 4*j + 1, binding j -> i
result: right - left == 1
```

The coalescer may group the pair only after the combined fact context proves
that delta. Contradictory or unbound assumptions keep the accesses separate.

Do not extend this work into a general polyhedral or SMT domain. Existing
ixsimpl tracker work on symbolic denominators and relational Mod proofs covers
specific sufficient rules instead.

## Gap 8: Predicate Expansion and Rational Endpoints

### Predicate expansion

`ixs_expand` already recurses through comparisons, AND, OR, NOT, and Piecewise
conditions. `Analysis::expand(PredHandle)` now exposes that core path. The
remaining manual caller is `expandIndexExprPredicate` in `Wave.cpp`; migrate
its proof batch to `Analysis`, then delete the recursive rebuild.

An isolated-call wrapper is optional:

```c++
FailureOr<PredHandle> expandPred(Store &store, PredHandle pred,
                                 std::string *diagnostic = nullptr);
```

No new ixsimpl solver feature is required.

### Predicate scaling

`WaveSymbols::scalePred` recursively scales comparison operands. It is used to
manufacture duplicate assumptions for pointer and machine lowering. Prefer to
remove those calls once affine correlation recognizes the unscaled facts. If a
caller still needs the transform, move it behind a core API with an explicit
positive scale. Negative scales must reverse ordered comparisons; zero is not
a semantics-preserving scaling operation.

### Rational endpoints

Wave independently implements floor, ceiling, and compare-to-integer helpers
in IR range models, pointer passes, div/rem lowering, and WaveAMDMachine.

Add one checked interface, either in ixsimpl or `WaveSymbols`:

```c++
std::optional<int64_t> floorEndpoint(RationalEndpoint value);
std::optional<int64_t> ceilEndpoint(RationalEndpoint value);
int compareEndpointToInteger(RationalEndpoint value, int64_t integer);
```

Comparison must use widened arithmetic. In particular, replace direct
`lower * denominator` calculations in `WaveExpandIntegerDivRem`.

Callers must choose rounding direction explicitly:

- enclosing a mathematical range: floor lower, ceil upper;
- restricting an integer-valued range: ceil lower, floor upper.

One generic `toIntegerRange` helper without a rounding mode is too easy to use
incorrectly.

## Gap 9: Fact Transfer and Binding Parity

Core status: landed in `d4172db`. C, C++, and Python expose simultaneous fact
substitution. The amalgamation is current. `ixs_import_many` already covers
batch structural import.

Example multi-substitution:

```text
facts: 0 <= x < 16, Mod(y, 8) == 0
subs:  x -> lane, y -> 2*K
```

The destination carries the range for `lane`; from `8 | y` and `y -> 2*K` it
derives `4 | K`, never `8 | K`. Integer-affine replacements invert exact
ranges, reduce congruences by the scale GCD, transfer a known-low-bit prefix as
congruence, and transfer power-of-two only for a positive power-of-two scale
with zero offset. Unsupported nonlinear replacements retain facts on the full
replacement expression but do not guess a symbol record.

Substitutions are simultaneous: replacement expressions are not recursively
rewritten through one another, and the first duplicate target wins. Wave's
remaining gap is binding provenance: remap expression handles and both sides'
facts in one `Analysis`, then reject any predicate whose symbols no longer have
SSA bindings. That lifetime policy stays in Wave.

## Fixed-Width Boundary

Do not add bitvector semantics to ixsimpl merely to absorb Wave or wavec code.

ixsimpl currently models:

- unbounded mathematical values;
- exact rational coefficients;
- exact rational division, with floored division represented explicitly as
  `floor(a/b)`;
- Mod tied to floor semantics, subject to the divisor-contract fix in Gap 4;
- a finite low-64-bit known-bit abstraction used only for sufficient proofs.

Wave and wavec additionally need:

- declared bit widths;
- signed and unsigned comparison;
- truncation and extension;
- wrapping Add/Mul/shift behavior;
- `nsw`/`nuw` legality;
- C truncating signed division and remainder;
- target instruction encoding constraints.

Keep `IntegerRangeAnalysis` and `APInt` reasoning in:

- `Wave.cpp` range inference;
- `WaveGenerateIndexExprs.cpp`;
- `WaveExtractLoopStrides.cpp` no-wrap checks;
- `WaveExpandIntegerDivRem.cpp`;
- `WaveAMDNarrowWideInt.cpp`;
- `WaveAMDFormFusedInt.cpp`;
- wavec lowering.

A separate typed bitvector layer may be justified later. It is not part of
this migration.

## Implemented Wave Facade

`WaveSymbols` remains the only raw `ixs_*` boundary in Wave C++.

Current shape, omitting diagnostic parameters:

```c++
class Analysis {
public:
  static FailureOr<std::unique_ptr<Analysis>>
  create(Store &store, ArrayRef<PredHandle> assumptions);

  LogicalResult assume(PredHandle value);
  LogicalResult assumeRange(ExprHandle value, InferredRange range);
  LogicalResult deriveAffine(ExprHandle base, int64_t scale, int64_t offset,
                             ExprHandle derived);
  LogicalResult substituteFacts(ArrayRef<ExprSubstitution> substitutions);

  FailureOr<ExprHandle> compose(ExprHandle lhs, ExprBinaryOp op,
                                ExprHandle rhs);
  FailureOr<ExprHandle> composeCeil(ExprHandle value);
  FailureOr<ExprHandle> composeFloor(ExprHandle value);
  FailureOr<ExprHandle> composeNeg(ExprHandle value);
  FailureOr<ExprHandle> composeSymbol(StringRef name);
  FailureOr<ExprHandle> composeInteger(int64_t value);
  FailureOr<ExprHandle> composePiecewise(ArrayRef<PiecewiseCase> cases);
  FailureOr<PredHandle> composeTrue();
  FailureOr<PredHandle> composeFalse();
  FailureOr<PredHandle> compare(ExprHandle lhs, PredCmpOp op,
                                ExprHandle rhs);
  FailureOr<PredHandle> composeAnd(PredHandle lhs, PredHandle rhs);
  FailureOr<PredHandle> composeOr(PredHandle lhs, PredHandle rhs);
  FailureOr<PredHandle> composeNot(PredHandle value);
  FailureOr<ExprHandle>
    substitute(ExprHandle value, ArrayRef<ExprSubstitution> substitutions);
  FailureOr<PredHandle>
    substitute(PredHandle value, ArrayRef<ExprSubstitution> substitutions);

  FailureOr<ExprHandle> simplify(ExprHandle value);
  FailureOr<PredHandle> simplify(PredHandle value);
  LogicalResult simplify(MutableArrayRef<ExprHandle> values);
  FailureOr<ExprHandle> expand(ExprHandle value);
  FailureOr<PredHandle> expand(PredHandle value);

  CheckResult check(PredHandle value);
  CheckResult equivalent(ExprHandle lhs, ExprHandle rhs);
  CheckResult equivalent(PredHandle lhs, PredHandle rhs);
  CheckResult defined(ExprHandle value);
  CheckResult defined(PredHandle value);
  CheckResult integerValued(ExprHandle value);
  CheckResult divisible(ExprHandle value, int64_t modulus);
  CheckResult congruent(ExprHandle value, int64_t modulus, int64_t residue);
  ExactDivideResult tryExactDivide(ExprHandle value, int64_t divisor);
  Pow2Fact getPow2Fact(ExprHandle value);
  std::optional<KnownBits> getKnownBits(ExprHandle value);
  std::optional<Congruence> getSymbolCongruence(ExprHandle symbol);

  std::optional<InferredRange> range(ExprHandle value);
  std::optional<int64_t> constantDifference(ExprHandle lhs, ExprHandle rhs);
  std::optional<AffineDecomposition> affineDecompose(ExprHandle value,
                                                     ExprHandle symbol);
  std::optional<ExprHandle> finiteDifference(ExprHandle value,
                                             ExprHandle symbol,
                                             ExprHandle step);
  std::optional<SplitAdditiveConstant>
    splitAdditiveConstant(ExprHandle value);
};
```

Keep ephemeral convenience wrappers for isolated queries. Implementation must
not duplicate solver logic or reopen a session from inside `Analysis`. Factory
and fact mutators are fallible; a failed mutator leaves the object unable to
prove anything.

Callers then read as policy:

```c++
FailureOr<std::unique_ptr<sym::Analysis>> analysis =
    sym::Analysis::create(store, assumptions);
if (failed(analysis))
  return failure();
if ((*analysis)->defined(offset) != sym::CheckResult::True)
  return failure();
if ((*analysis)->integerValued(offset) != sym::CheckResult::True)
  return failure();
if ((*analysis)->equivalent(next, expected) != sym::CheckResult::True)
  return failure();
```

## Migration Plan

### Phase 0: Freeze behavior

Add failing tests before changing APIs:

- compound AND legacy-array ingestion;
- negative-power integrality;
- fact-aware `K/32` integrality;
- Mod divisor-contract consistency;
- definedness and Piecewise coverage;
- positive and reciprocal-power, XOR, and Piecewise ranges;
- modular predicate equivalence;
- total-domain equivalence for reciprocal expressions;
- assumption-backed coalescing deltas;
- current Wave exact-byte-division and remainder-adjacency cases.

Capture current transform output for:

- `test/Dialect/Wave/lower-symbolic-memory.mlir`;
- `test/Dialect/Wave/lower-symbolic-memory-invalid.mlir`;
- `test/Dialect/Wave/lower-symbolic-memory-transpose.mlir`;
- `test/Dialect/Wave/simplify-index-exprs.mlir`;
- `test/Dialect/Wave/extract-loop-strides.mlir`;
- `test/Target/Wave/waveamdmachine-index-expr.mlir`;
- `test/Target/Wave/waveamdmachine-select-invalid.mlir`;
- `test/Target/Wave/waveamdmachine-extracted-loop-strides.mlir`.

### Phase 1: Core correctness APIs

Land separate ixsimpl commits for:

1. align the Mod divisor contract, implementation, and tests;
2. compound assumption ingestion;
3. public structural/fact-aware integrality and divisibility;
4. definedness;
5. fact-backed simplify.

Regenerate the amalgamation and Python stubs in each logical commit. Run C,
Python, property, serialization, and import tests.

### Phase 2: Wave fact context

Add `sym::Analysis`, migrate facade implementations, and delete:

- `flattenAssumption`;
- recursive `provablyDefined`;
- legality use of `collectDenominator`;
- repeated fact construction within one proof batch.

Construction, assumption ingestion, range import, and substitution must all be
failure-atomic. No transform semantics should change in this phase.

### Phase 3: Remove the duplicate symbolic-memory solver

Export known bits, congruence, and equivalence. Migrate in small commits:

1. exact byte division;
2. disjoint XOR linearization;
3. expression equality;
4. modular activation equivalence;
5. remainder adjacency subproofs.

Then migrate the equality ladders in `WaveLowerRedistribute.cpp` and
`WaveAMDMemoryTransactionProvider.cpp` without moving their domain policy.

Keep transaction grouping and `RemainderProofContext` structure intact until
all proof substitutions have dedicated regression coverage.

### Phase 4: Range and affine cleanup

Add power/XOR/Piecewise ranges and affine helpers. Then migrate:

- U32 bound recursion;
- pointer carry finite differences;
- cyclic offset decomposition;
- assumption-backed address deltas used by coalescing;
- sparse-address additive-constant splitting;
- repeated rational endpoint code;
- small machine-side constant evaluators.

Delete both recursive machine nonnegativity copies in
`WaveAMDMachineIndexExpr.cpp` and
`lib/Dialect/Wave/Transforms/WaveAMDMachine.cpp`; use a range or `expr >= 0`
query through `Analysis`.

### Phase 5: Python integration cleanup

Introduce the Python bound-expression builder helper. Convert CTA remapping,
DMA state/offsets, MXFP4 K-step, epilogue offsets, and pipeline state in
separate commits after classifying every range annotation by provenance.

Independently replace the SSA `IndexExpr` sugar and its sole MMA-grid consumer;
this has no facts-API prerequisite. Validate `test/python/dialects/wave.py`,
`test/python/dialects/wave_matmul.py`,
`test/python/dialects/wave_matmul_dma.py`, and
`test/python/dialects/wave_attention.py`, plus both coalesced and non-coalesced
MMA-grid IR shapes.

### Phase 6: Measure

Measure:

- `IndexExprOp::inferResultRanges` wall time;
- `wave::sym::inferRange` wall time;
- bounds/fact builds per translation;
- simplify/check/range queries per fact set;
- peak expression-store and scratch memory;
- full translation wall time for the slow A4W4 MXFP4 case;
- ASM and runtime performance for affected PerfGolden kernels.

ASM drift is a review stop. It requires same-hardware benchmarking before a
golden update.

## Commit and Validation Boundaries

Keep commits focused:

1. ixsimpl contract/test;
2. ixsimpl implementation/API;
3. binding/amalgamation update;
4. Wave facade import;
5. one Wave proof-family migration;
6. dead-code deletion.

For each Wave migration:

```bash
cmake --build build --target check-wave-mlir -j $(nproc)
cmake --build build --target check-wavec -j $(nproc)
build/bin/llvm-lit -sv build/test/Integration
```

When ASM can drift:

```bash
build/bin/llvm-lit -sv build/test --filter='PerfGolden'
```

For ixsimpl changes, run its C and Python suites in the standalone checkout
before updating the Wave submodule.

## Tracker Mapping

Relevant ixsimpl issues live in the ixsimpl checkout tracker, not the Wave
tracker:

| Issue | Overlap |
|---|---|
| `4-3ay` | symbolic-denominator and floor correlation |
| `4-xr1c` | remaining relational symbolic-Mod proof |
| `4-bev` | interval/congruence intersection |
| `4-1p9q` | Mod-difference divisibility |
| `4-1kb` | batch common-subexpression lifting |

`4-2jz` is closed: contextual Piecewise substitution landed. `4-sw9` is
closed and superseded by `4-1kb`; mutable flags on interned nodes are unsafe
across fact contexts.

Wave issue `7-gifn` covers commutative materialization order and range-aware
grouping after symbolic reasoning. It does not cover the core proof gaps.

Core contract/API items above landed between `274e93d` and `56a3f9d`.
Remaining tracker coverage:

- `collectDenominator` still decides Redistribute legality in `Wave.cpp`, and
  `divideCoefficientsExactly` still handles symbolic-memory byte division;
- `possibleOneBits` and `linearizeDisjointXors` still duplicate core known-bit
  and equivalence work in `WaveLowerSymbolicMemory.cpp`;
- legacy `proveEqual` ladders remain in symbolic memory, Redistribute, and the
  memory-transaction provider; migrated Analysis callers use total
  equivalence only;
- `canonicalizeAddressExpr` and `splitAddressConstant` still implement sparse
  decomposition instead of `splitAdditiveConstant`;
- `expandIndexExprPredicate` still rebuilds predicate trees in `Wave.cpp`;
- coalescing still needs simultaneous fact and binding transfer before proving
  cross-address deltas;
- Python builder/fact provenance cleanup remains.

Create one epic with separate ixsimpl and Wave children. Do not combine core
API work, submodule update, and Wave migration in one bead or commit.

## Completion Criteria

Migration is complete when:

- Wave contains no generic recursive definedness, integrality, known-bit,
  congruence, or predicate-equivalence solver;
- `collectDenominator` is not used for legality;
- the public header, design, constructors, simplifier, ranges, and definedness
  agree on the Mod divisor domain;
- compound assumptions have one documented core ingestion path;
- rejected or failed fact ingestion cannot weaken a proof context silently;
- related Wave queries reuse a scoped fact set;
- `WaveLowerSymbolicMemory` expresses memory policy using core proof queries;
- coalescing remaps and combines both addresses' assumptions before proving a
  delta;
- fixed-width and target reasoning remain in Wave;
- Python-to-Wave symbolic data stays structural;
- ixsimpl C, Python, property, import, and serialization tests pass;
- Wave MLIR, wavec, Integration, and affected PerfGolden tests pass;
- translation-time measurements show no regression;
- any ASM drift has same-hardware benchmark evidence.
