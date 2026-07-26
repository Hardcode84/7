# GFX950 asymmetric persistent-wave f16 GEMM

## Status

Implemented as an opt-in profile. Profiling rejected it from the default
sweep: the current 4-wave kernel remains 45% faster at 8192x8192x8192.

Profile: `gfx950-f16-256x256-16wave-persistent`. Sweep alias:
`f16-persistent`. Existing profiles remain unchanged.

## Goal

Keep direct-to-LDS traffic on persistent producer waves and MFMA work on
persistent consumer waves. Producers observe their own DMA completion through
`HW_REG_IB_STS`, publish ready stages through LDS atomics, and continue without
a workgroup barrier. Consumers wait on monotonic LDS mailboxes, copy
operands into registers, release the LDS stage, and finish MFMA work after the
release.

The experiment must answer:

- Can dedicated producers hide global-to-LDS latency behind compute?
- Can finite `s_sleep` plus `s_wakeup` replace steady-state full barriers?
- Does removing four waves from compute leave enough MFMA latency coverage?
- Is polling `IB_STS.VM_CNT` cheaper than a producer-side `s_waitcnt`?

Initial target is the existing gfx950 f16 `256x256x32`, 16-wave shape.

## Non-Goals

- No automatic role discovery from GEMM operation patterns.
- No clone-based multi-wave specialization.
- No kernel-specific scheduler policy or cost-model knob.
- No post-greedy cycle simulation that vetoes an otherwise legal schedule.
- No regalloc role groups or branch-pair allocation rules.
- No cache, clock, or FP-mode changes hidden in the comparison.
- No manual assembly as the final implementation.

## Relation To Multi-Wave Specialization

`WaveAMDMachineMultiWaveSpecialize` clones one graph to obtain two static
instruction orders. Both branches perform the same work and rendezvous at the
same barriers.

This design assigns different work to each branch:

- producer branch: global-to-LDS DMA and mailbox publication;
- consumer branch: LDS reads, MFMA, mailbox release, and output stores.

The branches run asynchronously. Their progress is bounded by a shared LDS
ring, not scheduler lockstep. The kernel expresses the role split directly as
ordinary wave-uniform control flow. It carries no paired-specialization marker.

## Hardware Basis

Current gfx950 target data provides:

| Property | Value |
|---|---:|
| SIMDs per CU | 4 |
| VGPR dwords per SIMD | 512 |
| Maximum waves per SIMD | 8 |
| Wave64 SIMD issue period | 4 cycles |
| LDS-DMA accept queue depth | 7 |
| LDS-DMA modeled latency | 180 cycles |
| LDS-DMA issue period | 4 cycles |
| Physical LDS per CU | 160 KiB |

Four resident waves per SIMD require a combined VGPR/AGPR allocation of at
most 128 dwords per wave. The proposed 16-wave workgroup therefore occupies
one CU when every branch fits that limit.

CDNA4 defines `HW_REG_IB_STS` as hardware register 7. Its VM counter is split:

```text
VM_CNT[3:0] = IB_STS[3:0]
VM_CNT[5:4] = IB_STS[23:22]
```

One full-register read decodes the counter as:

```text
vmcnt = (raw & 0xf) | ((raw >> 18) & 0x30)
```

Reading two slices is invalid: the counter may change between reads.

`IB_STS.VM_CNT == 0` is only a candidate completion test until a gfx950
microbenchmark proves that direct-to-LDS writes are visible when it reaches
zero. The producer-side `s_waitcnt vmcnt(0)` variant is the correctness and
performance control.

## Starting Geometry

Use profile-equivalent launch geometry:

```text
CTA tile:             256 x 256
K stage:              32
Wave size:            64
Waves per workgroup:  16
Resident waves/SIMD:  4
Producer waves:       4
Consumer waves:       12
```

Logical wave ID comes from the first active workitem:

```text
wave_id = read_first(workitem_id) / 64
slot    = wave_id / 4
row     = wave_id % 4
```

`slot == 3` selects producers, giving logical waves 12 through 15. Slots 0
through 2 select consumers.

The initial topology assumes logical wave IDs distribute as four slots over
four SIMDs. A launch microbenchmark must verify that mapping on gfx950. Role
identity remains the logical workgroup wave ID. Do not repeatedly sample
physical `HW_ID`: physical fields are not a stable software identity.

### Producer Ownership

Producer `p = wave_id - 12` owns:

