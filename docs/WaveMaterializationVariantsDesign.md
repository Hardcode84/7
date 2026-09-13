# Late selection of materialization variants

Status: proposed experiment. Build the bounded infrastructure first, then test
it on GLU. Production enablement requires all gates in this proposal. Other
producers and larger searches require a separate decision.

## Summary

Wave can compare exact materialization alternatives by compiling each concrete
choice and scoring the affected machine region. The producer proves
equivalence. The target model selects the cost objective. The scheduler
schedules each concrete graph without alternative-specific policy.

The first experiment compares induction-variable rematerialization with a
loop-carried modular offset from `wave-extract-loop-strides`. Each source
`wave.materialization_variants` operation records one independent value
choice. Machine selection preserves it as
`waveamdmachine.materialization_variants`. Common machine optimizations can add
choices. Construction then partitions interacting choices into loop-based search
scopes and builds a complete specialized candidate block for each assignment
in a scope.

Before scheduling-related passes, each scope is represented by one
`waveamdmachine.materialization_candidates` operation with multiple regions.
Each region has its own input block arguments, a complete specialized body,
and a yield matching the wrapper results. The wrapper owns the external SSA
uses. Workers clone and transform candidate-local IR without mutating shared
use lists.

Prescheduling passes process candidates independently. The scheduling pass
schedules each candidate in parallel, computes its model cycle score, and
records the score on its yield. An immediate collapse pass keeps the
lowest-cycle region and inlines its scheduled body. Only the selected code
reaches the remaining postschedule passes, register allocation, and emission.

Implement the complete candidate-processing infrastructure before GLU
calibration. Then use it to compare both forms, correct model ranking errors,
and measure compilation cost. Keep automatic selection opt-in until the
production gates pass.

## Terms

- IR means intermediate representation. A block is an ordered sequence of
  operations; a region contains blocks owned by an operation.
- A source choice is one result with one or more exact replacement values.
- A search scope contains all choices whose costs interact. It usually contains
  a loop, its initialization, and its exit computations.
- A candidate is one complete assignment of choices in a scope, materialized as
  executable IR in one region of a wrapper operation.
- A loop carry is a value passed from one iteration to the next through loop
  operands, body arguments, and a terminator. It can also become a loop result.
- A token is an explicit SSA value that orders memory operations. SSA means
  static single assignment: each value has one definition.
- The machine model predicts execution cycles from scheduled instructions,
  dependencies, target resources, and execution frequencies.
- Prescheduling passes prepare the graph for scheduling. Postschedule passes
  finish the selected graph before register allocation and machine-code emission.

## Motivation and calibration cases

Carrying an address offset can reduce arithmetic but add loop state and extend
register lifetimes. Rematerializing the offset can add arithmetic but shorten
lifetimes and expose more scheduling freedom. Neither form is always cheaper.

Two gated linear unit (GLU) kernel configurations motivate the experiment: a
persistent kernel and an optimized asynchronous kernel. Preliminary
observations compare the carried form with induction-variable
rematerialization on gfx950:

| Kernel | Hardware time change | SALU | VALU | SQ wave cycles | Preferred form |
|---|---:|---:|---:|---:|---|
| GLU persistent | about +1 to +2% | -18.5% | +1.0% | +1.75% | rematerialize |
| GLU optimized_async | -8.2% | -17.2% | +4.5% | -9.6% | carry |

SALU and VALU denote scalar and vector arithmetic instruction counts. SQ wave
cycles measure wave execution cycles. Positive changes indicate an increase
relative to rematerialization.

The preliminary model estimates are 19,484 cycles for the persistent carried
form and 20,288 for rematerialization at the tested trip count. The model thus
prefers the form that hardware measures as slower. These figures define a
calibration problem; they are not acceptance evidence. Reproduce both rankings
with controlled artifacts during GLU validation.

Stage 2 must retain exact source revisions, generator arguments, input shapes,
input distribution, loop counts, target settings, tool versions, device
settings, IR, assembly, binaries, and raw measurements. It must define the
protected sweep and model-calibration corpus before tuning starts. LLVM and
the last known-good Wave baseline need the same workload, output contract, and
timing method.

Production enablement is blocked if a generic model correction cannot explain
both opposing witnesses and preserve the calibration corpus. A kernel name, choice
ordinal, or producer identity must not affect the model score.

## Scope and ownership

This is a cold compiler optimization path. Candidate cloning, parallel memory
use, and total CPU work have explicit budgets. It adds no runtime choice.

The initial experiment module contains exactly one defined schedulable kernel.
Declarations and immutable target support data are permitted. There must be no
other executable function that needs a separate score or installation
decision. The experiment setup checks this restriction before constructing
alternatives. A direct experimental invocation outside this scope reports an
error.

