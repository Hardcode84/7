# Wave Symbolic Reasoning

## Scope

Wave uses ixsimpl for mathematical expressions and proofs. Wave owns the IR
meaning around those expressions.

The boundary is semantic:

> Reusable algebra belongs in ixsimpl. SSA, fixed-width arithmetic, execution,
> memory, and target policy belong in Wave.

An expression containing only symbols and integers does not automatically
belong in ixsimpl. A rule about workitems, dominance, wrapping `i32`, memory
tokens, or AMD address fields stays in Wave even when its implementation asks
ixsimpl questions.

`WaveSymbols` is Wave's only raw ixsimpl boundary. Transforms use typed handles
and `sym::Analysis`; they do not call `ixs_*` or implement expression-domain
solvers.

## Ownership

| Layer | Owns |
|---|---|
| ixsimpl | Expression construction, canonicalization, substitution, expansion, ranges, definedness, integrality, divisibility, exact quotients, known bits, congruence, equivalence, finite differences, affine decomposition |
| `WaveSymbols` | Store lifetime, typed handles, structural import, diagnostics, conservative result translation, scoped `Analysis`, target-facing query wrappers |
| Wave passes | SSA bindings, dominance, fact lifetime, lane classification, loop and workitem projection, fixed-width legality, memory ordering, transaction policy, materialization |
| Python DSL | Structural expression construction, symbol-to-SSA bindings, structural assumptions, kernel and layout policy |
| WaveMeta | Parameter specialization, tuple width and index resolution, specialization order |

Expression walking in Wave is valid when the walk interprets IR or target
policy. Examples include collecting bound names, discovering workitem periods,
or emitting machine operations. Walking an expression to prove equality,
divisibility, a range, or known bits is an ixsimpl responsibility.

## Data Model

`WaveDialect` owns one `sym::Store`. Nodes are immutable and hash-consed in
that store. `ExprHandle` and `PredHandle` remain valid while the store lives.

Python imports live in-process nodes with `get_from_node_ptr`.
`get_from_bytes` accepts stable ixsimpl serialization for durable or
cross-context data. Text constructors serve assembly and human-authored tool
inputs; production lowering never prints and reparses a node. C++ uses typed
node import and deserialization APIs.

```text
Python ixsimpl node
        |
        | structural import
        v
Wave sym::Store ---- wave.expr / wave.pred attributes
        |
        v
wave.index_expr + SSA bindings + assumptions
        |
        +--> symbolic memory and redistribution
        +--> pointer and loop transforms
        `--> WaveAMDMachine selection
```

ixsimpl models exact integers and rationals. It has no implicit MLIR type,
lane width, address space, dominance relation, or memory effect.

## Analysis Lifetime

`sym::Analysis` owns one ixsimpl session and one fact set. It holds the store
lock for its lifetime. Scope it to one related proof batch.

```cpp
FailureOr<std::unique_ptr<sym::Analysis>> created =
    sym::Analysis::create(store, assumptions);
if (failed(created))
  return failure();
sym::Analysis &analysis = **created;

FailureOr<sym::ExprHandle> rewritten =
    analysis.substitute(expr, substitutions);
if (failed(rewritten))
  return failure();
