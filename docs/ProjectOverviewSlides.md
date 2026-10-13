---
marp: true
theme: default
size: 16:9
paginate: true
title: Wave overview
description: Explicit wave execution from high-level IR to AMDGPU machine code
---

# Wave

## Keep the information. Compile the wave.

MLIR from wave-level operations to physical registers

<!--
50 minutes plus discussion. Short version: 40 minutes plus discussion.
Sections: Why 5/4, What 6/5, Wave front 15/12, Wave back 19/15, Triton 5/4 minutes.
Backup slides are outside these budgets. Short version: compress examples within each section.
Implementation snapshot: aca5c3c6, 29 September 2026; slide draft: 12 October 2026.
-->

---

# SIMT must die

- This is not how modern GPUs work.
- Collective ops (MMAs) become awkward.
- Uniform values become facts to recover.
- Masks and layout relations become facts to recover.
- High-level frontends already have this information.

**Why throw it away?**

<!--
Why. The target is an information-losing compiler abstraction. SIMT remains a useful source model; existing GPU compilers already preserve or recover some of these facts.
"This" refers to the independent per-thread execution model. Matrix instructions operate collectively on operands distributed across lanes, so a per-thread presentation must recover that group contract.
The claim is that Wave should receive the known facts explicitly, not that every other compiler discards all of them.
[Motivation](AMDGPUExplicitWaveProgrammingModel.md)
-->

---

# A playground for compiler experiments

- Inspect the IR before and after each decision.
- Change a pipeline without rewriting the driver.
- Try different schedules and equivalent computations.
- Measure compile cost and final code.

**Make the experiment visible.**

<!--
History for discussion: explicit wave IR and tokens in May; component allocation in June; scheduling and redistribution in July; cost-model policy consolidation in August; materialization choices and Triton integration in September.
[Pipeline strategy](TransformDialectPipelineStrategy.md)
-->

---

# What information does this code contain?

Per-thread pseudocode:

```text
for k in range(K):
    i = tile_base + thread_id
    if i < n:
        x = load(base + k * stride + i)
        consume(x)
```

- `K`, `base`, `stride`, `tile_base`, `n`: uniform
- `thread_id`, `i`, `x`: lane-varying
- Loop control: uniform; access: masked

<!--
What. Pseudocode assumes one wave and uniform kernel inputs. This is a masked tiled-load fragment, not a complete GEMM.
Use it to establish the distinctions before adding LDS and matrix operations.
[Wave type model](../include/mlir/Dialect/Wave/IR/WaveTypes.td)
-->

---

# Keep those facts explicit

Wave-level pseudocode:

```text
lane   : simd<u32, W> = lane_id()
i      : simd<u32, W> = tile_base + lane
active : mask<W>      = i < n

uniform_for k in range(K):
    where active:
        x : simd<f32, W> = load(base + k * stride + i)
        consume(x)
```

**The producer supplies execution intent.**

<!--
Schematic notation, not wavec or MLIR syntax. Memory effects and their observation are introduced later.
Triton-style frontends already carry distributed values and layouts; the bridge must preserve their semantics.
[Wave operations](../include/mlir/Dialect/Wave/IR/WaveOps.td)
-->

---

# MLIR all the way

```text
Python / Triton / other producers
              |
       Wave + WaveAMD
              |
       WaveAMDMachine
              |
     physical-register IR
              |
      LLVM MC → object → HSACO
```

SSA, types, regions, rewrites, dialect conversion

<!--
Wave owns instruction selection, scheduling, allocation, and waits. LLVM supplies instruction descriptions, encodings, MC infrastructure, and linking support.
"All the way" means through the machine representation; final object emission uses LLVM MC.
[Pipeline](../lib/Target/Wave/pipelines/pipelines.mlir)
[Emission](../lib/Target/Wave/AMDGPU.cpp)
-->

---

# 2 + 1/2 levels

| Dialect | Contract |
|---|---|
| `wave` | Values, masks, control, memory, symbolic relations |
| `waveamd` | AMD-specific operations at the Wave level |
| `waveamdmachine` | Selected instructions and machine resources |

**WaveAMD is the half-level.**

<!--
WaveAMD extends the high-level representation; it is not a mandatory separate lowering stage for every operation.
[Wave ops](../include/mlir/Dialect/Wave/IR/WaveOps.td)
[WaveAMD ops](../include/mlir/Dialect/Wave/IR/WaveAMDOps.td)
[Machine ops](../include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.td)
-->