Each search region has a configurable candidate limit. The driver retains
the first assignments in stable operand order, up to this limit. Larger search
spaces do not cause compilation to fail. Each retained assignment resolves all
choices. The limit bounds exploration; it does not prove that the retained
assignments contain the lowest-cost candidate.

The producer owns fixed-width semantics, definedness, and dominance. The model
owns target cost, occupancy policy, and legal resource limits. Candidate
construction owns enumeration; the pipeline owns candidate execution and
collapse. The scheduler remains a stall filler. It receives no
alternative-specific ranking or post-schedule veto.

This design does not add algebraic search, infer equivalence from consumers,
change memory transactions, or move selection into spill repair.

## Semantic foundation

A canonical index expression defines which address a computation produces. Its
mathematical relation, integer width, assumptions, and definedness form the
proof input. A materialization is an instruction sequence that computes that
relation. Choosing a cheaper sequence must not change the relation or the
memory transactions it addresses.

The loop-offset producer proves that a recurrence and induction-variable-based
recomputation produce identical fixed-width values on every executed
iteration. For example, an unsigned modular offset can be recomputed as
`(base + iteration * step) mod modulus` or carried with an equivalent modular
update. The proof must cover initialization, each update, wraparound, and
every result use. Mathematical integer equality alone does not prove
equivalence of fixed-width or poison-producing operations.

Alternatives must have the same definedness. Poison denotes a value for which
the source operation imposes no ordinary value requirement. Replacing poison
with a concrete value can be a one-way refinement, but the reverse replacement
can be invalid. Such a refinement is not an interchangeable alternative in
this design. Candidate construction accepts only exact alternatives; it does
not infer equivalence or definedness from a favorable cost.

The canonical expression does not encode target preferences. The recurrence
proof is sufficient to construct the initial alternatives; no separate
index-expression planner is required.

## Source value-choice contract

```mlir
%value = wave.materialization_variants %rematerialized, %carried
    : !wave.simd<i32>
```

The operation has one result and one or more operands. Every operand has the
exact result type and is an exact replacement at every result use. All choices
are equivalent; no operand has a distinct semantic role. A single-operand
operation folds to that operand. The operation is pure, always speculatable,
and has no runtime meaning. Its producer computations must be safe at their
actual placement; purity alone does not permit speculation of a trapping or
immediately undefined computation. Proof assumptions follow defining SSA values, not
nearby operations.

Canonicalization removes duplicate SSA choices and flattens choices produced
by another `wave.materialization_variants` operation. It preserves first-seen
leaf order. Shared producers remain when other operations still use them.
One remaining choice folds to its value.

Each variants operation defines one independent choice. Any combination of
operand selections across operations must preserve program semantics. Shared
producers and cost interactions determine search-region membership; they do
not require synchronized operand indices.

Alternatives that are valid only as a bundle do not satisfy this single-result
contract. Such a producer needs a multi-result choice operation that
represents the coupling structurally, with a separate semantic contract and
design review.

The verifier checks local operand and result structure. The driver builds a
choice table from the operations in each search region. Internal trial helpers
consume that table. Equivalence is a trusted producer contract, not a verifier
def-use analysis.

## Candidate wrapper contract

The machine wrapper is `waveamdmachine.materialization_candidates`. It has a
variadic input list, a result list, and one or more single-block candidate
regions. A candidate block can contain nested loops and other structured ops.
Region order is stable and breaks score ties. All candidates are equivalent.
Every candidate is a complete semantic replacement for the scope, including
memory effects, explicit token dependencies, and yielded values.

Each region has its own block arguments with the same count and types as the
wrapper inputs. Every captured SSA dependency, including memory tokens, passes
through those arguments. Candidate bodies cannot capture external SSA values
or values from sibling candidates. The wrapper has `IsolatedFromAbove`;
ordinary SSA dominance also excludes references to sibling-region definitions.
The wrapper's own operands are the shared external uses. Candidate-local uses
refer to distinct block arguments, even when two wrapper inputs name the same
value.

`waveamdmachine.candidate_yield` terminates each candidate and forwards values
matching the wrapper result types. Those results are the only SSA outputs from
the scope. Multiple results represent the whole scope's outputs; they do not
introduce synchronized selection indices between source value-choice
operations. The verifier checks local signature, region, and terminator
structure. Equivalence of candidate bodies remains a producer proof.

The wrapper has `RecursiveMemoryEffects`. It is not declared pure or always
speculatable. Candidates can contain loads, stores, DMA, and barriers. Generic
effect queries conservatively include effects from all candidate bodies; the
execution contract selects exactly one body, not their sequential execution.

