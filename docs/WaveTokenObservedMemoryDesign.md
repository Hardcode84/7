# Token-observed memory effects

## Status and purpose

Unused stores and direct memory access (DMA) operations are removable.
Explicit memory tokens identify the effects that must remain observable.
Kernel completion consumes the tokens for required output writes.

Plain `--canonicalize` removes unused covered operations and dead token
recurrences. There is no separate memory-elimination pass. Operations retain
their physical memory effects.

This change affects source semantics. A program must not depend on a write that
has no explicit path to a live observer. No compatibility mode shall attach
unused writes to kernel completion.

## Terms

- **Token:** an SSA value that carries explicit memory dependencies. SSA means
  static single assignment.
- **Live observer:** a required operation or result that makes an upstream
  computation necessary. Kernel completion and retained synchronization
  operations are examples.
- **Liveness:** whether an operation must remain in the program.
- **Issue ordering:** the order in which operations can start.
- **Completion:** the events that must finish before a consumer can proceed.

These properties are separate. Retaining a producer does not require an immediate
wait. Permission to erase an unused operation does not permit speculation,
duplication, or common subexpression elimination (CSE).

## Semantic contract

A covered memory operation is removable when all its results are dead. A load
can remain live through its data result or its token. A store or DMA operation
normally remains live through its token alone.

A use retains an operation only if that use leads to a live observer. A dead
chain of loads, stores, joins, and token forwarding operations can disappear.
An internal loop recurrence is not an observation root.

The dependency graph includes data operands, token operands, and control flow.
It does not include inferred edges from pointer equality, alias analysis, source
order, nearby barriers, or kernel termination. A live load retains an upstream
store through an explicit dependency, even if the load token is unused.

An operation that remains in the emitted program can still perform its write.
Removal is permitted, not a runtime cancellation mechanism. Programs must not
depend on either the presence or absence of an unobserved write. This design
does not make memory transactional.

The following examples are schematic. They omit types and use `kernel_end` to
denote the logical observation boundary.

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

The final token retains the complete chain. Completion need not consume each
intermediate token. If `%output` has no observer, the complete chain can vanish.

## Covered operations

| Operation class | Required contract |
| --- | --- |
| Wave store and scatter | Discardable effects; mandatory result token |
| Wave AMD DMA to LDS | Source read and destination write belong to the result token |
| TDM load and store | Complete transfer belongs to the result token |
| Corresponding machine stores and DMA | Same erasure rule; mandatory result token |
| Compiler-generated LDS and scratch stores | Private token flow to reloads or other required consumers |
| TDM prefetch | Explicit token use retains the requested prefetch |
| Ordinary loads | Either data or token use can retain the load |

The rule applies to the complete operation. It must not remove the write half
of a DMA operation while retaining its read half.

Barriers remain explicit synchronization effects. A retained barrier that
consumes a store token retains that store. The barrier does not observe writes
that have no token path to it. Barrier removal needs a separate proof about
participating waves and convergence; this change does not authorize it.

Atomic, volatile, externally visible signaling, and unknown operations do not
acquire discardable effects from a general memory-issuer classification. They
remain effectful unless their operation contract explicitly provides equivalent
observation rules. Unsupported source forms must produce a diagnostic.

Prefetch producers must supply an explicit use that reaches a live consumer or
completion. Compiler-generated prefetches must attach that use during creation.
No scan shall retain all unused prefetches at function exit.

## Function and kernel boundaries

Use logical token results on Wave kernel functions. A kernel can return zero or
more memory tokens. It cannot return ordinary data through this boundary.

```mlir
// Proposed logical signature. The physical kernel still returns void.
func.func @kernel(%out: !wave.ptr<#wave.global, i32>,
                  %value: !wave.simd<i32, 64>) -> !wave.mem.token
    attributes {wave.kernel} {
  %written = wave.store %value -> %out
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return %written : !wave.mem.token
}
```

