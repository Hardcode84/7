# WaveAMDMachine multi-wave specialization

## Status

Scoped hardware model, clone pass, joint greedy scheduling, barrier rendezvous,
and paired barrier cleanup implemented. Scheduled pipelines always run the
clone pass; a function unit attribute opts kernels in. Synthetic WaveAMDMachine
and Integration fixtures cover the stack.

No profile names, operation patterns, or schedule-order policies drive
qualification.

Current model provides:

- explicit `(SIMD, slot)` placements;
- separate wave-local instruction state and shared resource calendars;
- SIMD issue and optional pipe domains;
- CU issue and SIMD-pair LDS-DMA issue domains;
- target-declared round-robin wave arbitration;
- `wouldStall(wave, op)` admission over shared resource state;
- bounded joint greedy refinement and loop replay;
- clone-only specialization before the normal scheduler.

Replay and refinement use fixed iteration counts. Candidate search has a fixed
per-step bound. Region size is uncapped; compile work scales with input IR and
never iterates to convergence.

## Goal

Build several static schedules for one code chunk while modeling all resident
waves and their shared machine resources.

Primary case: two schedules selected by SIMD identity. When one schedule has a
shared resource busy, the other can put an independent operation at its next
issue point.

The optimization must:

- preserve the source dependency graph in every schedule;
- model wave-, SIMD-, SIMD-pair-, and CU-scoped resources separately;
- account for total target occupancy;
- clone before scheduling and let the normal greedy scheduler co-schedule both
  marked branches;
- keep scheduling and steady-state replay bounded;
- materialize ordinary `waveamdmachine.uniform_if` control flow;
- require no specialization support from register allocation;
- preserve identical barrier protocols across all branches.

This is static co-scheduling. Generated waves cannot inspect resource occupancy
and choose an operation at runtime. Hardware selects a wave, then executes that
wave's fixed instruction stream.

## Terms

**Placement** is one modeled resident wave slot: `(SIMD, slot-on-SIMD)`.

**Specialization class** is one generated instruction order. Several placements
may execute the same class.

**Resource domain** is the hardware instance against which a reservation is
made. Domain follows resource scope: wave, SIMD, SIMD pair, or CU.

**Barrier signature** is the ordered barrier protocol for one cloned chunk,
including structured region path, original site, and full or split form.

## Invariants

1. Every class is a topological order of the same explicit SSA/token graph.
2. Memory ordering comes only from SSA and explicit token edges.
3. Wave-local state never leaks between placements.
4. Shared reservations contend only in their declared hardware domain.
5. Every specialization branch has the same barrier signature.
6. Barrier-count or barrier-protocol rewrites commit in every branch or none.
7. Greedy choices see shared-resource pressure directly. No post-greedy cycle
   simulation may veto or replace an order.
8. Class count, occupancy, candidates per step, refinement, and replay have
   fixed bounds.

## Current Architecture

`waveamd-machine-multi-wave-specialize` clones eligible top-level loops into a
marked `uniform_if`. It preserves source order and performs no scheduling.

`waveamd-machine-schedule` collects marked branch pairs before ordinary local
regions. It builds one graph per branch, verifies structural equality, then
runs both class frontiers against one `MultiWaveExecutionState`. The marker is
removed after orders are applied.

Explicit placement keeps wave-local memory admission queues and adds shared
calendars. It disables occupancy proxies such as `smoothLdsDmaIssue`; shared
placements already provide that occupancy.

## Topology And Occupancy

`ArchData` describes the scheduling topology:

```text
simdsPerCU
wavesPerSIMD
SIMD issue period
CU issue capacity
resource instances, scopes, capacities, and service times
hardware-ID fields used by class dispatch
wave issue arbitration policy
```

`waveamdmachine.target_waves` remains the target resident-wave count per SIMD.
It is not a workgroup wave count. For a full CU, modeled placement count is:

```text
simdsPerCU * target_waves
```

The value must not exceed `ArchData::wavesPerSIMD`. Unknown or inconsistent
topology disables specialization; it does not fabricate a placement.

`wave.waves_per_workgroup` and known workgroup shape describe workgroup
cohorts. Target placement data maps those cohorts onto resident placements.
Multiple workgroups may fill the target occupancy.