- A rows `[64p, 64(p + 1))` for the current K32 stage;
- B columns `[64p, 64(p + 1))` for the current K32 stage;
- ready bit `1 << p`.

Each slab is `64x32xf16`, or 4 KiB. One producer moves 8 KiB with eight
wave-wide `buffer_load_dwordx4` direct-to-LDS instructions. Four producers
retain the baseline total of 32 DMA instructions per K32 stage.

### Consumer Ownership

Each row group owns 64 output rows. Its three consumer slots divide 256 output
columns:

| Consumer slot | N tiles | Output tile | MFMA per K32 | LDS reads per K32 |
|---:|---:|---:|---:|---:|
| 0 | 5 | `64x80` | 20 | 9 |
| 1 | 5 | `64x80` | 20 | 9 |
| 2 | 6 | `64x96` | 24 | 10 |

Across four row groups:

```text
MFMA per K32:     4 * (20 + 20 + 24) = 256
LDS reads/K32:    4 * (9 + 9 + 10)   = 112
```

The symmetric 16-wave shape performs 256 MFMAs and 128 LDS reads. Asymmetric
ownership preserves compute and DMA work while reducing LDS reads by 12.5%.

Output coordinates are disjoint and cover the CTA exactly:

```text
row 0..3 -> M [64*row, 64*(row+1))
slot 0   -> N [0, 80)
slot 1   -> N [80, 160)
slot 2   -> N [160, 256)
```

## Register Budget

The largest consumer is `64x96`:

| Live class | Dwords |
|---|---:|
| MFMA accumulators | 96 |
| Four A fragments | 16 |
| One B fragment | 4 |
| Addresses, counters, predicates, tokens | at most 12 |
| Total | at most 128 |

B fragments are streamed one at a time. Keeping all six B fragments would
break four-wave-per-SIMD occupancy.

The 128-dword limit is combined VGPR/AGPR pressure. Bank split is not a design
constraint. No spill, LDS relief, or Scratch relief is accepted for this
profile.

Producer pressure is much smaller. Generic `uniform_if` liveness must allocate
the maximum branch pressure, not the sum:

- shared live-ins interfere with both branches;
- producer-local and consumer-local values do not interfere;
- accumulators remain inside the consumer branch;
- both branches yield only the final ordering token.

Branch-specific descriptor and address setup stays inside its branch. Hoisting
it would inflate the opposite branch without sharing useful work.

## LDS Ring

One stage stores:

```text
A: 256 * 32 * 2 bytes = 16 KiB
B: 32 * 256 * 2 bytes = 16 KiB
stage stride          = 32 KiB
```

Use three stages:

```text
slot 0 data: [0 KiB, 32 KiB)
slot 1 data: [32 KiB, 64 KiB)
slot 2 data: [64 KiB, 96 KiB)
mailboxes:   allocated after stage data
```

Triple buffering permits one stage being consumed, one complete stage waiting,
and one stage being filled. It also bounds producer lead to three K stages.

The runner must request the full dynamic LDS byte count. Its 64 KiB constant is
the threshold for dynamic allocation, not the gfx950 capacity. Mailboxes and
any padding participate in normal `wave.lds_size` or
`wave.dynamic_lds_size` accounting.

Reuse the current A/B LDS layout and XCD CTA remap:

```text
cta_swizzle_xcds = 8
cta_group_m      = 4
```

Only stage count and wave ownership change in the first experiment.

## Mailbox State

Each ring slot owns one `ready` and one `done` i32. Values only increase;
steady-state code never resets a mailbox.

```text
ready_target(g) = 16 * g + 15
done_target(g)  = 4096 * g + 4095
```

Each participant publishes one distinct power of two with returning
`ds_add_rtn_u32`. Participant zero also supplies the generation increment.

For a slot's first use:

```text
ready extra = 16 * g
done extra  = 4096 * g
```

For every reuse three generations later:

```text
ready contribution sum = 15 + 33     = 48
done contribution sum  = 4095 + 8193 = 12288
```

Those increments equal each target's three-generation delta. Exact equality
identifies the last participant without a reset race. Duplicate publication
corrupts all later targets and is a protocol violation.

## Runtime Protocol

Let `g` be the K-stage generation and `s = g % 3`.

### Startup

All waves execute one startup sequence:

1. Elect one workitem.
2. Initialize every mailbox word to zero.
3. Drain the LDS initialization stores.
4. Execute one full workgroup barrier.
5. Enter the wave-uniform producer/consumer branch.

