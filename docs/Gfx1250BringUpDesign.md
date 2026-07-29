# gfx1250 Wave Backend Bring-Up

## Validation Boundary

Compile-time evidence does not establish runtime correctness, performance, or
same-hardware assembly quality. Those claims require hardware validation.

LLVM already owns gfx1250 target parsing, encodings, ELF identity, instruction
descriptions, intrinsics, descriptor fields, wait instructions, and schedule
classes. Wave must consume that support. Wave must not duplicate an ISA
database.

Wave support includes:

- target parsing recognizes ISA 12.5;
- gfx1250 defaults to wave32 and rejects wave64;
- final emission accepts the audited gfx1250 scalar/vector subset and rejects
  missing target mappings;
- MC finalization preserves high-VGPR identities and emits visible
  `S_SET_VGPR_MSB` window switches;
- LOAD, STORE, DS, KM, and X waits use the split-counter model below;
- agent-scoped acquire-release global atomic add uses the gfx1250 cache and
  split-wait sequence;
- packed f16 and bf16 conversions have broad ISA 12.5 capability checks;
- kernarg preload and terminal VGPR deallocation contain broad ISA 12.5
  handling;
- buffer descriptors, LDS accounting, and register allocation use gfx1250
  target facts;
- the dedicated unscheduled pipeline lowers scalar/vector global, buffer, LDS,
  SMEM, and scratch kernels through object link and disassembly;
- pressure-driven allocation crosses `v255` and restores visible VGPR-window
  state across conditional edges and joins;
- legacy per-lane direct-to-LDS operations reject during instruction
  selection;
- f16 and bf16 `16x16x32` WMMA lower through regalloc, MC assembly, object
  linking, and disassembly;
- schedule classes and resources come from LLVM MC schedule queries;
- normal-mode TRANS, WMMA, and scratch hazards emit visible repair
  instructions.

TDM support adds:

- raw D0/D1 and D0-D3 SGPR tuple transfers;
- Python descriptor packing and tuple-selection sugar;
- explicit issue dependencies and completion tokens;
- partial `s_wait_tensorcnt`, including nonzero counts;
- completion-neutral descriptor-derived L2 prefetch;
- LLVM-derived two-micro-op HWLGKM+HWVMEM scheduling;
- compile-only IR, MC, object, and disassembly coverage.

## Goal

Compile and run correct gfx1250 Wave kernels in three steps:

1. scalar/vector kernels using global, buffer, LDS, scalar, and scratch memory;
2. f16 and bf16 GEMM using gfx1250 `16x16x32` wave32 WMMA;
3. tokenized TDM load, store, and prefetch over raw LLVM descriptor tuples.

Compile-time support includes:

- exact gfx1250 target selection;
- valid MCInst emission and object generation;
- full `v0` through `v1023` allocation with late VGPR-window lowering;
- legal HSA kernel descriptors and entry sequence;
- split gfx12.5 wait counters driven by explicit memory tokens;
- correct buffer-resource packing, LDS facts, tuple alignment, and register
  budgets;
- gfx1250 WMMA fragment layouts and accumulator semantics;
- target-specific scheduling and hazard repair;
- opt-in expert scheduling with post-regalloc dependency waits;
- Python target selection and compile-time Integration coverage.

TDM compile-time support includes:

- D2 and D4 descriptor forms without a second descriptor IR;
- SGPR tuple allocation and LLVM MC operand validation;
- tensor completion waits through CFG joins and loops;
- visible TDM and tensor-wait assembly;
- conservative scheduling without measured hardware timing.

## Non-goals

gfx1250 scope does not include:

- legacy `waveamd.dma_load_lds` enablement on gfx1250;
- high-level TDM descriptor IR, fused loads, and gather or scatter;
- cluster or multicast memory;
- named or split hardware barriers;
- SWMMAC, scaled WMMA, sparse WMMA, FP4, FP6, FP8, or BF8;
- typed inline assembly;
- VOPD pairing;
- attention tuning;
- gfx1251 enablement.

Unsupported paths must fail with target-specific diagnostics.

## LLVM Contract

| Property | gfx1250 contract | Wave policy |
|---|---|---|
| ISA | 12.5.0 | exact stepping match |
| wave size | 32 only | reject any other value |
| execution mode | CU mode, four SIMDs per CU | no WGP descriptor field |
| VGPRs | LLVM reports 1024 addressable in four 256-entry windows and a 16-register allocation granule | query LLVM, allocate the full range, then lower window state |
| VGPR tuples | target-selected aligned multi-register operands | derive alignment from LLVM register classes |
| SGPRs | 106 architected; at most 32 user SGPRs | preserve ABI reservations and descriptor limit |
| accumulators | VGPR-backed | no AGPR allocation |
| LDS | 320 KiB, 32 banks | use both facts in legality and layout scoring |
| buffer resource | 57-bit base, 45-bit `NumRecords` | target-specific structural packing |
| waits | LOAD, STORE, DS, KM, X, ASYNC, TENSOR | base path implements first five; TDM implements TENSOR |
| matrix base | f16/bf16 `16x16x32` WMMA | f32 accumulator only |
| code object | target accepts HSA code objects; Wave emits v6 | validate descriptor with LLVM tools |