---

# The compiler pipeline is IR

Excerpt from the transform library:

```mlir
%r0 = transform.include @waveamd_backend
    failures(propagate) (%root)
    : (!transform.any_op) -> !transform.any_op
%r1 = transform.apply_registered_pass "wave-compile-kernels"
    to %r0 : (!transform.any_op) -> !transform.any_op
transform.yield %r1 : !transform.any_op
```

- Named sequences compose compiler stages.
- Transform operations control iteration and experiments.
- Payload IR remains inspectable.

<!--
Excerpt from @compile_kernels; surrounding named sequence omitted.
The backend contains selection, candidate scheduling, allocation, and finalization sequences. Compilation failures propagate.
[Actual pipeline](../lib/Target/Wave/pipelines/pipelines.mlir)
-->

---

# Wave front: program the subgroup

| Value | Representation |
|---|---|
| Uniform scalar | `i32`, `f32`, pointer |
| One value per lane | `!wave.simd<f32, 32>` |
| Active lanes | `!wave.mask<32>` |
| Per-lane packet | `!wave.simd<vector<4xf32>, 32>` |

**Uniform and varying are different types.**

<!--
Wave front. Scalar type examples describe this programming model, not arbitrary MLIR semantics.
Implicit lane-varying-to-uniform conversion is not allowed. Cross-lane operations must express that conversion explicitly.
[Types](../include/mlir/Dialect/Wave/IR/WaveTypes.td)
-->

---

# Uniform control and masking are different

```text
uniform condition              lane mask
        |                          |
     scf.if                    wave.where
        |                          |
one branch per wave       execute under active lanes
```

- `scf.for` retains uniform loop structure.
- Region arguments and yields carry state.
- A mask is not a scalar branch condition.

<!--
Diagram is schematic. Nested masking must preserve the enclosing active mask and restore EXEC correctly.
Do not imply uniform scf.while support from the broader programming-model proposal.
[Control-flow operations](../include/mlir/Dialect/Wave/IR/WaveOps.td)
-->

---

# C++ memory model sucks

## For the compiler contract we want here

- Which effects must remain?
- Which operations must issue first?
- Which transfers must complete before use?
- Which waves must synchronize?

**Represent the answers as dependencies.**

<!--
This is the talk's design critique, not a claim that C++ lacks synchronization or cannot express correct GPU programs.
Wave's goal is an explicit wave/async-memory IR contract. Tokens do not replace memory scopes, cache rules, atomics, or release/acquire semantics.
[Memory contract](WaveMemoryModel.md)
-->

---

# Memory effects have SSA results

Schematic IR:

```text
%written       = store %value, %ptr
%loaded, %read = load %ptr after %written
%output        = store %loaded, %out
kernel_end %output
```

- Data edges retain required values.
- Token edges retain required effects and dependencies.
- Tokens need no runtime storage.

<!--
This chain is schematic, as in the memory design document. Completion waits depend on consumer semantics and target events; a token use does not mean an immediate full drain.
[Values, tokens, and observation](WaveMemoryModel.md)
-->

---

# Writes can be dead code

```text
%a = store %result, %out_a
%b = store %result, %out_b

kernel_end %a, %b       →       kernel_end %a
```

- `%out_b` loses its observation path.
- Its discardable store can disappear.
- Shared work needed by `%out_a` stays live.

**A dead token cycle is not an observer.**

<!--
Schematic before/after. Removal is permitted, not required. This does not make arbitrary atomics, volatile accesses, barriers, or unknown effects discardable.
The integration witness duplicates GEMM output stores, removes one observation, and checks the generated assembly.
[Two-output GEMM witness](../test/Integration/wave_token_observed_matmul.py)
[Runtime witness](../test/Integration/wave_token_observed_matmul_runtime.mlir)
-->

---

# The kernel return observes effects

```mlir
func.func @kernel(
    %out: !wave.ptr<#wave.global, i32>,
    %value: !wave.simd<i32, 64>) -> !wave.mem.token
    attributes {wave.kernel} {
  %written = wave.store %value -> %out
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return %written : !wave.mem.token
}
```

Logical result; no return register or host result buffer.

<!--
Complete source IR example from the memory contract. Selection transfers observation to the machine exit; conversion removes tokens from the physical signature.
[Kernel exits](WaveMemoryModel.md)
-->

---

# Issue is not completion

