# GFX950 LDS-emulated split barriers

## Goal

Expose split barrier semantics in WaveAMDMachine IR so the scheduler can move
barrier arrival earlier than the blocking wait.

Target shape:

```mlir
%state = waveamdmachine.barrier_init
...
%ticket, %arrived = waveamdmachine.barrier_arrive %state after %deps
    : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
...
%ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
    : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
```

`barrier_init` is created at kernel entry by the split pass. Each converted
static barrier site captures its init result as an SSA value. `barrier_arrive`
produces the arrival ticket and normal mem token consumed by `barrier_wait`;
users of the original monolithic barrier token consume the wait result.

The first implementation is gfx950-only and uses LDS atomics. Other targets keep
`waveamdmachine.s_barrier`.

## Current Problem

`wave.barrier` lowers directly to `waveamdmachine.s_barrier`. That op has two
jobs:

- drain memory dependencies before the hardware barrier;
- produce the post-barrier token consumed by later memory ops.

This makes the barrier indivisible to the scheduler. Independent MFMA or scalar
work that could run after all waves have arrived but before the consumer-side
wait has no IR slot to occupy.

Split barriers separate those two roles:

- `barrier_arrive` is the producer-side ordering point;
- `barrier_wait` is the consumer-side convergence point;
- only `barrier_wait` produces the replacement token for original barrier
  consumers.

## IR Contract

### `barrier_init`

One `barrier_init` is inserted in the kernel entry block for every static
barrier converted to split form.

Result type:

```mlir
!waveamdmachine.barrier
```

The value is an opaque handle for the static barrier slot. It is not a memory
token. It carries static identity only; the materialization pass assigns LDS
state and offsets after it knows all split barriers in the function.

No required attrs. A static site id may be added for diagnostics.

`barrier_init` has no user-visible memory ordering effect. Materialization emits
the actual LDS initialization at kernel entry and batches all init stores behind
one real startup `s_barrier`.

### `barrier_arrive`

`barrier_arrive` consumes:

- the `barrier_init` handle;
- zero or more pre-barrier memory dependency tokens.

It returns:

- one `!waveamdmachine.reg<vgpr, 1>` arrival ticket;
- one `!waveamdmachine.mem.token` arrival token.

The token is not a post-barrier token. It has the ordinary mem-token type so
the existing scheduler and waitcnt machinery can reuse the same dataflow path,
but split-barrier validation must restrict uses:

- direct use of the ticket and token by the matching `barrier_wait`;
- token-only plumbing that is proven to feed the matching wait;
- no original post-barrier memory consumer may use the arrive ticket or token.

The split pass rewrites all original barrier users to the wait result.

### `barrier_wait`

`barrier_wait` consumes:

- the same `barrier_init` handle;
- the arrival ticket from `barrier_arrive`;
- the arrival token from `barrier_arrive`.

It returns the post-barrier `!waveamdmachine.mem.token`. This result replaces
the original `s_barrier` result. Later LDS, VMEM, SMEM, and stores that were
ordered after the original barrier depend on this token.

`barrier_wait` must not accept arbitrary ticket/token operands. Both must come
from the matching arrive path.

## Split Pass

Pass placement:

```mlir
waveamd_backend_lower
waveamd-mma-reuse-preschedule
waveamd-hazard-repair
waveamd-split-barriers
waveamd-machine-schedule
waveamd-materialize-split-barriers
waveamd_backend_finish
```

The split pass:

1. Finds eligible `waveamdmachine.s_barrier` ops.
2. Creates one `barrier_init` per converted static barrier at kernel entry.
3. Replaces each barrier with `barrier_arrive` immediately followed by
   `barrier_wait`.
4. Replaces original barrier token uses with the wait result.
5. Leaves non-eligible barriers as `s_barrier`.

Eligibility:

- target is gfx950;
- barrier is in uniform machine control;
- expected waves per workgroup is known;
- function has fixed LDS accounting available;
- barrier result/token topology can be rewritten without token ambiguity.

Initial implementation can reject:

- dynamic LDS layouts whose addresses cannot be shifted safely;
- unknown workgroup shape;
- barriers under non-uniform control;
- token joins that make arrive-to-wait matching ambiguous.

For dynamic LDS, materialization reserves barrier state before the dynamic
segment and shifts existing LDS addresses by the reserved byte count. Both
VGPR-addressed DS ops and M0-based LDS DMA forms must be adjusted before new
barrier DS ops are inserted.

## LDS State

Each static split barrier reserves LDS state:

| Field | Size | Purpose |
|---|---:|---|
| `arrivals` | 4 bytes | monotonic count of arrived waves and ticket source |

One dword per barrier site is the protocol state. There is no LDS slot attr on
`barrier_init`; offsets are assigned during materialization. Padding may be
added to avoid known hot LDS-bank conflicts once measured.

Reservation must be part of normal LDS accounting. The materialization path
must update the function's fixed LDS size before regalloc LDS relief plans its
own spill slots. The manual timing probe used a hard-coded LDS address; the
production path must never alias user LDS or regalloc spill LDS.

Expected wave count is workgroup-wide:

```text
ceil(flat_workgroup_size / wavefront_size)
```

Use `wave.waves_per_workgroup` only when present and consistent with the known
workgroup shape. `waveamdmachine.target_waves` is not the barrier count; it is a
register-pressure target.

## Runtime Protocol

### Initialization

At kernel entry:

1. Elect one active lane per wave.
2. Store zero to every split-barrier `arrivals` slot.
3. Drain LDS stores.
4. Execute one real `s_barrier`.

Multiple waves may write the same zero values to the same slots. The startup
barrier prevents a later zero store from racing with the first arrive.

### Arrive

For each dynamic barrier instance:

1. Elect one lane per wave under full EXEC.
2. Issue `ds_add_rtn_u32 arrivals, 1` for the elected lane.
3. Restore EXEC.

Arrive must not consume the returned ticket. It also must not force
`s_waitcnt lgkmcnt(0)` for the original barrier dependencies. The arrive token
carries those dependencies forward; the counter update is the convergence
signal and the returned value is the dynamic barrier ticket.

This is the key limitation: arrival can be observed before older LDS/VMEM
dependencies have drained. Correctness comes from the wait result token still
depending on the original pre-barrier tokens. Post-barrier memory consumers
cannot issue until the normal waitcnt path drains those dependencies.

The materialized ticket VGPR is live from arrive to wait. This is intentional:
the return latency can be hidden by work scheduled between the split ops, but
the scheduler must account for the pressure cost of widening that gap.

### Wait

`barrier_wait` takes the synchronization cost:

1. Elect the same one lane per wave under full EXEC.
2. `s_waitcnt lgkmcnt(0)` and scalarize the arrival ticket.
3. Compute `target = ((ticket / expected_waves) + 1) * expected_waves`.
4. Poll until the monotonic counter reaches `target`:
   - `ds_read_b32 arrivals`;
   - `s_waitcnt lgkmcnt(0)`;
   - scalarize the value;
   - branch back while `arrivals < target`.
5. Restore EXEC.

The wait result token is produced after the successful poll. Downstream memory
operations depend on that token, so ticket waits still see an explicit
post-barrier ordering edge.

The arrival ticket fixes the dynamic barrier generation before wait-side skew
can appear. A fast wave that reaches the next dynamic arrive takes a later
ticket generation and cannot satisfy a slow wave's current `target` early.
`arrivals >= target` releases exactly when all waves in the ticket generation
have issued their arrives.

No counter reset is needed. Loop-carried barriers reuse the same LDS state
without a reset/arrive race. The v1 lowering may reject kernels whose dynamic
barrier count can overflow 32-bit monotonic counters.

## Scheduler Model

The scheduler sees three new op classes:

- `barrier_init`: no hot instruction cost; SSA dependency anchor.
- `barrier_arrive`: schedulable LGKM/DS-like producer-side op.
- `barrier_wait`: schedulable wait-side op with a token dependency on arrive.