### Region-branch dataflow

Implement `RegionBranchOpInterface` on the wrapper and
`RegionBranchTerminatorOpInterface` on its yield. Model an exhaustive,
mutually exclusive switch with a compile-time choice and no runtime selector:

| Edge | Forwarded values |
|---|---|
| Parent to any candidate | Wrapper inputs to that candidate's block arguments |
| Candidate yield to parent | Yield operands to wrapper results |
| Candidate to sibling candidate | No edge |
| Parent to parent without a candidate | No edge |

`getEntrySuccessorOperands` returns the wrapper inputs. `getSuccessorInputs`
returns candidate arguments for a region successor and wrapper results for the
parent successor. Each yield exposes its mutable successor operands. Before
collapse, every candidate is reachable and has invocation bounds `[0, 1]`.
Exactly one candidate executes per wrapper invocation. Loops inside that
candidate retain their own execution counts.

Use these interfaces for MLIR dataflow and candidate-local cleanup. Scores are
not runtime branch conditions and do not change reachability before collapse.
Candidate-local cleanup must preserve the common input and result signature.
Any removal of wrapper inputs, candidate arguments, or wrapper results is a
serial structural rewrite across all candidates, not a worker-local signature
edit.

The generic MLIR region-branch canonicalization patterns reject
`IsolatedFromAbove` operations. Their forwarding rewrites can also replace
block arguments with external operands, which would break wrapper isolation.
Apply those patterns to supported loops inside candidates, not to the wrapper
itself. Keep the wrapper signature fixed through candidate processing; its
eventual collapse performs the serial argument and result remapping.

### Scores and collapse

MLIR regions have no attributes. The scheduling pass records a nonnegative i64
`cycles` attribute on each successfully scheduled candidate's yield. The value
is the model's cycle score for that entire candidate at the fixed scope
context. Do not sum scores for nested scheduler blocks as if overlap and loop
frequencies were independent. The score is valid only for that scheduled body.

The collapse pass selects the minimum score and breaks exact ties by region
order. It does not need a separate winner-index attribute. No graph-changing
pass runs between scoring and collapse. Missing scores, malformed scores, or a
broken candidate contract terminate compilation; they are not baseline
fallbacks.

Collapse is serial. Map winning block arguments to wrapper operands, inline
the winning body at the wrapper position, replace wrapper results with yielded
values, and erase the yield, losing regions, and wrapper. Retain the chosen
instruction order. Do not reschedule the winner. The remaining postschedule
pipeline runs once on the resulting function.

## Construction and lowering boundary

`wave-extract-loop-strides` preserves the original rematerialization and
builds the proved recurrence. It joins corresponding values with independent
source variants operations. It does not select by consumer identity or
memory-operation kind.

Machine instruction selection converts source choices to
`waveamdmachine.materialization_variants`. The machine operation has the same
exact-type constraint, equivalent-choice contract, singleton fold, and
canonicalizers as the source operation. Selection must give all operands and
the result one common machine representation. Pointer metadata and split
machine values must preserve the independent-choice contract.

Common machine optimizations run on this choice graph and can add choices.
They must preserve all alternatives. A use-count profitability heuristic must
record a choice instead of discarding an equivalent form. Semantic legality
checks remain required.

After common optimizations, form search scopes and expand the machine choices
into `waveamdmachine.materialization_candidates`. Create private block
arguments, clone each complete assignment, resolve its value choices, and
remove rejected computations and dead carries. No Wave candidate wrapper is
required. Each machine candidate must be fully specialized before scheduling.

```text
Wave alternative construction
  -> machine selection, preserving choices as machine value-choice ops
  -> common machine optimizations, including new alternative producers
  -> form independent search scopes and enumerate assignments
  -> create machine wrappers, destination regions, and private block arguments
  -> clone each candidate with its own IRMapping; resolve machine choices
  -> candidate-local machine cleanup and dead-carry removal
  -> candidate-local split barriers, MMA reuse, scalar masks, hazard repair
  -> candidate-local multi-wave specialization
  -> schedule candidates and compute cycle scores in parallel
  -> record scores on yields; collapse each wrapper to its winner
  -> packed peephole and remaining production postschedule passes
  -> register allocation, final hazard/wait handling, emission once
```

Reuse production pass implementations and options. Give them a candidate scope
and immutable target context; do not maintain a copied alternative pipeline.
Passes must not hoist candidate-dependent computations outside the wrapper,
combine sibling bodies, or charge resources as if all candidates execute.
Candidate-local rewriting must preserve the wrapper's common signature.

