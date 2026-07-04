# WaveAMD instruction execution-state model

## Goal

Use one small state model for scheduler issue preview and simulator replay.

User-facing API:

```cpp
struct InstructionExecutionState {
  FailureOr<InstructionStall> query(Operation *op) const;
  FailureOr<InstructionCommit> commit(Operation *op);
};
```

`query` answers: "if this instruction is next, why does it stall and for how
long?" It never changes state.

`commit` issues the instruction, advances state through required stalls, records
new pending work, and returns the committed issue/ready timing.

Scheduler and event simulator both use this API. No second timing oracle.

## File Boundary

New implementation lives in separate files:

```text
include/mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h
lib/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.cpp
```

Scheduler and simulator users call this API directly.

Allowed reuse:

- `ArchData`, `SchedClass`, `FunctionalUnit`.
- `OpClassifier` and memory-counter classification helpers.
- WaveAMDMachine op traits and typed SSA values.

## Scope

First model is single execution unit state only.

Supported targets for this model:

- CDNA3: `gfx942`.
- CDNA4: `gfx950`.
- RDNA3: `gfx11*`.

Out of current support:

- GFX12 / GFX125x.
- LLVM `coexec` scheduling behavior as an enabled strategy. Its local source is
  useful prior art, but current LLVM gates that strategy to `gfx1250`.

In scope:

- VALU, SALU, and XDL issue/backpressure counters.
- Wait-counter queues for issued, not-yet-retired events.
- Memory value dependencies.
- Memory token dependencies, including transitive token deps.
- Explicit `s_waitcnt` / `s_waitcnt_*` and pre-waitcnt "future wait"
  estimation.
- M0 software wait-state gap.

Out of scope for the first file:

- Cache modeling.
- Implicit alias/order inference.
- Rewriting waitcnt insertion.
- Scheduler search policy.
- Cycle-exact silicon claims.

LGKM covers LDS/DS, GDS, scalar-memory, and messages. SMEM is not a third
hardware wait counter. Until SMEM ordering is modeled, SMEM either drains only
through `lgkmcnt(0)` or fails loudly.

Memory ordering stays explicit: SSA dominance plus token edges. No hidden alias
analysis.

## LLVM Cross-Reference

LLVM's AMDGPU scheduler is useful for shape, not as a drop-in policy:

- `SISchedule.td` gives per-target schedule classes and speed models. Treat it
  as seed data plus calibration, not cycle truth.
- `AMDGPUCoExecSchedStrategy` has the right flavor/resource vocabulary:
  `WMMA`, VALU, VMEM, DS, SALU, DMA, fence, resource busy cycles, and
  critical-resource dependency priority.
- Do not import `coexec` policy wholesale. Local LLVM currently warns outside
  `gfx1250`, and this model targets `gfx942`, `gfx950`, and `gfx11*`.
- Waitcnt insertion and hazard repair stay outside this API. This state answers
  timing; scheduler DAG plus SSA/token edges answer legality.

Primary cross-checks:

- AMD CDNA3 / MI300 ISA reference.
- AMD CDNA4 ISA reference.
- AMD RDNA3 ISA reference.
- LLVM `AMDGPUCoExecSchedStrategy`, `SISchedule.td`, `SIInsertWaitcnts`, and
  `GCNHazardRecognizer`.

## Public Types

```cpp
enum class StallKind : uint8_t {
  None,
  IssueBackpressure,
  MemoryValue,
  MemoryToken,
  M0ReadWrite,
  OperandValue,
};

struct StallComponent {
  StallKind kind = StallKind::None;
  int64_t cycles = 0;
};

struct InstructionStall {
  StallKind kind = StallKind::None;
  int64_t cycles = 0;
  SmallVector<StallComponent, 4> components;
};

struct InstructionCommit {
  InstructionStall stall;
  int64_t issueCycle = 0;
  int64_t nextIssueCycle = 0;
  int64_t valueReadyCycle = 0;
  int64_t tokenReadyCycle = 0;
};
```

