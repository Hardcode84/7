# WaveAMD RegAlloc

WaveAMD regalloc assigns physical register indices to WaveAMDMachine register
values through an inspectable transform loop:

```text
build-alias-state -> linear-scan -> AGPR -> Remat -> SGPRToVGPR -> LDS -> Scratch
```

Each iteration rebuilds state from current IR, runs deterministic linear scan,
then either commits physical assignments or lets one ordered relief transform
rewrite IR. First relief rewrite wins, clears state, and restarts from alias
state. No hidden C++ plan survives an IR rewrite.

## Contract

Tracked values have type `!waveamdmachine.reg<sgpr|vgpr|agpr, width>` with no
physical index. Successful allocation rewrites tracked results to
`!waveamdmachine.reg<class, width, index>`.

`width` is a count of contiguous 32-bit registers. `index` is the physical base;
the occupied range is `[index, index + width)`.

Values already carrying a physical index inside allocation scope are fixed
constraints. Ordinary allocation must not overlap fixed live ranges or use ABI
reserved registers for the wrong purpose.

SCC, VCC, EXEC, M0, memory tokens, barriers, and control-only values are not
normal register-allocation classes. Inputs must satisfy their liveness and
hazard constraints through separate passes.

The module must carry `waveamdmachine.target`. The transform loop processes
non-external `func.func` payload functions independently.

## Budgets

Register budgets come from the target. VGPR allocation is capped to the
addressable VGPR namespace, `v0` through `v255`.

`waveamdmachine.target_waves` narrows SGPR/VGPR budgets to the occupancy budget
for that wave count. It also enables positional VGPR-family accounting where
AGPRs count against VGPR occupancy:

```text
live_vgpr_dwords(position) + live_agpr_dwords(position) <= limit
```

`wave.kernel` reserves the kernel-entry prefix:

- SGPRs for the kernarg segment pointer.
- Optional kernarg preload SGPRs.
- SGPRs for workgroup IDs.
- VGPR0 for workitem ID X.

Ordinary allocation starts after the reserved prefix. Entry ops that materialize
those resources may use reserved registers. Other values may not.

Virtual AGPR allocation requires target AGPR support. Fixed AGPR values remain
fixed constraints.

## State

Regalloc state is a function attribute. It contains:

- operation positions;
- stable value IDs;
- value ranges and register classes;
- alias sets and per-member dword offsets;
- fixed reservations;
- linear-scan assignments or one failure record;
- per-stage metadata counters.

State is ephemeral. Every IR rewrite clears it; the next iteration rebuilds it.
Do not preserve alias sets across rewrites.

Alias state lives in versioned `#wave.regalloc_state`. Fixed-stride op, value,
range, and alias-set records index contiguous path and member slabs. Record
index is the stable ID; C++ field enums define the schema. The outer dictionary
holds stage, failure, assignments, and counters. Legacy dictionary payloads are
accepted only as authored compatibility input.

Value IDs are structural:

- op result: operation path plus result number;
- block argument: region path, block number, argument number.

Marker ops must not consume tracked values only to name them. Such operands are
real uses and corrupt liveness.

## Liveness And Aliasing

Positions use flattened program order with explicit loop-body positions.
`uniform_loop` body positions sit between loop entry and loop exit. External
loop operands used in the body remain live across the backedge.

Each width-N register value lowers to N scalar dword intervals. Tuple lanes and
wide-value lanes can die independently.

Horizontal aliasing means multiple SSA values share one storage slot. Required
alias edges include:

- `uniform_loop` init, body block argument, `continue_if` carry, and result for
  the same carry slot;
- branch/if yielded values and corresponding region result when machine
  semantics require shared storage;
- MFMA accumulator input/result when the op is in-place;
- tuple round trips at matching offsets.

Vertical aliasing means scalar intervals occupy one contiguous physical range:

- width-N value lanes have offsets `[0, N)`;
- tuple elements map to cumulative offsets in the tuple base;
- fixed physical tuple values pin their base and all offsets.

Alias sets allocate as one unit. One alias set has one storage bank and one
physical base plus per-value offsets. Liveness at a position is the live subset
of the set.

