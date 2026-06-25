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
  choose a candidate from that provider and stop. Do not inspect later
  providers for a cheaper plan.
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
  - select the cheapest failure-progressing candidate from the first provider
    with legal candidates;
  - record the chosen plan;
  - insert non-spillable temp live ranges required by planned bridges;
  - restart linear scan.
- Providers own legality, capacity checks, bridge counting, and materialization.

## Candidate Contract

- Candidate alias set must intersect the allocation failure point.
- The live range that failed allocation is eligible for relief.
- Selection may reject a structurally legal candidate whose planned temps erase
  its current-failure pressure effect.
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

- Candidate is an alias set whose value can be rebuilt from a cheap pure DAG.
- Plan is scoped to allocation failure position `P`.
- Cut original ranges at `P`. Rebuild once at the first external consumer after
  `P`; later dominated consumers use the rebuilt value.
- Rebuilt ranges can become later remat candidates if scan fails after the
  rebuild point.
- Leaves need not already be live at the rebuild point. Extending cheaper leaves
  across `P` is legal when net pressure at `P` decreases.
- Tree materialization is delayed. Selection records root DAG, rebuild point,
  post-cut uses, leaf pressure deltas, and bridges.

## CSE and Remat Contract

- Machine CSE before regalloc may merge duplicate pure layout/address math
  across a hot loop. Do not fight this by disabling CSE or marking cheap
  machine math impure.
- Remat owns splitting those CSE-created live ranges when they create pressure:
  a cheap pure value defined before a hot loop, unused inside the loop, and
  used after the loop must be disposable by rebuilding once at the first
  pressure-relevant post-loop consumer.
- This covers cheap WaveAMDMachine layout/address expressions already admitted
  by remat legality, including shifts, and/xor-style masks, `v_mov_b32_tuple`,
  simple add trees, tuple joins, and equivalent pure selector output.
- Legality walks the full value DAG at the rebuild point. Each leaf must be one
  of:
  - an anchored hardware/source value modeled available there;
  - an immediate, scalar, or kernarg value available there;
  - a tracked value whose interval can be extended across `P` with modeled
    pressure cost;
  - another cheap pure op that can be recursively cloned there.
- Candidate progresses when pressure removed at `P` exceeds pressure added at
  `P` by leaf extensions, rebuilt ranges, and bridge temps.
- Fixed hardware inputs such as `v_workitem_id_x`, workgroup id, and fixed
  kernarg preload sources are anchored values, not free remat ops. Reuse them
  only when availability and pressure are modeled at the rebuild point; otherwise
  reject the candidate.
- Allocation metadata is not fixed-source provenance. Do not treat a value as
  remat-safe just because it already carries an allocated register index.
- Materialization must rebuild once at the rebuild point and must not mutate
  clone templates for later planned slots. Compute planned-value and protected
  template sets first, skip internal planned template uses, rewrite selected
  post-cut uses, then erase dead original cheap trees after all clones are
  emitted.
- Diagnostics for missed remat opportunities should expose root op, def
  position, failure position, rebuild point, first post-cut use, relief dwords,
  added pressure, reject reason, and whether the candidate crosses a loop unused.
- Validation should include a small lit test and a loop-spanning CSE case:
  pre-regalloc may contain VGPR address values crossing a hot loop, but
  post-regalloc should not leave VGPR/AGPR values defined before the loop,
  unused inside it, and only used after it.

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
