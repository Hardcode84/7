# WaveAMD RegAlloc Semantics

`waveamd-reg-alloc` assigns physical register indices to
WaveAMDMachine register values. It is a machine-IR pass over `ModuleOp`
and processes every non-external `func.func`. The module must carry a
`waveamdmachine.target` attribute.

## Allocation Domain

Tracked values have type `!waveamdmachine.reg<sgpr|vgpr|agpr, width>`
with no physical index. A successful allocation rewrites tracked op
results to `!waveamdmachine.reg<class, width, index>`.

`width` is a count of contiguous 32-bit registers. `index` is the
physical base. The occupied range is `[index, index + width)`.

Values already carrying a physical index inside pass-owned allocation are
fixed constraints. The pass does not move them. A successful result must
still satisfy them: no ordinary allocation may interfere with a fixed
live range or use a reserved ABI register for the wrong purpose.

SCC, VCC, and M0 are singleton hardware resources, not normal
register-allocation classes. Inputs must have non-overlapping writes to
those resources.

Function-entry register block arguments are not ABI lowering. The pass
allocates register values produced inside the function. Final codegen
requires all register operands and block arguments to be physical, so
virtual entry operands must be lowered or given fixed physical types
before translation.

## Register Budgets

Register budgets come from `waveamdmachine.target`. VGPR allocation is
capped to the addressable VGPR namespace, `v0` through `v255`.

`waveamdmachine.target_waves` may appear on a function or enclosing op.
When present, it narrows SGPR and VGPR budgets to the target occupancy
budget for that wave count. It also constrains VGPR-family high-water
usage across VGPRs and AGPRs according to target accounting. The value
must be a positive integer and must not exceed target wave capacity.

`vgpr-limit` and `sgpr-limit` pass options can only shrink target-derived
budgets. They are test and tuning controls, not target facts.

`wave.kernel` reserves the kernel-entry prefix:

- SGPRs for the kernarg segment pointer.
- Optional kernarg preload SGPRs.
- SGPRs for workgroup IDs.
- VGPR0 for workitem ID X.

Ordinary allocation starts after the reserved prefix. Entry ops that
materialize those resources may use the reserved registers. Other values
may not.

Virtual AGPR allocation requires target AGPR support. Fixed AGPR values
remain fixed constraints. VGPR-family accounting is enforced when
`waveamdmachine.target_waves` derives a total VGPR-family limit.

## Successful Result

For each non-overflowed function:

- Every tracked op result has a physical index.
- Physical ranges allocated by the pass fit their class budget.
- Physical bases allocated by the pass are aligned to the next power of
  two greater than or equal to their width.
- SGPR, VGPR, and AGPR spaces are separate.
- Distinct live ranges in one class never overlap in both time and
  physical dwords.
- Values in one alias group share one physical base plus per-value
  offsets.
- Dead subranges stop occupying their slots; live tuple slots can outlive
  dead siblings without blocking those sibling slots.

Exact physical numbers carry no semantic meaning beyond legality and
required aliasing. Consumers must not infer schedule quality, value
priority, or source structure from a register number.

## Tuple Aliases

`tuple_to_elements` and `tuple_from_elements` are zero-cost register
views. Elements occupy cumulative dword offsets inside the tuple's
physical block. Example: splitting a width-8 tuple into widths
`[4, 2, 2]` binds elements at offsets `[0, 4, 6]`.

Round trips at matching offsets share one physical block. Shuffles,
broadcasts, shared operands, slot mismatches, partial tuple rebuilds, and
values that feed loop carries cannot share storage; each logical slot
needs independent storage.

Whole-tuple users keep all tuple slots live. Element-only users keep only
the used slots live.

## Loop Carries

Each `waveamdmachine.uniform_loop` carry slot denotes one physical
storage location across the init value, body block argument, backedge
carry, and loop result.

If two carry slots receive the same SSA init value, they get independent
storage. Otherwise two logical loop variables would occupy one storage
location.

The next carried value must not clobber the current carried value before
its last body use.

Values defined outside a loop and used inside the body remain live across
the loop backedge.

When loop-carry storage and tuple storage both constrain the same SSA
value, the carry slot keeps its storage and the tuple slot must use
independent storage.

## MFMA Accumulators

MFMA accumulator chains may be in-place aliases when operand and result
semantics allow it. The accumulator input, result, and loop-carried
accumulator storage may share one physical block.