If two loop carry slots receive the same SSA init value, duplicate storage
first. SSA identity at loop entry must not merge two logical loop variables.

MFMA accumulator chains may alias input, result, and loop-carried accumulator
storage when operand/result semantics allow it. One accumulator SSA value
feeding multiple chains gives each chain independent storage.

## Interface Banks

Storage bank and op interface bank are separate facts.

Storage bank order:

```text
SGPR < VGPR < AGPR
```

Normal values start in their preferred bank. Relief may force storage into a
different bank, but op operands/results still require the bank dictated by the
machine operation.

Bridge directions:

```text
SGPR storage -> VGPR interface: scalar-to-vector materialization
VGPR storage -> SGPR interface: v_readfirstlane_b32 when legal
VGPR storage -> AGPR interface: v_accvgpr_write_b32_tuple
AGPR storage -> VGPR interface: v_accvgpr_read_b32_tuple
```

Some bridge directions are not legal for all values. If no legal bridge exists,
that value is not a candidate for that relief path.

Inserted bridge, remat, spill-store, and spill-load values are normal IR. The
next iteration sees their pressure through rebuilt state.

## Linear Scan

Linear scan consumes alias state only.

Success produces a complete assignment map for every allocatable alias set and
applies physical register indices. Failure produces one failure record:

- failed alias set;
- failure position;
- register class or combined VGPR/AGPR mode;
- live pressure and limit;
- requested width;
- overlapping alias sets at the point;
- deterministic diagnostics.

Linear scan does not choose AGPR/remat/LDS/scratch. It reports pressure; ordered
transforms decide whether they can rewrite IR.

Physical occupancy is class-local:

- one live-slot set per physical dword;
- reserved prefixes unavailable to ordinary groups;
- fixed groups placed before virtual groups;
- a candidate base fits when occupied dword live sets do not intersect the
  group's live slots.

## Relief Stages

Relief order is strict:

```text
AGPR -> Remat -> SGPRToVGPR -> LDS -> Scratch
```

Each stage reads current IR plus the latest failure record. A stage either
rewrites IR immediately or declines. Relief size is not a filter; a legal
rewrite may be accepted even when it does not solve the whole failure alone.

Candidate ranking is local to one stage:

- legality and resource budgets first;
- bridge count;
- loop-scaled bridge or load/store cost;
- latency or instability penalties when local and deterministic;
- stable tie-breakers.

There is no global ranking across relief stages.

### AGPR

AGPR relief moves eligible VGPR-family pressure into AGPR storage.

Legality:

- target has AGPRs;
- no fixed physical values or ABI-reserved entry values;
- no unpromotable AGPR write users;
- AGPR value can be defined directly or through `v_accvgpr_write_b32_tuple`;
- every non-AGPR user can read through `v_accvgpr_read_b32_tuple`;
- target VGPR-family accounting still fits positionally.

MFMA accumulator/interface-compatible aliases need no bridges. AGPR is pressure
relief; do not demote AGPR back to VGPR as a spill strategy.

### Remat

Remat is reverse CSE for cheap pure WaveAMDMachine DAGs. Candidate roots come
from the failed alias set and overlapping alias sets live at the failure point.
It handles eligible SGPR, VGPR, and combined VGPR/AGPR failures. Profitable
scalar DAG remat therefore runs before SGPRToVGPR promotion.
Each root plan contains the whole alias set, rebuild sites, cloned DAG nodes,
and leaves whose live ranges would extend across the failure. Build root plans
before profitability checks; roots rejected alone may be profitable together.

A relief plan may contain one root or a bundle of roots. A shared extended leaf
amortizes failure pressure. A shared cloned dependency amortizes cost only when
the roots rebuild at the same insertion site. Roots sharing neither stay in
separate plans.

For bundle `B` and register class `c`:

```text
removed_c(B) = sum(width of each distinct root alias set in c)
added_c(B)   = sum(width of the union of newly-live leaf alias sets in c)
after_c(B)   = before_c + added_c(B) - removed_c(B)
```