`InstructionStall::kind` is the primary reason. `components` keeps diagnostics
lossless when multiple reasons tie or overlap.

Tie order for primary reason:

1. `MemoryToken`
2. `MemoryValue`
3. `M0ReadWrite`
4. `OperandValue`
5. `IssueBackpressure`

Unsupported ops are not a stall kind. `query` / `commit` return failure with a
diagnostic.

## Instruction Summary

The state should not inspect op internals repeatedly. First step in `query` and
`commit` is lowering the op into a compact summary:

```cpp
enum class PipeKind : uint8_t {
  None,
  VALU,
  SALU,
  XDL,
};

enum class WaitCounterKind : uint8_t {
  None,
  Vmem,
  Vscnt,
  Lgkm,
  Expcnt,
};

enum class EventClass : uint8_t {
  None,
  VmemLoad,
  VmemStore,
  LdsDs,
  Smem,
  Flat,
  Export,
};

struct InstructionDesc {
  Operation *op = nullptr;
  SchedClass schedClass = SchedClass::NoInst;
  FunctionalUnit fu = FunctionalUnit::None;
  PipeKind pipe = PipeKind::None;
  WaitCounterKind counter = WaitCounterKind::None;
  EventClass eventClass = EventClass::None;
  unsigned issueCount = 0;
  int valueLatency = 0;
  int tokenLatency = 0;
  int retireLatency = 0;
  bool realInstruction = false;
  bool readsM0 = false;
  bool writesM0 = false;
  bool waitcnt = false;
  bool tokenConsumer = false;
  bool tokenIssuerMustWaitBeforeIssue = false;
};
```

`tokenIssuerMustWaitBeforeIssue` is policy, not alias analysis. Read-only
issuers may carry source-token deps into their result token instead of waiting
before issue. The result token must preserve skipped deps.

## State

```cpp
struct PipeState {
  int64_t nextIssueCycle = 0;
  SmallVector<int64_t, 8> pendingIssues;
  unsigned maxInFlight = 0;
};

using EventId = uint32_t;

struct PendingEvent {
  EventId id = 0;
  Operation *op = nullptr;
  WaitCounterKind counter = WaitCounterKind::None;
  EventClass eventClass = EventClass::None;
  int64_t issueCycle = 0;
  int64_t valueReadyCycle = 0;
  int64_t tokenReadyCycle = 0;
  int64_t retireCycle = 0;
  SmallVector<Value, 2> valueResults;
  Value tokenResult;
};

struct TokenDeps {
  SmallVector<EventId, 4> events;
};

struct InstructionExecutionState {
  int64_t currentCycle = 0;
  PipeState valu;
  PipeState salu;
  PipeState xdl;
  SmallVector<PendingEvent, 16> vmemQueue;
  SmallVector<PendingEvent, 16> vscntQueue;
  SmallVector<PendingEvent, 16> lgkmQueue;
  SmallVector<PendingEvent, 16> expcntQueue;
  DenseMap<Value, int64_t> valueReadyAt;
  DenseMap<Value, TokenDeps> tokenDeps;
  bool m0GapArmed = false;
};
```

`currentCycle` means next issue attempt cycle. After a commit, it points at the
next instruction's earliest issue attempt.

Queues hold issued wait-counter events until their retire cycle passes. Token
deps may refer to retired entries until the token value dies; keep an
id-to-entry archive if active queues get compacted.

`m0GapArmed` is set by a SALU M0 write when the next selected M0 consumer needs
one independent real instruction first. Pseudos do not clear it.

## Query

`query(op)`:

1. Build `InstructionDesc`.
2. Compute pipe wait from VALU/SALU/XDL state.
3. Compute normal operand wait from `valueReadyAt`.
4. Compute memory value wait from wait-counter queue result readiness.
5. Compute token wait from pending event deps.
6. Compute explicit waitcnt drain wait when `op` is a waitcnt.
7. Compute M0 gap wait.
8. Return max wait and all nonzero components.

