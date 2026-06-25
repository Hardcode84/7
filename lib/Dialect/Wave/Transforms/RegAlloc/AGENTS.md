# WaveAMD Regalloc Pressure Relief

Scope: WaveAMD regalloc implementation files in this directory.

## Target Model

- Keep current alias-set construction model.
- Keep linear scan as allocator driver.
- On failure to allocate current interval at position `P`, ask pressure-relief
  providers for one plan, record it, add planned temp ranges, rerun linear scan.
- Provider order is strict:

```text
AGPR -> Remat -> LDS -> Scratch
```

- Query one provider class at a time. If a provider has any legal candidate,
  choose within that provider and stop. Do not inspect later providers for a
  cheaper plan.
- Always relieve the entire alias set. No partial-lane, partial-value,
  loop-carry, or provider-specific alias splitting.
- Accept a legal plan even when it cannot relieve enough pressure by itself.
  Rerun scan and let the next failure pick the next plan.
- Do not rebuild alias sets after each plan. Add planned temp ranges and bridge
  constraints incrementally.
- Do not materialize operations during selection or allocation. Plans
  materialize after allocation planning.

## Core Allocator Boundary

- Base regalloc knows only the common provider interface.
- No provider-specific conditionals in base regalloc.
- One provider implementation per file. Shared helpers are provider-neutral;
  selection/materialization code stays out of `WaveAMDRegAlloc.cpp`.
- Base regalloc may:
  - build the failure query at position `P`;
  - iterate providers in fixed order;
  - select the cheapest candidate from the first provider with legal candidates;
  - record the chosen plan;
  - insert non-spillable temp live ranges required by planned bridges;
  - restart linear scan.
- Providers own legality, capacity checks, bridge counting, and materialization.

## Candidate Contract

- Candidate alias set must intersect the allocation failure point.
- The live range that failed allocation is eligible for relief.
- Candidate cost is common:
  - required bridge count;
  - bridge loop-depth penalty;
  - stable tie-breakers.
- Loops affect bridge cost, not legality.
- Relief size is not a filter. Use it only for diagnostics or final
  tie-breaks inside equal-cost candidates.
- Bridge temps are normal intervals except `nonPromotable`/non-spillable.

## Providers

### AGPR

- Moves VGPR-family pressure into AGPR storage.
- MFMA accumulator chains need no bridges when alias/interface banks already
  match.
- Non-MFMA uses require explicit bridge temps.
- Capacity is target occupancy and target AGPR availability.

### Remat

- Candidate is an alias set whose value can be rebuilt from cheap ops.
- Rebuild expression tree backward per consumer.
- Every non-rematerialized tracked leaf must be live at every consumer where
  the root is rematerialized.
- Tree materialization is delayed. Selection records root, leaves, and bridges.
- Inputs unavailable at any remat consumer make candidate illegal.

### LDS

- Uses the shared memory-spill provider logic.
- Spills whole alias sets.
- Capacity is target occupancy plus LDS budget. Do not restrict to one wave.
- No loop special cases. Loop placement is bridge cost.

### Scratch

- Uses the same shared memory-spill logic as LDS.
- Spills whole alias sets.
- Unlimited capacity. Last resort by provider order.
- No loop special cases. Loop placement is bridge cost.

## Forbidden Shapes

- Ranking all provider candidates globally.
- Skipping a provider that still has legal candidates.
- Refusing a legal plan because it does not solve pressure alone.
- Rebuilding alias sets from scratch after each plan.
- Materializing remat/spill/bridge ops during candidate selection.
- Special-casing loop carries, loop bodies, LDS, scratch, or remat in base
  regalloc.
- Spilling less than the full alias set.