Count each root and leaf alias set once, independent of root count, rebuild-site
count, or consumer count. A legal bundle strictly lowers pressure for the
recorded failure class or combined register family and does not push another
class across its budget. It need not bring the failure point under budget;
materialize one bundle, clear state, and rerun linear scan.

Bundle selection operates on the bipartite graph from roots to newly-live leaf
alias sets. Consider connected components independently. Select a deterministic
inclusion-minimal profitable subset, then rank bundles by unique loop-scaled DAG
cost, root count, and stable alias-set IDs. Profitability uses union pressure,
never the sum of per-root leaf pressure.

Materialization is atomic for the bundle. Rebuild roots at their post-failure
consumer sites and share cloned dependency nodes only at the same insertion
site. Cache by `(site, original value)`. Sharing across sites is illegal unless
the resulting temporary live range is included in pressure accounting. Cost
each unique `(site, DAG node)` once, plus rewritten uses.

Leaves need not already be live at a rebuild site. Fixed hardware inputs such
as `v_workitem_id_x`, workgroup IDs, and fixed kernarg preload sources are
anchored values. Reuse only when availability and pressure are modeled.

Example: 64 one-dword coordinate roots share one anchored lane-ID leaf. One
root removes one VGPR and adds one VGPR, so it cannot make progress. A two-root
bundle removes two VGPRs while adding the leaf once. After state rebuild, the
lane ID is already live at the failure point and remaining roots add no leaf
pressure.

Rebuilt values are normal IR and can be remat candidates in later iterations.
Provider metadata counts distinct relieved root alias-set widths, not rebuild
slots.

### SGPRToVGPR

SGPRToVGPR owns SGPR pressure and allocated-footprint failures left after remat.
It stores uniform values in VGPRs.

Candidates come from the failed SGPR alias set and its live SGPR overlaps.
Required relief is `pressure - limit` when both fields are present, otherwise
the failure request. Candidate order uses bridge count and cost, loop cost,
live dwords, lifetime end, and stable alias-set IDs. The plan takes candidates
until required relief is covered or legal candidates are exhausted, then
rewrites the whole plan and rebuilds allocator state once.

Legality:

- no fixed physical values;
- no ABI-reserved entry values;
- no unsupported block arguments;
- width support is explicit;
- source value has a legal scalar-to-vector bridge;
- every SGPR use has a legal readback or direct replacement.

Every alias member must be legal and at least one must need repair. A set whose
members already have only canonical promotion moves is not a candidate. Mixed
sets remain repairable: reuse the earliest promotion, move it after the SGPR
definition, and coalesce duplicate promotions. Reused moves are pinned;
new moves carry SGPR-to-VGPR temp provenance.

Materialization replaces VGPR and return uses directly. SGPR users read back
through `v_readfirstlane_b32`; the promotion must dominate each readback.
Function entry arguments change bank in place. Function result types refresh
from the rewritten returns.

Pinned promotion moves cannot be remat roots or cloned inside another remat
DAG. Within a remat plan they remain pressure-accounted leaves. This prevents a
repaired promotion from alternating between SGPR remat and VGPR storage.

### LDS

LDS relief stores VGPR alias sets in compiler-owned shared memory.

Legality:

- target has enough LDS after existing static and dynamic LDS usage;
- extra LDS does not violate requested `target_waves`;
- value is lane-local and reloadable through VGPR LDS ops;
- live range does not cross unsupported region boundaries;
- spill slot address does not create worse pressure than it relieves;
- value width has load/store support.

Current LDS spills split VGPR values by dword into DS addtid slots. Spill LDS is
compiler-owned and disjoint from user LDS. Spill memory ordering uses explicit
tokens for each spill slot chain.

### Scratch

Scratch relief stores VGPR alias sets in private memory.

Legality:

- scratch lowering exists for the target;
- function can use flat scratch/private segment metadata;
- value width has load/store support;
- address calculation has legal SGPR/VGPR temporaries.

Scratch updates private segment size, flat-scratch usage, and metadata. It has
unlimited capacity and is last by stage order.

## Convergence

