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

Remat rebuilds cheap pure WaveAMDMachine DAGs.

Candidate is the failed alias set or an overlapping alias set live at the
failure point. The stage finds a cheap pure expression DAG rooted at the
candidate value and clones it at consumers after the pressure point. Rebuilt
values are normal IR and can be candidates in later iterations.

Leaves need not all be live at the rebuild point. Extending cheaper leaves
across the failure point is legal when rebuilt IR lowers pressure there.

Fixed hardware inputs such as `v_workitem_id_x`, workgroup IDs, and fixed
kernarg preload sources are anchored values. Reuse only when availability and
pressure are modeled.

### SGPRToVGPR

SGPRToVGPR relieves SGPR pressure by storing uniform values in VGPRs.

Legality:

- no fixed physical values;
- no ABI-reserved entry values;
- no unsupported block arguments;
- width support is explicit;
- source value has a legal scalar-to-vector bridge;
- every SGPR use has a legal readback or direct replacement.

Materialization inserts vector materialization after the SGPR def and
`v_readfirstlane_b32` before SGPR users that need readback. Bridge temps are
marked so the allocator can avoid cyclic re-promotion.

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

## Non-Goals

- No direct SGPR, SCC, VCC, EXEC, or M0 spilling to memory.
- No occupancy choice. `waveamdmachine.target_waves` is an input constraint.
- No implicit alias analysis for spill memory. Ordering is explicit token edges.
- No hidden post-assembly repair.
- No provider-specific logic in linear scan.
- No deferred relief plans materialized after later scans.
- No string round-tripping of structural regalloc state.

## Coverage And Costs

Coverage comes from RegAlloc LIT tests, integration tests for tuple subranges,
target-waves, AGPR MFMA accumulators, bridge codegen, and post-regalloc
consumers: resource info, hazard waits, metadata, and assembly translation.

Compile-time cost grows with alias-set count, live-range density, physical
register scan length, and retry count. Dense live-slot sets and rebuilds after
IR rewrites are the main memory costs for large generated kernels.