Class mapping is separate from placement. A two-class CDNA example is:

```text
SIMD 0 -> class 0
SIMD 1 -> class 1
SIMD 2 -> class 0
SIMD 3 -> class 1
```

At `target_waves = 1`, this creates four placements with two instances of each
class. At `target_waves = 2`, it creates eight placements; both slots on one
SIMD use that SIMD's class. Class multiplicity participates in every shared
reservation.

The mapping is target topology, not GEMM policy. Current IR specialization uses
two classes. Model placement count follows target occupancy.

## Scoped Resource Model

Split local instruction state from resource calendars:

```cpp
struct WaveExecutionState;
struct ResourceCalendar;

struct WavePlacement {
  unsigned simd;
  unsigned slot;
  unsigned classId;
};

struct MultiWaveExecutionState {
  SmallVector<WaveExecutionState> waves;
  SmallVector<ResourceCalendar> resources;
};
```

`WaveExecutionState` owns:

- SSA value readiness;
- token and wait-counter state;
- M0 and store-data hazards;
- wave-local issue position;
- other state whose identity is one dynamic wave.

`ResourceCalendar` owns capacity reservations for one resource domain.
Examples include one SIMD execution pipe, one SIMD-pair LDS-DMA issue path, or
one CU issue domain. Exact scope is target data.

Instruction description returns every resource use:

```cpp
enum class ResourceScope : uint8_t { Wave, SIMD, SIMDPair, CU };

struct ResourceUse {
  ResourceId resource;
  ResourceScope scope;
  unsigned units;
  int64_t issueDuration;
  int64_t retireLatency;
};
```

Capacity and duration are distinct. LDS-DMA queue occupancy and retirement stay
wave-local; shared SIMD-pair cadence reserves only issue bandwidth.

`query(placement, op)` combines:

- operand and token readiness from the placement's wave state;
- wave, SIMD, SIMD-pair, and CU issue availability;
- all shared resource calendars selected by placement and scope.

`commit(placement, op)` updates that wave state and only the selected resource
domains. Query remains side-effect free.

Single-wave clients retain wave-local queue behavior. Explicit multi-wave
clients share the scoped calendars while reusing the same SSA, token, wait, and
hazard implementation per placement.

## Joint Greedy Scheduling

Build one dependency graph per cloned branch. Canonical edge order removes
MLIR use-list order from graph identity. Structurally unequal graphs fail before
either order changes.

Each class gets independent `ready`, `pending`, `scheduled`, and output-order
state. Scheduling never clones IR.

The runtime model contains one `WaveExecutionState` per placement. Placements
of one class share the class's static order but keep independent dynamic state.
All placements share scoped resource calendars.

At each greedy step:

1. Extend the next caught-up class under rotating class priority.
2. Start from that class's bounded single-wave greedy priority.
3. Ask `wouldStall(wave, op)` for the target-selected physical wave.
4. On a stall, search a fixed number of ready alternatives in priority order.
5. Append the selected operation to that class's static order.
6. Commit that operation across every placement using the class before another
   class chooses; shared reservations then reflect full class multiplicity.
7. If only barriers are exposed, extend classes until the paired rendezvous.

Multi-wave concerns stay inside the model. Greedy sees only stall admission; it
never asks whether an operation is MFMA, LDS DMA, or a GEMM load. Saturating one
shared resource naturally admits ready work using another.

Lockstep means one shared scheduling timeline and coordinated class frontiers.
It does not mean strict alternation. One chosen node covers its full class
cohort before the next class choice. Independent SIMD-scoped operations on
different SIMDs may occupy the same cycle when CU capacity permits.

Modeled wave arbitration is explicit target data. The compiler does not own
runtime issue choice. Unknown arbitration is unsupported for specialization;
a favorable invented issue trace is not evidence.

### Steady State

Loop scheduling reuses the existing bounded steady-state mechanism. Replay all
placements together so backedge readiness and shared queues cross the same
iteration boundary.

Keep fixed constants for:

- replayed iterations;
- refinement rounds;
- fillers per stall target;
- specialization classes;
- resident placements;
- candidates examined per greedy step.

No convergence loop runs until a state happens to stabilize. Complexity is
bounded by these constants and region size.

### Pressure