Multi-wave specialization must recognize a loop inside a candidate as an
eligible execution scope. A check that requires the immediate parent to be
`func.func` excludes such loops. Obtain target and launch settings from the
enclosing function while keeping transformation state local to the candidate.
Audit the same assumption in scheduling-region discovery, scalar-mask state,
barrier state, and hazard repair. Candidate state must not be shared across
sibling alternatives.

Early specialization is required because `waveamd-form-fused-int` and machine
cleanup contain use-sensitive patterns. Coexisting source alternatives can
prevent fusion or hide a producer behind a value join. Dead code elimination
(DCE) after machine lowering cannot recover a missed dedicated pass. Include
candidate-dependent setup and placement in the scope so a wrapper does not
itself block a required optimization.

In separate validation runs, compare each candidate with independent
compilation of the same assignment. Check cleanup output, final instruction
shape, carries, resources, and binary behavior. Explain and resolve any
difference, including baseline differences caused by the wrapper boundary,
before production enablement.

Without alternatives, run the ordinary pipeline once without a wrapper or
clone. The initial experiment accepts only the scheduled pipeline entry. An
unscheduled entry must reject candidate wrappers until it has an explicit
selection contract. Source choices become machine choices during selection.
Resolve machine choices before scheduling. Neither value choices, wrappers,
nor yields may reach register allocation or emission.

## Fusion as a materialization choice

Single-use fusion is another candidate producer for this mechanism. A
use-count heuristic chooses between retaining a shared intermediate and fusing
its work into a consumer. Both single-use and multi-use producers can have
alternatives; use count alone does not establish which scheduled graph is
cheaper.

For example, consider pure arithmetic with proved identical fixed-width
semantics:

```text
p = mul(a, b)
r = add(p, c)
s = other_use(p)
```

The baseline keeps `p` and `r`. A fused alternative computes
`r = mad(a, b, c)` while retaining `p` for `s`. Fusion can shorten the
dependency chain to `r`, but duplicates multiply work while `s` remains live.
If every use selects a fused form, DCE can remove `p`. These costs depend on
the complete selection vector, not on separate charges for each consumer.
Compare sharing, dependency latency, instruction resources, and register
lifetimes through the same target model.

Separate semantic and target legality from the use-count profitability test.
Instruction support, operand encoding, constant-bus constraints, arithmetic
definedness, and live flag results still require proof. Some current rewrites
erase the producer after replacement; their single-use check also protects
that erase. A variants producer must retain all live results and let DCE
remove only dead operations. Removing `hasOneUse()` from those rewrites is not
sufficient.

Each consumer result can have its own variants operation, so the trial space
includes partial fusion. Shared producer cost is present exactly while a
selected graph needs it. Search consumers together when their costs interact.
Stable ordering and the total search bound still apply.

Machine fusion needs a construction boundary before its destructive rewrite.
Record fused and unfused results with machine value-choice operations.
Expand these choices with the other machine choices before scheduling. The
suffix must not rerun the same profitability heuristic and overwrite the
selected unfused form. The choice producer replaces that heuristic at the
fusion decision point.

Combining machine fusion with Wave loop-offset choices requires joint
enumeration: each collapsed Wave choice determines the machine graph and its
legal fusion domains. Independent greedy winners can miss their interaction.
Count complete Wave-plus-fusion assignments within each dependent search
region; do not nest unbounded searches. This extension needs its own
production witness and candidate-cost gate. It does not expand the initial
loop-offset producer scope.

## Scope expansion pass

`waveamd-expand-materialization-variants` places each machine choice in a scope
that contains its complete enclosing loop and enclosing control-flow operations.
The scope includes dependent consumers, including loop exit computations.
Alternative setup enters the scope when all its users belong to scopes. The
pass follows region branch inputs and results to find setup through loop carries.
Shared fixed inputs stay outside the scopes.

Each scope is a contiguous sequence of operations in one block. Overlapping
scopes merge. Shared removable setup and dependent consumers also merge scopes.
Operations between merged scopes retain their order. Independent loops keep
separate candidate counts. Block terminators and machine return instructions
stay outside each wrapper.

The pass caps each candidate count before cloning. `max-candidates` must be
positive. The first choice changes slowest. If the full product exceeds the
cap, the pass retains its first `max-candidates` assignments.
It computes capped counts without overflow. It creates private input arguments
serially, then clones and resolves each assignment in parallel. Dead operations
are removed within each candidate. External uses receive the wrapper results.

Scope formation uses SSA edges, including explicit memory tokens. It does not
infer memory ordering. Separate scopes alone do not prove that model costs are
independent. The scoring pipeline must supply a fixed model state at each scope
boundary before it can compare local scores.