No full barrier appears in the recurring K loop.

### Producer Loop

Every producer executes:

```text
for g in K / 32:
  s = g % 3
  if g >= 3:
    wait until done[s] == done_target(g - 3)
  issue eight direct-to-LDS loads for owned A/B slabs
  wait until this wave's DMA completion condition holds
  contribution = producer bit + producer-0 generation increment
  old = atomic_add(ready[s], contribution)
  if old + contribution == ready_target(g):
    s_wakeup
```

The first variant polls to VM count zero. The producer branch issues no other
VMEM operation inside the hot loop, so the counter has one owner and at most
eight outstanding events.

Every DMA consumes its explicit M0 SSA value and memory dependency. Stage M0
and A/B offsets are branch-local loop carries. The poll consumes DMA tokens;
the next M0 user consumes the next M0 SSA value. This protocol needs no issue
token or M0 passthrough pseudo.

The final producer publication still performs `s_wakeup`. Producers may then
reach the function return; consumers need no final workgroup barrier.

### Consumer Loop

Every consumer executes:

```text
for g in K / 32:
  s = g % 3
  wait until ready[s] == ready_target(g)
  read four A fragments
  for each owned N fragment:
    read one B fragment
    issue four MFMAs
  wait for the final LDS read to complete
  contribution = consumer bit + consumer-0 generation increment
  old = atomic_add(done[s], contribution)
  if old + contribution == done_target(g):
    s_wakeup
  finish MFMAs that only consume register fragments
store owned output tile
```

The done bit means "all LDS reads from this slot completed", not "all MFMAs
completed". Once fragments are in registers, producers may overwrite the LDS
stage while the compute tail runs.

The done atomic must depend on the completion token for the last LDS read.
Depending only on LDS issue would permit early overwrite.

## DMA Completion Poll

The Wave semantic operation waits for all VMEM represented by one dependency:

```mlir
%complete = waveamd.vmem_wait_poll %dma
    : (!wave.mem.token) -> !wave.mem.token
```

It consumes ordinary memory tokens and returns an ordinary memory token. No
issue-token type is needed.

Machine selection expands it to a bounded runtime loop:

```text
poll:
  raw = s_getreg_b32 HW_REG_IB_STS
  vmcnt = (raw & 0xf) | ((raw >> 18) & 0x30)
  if vmcnt != 0:
    optional s_sleep 1
    goto poll
```

Requirements:

- one full `IB_STS` read per iteration;
- volatile hardware-state read, never `Pure`;
- no CSE, hoisting, or rematerialization;
- the read carries the DMA dependency without forcing completion;
- a marker tells normal waitcnt analysis that the dependency is drained;
- materialization is bounded in compile time; the loop is a runtime loop.

Initial comparisons:

1. `s_waitcnt vmcnt(0)`;
2. tight `IB_STS.VM_CNT` poll;
3. `IB_STS.VM_CNT` poll with `s_sleep 1`.

This separates role specialization from polling policy.

## Sleep And Wakeup

LDS waits use:

```text
load mailbox
wait for load
compare exact target
if not ready:
  s_sleep 1
  retry
```

CDNA4 specifies `s_sleep 1` as an approximate 1 through 64 cycle sleep.

Publishers call `s_wakeup` only after a visible publication:

- last producer after the ready target is reached;
- last consumer after the done target is reached.

`s_wakeup` is an optimization, not a correctness edge. A wake can occur after
the comparison but before a waiter executes `s_sleep`. The sleep is finite;
the waiter wakes, reloads, and observes the mailbox.

The machine operation must carry ordering:

```mlir
%awake = waveamdmachine.s_wakeup after %published
    : !waveamdmachine.mem.token
```

It consumes the publication token and returns a token. It is side-effecting.
The scheduler cannot move it before the LDS store or returning atomic.

## Memory Ordering

All ordering remains explicit SSA plus token edges.

Producer chain:

```text
direct-to-LDS tokens
  -> waitcnt_poll completion
  -> ready returning atomic
  -> conditional s_wakeup
```

Consumer chain:

```text
ready mailbox poll
  -> LDS read tokens
  -> final-read completion
  -> done returning atomic
  -> conditional s_wakeup
```

Cross-wave communication uses LDS values. SSA values never cross mutually
exclusive role branches. No transform may infer ordering from LDS addresses,
operation names, or assumed aliasing.

