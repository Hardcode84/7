# WaveAMD Register Pressure Relief Design

Status: design note.

Current regalloc relieves pressure with storage-bank promotion:

```text
SGPR -> VGPR -> AGPR
```

Memory spilling extends that ladder, but should not be bolted onto the
AGPR promotion code. SGPR promotion, AGPR promotion, LDS spill, and
scratch spill all have the same allocator shape:

- pressure point;
- live range candidate;
- destination resource budget;
- legality check;
- cost;
- materialization rewrite;
- rebuild and retry.

Use one pressure-relief driver with pluggable providers. Bank promotion
and memory spilling are different materializations, but they should be
selected by the same pressure diagnostics and resource model.

## Goals

- Keep register allocation deterministic and inspectable.
- Reuse one candidate ranking path for SGPR, VGPR, AGPR, LDS, and
  scratch relief.
- Preserve `waveamdmachine.target_waves` as an input constraint.
- Prefer cheaper storage before more expensive storage:

```text
SGPR pressure: SGPR -> VGPR
VGPR pressure: VGPR -> AGPR -> LDS -> scratch
```

- Make spill decisions visible in diagnostics.
- Make inserted spill code normal machine IR, then rerun waits, hazards,
  resource info, metadata, and assembly emission.

## Non-Goals

- No SCC, VCC, EXEC, or M0 spilling in the first version.
- No implicit aliasing model for spill memory. Spill memory gets its own
  explicit tokens or is proven disjoint by construction.
- No hidden post-assembly repair. Scratch and LDS usage must be visible in
  WaveAMDMachine IR and resource metadata.
- No occupancy choice. `target_waves` constrains the allocator; it does
  not ask the allocator to pick occupancy.

## Core Model

Pressure relief is driven by allocator failures:

```text
PressureFailure {
  class
  position
  limit
  live_dwords
  required_relief
  request
  overlaps
}
```

Providers see the same failure and return candidates:

```text
ReliefCandidate {
  group
  provider
  relief_dwords
  resource_delta
  cost
  debug_reason
}
```

The common driver:

```text
build inventory
allocate
if success: commit

failure -> collect candidates from providers
if none: report pressure failure

pick best candidate
materialize candidate
rebuild inventory
retry
```

Materialization edits IR. The next attempt treats all inserted bridge,
spill-store, and spill-load values as normal values with normal live
ranges.

## Resource Budgets

One budget object should cover all relief destinations:

```text
ReliefBudgets {
  sgpr_dwords
  vgpr_dwords
  agpr_dwords
  vgpr_family_dwords
  lds_bytes
  scratch_bytes
  target_waves
}
```

Register budgets come from the existing target helper. `target_waves`
narrows SGPR/VGPR caps and enables positional VGPR-family accounting.

LDS budget is per workgroup. Available LDS is:

```text
lds_for_target_waves - existing_lds_bytes - reserved_spill_lds_bytes
```

`lds_for_target_waves` must use the same target facts as LLVM's occupancy
calculation: local memory size, wave size, EUs per CU, and workgroup wave
count. If the workgroup size is unknown, use a conservative upper bound or
reject LDS spilling for that function.

Scratch budget is not an occupancy-preserving resource in the same sense,
but it must update private segment metadata and flat-scratch usage. It is
the last fallback, not an equal-cost choice.

## Providers

### SGPRToVGPR

Relieves SGPR pressure by storing uniform values in VGPRs.

Legality:

- no fixed physical values;
- no ABI-reserved entry values;
- no unsupported block arguments;
- width support must be explicit;
- source value must have a legal scalar-to-vector bridge;
- every SGPR use must have a legal readback or direct replacement.

Materialization:

- insert vector materialization after the SGPR def;
- replace unsupported SGPR uses with `v_readfirstlane_b32` before the
  user;
- mark bridge temps so the allocator can avoid re-promoting them when
  that would cycle.

### VGPRToAGPR

Relieves VGPR pressure by storing vector values in AGPRs.

Legality:

- target has AGPRs;
- no fixed physical values;
- no unpromotable AGPR write users;
- AGPR value can be defined directly or via `v_accvgpr_write_b32_tuple`;
- every non-AGPR user can read through `v_accvgpr_read_b32_tuple`;
- target VGPR-family accounting still fits positionally.

Materialization:

- change directly AGPR-capable defs to AGPR results;
- insert AGPR writes after non-AGPR defs;
- insert AGPR reads before VGPR users;
- preserve tuple and MFMA accumulator alias slots.

This is current behavior in spirit, but it becomes one provider instead
of a special path.

### VGPRToLDS

Relieves VGPR pressure by storing per-lane values in reserved LDS.

Legality:

- target has enough LDS after existing static and dynamic LDS usage;
- extra LDS does not violate requested `target_waves`;
- value is lane-local and reloadable through VGPR LDS ops;
- live range does not cross unsupported region boundaries;
- spill slot address can be computed without creating worse SGPR/VGPR
  pressure than it relieves;
- value type width has load/store support.

Slot layout must avoid aliasing between lanes and waves:

```text
slot_base + wave_in_workgroup * wave_stride + lane_id * value_bytes
```

If wave-in-workgroup is unavailable, first version can restrict LDS spills
to single-wave workgroups or use a conservative slot layout covering the
maximum waves in the workgroup.

Materialization:

- reserve LDS bytes and update `wave.lds_size` / `waveamdmachine.lds_size`;
- insert LDS store after the value definition;
- insert LDS loads before each use that needs the value;
- thread spill tokens per spill slot;
- let ticket waits and hazard waits run after regalloc.

Spill LDS is compiler-owned and disjoint from user LDS. It does not need
tokens against unrelated user LDS operations, only against its own slot
chain.

### VGPRToScratch

Relieves VGPR pressure by storing per-workitem values in scratch/private
memory.

Legality:

- scratch lowering exists for the target;
- function can use flat scratch/private segment metadata;
- value type width has load/store support;
- address calculation does not require impossible SGPR/VGPR temporaries.

Materialization:

- allocate private spill slots;
- insert scratch store after definition;
- insert scratch reload before each use;
- update private segment size, flat-scratch usage, and metadata;
- model VMEM counters and waits through normal post-regalloc passes.

Scratch is always more expensive than LDS. Use it only when AGPR and LDS
cannot legally or profitably relieve the pressure.

## Candidate Ranking

Candidates must first satisfy legality and resource budgets. Ranking then
uses a common cost:

```text
cost =
  materialization_ops
  + loop_depth_weighted_ops
  + memory_latency_penalty
  + extra_resource_pressure
  + instability_penalty
```

Tie breakers:

1. enough relief at the pressure point;
2. lower cost;
3. greater relief dwords;
4. longer overlap with the pressure window;
5. smaller destination-resource consumption;
6. stable source order.

Loop depth matters because a reload inside a loop is paid every iteration.
Definitions outside the loop with uses inside the loop should generally be
worse LDS/scratch candidates than values born and consumed in the same
loop body.

## Region Rules

First version should be conservative:

- no spilling values across `exec_if` boundaries unless both store and
  reload placement are dominance-safe;
- no spilling loop-carried values until carry-slot placement is explicit;
- no memory spilling block arguments;
- no spilling values with multiple region exits unless each reload is
  placed on a dominated path.

Bank promotion can keep supporting more cases than memory spilling because
it does not add memory side effects.

## Scheduling And Waits

Current backend scheduling runs before regalloc, then regalloc can insert
bridge ops. That is tolerable for AGPR copies. It is not enough for real
memory spills.

After memory spilling:

- ticket waits must run again;
- hazard waits must run again;
- resource info must include spill LDS/private bytes;
- scheduler should either run after spill insertion or run a small
  post-spill cleanup scheduler for spill load/store windows.

Long term, scheduler pressure scoring should query the same provider cost
model, so it can avoid schedules that are only legal after expensive
memory spills.

## Diagnostics

Pressure diagnostics should report both rejected and selected candidates:

```text
provider
group
position
relief_dwords
cost
resource_delta
legality_failure, if rejected
materialized_ops
spill_slot, for memory providers
```

Resource diagnostics should report final usage:

```text
sgpr_count
vgpr_count
agpr_count
lds_user_bytes
lds_spill_bytes
scratch_spill_bytes
target_waves
```

## Rollout

1. Extract current SGPR/VGPR/AGPR promotion into provider objects with no
   behavior change.
2. Add common candidate diagnostics.
3. Add LDS budget helper using target local-memory limits and
   `target_waves`.
4. Add LDS slot allocation and machine LDS spill ops for width-1 VGPR
   values.
5. Extend LDS spills to tuples/subranges.
6. Add scratch/private segment model and metadata emission.
7. Add scratch spill ops and codegen.
8. Add post-spill scheduling cleanup.
9. Feed provider costs into scheduler pressure selection.

## Open Questions

- Exact workgroup wave count source for LDS slot layout.
- Whether LDS spills should be enabled by default or require an explicit
  pass option until hardware numbers are measured.
- Scratch ABI details: flat scratch registers, private segment size, and
  metadata fields must be emitted consistently.
- Rematerialization: constants and cheap pure ops may be better remade
  than spilled.
- Interaction with `mark-overflow=true`: diagnostics should be able to
  show relief candidates without materializing them.