## Search regions and independence

A search scope is a cost boundary represented by one wrapper. Each candidate
region implements that entire scope. Start with one loop and include its
variant-dependent initialization, complete body and nested loops, recurrence
updates, and exit computations. Charge setup work at its actual enclosing
frequency. Do not score a loop body with its setup removed or treat its
operands as free computations.

Merge overlapping scopes and scopes connected by a choice-dependent cost.
Examples that require a merge include:

- a shared producer whose retention or fusion depends on choices in both scopes;
- a value whose materialization or lifetime changes across the boundary;
- a nested-loop choice that changes an outer carry or hoisted computation;
- scheduling motion, resource contention, or outstanding async work that makes
  the boundary state depend on both choices.

Sharing an unchanged input does not by itself require a merge. Neither does an
explicit token edge whose modeled boundary state is fixed. Use SSA, explicit
tokens, and production scheduling/model boundaries; do not infer alias
ordering or insert barriers to make scopes independent.

Independent scopes have fixed external operands and observable results, and a
choice-independent model context at their boundaries. The model context
includes input ready times relative to entry, pending memory counters,
issue-resource state, and resident-wave configuration. A regional score
includes completion of its required outputs and the effects it leaves at exit.
Do not reset counters, assume ready inputs, or force a drain unless the actual
boundary permits it.

The partition must preserve cost composition in the scheduling model. If a
choice changes the next scope's entry state beyond a common time shift, merge
the scopes and score their enclosing execution context. Sibling loops are
candidates for independence, not proof of independence. Dependent nested loops
are searched together; do not choose an inner winner greedily before scoring
its outer-loop alternatives. A whole-function scope is permitted only when the
choices are coupled and the merged scope meets the choice bound.

Scope formation uses the pre-lowering SSA graph and known pass effects. Retain
stable internal scope identities through lowering. Candidate construction
establishes the machine boundary contract for the downstream scheduling model.
A violation is a definite diagnostic; stop and correct the partition or
construction boundary. Do not silently accept a local score for a graph with
escaping choice-dependent effects.

This is model independence at a fixed target configuration. It does not prove
independent final allocation or occupancy. Validate the combined selected
binary through the separate resource and hardware gates; do not add per-trial
regalloc.

## Enumeration, parallel mutation, and storage

Assign scope IDs in stable lexical order before cloning. Within each scope,
assign choice ordinals by a stable operation walk and use operand order for
alternatives. Enumerate the Cartesian product with the first choice changing
slowest. Candidate zero selects the first operand at each choice. Each source
variants op remains an independent choice; there is no grouping attribute.

For a configured cap `M` and binary choice counts `c_1, ..., c_R`, the
candidate count is `sum(min(2^c_i, M))`, bounded by `M * R`. Independent
scopes add their candidate counts instead of multiplying them. If a merged
scope exceeds the cap, retain the first assignments up to the cap. Do not split
coupled choices. Each retained candidate resolves every choice in the scope.

Create the wrapper, its external operands, all destination regions, and each
region's block arguments serially. Build a private `IRMapping` for each
candidate that maps all source-scope inputs to its destination arguments. Then
workers can clone source bodies into disjoint destinations and specialize them
in parallel. The source graph stays immutable until all workers complete. No
worker may fall back to an unmapped external SSA value when cloning a captured
dependency. An incomplete mapping is a construction defect, not permission to
capture it.

Distinct block arguments prevent clone construction, operand replacement, and
operation erasure from mutating shared external use lists. `IsolatedFromAbove`
alone does not permit arbitrary parallel mutation: workers may touch only
their own candidate bodies. They must not edit wrapper operands, region lists,
signatures, enclosing attributes, symbols, or other candidates. Context-owned
attributes and types use MLIR's normal concurrent uniquing support.

Refactor candidate-capable passes around an explicit candidate root. Run
passes without that mutation contract serially until they are adapted and
checked. Standard operation-pass nesting does not automatically provide
region-level parallel execution. The scheduling driver supplies the candidate
work queue, with per-candidate analysis, model, and diagnostic state. Preload
required dialects and snapshot immutable target configuration before workers
start.

Schedule independent candidate bodies in parallel and return their cycle
scores and diagnostics in indexed result storage. After joining workers,
attach scores serially to yields in candidate order. Collapse wrappers
serially because it reconnects winning bodies to external SSA values and
removes losing input uses. Do not mutate the parent operation from scheduling
workers.

Reuse the compiler thread pool and deterministic diagnostic buffering. Index
worker results by candidate order, not completion order. Each wrapper
collapses in place. Independent wrappers compose without a global Cartesian
search or a second scheduling run.

