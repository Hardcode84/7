# GFX950 Stream-K GEMM with same-kernel reduction

## Status

Proposed. First implementation targets the opt-in
`gfx950-f16-256x256-4wave` kernel.

The initial mode uses a static persistent grid and contiguous Stream-K
partitions. Whole output tiles bypass all fixup state. Split boundary tiles use
FP32 global scratch and a deadlock-free last-arriver reduction in the same
kernel.

## Decision

Build Stream-K in the Wave Python DSL. Keep the normal matmul scheduler,
machine model, and register allocator.

Use:

- four-wave `256x256x64` GEMM as the compute kernel;
- one persistent workgroup per selected worker;
- static balanced partitions of flattened `(tile, K iteration)` work;
- direct epilogue for whole tiles;
- at most two scratch partials per worker;
- returned device-scope atomics for last-arriver election;
- fixed-order FP32 reduction by the elected workgroup;
- no cross-workgroup spin loop.

Do not use:

- a grid-wide barrier;
- a designated reducer waiting for unscheduled workgroups;
- atomic accumulation into C;
- FP16 partial accumulators;
- dynamic MFMA work stealing;
- compiler recognition of GEMM or Stream-K patterns;
- post-greedy schedule selection.

## Motivation

Stream-K divides aggregate inner-loop iterations evenly among physical
workers. It can remove persistent-grid tail loss and amortize workgroup setup
without changing the GEMM main loop.

Saved same-session gfx950 results bound the expected gain:

| Kernel | Workgroups | Time us | PFLOP/s |
|---|---:|---:|---:|
| hipBLASLt solution 2530, StreamK 0 | 1024 | 732.855 | 1.500313 |
| hipBLASLt solution 2531, StreamK 5 | 256 | 718.835 | 1.529574 |

The 14.020 us reduction is 1.95% of the data-parallel time. Stream-K is
supporting machinery, not an explanation for the remaining main-loop gap.

The four-wave Wave profile already has:

```text
CTA tile:             256 x 256
K iteration:          64
Waves per workgroup:  4
Target waves/SIMD:    1
Dynamic LDS:          133120 bytes
Output:               coalesced MFMA, column-major, sc0 nt
CTA mapping:          8 XCDs, group M by 4
```

Its LDS allocation admits one such workgroup per CU. A CU-sized persistent
grid is therefore the natural starting point.

## Scope

The design covers:

- static work decomposition;
- whole and partial tile control flow;
- scratch and counter ABI;
- cross-workgroup publication;
- deterministic same-kernel reduction;
- XCD-aware tile traversal;
- compiler prerequisites;
- correctness and performance gates.

Dynamic per-XCD queues are deferred. They can claim whole tiles later without
changing partial-tile reduction.

The first kernel supports `batch=1`. Batch remains in the partition formulas
so extending the ABI does not change work identity or fixup layout.

## Work decomposition

Let:

```text
TM = M / 256
TN = N / 256
T  = batch * TM * TN
I  = K / 64
W  = T * I
P  = persistent worker count
```

All products, interval endpoints, and inverse-owner calculations use unsigned
64-bit arithmetic.

Require:

```text
M > 0
N > 0
K > 0
M % 256 == 0
N % 256 == 0
K % 64 == 0
1 <= P <= W
```

Worker `p` receives a balanced half-open interval:

```text
q = W / P
r = W % P

begin(p) = p*q + min(p, r)
end(p)   = begin(p) + q + (p < r)
```

Every work index maps to:

```text
tile_position = work / I
k_iteration   = work % I
tile_id       = map_tile(tile_position)
```

`map_tile` reuses the existing grouped XCD permutation. Stream-K partitions
logical tile positions before the permutation. All contributors to one
position therefore use the same tile coordinates, scratch identity, and
counter.

Each worker interval contains:

- an optional partial first tile;
- zero or more whole tiles;
- an optional partial last tile.

When both boundaries lie in one tile, that tile uses one partial slot. No
worker writes more than two partials.

### Inverse owner map

Fixup needs the workers intersecting a tile. Invert the same balanced
partition:

```text
large_end = r * (q + 1)

owner(work) =
  work / (q + 1)                         if work < large_end
  r + (work - large_end) / q             otherwise
```

`q` is nonzero because `P <= W`.

For tile position `t`:

```text
first_owner = owner(t*I)
last_owner  = owner((t + 1)*I - 1)
parts       = last_owner - first_owner + 1
```