## Compiler Surface

The kernel needs general mechanisms:

### Volatile Hardware-Register Read

Add an enum-typed hardware-register read or a dedicated volatile IB-status
read. Do not pass register names through strings.

The generic shape is:

```mlir
%raw = waveamdmachine.s_getreg
    #waveamdmachine.hwreg<ib_sts> offset 0 width 32
    : !waveamdmachine.reg<sgpr, 1>
```

AMDGPU MC lowering maps the enum to LLVM's hardware-register ID. The verifier
checks only the enum, slice, and result type. Target selection or lowering
rejects unavailable hardware registers.

Existing constant-like hardware-ID reads need not share the volatile trait.

### Counter Poll

`waveamd.vmem_wait_poll` is VMEM-specific because CDNA4 exposes that counter
through `IB_STS`. It carries no DMA timing attributes, kernel names, or
scheduler policy.

### Wakeup

Add token-ordered `s_wakeup` with normal SALU/control classification and AMDGPU
MC lowering. A raw no-operand wakeup is insufficient because scheduling could
separate it from publication.

### Shared Atomics

Use ordinary shared-memory load, store, and returning atomic-add semantics.
Machine lowering already has `ds_add_rtn_u32`. The Wave Python DSL needs a
structural shared atomic builder rather than injected assembly or textual MLIR.

## Pipeline

Required relative order:

```text
Wave Python DSL emits role control and explicit memory dependencies
machine selection expands finite poll loops into ordinary uniform control
normal hazard repair and greedy scheduling
normal waitcnt ticket analysis observes the poll-completion marker
ordinary regalloc, hazard waits, resource info, and AMDGPU lowering
```

Generated loop temporaries participate in normal scheduling, regalloc, and
hazard handling.

## Scheduler And Model

Each producer or consumer block uses the exact normal greedy scheduler:

- same dependency graph;
- same ready and pending sets;
- same recurrence handling;
- same stall fill;
- same bounded steady-state replay;
- same pressure retry.

New operations receive normal resource descriptions. The scheduler does not
ask whether the function is a persistent GEMM or whether a branch is a
producer.

The existing paired multi-wave scheduler does not apply because branch graphs
and runtime progress differ. A future heterogeneous-role model may instantiate
four producer placements and twelve consumer placements, but multi-wave state
must remain behind the normal query:

```text
would issuing this instruction stall for this placement?
```

No candidate selector, operation-name policy, or full-schedule veto belongs in
that extension.

Compile-time simulation remains bounded by fixed replay and refinement limits.
Runtime mailbox loops do not cause compiler iteration to convergence.

## Register Allocation

No role-specific regalloc machinery is part of the feature.

`uniform_if` already denotes mutually exclusive control flow. Required
behavior:

- producer and consumer branch-local intervals may reuse registers;
- values live into both branches interfere normally;
- branch-local accumulators end before the join;
- the join carries only the final token.

The profile exposed one generic bug: fixed-register reservations used the
envelope of disjoint branch ranges. Reservations now retain each range's
start/end, allowing the same physical register in sibling branches. A
one-VGPR regression test pins this behavior.

## Wave Python DSL Shape

The profile is authored in the Wave Python DSL:

```text
shared startup:
  descriptors, logical wave ID, mailbox initialization, one barrier

uniform_if wave_id >= 12:
  producer descriptors and persistent producer loop
otherwise:
  consumer accumulators, persistent consumer loop, output stores

function return
```

The profile remains a separate generator configuration, tentatively:

```text
gfx950-f16-256x256-16wave-persistent
```

Unsupported shapes fail clearly in the first version:

- gfx950 only;
- wave64 only;
- exactly 16 waves per workgroup;
- M and N multiples of 256;
- K multiple of 32;
- combined register allocation at most 128 dwords;
- aggregate LDS allocation within target capacity.

General tail handling follows only after the fixed shape is correct and faster.

## Correctness Invariants

1. Exactly four logical producer waves and twelve consumer waves execute.
2. Producer and consumer output/input ownership covers each tile once.
3. Each producer adds its ready bit once per generation.
4. Each consumer adds its done bit once per generation.
5. Ready publication follows completion of every owned direct-to-LDS write.
6. Slot reset follows the exact prior-generation done target.
7. Done publication follows completion of every consumer LDS read.
8. Mailbox generation is initialized before any participant publishes a bit.
9. Every sleep loop reloads state; wakeup delivery is never required.
10. No full workgroup barrier appears after startup.
11. No producer VMEM outside the owned DMA batch affects the polled counter.
12. All role-local values remain inside their uniform branch.