One accumulator SSA value feeding multiple MFMA chains gives each chain
independent accumulator storage.

When in-place aliasing is not legal, allocation preserves distinct
physical storage. Required movement must be explicit in IR.

## Bank Promotion

Register pressure is relieved by forced storage-bank promotion and VGPR
memory spilling. Provider candidates are ranked together by legality, common
cost, pressure relief, and provider order as the last tie-breaker.

```text
SGPR -> VGPR -> AGPR
```

When a bank overflows, the allocator chooses a live promotable storage
group, moves it into the next bank, rebuilds required bridge ops, and
restarts allocation from the affected point. Operations still keep their
machine operand/result bank requirements.

Bank mismatches get explicit bridge ops:

- SGPR storage consumed by VGPR users gets a vector materialization.
- VGPR storage consumed by SGPR users gets `v_readfirstlane_b32`.
- VGPR storage consumed by AGPR users gets `v_accvgpr_write_b32_tuple`.
- AGPR storage consumed by VGPR users gets `v_accvgpr_read_b32_tuple`.

Promotion never moves fixed physical ranges, ABI ranges, or bridge temps.
If no legal bridge sequence exists, the group is not promotable. If no
promotion can relieve the pressure, overflow handling follows normal pass
mode.

Memory spilling applies to VGPR storage groups. LDS spills materialize
width-1 VGPR values through DS load/store ops when one-wave workgroups,
LDS budget, and addressing constraints make the slot legal. Scratch spills
materialize VGPR values and supported wide loop carries through private
scratch slots. SGPR pressure is relieved through SGPR-to-VGPR promotion,
not direct memory spilling.

VGPR-to-AGPR promotion reduces VGPR-bank pressure, but it does not reduce
combined VGPR/AGPR target-waves pressure. Combined pressure uses memory-spill
providers directly.

The allocator does not expose the old AGPR-bank-spill candidate-ranking
mode and does not emit `waveamdmachine.regalloc_agpr_candidates`.

## Overflow Mode

Default mode is hard fail. If allocation cannot produce a legal result,
the pass emits an error and fails.

With `mark-overflow=true`, allocation overflow is a soft result:

- The offending function gets
  `waveamdmachine.regalloc_overflowed = 1 : i64`.
- The module gets
  `waveamdmachine.regalloc_overflowed_count = N : i64`, including
  `N = 0` when no function overflowed.
- Pressure detail is emitted through MLIR optimization remarks when
  remarks are enabled.
- The function is not a valid allocated program.

For functions that reach allocation, each run owns these attributes. Stale
overflow markers and obsolete diagnostic attrs are removed before new state is
written. Hard input errors before allocation may leave prior state untouched.

Overflowed functions are diagnostic IR only, not valid input to
production post-regalloc passes.

Regalloc reports use MLIR optimization remarks under category
`waveamdmachine-regalloc`. Example:

```bash
wave-opt --waveamd-reg-alloc \
  --remarks-filter=waveamdmachine-regalloc \
  --remark-policy=all \
  --remark-format=yaml \
  --remarks-output-file=regalloc.yaml input.mlir
```

Remark names:

- `regalloc-summary`: function-level inventory and peak pressure.
- `regalloc-interval`: one live interval.
- `regalloc-lds-plan`: LDS spill slot planning.
- `regalloc-scratch-plan`: scratch spill slot planning.
- `regalloc-pressure-failure`: first reported pressure point.

`regalloc-pressure-failure` contains the overflowing class, class budget,
reserved prefix size, live dwords, program position, required relief, the
request interval, active overlaps, and memory-spill rejection counts when
available. Memory-spill rejection metrics include `memory_spill_reject`
plus per-reason counts such as `loop_carry`, `starts_at_pressure`, `fixed`,
and `total`. Pressure-relief diagnostics also include provider summaries and
candidate summaries when the allocator tried pressure relief at that point.

Default hard failures also print pressure detail in the error diagnostic.

## Implementation

`waveamd-reg-alloc` is a `ModuleOp` pass. It walks non-external functions,
derives target budgets, prepares regalloc IR, verifies singleton-resource
liveness, then allocates each function independently.

Each allocation attempt rebuilds current state from IR:

1. `buildAllocatedWaveAMDLiveIntervals` assigns operation positions and
   builds alias-aware live intervals for tuples, loops, exec-if results, MFMA
   accumulators, fixed physical values, and target scopes.
2. `buildInventory` imports those intervals into `Inventory`, creates kernel
   ABI reserved intervals, and records peak SGPR, VGPR, and AGPR pressure.