`parts == 1` is a whole tile. It never touches scratch or a counter.

## Aligned 8192 case

For `M=N=K=8192`, `P=256`:

```text
T = 32 * 32 = 1024
I = 8192 / 64 = 128
W = 131072
q = W / P = 512 = 4 * I
r = 0
```

Every worker receives four complete output tiles. Generated control flow takes
the whole-tile path only:

- no partial stores;
- no global atomics;
- no counter loads;
- no reduction;
- no workspace reads.

The remaining overhead is persistent-loop control and tile-coordinate
calculation. This shape must show no fixup instructions in the hot path.

## Kernel structure

The kernel keeps the existing K64 matmul body:

```text
worker interval
  for each intersected tile:
    initialize accumulator
    run assigned contiguous K iterations

    if complete tile:
      coalesced epilogue
      store C
    else:
      publish partial
      if last arrival:
        reduce all partials
        coalesced epilogue
        store C
        reset counter
```

The persistent outer loop is runtime bounded. Compilation emits one tile loop
and one K loop; it does not unroll workers, tiles, or fixup peers.

The outer loop carries an explicit memory token. Each tile's terminal LDS use
orders a workgroup barrier before the next tile reuses staging storage.
Whole-tile output stores, partial publication, reduction, and counter reset
join the tile's exit token. No pass infers loop-carried memory dependencies.

The normal greedy scheduler sees the same K64 body as the existing four-wave
profile. Stream-K adds prologue and epilogue control flow around it.

## Scratch layout

Partial accumulators remain FP32.

Reserve two full logical output-tile slots per worker:

```text
partial_slots = 2 * P
slot_bytes    = 256 * 256 * 4 = 262144
scratch_bytes = partial_slots * slot_bytes
```

At `P=256`, the conservative allocation is 128 MiB. Only actual partial slots
are written.

Slot identity is structural:

```text
head slot = 2*p
tail slot = 2*p + 1
```

If a worker has one partial tile, it uses the head slot. If it has two, lower
tile position uses head and higher tile position uses tail.

The reducer derives every contributor slot from `begin(owner)`, `end(owner)`,
and the tile position. No slot table or host-generated string encoding is
needed.

Scratch stores use the coalesced logical output ownership already used by the
four-wave epilogue. Reducer waves load the same partition. Scratch layout must
not expose physical AGPR numbering.

The first implementation favors simple addressing over workspace size.
Compacting boundary slots requires measured value before adding metadata.

## Counter layout

Allocate one aligned 32-bit arrival counter per logical tile position:

```text
counter_bytes = align_up(T * 4, 256)
```

Counters are zero before the first launch. The last reducer resets its counter
to zero after the final output store. Serialized launches on one stream can
reuse the workspace without another kernel or per-launch memset.

Workspace ownership rules:

- one workspace belongs to one in-flight kernel sequence;
- concurrent streams use disjoint workspaces;
- failed or interrupted launches require counter reinitialization;
- scratch contents need no initialization.

An epoch-tagged 64-bit counter is deferred. It is useful only if sharing one
workspace across independently ordered launches becomes a requirement.

## Last-arriver protocol

Every partial contributor follows this protocol:

1. Store its FP32 partial through all four waves.
2. Join all store tokens.
3. Complete a workgroup barrier ordered after those stores.
4. Workitem 0, lane 0 of logical wave 0, performs an acquire-release atomic
   increment on the tile counter.
5. Workitem 0 writes `old_count + 1 == parts` to an LDS broadcast word.
6. Workgroup barrier broadcasts the decision.
7. Non-last workgroups continue or exit.
8. The last workgroup acquires the final counter value in every reducing wave.
9. All waves load and sum contributor slots in ascending K order.
10. Run the normal coalesced epilogue and store C.
11. Barrier after the output stores.
12. Workitem 0 resets the tile counter to zero with release ordering.

No workgroup polls for another workgroup. Progress does not depend on dispatch
order or total residency.

### Why acquire-release RMW

Each arrival must incorporate the publication before it in the atomic
modification order. Acquire-release RMW operations form a transitive chain:
the last arrival observes all earlier partial stores before reduction loads.

Workitem 0 alone receives the returned count. An LDS broadcast communicates
the election, not global memory visibility. Each reducing wave performs its
own device-scope acquire before loading scratch.

SSA tokens encode instruction order:

