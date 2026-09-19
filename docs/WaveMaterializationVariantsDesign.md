# Materialization variants

Wave selects between equivalent computations by scheduling concrete alternatives
and comparing their predicted cycle costs. Selection is part of compilation.
The generated program contains only the selected code; it has no runtime choice.

This document defines the semantic and architectural contracts. Operation syntax,
local verification rules, pass options, algorithms, and regression cases are
maintained in code and tests.

## Purpose

Equivalent computations can have different scheduling costs. For example, an
address offset can be recomputed from a loop induction value or passed from one
iteration to the next. The carried form can reduce arithmetic but extend register
lifetimes. The recomputed form can expose more scheduling freedom. Instruction
count or use count alone does not determine which form is cheaper.

The same choice contract can describe shared arithmetic and a fused consumer.
Their relative cost depends on whether other selected uses keep the shared
computation alive. The complete selected graph determines that cost.

Materialization selection compares the complete affected computation after
machine instruction selection. The producer proves equivalence. The target cost
model estimates cost. The scheduler applies its ordinary scheduling rules.

## Values and equivalence

SSA means static single assignment: each value has one definition. A value choice
identifies interchangeable SSA values. `wave.materialization_variants` represents
this choice in Wave IR. `waveamdmachine.materialization_variants` preserves the
same meaning after machine selection. Neither operation executes at runtime.

Every alternative must be an exact replacement at every use of the choice
result. All alternatives have the same type, value, and definedness. There is no
distinguished baseline operand. A choice with one alternative is a no-op.
Duplicates and nested choices do not create distinct materializations.

The producer owns the equivalence proof, including integer width, overflow,
poison, dominance, and assumptions. Replacing poison with a concrete value can
be a valid refinement in only one direction. That is not sufficient for
interchangeable alternatives. Purity of a choice also does not permit its
producer computations to execute at an unsafe location.

Assumptions follow defining SSA values. Consumers must not recover assumptions
from nearby operations or sibling uses. Cost estimates cannot establish
semantic equivalence.

For loop offsets, the recurrence and recomputation must agree at initialization,
on every executed iteration, and at every result use. The proof includes
fixed-width wraparound. Buffer bounds and address materialization are separate
contracts: retaining or changing an offset expression must preserve pointer
arithmetic and memory access behavior. A descriptor bound alone does not prove
that an individual access is in bounds.

Distinct value choices are independent semantic dimensions. Matching operand
positions do not establish a relationship between them. Shared computations can
make their costs interact even when every combination is semantically valid.

## Memory effects

The [Wave memory model](WaveMemoryModel.md) defines token ordering and effect
removal. Materialization selection preserves that contract.

An address choice can require alternative memory operations. Each alternative
must contain a complete address computation and preserve the required memory
effects. Results that describe the same alternative effect, including its token,
must select that effect consistently. This relationship follows the effect
producers, not an arbitrary group identifier or matching operand positions.
A dependent memory operation can still have an independent address choice.
Access duplication requires removable effects. Reject calls and atomics that
do not provide this contract.

Automatic shared-offset choices require a complete, duplicable address-use
graph. If an address reaches a non-removable access or a region boundary,
apply the direct symbolic simplification. A use count alone does not establish
that access duplication is legal.

Prerequisite effects are not owned by an alternative merely because its token
chain reaches them. Selecting one load must not delete a required preceding
store. Removing an unselected memory operation must preserve required history
and all effects used by the retained program.

After expansion resolves choices, apply memory canonicalization before
scheduling so scores exclude dead work.

## Search scopes

A search scope contains the computation evaluated as one selection decision.
Scopes are based on complete loops, including dependent setup, nested control
flow, recurrence updates, and exit computations. Setup that becomes unused after
selection must participate in the decision.

Overlapping scopes merge. Shared removable setup and choice-dependent consumers
also join scopes. Sharing an unchanged input alone does not require a merge.
Independent loops retain separate searches instead of forming a Cartesian
product across the function. Selection is regional, not a global optimum for
final register allocation or hardware execution.

Each scope has a bounded candidate count. A candidate is a complete assignment
of alternatives in that scope. Enumeration is deterministic and resolves every
choice in each retained candidate. If all assignments fit, all are considered.
Otherwise, the compiler reports that exploration reached the bound and compares
the retained assignments. Exceeding the bound does not fail compilation or leave
unresolved choices. A bounded search does not guarantee the best assignment
outside the explored set.

Compilation work is the sum of the retained candidate work in each scope, plus
the common pipeline. Candidate storage includes all retained bodies, not only
those being processed by active workers. Bounding each scope controls this cost
without combining independent searches.

