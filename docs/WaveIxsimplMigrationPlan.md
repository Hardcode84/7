# Wave Symbolic Reasoning and ixsimpl Migration

## Status

This document audits symbolic reasoning in Wave lowering and defines which
parts belong in ixsimpl.

Audit baseline:

- Wave: `01f668ad2bca39a657ac907dc513992f2a89fc7c`
- vendored ixsimpl: `d7e536dd2fbe61dcea5ea727ebcfa45142f38791`
- audit date: 2026-07-22

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

The priority order is:

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
| Batch simplification with one assumption array | Complete |
| Comparison entailment | Complete for normalized CMP queries |
| Rational interval range | Complete for supported propagation rules |
| Power-of-two facts | Public |
| Mutable fact sets | Public and session-owned |
| Explicit expression ranges | Public through fact sets |
| Affine range derivation | Public through fact sets |
| Fact substitution | Public for one target/replacement |
| Symbol congruence | Implemented internally; full modulus/remainder query is symbol-only |
| Arbitrary-expression divisibility | Implemented internally |
| Low-64-bit known bits | Implemented internally |
| Fact-aware integrality | Implemented internally |
| Predicate-tree expansion | Implemented internally by `ixs_expand` |

Current fact sets accept conjunctions, explicit ranges, affine derivation, and
substitution. They support `check`, `range`, and power-of-two queries. They do
not support fact-backed simplification, public integrality/divisibility, public
known bits, or general predicate equivalence.

## Decision Matrix

| Priority | Core work | Wave result |
|---|---|---|
| P0 | Compound assumption ingestion | Delete `flattenAssumption`. |
| P0 | Public integrality, divisibility, and exact quotient | Stop using `collectDenominator` for legality; delete local exact division. |
| P0 | Resolve Mod contract and add definedness | Delete recursive `provablyDefined`. |
| P0 | Fact-backed simplification and a reusable fact context | One fact build per proof batch; no nested Store sessions. |
| P1 | Known bits, query-specific congruence, total equivalence | Delete possible-bit, modular-equivalence, and `proveEqual` ladders. |
| P1 | Integer-power, XOR, and Piecewise ranges | Delete generic U32 range recursion; keep U32 target policy. |
| P1 | Constant difference, affine decomposition, finite difference | Delete local delta, stride, and additive-constant algebra. |
| P2 | Predicate facade and rational endpoint helpers | Delete predicate rebuilding and repeated endpoint arithmetic. |
| P2 | Multi-substitution transfer and Python fact provenance | Simplify builders without transporting opaque fact objects. |

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

### Current behavior

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

### Current behavior

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
object is live must go through session-aware methods on `Analysis`. Calling
existing Store-level facade functions would open a nested session and
deadlock. Alternatively, construct every query node before creating the
analysis object; this is too restrictive for symbolic-memory proof code and is
not the preferred contract. The sketch shows representative builders;
implementation needs session-aware equivalents for every compose and
expression/predicate substitution operation used by migrated callers.

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

## Gap 3: Integrality, Divisibility, and Exact Quotients

### Current behavior

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

### Current behavior

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

### Current behavior

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

### Current behavior

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

### Current behavior

ixsimpl stores expression range facts under raw and expanded aliases. This
already handles spelling differences such as:

```text
2*(A + 8*B) == 2*A + 16*B
```

It intentionally does not solve general cross-variable relations such as
`x < K`.

Wave still performs local affine work:

- canonicalizes a query target and comparison residuals together;
- subtracts them and accepts constant deltas;
- substitutes `iv + step`, subtracts the original expression, and expects a
  loop-invariant finite difference;
- manually matches `scale*Mod(iv + constant, modulus) + base`.

These are bounded algebraic decompositions, not general relational solving.

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
conditions. Wave manually rebuilds predicate trees because its facade exposes
only `expandExpr`.

Add:

```c++
FailureOr<PredHandle> expandPred(Store &store, PredHandle pred,
                                 std::string *diagnostic = nullptr);
```

This is a Wave facade gap, not a new ixsimpl solver feature. Delete
`expandIndexExprPredicate` from `Wave.cpp` afterward.

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

Lower-priority API gaps:

- simultaneous multi-target fact substitution matching `ixs_subs_multi`;
- sound transfer of congruence and bit facts through nontrivial replacements;
- const-correct read-only node introspection;
- Python and C++ bindings for every new public C API;
- regenerated `ixsimpl_amalg.c` after public API changes;
- optional batch structural import if profiling shows import overhead.

Example multi-substitution:

```text
facts: 0 <= x < 16, Mod(y, 8) == 0
subs:  x -> lane, y -> 2*K
```

Current single-target substitution preserves stored modulus, known-bit, and
power-of-two records. It does not invert those facts through a replacement.
The destination should carry the range for `lane`; from `8 | y` and `y -> 2*K`
it may derive `4 | K`, never `8 | K`. That inverse-congruence rule is new work,
not record preservation. Simultaneous semantics also matter: replacement
expressions are not recursively substituted into one another.

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

## Proposed Wave Facade After Migration

`WaveSymbols` remains the only raw `ixs_*` boundary in Wave C++.

Proposed shape:

```c++
class Analysis {
public:
  static FailureOr<std::unique_ptr<Analysis>>
  create(Store &store, ArrayRef<PredHandle> assumptions);

  LogicalResult assume(PredHandle value);
  LogicalResult assumeRange(ExprHandle value, InferredRange range);
  LogicalResult deriveAffine(ExprHandle base, int64_t scale, int64_t offset,
                             ExprHandle derived);

  FailureOr<ExprHandle> compose(ExprHandle lhs, ExprBinaryOp op,
                                ExprHandle rhs);
  FailureOr<PredHandle> compare(ExprHandle lhs, PredCmpOp op,
                                ExprHandle rhs);
  FailureOr<ExprHandle>
  substitute(ExprHandle value, ArrayRef<ExprSubstitution> substitutions);

  FailureOr<ExprHandle> simplify(ExprHandle value);
  FailureOr<PredHandle> simplify(PredHandle value);
  FailureOr<ExprHandle> expand(ExprHandle value);
  FailureOr<PredHandle> expand(PredHandle value);

  CheckResult check(PredHandle value);
  CheckResult equivalent(ExprHandle lhs, ExprHandle rhs);
  CheckResult equivalent(PredHandle lhs, PredHandle rhs);
  CheckResult defined(ExprHandle value);
  CheckResult integerValued(ExprHandle value);
  CheckResult divisible(ExprHandle value, int64_t modulus);

  std::optional<InferredRange> range(ExprHandle value);
  std::optional<KnownBits> knownBits(ExprHandle value);
  ExactDivideResult exactDivide(ExprHandle value, int64_t divisor);
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
| `4-2jz` | contextual Piecewise substitution |
| `4-1kb` | batch common-subexpression lifting |
| `4-sw9` | fixed-point simplification skip |

Wave issue `7-gifn` covers commutative materialization order and range-aware
grouping after symbolic reasoning. It does not cover the core proof gaps.

Missing tracker coverage:

- compound assumption contract parity;
- Mod divisor-contract consistency;
- public integrality/divisibility and exact quotient;
- definedness;
- public known bits and query-specific congruence;
- fact-backed simplify/equivalence;
- integer-power, XOR, and Piecewise ranges;
- fact transfer through nontrivial substitutions;
- Wave scoped analysis/fact reuse;
- assumption-backed coalescing and sparse-address decomposition;
- Python builder/fact provenance cleanup;
- deletion of the duplicate symbolic-memory solver.

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
