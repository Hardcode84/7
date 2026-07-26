# GFX950 asymmetric persistent-wave f16 GEMM

## Status

Implemented as three opt-in profiles:

- `gfx950-f16-256x256-16wave-persistent`: original streamed consumer;
- `gfx950-f16-256x256-16wave-persistent-pipelined`: buffered B reads and early
  stage release;
- `gfx950-f16-256x256-16wave-persistent-pipelined-k64`: two K32 slices per
  mailbox generation.

The K64 profile reaches 1073.2 TFLOP/s at 8192x8192x8192, 11.3% above the
pipelined K32 profile. It remains 27.4% below the current 4-wave kernel, so all
three profiles stay out of the default sweep.

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

The K64 variant batches two adjacent K32 slices into one mailbox generation.
Each stage is 64 KiB. Two stages plus four mailbox words use 131104 dynamic
bytes. This halves publication and polling frequency per K32 without changing
the direct-to-LDS instruction count.

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

Pipelined consumers prefetch four B fragments for 64x80 strips and two for
64x96 strips. The done atomic issues after the final B read completes and
before the final four MFMAs. K64 consumers repeat this sequence for both K32
slices and publish only after the second slice.

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

The profiles remain separate generator configurations:

```text
gfx950-f16-256x256-16wave-persistent
gfx950-f16-256x256-16wave-persistent-pipelined
gfx950-f16-256x256-16wave-persistent-pipelined-k64
```

Unsupported shapes fail clearly in the first version:

- gfx950 only;
- wave64 only;
- exactly 16 waves per workgroup;
- M and N multiples of 256;
- K multiple of 32;
- K64 mode requires K multiple of 64 and K at least 192;
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

Strict K64 random checks pass exactly at K=192 and K=256 for seeds 1, 7, 29,
83, and 211. HPL checks pass with maximum differences 0.003906 and 0.007812.
K=64 and K=128 trigger Scratch relief; K=128 then fails strict random checks
nondeterministically. K64 mode rejects K below 192 until `7-2bb` fixes that
general regalloc path.

Two thousand consecutive K=8192 polling launches complete under a 30-second
watchdog. Scheduled K64 K=8192 compilation takes 0.93 seconds and 105 MiB peak
RSS.

All measurements use the same generated runner and no clock changes. The
original completion controls use 20 launches, five warmups, and nine repeats:

| Completion | Median us | TFLOP/s |
|---|---:|---:|
| tight `IB_STS` poll | 1188.799 | 924.893 |
| `IB_STS` poll + `s_sleep 1` | 1195.288 | 919.870 |
| `s_waitcnt vmcnt(0)` | 1176.327 | 934.700 |

Polling is not the original gap: blocking waitcnt is 1.3% faster than the best
unpipelined poll.

The final random 8192x8192x8192 sweep uses 200 launches, 25 warmups, and nine
repeats:

| Kernel | Median us | TFLOP/s | vs 4-wave |
|---|---:|---:|---:|
| pipelined K32 | 1139.889 | 964.58 | -34.72% |
| pipelined K64 | 1024.521 | 1073.20 | -27.37% |
| existing 8-wave | 804.503 | 1366.70 | -7.51% |
| existing 4-wave | 744.067 | 1477.71 | baseline |

K64 batching gains 11.26% over pipelined K32. HPL medians are 939.43 and
856.20 TFLOP/s respectively, a 9.72% K64 gain.

A coordinator-only publication experiment replaced every returning atomic with
a non-returning atomic and made one wave poll the final target. It regressed
1.24% in an interleaved run:

| Publication | Median us | TFLOP/s |
|---|---:|---:|
| participant returning atomics | 1049.847 | 1047.307 |
| coordinator target poll | 1063.077 | 1034.273 |

The coordinator serializes progress and adds another poller. The general
non-returning atomic support and coordinator profile were removed.

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

ATT isolates the K64 gain and its remaining cost:

