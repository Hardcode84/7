# WaveAMD RegAlloc Design

Regalloc is a linear-scan allocator with explicit alias components and
forced bank promotion:

```text
SGPR -> VGPR -> AGPR
```

If one bank overflows, move selected live ranges into the next bank.
Operations still keep their required operand/result banks. If a value is
stored in a bank an operation cannot use directly, insert explicit move
ops. Those move temps are normal register values and go through the same
allocator and promotion logic.

## Core Rules

- Flatten IR once. Each operation gets a monotonically increasing
  position.
- Every normal register dword has one live interval.
- Width-N SSA values own N scalar dword intervals.
- Alias constraints are explicit before allocation.
- Alias components choose one storage bank.
- Required op banks are interface constraints, not storage constraints.
- Bank mismatch is repaired with explicit moves.
- Inserted move values are allocated like any other value.

Tokens and singleton hardware resources are not promoted. SCC, VCC, M0,
EXEC, memory tokens, barriers, and control-only values stay in separate
resource checks.

## Flattening

Build `FunctionInventory`:

```text
op -> position
value -> def position, use positions
op operand/result -> required interface bank
fixed physical value -> precolored interval
reserved ABI register -> prefilled physical live range
```

Positions are operation indices. Block arguments use the parent region
entry position or the slot position that defines their storage.

Flatten nested regions in the execution order used by machine IR.
`uniform_loop` body positions sit between loop entry and loop exit.
Conservative liveness across the backedge is acceptable; aliasing carries
the storage constraint.

## Scalar Intervals

Each width-N register value lowers to N scalar dword intervals:

```text
value %x : reg<vgpr, 4>
  x[0] interval
  x[1] interval
  x[2] interval
  x[3] interval
```

Each scalar interval has:

```text
value
subindex
start
end
preferred bank
storage bank
required interface bank per use/def
fixed phys index, optional
alias component id
vertical offset
```

Starts can be widened by alias constraints. Ends stay per-subinterval.
Tuple lanes and wide-value lanes can die early and free subregisters.

## Horizontal Aliasing

Horizontal aliasing means multiple SSA values are the same storage slot.

Required edges:

- `uniform_loop` init, body block argument, `continue_if` carry, and loop
  result for the same carry slot.
- Branch/if yielded values and corresponding region result, when machine
  semantics require same storage.
- MFMA accumulator input and result when the op is in-place.
- Tuple round trips at the same slot.

Example:

```text
loop carries(%init)
^bb0(%arg):
  continue_if ... carries(%next)
} -> %result
```

The slot component is:

```text
%init, %arg, %next, %result
```

If two loop carry slots receive the same SSA init, duplicate storage first.
Two logical loop variables must not alias because SSA identity happened to
be shared at entry.

## Vertical Aliasing

Vertical aliasing means scalar intervals occupy one contiguous physical
range.

Required edges:

- Width-N SSA value lanes form offsets `[0, N)`.
- Tuple construction/extraction maps element intervals to cumulative
  offsets in the tuple base.
- Fixed physical tuple values pin their base and all offsets.

Vertical aliasing forces equal base plus offset. It does not force equal
end positions.

Example:

```text
%tuple = tuple_from_elements %a:4, %b:2, %c:2 -> reg<..., 8>
```

Offsets:

```text
%a -> base + 0
%b -> base + 4
%c -> base + 6
```

## Components

After horizontal and vertical union, allocate components.

A component contains:

```text
scalar intervals
vertical width
fixed base, optional
preferred bank
storage bank
promotion state
start = min scalar starts
end = max scalar ends
```

Component liveness at a position is the live subset of its scalar
intervals. A width-8 tuple with only lanes 0-3 live occupies four dwords,
not eight.

One component has one storage bank. Boundaries where an op needs another
bank get move temps.

## Bank Model

Storage bank order:

```text
SGPR < VGPR < AGPR
```

Normal values start in their preferred bank:

```text
scalar producers -> SGPR
vector/memory/scale values -> VGPR
MFMA accumulators/results -> current lowering choice
fixed values -> fixed bank
```

Promotion moves storage upward only:

```text
SGPR storage can be forced to VGPR.
VGPR storage can be forced to AGPR.
AGPR storage cannot promote further.
```

This is storage policy, not op legality. Op legality is repaired by moves.

## Interface Banks

Each op operand/result has a required interface bank:

```text
s_add_i32 operands/results: SGPR
v_add_u32 operands/results: VGPR
memory address/data operands: VGPR or SGPR as the op requires
mfma data/acc/result operands: op-defined machine interface bank
mfma scale operands: VGPR
v_accvgpr_read input: AGPR, result: VGPR
v_accvgpr_write input: VGPR, result: AGPR
```

If storage bank matches interface bank, wire the value directly.

If storage bank differs, insert bridge ops:

```text
SGPR storage -> VGPR interface: scalar-to-vector copy/materialization
VGPR storage -> SGPR interface: readfirstlane or scalar copy only when legal
VGPR storage -> AGPR interface: v_accvgpr_write_b32_tuple
AGPR storage -> VGPR interface: v_accvgpr_read_b32_tuple
```

Some bridge directions are not always legal. If no bridge exists, the
component cannot be promoted past that boundary.

## Allocation Loop

Linear scan allocates physical storage for the current component storage
bank.

High-level loop:

```text
build inventory
build intervals
build alias components
assign preferred storage banks

while true:
  insert required move temps for current storage choices
  rebuild inventory/intervals/components for new temps
  clear physical assignments

  for component event in position order:
    expire dead scalar intervals
    if component already assigned:
      place live subintervals in existing base
      continue
    if fixed:
      validate fixed placement
      continue
    if free range exists in storage bank:
      assign base
      continue

    candidate = choose live component to promote from this bank
    if no candidate:
      report overflow
    promote candidate to next bank
    restart from earliest affected position
```

Inserted bridge values can create new pressure. They are not special. If
they overflow a bank, the same promotion loop chooses another component
to move up.

## Promotion Candidate Choice

On bank pressure failure, scan live components in the overflowing bank
plus the request.

Candidate must:

- Be promotable to the next bank.
- Free pressure at the failure position.
- Fit the target bank over its live positions.
- Satisfy target-wave VGPR-family pressure positionally.
- Have legal bridges for every interface mismatch after promotion.

Cost:

```text
primary: fewer inserted move ops
then: more pressure relief at failure point
then: longer live overlap with pressure region
then: lower target-bank pressure increase
then: stable order
```

Candidate choice is best effort. If promotion creates move temps that
cause another overflow, the next iteration handles it.

## Move Insertion

Move insertion is deterministic from component storage bank and op
interface bank.

For each operand:

```text
if storage bank == required operand bank:
  use original value
else:
  insert bridge before user
  use bridge result
```

For each result:

```text
if storage bank == produced result bank:
  result is component storage
else:
  create op result temp in required bank
  insert bridge into component storage bank
```

Examples:

```text
value stored in AGPR
v_add_u32 needs VGPR
insert v_accvgpr_read before v_add
v_add consumes VGPR temp
```

```text
s_add_i32 produces SGPR
component forced to VGPR
emit s_add result as SGPR temp
copy/materialize SGPR temp into VGPR storage
```

```text
VGPR value forced to AGPR
store needs VGPR data operand
insert v_accvgpr_read before store
store consumes VGPR temp
```

Move temps have normal intervals. They can be promoted too if pressure
requires it.

## Tuple And Loop Moves

Tuple ops are storage views. They should not create moves by themselves.

If tuple endpoints have different storage banks, the component builder is
wrong or the tuple is not a pure alias. Insert explicit copies before
building tuple alias edges.

Loop carry slots have one storage bank for init, body arg, carry, and
result. If a loop body op needs a different interface bank, insert a
bridge inside the body at that use/def boundary.

## Target-Wave Accounting

VGPR and AGPR share occupancy budget on targets where AGPR counts against
VGPRs. Enforce this positionally:

```text
live_vgpr_dwords(position) + live_agpr_dwords(position) <= limit
```

Do not subtract peak AGPR pressure from all VGPR allocation. That rejects
scratch values that do not overlap the AGPR peak.

Reserved ABI registers are prefilled occupancy. Fixed entry registers in
the reserved prefix do not double-count.

## Diagnostics

Overflow diagnostics should expose allocator state:

```text
bank
position
limit
live dwords
request component
overlapping components
promotable candidates
best rejected candidates and rejection reason
inserted move pressure, if relevant
```

Promotion diagnostics:

```text
component
source bank
target bank
relief dwords
inserted move count
target-bank live increase
fit failure, if rejected
```

## Migration Plan

1. Build component data beside current allocator.
2. Add tests for scalar intervals and alias components.
3. Replace tuple and loop alias logic with component builder output.
4. Implement storage bank promotion as generic rebanking.
5. Move AGPR bank-spill rewrite into generic move insertion.
6. Let inserted bridge temps run through the same allocator.
7. Delete special AGPR candidate discovery.

## Risks

- Bridge legality must be local and explicit. Some bank crossings are not
  legal for all values.
- Move insertion can cascade. Bound iterations and record rejected
  promotion choices.
- Promoting SGPR storage into VGPR can duplicate scalar values across
  lanes. This is only valid when the bridge semantics are valid.
- AGPR is expensive as generic overflow storage because most non-MFMA uses
  need reads back to VGPR.
- Conservative region liveness can overpromote. Correctness first.

## Expected Payoff

- Allocator policy is simple: try bank, promote on pressure, restart.
- AGPR bank spill is not special.
- Loop-carried AGPR cases stop needing bespoke discovery.
- Move temps explain their own pressure.
- Target-wave accounting matches actual overlap.
- Tuple and carry aliasing become one graph problem.