```mlir
%dma = waveamd.dma_load_lds %src -> %lds after %dep
    {bytes = 4 : i64}
    : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
       !wave.ptr<#wave.shared, i32>, !wave.mem.token)
    -> !wave.mem.token
%issued = wave.issue_token %dma
    : !wave.mem.token -> !wave.mem.token
%ready = wave.barrier %dma
    : (!wave.mem.token) -> !wave.mem.token
```

- `%issued`: order later work after DMA issue; do not wait for completion.
- `%ready`: retain DMA completion and workgroup synchronization.
- LDS consumers use `%ready`, not `%issued`.

<!--
Verified MLIR excerpt. The enclosing function supplies source pointers, the LDS destination, and the incoming dependency. Downstream issuers and LDS consumers are omitted.
The barrier consumes %dma explicitly. Passing %issued instead would discard its completion events and would not establish DMA readiness. The issue token does not introduce an immediate wait.
In the Triton bridge, wait_group(K) completes older committed groups and keeps the newest K groups outstanding.
A barrier is not an implicit async-group completion. Readiness must survive structured control flow.
[Memory tokens](WaveMemoryModel.md)
[Triton async protocol](../integrations/tlx/docs/TLXWaveAsyncMemoryProtocol.md)
-->

---

# Keep indexing symbolic

```mlir
%lane = wave.lane_id : !wave.simd<i32, 32>
%k = wave.assume %k_raw as "k"
    [#wave.pred<"k >= 0">, #wave.pred<"k < 16">] : index
%bytes = wave.index_expr <"4*(base + k*stride + lane)">
    ["base", "k", "stride", "lane"](%base, %k, %stride, %lane)
    : (index, index, index, !wave.simd<i32, 32>)
    -> !wave.simd<index, 32>
```

- Symbols bind directly to SSA operands.
- The range belongs to `%k`, the result of `wave.assume`.
- Address algebra stays symbolic until machine materialization.

<!--
Verified MLIR excerpt. %base, %k_raw, and %stride are uniform index arguments; %base is the tile's element offset, not its pointer. The expression converts f32 element offsets to byte offsets.
The producer supplies the k range as a precondition, not as a runtime check. Assumptions follow the defining SSA result, not nearby operations.
wave.index_expr uses ixsimpl expressions. Symbolic arithmetic and fixed-width source operations have a defined boundary; integer algebra alone does not authorize a rewrite across wraparound or poison.
The ixsimpl implementation is a backup topic.
[Index-map contract](WaveIndexMap.md)
-->

---

# Gather: four adjacent elements per lane

```mlir
%value, %token = wave.gather %base mapping
    <bit_offset = <"32 * (4 * item + origin + slot)">>
    bindings ["origin", "item"](%origin, %item)
    : (!wave.ptr<#wave.shared, f32>, index, !wave.simd<i32, 32>)
    -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
```

```text
origin = 0     slot 0   slot 1   slot 2   slot 3
lane 0:          A[0]     A[1]     A[2]     A[3]
lane 1:          A[4]     A[5]     A[6]     A[7]
```

Compiler choice: one `wave.load` of `vector<4xf32>` per lane.

<!--
The operation specifies addresses, not transaction width. The compiler derives contiguity and selects a transaction layout from the relation. The offset unit is bits; 32 is the f32 element width.
The enclosing function has 32 workitems. %item is the result of wave.assume on workitem_id, with bounds 0 <= item <= 31. %origin is an index argument. The table shows element indices for origin = 0.
The mapping can also carry base selection and owner block. Packet extents and predication are separate.
This is the contiguous_gather fixture, with the bounded item renamed. Symbolic-memory lowering produces one packet load.
[Gather fixture](../test/Dialect/Wave/lower-symbolic-memory.mlir)
[Symbolic memory contract](WaveIndexMap.md)
-->

---

# Scatter: permute the four slots

```mlir
%token = wave.scatter %value to %base mapping
    <bit_offset = <"32*(4*item + 2*Mod(slot, 2) + floor(slot/2))">>
    bindings ["item"](%item)
    : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.shared, i32>,
       !wave.simd<i32, 32>) -> !wave.mem.token
```

```text
               slot 0   slot 1   slot 2   slot 3
lane 0 writes:   A[0]     A[2]     A[1]     A[3]
lane 1 writes:   A[4]     A[6]     A[5]     A[7]
```

Compiler choice here: four scalar `wave.store` operations per lane.