return analysis.simplify(*rewritten);
```

Use `analysis.compose*`, `analysis.substitute`, `analysis.expand`, and
`analysis.simplify` while an analysis is live. A store-level convenience
function opens a separate session and cannot reuse the analysis fact set. Keep
one related proof batch on its analysis.

Keep handles after destroying an analysis. Do not keep its facts.

Fact construction is atomic. A failed mutator poisons fact-backed queries;
structural builders remain usable. Discard the analysis for proof work rather
than continue with a silently weaker fact set.

`Analysis::create` closes predicates in input order. Later roots can use facts
from earlier roots. `Analysis::createDirect` imports one exact domain without
that closure. Use it only when derived predicates enter through `assume`.

## Fact Contract

An assumption root is one of:

- a comparison;
- canonical true or false;
- an `AND` tree whose leaves satisfy this contract.

Unsupported boolean shapes are rejected. They are not filtered leaf by leaf.

Default construction and batch mutation validate every root before exposing
the fact set, then simplify and ingest roots in input order. Later predicates
therefore see facts established by earlier predicates. Direct construction
validates and imports roots without inter-predicate closure. Any rejection or
allocation failure discards the candidate; mutation failure also poisons the
analysis.

`CheckResult::Unknown` means no proof. It does not mean false. Legality paths
accept only `True`; profitability paths may choose a conservative fallback.
A detected contradictory domain also produces no usable proof. Detection is
best-effort; callers must supply consistent assumptions.

Facts describe mathematical expressions. Wave decides whether a fact is live
at an operation. That decision uses SSA dominance, region structure, operation
semantics, and binding identity.

Attached `wave.index_expr` predicates are IR metadata. During metadata cleanup,
trusted SSA-derived binding facts can mark an attached predicate stale; Wave
drops it before building the retained fact domain. Wave also drops predicates
whose symbols disappear during simplification. This is metadata salvage, not
assumption filtering inside `Analysis`: ixsimpl proves predicate truth under
current facts, while Wave owns metadata trust and lifetime.

### Fact transfer

Renaming a symbolic expression requires renaming its facts with the same
simultaneous substitution.

```cpp
if (failed(analysis.substituteFacts(substitutions)))
  return failure();
FailureOr<sym::ExprHandle> rewritten =
    analysis.substitute(expr, substitutions);
if (failed(rewritten))
  return failure();
return analysis.simplify(*rewritten);
```

When destination assumptions are built before the destination analysis:

1. Substitute every predicate structurally.
2. Reject any predicate whose symbols lack destination SSA bindings.
3. Create one analysis from all destination predicates.
4. Substitute and simplify the expression in that analysis.

Substitution is simultaneous. Replacements are not substituted through one
another. This matters for swaps and chained renames.

Use `assumeRange` only when an external MLIR analysis proves a range for the
exact expression. Use `deriveAffine` only for an exact relation
`derived = scale * base + offset`.

## Query Selection

| Need | Query |
|---|---|
| Canonical expression under facts | `simplify` |
| Several roots sharing facts and DAG nodes | batch `simplify` |
| Predicate truth | `check` |
| Total expression or predicate equality | `equivalent` |
| Domain safety | `defined` |
| Integer-valued result | `integerValued` |
| Inclusive rational bounds | `range` |
| Divisibility | `divisible` |
| Exact quotient construction | `tryExactDivide` |
| Power-of-two classification | `getPow2Fact` |
| Low-bit facts | `getKnownBits` |
| Modular relation | `congruent` |
| Symbol modulus and residue | `getSymbolCongruence` |
| Constant `lhs - rhs` | `constantDifference` |
| `coefficient * symbol + residual` | `affineDecompose` |
| `expr[symbol += step] - expr` | `finiteDifference` |
| `residual + integer constant` | `splitAdditiveConstant` |

Do not simplify a predicate and inspect its printed form. Ask `check` or
`equivalent`.

Do not prove divisibility and construct a quotient by walking coefficients.

```cpp
sym::ExactDivideResult result = analysis.tryExactDivide(expr, divisor);
if (result.status != sym::ExactDivideStatus::Proven || !result.quotient)
  return failure();
if (analysis.defined(expr) != sym::CheckResult::True ||
    analysis.defined(result.quotient) != sym::CheckResult::True)
  return failure();