```text
partial stores
  -> store completion
  -> workgroup barrier
  -> counter RMW
  -> reducer broadcast
  -> per-wave counter acquire
  -> scratch loads
  -> reduction
  -> output stores
  -> counter reset
```

Tokens do not replace device memory semantics. Global atomic order and scope
remain explicit operation properties.

## Deadlock argument

A designated receiver that spin-waits can occupy a CU while its producer is
not resident. Enough receivers can fill the device and block all producers.
Physical workgroup reordering across XCDs makes dispatch-order assumptions
fragile.

Last-arriver election removes the wait:

- every contributor publishes and remains runnable;
- non-last contributors release their CU;
- the final contributor already has all required publications;
- reduction starts only after the returned count proves completion.

The protocol remains live when `P` exceeds instantaneous residency. The
initial persistent profile still uses a CU-sized grid for performance.

## Reduction

Reducer waves sum partials in increasing K-segment order. The elected
workgroup's own partial is reloaded from scratch in the initial version. This
keeps numerical order independent of which workgroup arrives last.

Reduction happens after the K main loop, so main-loop A/B fragments are dead.
Regalloc may reuse their registers for partial loads and FP32 sums. Relief is
not accepted:

- no Scratch spill;
- no LDS spill;
- no AGPR bridge increase that lowers occupancy.

The final FP16 conversion and output store happen once, after full FP32
reduction.

Atomic add into C is rejected:

- 65536 atomics per output tile;
- nondeterministic accumulation order;
- no single final FP16 conversion point;
- high contention on adjacent cache lines.

## Numerical contract

Static partition boundaries and contributor order are deterministic for fixed
`M`, `N`, `K`, batch, and `P`.

Split accumulation reassociates FP32 additions relative to the data-parallel
kernel. Bitwise equality with the unsplit kernel is not required. Tests use the
existing FP16 GEMM error contract and also require:

- repeated runs produce identical output bits;
- random seeds cover positive, negative, normal, and subnormal inputs;
- HPL inputs pass;
- whole-tile Stream-K output matches the original kernel exactly;
- reduction stores FP32, never FP16.

## XCD and cache mapping

The existing `cta_swizzle_xcds=8`, `cta_group_m=4` permutation remains the
single tile mapping implementation.

Static workers traverse contiguous logical tile positions. The first
experiment compares:

1. current grouped permutation;
2. row-major logical positions;
3. grouped positions with worker IDs interleaved across XCDs.

Mapping changes never affect fixup liveness because no receiver spins. They
remain kernel-level traversal choices, not scheduler policy.

Dynamic per-XCD queues may later claim chunks of whole tile positions.
Partial-tile participant sets stay static so `parts` and scratch slots remain
derivable.

## Compiler boundary

Most work belongs in the Wave Python DSL kernel:

- balanced interval math;
- tile traversal;
- whole/partial branching;
- scratch addressing;
- counter selection;
- reduction;
- workspace ABI.

Wave currently lacks a high-level global atomic contract for this protocol.
Add only general operations if required:

```text
global_atomic_add_return(ptr, value, order, scope, after) -> old, token
global_atomic_load(ptr, order, scope, after) -> value, token
global_atomic_store(ptr, value, order, scope, after) -> token
memory_fence(order, scope, after) -> token
```

Required orders are acquire, release, and acquire-release. Required scope is
the GPU agent/device. Verifiers check local types, supported orders, and
scopes. Cross-operation legality stays in lowering or validation passes.

AMDGPU lowering must use MC instructions and preserve returned values plus
memory tokens. Use `memory_fence` only where the selected atomic and barrier
semantics do not already provide the required visibility; never insert it by
pattern matching. The waitcnt pass drains explicit dependencies. The scheduler
classifies global atomics and fences through the normal machine resource model.

Do not add:

- a Stream-K dialect op;
- a GEMM-name check;
- kernel-profile checks in C++;
- a scheduler mode;
- implicit alias or memory-order edges;
- post-schedule cycle vetoes.

## Runner and profile

Add one opt-in profile:

```text
gfx950-f16-256x256-4wave-streamk
```

It inherits the existing four-wave profile and adds a Stream-K kernel ABI.
Keep it out of `all` until correctness and the full sweep pass.

Runner arguments add:

```text
partial scratch pointer
counter pointer
persistent worker count
```

The runner:

- computes the conservative workspace size structurally;
- allocates FP32 scratch and counters;
- zeros counters before the first launch;
- reuses workspace across ordered warmup and timed launches;
- rejects shared workspace across concurrent launches;
- checks counters return to zero in debug runs.