Each return identifies the effects required at that exit. Independent output
tokens can be separate return operands or operands of `wave.join`. Joining them
does not order the producers against each other.

Kernel launch and ABI lowering must distinguish logical token results from
physical results. Tokens do not occupy return registers, kernel arguments, or
host result buffers. Preserve each return dependency on the selected
`waveamdmachine.s_endpgm` before removing logical token results from the physical
function signature. The transfer must not leave an interval in which cleanup can
erase the required effects. Dialect conversion removes logical results from the physical signature.

Selection must create one terminal machine operation per supported exit. Repeat
selection must not duplicate it. Unsupported control flow must fail explicitly.

Callable functions carry memory dependencies through explicit token arguments
and results. A logical token result connects callee effects to the caller; it
does not by itself require a register in the ABI. Physical calls and returns
must retain the corresponding dependency relation when logical types disappear.
Source `func.call` operations retain logical token arguments and results.
Machine selection has no call instruction lowering. Inline calls before machine
selection; residual calls and token arguments produce an error. Selected callable
returns attach their dependencies to `s_setpc_b64`.
Unknown calls remain effectful. Removing such calls requires a separate effect
contract. Do not extend call DCE as part of ordinary store removal.

The Python DSL accepts explicit return tokens. `observe(*tokens)` adds tokens
to the function return. `return_(values)` returns explicit values and registered
observations. Observe a region result at function scope; do not observe a token
inside its region. The C frontend uses `observe(tokens...)` with the same rule. An empty return means that
kernel completion observes no memory effects. Builders must not infer return
tokens from the set of stores in a function.

## Memory effects and erasure

Keep accurate physical read and write effects on the operations. Add a shared
operation contract for effects that are discardable when all results are dead.
Use that contract in Wave canonicalization and dead-code elimination (DCE).
Operation membership must be explicit across Wave, Wave AMD, and machine IR.

The local erasure predicate consumes verified IR and returns a boolean. It does
not perform alias analysis, inspect target names, or return a recoverable status.
Ordinary generic MLIR DCE can remain conservative about writes. The registered
Wave patterns must implement the additional erasure rule consistently.

Do not mark these operations `Pure`. Do not remove their physical effects or
move writes onto a fictitious allocated token to obtain generic DCE. Allocation
cleanup uses effects on pointer operands. Memory materialization uses effect
freedom to distinguish address calculations from memory accesses. Those answers
must remain accurate.

This contract does not authorize store CSE, motion across control flow, or
speculative memory access. Existing transformations must continue to prove their
own legality. A write with an unused token is legal IR and needs no warning.

Public verification checks local types, attributes, and required result tokens.
Cross-operation checks belong in passes. Internal consumers trust the token flow
created by verified producers; they must not reconstruct it from surrounding IR.

## Control flow and dead recurrences

A conditional write yields its token through the region result. A path with no
write forwards the incoming dependency, or an empty token if no dependency is
required. Preserve lane masks and execution conditions through machine lowering.

A token select between operations that have already executed does not cancel
either producer. The current unresolved token-select lowering joins both arms.
That join conservatively retains both producers when its result is live.

A loop must carry the token that connects required accesses between iterations.
The final result retains earlier iterations through that carry. A loop with zero
iterations forwards its initial token. No pass shall infer a carry from addresses.

Local unused-result checks cannot remove a closed recurrence whose values use
one another. Region-aware liveness must remove unused results and carries before
local DCE can remove the remaining operations. It must preserve required control
effects and loop termination behavior.

Compute liveness with a worklist over values and region control-flow mappings.
Propagate demand backward from required results and effects. A covered write is
not an unconditional root merely because it reports a physical write effect.
For unknown region semantics, retain the region conservatively. Required Wave
and machine region forms must have explicit transfer rules before rollout.

Remove dead region operands and results through supported rewrite interfaces.
Preserve operand segment metadata. Test nested loops, branch results, and zero
iterations. Do not repeatedly scan the complete function for each dead store.

