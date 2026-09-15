# Wave memory model

## Scope

This document defines memory semantics for Wave, Wave AMD, and WaveAMDMachine.
Source builders and compiler passes must preserve this contract. Target-specific
instruction, cache, and barrier protocols remain in their target design docs.

Memory dependencies are explicit. Required writes must have a token path to a
live consumer. Kernel completion observes only the tokens supplied at its exit.
Plain `--canonicalize` can remove unused stores, direct memory access (DMA)
operations, and dead token recurrences. There is no separate memory-elimination
pass and no implicit observation of all writes at kernel completion.

## Addresses and storage

| Storage or address form | Contract |
| --- | --- |
| Uniform address | A load can use scalar memory instructions when the address space and target permit them. |
| Lane-varying address | Vector accesses use per-lane addresses and the active lane mask. A uniform base can have a lane-varying offset. |
| Local data share (LDS) | Storage is shared by a workgroup. Communication between waves needs explicit synchronization. Address expressions and layouts determine bank access. |
| Scratch or private storage | Storage is private to each lane. Lowering preserves the target scratch layout. |

Address equality does not establish an ordering dependency. Address proofs can
select an instruction or layout, but cannot add a memory dependency. Same-wave
ordering, cross-wave synchronization, and cross-workgroup visibility are
separate requirements.

## Values, tokens, and observation

SSA means static single assignment: each value has one definition. The memory
graph contains ordinary SSA values, explicit token operands, and control flow.
The compiler must not add edges from pointer equality, alias analysis, source
order, nearby barriers, or kernel termination.

A load returns data and a memory token. A data consumer requires the loaded value
to be ready. A store returns a token because it has no data result. DMA tokens
represent the complete transfer, including its source read and destination write.

A live observer is a required operation or result that retains its dependencies.
Examples include a kernel exit and a retained synchronization operation. A token
use retains its producer only when the use reaches a live observer. A dead chain
of loads, stores, joins, and token forwarding operations can disappear. A closed
loop recurrence is not an observer.

Three properties must remain separate:

- **Liveness:** whether an operation must remain.
- **Issue order:** the order in which operations can start.
- **Completion:** the events that must finish before a consumer can proceed.

Retaining a producer does not require an immediate wait. Permission to remove an
unused operation does not permit speculation, duplication, or common
subexpression elimination (CSE).

The following examples are schematic; `kernel_end` denotes the observation
boundary.

```text
%written = store %value, %ptr
kernel_end
```

The store can disappear.

```text
%written = store %value, %ptr
kernel_end %written
```

The store must remain.

```text
%written = store %value, %ptr
%value2, %read = load %ptr after %written
%output = store %value2, %out
kernel_end %output
```

The final token retains the complete chain. The load data use retains the read
and its input dependency even when `%read` is unused. Completion does not need
to consume each intermediate token. Without an observer for `%output`, the
complete chain can disappear.

Removal is permitted; it is not runtime cancellation. An operation that remains
in the program can still perform its write. A program must not depend on either
the presence or absence of an unobserved write. Memory is not transactional.

## Token operations and waits

Logical tokens have type `!wave.mem.token`. Machine tokens have type
`!waveamdmachine.mem.token`. They have no runtime storage.

| Operation | Meaning |
| --- | --- |
| `wave.token` | Empty dependency set; suitable for an initial loop carry. |
| `wave.after`, `wave.join` | Combine dependencies without ordering the input producers against each other. |
| `wave.issue_token` | Retain producer issue order but carry none of their completion events. |
| `wave.wait` | Require completion of the supplied dependencies. |
| Barrier operations | Perform their specified synchronization and consume explicit dependencies. |

A token edge constrains issue order. Its completion requirement depends on the
consumer. Read-only memory issuers can overlap while forwarding incoming
completion events to their result tokens. Memory-writing dependencies and
non-issuer consumers require the applicable completion waits. A load data
consumer must wait for its data regardless of token use.

`wave.issue_token` cannot make stored contents ready for a reader. Its live use
can retain a store, but it does not transfer that store's completion events.

Wait insertion tracks target events such as vector loads, stores, LDS, and
scalar memory. It follows explicit dependencies. Hardware counters can require
a wait for additional older events covered by the same counter. Joins do not
require separate waits for each input. The wait pass treats `s_endpgm` as an
implicit drain; observation operands do not require an extra wait per operand.
Target terminal and register-release rules still apply.