All candidate bodies remain in the wrapper through scoring. Bound and report
worker count, candidate counts, IR size, peak resident memory, CPU time, and
elapsed time. Memory cost includes all candidate bodies, not just active
workers. Clone only the affected scopes; common surrounding IR is lowered
once. The work estimate is `sum(2^c_i * candidate_scope_cost_i)` plus common
compilation and collapse costs. Measure actual lowering and scheduling costs;
do not assume uniform scope sizes. Outer-tuner nesting remains disabled. No
silent search cutoff is permitted.

## Dead carry cleanup

Prune rejected recurrences after machine choices expand into regions. An
unused loop result is not sufficient: a body argument, update, and yield can
form a dead cycle in `waveamdmachine.uniform_loop`. Reuse MLIR dataflow liveness and region-branch canonicalization.
Do not add a separate carry-liveness algorithm or producer-shaped matching.

The `remove-dead-values` pass uses dataflow liveness to replace dead forwarded
operands with `ub.poison` and remove dead computations. The patterns from
`populateRegionBranchOpInterfaceCanonicalizationPatterns` then remove unused
tied block arguments, results, and successor operands. Ordinary
canonicalization removes the temporary poison values. A cleanup pipeline must
finish with no such poison operation in machine IR.

Canonicalizers alone do not remove arithmetic recurrence cycles. Their
dead-input pattern requires unused values, and their forwarding pattern does
not trace through arithmetic. Run dataflow dead-value removal before
structural cleanup. Preserve side effects, control conditions, live carry
dependencies, loop attributes, and zero-trip result semantics.

### Machine-loop integration requirements

The machine loop `uniform_loop` implements region-branch dataflow. Its carry
positions must be removed from init operands, body arguments, terminator
operands, and results together. Its `operandSegmentSizes` property records the
sizes of operand segments, including the optional entry condition and carry
list. Carry erasure must update that property.

The shared `RemoveDeadRegionBranchOpSuccessorInputs` rewrite must erase
segmented operands through `MutableOperandRange`. Raw
`Operation::eraseOperands` does not update segment sizes. The LLVM patch in
`build_tools/llvm_patches` uses one range per operand segment and removes
segments from last to first to preserve offsets. The build helper applies the
patch and includes its contents in the install fingerprint.

Register the full `populateRegionBranchOpInterfaceCanonicalizationPatterns`
set for `uniform_loop`. This set also forwards invariant carries and merges
duplicate carries. Keep these transformations enabled. Register preservation
must handle values that become loop captures after canonicalization and loop
invariant code motion, including 64-bit VCC saves and restores.

Permanent tests cover unused, forwarded, and arithmetic carries in both entry
modes; live controls in both modes; mutually dependent and nested dead carries;
live pre-tested results; interleaved live and dead positions; and a DMA loop
with a live token recurrence. Cleanup must preserve loop attributes and leave
no poison operations. Test the final assembly as well as IR verification.

Do not use a rewrite listener to repair invalid IR after mutation. Verify the
Wave and structured-control-flow loop boundaries before enabling candidate
cleanup. A broken internal mapping terminates compilation; it is not a rejected
candidate.

Explicit wait-token dependencies participate in liveness. A token consumed by
a live wait, effect, or result keeps its carry alive. Do not infer alias
ordering, add user token carries, or retain every token solely because of its
type. Cleanup must not invoke register-allocation spill policy.

## Frequency and scoring contract

The initial experiment requires an exact nonnegative static trip count for
every loop that affects the score. Preserve counts through construction, carry
pruning, and lowering. Distinguish pre-tested zero-trip loops from post-tested
loops. Reject missing or inconsistent frequency metadata before simulation.

Selection requires a strict simulation mode. Missing trip metadata must
produce an error, not an assumed iteration count. A command-line trip-count
override must not replace the kernel's proven execution frequency. A frequency
upper bound is insufficient because alternatives can exchange rank within it.
Bounded or dynamic frequencies require a separate objective and proof
contract.

Score predicted completion cycles for the current search region at its exact
execution frequencies and fixed external model context. Include its setup,
loop bodies, required output completion, and actual exit effects. Do not
substitute whole-function cycles or steady-state cycles per iteration. Fix the
device, launch, resident-wave configuration, calibration data, and simulator
options across candidates. The region simulator must account for nested
execution and boundary state; a flat list of body instructions is not
sufficient.

Select the candidate with minimum predicted region completion cycles. On an
exact cycle tie, select the lowest trial index. Thus the current region's
baseline wins a tie with any other candidate in that region. Pressure and
instruction counts are diagnostics, not additional ranking terms. The driver
adds no target-specific weights or pressure-based rejection rule.