<!--
The enclosing function has 32 workitems. %item is a bounded workitem_id with 0 <= item <= 31. %value contains four i32 slots per lane.
This is the permuted_scatter fixture. The map describes the same contiguous set of four addresses, but in slot order 0, 2, 1, 3. Current symbolic-memory lowering emits four extracts and four scalar stores; the relation does not require that particular implementation.
The offset unit is bits. Each slot maps to a distinct destination address.
[Scatter fixture](../test/Dialect/Wave/lower-symbolic-memory.mlir)
[Symbolic memory contract](WaveIndexMap.md)
-->

---

# Redistribute: swap neighboring lanes

```mlir
%out = wave.redistribute %in,
    <blocks = 1, items = 32, source_block = "block",
     source_item = "xor(item, 1)", source_slot = "slot">
    : !wave.simd<vector<2xi32>, 32>
    -> !wave.simd<vector<2xi32>, 32>
```

```text
destination lane:    0   1   2   3   ...
source lane:         1   0   3   2   ...
source slot:        unchanged
```

Compiler choice: `wave.shuffle` within each wave.

<!--
The map is destination-to-source: R(block, item, slot) = (block, xor(item, 1), slot). The enclosing function has 32 workitems and two i32 slots per lane.
The operation specifies the logical source value. The compiler determines the movement scope and selects local rearrangement, cross-lane instructions, or LDS. Identity requires no exchange.
The example is adapted from same_wave with a 32-workitem domain. Lowering is checked for a shuffle and no LDS allocation.
[Redistribution fixture](../test/Dialect/Wave/lower-redistribute.mlir)
[Index maps](WaveIndexMap.md)
-->

---

# Triton LinearLayout and Wave index expressions

8×8 `f32` tile · 32 lanes · 2 register slots per lane

```mlir
#layout = #ttg.linear<{
  register = [[0, 1]],
  lane = [[0, 2], [0, 4], [1, 0], [2, 0], [4, 0]],
  warp = [], block = []
}>
```

The same placement as direct index expressions:

```text
row = floor(lane / 4)
col = 2 * Mod(lane, 4) + slot
```

Triton XORs basis vectors selected by input bits.

<!--
lane ranges from 0 to 31; slot ranges from 0 to 1. Each basis vector corresponds to one input bit, least significant first. Output coordinates are (row, col).
The register bit contributes column bit 0. Lane bits 0 and 1 contribute column bits 1 and 2; lane bits 2 through 4 contribute row bits 0 through 2.
For these disjoint bit fields, the XOR basis map is exactly the arithmetic formula. This does not mean arbitrary overlapping basis contributions can be replaced by addition.
All 64 placements and the following transpose were checked against Triton's native LinearLayout evaluator.
[Triton layout algebra in the bridge](../integrations/tlx/docs/TLXWaveBridgeLayoutSystem.md)
[Wave expressions](WaveIndexMap.md)
-->

---

# Compose the relation for a transpose

Same placement for input and output: `out[row, col] = in[col, row]`

```text
sourceLane = 4 * col + floor(row / 2)
sourceSlot = Mod(row, 2)
```

```mlir
%out = wave.redistribute %in,
    <blocks = 1, items = 32, source_block = "block",
     source_item = "8*Mod(item, 4) + 4*slot + floor(item/8)",
     source_slot = "Mod(floor(item/4), 2)">
    : !wave.simd<vector<2xf32>, 32>
    -> !wave.simd<vector<2xf32>, 32>
```

<!--
The source block equals the destination block. The complete wave.redistribute operation is shown; item is the lane in this one-wave example.
The mapping is destination-to-source. Applying the input placement to (sourceLane, sourceSlot) gives (col, row), for every one of the 64 destination elements.
The equivalent Triton relation is source-layout inverse composed with the logical transpose and destination layout. Wave receives the resulting direct coordinate expressions.
For a row-major gather/scatter of the same tile, the address relation is bitOffset = 32 * (8*row + col), relative to the tile base. The compiler derives contiguous groups from that expression.
[Layout composition](../integrations/tlx/docs/TLXWaveBridgeLayoutSystem.md)
[Redistribution relation](WaveIndexMap.md)
-->

---

# Redistribute: swap the two waves

```mlir
%out = wave.redistribute %in,
    <blocks = 1, items = 64, source_block = "block",
     source_item = "xor(item, 32)", source_slot = "slot">
    : !wave.simd<vector<1xi8>, 32>
    -> !wave.simd<vector<1xi8>, 32>
```

```text
destination item:    0   1  ...  31 | 32  33  ...  63
source item:        32  33  ...  63 |  0   1  ...  31
                    ←── wave 0 ──→   ←── wave 1 ──→
```