Pseudo-code:

```cpp
FailureOr<InstructionStall>
InstructionExecutionState::query(Operation *op) const {
  FailureOr<InstructionDesc> maybeDesc = classifyForExecutionState(op);
  if (failed(maybeDesc))
    return failure();

  InstructionDesc desc = *maybeDesc;
  SmallVector<StallComponent, 4> waits;

  addPipeWait(desc, waits);
  addOperandValueWait(desc, waits);
  addMemoryValueWait(desc, waits);
  addMemoryTokenWait(desc, waits);
  addWaitcntDrainWait(desc, waits);
  addM0Wait(desc, waits);

  return makePrimaryStall(waits);
}
```

Memory value wait:

- If an operand is produced by a queued memory event, wait until that entry's
  `valueReadyCycle`.
- Non-memory producer latency still uses `valueReadyAt`.

Memory token wait:

- For token operands, collect `TokenDeps`.
- If the instruction must wait before issue, wait until all referenced entries
  reach `tokenReadyCycle` or `retireCycle`, per op policy.
- If the instruction may issue read-only, do not stall; carry deps into the
  result token on commit.

Explicit waitcnt drain:

- `vmcnt(N)` waits until all but the youngest `N` VMEM-load entries retire.
- `vscnt(N)` waits until all but the youngest `N` VMEM-store entries retire.
- `lgkmcnt(N)` waits until all but the youngest `N` modeled LGKM entries
  retire.
- Combined waits take the max required cycle.

On RDNA3, global and scratch stores use VScnt, not VMcnt. If VScnt is not
implemented, such ops are unsupported. Flat instructions may involve both
VM/VScnt and LGKM; use full drain until split readiness is modeled.

SMEM is LGKM, but scalar-memory reads can return out of order. Nonzero LGKM
waits are valid only for modeled ordered event classes; SMEM deps use
`lgkmcnt(0)` until the model proves a narrower wait.

Query does not prune queues or update counters. Const means const.

## Commit

`commit(op)` internally calls `query(op)`. Callers do not pass a cached preview;
that prevents scheduler/simulator divergence.

Pseudo-code:

```cpp
FailureOr<InstructionCommit>
InstructionExecutionState::commit(Operation *op) {
  FailureOr<InstructionStall> maybeStall = query(op);
  if (failed(maybeStall))
    return failure();

  InstructionStall stall = *maybeStall;
  currentCycle += stall.cycles;
  retireThrough(currentCycle);

  FailureOr<InstructionDesc> maybeDesc = classifyForExecutionState(op);
  if (failed(maybeDesc))
    return failure();

  InstructionDesc desc = *maybeDesc;
  int64_t issueCycle = currentCycle;

  reservePipe(desc, issueCycle);
  recordValueReadiness(desc, issueCycle);
  recordPendingEvent(desc, issueCycle);
  recordTokenDeps(desc);
  updateM0State(desc);

  currentCycle = issueCycle + issuePeriod(desc);
  retireThrough(currentCycle);
  return buildCommit(desc, stall, issueCycle);
}
```

Commit responsibilities:

- Advance through the stall reported by query.
- Retire queue entries whose retire cycle is now past.
- Reserve VALU/SALU/XDL capacity.
- Add queue entries for wait-counter event issuers.
- Record value readiness for all results.
- Record token deps for token results.
- Update M0 gap state.

`issuePeriod(desc)` is usually one cycle. Target-specific wave64 or shared
issue effects stay behind config/arch hooks.

## Memory Tokens

Token state is structural.

For each token result:

1. Start with deps from token operands.
2. If the op issues a wait-counter event, add the new event id.
3. If the op is a token join or barrier, union input deps without draining.
4. If the op is an explicit wait, apply drain semantics to the input deps.