## Ordering and completion

An ordinary token use retains its producer and preserves the completion meaning
defined by the consuming operation. `wave.issue_token` retains issue ordering but
does not carry the producer's completion events. Its live use can retain a store;
it cannot make the stored contents ready for an ordinary reader.

The wait pass currently treats `s_endpgm` as an implicit drain. Adding observation
operands must preserve target terminal rules. Do not emit an explicit wait for
each terminal operand solely because it retains a producer. Check terminal
completion and VGPR release behavior on each supported target.

Tokens do not replace workgroup barriers, memory scopes, cache rules, or
release/acquire semantics. A DMA-to-LDS consumer must retain the required
transfer and synchronization chain. SSA liveness alone does not establish
visibility between waves.

Scheduling continues to use SSA and explicit token edges. A join of independent
outputs adds no ordering between those outputs. Target latency and wait policy
remain in the cost model and wait machinery.

## Pipeline obligations

This is compile-time graph processing. It adds no runtime token storage. The
erasure predicate is a frequent compiler query and must be cheap. Region demand
analysis must use bounded worklist propagation rather than per-store graph scans.

Every lowering must transfer each replaced token to the complete replacement
effect. Split stores and DMA fallback sequences must join all required parts.
The observation path must survive until physical emission has fixed the required
operations and waits.

| Component | Required work |
| --- | --- |
| Source builders and launch construction | Supply explicit logical output tokens; preserve the physical ABI |
| Symbolic memory lowering | Transfer scatter tokens and complete DMA replacement dependencies |
| Canonicalization and region cleanup | Erase unused covered operations and dead token recurrences |
| Store coalescing | Remove assumptions that dead-token stores must survive; root live test stores |
| Allocation cleanup and reuse | Preserve access classification and release dependencies |
| Materialization alternatives | Preserve selected observation paths; remove temporary anchors after selection |
| Machine selection | Require store/DMA tokens and transfer return operands to terminal operations |
| Scheduling and waits | Preserve dependency edges without extra serialization or terminal waits |
| Redistribution and register allocation | Keep private stores connected to reloads through private tokens |

Run cleanup before expensive selection and scheduling, and after transformations
that expose dead outputs. Coordinate it with region cleanup. Do not run generic
SSA DCE over allocated physical-register code without a valid dependency model
for implicit register effects.

Compiler-generated synchronization must remain private. Do not retain a spill
or redistribution store by attaching an unrelated user token to completion.
Retain it through its required reload or private synchronization consumer.

An allocation release can carry required lifetime ordering. Do not classify it
as discardable merely because its result has no users. Removal must preserve
allocation reuse and any required synchronization.

## Expected benefit and limits of the rule

Removing an unused output can remove its stores, DMA transfers, address work,
descriptors, and private intermediate computation. Earlier removal can reduce
the input size for scheduling and register allocation.

This rule does not remove an overwritten store that remains in a live dependency
chain. For example, two stores to the same address remain live when the second
consumes the first token and completion consumes the second. Bypassing the first
store requires an independent proof that preserves all dependency obligations.

No throughput claim follows from fewer operations or passing simulator tests.
Measure performance on the target hardware.

## Production experiment and rollout gate

First prove one complete path through source IR, loop token carries, DMA,
selection, terminal observation, and emitted code. Use the tiled DMA matmul
kernel exercised by
[`wave_mfma_dma_lds_profile256_runtime.mlir`](../test/Integration/wave_mfma_dma_lds_profile256_runtime.mlir)
as the production basis. Add an optional second output through its ordinary
generator and lowering path. Preserve its loop structure and data distribution.

Record a controlled baseline with both outputs observed. Then remove only the
second output from the observation set. Record the input IR, target, generator
arguments, compiler revision, final IR, and assembly for both cases. A DMA shared
with the retained output must remain; only exclusive dead work can disappear.
If this witness has no exclusive transfer, add a separate production-shaped DMA
output path before claiming DMA removal as a demonstrated benefit.