Tokens do not replace workgroup barriers, memory scopes, cache rules, or
release/acquire semantics. A DMA-to-LDS consumer must retain the transfer and
required synchronization chain. SSA liveness alone does not establish visibility
between waves. A barrier observes only writes with a dependency path to it; its
opcode does not add a scheduling fence for all nearby operations. A barrier
without input tokens still performs its specified synchronization.

Target latency, counter policy, and instruction hazards remain backend
responsibilities. See the [execution state model](WaveAMDInstructionExecutionStateModel.md),
[scheduler design](AMDGPUOriginalOrderGapFillScheduler.md), and
[split-barrier protocol](Gfx950SplitBarrierEmulation.md).

## Function and kernel exits

Wave kernel functions return zero or more logical memory tokens. They do not
return ordinary data through this boundary.

```mlir
func.func @kernel(%out: !wave.ptr<#wave.global, i32>,
                  %value: !wave.simd<i32, 64>) -> !wave.mem.token
    attributes {wave.kernel} {
  %written = wave.store %value -> %out
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return %written : !wave.mem.token
}
```

Each return identifies the effects required at that exit. Independent outputs
can use separate return operands or a joined token. An empty return observes no
memory effects.

Machine selection transfers these dependencies to `waveamdmachine.s_endpgm`.
Dialect conversion removes logical results from the physical function signature.
Tokens use no return registers, kernel arguments, or host result buffers. The
transfer must leave no interval in which cleanup can erase required effects.
Selection creates one terminal machine operation per supported exit and does
not duplicate it when rerun. Unsupported control flow produces a diagnostic.

Callable functions express dependencies through token arguments and results.
Source `func.call` retains these logical values. Machine selection has no call
instruction lowering: inline calls before selection. Residual calls and token
arguments produce an error. Selected callable returns attach dependencies to
`s_setpc_b64`. Unknown calls remain effectful; ordinary store removal does not
authorize call removal.