3. `allocateGroups` packs `IntervalGroup`s into SGPR, VGPR, and AGPR physical
   occupancy while preserving fixed bases, reserved prefixes, and alignment.
4. Budget enforcement checks class-local limits and the combined VGPR/AGPR
   target-waves view.
5. If allocation inserted copies or selected pressure relief, the driver
   materializes the edits and rebuilds from IR. Retries stop at
   `kRewriteAttemptLimit`.
6. A successful final attempt rewrites pass-owned result types with physical
   indices, emits remarks, clears transient diagnostics, and runs
   post-regalloc verification in hard-fail mode.

### Data Model

`Inventory`
  Ordered ops, position map, value-to-interval map, kernel entry registers,
  interval groups, planned pressure-relief plans, provider byte totals, and
  peak pressure counters.

`Interval`
  Values sharing one live slot, register type, start and end positions,
  reserved/non-promotable flags, and owning group.

`IntervalGroup`
  One allocation unit. Contains preferred class, storage class, optional
  assigned/fixed base, member intervals, order, reserved/non-promotable flags,
  and pressure-relief state.

`RegisterBudgets`
  Addressable class limits, target-waves SGPR/VGPR caps, combined VGPR-family
  limit, max waves, and target AGPR accounting mode.

`PressureFailure`
  Class, limit, reserved count, position, request interval, live dwords,
  required relief, active overlaps, and combined-pressure marker.

### Liveness Model

Positions use flattened program order with explicit loop-body positions.
Tuple renames, MFMA accumulator aliases, loop carries, and exec-if region
results are coalesced into interval groups when their storage contracts allow
aliasing. External loop operands are extended across the loop backedge.

Physical occupancy is class-local:

- one live-slot set per physical dword;
- reserved prefixes unavailable to ordinary groups;
- fixed groups placed before virtual groups;
- candidate base fits when occupied physical dword live sets do not intersect
  the group's live slots.

When `target_waves` creates a VGPR-family limit, allocation also tracks a
VGPR-family pressure view. On targets where AGPRs count against VGPRs,
combined VGPR/AGPR overflow is relieved by memory-spill providers.

### Pressure Relief

Pressure relief uses `WaveAMDPressureReliefProvider` callbacks. The driver
creates bank-promotion, LDS-spill, and scratch-spill providers for the
current pressure point, asks each for candidates, selects one candidate, stores
the plan in `Inventory`, materializes through the owning provider, and retries.

Global candidate ranking is:

1. legal candidate;
2. lower total cost;
3. larger pressure relief;
4. provider-specific candidate tie-breaker;
5. provider order.

Provider summaries, candidate summaries, and memory-spill rejection counts are
stored as transient function attrs so hard errors and MLIR remarks report the
same pressure decision.

### Verification

Post-regalloc verification remains the final gate:

- all pass-owned results are physical;
- aliases in one interval have consistent base plus offsets;
- no class-local live physical interference;
- reserved ABI prefix is used only by allowed entry values;
- overflowed functions are rejected by production consumers.

Consumer scopes stay unchanged: resource info requires physical results,
assembly requires all register values, and hazard waits depend on
physical spans for the operands they inspect.

### Coverage

The production allocator is covered by:

- existing RegAlloc LIT coverage, relaxed only where tests asserted
  non-semantic physical numbers;
- integration tests for tuple subranges, target-waves, AGPR MFMA
  accumulators, and promotion bridge codegen;
- post-regalloc consumers: resource info, hazard waits, metadata, and
  assembly translation.

### Complexity And Performance

Allocation scans candidate physical bases and intersects live-slot sets.
Worst cases grow with interval-group count, live-range density, and physical
register scan length. Dense live-slot sets and retry rebuilds are the main
compile-time and memory costs for large generated kernels.

Design constraints:

- fixed occupancy is seeded before virtual assignment;
- subrange interference is decided by slot live-set intersection;
- diagnostics are built from the same problem the allocator sees.

## Non-Goals

The pass does not spill SGPRs or singleton resources such as SCC, VCC,
EXEC, and M0 directly to memory.

The pass does not choose occupancy. `waveamdmachine.target_waves`
expresses an input constraint.

The pass does not repair SCC, VCC, or M0 hazards. Inputs must satisfy
singleton-resource constraints before allocation.

The pass does not make overflowed functions consumable by production
post-regalloc passes.