Compiler choice: LDS store → barrier → LDS load.

<!--
The enclosing workgroup has 64 workitems and two wave32 waves. The example uses the relation and types from the capacity fixture, with available LDS instead of a full 64 KiB reservation. Lowering uses LDS stores, a barrier, and LDS loads. Scratch planning must fit the available capacity and establish address and stage coverage. A same-wave shuffle cannot implement this relation. Private scratch synchronization follows the value flow and must not take ownership of user token carries.
[Capacity rejection witness](../test/Integration/wave_redistribute_lds_capacity.mlir)
[Lifetime witness](../test/Integration/wave_redistribute_loop_lifetime.mlir)
-->

---

# Wave back: SSA all the way

Virtual register:

```text
!waveamdmachine.reg<vgpr, 1>
```

Allocated register:

```text
!waveamdmachine.reg<vgpr, 1, 8>
```

- Register class, width, and physical base live in the type.
- Distinct SSA values can share physical storage.
- Aliases, lifetimes, and fixed registers constrain allocation.

<!--
Wave back. Width counts contiguous 32-bit registers; the physical base is optional before allocation.
Keeping SSA values does not make physical-register hazards disappear.
[Register types](../include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTypes.td)
[Allocation contract](WaveAMDRegAllocDesign.md)
-->

---

# Symbolic indices become address fields

Illustrative byte offset, after width and range proofs:

```text
4 * (tile_base + k * stride + lane) + 16

soffset    = 4 * (tile_base + k * stride)
voffset    = 4 * lane
inst_offset = 16
```

**Uniformity and range select the fields.**

<!--
This is a legal decomposition only when the chosen target instruction's fields can represent it and their arithmetic preserves the original address semantics.
Do not move additions across a narrow wrapping offset without proof. The expression is explanatory algebra, not a universal instruction recipe.
[Symbolic offsets and bucketization](AMDGPUExplicitWaveProgrammingModel.md)
[Index contract](WaveIndexMap.md)
-->

---

# Still tokens. Still structured control.

```text
uniform_loop
  └─ exec_if
       ├─ memory issuer → token
       └─ data consumer
```

- Machine IR retains loops and masked regions.
- Scheduling follows SSA and explicit dependencies.
- Wait insertion sees real control flow.
- Physical hazards and final metadata remain explicit stages.

<!--
The diagram is schematic. The post-allocation pipeline preserves exec_if until ticket waits and hazard waits have seen structured control.
[Pipeline](../lib/Target/Wave/pipelines/pipelines.mlir)
[Hazard handling](HazardMitigationDesign.md)
-->

---

# The scheduler fills gaps

Illustrative schedule:

```text
before: load A | wait........ | use A | independent B
 after: load A | independent B | wait | use A
```

- Issue the original next instruction when it can proceed.
- On a modeled stall, choose a legal ready filler.
- If no filler fits, keep the stall.

<!--
Not a measured timing diagram. The filler must preserve SSA, token, singleton-register, and resource constraints.
[Gap-filling scheduler](AMDGPUOriginalOrderGapFillScheduler.md)
-->

---

# Separate legality from target policy

| Scheduler | Cost model |
|---|---|
| Dependency graph | Instruction readiness |
| Legal ready set | Resource occupancy |
| Apply selected order | Latency and pressure policy |
| Preserve constraints | Stall and filler admission |

**One scheduler; target-specific execution models.**

<!--
SCC, VCC, and M0 constraints remain visible to the dependence construction. A barrier opcode does not create an extra scheduling fence beyond its dependencies.
[Scheduler contract](AMDGPUOriginalOrderGapFillScheduler.md)
[Execution state model](WaveAMDInstructionExecutionStateModel.md)
-->

---

# Multi-wave specialization

```text
class A: memory → compute → memory → compute
class B: compute → memory → compute → memory
```

- Different static orders of the same dependency graph
- Wave-local readiness; shared SIMD/CU resources
- Matching barrier protocols across classes
- Bounded refinement and replay

<!--
Schematic orders: each must be a legal topological order for the actual input. Cloning precedes the normal joint scheduler.
This is opt-in static specialization, not runtime instruction selection based on live resource occupancy. Hardware still arbitrates wave issue.
[Multi-wave specialization](WaveAMDMultiWaveSpecializationDesign.md)
-->

---

# Materialization variants: `2*x` or `x+x`