`P` defaults to the detected CU count, then rounds only when an XCD experiment
requires it. A command-line override is a benchmark input, not a compiler
knob.

## Selection policy

The first profile always uses static Stream-K so behavior is measurable.
Default profile selection remains unchanged.

Future automatic selection compares:

```text
saved tail and setup time
  versus
partial FP32 store bytes
+ partial FP32 load bytes
+ counter and barrier cost
+ cache-locality loss
```

Reject splits with:

- fewer than eight K64 iterations per contributing worker;
- excessive partial count;
- workspace above the configured runtime budget;
- predicted fixup cost above saved tail time.

When `W % P == 0` and `(W / P) % I == 0`, select the aligned persistent path.
It has no reduction cost.

## Validation

### Synthetic protocol tests

Cover:

- one whole tile;
- two contributors to one tile;
- more workers than tiles;
- one worker interval contained inside one tile;
- head and tail partials from one worker;
- `r == 0` and `r != 0`;
- worker counts above physical residency;
- counter reuse over thousands of launches;
- XCD permutations;
- interrupted-launch counter reinitialization.

Reference tests enumerate work indices and prove:

- intervals are disjoint;
- intervals cover `[0, W)`;
- every tile covers K exactly once;
- every partial maps to one scratch slot;
- `parts` equals published partial count;
- one and only one contributor wins each split tile.

### Integration

Add random and HPL hardware checks for:

- aligned `8192x8192x8192`, reduced smoke iteration count;
- a smaller aligned whole-tile shape;
- a two-way split tile;
- a tile with at least three contributors;
- nonzero partition remainder;
- repeated workspace reuse;
- worker count above residency.

Tests verify no deadlock with a timeout and compare the final FP16 output.

### Performance

Measure against the unchanged four-wave profile in one session:

- random and HPL `8192x8192x8192`;
- the full documented f16 K sweep;
- awkward tile counts around multiples of `P`;
- small M/N and large K split cases;
- worker counts around CU and XCD multiples.

Record:

- TFLOP/s and launch time;
- whole and split tile counts;
- scratch bytes touched;
- atomic arrivals;
- CU occupancy over time;
- L2 hit rate and XCD traffic;
- VMEM store/load stalls;
- MFMA utilization.

The aligned 8192 kernel must not regress beyond measurement noise. Existing
`all` sweep profiles must not regress.

## Compilation bound

All loops are runtime loops:

- persistent tile loop;
- K64 loop;
- contributor reduction loop.

Compiler simulation and reporting keep their existing bounded trip-count
policy. No transform iterates to runtime `P`, `T`, `I`, or split count.

## Implementation sequence

1. Add pure partition and scratch-slot helpers with exhaustive Python tests.
2. Add general device-scope returned global atomics and memory-order tests.
3. Wrap the existing four-wave body in the static persistent whole-tile loop.
4. Validate aligned 8192 codegen has no fixup operations on the taken path.
5. Add partial publication and last-arriver election.
6. Add deterministic FP32 reduction and counter reset.
7. Add runner workspace ownership and repeated-launch checks.
8. Add Integration and PerfGolden coverage.
9. Run focused correctness, ATT, PMC, and full performance sweeps.
10. Consider compact scratch or dynamic whole-tile queues only after profiling.

Each step remains separately reviewable. Compiler support lands independently
from the GEMM kernel.

## Open questions

- Does gfx950 need an explicit cache invalidation in addition to acquire
  semantics before scratch loads?
- Is one acquire counter load per reducing wave sufficient under the selected
  AMDGPU memory scope?
- Does FP32 scratch use the current coalesced output layout or a dedicated
  reduction layout?
- Is reloading the elected workgroup's partial cheaper than preserving it
  through the election?
- Which `P` gives the best XCD balance on the target system?
- Does a compact `P`-slot protocol justify a chained handoff without spinning?

Resolve memory-visibility questions with a standalone cross-workgroup
publication microbenchmark before GEMM performance claims.

## References

- [Stream-K paper](https://arxiv.org/abs/2301.03598)
- [Wave four-wave gfx950 results](PerfReferences/WaveGfx950F16Gemm4Wave.md)
- `rocm-libraries/shared/rocroller/lib/source/KernelGraph/Transformations/AddStreamK.cpp`
- `rocm-libraries/shared/origami/src/origami/origami.cpp`
- `rocm-libraries/shared/origami/src/origami/streamk.cpp`