Do not serialize token state through strings or parse printed IR.

Read-only memory issuers need special care:

```text
ds_load -> global_load ... after %ds_token -> wait %global_token
```

If the global load can issue before `%ds_token` retires, `%global_token` still
inherits the LGKM dep. Later `wait %global_token` must see both VMEM and LGKM
requirements.

## M0 Gap

Model as instruction gap, not value latency.

Rules:

- SALU M0 writer arms `m0GapArmed`.
- Selected M0 consumers stall one cycle if armed.
- One unrelated real instruction clears the flag.
- Pseudos, constants, labels, and scheduling-only markers do not clear it.
- If commit pays the M0 stall, clear before issuing the M0 op, then re-arm if
  that op writes M0.

Selected consumers:

- LDS add-TID instructions.
- LDS-targeting global/buffer/scratch paths that consume M0.
- `S_MOVEREL`-class relative moves.

CDNA3/CDNA4 have explicit ISA rows for this gap. RDNA3 keeps the conservative
compiler model unless a target-specific row proves it unnecessary.

This matches scheduler needs: filler instructions can close the gap; pure time
advance also works for simulator accounting.

## Barriers

Barrier ops synchronize waves. They do not imply wait-counter drain.

If a barrier protects outstanding memory, the dependency must be visible through
tokens and satisfied by an explicit wait. A barrier token can carry pending deps
forward, but `commit(barrier)` must not silently retire VMEM, VScnt, LGKM, or
export events.

## Scheduler Use

The greedy scheduler owns dependency legality. This model only answers issue
timing.

Loop per region:

```text
state = InstructionExecutionState(config)

next = first ready op in original order
stall = state.query(next)
if stall.cycles == 0:
  state.commit(next)
else:
  filler = first ready op with state.query(filler).cycles == 0
  if filler:
    state.commit(filler)
  else:
    state.commit(next)
```

Scheduler diagnostics print `InstructionStall` directly:

```text
stall op=... kind=MemoryToken cycles=32 components=[MemoryToken:32, IssueBackpressure:1]
```

## Event Simulator Use

Single-wave simulation is a straight replay over instructions:

```text
state = InstructionExecutionState(config)
for op in flattened_program:
  commit = state.commit(op)
  record timeline event from commit
```

Do not fork timing logic for the event simulator. It should only add program
flattening and timeline recording.

## Validation

Unit tests for the new file:

- `query` is pure: repeated query returns same result and state dump is equal.
- `commit` result contains the same stall that `query` reported.
- VALU/SALU/XDL counters can be disabled and enabled by config.
- VMEM value consumer waits for value readiness.
- LDS/DS value consumer waits for value readiness.
- RDNA3 VMEM stores use VScnt or fail loudly when VScnt is disabled.
- SMEM token deps require `lgkmcnt(0)` until nonzero SMEM waits are modeled.
- Token consumer waits for transitive wait-counter event deps.
- Read-only token issuer carries skipped source deps into result token.
- `vmcnt(N)`, `vscnt(N)`, and `lgkmcnt(N)` drain the right queue entries.
- Barrier commit does not drain wait-counter queues.
- M0 filler instruction clears the selected-consumer gap.
- Pseudos do not clear the M0 gap.
- Unsupported targets (`gfx12`, GFX125x) fail instead of silently using another
  model.

Integration tests:

- Greedy scheduler and event simulator report the same stalls on one linear
  region.
- A token chain with mixed VMEM/LGKM deps produces mixed waits.
- A known A4W4 hot loop keeps the intended nonzero `vmcnt` shape.
- Unsupported op fails loudly with op name and region location.
- Coverage includes one target each for `gfx942`, `gfx950`, and `gfx11*`.

## Current Users

- `WaveAMDMachineGreedySchedule.cpp` uses copied state for preview and the live
  state for commit.
- `EventSimulator.cpp` replays functions and operation lists through
  `InstructionExecutionState`.