```mlir
%two = arith.constant 2 : i32
%mul = wave.binary muli %x, %two : i32, i32 -> i32
%add = wave.binary addi %x, %x : i32, i32 -> i32
%choice = wave.materialization_variants %mul, %add : i32
```

`%choice = 2*x = x+x` (mod 2³²)

<!--
The producer establishes value and definedness equivalence. The examples use wrapping i32 arithmetic.
Candidates start from the same model state. Collapse preserves the selected order and state.
Interacting scopes merge; independent loops do not form a function-wide Cartesian product. Search is bounded.
[Materialization contract](WaveMaterializationVariantsDesign.md)
[Separate index-expression proposal](WaveIndexExprMaterializationDesign.md)
The enclosing function supplies %x: i32 and returns %choice. No no-wrap flags are attached, so both alternatives agree modulo 2^32.
This example comes from the materialization integration fixture. The multiplication and addition are semantic alternatives, not a runtime conditional.
[End-to-end variant fixture](../test/Integration/wave_materialization_candidate_expansion.mlir)
-->

---

# Machine IR: two producers, one choice

```mlir
!s = !waveamdmachine.reg<sgpr, 1>
!cc = !waveamdmachine.reg<scc, 1>
!imm = !waveamdmachine.imm

%two = waveamdmachine.imm 2 : !imm
%mul = waveamdmachine.s_mul_i32 %x, %two : (!s, !imm) -> !s
%add, %scc = waveamdmachine.s_add_i32 %x, %x
    : (!s, !s) -> (!s, !cc)
%choice = waveamdmachine.materialization_variants %mul, %add : !s
```

<!--
!s, !cc, and !imm are ordinary MLIR type aliases, reused on the next slides. Function and ABI setup are omitted.
The compact machine fixture takes %x: !s as a function argument and returns %choice. It uses the same instructions produced by Wave selection; isolating ABI setup gives a readable region input/output boundary.
s_add_i32 also defines SCC. That result is dead here; singleton-register constraints still apply during scheduling.
[Machine variant integration](../test/Integration/wave_materialization_candidate_expansion.mlir)
-->

---

# After expansion: one region per candidate

```mlir
%choice = waveamdmachine.materialization_candidates %x : !s -> !s {
^bb0(%x0: !s):
  %two = waveamdmachine.imm 2 : !imm
  %mul = waveamdmachine.s_mul_i32 %x0, %two : (!s, !imm) -> !s
  waveamdmachine.candidate_yield %mul : !s
}, {
^bb0(%x1: !s):
  %add, %scc = waveamdmachine.s_add_i32 %x1, %x1
      : (!s, !s) -> (!s, !cc)
  waveamdmachine.candidate_yield %add : !s
}
```

<!--
Actual expansion structure from waveamd-expand-materialization-variants, with SSA names made readable and the preceding type aliases retained.
%two disappears from the addition candidate. The wrapper owns the external use of %x; its regions use their own arguments.
These are alternative complete region bodies, not runtime branches. For a loop choice, expansion includes the loop and its dependent computation.
[Expansion tests](../test/Target/Wave/waveamdmachine-expand-materialization-variants.mlir)
[Candidate ownership contract](WaveMaterializationVariantsDesign.md)
-->

---

# Score the regions, keep one body

`gfx1100` model scores:

```mlir
// Multiply candidate terminator:
waveamdmachine.candidate_yield %mul : !s {cycles = 2 : i64}
// Add candidate terminator:
waveamdmachine.candidate_yield %add : !s {cycles = 2 : i64}
```

Tie → first region → collapse:

```mlir
%two = waveamdmachine.imm 2 : !imm
%mul = waveamdmachine.s_mul_i32 %x, %two : (!s, !imm) -> !s
return %mul : !s
```

<!--
These scores were produced by waveamd-machine-schedule with apply-schedule for the compact machine fixture on gfx1100. They are model scores, not measured hardware latency or a speedup claim.
The lower excerpt is the output of waveamd-collapse-materialization-variants, with names and aliases normalized. The wrapper and losing body are gone; allocation runs on selected code.
[Scoring and collapse contract](WaveMaterializationVariantsDesign.md)
-->

---

# Loop: carried offset or `base + i*stride`

```mlir
%result = scf.for %i = %zero to %n step %one
    iter_args(%carry = %base) -> i32 : i32 {
  %scaled = wave.binary muli %i, %stride : i32, i32 -> i32
  %recomputed = wave.binary addi %base, %scaled : i32, i32 -> i32
  %offset = wave.materialization_variants %carry, %recomputed : i32
  %next = wave.binary addi %offset, %stride : i32, i32 -> i32
  scf.yield %next : i32
}
```