In the Python DSL, `observe(*tokens)` adds tokens to the function return.
`return_(values)` returns explicit values and registered observations. The C
frontend uses `observe(tokens...)`. Observe a region result at function scope,
not a token defined inside that region. Builders must not infer observations
from stores in the function. See the [C frontend syntax](CFrontendDesign.md#memory-and-tokens).

## Control flow

A conditional write yields its token through the region result. A path without
a write forwards the incoming dependency, or an empty token when no dependency
is required. Lowering preserves lane masks and execution conditions.

A token select between operations that have already executed does not cancel
either producer. Unresolved token-select lowering joins both arms and retains
both producers when the result is live.

A loop carries tokens for required dependencies between iterations. Its final
result retains the required earlier iterations. A loop with zero iterations
forwards its initial token. No pass infers a carry from addresses.

Canonicalization analyzes region token demand with a worklist and region
control-flow mappings. Required external uses and effects seed demand. A covered
write is not a root merely because it reports a physical write effect. The
analysis does not descend into regions with unknown control-flow semantics.
It retains their required operands conservatively.

A dead token recurrence can contain mutually used values. Region canonicalization
removes undemanded writes and replaces their remaining token uses with empty
tokens. Ordinary region cleanup can then remove unused carries and results.
Rewrites preserve control effects, loop termination, and operand segment metadata.
Analysis covers nested recurrences within each outer region rather than scanning
the whole function once per store.

## Physical effects and removal

Covered writes have the explicit `DiscardableMemoryOp` trait. They retain their
physical read and write effects. Local canonicalization removes them when all
results are unused; region demand analysis handles closed token recurrences.
Ordinary loads can remain live through data or token uses.

| Operation class | Removal contract |
| --- | --- |
| Wave store and scatter | Mandatory result token represents the write. |
| Wave AMD DMA to LDS | Result token represents both read and write. |
| TDM load and store | Result token represents the complete transfer. |
| Corresponding machine stores and DMA | Same contract as their source operations. |
| TDM prefetch | An explicit live token use retains the requested prefetch. |
| Compiler-generated LDS and scratch stores | Private token flow connects them to required reloads or synchronization. |

Removal applies to the complete operation, including both halves of DMA.
Prefetch producers must supply a use that reaches a live consumer or completion
when the prefetch is required. No exit scan retains unused prefetches.

Barriers, allocation releases, atomic operations, volatile accesses, external
signaling, and unknown effects do not acquire this trait from a general memory
issuer classification. Barrier removal needs a proof about synchronization and
convergence. Allocation release removal must preserve lifetime ordering and
reuse. Unsupported source forms produce diagnostics.

Do not mark writes `Pure` or move their effects to a fictitious token allocation.
Allocation cleanup and memory materialization need accurate pointer effects.
The removal contract does not authorize store CSE, motion across control flow,
or speculative access. An unused store token is legal IR and needs no warning.

A store that is overwritten still remains when it belongs to a live dependency
chain. Removing it requires a separate proof that preserves all dependencies.
Local verifiers check types, attributes, and required tokens. Cross-operation
checks belong in passes; consumers must not reconstruct missing token flow.

## Lowering and cleanup

Every lowering transfers each replaced token to the complete replacement effect.
Split stores and DMA fallback sequences join all required parts. The observation
path survives until physical emission has fixed required operations and waits.

Compiler-generated redistribution and spill synchronization remains private.
Retain private stores through required reloads or synchronization. Do not select
or rewrite a user memory-token carry, or attach unrelated user tokens to exit.

Materialization choices preserve coupled data and token results from the same
effect. Access duplication requires discardable effects. Resolving a choice
exposes unused operations to canonicalization; no anchor or special effect
erasure is required. Required prerequisite effects and independently consumed
alternatives remain live. See the
[materialization design](WaveMaterializationVariantsDesign.md).

Candidate cleanup uses upstream `CompositeFixedPointPass` to repeat
`remove-dead-values`, `canonicalize`, and `cse`, subject to the upstream iteration
limit. A later iteration removes arithmetic carries whose memory users became
dead during canonicalization. Cleanup runs before candidate scheduling so costs
exclude dead work.

Run cleanup before expensive selection and scheduling and after transforms that
expose dead outputs. Do not apply generic SSA dead-code elimination to allocated
physical-register code without a dependency model for implicit register effects.
Token processing adds compile-time graph work, not runtime token storage. Keep
local erasure queries cheap and use worklist propagation for region demand.

## Validation and evidence

The [two-output DMA matmul test](../test/Integration/wave_token_observed_matmul.py)
uses the gfx950 256-by-256 generator with K=256. Changing only the observation set
removes half the output stores while preserving shared DMA and the K loop.
Its [runtime test](../test/Integration/wave_token_observed_matmul_runtime.mlir)
checks both outputs when observed, then the retained output and the untouched
second buffer when only one output is observed.

The [independent DMA test](../test/Integration/wave_token_observed_dma.py) copies
two inputs through LDS in a loop. Removing one output observation removes its
DMA, LDS read, and global store. Simulator checks cover both observation sets.
These tests establish correctness and code removal, not hardware performance.

Coverage must retain these checks:

- Dead stores, scatter, DMA, TDM, prefetch, chains, and nested recurrences disappear.
- Load data uses and output joins retain all required producers.
- Conditional outputs, supported exits, and zero-trip loops preserve dependencies.
- Split transfers, barriers, issue-only tokens, and private spill tokens keep
  their distinct completion and lifetime requirements.
- Unknown effects remain; CSE and materialization preserve required effects.
- Physical kernel results remain void and terminal selection is idempotent.
- Candidate cleanup removes dead arithmetic carries and reaches stable IR.

For memory changes, run full lit, wavec, Integration, and the applicable
[simulator checks](AMDGPUEmulatorTesting.md). Record target or environment skips.
Run PerfGolden checks when assembly can change. Review instruction counts, code
size, and waits. Compare changed performance goldens on the same target hardware
before replacement. Check compile-time complexity separately from runtime speed.

## Implementation references

- [Wave operations](../include/mlir/Dialect/Wave/IR/WaveOps.td)
- [Wave AMD operations](../include/mlir/Dialect/Wave/IR/WaveAMDOps.td)
- [Machine operations](../include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.td)
- [Discardable effects](../include/mlir/Dialect/Wave/IR/WaveMemoryEffects.h)
- [Memory canonicalization](../include/mlir/Dialect/Wave/IR/WaveMemoryCanonicalization.h)
- [Machine selection](../lib/Dialect/Wave/Transforms/WaveAMDMachine.cpp)
- [Wait insertion](../lib/Dialect/Wave/Transforms/WaveAMDMachineWaitcnt.cpp)
- [Default pipelines](../lib/Target/Wave/pipelines/pipelines.mlir)
