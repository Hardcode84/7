# Hazard mitigation: architecture

How `lib/Dialect/Wave/Transforms/WaveAMDHazardWaits.cpp` models and
inserts AMDGPU hazard-mitigation NOPs, and why it's shaped the way it is.

## Where the pass sits

The pass runs late in the WaveAMD lowering pipeline, after ABI
lowering, register allocation, memory-tuple decomposition, and
ticket-wait insertion. Ticket waits run after regalloc because
regalloc preparation can insert `v_mov_b32_tuple`, a VALU op that
itself needs the LGKM-wait mitigation if it becomes the first VALU
after an `s_waitcnt`. Hazard mitigation runs after ticket waits
because it reacts to emitted `s_waitcnt`s.

The pass scans every `waveamdmachine` op for malformed input, runs a
dense forward dataflow over each function, then rewrites blocks with a
mutable local copy of the incoming state. The lattice carries the
LGKM pending bit, active SSA-value hazards, and physical-register
hazard windows.

Hazard classes:

| Hazard | Producer | Consumer | Gap |
|---|---|---|---|
| VALU after LGKM-clearing wait | `s_waitcnt` with non-default lgkm | any `VALUOp`-trait op | 1 cycle on non-CDNA4 targets (`s_delay_alu` on gfx11+, `s_nop 0` elsewhere) |
| TRANS forwarding on gfx940-family | `WriteTrans32` VALU op | non-TRANS `VALUOp`-trait op reading the TRANS result | 1 instruction |
| Destination-selection forwarding on gfx940-family | VALU result with destination selection | overlapping VALU read or write | 1 instruction |
| M0 read after `s_mov_m0` | `s_mov_m0` | any op with a `!m0`-typed operand | 1 instruction |
| VMEM store after MFMA | any `MFMAOp`-trait op | any `VMEMStoreOp`-trait op consuming the MFMA result | pass-count-derived XDL result latency |
| MFMA physical result write | allocated MFMA result span | later read/write of the same span | pass-count-derived XDL result latency |
| MFMA SrcC WAR | allocated MFMA accumulator span | later VALU or memory write of the same span | pass-count-derived XDL SrcC latency |
| VALU physical write | allocated VGPR/SGPR/VCC/EXEC result | later consumers sensitive to that class | target-specific VALU write latency |
| Store write-data | selected stores | later physical span users | target-specific store-data latency |

## Lattice Shape

`HazardState` has two parts:

- `lgkmPending` / `lgkmToValu`: lgkm issuers increment pending count;
  draining waits arm the VALU gap only on targets that need it.
- `DenseMap<Value, ValueHazards>`: active hazards carried by SSA
  value. `ValueHazards` tracks M0 and MFMA-store countdowns.
- `SmallVector<PhysicalHazard>`: post-regalloc hazards keyed by
  physical register span.
- VCC and EXEC-to-MFMA counters for hazards that are singleton-like but not
  represented as ordinary SSA value hazards.

Joins take max LGKM state and max countdown per `(Value, hazard)`.
Each counted instruction decrements all active SSA countdowns. Producer
ops seed result hazards: `s_mov_m0` seeds the M0 gap, and MFMA ops seed
pass-count-derived result hazards. No-machine-inst forwarding ops
conservatively copy operand hazards to results.

