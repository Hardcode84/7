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
LGKM pending bit plus active SSA-value hazards.

Three hazard classes are modeled today:

| Hazard | Producer | Consumer | Gap |
|---|---|---|---|
| VALU after LGKM-clearing wait | `s_waitcnt` with non-default lgkm | any `VALUOp`-trait op | 1 cycle on non-CDNA4 targets (`s_delay_alu` on gfx11+, `s_nop 0` elsewhere) |
| M0 read after `s_mov_m0` | `s_mov_m0` | any op with a `!m0`-typed operand | 1 instruction |
| VMEM store after 4-pass MFMA | any `MFMAOp`-trait op | any `VMEMStoreOp`-trait op consuming the MFMA result | 7 instructions on CDNA3, 8 on CDNA4 and other targets |

## Lattice Shape

`HazardState` has two parts:

- `lgkmPending` / `lgkmToValu`: lgkm issuers increment pending count;
  draining waits arm the VALU gap only on targets that need it.
- `DenseMap<Value, ValueHazards>`: active hazards carried by SSA
  value. Today `ValueHazards` has `m0` and `mfmaStore` countdowns.

Joins take max LGKM state and max countdown per `(Value, hazard)`.
Each counted instruction decrements all active SSA countdowns. Producer
ops seed result hazards: `s_mov_m0` seeds `m0 = 1`, and MFMA ops seed
`mfmaStore = 7/8`. No-machine-inst forwarding ops conservatively copy
operand hazards to results.

Constants for the gaps live in `HazardConfig` (`m0PipelineDelay = 1`,
`mfmaResultLatency = 7/8` for CDNA3/CDNA4 4-pass MFMA store use).
CDNA4 disables the LGKM-to-VALU gap; LLVM and CDNA4 docs have no
matching post-`s_waitcnt` VALU hazard. `valuDep1` is the `s_delay_alu`
encoding for "wait one VALU cycle", computed once at pass start.

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
- `MFMAOp` -- the MFMA producer set for the VMEM-store hazard.

Adding a new MFMA variant requires only tagging it with `MFMAOp`; the
hazard pass sees it automatically.

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
across active SSA hazards on the operands, advances the local state by
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

**Hazard-aware code motion.** The dataflow tells us which consumer
still needs waits, but not which movable instructions should fill the
gap. A later pass can use the same state to try local code motion
before falling back to `s_nop`.

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
  saturation; pseudo-op interleave; chained `s_mov_m0`; cross-block
  via `cf.cond_br` / `cf.br`; CFG join/sibling VALU-LGKM state;
  VALU-LGKM through `uniform_loop` entry/exit state;
  MFMA carried
  through a `uniform_loop` back-edge and consumed inside the body;
  same MFMA consumed after the loop via the exit-to-parent carry;
  pass-through carry with external producer; pass-through carry
  with no producer.