<!--
The enclosing function defines %zero = 0 and %one = 1, takes %base, %stride, and %n as i32 arguments, and returns %result. All arithmetic wraps without no-wrap flags.
At iteration i, the carry equals base + i*stride modulo 2^32. A zero-trip loop returns base. The example isolates address arithmetic; adding a memory consumer also brings its data and token dependencies into the candidate scope.
The fragment is verified as MLIR, and expansion produces two complete uniform_loop candidates.
[Loop candidate fixture](../test/Integration/wave_materialization_candidate_expansion.mlir)
[Loop scope contract](WaveMaterializationVariantsDesign.md)
-->

---

# Loop expansion: two candidate bodies

**Carry: `offset ← offset + stride`**

```mlir
// Candidate 0: uniform_loop body; %carry is a loop argument.
%next, %cc0 = waveamdmachine.s_add_i32 %carry, %stride
    : (!s, !s) -> (!s, !cc)
```

**Recompute: `offset ← base + i*stride + stride`**

```mlir
// Candidate 1: uniform_loop body; %i is a loop argument.
%scaled = waveamdmachine.s_mul_i32 %i, %stride : (!s, !s) -> !s
%offset, %cc0 = waveamdmachine.s_add_i32 %base, %scaled
    : (!s, !s) -> (!s, !cc)
%next, %cc1 = waveamdmachine.s_add_i32 %offset, %stride
    : (!s, !s) -> (!s, !cc)
```

<!--
These are arithmetic excerpts from the two expanded machine regions, with SSA names normalized. Both regions contain the full uniform_loop, its setup, and its result consumer. The shared induction increment, exit test, and continue_if are omitted from the excerpts.
The first loop uses its offset carry. The second computes from base and the induction variable. Expansion removes the unused multiply and base addition from the first region. Both loops still carry their final result for the function return.
Type aliases are the same as on the preceding machine slides: !s = !waveamdmachine.reg<sgpr, 1>, !cc = !waveamdmachine.reg<scc, 1>.
[Loop expansion fixture](../test/Integration/wave_materialization_candidate_expansion.mlir)
[Candidate scope](WaveMaterializationVariantsDesign.md)
-->

---

# Register allocation with relief providers

```text
build alias state → linear scan
                         |
                       failure
                         ↓
 AGPR → Remat → SGPR-to-VGPR → LDS → Scratch
                         |
                 first legal rewrite
                         ↓
                       retry
```

**One allocation mechanism; ordered relief.**

<!--
The current implementation is an inspectable transform loop. A successful scan can finish; a relief rewrite invalidates allocation state and triggers another iteration.
Provider order is strict, not a global cheapest-plan competition. The first legal rewrite need not solve all pressure.
[Allocation contract](WaveAMDRegAllocDesign.md)
[Transform loop](../lib/Target/Wave/pipelines/pipelines.mlir)
-->

---

# Relief has a cost

- Alias sets move together; tuple offsets stay valid.
- Storage bank and operand interface bank can differ.
- Bridges and reloads create new live ranges.
- Rematerialization needs live leaves at every rebuilt use.
- Compatible MFMA accumulator chains need no bank bridges.

**The next scan sees the repair's pressure too.**

<!--
Show an interval diagram verbally if needed: one alias set spans the failure point; replace it with short consumer-side ranges, then account for those ranges in the next scan.
LDS relief is capacity/occupancy limited. Scratch is last in provider order.
[Allocation details](WaveAMDRegAllocDesign.md)
[Rematerialization witness](../test/Integration/wave_regalloc_invariant_input_remat_codegen.mlir)
-->

---

# E2E integration: Triton

```text
Triton Python
        ↓
TTIR → prepared AMD TTGIR
        ↓
structural bridge
        ↓
Wave / WaveAMD → WaveAMDMachine → HSACO
```

**Preserve frontend facts; let Wave make target decisions.**

<!--
Triton E2E. Triton owns source semantics, TTIR/TTGIR, AMD warp-pipeline conversion, and membar analysis.
Wave owns target-machine decisions after the bridge.
[Integration](../integrations/tlx/README.md)
-->

---

# A structural compiler boundary

```text
import → layouts/types → facts → tokens
       → target plan → verify → emit
```