```

## Proof Recipes

### Exact byte division

Symbolic memory maps use bit offsets; pointer operations use byte offsets.
The conversion is legal only when the complete bit expression has an exact,
defined quotient by eight.

```text
bit offset: 16*item + 16*slot
query:      tryExactDivide(offset, 8)
result:     2*item + 2*slot
```

Congruence can prove exactness even when structural coefficients do not.
Failure keeps the access on its conservative path.

Scaled wrapping expressions keep their mathematical wrap:

```text
Mod(2*x, 2^32) / 2  -> Mod(x, 2^31)
```

The result becomes `x` only with `0 <= x < 2^31`. For `x = -1`, it is
`2^31 - 1`. Treating the signed input as an unwrapped integer is unsound.

### Ranges

Use one range for the complete target expression before decomposing it into
terms.

```text
expr:  128 + 64*u + w
facts: 0 <= expr <= 2147483647
query: range(expr)
```

The query must recover the range from the correlated expression facts. It
must not require independent ranges for `u` and `w`.

An exact singleton range is a value substitution during fact-aware
simplification.

```text
facts:  d == 2, s == 128
expr:   Mod(floor(x/s), d)
result: Mod(floor(x/128), 2)
```

`1 <= d <= 2` stays symbolic. A target path that requires a static divisor
rejects it.

Ask `range(expr)` first. Explicit expression-range facts are indexed by the raw
expression and a cached expanded, fact-free-simplified alias, so equivalent
factored and reconstructed spellings match without caller expansion. If range
propagation still fails, expand and retry under the same analysis. Caller-side
expansion can grow the DAG and remains deliberate escalation beyond alias
lookup.

Rational endpoints require an explicit rounding policy:

- enclosing a mathematical interval: floor lower, ceil upper;
- restricting to integer values: ceil lower, floor upper.

Use `floorEndpoint`, `ceilEndpoint`, and `compareEndpointToInteger`; widened
comparison prevents cross-multiplication overflow.

### Interval and congruence intersection

Range and residue facts constrain the same domain.

```text
facts: 0 <= x <= 15, Mod(x, 4) == 2
query: range(Mod(x, 16))
result: [2, 14]
```

If the interval contains no value with the required residue, the fact domain
is contradictory. A partial reachable-residue cycle must be bounded; large
cycles fall back to a sound structural range.

### Symbolic modulus

Relational facts can remove a mathematical Mod without enumerating values.

```text
expr:  Mod(x, 8*d)
facts: d > 0, x >= 0, x < 8*d
result: x
```

Missing positivity, lower bound, or relational upper bound keeps the Mod.

### Equivalent residues

Equal residues follow from divisibility of their dividend difference.

```text
expr:  Mod(x + z, 16) - Mod(x, 16)
fact:  Mod(z, 16) == 0
result: 0
```

A wrong residue, different modulus, or unknown divisibility must not cancel.

### Ordered predicates on a discrete grid

Two ordered comparisons can be equivalent even when their thresholds differ,
provided no feasible grid point lies between them.

```text
facts: Mod(origin, 4) == 0, Mod(limit, 4) == 0
lhs:   origin < limit
rhs:   origin + 3 < limit
result: equivalent(lhs, rhs) == True
```

Normalize strict residuals, compute the constant threshold distance, and ask
the fact domain whether an intervening residue is reachable. This proof is
generic ixsimpl equivalence. Wave only decides that the predicates control the
same packet operation.

Without both grid facts, the result is unknown. A similar-looking fact such as
`Mod(origin, 4) == 0` alone does not align `limit`.

### Mod successor without boundary crossing

Mathematical Mod advances linearly until it reaches a divisor boundary.

```text
facts: D > 0, Mod(A, 8) == 0, Mod(D, 8) == 0
lhs:   Mod(A + 1, D)
rhs:   Mod(A, D) + 1
result: equivalent(lhs, rhs) == True
```

The residue grid proves that `A + 1` cannot cross a multiple of `D`. At a
reachable boundary the query remains unknown or proves inequality.

MLIR `remsi` is not mathematical Mod for negative dividends. Wave must prove
the signed remainder is nonnegative before using this mathematical identity.
For a positive divisor Wave queries `Mod(A, D)`; for a negative divisor it
queries `Mod(A, -D)`. If only `D != 0` is known, both sign branches must prove
the identity. Unsigned remainder still requires its typed divisor and no-wrap
conditions.

### Same quotient bucket

Floor differences cancel only when the shift stays within one quotient bucket.

```text
expr:  floor((A + delta) / D) - floor(A / D)
facts: D > 0, 0 <= Mod(A, D) + delta < D
result: 0
```

Both lower and upper boundary facts matter. A proof for positive `delta` does
not imply the negative-shift case.

### Quotient and remainder reconstruction

Within the mathematical Mod domain, a shared scale reconstructs the dividend:

```text
c*outer*m*floor(E/m) + c*outer*Mod(E,m) -> c*outer*E
```

The V9 address shape is one instance:

```text
64*s*floor(x/256) + 32*s*Mod(floor(x/128), 2)
  -> 32*s*floor(x/128)