gfx1251 remains distinct. New bring-up gates use exact gfx1250 identity or LLVM
feature predicates. Instruction selection, resource limits, schedule data, and
performance features must not infer shared behavior from ISA 12.5 alone.

LLVM source is the executable specification:

- `llvm/include/llvm/TargetParser/AMDGPUTargetParser.def`
- `llvm/lib/Target/AMDGPU/AMDGPU.td`
- `llvm/lib/Target/AMDGPU/GCNProcessors.td`
- `llvm/lib/Target/AMDGPU/SISchedule.td`
- `llvm/lib/Target/AMDGPU/SIInsertWaitcnts.cpp`
- `llvm/lib/Target/AMDGPU/AMDGPUWaitcntUtils.h`
- `llvm/lib/Target/AMDGPU/MIMGInstructions.td`
- `llvm/lib/Target/AMDGPU/AMDGPULowerVGPREncoding.cpp`
- `llvm/lib/Target/AMDGPU/GCNHazardRecognizer.cpp`
- `llvm/lib/Target/AMDGPU/SIRegisterInfo.td`
- `llvm/lib/Target/AMDGPU/MCTargetDesc/AMDGPUInstPrinter.cpp`
- `llvm/lib/Target/AMDGPU/MCTargetDesc/AMDGPUTargetStreamer.cpp`
- `llvm/lib/Target/AMDGPU/Utils/AMDGPUBaseInfo.cpp`
- `mlir/lib/Conversion/AMDGPUToROCDL/AMDGPUToROCDL.cpp`
- `llvm/docs/AMDGPUUsage.rst`
- `llvm/docs/AMDGPUDMAOperations.md`

Public LLVM source:

- [gfx1250 processor model](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/GCNProcessors.td)
- [gfx1250 feature set](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/AMDGPU.td)
- [schedule model](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/SISchedule.td)
- [wait-counter implementation](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/SIInsertWaitcnts.cpp)
- [TDM instruction definitions](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/MIMGInstructions.td)
- [TDM descriptor lowering](https://github.com/llvm/llvm-project/blob/main/mlir/lib/Conversion/AMDGPUToROCDL/AMDGPUToROCDL.cpp)
- [DMA operation contract](https://github.com/llvm/llvm-project/blob/main/llvm/docs/AMDGPUDMAOperations.md)
- [Triton Gluon TDM DSL](https://github.com/triton-lang/triton/blob/main/python/triton/experimental/gluon/language/amd/gfx1250/tdm.py)
- [Triton TDM wait accounting](https://github.com/triton-lang/triton/blob/main/third_party/amd/lib/TritonAMDGPUTransforms/UpdateAsyncWaitCount.cpp)
- [Triton TDM store pipelining](https://github.com/triton-lang/triton/blob/main/third_party/amd/lib/TritonAMDGPUTransforms/TDMStoresPipeline.cpp)
- [wait event classification](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/AMDGPUHWEvents.cpp)
- [global atomic ordering](https://github.com/llvm/llvm-project/blob/main/llvm/test/CodeGen/AMDGPU/memory-legalizer-global-agent.ll)
- [terminal VGPR deallocation](https://github.com/llvm/llvm-project/blob/main/llvm/test/CodeGen/AMDGPU/release-vgprs.mir)
- [high-VGPR lowering](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/AMDGPULowerVGPREncoding.cpp)
- [VGPR register classes](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/SIRegisterInfo.td)
- [high-VGPR assembly printing](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/MCTargetDesc/AMDGPUInstPrinter.cpp)
- [architected workgroup-ID lowering](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/SIISelLowering.cpp)
- [SALU delay insertion](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/AMDGPUInsertDelayAlu.cpp)
- [gfx1250 descriptor reference](https://github.com/llvm/llvm-project/blob/main/llvm/test/tools/llvm-objdump/ELF/AMDGPU/kd-gfx1250.s)
- [AMDGPU target and ABI guide](https://github.com/llvm/llvm-project/blob/main/llvm/docs/AMDGPUUsage.rst)

LLVM source and MC are the public instruction evidence used here. Every encoded
instruction needs MC assembly and disassembly coverage. Hardware tests remain
the authority for runtime behavior and performance.

Triton and Gluon provide compiler prior art, not an ABI dependency. Their
surface includes high-level descriptors, fused loads, gather/scatter, prefetch,
barrier signaling, partial tensor waits, and loop-pipelined stores. Late wait
accounting converts logical operations to emitted TDM instruction counts. Wave
keeps one TENSOR ticket per emitted instruction; LLVM micro-op count affects
issue slots, not `s_wait_tensorcnt`.

## Target Capability Boundary

Target parsing happens once. Downstream code receives parsed target facts, not
chip strings.

Extend `WaveAMDMachineTarget` with shared queries for:

- exact ISA identity;
- supported wave sizes;
- addressable register counts and VGPR-window support;
- allocation granules and tuple alignment;
- LDS size and bank count;
- architected scratch and kernarg preload;
- wait-counter family;
- matrix families;
- descriptor field availability.

Stable architecture facts may derive from `llvm::AMDGPU::IsaVersion`. MC
legality and opcode selection use `MCSubtargetInfo` feature predicates.

Do not use a broad ISA 12.5 helper as the matrix or schedule gate. Exact
gfx1250 identity and LLVM feature predicates carry those decisions.

## MC Emission

`lib/Target/Wave/AMDGPU.cpp` resolves VI, gfx11, and gfx1250 opcodes through
LLVM MC tables. gfx1250 remains a distinct encoding and operand-schema family.

MC policy:

1. Enable each gfx1250 operation only after its opcode and ABI coverage is
   complete.
2. Extend the declarative mapping used by `AMDGPUOpcodes.def`.
3. Select instructions with `IsaVersion` and `MCSubtargetInfo` predicates.
4. Audit operand schemas, implicit operands, cache-policy fields, and tuple
   classes for every enabled operation.
5. Preserve physical high-VGPR identities in `MCInst` operands.
6. Finalize window state before `MCCodeEmitter` and `MCInstPrinter`.

Core audit set:

- scalar move, arithmetic, compare, branch, and EXEC manipulation;
- vector move, arithmetic, compare, conversion, permutation, and 64-bit
  arithmetic;
- global and buffer loads and stores at every Wave width;
- scalar memory;
- LDS loads, stores, and atomics;
- scratch loads and stores;
- split waits;
- barriers used by the base path;
- `s_endpgm` and terminal deallocation.

No gfx11 fallback is permitted. Missing gfx1250 mappings fail before object
emission and name the unsupported WaveAMDMachine operation.

This work should reuse the declarative WaveAMDMachine MC-emission project.
Bring-up owns gfx1250 mappings and coverage; it should not create a parallel
handwritten emitter.

### TDM Transfer ABI

Core Wave IR accepts hardware descriptor groups, not tensor shapes or strides:

| Form | Operands |
|---|---|
| D2 | D0: SGPR4, D1: SGPR8 |
| D4 | D0: SGPR4, D1: SGPR8, D2: SGPR4, D3: SGPR4 |

Tuple widths, register classes, alignment, and named operand positions come
from LLVM instruction and register metadata. D4 form has exactly D0 through D3.
LLVM's internal `r128` selector stays zero and never becomes Wave IR or assembly
syntax.

Descriptor kind, prefetch mode, and cache policy use TableGen enums with
generated stringify and symbolize helpers. Python static sugar mirrors LLVM's
public descriptor layout for one issuing wave, including finalized load/store
padding. Multi-wave or dynamically finalized descriptors enter as raw external
groups. C++ lowering does not duplicate the descriptor encoder. Packing stays
structural. No string round-trip.

Grouped issue is sugar. Python builds each member's tuples, selects D0 through
D3 tuple-wise by uniform predicate, then emits one ordinary TDM transfer. No
fused Wave or WaveAMDMachine operation. Unsupported group shapes fail before
selection.

TDM load and store consume a dependency token and produce a completion token.
The input orders issue. The result denotes TENSOR completion. Load reads global
memory and writes LDS. Store reads LDS and writes global memory. No implicit
alias edge or barrier is inferred.

Descriptor-derived prefetch consumes an issue dependency and returns a
completion-neutral token. It forwards dependency completion events but adds no
event of its own. It does not issue tensor memory, allocate a TENSOR ticket, or
require `s_wait_tensorcnt`. Regular and speculative modes remain distinct typed
values.

MC emission selects LLVM's D2 or D4 opcode from descriptor kind and emits real
`MCInst` values:

```text
tensor_load_to_lds
tensor_store_from_lds
s_wait_tensorcnt
```

Assembly keeps transfers and waits visible. No direct ISA text printing.

### VGPR Addressing Windows

gfx1250 encodes only the low eight bits of each VGPR operand. Four two-bit
selectors supply the high bits for logical `src0`, `src1`, `src2`, and `dst`
fields. `S_SET_VGPR_MSB` changes those selectors.

```text
S_SET immediate: src0[1:0] src1[3:2] src2[5:4] dst[7:6]
MODE register:   dst[13:12] src0[15:14] src1[17:16] src2[19:18]
```

Register allocation must keep real physical `v0` through `v1023` identities.
Do not fold a register to its low alias or pass it through text. Late MC
finalization:

1. uses `getVGPRLoweringOperandTables` to map each opcode's operands to the
   four logical fields;
2. gets each physical register's selector with `getVGPREncodingMSBs`;
3. inserts `S_SET_VGPR_MSB` when required;
4. encodes the new selector byte in bits 7:0 and the previous selector byte in
   bits 15:8;
5. lets `AMDGPUInstPrinter` print low aliases plus high-register comments.

The assembler accepts the low aliases, not source operands named `v256` or
higher. Disassembly reconstructs high-register comments from MC state.

Window mode is ABI-zero at entry. Finalization restores zero before branches,
calls, returns, and block fallthrough. `s_endpgm` needs no restore. It must
also:

- patch compatible `S_SETREG_IMM32_B32(MODE)` writes with current selectors;
- insert the required `s_nop` before a switch after an incompatible MODE write,
  including a write in a fallthrough predecessor;
- move a first-member switch before its hard clause, then resize or drop a
  clause when a later member needs a switch;
- place switches correctly around barriers, waits, and `s_delay_alu`;
- treat a switch as an implicit X-counter drain;
- reject unsupported high-VGPR operand maps.

Emission buffers each function's `MCInst` values, labels, directives, and
alignment until finalization. The buffered stage inserts the required `s_nop`
between a MODE write and a following switch before printing. Automatic switch
insertion and compatible MODE patching use this buffered stage. Branches and
fallthrough labels for uniform conditionals, EXEC conditionals, loops, and
DMA-delay regions use the same buffer. No later pass may change physical VGPR
operands. WaveAMDMachine has no inline-assembly or VOPD producer.
Finalization does not fabricate raw `MCInst` values for absent operations.
Wave-visible state enums use TableGen-generated stringify and symbolize
helpers; selector field order otherwise comes directly from LLVM's operand
tables.

Landing is gated:

- MC bring-up preserves high registers, buffers instructions, and round-trips
  explicit switches while allocation remains below 256;
- register-resource work enables automatic window lowering and removes the cap
  only after split X-counter handling is available.

## Wait Counters And Ordering

Wave memory ordering remains explicit SSA token ordering. gfx1250 support must
not add alias inference, implicit barriers, or loop-carried dependencies.

Legacy Wave targets use three physical counter classes: VMEM, LGKM, and VSCNT.
gfx1250 uses split wait instructions:

```text
s_wait_loadcnt
s_wait_storecnt
s_wait_dscnt
s_wait_kmcnt
s_wait_xcnt
s_wait_asynccnt
s_wait_tensorcnt
```

Wait modeling has two layers:

1. operation traits describe semantic completion events;
2. a target mapping assigns events to physical counters and emitted waits.

The gfx1250 mapping must mirror LLVM's `WaitEventMaskForInstGFX12Plus`.
Existing targets keep their current VMEM/LGKM/VSCNT mapping.
Scheduler timing keeps semantic events separate from split completion counters.
Target MC schedule resources provide issue timing.

Completion and source lifetime use separate scoreboards:

- completion tickets retain SSA identity, issue order, out-of-order state, and
  writes-memory state;
- X tickets name allocated physical register units used as VMEM or SMEM
  sources; VMEM also records its implicit EXEC use.

X waits occur only before a physical definition overlaps a pending source.
Reads do not wait. Physical definitions are checked before the current
instruction's implicit drain or SMEM/VMEM group switch. Structured EXEC
lowering includes hidden save-stack SGPR definitions and EXEC writes at arm
transitions. SMEM and VMEM interleaving then drains the previous source group.
Branches, barriers, register-control operations, messages, termination, and
`S_SET_VGPR_MSB` drain X implicitly. LOAD waits retire matching VMEM X tickets
when no STORE remains; `KM(0)` retires SMEM X tickets.

Dataflow joins keep the conservative oldest live ticket. Loops converge through
the existing lattice. Counter field limits and combined-wait encoding come from
LLVM AMDGPU helpers; Wave does not duplicate field widths.

| Semantic event | Existing targets | gfx1250 completion | gfx1250 source |
|---|---|---|---|
| VMEM read | VMEM | LOAD | X |
| VMEM or scratch write | VSCNT | STORE | X |
| LDS | LGKM | DS | none |
| SMEM | LGKM | KM | X |
| message | LGKM | KM | none |
| TDM load or store | unavailable | TENSOR | none |

FLAT, GDS, and ASYNC remain rejected until Wave models every required counter
and token obligation. TENSOR is legal only for tokenized TDM load and store.

Base memory handles LOAD, STORE, DS, KM, and X. TDM adds TENSOR.
ASYNC stays unavailable.

Required cases:

- load result use waits on LOAD;
- store token consumers wait on STORE;
- LDS consumers and barriers wait on DS;
- scalar-memory consumers wait on KM;
- TDM completion consumers wait on TENSOR;
- operations classified by LLVM as X events wait on X;
- synchronous acquire-release global atomics use LLVM's split-wait, cache
  writeback, returning atomic, and cache-invalidate sequence;
- CFG joins and loop backedges retain all incoming obligations;
- `s_endpgm` provides the implicit terminal STORE drain; pending scratch stores
  forbid early VGPR deallocation.

Each TDM load or store creates one ordered TENSOR ticket. A consumer waits with
the count of younger live tickets, so independent newer transfers may remain
in flight. `s_wait_tensorcnt 0` drains all. Nonzero waits are required for
pipelines. CFG joins and loops retain the oldest required ticket.

Tensor-wait capacity comes from LLVM's AMDGPU counter-width helper. The MC
operand schema performs final encoding validation. Wave does not duplicate a
counter maximum or field width. Prefetch creates no TENSOR ticket and cannot
force a tensor wait.

Combined LOAD+DS and STORE+DS waits are an encoding choice after the semantic
requirements are known. They are not separate IR semantics. The abstract split
wait op reaches assembly only through `MCInst`; the emitter prefers LOAD+DS,
then STORE+DS, and emits remaining counters, including TENSOR, independently.

## Expert Scheduling Mode 2

Expert scheduling mode 2 is separate from LLVM's gfx1250 coexecution scheduler:

- `amdgpu-sched-strategy=coexec` selects a pre-register-allocation ordering
  policy;
- `waveamdmachine.expert_scheduling_mode` is a unit function attribute that
  selects hardware mode 2 and late physical-register dependency waits.

Neither enables the other. Attribute absence keeps normal mode. Coexecution
scheduling and split completion waits do not require expert mode.

Expert mode makes the compiler track physical-VGPR hazards that normal hardware
mode handles. LLVM maintains software `VA_VDST_RD` and `VA_VDST_WR` scores over
one hardware `VA_VDST` field, plus `VM_VSRC`. It classifies:

- Core/Side-MACC, DP-MACC, TRANS, and XDL VALU reads and writes;
- LDS, FLAT, and VMEM VGPR source reads.

`waveamd-insert-ticket-waits` owns the expert scoreboard after register
allocation. It keys hazards by full physical VGPR index, before MC window
lowering, and keeps separate read, write, and VM-source scores. Typed operation
traits classify event families. TableGen enums supply event, counter, and mode
names. Issue increments come from the shared cost-model query and its generated
operation interfaces; no operation count is duplicated in the pass.

CFG and loop joins take the oldest incoming score. A nonzero wait is retained
when all live events share one family. Mixed families drain to zero because
completion may be out of order. Current VALU consumers omit VA waits: hardware
handles VALU-to-VALU hazards in expert mode. Dependency field limits come from
LLVM's AMDGPU helpers.

TDM transfers consume raw SGPR tuples and do not participate in expert
dependency counters. Prefetch tracks its VGPR offset as a FLAT-family source.
Dependency waits do not imply TENSOR completion and never force
`tensorcnt(0)`; memory-token consumers retain independent partial TENSOR waits.

Kernel entry enables mode 2. Callable entry enables mode 2 before draining
incoming LOAD, DS, KM, VA, and VM-source state. Calls run in normal mode and
restore mode 2 afterward. Returns drain callable state and restore normal mode.
Kernel termination stays in mode 2.

`waveamdmachine.s_wait_alu` and `waveamdmachine.s_set_sched_mode` are typed
machine operations. MC emission only validates fields and builds `MCInst`.
`MCInstPrinter` keeps dependency waits and scheduling-mode writes visible in
assembly and disassembly.

## Kernel ABI And Entry

Wave's descriptor printer currently emits fields that LLVM rejects for
gfx1250:

- DX10 clamp;
- IEEE mode;
- WGP mode;
- shared VGPR count.

Descriptor construction must query target features before emitting fields.
gfx1250 requires:

- CU mode;
- architected private-segment enable when scratch is used;
- gfx12 user-SGPR encoding;
- correct round-robin and forward-progress fields;
- no AGPR or shared-VGPR accounting;
- named-barrier count zero for the base path;
- target-consistent XNACK fields;
- next-free SGPR/VGPR values rounded with target granules.

The startup `global_prefetch_b8 ... scope:SCOPE_SE` plus `v_nop` sequence used
by current gfx1250 code generation is a target workaround. Model it as an
entry-sequence capability and emit it through MCInst before user instructions.
Keep its reserved input registers visible to entry-register accounting.
Targets with LLVM's wait-xcnt feature also set replay mode through LLVM's
HWREG encoding.

Architected workgroup IDs need explicit Wave ABI materialization: X from
TTMP9, Y from TTMP7 low half, Z from TTMP7 high half. Cluster-capable targets
reconstruct grid workgroup IDs from TTMP6 local/max fields, then use LLVM's
IB_STS2 encoding to select raw IDs when clustered dispatch is disabled. Count
the two entry temporaries in SGPR metadata; regalloc may reuse them after the
prelude.

Entry materialization runs after Wave hazard repair. Its dependent SALU chains
must emit `s_delay_alu` themselves, including the final ID-to-kernel-body edge.

Validation is object-level:

1. assemble the emitted source;
2. disassemble the text section with `llvm-objdump`;
3. dump the kernel descriptor and metadata;
4. compare fields against an equivalent LLVM-generated kernel.

Text matching alone cannot prove descriptor correctness.

## Buffer Resources And LDS

`WaveAMDBufferRsrcToTuples.cpp` currently packs a gfx11 descriptor:

- 64-bit base;
- one 32-bit range;
- hard-coded gfx11 format and flag bits.

gfx1250 uses a 57-bit base and 45-bit `NumRecords`. Keep base, record count,
format, and flags structural until target-specific lowering. The gfx1250
packer must define every bit and reject values that do not fit. Base updates
must preserve record-count and flag fields.

Tests need:

- zero, one, and maximum record counts;
- base bits crossing the old 48-bit and new 57-bit boundaries;
- record counts crossing 32 bits;
- update-base round trips;
- MC assembly of every enabled buffer load/store width.

`WaveLowerRedistribute.cpp` currently assigns 64 LDS banks to gfx1250. The
correct value is 32. Query the shared target facts and add a conflict-scoring
test whose choice differs between 32 and 64 banks.

LDS allocation must accept up to 320 KiB while preserving user LDS, spill LDS,
and future protocol reservations in one accounting path.

## Register Allocation

gfx1250 register allocation uses one physical VGPR file, not four allocator
register banks. The addressing windows are late encoding state.

Required allocator changes:

- remove the text-emission cap from `WaveAMDRegisterLimits.cpp`;
- query LLVM for occupancy limit, architectural maximum, and allocation
  granule;
- honor `target_waves` through `maxVGPRsForWaves`;
- clamp explicit budgets and fixed base-plus-width ranges to target
  addressability;
- keep physical indices `0` through `1023` in `RegType`;
- derive every multi-dword tuple's legal bases from LLVM register classes
  instead of `PowerOf2Ceil(width)`;
- keep low-256 constraints for `LD_SCALE` and inline-assembly operands;
- keep the existing low-to-high linear scan so low windows win naturally;
- keep accumulators in VGPRs and reject AGPR requests;
- report the real high-water mark through resource metadata;
- verify final addressability, fixed ranges, and tuple alignment.

Allocation and encoding legality remain separate. The allocator may choose a
tuple spanning a 256-entry boundary when LLVM's class permits it. MC
finalization derives the selector from the physical base register.

No switch-cost heuristic is required for correctness. Each operand field has
independent state, so assigning every operand to one window is not the cost
model. Scheduler work may add field-aware affinity after measuring emitted
transitions, but cannot create a separate register class or reserve high
windows unconditionally.

High allocation stays disabled until automatic window finalization, MODE
hazards, block resets, X-counter interaction, and high-water resource reporting
pass together. Failure then means target occupancy exhausted, index above
`v1023`, or unsupported operand encoding—not merely crossing `v255`.

TDM descriptors stay in SGPR tuples. Selection reads each LLVM operand's
register class and constrains D0, D1, D2, and D3 accordingly. Regalloc derives
legal tuple bases from `MCRegisterInfo`; it does not apply a generic
power-of-two width rule or add gfx1250 register-count constants. D1 uses the
LLVM class accepting its eight-register tuple. D0, D2, and D3 use the class
accepting their four-register tuples.

## WMMA And Fragment Layouts

Initial matrix support adds two exact kinds:

```text
wmma.f32.16x16x32.f16
wmma.f32.16x16x32.bf16
```

Each wave32 lane provides:

- 16 f16 or bf16 elements for A: 8 VGPR dwords;
- 16 f16 or bf16 elements for B: 8 VGPR dwords;
- 8 f32 accumulator elements: 8 VGPR dwords;
- 8 f32 result elements: 8 VGPR dwords.

The implementation uses:

- TableGen `MmaKind` entries and generated stringifiers;
- dedicated WaveAMDMachine operations;
- exact target legality;
- exact A, B, accumulator, and result fragment layouts;
- fill-zero, extract, unpack, and output-store mappings;
- two-address or killed-accumulator semantics;
- LLVM opcode mapping, named operands, register classes, and WMMA modifiers;
- XDL2 schedule classification with an initial eight-cycle latency.

Do not alias the existing gfx11 `16x16x16` WMMA kind. Shape, operand widths,
layout, and encoding differ.

First GEMM uses global loads, ordinary LDS stores, barriers, and ordinary LDS
loads. Async staging waits for the advanced memory model.

## Scheduler And Hazards

Build the exact gfx1250 entry from LLVM subtarget and MC scheduling data:

- execution-unit, wave, VGPR, and LDS facts come from AMDGPU target helpers;
- representative AMDGPU opcodes resolve through `MCInstrInfo` and
  `MCSubtargetInfo`;
- schedule latency and resource acquire/release cycles come from the resolved
  MC schedule class;
- direct MC probes supply legal classes with no same-named `WriteRes`;
- Wave schedule classes and functional units use TableGen enums and generated
  symbolizers;
- generated tables contain no fallback timing constants and fail closed when a
  required gfx1250 class or resource is absent.

TDM load and store classify both LDS and VMEM memory paths. The generated
`WriteTDM` class probes the real LLVM opcode: 320-cycle latency, two micro-ops,
HWLGKM `[0,1)`, HWVMEM `[0,1)`, and HWRC `[0,2)`. Two SIMD issue slots cover
that single-wave MC envelope. Memory-path masks do not claim an independent
gfx1250 port or multi-wave throughput model.

Prefetch uses its resolved ordinary prefetch resources. It has no TENSOR
completion event.

Generated tables are scheduling inputs, not measured throughput claims.

Normal-mode hazard repair follows LLVM target features:

- XDL2 WMMA has eight-cycle latency and release occupancy;
- WMMA-to-WMMA overlap needs five intervening VALU slots;
- WMMA-to-coexecutable-VALU overlap needs four intervening VALU slots;
- TRANS RAW or WAR overlap needs one `v_nop`; SALU does not age the window;
- scratch-base forwarding tracks physical `s102` and `s103` writes for ten
  SGPR-defining SALU or VALU instructions;
- scratch repair emits typed `s_wait_alu sa_sdst(0) va_sdst(0)`;
- `va_vdst(0)` clears VALU/TRANS VGPR dependencies;
- `va_sdst(0)` clears VALU-to-SGPR dependencies; VCC and EXEC stay live;
- CFG and loop joins retain the maximum incoming obligation.

WMMA stays distinct from legacy VALU and MFMA classification. Inserted
`v_nop` and `s_wait_alu` operations flow through `MCInst` and remain visible in
assembly and disassembly.

Final MC buffering also enforces:

- unclaused initial VMEM behavior;
- MODE-to-window-switch separation across fallthrough labels;
- paired delay-ALU dependencies unpack only for destructive window edits;
- affected hard clauses drop; unaffected packed delays and clauses survive;
- delay targets cannot cross labels or control flow;
- terminal memory completion and scratch-store deallocation rules.

Reuse existing instruction traits and LLVM feature predicates. No
provider-specific gfx1250 code belongs in base register allocation.

The existing AMDGPU scheduler project may supply common schedule-table and
hazard infrastructure. gfx1250 bring-up owns classification, repair, and tests.
Expert scheduling stays disabled unless the function carries
`waveamdmachine.expert_scheduling_mode`. Normal coexecution and forwarding
repair must not emit `HW_REG_WAVE_SCHED_MODE`.

## Python And Tools

One public target profile must drive matmul, attention, examples, calibration,
and test feature detection.

The gfx1250 profile contains:

- wave size 32;
- 320 KiB LDS and 32 banks;
- `wmma_gfx1250` matrix family;
- f16/bf16 `16x16x32` kinds;
- K tile 32;
- VGPR accumulator layout;
- base-path and TDM memory staging;
- D2/D4 descriptor packing and grouped tuple-selection helpers;
- static packing limited to one issuing wave, with explicit load/store padding;
- raw tuple entry for externally finalized descriptors;
- partial tensor waits and completion-neutral prefetch;
- occupancy and static-LDS limits.

Auto selection must choose this profile only for exact gfx1250. The current
fallback that maps every non-gfx9 target to generic `wmma` is invalid.

Lit features must distinguish:

- a gfx1250 device;
- gfx11 WMMA;
- gfx1250 WMMA.

## Diagnostics

Reject unsupported work before final emission. Required diagnostics include:

- wave64 requested for gfx1250;
- gfx11 WMMA kind selected for gfx1250;
- gfx1250 WMMA kind selected for another target;
- AGPR requested;
- register index above `v1023` or the occupancy budget;
- high-VGPR operand without a lowering table;
- legacy async, cluster, multicast, named-barrier, or SWMMAC operation used;
- TDM operation used on another target;
- D2 with extra groups or D4 without exactly D2 and D3;
- TDM tuple outside its LLVM operand register class;
- tensor wait count outside LLVM-reported counter capacity;
- missing gfx1250 MC opcode mapping;
- descriptor value outside the target field width.

## Test Plan

| Layer | Required proof |
|---|---|
| target | exact parse, wave32 default, wave64 rejection, gfx1251 negative |
| capabilities | register, LDS, bank, granule, matrix, and wait facts |
| machine lowering | operation legality and exact gfx1250 opcode selection |
| MC | assemble and disassemble each enabled instruction family |
| ABI | object descriptor and entry-sequence round trip |
| TDM IR | D2/D4 tuple forms, typed modes, tuple-wise grouped selection, token chains |
| TDM MC | load/store forms, SGPR tuple classes, visible assembly and disassembly |
| waits | independent LOAD/STORE/DS/KM/X/TENSOR, nonzero tensor waits, joins, loops, atomics, termination |
| prefetch | issue ordering without TENSOR tickets or tensor waits |
| VGPR windows | all four operand fields, `v256`/`v512`/`v768`/`v1023`, tuples across 256, CFG resets, MODE writes, clauses, X drains |
| resources | 32-bank choice, 320 KiB bound, target tuple alignment, and LLVM-reported VGPR limits |
| WMMA | exact fragments, killed accumulator, f16 and bf16 emission |
| scheduler | generated-table check, XDL2 class, TDM WriteTDM/HWLGKM/HWVMEM pressure, target hazards |
| Python | exact profile selection, descriptor packing, grouped selects, wrong-family rejection |
| Integration | scalar/vector memory, high-VGPR CFG, f16/bf16 GEMM, TDM load/store/prefetch |
| hardware | separate runtime-correctness gate |
| measured PerfGolden | separate performance gate |

MC tests run without hardware. Hardware and measured PerfGolden rows are
outside compile-time acceptance. Evidence is limited to verifier and lowering
tests, MC assembly and disassembly, object linking, and schedule-table
comparison against LLVM's `llvm-mca` model. No runtime-correctness or
performance claim.

## Dependency Order

1. target capability contract;
2. gfx12.5 MC emission and buffered VGPR-window finalization;
3. kernel ABI and entry;
4. split wait counters;
5. buffer, LDS, full VGPR allocation, and register-resource fixes;
6. scalar/vector Integration bring-up;
7. f16/bf16 WMMA and fragment layouts;
8. scheduler and hazard model;
9. Python profile and GEMM Integration;
10. integrated-tree validation.

Dependencies form a DAG where ABI and waits can proceed in parallel after MC
emission. High-VGPR enablement waits for both MC finalization and X-counter
support. Runtime validation is a separate dependency.

TDM support divides into three layers:

1. raw tuple IR and Python packing/select sugar;
2. machine selection, MC emission, tensor waits, and conservative scheduling;
3. compile-only dialect, Integration, assembly, and disassembly validation.

## Compile-Time Acceptance

Compile-time support is complete when:

- unsupported target-family fallback is impossible;
- scalar/vector and f16/bf16 GEMM objects assemble and disassemble as gfx1250;
- all four VGPR windows pass MC, CFG, hazard, resource, and Integration tests;
- descriptor, waits, resources, and fragments match the LLVM contract;
- TDM D2/D4 tuples select legal LLVM opcodes and register classes;
- issue dependencies and completion tokens place zero and nonzero tensor
  waits correctly;
- prefetch forwards dependencies without adding a completion event;
- TDM schedule pressure includes generated WriteTDM, HWLGKM, and HWVMEM data;
- TDM assembly remains visible and round-trips through LLVM MC;
- Integration tests compile in normal CI;
- the integrated tree passes all required gates;
- remaining advanced features have explicit diagnostics and separate scope.

Runtime correctness and performance require CPU-reference agreement and
same-hardware benchmarks.