## Winner allocation and model calibration

Pre-allocation pressure is an estimate, not an allocation or occupancy proof.
Tuple alignment, fixed registers, alias constraints, relief temporaries, LDS,
and allocation granularity can change feasibility. Postschedule
transformations, spill repair, and wait insertion can also change cost.

Normal selection does not run allocation, spill repair, or emission on losing
candidates. After collapsing all candidate wrappers, run the remaining
production pipeline once. Its normal target checks enforce the requested
`waves_per_eu` contract on final resources. An allocation or emission failure
terminates compilation; it does not start a search through previously rejected
candidates.

Calibration is a separate experiment. Independently force each choice in the
bounded witness corpus, finish its production pipeline, and retain the
resulting binary and resource metadata. Compare the post-scheduling cycle
ranking with hardware measurements of those binaries. Record registers, LDS,
scratch, relief operations, barriers, waits, and final instruction counts to
explain differences. This work does not add candidate allocation to normal
selection.

If later transformations reverse the predicted winner in a protected case, the
model fails its calibration gate. Correct the prediction and repeat the gate
before enabling production selection. Do not add an allocation-based candidate
score or retry path to hide the mismatch.

## Failure handling and diagnostics

A named, expected target infeasibility established before allocation can
reject one candidate. Estimated pressure alone does not establish such
infeasibility. Workers return a typed score, named rejection, or definite
failure. After joining, the driver reports definite failures first, then
serially removes explicitly rejected candidates while preserving the relative
order of survivors. Attach scores to all remaining yields before collapse. An
absent score is not an implicit rejection, and rejecting every candidate is a
compilation error. A violated internal invariant, malformed producer IR,
unsupported required lowering, pass failure without a candidate-rejection
contract, or IO/platform failure terminates the compilation. Do not relabel
these failures as expensive candidates or hide them when another trial
succeeds.

Tracing records the function symbol, search-region ID and boundary context,
choice ordinals and arities, selection vector, exact frequencies, predicted
cycles, optional pressure and instruction diagnostics, and rejection reason
for each trial. Final resource data belongs to the winner or to separate
calibration runs. A definite error identifies its pass and trial. If no
feasible candidate remains, emit one error with all rejection reasons. Do not
silently install the baseline. Normal successful compilation does not print
selection diagnostics.

A discardable diagnostic attribute can record the collapsed choice for tests.
It is not a second selection input. Remove it before emission. Artifact
retention uses deterministic trial names. Never serialize SSA or structural
proof data through printed strings to communicate between phases.

## Correctness tests

Dialect and driver tests cover local type and arity errors, scope and trial
limits, stable choice ordering and clone mappings, exact ties, and rejection
at every pipeline entry that cannot consume variants.

Transformation tests cover all operands, mixed independent selections, shared
producers, fusion after collapse, placement, and complete rejected-tree
removal. Compare each candidate with independent construction of the same
form.

Wrapper tests cover private argument lists, input and yield type agreement,
external capture rejection, sibling-reference rejection, recursive effects,
region-branch operand mappings, and invocation bounds. Verify that MLIR
liveness keeps inputs used by any candidate and that candidate execution is
modeled as exclusive, not sequential. Test missing scores and exact score
ties.

Parallel construction tests clone candidates that use the same external
values, replace and erase those local uses, and check that wrapper-owned
external use lists remain unchanged until serial collapse. Check nested
captures, immutable source IR, per-candidate analysis state, and deterministic
results across worker counts. Use a thread-sanitized probe for the parallel
mutation path. Test that multi-wave specialization still runs inside a
candidate wrapper.

Carry tests cover Wave/SCF and machine loops, nested loops, mutually dependent
dead carries, live cross-carry dependencies, live control conditions,
zero-trip results, attributes, and async DMA wait-token dependencies.

Scoring tests cover missing and zero trip counts, nested frequency metadata,
finite region costs, cycle ties despite different pressure or instruction
counts, definite pass failure despite another successful trial, and
all-candidate rejection. Verify that only selected bodies reach allocation and
emission and that a winner failure does not retry another candidate.

Region tests cover independent sibling loops, shared unchanged inputs, shared
choice-dependent producers, nested carries, escaping live values, and pending
DMA dependencies. Check merge decisions and the configured candidate cap after
merging. Independent loops must have separate candidate counts. For small
cases within the cap, use exhaustive joint evaluation as a test oracle. Reverse region processing order and vary worker limits; require
identical choices and regional scores. Test scope identity through loop
rebuilding and require a definite failure when lowering violates a declared
boundary.