```

Scale, outer factor, modulus, and floor multiplier must match. A mismatched
factor or multiplier keeps the original sum.

### Shared-DAG simplification

Simplify related roots as one batch.

```cpp
SmallVector<sym::ExprHandle> roots{base, targetBlock, bitOffset};
if (failed(analysis.simplify(roots)))
  return failure();
```

The subtree cache is scoped to the call and fact context. Results from one
fact set must never be reused under another. Branch-local Piecewise facts use
their own cache scope.

## Finite Difference

`finiteDifference(f, x, step)` constructs and simplifies:

```text
f[x -> x + step] - f
```

It replaces that ladder for proof construction. Source-shaped material
candidates may still use structural substitution and subtraction. It does not
prove that the result is constant, equals the loop step, is loop invariant,
fits an index, or respects fixed-width no-wrap. Callers ask those questions
separately.

```cpp
std::optional<sym::ExprHandle> delta =
    analysis.finiteDifference(f, x, step);
if (!delta || analysis.integerValued(*delta) != sym::CheckResult::True)
  return failure();
```

If a caller already has `fShifted`, `fBase`, and a literal expected delta, use
`constantDifference` directly.

```cpp
std::optional<int64_t> delta =
    analysis.constantDifference(fShifted, fBase);
bool matches = delta && *delta == expected;
```

### Scope of `f(x + N) - f(x) == N`

The identity proves one narrow property: `f` preserves a particular step.
It is not a replacement for symbolic reasoning as a whole.

```text
f(x) = base + x,       N = 4  -> 4
f(x) = base + 8*x,     N = 4  -> 32
f(x) = x*x,            N = 1  -> 2*x + 1
f(x) = x + Mod(x, 4),  N = 4  -> 4
f(x) = Mod(x, 8),      N = 1  -> 1 or -7
```

The second case is a valid constant stride but fails `difference == N`.
The third is not loop invariant. The fourth proves only the chosen step; it
does not make `f` globally affine. The fifth still needs cyclic-boundary
policy.

| Wave proof | Correct query | Role of `difference == N` |
|---|---|---|
| Loop carry stride | `finiteDifference`, then integer-valued and loop-invariant checks | Useful when expected physical stride equals `N`; otherwise compare with the real stride |
| Two existing addresses | `constantDifference` or total `equivalent` | Parameterizing them as one `f` adds no proof power |
| Slot adjacency | `constantDifference == elementBits`, plus base/block equivalence | Loop or slot step usually differs from bit stride |
| Projection invariance | total `equivalent` | No finite-difference role |
| Divisibility, ranges, known bits | dedicated query | No finite-difference role |
| Remainder wrap | Mod equivalence plus Wave boundary policy | A local step proof cannot remove wrap policy |
| Predicate activation | predicate `equivalent` | Threshold and residue facts matter, not a function step |

`step` must not reference `x`. A zero step is vacuous. Facts must describe a
domain where both evaluations are defined. Wave still excludes terminal loop
iterations without a successor and verifies materialization legality.

Loop extraction keeps one analysis per exact expanded-expression domain. It
derives the proof stride with `finiteDifference` and constructs the
source-shaped material stride structurally. Accumulating U32 proofs admit base,
stride, and trip-count facts in that order on one analysis; each phase may use
only facts already admitted.

## Wave-Owned Policy

### Symbolic memory

ixsimpl proves address algebra. Wave still owns:

- mapping `block`, `item`, `slot`, and packet symbols to SSA values;
- filtering facts by dominance and binding parity;
- i32 wrapping-invariant fact selection;
- workitem and loop projections;
- signed versus unsigned remainder eligibility;
- base and target-block interpretation;
- transaction graph construction and exact cover;
- target-provider legality and profitability;
- explicit memory-token ordering.

`RemainderProofContext` is therefore Wave code. Its expression questions use
core queries; its SSA traversal and execution projections do not move.

#### Exact-domain caching and fallback

Exact member-pair proofs batch only when their ordered assumption-handle
sequences match exactly. Hashes select candidate groups; full sequence equality
resolves collisions. Assumptions are not sorted or deduplicated.

Slot preparation stays in packet order because it mutates packet-binding
state. Prepared substitutions and mapping metadata are then grouped by exact
fact domain. One `Analysis` specializes every slot in a group.

Larger packets use the same grouping for sparse address canonicalization. One
analysis per exact domain simplifies base and target-block expressions and
splits additive offset constants for all member slots.

Each slot receives an original `size_t` proof ID before copying or gather
deduplication. Access-local relation caches use canonical
`(min(id), max(id))` keys. A proof stores base/target equivalence, same offset,
and both directed adjacency results. Copies retain the original ID.

Slot specialization asks ixsimpl to split the simplified bit offset into a
residual and integer constant. A successful `splitAdditiveConstant` result is
retained with that slot as a proof signature under the slot's exact facts.
Missing results are not negative proofs.

Packets of at most 64 slots use dense relation planning. Slots with a proof
signature form classes keyed by exact base, target-block, and residual handles.
Each class retains only non-activation facts common to every member. A theorem
between two classes therefore applies to every member pair: it proves base and
target-block equivalence and a constant residual difference under the combined
class-common facts. Member constants turn that residual difference into the
directed bit-offset difference.

Same-class differences need only checked subtraction of member constants.
Cross-class theorems use ixsimpl once per class pair. The pass-scoped class
cache keys the complete ordered common-fact sequence and the two oriented class
keys. A conclusive theorem is cached. If ordered analysis succeeds but the
theorem remains `Unknown`, an unavailable theorem marker is also cached. That
marker suppresses duplicate class probes; it is not a proof of inequality.

Every member pair covered by an unavailable class theorem enters exact
pair fallback. Missing signatures and overflowing class arithmetic do the
same. Dense planning therefore covers every unordered slot pair while
amortizing proofs over expression classes.

Larger packets use sparse address buckets after exact-domain canonicalization.
They consider constant buckets separated by `elementBits`. After either graph
path, logical packet successors are checked explicitly and retain exact
fallback when class or sparse reasoning cannot prove them.

Exact member-pair fallback groups pairs by their combined exact fact domain.
Groups first use `Analysis::createDirect`. Unknown or builder failure retries
the whole task under one ordered `Analysis::create` shared by the unresolved
group tasks. The direct analysis is destroyed before that fallback; derived
relations remain queries, not imported facts.
`constantDifference(highOffset, lowOffset)` is the first offset query: zero
proves one point, `elementBits` proves low-to-high adjacency, and
`-elementBits` proves high-to-low adjacency. If it cannot produce a constant,
the same analysis runs total equivalence and composed-add queries.

The pass-scoped exact-pair cache key contains the complete ordered assumptions,
oriented base, target-block, and offset handles, and `elementBits`. It stores
conclusive proofs and successful ordered probes that remain `Unknown`. An
`Unknown` entry is marked prepared but unavailable and retains any partial
proof. If base and target-block equality were proved before offset reasoning
became unknown, `baseTargetProven` remains true and remainder preparation may
run. An unknown base or target-block does not enter remainder fallback.
Analysis-construction and expression-construction failures are not cached.
Full key equality resolves hash collisions.

Wave only schedules and caches these queries. It does not walk expressions,
refine predicates, or reproduce ixsimpl algorithms.

Activation proof is lazy. Same-point and adjacency checks first require a
successful address and offset relation, including any remainder-successor
fallback. Only a surviving candidate compares activation. Activation
predicates are removed from its separate fact domain before proving the two
activation relations equivalent. Structural equality needs no analysis. A
pass-scoped cache retains conclusive equivalence or inequivalence under the
complete ordered non-activation assumptions and the two oriented relation
handles. Unknown direct equivalence retries under the ordered fact domain;
Unknown and construction failure are not cached. Relation analyses are
destroyed before activation fallback or remainder proofs open another
analysis.

Dense member-pair fallback batches address and remainder preparation together.
Adjacency checks consume the prepared results instead of reopening one analysis
per pair. Only pairs with proven common base and target-block receive remainder
preparation.

Remainder fallback uses two exact domains. Slot-pair assumptions batch affine
residuals and binding-symbol nonnegativity. A pass-scoped preparation cache is
keyed by the complete ordered facts, oriented bit offsets, oriented binding
symbol handles, and `elementBits`. A `Ready` entry restores the prepared
candidate and both binding-nonnegative flags.

Direct construction handles cheap preparation first; unresolved candidates use
the ordered fact domain. A completed query with no usable candidate stores a
no-proof marker. Only a successfully constructed direct or ordered analysis can
produce either cached state. The marker prevents duplicate preparation but is
not a proof that the slots are non-adjacent. Analysis or expression
construction failure is not cached.

Each `Ready` candidate's ordered dividend/divisor assumptions then batch divisor
equivalence, dividend successor, and divisor sign. Both exact domains use
direct construction; later definedness and sign facts use `assume`. SSA
projection and materialization run only after the slot-pair analysis is
destroyed. Candidate order is unchanged. Known-sign and unsigned proofs add
definedness to one candidate analysis; unknown signed divisors use sequential
positive and negative child domains.

Failure to discover an edge leaves slots separate.

The `relation-planning-fact-domains` pass statistic counts successfully built
address-class, exact-pair, activation, and sparse-canonicalization domains. It
is not a total count of `Analysis` constructions; only instrumented
construction sites contribute.

On the 8K persistent-causal kernel, the symbolic-memory pass runs in 14.74
seconds in isolation. Direct whole translation takes 92.30 seconds, down from
the 128.88-second strong baseline. Final regeneration left all 16 assembly
goldens byte-identical; their parallel lit filter completed in 94.36 seconds.
The reduction comes from sharing proof work, not weakening proofs.

Typed-pointer emission first prepares every selected transaction point.
Requests with identical ordered assumptions share one analysis. Preparation
records only an existing SSA offset or a structurally computed element-offset
handle; no analysis survives into IR emission. Loads and stores retain planner
order, and failed typed preparation takes the byte-pointer path.

### Redistribution

ixsimpl proves relation expressions defined, integral, in range, or equal.
Wave enumerates small finite relations, classifies movement, selects shuffles
or LDS, allocates scratch, and materializes the relation.

Enumeration is a conservative fallback, not an algebra engine.

Classification and block-lowering checks share one analysis over the exact
`block`, `item`, and `slot` range domain. Intermediate relations keep the
classification and lowering status without enforcing target support until
composition finishes. A composed relation receives a new classification.

Coordinate evaluation caches belong to one redistribution. They survive from
validation through lowering, then release with that operation. Composed
relations discard the cache built for their prior expression roots.

Relation composition builds a whole adjacent chain in one fact-free analysis.
IR operands and attributes change only after that analysis is destroyed.

Each lowering path collects every expression and destination slot before its
first materialization. One `item`-range analysis substitutes `block = 0`,
substitutes each slot, and simplifies the complete batch. Scratch lowering
includes every store address, load address, and dynamic vector selector from
every stage. Duplicate expression-slot pairs enter the batch once. Emission
consumes only prepared entries; a missing entry fails lowering.

### Pointer coalescing

Coalescing compares addresses only after remapping both expressions and their
facts into one binding namespace.

```text
left:  x                 with x == 4*i
right: 4*j + 1           with j bound to the same SSA value as i
delta: right - left == 1
```

Missing binding parity, stale symbols, or contradictory facts keep the
accesses separate.

### WaveAMDMachine

ixsimpl can prove a mathematical offset nonnegative, bounded, divisible, or
constant. WaveAMDMachine chooses voffset, soffset, addr64, immediate splits,
buffer operations, and wide materialization. Those choices depend on AMD field
widths and typed values.

Transaction providers keep their B8/B16 address grammar and sampling policy.
Their equality and range checks use one shared analysis.

Address planning opens one analysis over the pointer offset's ordered facts.
Whole-expression bounds, bounded Add decomposition, field packing, and final
slot simplification reuse it. Rational preflight and rational materialization
reuse the same analysis for the selected slot.

Wide recursive materialization opens its analysis lazily and reuses it for
integrality, nonnegativity, rounding, and power-of-two Mod checks. A non-power-
of-two Mod destroys that analysis before entering the narrow materializer.
Buffer promotion builds the complete pointer-chain expression structurally,
then proves its final byte range in one analysis.

### Proof form and material form

Strongest proof form is not always cheapest machine form. Keep both when a
pass needs aggressive algebra for legality but later emits the expression.

```text
material form: persisted or source-shaped expression used for emission
proof form:    expanded and simplified expression used for queries
facts:         transferred with both forms in one binding namespace
```

Use proof form for equality, ranges, divisibility, grouping, and field-fit
checks. Use material form for `wave.index_expr`, pointer arithmetic, and
machine operations. Transaction request points carry both through provider
selection; the selected transaction retains the chosen material byte offset.
Proving a canonical B8/B16 mapping must not silently replace the expression
that gets emitted.

When a transform does choose a new material form, compare the final candidate
with the original form, not an already-expanded baseline. A target-independent
structural cost accepts a constant, a strictly cheaper supported expression,
or an equal-cost expression that removes bindings. Unknown candidate cost and
equal-cost permutations keep the original. Machine selection treats the
persisted form as authoritative when it is lowerable; it may build a stronger
proof form without rewriting emission shape.

Exact division follows the same rule. The proven quotient is a proof result;
the structural division of the material input is the emission baseline. The
quotient replaces that baseline only when the material-form cost policy accepts
it.

Address-field decomposition must query the complete proof expression before
splitting correlated addends. A bound on `a + b` does not imply independent
bounds on `a` and `b`. Field assignment may use the whole-expression proof;
materialization still follows the selected material expression.

Decomposition distributes one outer integer factor across one Add layer. It
also applies that bounded rule to a factored top-level addend:

```text
base + 4*(16 + wgid + 4*lid)
  -> base + 64 + 4*wgid + 16*lid
