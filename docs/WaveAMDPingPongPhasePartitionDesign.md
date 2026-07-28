# WaveAMDMachine ping-pong phase partitioning

## Status

Design only.

The proposed pass partitions selected machine loops into coarse phases before
multi-wave specialization. It inserts scheduling barriers but performs no
scheduling. The normal greedy scheduler later schedules each phase while one
continuous multi-wave model tracks all phases, classes, and loop iterations.

The pass is opt-in through a per-function unit attribute. Unmarked functions
remain byte-stable.

This extends
[WaveAMDMultiWaveSpecializationDesign.md](WaveAMDMultiWaveSpecializationDesign.md).

## Goal

Replace manually placed performance scheduling barriers with deterministic,
target-aware phase partitioning.

Each phase should:

- contain a balanced amount of modeled work;
- expose independent work on multiple resources;
- avoid expensive live-through state;
- remain large enough for normal greedy scheduling;
- preserve every SSA and explicit token dependency.

The partitioner owns only phase boundaries. It does not choose instruction
order, clone code, assign operations to specialization classes, insert runtime
delays, or compare completed schedules by simulated cycle count.

## Non-goals

- Infer memory ordering from addresses or aliases.
- Insert, remove, or split hardware barriers.
- Model cache residency, power throttling, or data-dependent latency.
- Infer `s_setprio` effects before priority arbitration exists in the model.
- Search all graph partitions or all instruction orders.
- Add kernel names, profile names, or operation sequences as heuristics.
- Replace normal greedy candidate selection.

## Terms

**Hard boundary** is control flow, a terminator, `s_setprio`, or an existing
scheduling barrier. Partitioning never crosses one.

**Hardware rendezvous** is a real full or split barrier. It remains inside the
normal scheduler graph and retains its modeled synchronization semantics.

**Auto phase boundary** is a compiler-generated
`waveamdmachine.sched_barrier`. It prevents instruction motion across the cut
but has no runtime issue or rendezvous effect.

**Scheduling interval** is one maximal block-local sequence between hard
boundaries and existing scheduling barriers.

**Phase** is one contiguous portion of a scheduling interval.

**Phase cursor** identifies the phase currently being scheduled for one
specialization class.

**Resource demand** is normalized service work for one modeled resource
domain.

## Invariants

1. Source order remains unchanged before normal scheduling.
2. Every dependency edge stays forward across or within a phase.
3. Memory ordering comes only from SSA and explicit token edges.
4. Auto phase boundaries never become hardware instructions.
5. Auto phase boundaries never rendezvous modeled waves.
6. Model state crosses auto phase boundaries unchanged.
7. Each class uses the normal greedy step implementation inside every phase.
8. Specialization branches contain identical phase structure.
9. Real barriers retain paired lineage and rendezvous semantics.
10. Search work has fixed bounds independent of schedule convergence.
11. No completed greedy order is rejected using a later full-cycle score.

## Enablement

The scheduled backend always runs:

```text
waveamd-machine-pingpong-partition
```

Only functions carrying:

```text
waveamdmachine.enable_pingpong_partition
```

are candidates. The unit attribute is per function, matching
`waveamdmachine.enable_multi_wave_specialization`.

Initial implementation also requires:

```text
waveamdmachine.schedule_input
waveamdmachine.enable_multi_wave_specialization
```

The partition attribute does not imply specialization. A function explicitly
requesting ping-pong partitioning without multi-wave specialization is
malformed and receives a diagnostic. Generators and calibration tools stamp
both attributes when the option is selected.

Unmarked functions are not analyzed. Unsupported marked loops use one phase
and receive a report reason; malformed target or attribute data is an error.

No profile enables the attribute implicitly. Selection belongs to the kernel
configuration or command line.

## Pipeline Position

The pass operates on selected WaveAMDMachine IR:

```text
waveamd backend preschedule
waveamd-machine-pingpong-partition
waveamd-machine-multi-wave-specialize
waveamd-machine-schedule
waveamd-mfma-packed-peephole
waveamd backend postschedule
```

Running before specialization guarantees both cloned arms receive identical
phase boundaries. Running after machine selection gives the partitioner exact
scheduling classes and target resource descriptions.

The pass must run after all transformations that materially change the coarse
instruction mix. Later peepholes may combine instructions only within one
phase.

