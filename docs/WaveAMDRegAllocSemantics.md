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

Register pressure is relieved by forced storage-bank promotion:

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
available.

Default hard failures also print pressure detail in the error diagnostic.

## Rewrite Design

`waveamd-reg-alloc` uses the component implementation. It preserves the
observable contract above while making storage constraints explicit.

The function pipeline is:

1. `FunctionInventory`: assign stable operation positions and classify
   register values, singleton resources, entry ops, tuple ops, loops, MFMA
   ops, fixed physical values, and target scopes.
2. `SemanticRepair`: insert copies where SSA identity cannot represent
   required storage, then re-run inventory.
3. `ConstraintBuilder`: build alias constraints and live slot segments.
4. `BudgetResolver`: compute class budgets, reserved prefixes,
   target-waves caps, and VGPR-family accounting.
5. `PhysicalAllocator`: seed fixed and reserved occupancy, assign virtual
   storage groups per class, and report pressure failures.
6. `PromotionMaterializer`: insert SGPR/VGPR/AGPR bridge ops for groups
   promoted by the allocator, rebuild, and retry.
7. `Commit`: rewrite result and loop block-argument types with physical
   indices and write or clear overflow markers.
8. `PostVerify`: run post-regalloc verification as the final gate.

`SemanticRepair` and `ConstraintBuilder` run to a fixed point.
Repairable alias conflicts return edit requests; the driver applies them,
then inventory and constraints rebuild. Non-repairable conflicts are hard
errors.

### Data Model

`RegValue`
  `Value`, class, width, fixed index if present, defining position, last
  uses, pass-owned flag, reserved-entry allowance.

`StorageGroup`
  One allocation unit. Contains class, width, alignment, optional fixed
  base, values with slot offsets, and per-slot live segments.

`SlotSegment`
  Relative dword slot plus half-open position range. Diagnostics convert
  back to the current inclusive `start` / `end` schema.

`AliasEdge`
  Weighted relation: `base(lhs) + lhsOffset == base(rhs) + rhsOffset`.

`ClassProblem`
  Budget, reserved prefix, fixed groups, virtual groups, and physical
  occupancy for one class.

`PressurePoint`
  Class, limit, reserved count, position, request interval, live dwords,
  required relief, and active overlaps.

Use weighted union-find for aliases. Each root stores class, required
width, fixed base, and member value offsets. Union conflicts are repair
requests or hard errors, never silent coalesces.

### Liveness Model

Positions use program order with explicit loop body positions. Each
position has read and write phases. Uses are live through the read phase;
defs become live at the write phase. Same-op tuple renames, MFMA
accumulator aliases, and loop carry joins use alias constraints, not
interference.

Physical occupancy is class-local:

- one occupancy structure per physical dword;
- reserved prefix tracked as unavailable for ordinary groups;
- allowed entry groups may occupy exact reserved registers and then insert
  normal liveness into occupancy;
- fixed groups inserted before virtual groups;
- candidate base fits when occupied physical dword live sets are disjoint
  from the group's live slots.

When `target_waves` creates a VGPR-family limit, allocation also tracks a
VGPR-family pressure view. VGPR candidates cannot consume headroom needed
by live AGPRs on targets where AGPRs count against VGPRs.

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

Rewrite-specific internal verifiers should check:

- alias graph has one class per root;
- each alias edge has legal provenance: tuple view, loop carry, MFMA
  accumulator, or fixed constraint after repair;
- fixed bases agree per root;
- group width covers every member offset plus width;
- live slot sets are within group width;
- reserved and fixed occupancy are inserted before virtual allocation;
- committed types match planned assignments.

### Rollout Criteria

The production allocator is covered by:

- existing RegAlloc LIT coverage, relaxed only where tests asserted
  non-semantic physical numbers;
- integration tests for tuple subranges, target-waves, AGPR MFMA
  accumulators, and promotion bridge codegen;
- post-regalloc consumers: resource info, hazard waits, metadata, and
  assembly translation.

### Complexity And Performance

Current allocation scans candidate bases and active intervals, then
compares value subranges pairwise. Worst cases grow with interval count
times active count times physical-register scan.

The rewrite uses explicit storage groups and physical occupancy. The
current implementation uses dense bitsets for live slots; that is already
faster on large observed GEMM cases, but dense memory and retry rebuilds
remain the primary risks for very large generated kernels. Sparse live
sets or event-based pressure summaries are the next optimization points
if compile-time or memory regresses.

Design constraints:

- fixed occupancy is seeded before virtual assignment;
- subrange interference is decided by slot live-set intersection;
- diagnostics are built from the same problem the allocator sees.

## Non-Goals

The pass does not spill to memory.

The pass does not choose occupancy. `waveamdmachine.target_waves`
expresses an input constraint.

The pass does not repair SCC, VCC, or M0 hazards. Inputs must satisfy
singleton-resource constraints before allocation.

The pass does not make overflowed functions consumable by production
post-regalloc passes.