```

This exposes immediate, uniform, and lane fields without recursively expanding
arbitrary products. Constant and final slot candidates may be simplified when
the material-form cost policy accepts them. Whole-expression and decomposed
plans are compared only after both have their final material forms. Generic
expression cost never collapses a legal voffset/soffset split; keeping uniform
arithmetic off the VGPR path is target policy, not algebraic simplification.

Mathematical integrality and nonnegativity do not prove a 32-bit instruction
sequence safe. Rational lowering also proves every narrow numerator
intermediate cannot wrap, or evaluates the numerator and shift in a wide type.
Proving only the final quotient fits is insufficient.

Narrow rational denominators stay compile-time positive integers. Rounded and
exact integer rational lowering accepts only power-of-two denominators. A
dynamic denominator or an `i64`-overflowing denominator product is rejected
before any B32 multiply is emitted. For a proven nonnegative U32 numerator and
a static denominator greater than `UINT32_MAX`, floor and exact integer
division are zero. Ceil is zero only when the numerator is zero.
Target-independent materialization cost is unknown for an unsupported rational
denominator or dynamic Mod divisor; it cannot make an unsupported source form
win over a lowerable simplified form.

One B32 modular path deliberately permits numerator wrap. It is legal only
when the enclosing operation is mathematical Mod by a positive power of two
no larger than `2^32`, and the numerator expression preserves the required low
bits through B32 evaluation. The whitelist covers integral Add/Mul forms,
Xor, and nested power-of-two Mod. The enclosing mask discards every wrapped
high bit. No other rational lowering treats B32 wrap as an exact-integer proof.

## Fixed-Width Boundary

ixsimpl is not a bitvector engine. Wave owns:

- bit width and signedness;
- wrap, overflow, truncation, and extension;
- no-wrap preconditions;
- typed division and remainder semantics;
- instruction immediate and address-field widths;
- conversion between element, byte, and bit units.

Do not reinterpret wrapping `i32` arithmetic as unbounded algebra. Prove no
wrap, encode the mathematical wrap explicitly, or keep the proof in MLIR's
integer analyses.

Known-bit results are mathematical low-bit facts. They do not assign a type.

`provablyFitsU32` is target policy over a core range/check query. Failure picks
a wide path or rejects lowering; it never licenses truncation.

Narrow non-power-of-two Mod requires the complete nonnegative dividend to fit
U32. Proving only the remainder fits is insufficient: B32 evaluation may wrap
the dividend before constant-division lowering. Power-of-two Mod may use a
low-bit mask when the emitted expression preserves those bits.

Pointer element-to-byte scaling rejects an unrepresentable literal or
coefficient. A complete symbolic interval may exceed signed `i64` and still use
the 64-bit address path when bounded expansion proves every materialized
coefficient representable; runtime address arithmetic then has the target's
64-bit semantics.

## Python Boundary

Python builds `ixsimpl.Expr` objects and binds their symbols to SSA values.

```python
step_sym = dsl.sym("step")
raw_step = step_sym * tiles + k
value = bld.index_expr(raw_step, {step_sym: step})
```

The builder imports the expression and assumptions structurally. It does not
transport an opaque Python fact object and does not print then parse nodes.

External contracts absent from IR remain explicit assumptions. Derived affine
facts use structural expressions. Workitem and SCF ranges already available to
MLIR analyses should not be duplicated in Python.

WaveMeta binds module parameters and substitutes tuple widths first. Greedy
canonicalization then substitutes constant parameter and static-loop bindings
into `wave.index_expr`. Tuple decomposition follows; residual dynamic indices
or widths are diagnosed last. Local op and type verification remains
independent of this specialization order.

An MMA accumulator index uses the same path:

```text
before:
  %wave_n = wavemeta.param "wave_n_tiles" : index
  %acc_idx = wave.index_expr <"i*wave_n + j">
      ["wave_n", "i", "j"](%wave_n, %i, %j)
  %acc = wavemeta.tuple_get %accs[%acc_idx]