Existing `wave.transform.pingpong_score` and
`wave.transform.insert_pingpong_barriers` remain explicit transform-dialect
tools. The production pass does not call their contiguous-functional-unit
heuristic.

## Qualification

The pass examines the same top-level `waveamdmachine.uniform_loop` chunks used
by multi-wave specialization.

An interval is eligible when:

- the enclosing function has all required attributes;
- target topology and scheduling data resolve;
- every instruction has a supported scheduling class;
- the block has deterministic source order;
- register widths needed for cut pressure are known;
- structured regions and real barrier lineage are unambiguous.

Nested blocks are partitioned independently. No phase crosses a structured
region boundary. Unsupported intervals remain one phase.

Existing scheduling barriers are hard cuts for partition analysis. The pass
does not move or remove them. Once automatic partitioning is validated for a
kernel, performance-only manual barriers can be removed from its source.

## Dependency Graph

Partitioning reuses the normal scheduler graph construction:

- SSA edges;
- explicit memory-token edges;
- singleton register edges;
- EXEC edges;
- loop-carried recurrence edges.

No new dependency kind is introduced.

The original block order provides the coarse linearization. The partitioner
only inserts barriers between existing operations. It never reorders graph
nodes.

A cut is legal when no non-recurrence edge points from the suffix to the
prefix. Loop recurrences are charged to the phase containing their source and
recorded as cross-iteration state.

## Resource Demand

Each instruction contributes demand to every resource reported by the target
schedule model. Demand uses resource scope, capacity, issue duration, and
specialization-class multiplicity.

For resource `r`:

```text
demand_r(op) =
    units(op, r) * issue_duration(op, r) * cohort_multiplicity(r)
    / effective_capacity(r)
```

`effective_capacity` accounts for the number of wave, SIMD, SIMD-pair, or CU
instances available to the modeled occupancy. Calculations use fixed-point
integers.

Phase demand is additive:

```text
D_r(phase) = sum demand_r(op)
```

The phase work lower bound is:

```text
work(phase) =
    max(critical_path(phase), max_r D_r(phase))
```

This is a partitioning estimate, not a replacement for instruction-state
queries during greedy scheduling.

Memory queue occupancy and value-ready latency are not additive. The
partitioner records their cut state as penalties; the normal scheduler and
continuous execution model handle exact ordering.

## Useful Phase Shape

Equal instruction counts are not balanced work. Equal scalar work estimates
are also insufficient when every instruction uses the same saturated
resource.

An eligible phase should expose at least one pair of incomparable ready
subgraphs using different resource domains. A phase without cross-resource
choice cannot produce complementary class schedules and is merged with an
adjacent phase when legal.

The resource mix test uses graph reachability and target resource identity. It
does not match operation names.

Small bookkeeping operations contribute their modeled cost but cannot make an
otherwise homogeneous phase qualify.

## Cut Cost

Every legal cut records:

- prefix and suffix work;
- maximum normalized resource demand;
- VGPR and AGPR dwords live through the cut;
- SGPR and singleton-register state live through the cut;
- critical dependency edges crossing the cut;
- memory values and tokens crossing the cut;
- number of independent cross-resource choices on each side.

Cut ranking is deterministic and lexicographic:

1. minimize maximum phase work;
2. minimize phase-work spread;
3. minimize maximum live-through VGPR and AGPR dwords;
4. minimize critical edges crossing cuts;
5. minimize memory values crossing cuts;
6. maximize cross-resource choice inside every phase;
7. prefer earlier source positions.

Register classes remain separate in the ranking. AGPR/VGPR bank assignment is
not predicted by the partitioner.

## Bounded Partition Search

Initial specialization has two classes. Initial partition search therefore
evaluates:

- one phase: no automatic barrier;
- two phases: one automatic barrier.

One phase is always a valid fallback.

For the two-phase candidate, the partitioner finds the cumulative-work
midpoint and examines a fixed number of legal cuts on either side. The window
is an implementation constant, not a pass option. Candidate count and class
count stay fixed.

Complexity is:

```text
O(nodes + edges + candidate_window)
```

per scheduling interval. No dynamic programming over all cut pairs, schedule
enumeration, convergence loop, or full event simulation runs in this pass.

More than two automatic phases requires separate model and performance
evidence. It must retain a fixed phase-count bound.

## Materialized Boundaries

The selected cut receives:

```text
waveamdmachine.sched_barrier
    {waveamdmachine.auto_pingpong_phase = <ordinal>}
```

