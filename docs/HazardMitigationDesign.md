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

Primary hazard classes modeled today include:

| Hazard | Producer | Consumer | Gap |
|---|---|---|---|
| VALU after LGKM-clearing wait | `s_waitcnt` with non-default lgkm | any `VALUOp`-trait op | 1 cycle on non-CDNA4 targets (`s_delay_alu` on gfx11+, `s_nop 0` elsewhere) |
| TRANS forwarding on gfx940-family | `WriteTrans32` VALU op | non-TRANS `VALUOp`-trait op reading the TRANS result | 1 instruction |
| M0 read after `s_mov_m0` | `s_mov_m0` | any op with a `!m0`-typed operand | 1 instruction |
| VMEM store after MFMA | any `MFMAOp`-trait op | any `VMEMStoreOp`-trait op consuming the MFMA result | pass-count-derived XDL result latency |
| MFMA physical result write | allocated MFMA result span | later read/write of the same span | pass-count-derived XDL result latency |
| MFMA SrcC WAR | allocated MFMA accumulator span | later write of the same span | pass-count-derived XDL SrcC latency |
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
latencies, TRANS forwarding wait states, LGKM wait behavior, and target ISA
state used to derive MFMA pass-count latencies. CDNA4 disables the
LGKM-to-VALU gap; LLVM and CDNA4 docs have no matching post-`s_waitcnt` VALU
hazard. `valuDep1` is the `s_delay_alu` encoding for "wait one VALU cycle",
computed once at pass start. The gfx940-family TRANS forwarding gap is one
wait state.

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

## Cross-references

- Upstream LLVM: `llvm/lib/Target/AMDGPU/GCNHazardRecognizer.{h,cpp}`
  uses per-instruction-class `check*()` methods with hard-coded
  latency locals and a `getWaitStatesSince()` template for backward
  walks with state memoization. No central catalog.
  `AMDGPUWaitSGPRHazards.{h,cpp}` is a separate post-schedule pass
  for gfx12 SGPR RAW hazards using per-block dataflow.

Wave uses dense forward dataflow for active hazards, with trait-based
op classification from the local WaveAMDMachine dialect.

## Deferred work

**Hazard-aware code motion.** `waveamd-hazard-repair` handles the
pre-scheduler local repair pass. `waveamd-insert-hazard-waits` also contracts
some barrier drains, fills LGKM/VALU gaps, and hoists M0 moves before final
NOP insertion.

**Tablegen-described catalog.** A generated hazard catalog only pays
off once we ship 10+ hazard kinds with multiple subcases each. Three
direct C++ hazards are fine for now.

**Forwarding precision.** No-machine-inst ops conservatively copy the
union of operand hazards to all results. That is safe for current
pseudo ops, but tuple-like ops could keep per-lane precision if false
positive waits ever show up in real kernels.

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