after wave_n_tiles = 2, i = 1, j = 0:
  %acc = %acc_slot_2
```

Parameter binding and static-loop unrolling make the index constant.
`wave.index_expr` canonicalization materializes `2`; tuple decomposition picks
the corresponding accumulator scalar. No separate SSA arithmetic-string
facade is needed.

Host reference math, input validation, and kernel configuration arithmetic are
not lowering proofs and stay ordinary Python.

## Performance Rules

- Build one `Analysis` per related fact domain, not per query.
- Batch roots with shared subtrees.
- Keep cache state scoped to one fact context.
- Do not scan every node in a store to validate one handle.
- Bound recursive proof depth, term count, and residue-cycle work.
- Fall back conservatively when a bound is reached.
- Profile the exact kernel and pass before changing proof shape.
- Compare emitted assembly when optimizing compile time.

Compile-time fixes follow the measured ownership boundary. Wave caches repeated
theorems and avoids duplicate queries; ixsimpl removes repeated work inside one
query. A Wave cache stores opaque query results and never becomes another
algebra engine.

## Validation

Every proof change needs both acceptance and rejection coverage.

ixsimpl coverage includes:

- source and amalgamated C builds;
- C and C++ API tests;
- Python bindings and property tests;
- contradictory, missing-fact, foreign-context, overflow, and resource-limit
  cases;
- generated amalgamation equality.

Wave coverage includes:

- facade tests for exact query translation;
- dialect tests for positive and conservative fallback behavior;
- Integration coverage for real lowering paths;
- PerfGolden regeneration when assembly can drift;
- exact-kernel translation timing and ixsimpl hotspot profiles.

Stronger proofs may change IR or assembly. Correctness comes first; assembly
drift still requires review and same-hardware performance evidence before it
is accepted as a performance improvement.

## Non-goals

- General SMT or polyhedral solving.
- Bitvector semantics in ixsimpl.
- Implicit alias, barrier, or memory-dependency inference.
- Opaque fact objects crossing Python, C++, or MLIR boundaries.
- Target policy in ixsimpl.
- Expression-domain solvers in Wave transforms.