The experiment passes only if:

1. Both outputs are correct when both are observed.
2. The retained output is correct when the other observation is removed.
3. Final code contains no writes or DMA transfers exclusive to the dead output.
4. Required shared transfers, loop carries, and synchronization remain correct.
5. Joining independent outputs adds no dependency between their producers.
6. Completion tokens add no unnecessary terminal waits or physical ABI values.

Stop expansion if any condition fails. Identify the broken ownership or
dependency transfer and correct it within this path. Passing isolated operation
tests does not authorize wider rollout. After this gate, convert all covered
producers and tests before enabling removal in the default pipeline. Do not land
a default configuration that deletes outputs from unconverted source builders.

## Validation

Add Integration coverage for the production experiment. Supporting tests must
cover the following cases at source and machine boundaries:

- Unused stores, scatter, DMA, TDM, and complete dead chains disappear.
- A live load data result retains its required upstream write.
- Live output joins retain all producers without serializing them.
- Conditional outputs, multiple supported exits, and zero-trip loops work.
- Dead nested token recurrences disappear without deleting required loop effects.
- Split stores and DMA fallbacks preserve every replacement dependency.
- Issue-only tokens retain issue order without claiming completion.
- Prefetch remains when explicitly observed and disappears when unobserved.
- Retained barriers preserve required writes and synchronization.
- Atomics and unknown effects do not inherit discardable semantics.
- Allocation reuse, redistribution, and forced LDS/scratch spills remain correct.
- CSE, coalescing, and materialization selection preserve the observation graph.
- Physical kernel signatures remain void and terminal selection is idempotent.

Run full lit, wavec, and Integration checks before implementation commits. Run
simulator correctness checks for gfx942, gfx950, and gfx1250 as described in the
[simulator guide](AMDGPUEmulatorTesting.md). Record skipped tests and their exact
hardware or environment requirements. Simulator results establish correctness,
not hardware performance.

Run PerfGolden checks when assembly can change. Review assembly changes and
compare old and new code on the same hardware before replacing performance
goldens. Record instruction counts, code size, and required waits for the
production witness. Check compile-time complexity separately from runtime speed.

## Implementation references

- [Wave operations](../include/mlir/Dialect/Wave/IR/WaveOps.td)
- [Wave AMD operations](../include/mlir/Dialect/Wave/IR/WaveAMDOps.td)
- [Machine operations](../include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.td)
- [Machine selection](../lib/Dialect/Wave/Transforms/WaveAMDMachine.cpp)
- [Wait insertion](../lib/Dialect/Wave/Transforms/WaveAMDMachineWaitcnt.cpp)
- [Default pipelines](../lib/Target/Wave/pipelines/pipelines.mlir)
- [Python DSL](../python/mlir/dialects/wave_dsl.py)
- [Materialization contract](WaveMaterializationVariantsDesign.md)

## Implementation evidence

[`wave_token_observed_matmul.py`](../test/Integration/wave_token_observed_matmul.py)
uses the gfx950 256-by-256 DMA matmul generator with K=256. It adds a second
output buffer through the same pointer and store operations. The two cases differ
only in the return observation set. Both cases retain shared DMA and the K loop.
The second case emits half as many output stores.

[`wave_token_observed_matmul_runtime.mlir`](../test/Integration/wave_token_observed_matmul_runtime.mlir)
checks both observation sets. The gfx950 simulator produces both correct outputs
when both are observed. With one observation, the first output remains correct
and the second buffer retains its sentinel values. These checks establish
correctness and code removal; they do not measure hardware performance.

[`wave_token_observed_dma.py`](../test/Integration/wave_token_observed_dma.py)
copies two independent inputs through LDS in a loop. Removing the second output
observation removes its DMA, LDS read, and global store. The gfx950 simulator
checks both complete outputs, then checks the retained output and the untouched
second buffer with one observation.