Phase ordinals are block-local and stable. The marker is compiler-owned and
transient.

No barrier is inserted when:

- no two-phase candidate passes the phase constraints;
- either phase lacks useful cross-resource choice;
- cut pressure exceeds the target occupancy budget;
- the interval is too small to contain two model-relevant phases;
- required target data is unavailable.

The pass reports the reason when partition diagnostics are enabled.

## Specialization

The existing clone pass copies auto phase barriers and their ordinals into
both branches. It performs no partition analysis and no scheduling.

Before joint scheduling:

- branch phase counts must match;
- corresponding phase ordinals must match;
- corresponding phase graphs must have the same shape;
- hard barrier lineage must match independently of phase metadata.

Mismatch is a compiler error. The scheduler never repairs divergent phase
structure.

## Fine Scheduling

Each `(class, phase)` owns an ordinary `GreedyOrderState`. Candidate selection,
stall filling, recurrence handling, latency priorities, compute-resource
priorities, and pressure retries use the same functions as an unsplit region.

The phase coordinator owns only:

- current phase cursor for each class;
- entry execution state for each phase;
- transition to the next phase when one class finishes;
- hardware-barrier rendezvous;
- completion of the whole phase sequence.

The coordinator contains no operation classifier, kernel rule, or alternative
candidate selector.

When class `c` finishes phase `p`, its cursor advances to phase `p + 1`.
Another class may remain in phase `p`. The next normal greedy step may
therefore schedule different phase indices for different classes against the
same shared model.

This models runtime cross-phase overlap. Compilation does not force classes
to reach a scheduling barrier together.

## Continuous Model State

One `MultiWaveExecutionState` covers the complete specialized loop.

Crossing an auto scheduling barrier preserves:

- per-wave current cycle;
- operand-ready cycles;
- M0, EXEC, VCC, and SCC state;
- memory counters and pending memory events;
- wave-local issue queues;
- shared resource calendars;
- round-robin arbitration cursor;
- per-class arrival skew.

Crossing an auto barrier performs no query, commit, cycle advance, queue
drain, or rendezvous.

A real hardware barrier remains an instruction. A class frontier stops after
issuing it. Once every required class reaches the matching barrier lineage,
the model performs its existing rendezvous.

Fresh model state at every phase entry is invalid.

## Steady State

Steady-state replay covers:

```text
all phases
all classes
all resident placements
loop backedge
```

Replay uses per-class phase cursors and the same shared resource state as first
iteration scheduling. Loop-carried values bind only after that wave finishes
the final phase.

Refinement retains the existing fixed iteration and round limits. A changed
phase order causes replay of the complete phase sequence. Simulated totals
never veto a completed greedy order.

## Register Pressure

Partition-time live-through pressure rejects obviously bad cuts. Final
pressure legality remains owned by the normal scheduler and register
allocator.

Pressure retry is phase-sequence scoped:

1. Schedule phases using current greedy policies.
2. Run normal pressure validation for each class.
3. Disable the first responsible greedy policy when required.
4. Rebuild the affected sequence with continuous model state.
5. Keep original order when normal fallback requires it.

No phase-specific spill rule or allocator path is added.

Branch-local values in opposite specialization arms remain disjoint under
ordinary `uniform_if` allocation semantics.

## Packing Interaction

Auto machine barriers constrain `waveamd-mfma-packed-peephole`, which runs
after scheduling. It may not combine operations from different phases.

`wave-form-packed-math` currently runs before machine selection and therefore
cannot see automatically generated machine barriers. Removing Wave-level
manual barriers requires a separate general guarantee that early root pairing
does not create excessive live-through state.

The partition pass must not become a hidden legality fix for early packing.
Completion criteria include either:

- early packing is independently pressure-safe without manual barriers; or
- phase discovery is made available before early packed formation through a
  structural, target-backed interface.

Operation-name matching is not acceptable.

## Priority Staggering

Phase partitioning does not create the initial wave stagger.

Existing explicit `s_setprio` and conditional barrier protocols remain
separate kernel behavior. `s_setprio` is a hard scheduling boundary.

Automatic priority placement is unsupported until the multi-wave model tracks:

- current hardware priority per wave;
- target priority arbitration;
- priority changes from `s_setprio`;
- interaction with round-robin issue selection.

Scheduler `priorityStall` fields do not represent hardware wave priority.