## Candidate regions and ownership

`waveamdmachine.materialization_candidates` holds the concrete alternatives for
one scope. Each candidate is a complete replacement for that scope, including
its results, control flow, memory effects, and token dependencies. Exactly one
candidate is selected.

The wrapper is isolated from values defined above it (`IsolatedFromAbove`). Its
operands own the external SSA uses. Each candidate receives distinct private
block arguments for those inputs and returns the scope outputs through its
yield. Candidates cannot capture external or sibling values directly.

This separation is required for parallel mutation. Cloning or replacing an
operand changes the referenced value's use list. Separate block arguments let
workers change candidate bodies without racing on shared external use lists.
The wrapper boundary and private inputs are created serially. Workers own only
their candidate contents; wrapper signatures and surrounding IR remain shared
and cannot be changed by those workers.

The wrapper has recursive memory effects. Generic effect queries include its
candidate bodies conservatively, while execution selects only one body. Region
branch interfaces expose the corresponding dataflow: inputs can enter any
candidate, candidate yields return to the wrapper results, and there are no
edges between candidates or around all candidates. Scores do not change this
reachability before collapse.

## Compilation flow

The compilation order is:

1. Construct proved equivalent Wave values and required memory alternatives.
2. Select machine instructions while preserving value choices.
3. Run common machine optimizations, which can also produce choices.
4. Form scopes and expand assignments into isolated candidate regions.
5. Clean up each specialized candidate.
6. Schedule candidates, record their cycle scores, and collapse each wrapper.
7. Finish the selected code, allocate registers, and emit machine code.

Choice lowering preserves the choice directly; it does not perform the search.
Expansion occurs after common machine optimizations and before scheduling.
Every scheduled candidate is fully specialized. Functions without choices need
no candidate wrapper or cloning.

Candidate cleanup uses the upstream composite fixed-point pass. It repeats
dead-value removal, canonicalization, and common-subexpression elimination.
When canonicalization removes a memory user, the next iteration can remove
its dead loop carries. The upstream iteration limit applies. Nesting cleanup on isolated wrappers permits
parallel work on independent wrappers. A pass rooted on a wrapper preserves that
root's input and result contract; changes to the shared signature require an
enclosing structural rewrite. Transformations must not move candidate-dependent
work outside the wrapper or combine sibling candidate bodies.

A rejected recurrence can leave a dead cycle through loop arguments and yields.
Dataflow liveness and region-branch canonicalization remove that cycle. The full
canonicalization surface remains available. Cleanup must preserve live controls,
required token dependencies, loop metadata, and zero-trip results. It must not
leave temporary poison operations for machine emission.

## Scheduling and scoring

The scheduler treats a candidate wrapper as an opaque separator in its ordinary
operation walk. Each candidate receives a copy of the same incoming model state
and runs the normal scheduling workflow in parallel. State includes pending
memory events, value readiness, resource use, and issue position.

Candidate selection adds no alternative-specific scheduling strategy, target
ranking, iteration replay, or trip-count weighting. A score sums the ordinary
scheduler's completion-cycle increments for the candidate's scheduling regions.
All candidates use the same target and launch settings. The target model owns
latency, occupancy, resource, and stall policy.

The scheduler selects the lowest cycle score. Stable region order breaks ties;
worker completion order does not affect selection. It adopts the winner's model
state, maps the scope outputs, and continues the walk. Ordinary scheduling-region
resets remain unchanged. A wrapper boundary does not force pending work to drain.

The score belongs to the scheduled candidate body. No graph-changing pass runs
between scoring and collapse. Collapse preserves the winner's instruction order
and reconnects it to surrounding SSA values serially. It does not reschedule the
winner.

The unscheduled pipeline selects the first equivalent assignment, cleans up that
candidate, and collapses it without a scheduling score. This deterministic
selection does not give the first alternative a different semantic role.

## Final code and failures

Register allocation, spill repair, and emission run only on selected code.
Pre-allocation pressure and instruction counts are not additional candidate
ranking terms. A cycle score predicts scheduling cost; it does not prove final
occupancy or measured hardware performance.

Malformed choices, unsupported required lowering, broken mappings, and pass
failures terminate compilation. They are not expensive candidates that can be
ignored when another candidate succeeds. A comparison requires valid scores;
a single remaining candidate needs no comparison. If the selected code fails
allocation or emission, compilation fails rather than retrying losing candidates.

Value choices, candidate wrappers, and yields are resolved before final
allocation and emission. The result follows the ordinary machine-code pipeline.