Integration tests compile both GLU witnesses through the full production
suffix. Check baseline reproduction, final carry and instruction shapes, and
conversion of source choices to machine choices, absence of value choices at
scheduling, and absence of candidate wrappers and yields at allocation and
emission. Separate forced-choice validation runs
check final binaries for every candidate in the bounded corpus. Check selected
binaries for every protected sweep configuration. Simulator checks support
this evidence; target hardware is required for performance.

## Implementation stages and production gates

### Stage 1: complete the infrastructure

Build the full bounded candidate-processing path before testing it on GLU.
Keep candidate production and automatic selection opt-in. Implement these
components in dependency order:

1. Source and machine value choices, machine candidate wrappers and yields,
   local verifiers, isolation, recursive effects, and region-branch interfaces.
   Preserve value choices through machine selection and common optimizations.
2. Search-scope formation, stable enumeration, private argument mapping, and
   parallel cloning and specialization within the candidate-count bound.
3. MLIR dead-value and loop-carry cleanup, including segment-aware operand
   erasure, within each specialized machine candidate.
4. Candidate-local production prescheduling and multi-wave specialization, with
   explicit state ownership and checked parallel mutation boundaries.
5. Parallel scheduling, strict regional cycle scoring, deterministic diagnostic
   collection, serial score attachment, and immediate winner collapse.
6. Normal postschedule processing, register allocation, and emission of selected
   bodies only, plus tracing and forced-choice controls for validation.

Add the specified dialect, transformation, concurrency, and integration tests
as each component is implemented. Cover the full path through final emission,
including independent scopes, live token dependencies, and winner-only regalloc.
Check worker-count independence and use a thread-sanitized probe for concurrent
IR mutation. Fix failures before proceeding to GLU testing.

This stage is complete when the infrastructure and its contract tests pass.
GLU performance, model calibration, and the 5% compilation budget are not entry
gates for infrastructure implementation. Passing infrastructure tests does not
establish production value or authorize default enablement.

### Stage 2: exercise and calibrate on GLU

Connect the proved modular loop-offset producer to the completed infrastructure
for persistent and optimized_async GLU on gfx950. Retain exact source revisions,
generator arguments, input distributions, shapes, loop counts, target settings,
tool and device settings, intermediate IR, final assembly, binaries, and raw
measurements.

Before tuning the model, fix the protected sweep, calibration corpus, measurement
procedure, confidence method, repetition count, and practical regression margin.
Define CPU and resident-memory limits for the intended build environment.
Compare against both LLVM and the last known-good Wave implementation with the
same workload, output contract, and timing method.

Force each legal candidate through the pipeline in separate validation runs.
Check correctness and compare its final code with independent compilation of
that assignment. Require baseline reproduction. Then run automatic selection
and compare regional cycle rankings with measurements of the actual binaries.
Correct the generic model using instruction mix, dependencies, carried latency,
wave issue behavior, and occupancy. Do not use kernel names or choice identities
as model inputs. Recheck the fixed calibration corpus after model changes.

Measure per-scope cloning, specialization, prescheduling, scheduling, scoring,
and collapse with the intended worker limit. Include memory for all retained
candidate bodies. Common code is compiled once; postschedule work, allocation,
and emission run once after collapse. Measure the actual sum of candidate costs.
Separate forced-choice calibration runs from normal compilation measurements.

If correctness, ranking, or compilation cost fails a gate, keep selection opt-in,
identify the mechanism, fix the implementation or model, and repeat the affected
checks. Infrastructure completion does not waive a failed production gate.

### Stage 3: production enablement

All conditions must hold:

- The model selects rematerialization for persistent GLU and carry for
  optimized_async GLU, and preserves the fixed calibration corpus.
- Separate forced-choice validation confirms correctness and intended final
  instruction, memory, and carry behavior for every feasible corpus candidate.
- Controlled same-device A/B/B/A measurements preserve persistent baseline time
  and retain the optimized_async improvement.
- Every protected sweep row compiles, passes correctness, and executes. The
  predeclared confidence bound excludes a slowdown larger than the declared
  margin against both LLVM and the last known-good Wave baseline. Inconclusive
  measurements do not pass.
- End-to-end sweep compilation increases by no more than 5%, including cloning,
  cleanup, scheduling, and simulation for all trials, plus postschedule work,
  allocation, and emission once for each winner. Separate calibration runs are
  not part of this compilation measurement. CPU work and peak resident memory
  meet the Stage 2 limits under the intended concurrent build workload.

A failed witness, protected row, or resource budget blocks production
enablement. Gains elsewhere do not compensate. Passing these gates authorizes
only the specified gfx950 loop-offset slice. More producers, dynamic
frequencies, multiple kernels, or a larger per-region search require another
evidence-backed design review.