Constants for the gaps live in `HazardConfig`: M0 pipeline delay, VALU write
latencies, forwarding wait states, LGKM wait behavior, and target ISA
state used to derive MFMA pass-count latencies. CDNA4 disables the
LGKM-to-VALU gap; LLVM and CDNA4 docs have no matching post-`s_waitcnt` VALU
hazard. `valuDep1` is the `s_delay_alu` encoding for "wait one VALU cycle",
computed once at pass start. Gfx940-family TRANS and destination-selection
forwarding gaps are one wait state. This rule matches the
[LLVM destination-selection hazard](https://github.com/llvm/llvm-project/blob/30bff76d3a294fe0882a05472234b25bb752b16a/llvm/lib/Target/AMDGPU/GCNHazardRecognizer.cpp#L1063-L1184).
MFMA SrcC WAR repair covers VALU, VMEM, and DS register writes, matching
[LLVM's MAI hazard check](https://github.com/llvm/llvm-project/blob/30bff76d3a294fe0882a05472234b25bb752b16a/llvm/lib/Target/AMDGPU/GCNHazardRecognizer.cpp#L3336-L3451).

## gfx950 MFMA operand read-skip

On gfx950, an MFMA can cause a packed-FP32 VALU instruction on a co-executing
wave to skip its operand read. The VALU instruction can then use stale VGPR
data. The confirmed victim class is `v_pk_add_f32`, `v_pk_mul_f32`, and
`v_pk_fma_f32`.

Post-schedule target legalization disables these packed operations for each
gfx950 function that contains an MFMA or scaled MFMA operation. It lowers every
packed lane to scalar instructions before register allocation. Keeping the
packed representation through scheduling preserves its compact live range and
resource cost. The rule covers the full function because the victim and MFMA
can run on different waves. Functions without matrix operations keep
packed-FP32 throughput.

This erratum does not change instruction order. Scheduler legality remains SSA
dominance plus explicit token edges. Hazard repair does not insert an MFMA NOP.

The public [ROCm erratum workaround](https://github.com/ROCm/triton/commit/aa3cf1a1601f19ac254946bf891a7c002803b30a)
implements packed-FP32 target-feature suppression and cites ROCM-27743 and
DEGGIGX90-5078. [LLVM issue 206825](https://github.com/llvm/llvm-project/issues/206825)
contains the public reproducer and the schedule-sensitive symptom. The
[CDNA4 ISA reference](https://www.amd.com/content/dam/amd/en/documents/instinct-tech-docs/instruction-set-architectures/amd-instinct-cdna4-instruction-set-architecture.pdf)
defines the affected MFMA instruction class.

## Trait-based classification

No denylists of opcodes. Tablegen-declared traits drive every
classification decision:

- `NoMachineInst` -- op produces no hardware instruction (pseudo
  ops: `arg`, `imm`, `token`, `s_waitcnt*`, `s_workgroup_id_*`,
  `v_workitem_id_x`, `tuple_*`, `wait`, `token_join`). Used by gap
  counting to skip ops that don't consume a wait state.
- `VALUOp`, `VMEMLoadOp`, `VMEMStoreOp`, `SMEMLoadOp`,
  `LDSLoadOp`, `LDSStoreOp`,
  `WaitcntOp`, `TokenOp`, `TokenJoinOp` -- pre-existing functional
  classifiers used both here and in other passes.
- `MFMAOp` -- the MFMA producer set. MFMA variants also need schedule-class
  pass-count support.

Adding a new MFMA variant requires `MFMAOp` tagging plus valid MMA
schedule-class/pass-count support; missing pass-count data is a hard error.

## Dataflow Edges

`HazardAnalysis` subclasses `DenseForwardDataFlowAnalysis`. Transfer
handles normal ops; edge hooks remap hazards across structural value
forwarding:

- `BranchOpInterface`: successor operands map to successor block
  arguments.
- `RegionBranchOpInterface`: entry operands map to region arguments;
  terminator operands map to back-edge arguments or parent results.
- Parent-to-region edges count the parent op as one instruction when
  it is not tagged `NoMachineInst`, matching the machine gap model.

The solver sees the original IR. The rewrite therefore mirrors
`WaveAMDMachineWaitcnt.cpp`: seed a local state from the solver's
block-entry lattice, walk the block, insert waits, and update the
local state immediately. Control-flow ops refresh local state from
the solver's post-op lattice; nested regions are rewritten from their
own block-entry states.

At a consumer, the rewrite inserts the maximum needed `s_nop` count
across active SSA and physical hazards, advances the local state by
that count, then applies the VALU-after-LGKM mitigation if needed.
Hazard aging counts `s_nop N` as `N + 1` wait states, matching
[LLVM's wait-state model](https://github.com/llvm/llvm-project/blob/30bff76d3a294fe0882a05472234b25bb752b16a/llvm/lib/Target/AMDGPU/SIInstrInfo.cpp#L1932-L1941).

## Cross-references

- Upstream LLVM: `llvm/lib/Target/AMDGPU/GCNHazardRecognizer.{h,cpp}`
  uses per-instruction-class `check*()` methods with hard-coded
  latency locals and a `getWaitStatesSince()` template for backward
  walks with state memoization. No central catalog.
  `AMDGPUWaitSGPRHazards.{h,cpp}` is a separate post-schedule pass
  for gfx12 SGPR RAW hazards using per-block dataflow.

Wave uses dense forward dataflow for active hazards, with trait-based
op classification from the local WaveAMDMachine dialect.

## File layout

- `lib/Dialect/Wave/Transforms/WaveAMDHazardWaits.cpp` -- the pass.
- `include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.td` --
  trait declarations (`WaveAMDMachine_NoMachineInst`,
  `WaveAMDMachine_MFMA`) and per-op tagging.
- `include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h` --
  C++ trait class templates.
- `test/Target/Wave/waveamdmachine-hazard-waits.mlir` -- lit tests
  covering: same-block VALU-LGKM (gfx11 + gfx10); same-block M0;
  TRANS forwarding on gfx942/gfx950;
  saturation; pseudo-op interleave; chained `s_mov_m0`; cross-block
  via `cf.cond_br` / `cf.br`; CFG join/sibling VALU-LGKM state;
  VALU-LGKM through `uniform_loop` entry/exit state;
  MFMA carried
  through a `uniform_loop` back-edge and consumed inside the body;
  same MFMA consumed after the loop via the exit-to-parent carry;
  pass-through carry with external producer; pass-through carry
  with no producer.