Validate pressure independently for each class. Maximum branch pressure
determines whether the requested `target_waves` remains valid. A failed check
keeps both original orders.

This is scheduler input, not a later cycle-based order veto.

## Code Chunk

Initial unit is one complete top-level `waveamdmachine.uniform_loop` plus any
required loop-local scheduling regions.

Loop-only cloning keeps shared:

- kernel entry and ABI setup;
- address and descriptor setup;
- epilogue and stores;
- code outside the hot recurrence.

Every loop operand is a branch live-in. Every loop result is yielded from each
`uniform_if` arm. Types and result positions are identical because both arms
come from the same source operation.

If a required live-out type is not supported by `uniform_if`, extend the op's
generic IR, verifier, and lowering contract. AGPR result support, when needed,
is ordinary `uniform_if` support. Do not clone a whole kernel merely to avoid
that work.

Whole-kernel cloning is deferred. It increases code size and duplicates setup
without proving that cross-loop phase matters.

## Specialization IR

The function-gated clone pass runs before scheduling:

1. Validate target topology, workgroup occupancy, loop shape, and barrier
   lineage.
2. Read the target hardware-ID field through `s_getreg_hw_id`.
3. Build a wave-uniform class condition.
4. Create a marked `waveamdmachine.uniform_if`.
5. Move the source loop into one arm and clone it into the other.
6. Yield both loop result sets and replace original uses with `uniform_if`
   results.

The marker identifies compiler-generated paired branches for barrier cleanup.
It is not an optimization knob and carries no scheduling policy.

Unsupported topology or loop shape leaves the original loop unchanged. A
malformed barrier lineage fails before rewriting.

Dispatch and branch overhead sit outside the recurring loop body. Target data
provides the SIMD-ID slice; do not branch on chip-name strings.

## Register Allocation

No wave-specialization regalloc path exists.

`uniform_if` already represents mutually exclusive control flow. Generic live
interval construction must give it normal semantics:

- live-ins interfere with values in either arm;
- branch-local values in opposite arms do not interfere;
- yielded values meet at the region result;
- values live across the conditional remain live across both arms.

Do not add mutually-exclusive allocation groups, positional branch pairing, or
hidden allocator attributes. Failure to allocate disjoint `uniform_if` arms is
a generic regalloc bug.

## Barriers

Scheduling needs no specialization-specific barrier fence. Both arms clone the
same code chunk and therefore start with the same barrier sites and dynamic
structure. Each class still obeys the same SSA/token graph.

The hazard is later cleanup. Current `waveamd-barrier-cleanup` walks blocks
independently. Different schedules can make a full-barrier pair or a split
arrive/wait pair collapsible in one arm but not the other. Independent cleanup
could then change barrier count or protocol for only part of a workgroup.

Barrier cleanup must become paired for marked specialization conditionals.

Before cloning, assign each barrier site a stable ordinal within the code
chunk. Cloning preserves the ordinal in both arms. The marked `uniform_if`
uses `waveamdmachine.paired_barriers`; full/arrive/wait ops carry sorted
`waveamdmachine.barrier_sites`. Merges union disjoint site sets. Both
attributes are transient and compiler-owned.

Paired cleanup uses analysis then commit:

1. Collect corresponding barrier sites from every arm.
2. Build the normal merge plan independently for every arm.
3. Accept a merge only when the same original sites can merge in all arms.
4. Commit all corresponding rewrites as one transaction.
5. If any arm cannot merge, merge none.
6. Recompute paired site groups after a successful merge.

This applies to both transformations performed by cleanup:

- collapse redundant `s_barrier` pairs;
- collapse `barrier_arrive` / `barrier_wait` back to `s_barrier`.

Merged token dependencies may differ between arms; each plan must preserve its
arm's explicit token graph. Site identity and resulting protocol must match.

After cleanup, a pass check compares barrier signatures across all marked
arms. Mismatch is a pass failure. This is transform validation, not an
individual barrier verifier: the check reads multiple operations and regions.

Remove transient site metadata only after that check. Any later transform that
changes barrier count or protocol must use the same all-arms rule. Final
machine lowering must never see mismatched signatures.

## Pipeline

Required relative order:

