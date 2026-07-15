# WaveAMD Regalloc Transform Loop

Scope: WaveAMD regalloc implementation files in this directory.

## Target Model

- Regalloc is an inspectable IR transform loop, not one allocator with deferred
  side plans.
- Each iteration rebuilds regalloc state from current IR, runs linear scan, then
  either commits physical registers or applies one pressure-relief rewrite.
- Driver order is fixed:

```text
build-alias-state -> linear-scan -> AGPR -> Remat -> SGPRToVGPR -> LDS -> Scratch
```

- Relief order is strict:

```text
AGPR -> Remat -> SGPRToVGPR -> LDS -> Scratch
```

- First relief transform that rewrites IR wins. Restart from alias-state build.
- No hidden C++ state may survive an IR rewrite. Recompute, or store enough
  inspectable state in IR.
- Physical assignment is final-only: write indices into
  `!waveamdmachine.reg<class, width, index>` after linear scan succeeds.
- Failed scans write a precise failure record, not partial physical assignment.

## IR State

- Alias sets, interval data, allocation failure, and debug scan state live in a
  function-level regalloc state attribute.
- Do not attach alias metadata to arbitrary `Value`s. Op results share defining
  op storage; block arguments have no generic per-arg attr channel.
- State references values by stable per-epoch IDs:
  - op result: operation path plus result number;
  - block argument: region path, block number, argument number.
- State is ephemeral. Every IR rewrite clears it; the next iteration rebuilds it
  with a new epoch.
- Keep the default encoding compact. Debug modes may print dictionaries or
  named records for FileCheck.
- Marker ops must not consume tracked values only to name them. Such operands are
  real uses and corrupt liveness.

## Alias Builder

- Builder must be `O(Nops + Nuses)` for one function.
- Assign operation positions and value IDs in deterministic IR order.
- Create one interval node per tracked register value.
- Extend interval end on each real operand use.
- Collect alias edges from op/interface semantics, then flatten them into alias
  sets once.
- Alias edges carry dword offsets. Tuple elements, loop carries, branch yields,
  and MFMA accumulator/result aliases must preserve offsets.
- Prefer op interfaces for alias semantics. Hard-coded op checks are local
  fallback, not the long-term model.
- Loop handling must stay linear: summarize external loop uses while walking the
  loop body, extend each affected interval once at loop exit.
- Spillable/non-spillable is derived from producer/consumer op semantics each
  build. Do not keep sticky side bits across IR rewrites.

## Linear Scan

- Linear scan consumes alias state only.
- Success produces a complete assignment map for every allocatable alias set.
- Failure produces one failure record:
  - failed alias set;
  - failure position;
  - register class or combined VGPR/AGPR mode;
  - live pressure and limit;
  - overlapping alias sets at the point;
  - deterministic scan diagnostics.
- Linear scan does not choose AGPR/remat/LDS/scratch. It reports pressure
  failure; ordered transforms decide whether they can rewrite IR.
- Linear scan does not materialize spill, remat, or bridge ops.

## Relief Transforms

- Each relief transform reads current IR plus the latest failure record.
- A transform either rewrites IR immediately or declines.
- Relief size is not a filter. A rewrite need not solve the whole failure alone.
  Restart the loop and let the next scan find the next failure.
- Candidate cost ranks choices inside one transform only:
  - bridge count;
  - loop-scaled bridge cost;
  - latency/instability penalties when local and deterministic;
  - stable tie-breakers.
- No global ranking across relief transforms.

### AGPR

- Moves eligible VGPR-family pressure into AGPR storage.
- AGPR is pressure relief. Do not demote AGPR back to VGPR as a spill strategy.
- MFMA accumulator/interface-compatible aliases need no bridges.
- Non-AGPR producers or consumers require explicit bridge ops.
- Capacity is target occupancy plus target AGPR availability.

### Remat

- Remat is reverse CSE for cheap pure WaveAMDMachine DAGs.
- Handles eligible SGPR, VGPR, and combined VGPR/AGPR failures.
- Profitable SGPR remat runs before SGPRToVGPR promotion.
- Candidate is the alias set named by the failure, or an overlapping alias set
  live at the failure point.
- Find a cheap pure expression DAG rooted at the candidate value.
- Cut the long live range by cloning once at the first consumer after the failure
  point. Later dominated consumers use the rebuilt value.
- Rebuilt values are normal IR and can be remat candidates in later iterations.
- Leaves need not all be live at the rebuild point. Extending cheaper leaves
  across the failure point is legal when rebuilt IR lowers pressure there.
- Fixed hardware inputs such as `v_workitem_id_x`, workgroup id, and fixed
  kernarg preload sources are anchored values. Reuse only when availability and
  pressure are modeled.
- Allocation metadata is not fixed-source provenance.
- Machine CSE may merge pure layout/address math across loops. Remat owns
  undoing those long ranges when they create pressure.

### SGPRToVGPR

- Owns SGPR pressure and allocated-footprint failures left after remat.
- Relieves pressure through VGPR storage and scalar readback.
- Candidate IDs are the failed set plus live SGPR overlaps.
- Select candidates through `pressure - limit`, or request when unavailable.
  Apply available legal candidates even when they do not cover the overage.
- Promote whole alias sets. Mixed canonical/sunk tuple members are repairable.
- Move the earliest sunk promotion after its definition and coalesce duplicates.
- Pin repaired promotions. Remat cannot clone a pinned root or DAG node.
- Refresh changed function results, update metadata, and clear state once after
  the complete plan.

### LDS

- Uses shared memory-spill rewrite logic.
- Spills whole alias sets.
- Inserts real LDS stores/reloads and explicit memory-token edges immediately.
- Capacity is target occupancy plus LDS budget. Dynamic kernel LDS use must
  reserve space before spill capacity is computed.
- No loop-specific allocator path. Loops affect bridge/store/reload cost.

### Scratch

- Uses the same memory-spill rewrite logic as LDS.
- Spills whole alias sets.
- Inserts real scratch stores/reloads and explicit memory-token edges
  immediately.
- Unlimited capacity. Last resort by order.
- No loop-specific allocator path. Loops affect bridge/store/reload cost.

## Convergence

- Successful scan exits. Unchanged failure state stalls. Provider rewrite
  clears state and restarts.
- Providers clear state only after semantic IR progress.
- Default `max_iterations` is 512. Cap exhaustion is a diagnostic backstop.
- Do not raise the cap without a converging workload, progress argument, and
  compile-time measurements.

## Final Result

- No virtual SGPR/VGPR/AGPR values remain in allocation scope.
- All allocated register values carry physical indices in their reg types.
- Spill, remat, AGPR bridge, and memory-token ops are ordinary IR.
- Kernel metadata comes from final IR, not stale allocator state.
- Verification must not require hidden allocator objects.
- Assignment clearing preflights function returns and direct calls. Declarations
  and fixed ABI entries retain their types.

## Forbidden Shapes

- Deferred pressure-relief plans materialized after later scans.
- Preserving alias sets across IR rewrites.
- Partial physical assignment on failed scan.
- Ranking AGPR/remat/LDS/scratch candidates globally.
- Skipping an earlier relief transform because a later one looks cheaper.
- Provider-specific logic in linear scan.
- Marker operands that create fake liveness.
- String-round-tripping regalloc state that already has structural form.