- Separate LLVM/MLIR builds; no shared native handles
- Closed data contract with explicit provenance
- Layout movement stays symbolic
- Async completion stays explicit
- Unsupported semantics produce diagnostics

<!--
The target plan contains no source MLIR handles, callbacks, or lazy source lookups. Emission uses Wave's structural bindings and does not rediscover source semantics.
There is no silent LLVM backend fallback.
[Bridge contract](../integrations/tlx/README.md)
[Async protocol](../integrations/tlx/docs/TLXWaveAsyncMemoryProtocol.md)
-->

---

# From the tiled load to a real kernel

```text
symbolic global accesses
        ↓
DMA / LDS staging + explicit readiness
        ↓
matrix operations + accumulator state
        ↓
observed output stores
        ↓
scheduled, allocated machine code
```

GEMM · GLU · attention

<!--
This is the recurring example completed as a dataflow diagram, not a new performance claim. The repository contains Triton workloads and frozen Wave inputs for these kernel families.
Correctness must reach final ISA: gfx950 MFMA kernels require the audited packed-FP32 legalization and hazard rules across default and calibration pipelines.
[Triton workloads](../integrations/tlx/workloads/)
[Final-ISA witness](../test/Integration/wave_gfx950_packed_legalization.py)
[Assembly regression tests](../test/PerfGolden/)
-->

---

# Keep the information

- Execution intent in types and regions
- Memory intent in explicit dependencies
- Address relations in symbolic expressions
- Target choices in inspectable machine IR

## Questions?

<!--
End of main talk. Discuss where proof should end and target profitability should begin.
No hardware throughput claim is made in this deck. Cycle estimates, ISA checks, simulator results, and hardware timings establish different things.
-->

---

# Backup: WaveMeta

- Module parameters: `wavemeta.param`
- Static loops and conditionals
- Parameter-sized tuples: `!wavemeta.ptuple`
- Specialization produces concrete types and ordinary SSA

```text
parameter bindings → specialization → Wave lowering
```

<!--
Static and unrolled loops expand after controlling parameters become constant. Parametric tuples flatten through dialect conversion.
[WaveMeta dialect](../include/mlir/Dialect/Wave/IR/WaveMetaBase.td)
[Pipeline parameters](TransformDialectPipelineStrategy.md)
-->

---

# Backup: ixsimpl

- Integer-expression DAGs with shared nodes
- Simplification with ranges and assumptions
- Composition and proof over bounded coordinates
- Structural C/Python interfaces and binary serialization

**Prove relations here; choose target costs in the backend.**

<!--
C99 library. Wave uses a common index-map proof boundary; a failed or unknown proof does not authorize the requested transformation.
The library README has corpus-specific historical timing numbers; they are not used as a current compilation-speed claim here.
[Library](../third_party/ixsimpl/README.md)
[Wave proof contract](WaveIndexMap.md)
-->

---

# Backup: C frontend

Source fragment from the SAXPY runtime test:

```cpp
simd<uint32_t, W> lane = lane_id<W>();
uint32_t wave = workgroup_id<0>();
simd<uint32_t, W> i = wave * W + lane;
mask<W> active = i < n;
where (active) {
  simd<float, W> xv = load(x + i);
  simd<float, W> yv = load(y + i);
  output_done = join(output_done, store(a * xv + yv, y + i));
}
observe(output_done);
```

<!--
Fragment, not a complete translation unit. Enclosing kernel arguments and output_done initialization are omitted; W is a compile-time macro.
The lexer/parser/sema are C99; the lowering bridge builds Wave IR. This frontend uses the same target pipeline.
[Complete source](../test/Integration/Inputs/wavec_saxpy_runtime.wave)
[Frontend](CFrontendDesign.md)
-->

---

# Backup: two ways to represent layouts

| Triton bridge input | Wave relation |
|---|---|
| Named physical-to-logical maps | Direct symbolic coordinate expressions |
| `LinearLayout` for linear encodings | Integer and bitwise expression algebra |
| Encoding-specific import | Common composition and proof boundary |

```text
(register, lane, warp, block) → logical coordinates
                 ↓ composition
 destination coordinates → source coordinates
```

<!--
This compares representations in this integration, not a claim that one is universally better or faster.
Both sides carry bounded coordinate domains. Inverse relations need proofs because one logical element may have multiple physical locations.
[Bridge layout algebra](../integrations/tlx/docs/TLXWaveBridgeLayoutSystem.md)
[Wave direct maps](WaveIndexMap.md)
-->