Loop state determines the next action:

- successful scan: done;
- failure state left by all providers: stalled, return the concrete failure;
- state cleared by a provider rewrite: restart from alias-state construction.

Providers clear state only after a semantic IR rewrite. SGPR promotion repair
pins reused moves so remat cannot undo the rewrite on the next iteration. The
loop still has a `max_iterations` backstop, default 1024, and reports the reached
cap. Raising the cap requires a converging workload, a progress argument, and
compile-time measurements; it is not a cycle repair.

## Memory Spill Rules

LDS and scratch share the memory-spill rewrite shape:

- spill whole alias sets;
- insert real stores after definitions;
- insert reloads before uses;
- thread explicit memory-token edges;
- update LDS/private resource metadata;
- let ticket waits and hazard waits run after regalloc.

First-order region rules stay conservative:

- no spilling values across `exec_if` boundaries unless placement is
  dominance-safe;
- loop-carried spill placement must preserve carry-slot semantics;
- no memory spilling block arguments unless the stage has an explicit placement
  rule;
- multiple region exits require dominated reload placement.

## Overflow And Diagnostics

Default mode is hard fail. If allocation cannot produce a legal result, the
transform loop emits an error and fails.

Soft overflow markers are a diagnostic IR contract. The current transform loop
does not populate them; transform sequences that deliberately continue after an
overflow must set them before post-regalloc consumers run:

- `waveamdmachine.regalloc_overflowed = 1 : i64` on the function;
- `waveamdmachine.regalloc_overflowed_count = N : i64` on the module.

Overflowed functions are diagnostic IR only, not valid input to production
post-regalloc passes.

Regalloc reports use MLIR optimization remarks under category
`waveamdmachine-regalloc`.

Remark names:

- `regalloc-summary`;
- `regalloc-interval`;
- `regalloc-lds-plan`;
- `regalloc-scratch-plan`;
- `regalloc-pressure-failure`.

`regalloc-pressure-failure` contains the overflowing class, class budget,
reserved prefix size, live dwords, program position, requested width, active
overlaps, and memory-spill rejection counts when available. Stage byte counters
are tracked as `wave.regalloc.*.dwords`.

## Verification

Post-regalloc verification is the final gate:

- all pass-owned results are physical;
- aliases in one interval have consistent base plus offsets;
- no class-local live physical interference;
- reserved ABI prefix is used only by allowed entry values;
- overflowed functions are rejected by production consumers.

Consumer scopes:

- resource info requires physical results;
- assembly requires all register values physical;
- hazard waits depend on physical spans for operands they inspect;
- metadata comes from final IR, not allocator state.

Assignment clearing preflights function types before mutation. Defined function
results come from cleared return operands; entry arguments provide input types;
declarations stay unchanged. Multiple returns and direct calls must agree with
the planned types or clearing fails before changing IR. Fixed ABI and marked
values keep their physical indices.

## Non-Goals

- No direct SGPR, SCC, VCC, EXEC, or M0 spilling to memory.
- No occupancy choice. `waveamdmachine.target_waves` is an input constraint.
- No implicit alias analysis for spill memory. Ordering is explicit token edges.
- No hidden post-assembly repair.
- No provider-specific logic in linear scan.
- No deferred relief plans materialized after later scans.
- No string round-tripping of structural regalloc state.

## Coverage And Costs

RegAlloc LIT coverage includes multi-candidate SGPR relief, mixed canonical and
sunk tuple aliases, pinned-promotion convergence, profitable SGPR remat,
signature clearing, and malformed failure fields. Production-loop Integration
coverage translates SGPR overage bundles and repaired aliases through assembly.
Other integration coverage exercises tuple subranges, target-waves, AGPR MFMA
accumulators, bridge codegen, resource info, hazard waits, and metadata.

Compile-time cost grows with alias-set count, live-range density, physical
register scan length, and retry count. Dense live-slot sets and rebuilds after
IR rewrites are the main memory costs for large generated kernels. Stage timing
reports include alias build, scan, AGPR, remat, SGPRToVGPR, LDS, and scratch.