| ATT metric | K32 waitcnt | Pipelined K64 | Delta |
|---|---:|---:|---:|
| mailbox atomic hits | 8192 | 4096 | -50.0% |
| wait instruction cycles | 4076474 | 2042010 | -49.9% |
| direct-to-LDS cycles/op | 11.621 | 7.465 | -35.8% |
| MFMA cycles/op | 24.493 | 26.817 | +9.5% |

One-launch PMC collection shows higher useful issue despite the slower traced
MFMA instruction:

| Counter | K32 waitcnt | Pipelined K64 | Delta |
|---|---:|---:|---:|
| `MfmaUtil` | 47.058% | 55.039% | +7.981 pp |
| `MeanOccupancyPerActiveCU` | 3.745 | 3.713 | -0.9% |
| `SQ_WAIT_INST_ANY` | 650293084 | 615746710 | -5.3% |
| `SQ_WAIT_INST_LDS` | 111408952 | 97563948 | -12.4% |
| `SQ_LDS_CMD_FIFO_FULL` | 18023329 | 14431714 | -19.9% |
| `LdsLatency` | 58.260 | 56.386 | -3.2% |
| `LdsUtil` | 28.667% | 31.399% | +2.732 pp |

The K64 ISA uses 128 vector dwords, 26 SGPRs, no scratch, no relief, 131104
bytes of dynamic LDS, and one startup barrier. Batching removes mailbox and
producer-wait overhead. Consumer MFMA/LDS interleave remains the bottleneck.

The default `all` sweep completed 31 of 31 kernels. Against the preceding
same-command CSV, non-K512 rows range from -0.71% to +1.42%. K512 rechecks are
-0.91% for 8-wave and -1.54% for 4-wave at roughly 21 microseconds per launch;
their checked assembly is unchanged.

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

The profiles stay out of the default sweep. They remain available through
`--kernels=f16-persistent`, `--kernels=f16-persistent-pipelined`, and
`--kernels=f16-persistent-pipelined-k64`.

## Findings

### Counter Semantics

Poll-mode random and HPL checks through 256 K-stages observe no stale LDS.
This is empirical gfx950 evidence, not a portable ISA guarantee.

### Compute Occupancy

Three compute waves per SIMD do not cover streamed-read and MFMA dependencies.
K64 batching raises MFMA utilization from 47.1% to 55.0% without changing
occupancy.

### Register Limit

The largest K32 consumer fits at 124 vector dwords. Pipelined K64 reaches the
128-dword occupancy limit without spill or relief.

### Mailbox Cost

Every publication adds four ready atomics and twelve done atomics. K64 batches
two K32 slices per publication, halving atomic hits and ATT wait cycles.

### Logical-To-Physical Mapping

ATT sees the producer slot on each selected SIMD. D2L cost falls from 14.49 to
11.62 cycles per instruction, so producer placement is not the loss.

### Store Layout

Strict random checks confirm disjoint 5/5/6 ownership. Ordinary MFMA output
requires 64-bit column-major stores; the baseline's coalesced output path is
wider.

## Follow-Up Questions

- Should producers run at elevated priority only while issuing DMA?
- Does a two-producer, one-per-SIMD-pair variant offset its less regular
  consumer partition?
- Can a different ownership split retain baseline MFMA ILP without exceeding
  128 vector dwords?
- Can MFMA/LDS ordering improve without increasing the 128-dword register
  footprint?

## References

- [AMD Instinct CDNA4 ISA](https://www.amd.com/content/dam/amd/en/documents/instinct-tech-docs/instruction-set-architectures/amd-instinct-cdna4-instruction-set-architecture.pdf)
- [GFX950 matmul profiles](Gfx950MatmulProfiles.md)
- [WaveAMDMachine multi-wave specialization](WaveAMDMultiWaveSpecializationDesign.md)
- [GFX950 split-barrier emulation](Gfx950SplitBarrierEmulation.md)
- `lib/Dialect/WaveAMDMachine/CostModel/ArchData.cpp`
- `lib/Dialect/Wave/Transforms/WaveAMDMaterializeSplitBarriers.cpp`
- `test/PerfGolden/Inputs/gfx950-f16-256x256-16wave.s`