## Validation Plan

### Phase 0: ISA Microbenchmarks

Before GEMM:

- issue 1 through 24 direct-to-LDS loads;
- sample full `IB_STS` until decoded VM count reaches zero;
- verify every LDS byte against random global input;
- repeat with randomized delay before and during polling;
- compare against `s_waitcnt vmcnt(0)`;
- stress finite sleep with deliberately missed wake windows;
- run enough iterations to expose stale LDS or counter-wrap failures.

Any visibility mismatch rejects `IB_STS` polling. Keep the role design and use
the `s_waitcnt` control.

### Phase 1: Fixed GEMM

Add the separate 4-producer/12-consumer profile:

- three LDS stages;
- poll-to-zero producer completion;
- one streamed B fragment;
- no priorities beyond default;
- current XCD remap and output cache policy.

Run random end-to-end correctness for:

```text
M=N=256, K=32,64,96,256
M=N=4096, K=512,1024,4096,8192
multiple random seeds
HPL inputs
```

Small shapes use CPU comparison. Large shapes use the existing checked runner
where practical and repeated randomized stress otherwise. A watchdog treats a
hang as a correctness failure.

### Phase 2: Isolated Controls

Measure one change at a time:

1. producer `s_waitcnt vmcnt(0)`;
2. tight `IB_STS` polling;
3. `IB_STS` polling plus `s_sleep 1`;
4. wakeup disabled while finite sleep remains;
5. two-stage versus three-stage LDS ring;
6. all waves at priority 0;
7. producers at priority 0, active consumers at priority 1;
8. one, two, and four producer ownership only after the four-producer shape is
   correct;
9. thresholded multi-batch DMA using normal waitcnt ticket accounting.

No result is accepted from a single noisy sample.

### Phase 3: ATT

Compare baseline and candidate in the same session:

- barrier and poll-loop residence;
- MFMA issue utilization;
- LDS read and LDS atomic pressure;
- direct-to-LDS accept stalls;
- producer lead and ring occupancy;
- consumer wait duration;
- output-store tail;
- per-SIMD role balance.

Instrumented counters or markers use a separate diagnostic build. They do not
remain in the measured kernel.

### Phase 4: Repository Gates

Before enabling the profile in `all`:

```text
check-wave-mlir
check-wavec
Integration
PerfGolden
full gfx950 perf sweep with random inputs
focused HPL sweep
```

Golden drift is acceptable only when correctness holds and measured
performance does not regress. Existing profiles must retain their current
performance.

## Measured Result

Strict random checks pass at K=32 and K=128 for both completion modes. The
K=128 test reuses ring slot zero. A 256x256x8192 polling kernel passes random
data exactly and HPL data with 0.5 maximum f16 difference. Two thousand
consecutive K=8192 polling launches complete under a 30-second watchdog.
Scheduled K=8192 compilation takes 0.55 seconds and 105 MiB peak RSS.

All throughput rows use random 8192x8192x8192 inputs, 20 launches, five
warmups, and nine same-session repeats. Medians use the same generated runner
and no clock changes.

| Kernel | Completion | Median us | TFLOP/s | vs 4-wave |
|---|---|---:|---:|---:|
| persistent | tight `IB_STS` poll | 1188.799 | 924.893 | -31.70% |
| persistent | `IB_STS` poll + `s_sleep 1` | 1195.288 | 919.870 | -32.07% |
| persistent | `s_waitcnt vmcnt(0)` | 1176.327 | 934.700 | -30.98% |
| existing 4-wave | `s_waitcnt` | 811.930 | 1354.195 | baseline |
| existing 8-wave | `s_waitcnt` | 863.081 | 1273.938 | -5.93% |

Polling is not the gap: blocking waitcnt is 1.3% faster than the best poll.

ATT captured one workgroup batch from the persistent waitcnt control and the
4-wave baseline. Both execute 131072 MFMAs and 16384 direct-to-LDS loads in
the captured waves.