```text
waveamd-split-barriers
preschedule cleanup and hazard repair
waveamd-machine-multi-wave-specialize
waveamd-machine-schedule
paired waveamd-barrier-cleanup
barrier-signature validation
waveamd-materialize-split-barriers
ordinary regalloc and backend lowering
```

Split barriers before cloning retain one shared `barrier_init` identity; cloned
arrive/wait operations capture that identity. Paired cleanup decides whether
all arms keep the split protocol or all arms return to a full barrier.

## Enablement And Fallback

The scheduled backend always runs the pass. Only functions carrying
`waveamdmachine.enable_multi_wave_specialization` are candidates; unmarked
functions are unchanged. Matmul generators and calibration tools expose
`--multi-wave-specialize` to stamp that unit attribute. Profiles do not stamp
it implicitly.

Specialization requires:

- supported target topology and hardware-ID mapping;
- valid target occupancy;
- a complete supported loop chunk;
- pressure within the requested occupancy budget.

Unsupported structure keeps the normal single schedule. Malformed target or
resource data remains a diagnostic.

Class count stays fixed at two. Cloned region size has no cap. Do not run a
second full simulation after greedy scheduling and select whichever order has
fewer modeled cycles.

## Verification

During joint scheduling:

- every class schedules every graph node exactly once;
- every dependency edge is forward in every class order;
- all classes use the same source graph and region structure;
- placement count and class multiplicities match target occupancy;
- every resource reservation resolves to a valid domain;
- every class stays inside the pressure budget.

After cloning:

- branch result types and positions match;
- branch-local values do not escape except through yields;
- hardware-ID dispatch is wave-uniform;
- barrier site ordinals match across arms.

After barrier cleanup:

- barrier signatures match across arms;
- no transient barrier-site metadata remains before final lowering.

## Tests

### Resource Model

- Wave-local M0, tokens, and wait counters do not cross placements.
- Same-SIMD resources contend between resident waves.
- Same-pair LDS-DMA issues contend; different SIMD pairs issue independently.
- Different-SIMD private resources do not contend.
- CU resources contend across every placement.
- Class multiplicity reserves the expected capacity.
- Query is side-effect free; commit mutates only selected domains.
- Queue acceptance and retirement use separate timing.

### Scheduler

- Shared saturation selects a ready operation using another resource.
- SIMD-private work issues concurrently where target capacity allows.
- Class priority rotates and output is deterministic.
- Unmarked functions remain unchanged.
- Marked functions clone regions larger than 2,048 operations.
- Scheduler consumes the clone marker and applies both orders.
- Explicit token edges remain forward in every class.
- Candidate, replay, and refinement limits are enforced.
- No operation-name or kernel-shape eligibility appears in diagnostics.

### Barriers

- Different schedules preserve the same unmerged barrier signature.
- Full barriers merge in both arms when both plans are legal.
- Full barriers merge in neither arm when only one plan is legal.
- Split barriers collapse in both arms when both plans are legal.
- Split barriers collapse in neither arm when only one plan is legal.
- Deliberately mismatched signatures fail before scheduling.

### End To End

- `uniform_if` branch locals reuse registers without specialization attrs.
- Synthetic Integration fixtures exercise paired cleanup and scoped resources.
- Target tests cover large-region bounds, determinism, and fallback.
- Function qualification remains separate from kernel profiles.

## Implementation Slices

1. Scoped resource descriptions and multi-placement query/commit.
2. Explicit-placement occupancy model with single-wave wrapper retained.
3. Clone-only specialization pass.
4. Bounded joint greedy scheduling in the normal scheduler.
5. Transactional paired barrier cleanup.
6. Synthetic integration, code-size, and compile-time gates before kernel use.

## Rejected Shapes

**SIMD-parity operation policy.** Pattern-specific ordering does not model the
resource conflict and cannot generalize.

**Shared `InstructionExecutionState`.** It aliases wave-local SSA, M0, and wait
state across waves.

**Independent branch cleanup.** It can change barrier count or protocol in one
arm only.

**Special regalloc groups.** Structured branch exclusivity already carries the
required semantics.

**Post-greedy simulation veto.** Model improvements belong in resource preview
and greedy selection.

**Unbounded periodic simulation.** Fixed replay and refinement limits already
cover the required steady-state view.