## Diagnostics

Optional reporting prints one line per interval:

```text
waveamd-machine-pingpong-partition
func=<name> block=<n> interval=<n>
action=<split|keep>
reason=<reason>
cut=<source-index>
left-work=<n> right-work=<n>
live-vgpr=<n> live-agpr=<n>
```

Reports contain no profile names.

Stable reasons include:

- `missing_specialization`
- `unsupported_target`
- `unsupported_interval`
- `no_admissible_split`
- `insufficient_resource_choice`
- `cut_pressure`
- `split`

## Determinism

- Traverse blocks and operations in IR order.
- Canonicalize dependency-edge order.
- Iterate resource kinds in enum order.
- Use integer costs.
- Use source position as final tie-break.
- Never iterate unordered containers when selecting a cut.

Equivalent input and target data produce identical phase boundaries.

## Verification

After partitioning:

- only marked functions changed;
- operation order is unchanged;
- phase ordinals are dense within each block;
- every auto barrier lies inside an eligible interval;
- every graph edge remains forward;
- no real barrier metadata changed.

After specialization:

- corresponding branch phase ordinals match;
- corresponding phase graphs match;
- real barrier signatures match.

After scheduling:

- every node appears once in its class order;
- no node crosses its phase boundary;
- model state crosses auto barriers;
- only real barriers rendezvous;
- every class finishes every phase;
- phase metadata is removed before final lowering.

## Tests

### Partitioning

- Unmarked function remains byte-identical.
- Marked function without specialization is rejected.
- Equal op counts with unequal modeled work split by work.
- MFMA, VALU, LDS, and VMEM synthetic mixtures use target capacities.
- Homogeneous resource runs remain one phase.
- High live-through cut loses to a slightly less balanced cut.
- Explicit token edges remain unchanged.
- Structured regions and real barriers remain hard boundaries.
- Tie-breaking is deterministic.
- Search-window and phase-count bounds are enforced.

### Joint Scheduling

- Both branches receive identical phase ordinals.
- Different classes may occupy adjacent phases concurrently.
- Shared MFMA and LDS calendars cross an auto phase boundary.
- Pending DMA and value-ready state cross an auto phase boundary.
- Auto barriers do not rendezvous wave cycles.
- Real barriers still rendezvous matching lineage.
- Single-phase output matches normal multi-wave scheduling.
- Every phase advance calls the normal greedy step implementation.

### Pressure And Packing

- Cut-pressure ranking accounts for VGPR and AGPR widths.
- Pressure retry rebuilds downstream phase entry state.
- Post-schedule packed peephole cannot cross an auto phase barrier.
- Early packed formation remains safe after manual performance barriers are
  removed.

### End To End

- Opt-in four-wave GEMM passes random and HPL correctness.
- Opt-in eight-wave FlashAttention passes random correctness.
- Perf goldens record selected boundaries and final assembly.
- Full performance sweep has no unmarked binary drift.
- Marked kernels match or beat their manual-barrier baselines.
- Compile-time scaling remains linear in interval size.

## Implementation Slices

1. Add pass and per-function opt-in attribute.
2. Share scheduler graph and target resource-demand helpers.
3. Implement bounded two-phase cut selection and reporting.
4. Insert stable auto phase barriers before specialization.
5. Add per-class phase cursors to the joint coordinator.
6. Carry one multi-wave state across the complete phase sequence.
7. Extend bounded steady-state replay across phase cursors.
8. Preserve phase boundaries through the post-schedule packed peephole.
9. Add synthetic, Integration, PerfGolden, and compile-time coverage.
10. Remove manual performance barriers only after matched correctness and
    performance validation.

## Rejected Designs

**Instruction-count balance.** Machine instructions have different latency,
capacity, scope, and issue duration.

**Contiguous functional-unit runs.** Homogeneous phases remove the independent
resource choices ping-pong scheduling needs.

**Fresh model per phase.** Drops queue state, shared reservations, and wave
skew at every generated boundary.

**Phase rendezvous.** `sched_barrier` has no runtime synchronization effect.

**Partition after cloning.** Independent branch analysis can produce different
phase structure.

**Partition after scheduling.** Boundaries cannot improve the order already
chosen.

**Post-greedy cycle selection.** Full simulation may report diagnostics but
never replaces or vetoes greedy orders.

**Kernel-pattern qualification.** Enablement is per-function and cost is
target/model driven.