| Wave role | Traced waves | Wall cycles/wave | MFMA/wave | MFMA cycles/op | Wait cycles/wave | D2L cycles/op |
|---|---:|---:|---:|---:|---:|---:|
| persistent 64x80 consumer | 16 | 494913 | 5120 | 25.00 | 79566 | 0 |
| persistent 64x96 consumer | 8 | 508438 | 6144 | 23.64 | 130874 | 0 |
| persistent producer | 8 | 452870 | 0 | 0 | 219551 | 11.62 |
| existing 4-wave | 8 | 294704 | 16384 | 11.94 | 5771 | 14.49 |

Dedicated producers reduce direct-to-LDS cost. Consumer MFMA issue cost still
doubles because three compute waves per SIMD repeatedly block on streamed B
reads and mailbox waits. The baseline wave carries enough independent MFMA
work to cover those dependencies at one resident wave per SIMD.

One-launch PMC collection confirms that attribution:

| Counter | Persistent | 4-wave | Ratio |
|---|---:|---:|---:|
| `MfmaUtil` | 47.058% | 82.006% | 0.57x |
| `MeanOccupancyPerActiveCU` | 3.745 | 1.000 | 3.74x |
| `SQ_WAIT_INST_ANY` | 650293084 | 178321342 | 3.65x |
| `SQ_WAIT_INST_LDS` | 111408952 | 13305217 | 8.37x |
| `SQ_LDS_CMD_FIFO_FULL` | 18023329 | 854881 | 21.08x |
| `LdsLatency` | 58.260 | 54.652 | 1.07x |
| `LdsUtil` | 28.667% | 40.759% | 0.70x |

The persistent ISA uses 124 vector dwords, 26 SGPRs, no scratch, no relief,
98336 bytes of dynamic LDS, and one startup barrier. Resource fit and
cross-wave protocol are correct; the role partition is slower.

## Acceptance

Required:

- zero random-data mismatches;
- no hang under repeated sleep/wakeup stress;
- no scratch or LDS regalloc relief;
- combined register allocation at most 128 dwords;
- LDS usage at most the planned ring plus explicit mailbox allocation;
- no steady-state `s_barrier`;
- bounded compile time;
- no scheduler special path;
- no regression in the existing full perf sweep.

The profile stays out of the default sweep. It remains available through
`--kernels=f16-persistent` for follow-up experiments.

## Findings

### Counter Semantics

Poll-mode random and HPL checks through 256 K-stages observe no stale LDS.
This is empirical gfx950 evidence, not a portable ISA guarantee.

### Compute Occupancy

Three compute waves per SIMD do not cover streamed-read and MFMA dependencies.
Measured MFMA utilization is 47.1% despite 3.745 mean occupancy.

### Register Limit

The largest consumer fits at 124 vector dwords without spill or relief.
Keeping all six B fragments would exceed the 128-dword occupancy budget.

### Mailbox Cost

Every K32 stage adds four ready atomics, twelve done atomics, LDS polls, and
wakeups. `SQ_WAIT_INST_LDS` rises 8.37x and command-FIFO-full cycles rise
21.08x.

### Logical-To-Physical Mapping

ATT sees the producer slot on each selected SIMD. D2L cost falls from 14.49 to
11.62 cycles per instruction, so producer placement is not the loss.

### Store Layout

Strict random checks confirm disjoint 5/5/6 ownership. Ordinary MFMA output
requires 64-bit column-major stores; the baseline's coalesced output path is
wider.

## Follow-Up Questions

- Is ring depth three useful once consumer release moves before the MFMA tail?
- Should producers run at elevated priority only while issuing DMA?
- Does a two-producer, one-per-SIMD-pair variant offset its less regular
  consumer partition?
- Can a different ownership split retain baseline MFMA ILP without exceeding
  128 vector dwords?
- Can publication avoid sixteen returning atomics per K32 without a full
  workgroup barrier?

## References

- [AMD Instinct CDNA4 ISA](https://www.amd.com/content/dam/amd/en/documents/instinct-tech-docs/instruction-set-architectures/amd-instinct-cdna4-instruction-set-architecture.pdf)
- [GFX950 matmul profiles](Gfx950MatmulProfiles.md)
- [WaveAMDMachine multi-wave specialization](WaveAMDMultiWaveSpecializationDesign.md)
- [GFX950 split-barrier emulation](Gfx950SplitBarrierEmulation.md)
- `lib/Dialect/WaveAMDMachine/CostModel/ArchData.cpp`
- `lib/Dialect/Wave/Transforms/WaveAMDMaterializeSplitBarriers.cpp`
- `test/PerfGolden/Inputs/gfx950-f16-256x256-16wave.s`