Scheduling intent:

```text
pre-barrier LDS/VMEM deps
barrier_arrive
independent MFMA/SALU/VALU work
barrier_wait
post-barrier LDS/VMEM consumers
```

`barrier_arrive` must not be modeled as a zero-cost marker. It issues
returning LDS atomic traffic and can worsen LGKM pressure. It is a non-draining
token consumer: source token producers must be scheduled before it, but
source-token readiness must be carried to the result token instead of paid with
an arrive-side wait.

`barrier_wait` is a ticket read + poll loop after materialization, but the
scheduler only needs a conservative placeholder:

- it depends on the arrive token;
- it produces the post-barrier token;
- it should be movable later when independent work has no dependency on the
  wait result;
- it must not be treated as a region boundary.

Scoring should prefer schedules that increase useful work between arrive and
wait only when they do not create a worse hard resource or register-pressure
failure. A split-barrier candidate that leaves the hot-loop `lgkmcnt(0)` shape
unchanged is not progress.

## Waitcnt And Hazards

Materialization runs before regalloc, ticket waits, hazard waits, and resource
verification. That keeps generated SGPR/VGPR temporaries in the normal
allocator path.

After materialization, existing passes see real machine ops:

- returning arrive atomics produce LGKM events whose result is consumed at wait;
- poll reads produce LGKM events;
- `s_waitcnt lgkmcnt(0)` is inserted for arrival-ticket and poll
  scalarization, not immediately at arrive;
- `v_readfirstlane_b32` hazards are handled by the existing hazard pass.
- EXEC save/restore is visible to regalloc and final operand verification.

The split pseudos should not reach ASM emission.

## Correctness Rules

- Memory ordering remains token-only. No alias inference.
- `barrier_arrive` does not drain original dependency tokens. It forwards them
  to the wait result.
- `barrier_arrive` materializes the arrival ticket, but the ticket is not a
  memory-ordering token.
- `barrier_wait` is the only producer of the post-barrier token.
- All waves in the workgroup must execute each dynamic arrive/wait pair.
- Loop-carried barriers reuse the same LDS counters and rely on monotonic
  targets.
- Single-wave workgroups may lower to a cheap token/waitcnt form, but only
  after the general path is correct.
- Fallback to `s_barrier` on any unsupported shape.

## Validation

Required lit coverage:

- split pass rewrites `s_barrier` into init/arrive/wait and rewires original
  token users to wait;
- validation rejects post-barrier users of arrive tokens;
- validation rejects mismatched wait/init pairs;
- scheduler moves independent work between arrive and wait;
- materializer emits LDS init, returning atomic arrive, arrival-ticket
  scalarization, counter polls, and updates LDS size;
- waitcnt pass inserts the needed LGKM waits after materialization;
- arrive materialization does not create an immediate `lgkmcnt(0)`;
- unsupported targets keep `s_barrier`.

Required end-to-end coverage:

- small multi-wave LDS producer/barrier/consumer integration test;
- loop-carried barrier test proving monotonic counter reuse;
- gfx950 perf golden showing the intended hot-loop shape:

```text
ds_read_b64_tr_b8...
s_waitcnt lgkmcnt(nonzero or hidden by work)
barrier_arrive ds_add_rtn_u32
MFMA/SALU/VALU work
barrier_wait ticket read + LDS poll
post-barrier consumer
```

Perf validation must compare against the current checked-in golden and the
manual split-barrier probe shape. ASM drift alone is not proof.

## Open Questions

- Whether `barrier_arrive` needs a distinct cost class or can start as
  `WriteLDS`.
- Whether to batch all `barrier_init` materialization behind one startup
  hardware barrier or keep one local init sequence per static site.
- Whether token joins between arrive and wait are worth supporting in v1.
- Whether counter slots need padding to reduce LDS-bank conflicts in the hot
  matmul profile.
- Whether non-power-of-two expected wave counts should be supported in v1 or
  rejected to avoid expensive target computation.
