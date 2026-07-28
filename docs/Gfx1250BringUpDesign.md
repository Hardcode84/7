# gfx1250 Wave Backend Bring-Up

## Status

In progress.

LLVM source check: 2026-07-28. Audited high-VGPR implementation and tests match
public LLVM sources as of that date.

LLVM already owns gfx1250 target parsing, encodings, ELF identity, instruction
descriptions, intrinsics, descriptor fields, wait instructions, and schedule
classes. Wave must consume that support. Wave must not duplicate an ISA
database.

Current Wave support is partial:

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
- resource descriptors, matrix lowering, and scheduling still use older target
  assumptions.

## Goal

Compile and run correct gfx1250 Wave kernels in two steps:

1. scalar/vector kernels using global, buffer, LDS, scalar, and scratch memory;
2. f16 and bf16 GEMM using gfx1250 `16x16x32` wave32 WMMA.

Initial production support includes:

- exact gfx1250 target selection;
- valid MCInst emission and object generation;
- full `v0` through `v1023` allocation with late VGPR-window lowering;
- legal HSA kernel descriptors and entry sequence;
- split gfx12.5 wait counters driven by explicit memory tokens;
- correct buffer-resource packing, LDS facts, tuple alignment, and register
  budgets;
- gfx1250 WMMA fragment layouts and accumulator semantics;
- target-specific scheduling and hazard repair;
- Python target selection, compile-time Integration coverage, hardware
  correctness, and measured assembly goldens.

## Non-goals

Initial bring-up does not include:

- async global-to-LDS or LDS-to-global staging;
- tensor DMA;
- expert scheduling mode 2;
- cluster or multicast memory;
- named or split hardware barriers;
- SWMMAC, scaled WMMA, sparse WMMA, FP4, FP6, FP8, or BF8;
- attention tuning;
- gfx1251 enablement.

These need separate work after the scalar/vector and base WMMA path is proven.
Unsupported paths must fail with target-specific diagnostics.

## LLVM Contract

| Property | gfx1250 contract | Initial Wave policy |
|---|---|---|
| ISA | 12.5.0 | exact stepping match |
| wave size | 32 only | reject any other value |
| execution mode | CU mode, four SIMDs per CU | no WGP descriptor field |
| VGPRs | 1024 addressable in four 256-entry windows; allocation granule 16 | allocate the full range and lower window state after allocation |
| VGPR tuples | target-selected aligned multi-register operands | derive alignment from LLVM register classes |
| SGPRs | 106 architected; at most 32 user SGPRs | preserve ABI reservations and descriptor limit |
| accumulators | VGPR-backed | no AGPR allocation |
| LDS | 320 KiB, 32 banks | use both facts in legality and layout scoring |
| buffer resource | 57-bit base, 45-bit `NumRecords` | target-specific structural packing |
| waits | LOAD, STORE, DS, KM, X, ASYNC, TENSOR | base path implements first five |
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
- `llvm/lib/Target/AMDGPU/AMDGPULowerVGPREncoding.cpp`
- `llvm/lib/Target/AMDGPU/GCNHazardRecognizer.cpp`
- `llvm/lib/Target/AMDGPU/SIRegisterInfo.td`
- `llvm/lib/Target/AMDGPU/MCTargetDesc/AMDGPUInstPrinter.cpp`
- `llvm/lib/Target/AMDGPU/MCTargetDesc/AMDGPUTargetStreamer.cpp`
- `llvm/lib/Target/AMDGPU/Utils/AMDGPUBaseInfo.cpp`
- `llvm/docs/AMDGPUUsage.rst`

Public LLVM source:

- [gfx1250 processor model](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/GCNProcessors.td)
- [gfx1250 feature set](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/AMDGPU.td)
- [schedule model](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/SISchedule.td)
- [wait-counter implementation](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/SIInsertWaitcnts.cpp)
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

No public gfx1250 ISA manual was found. Every encoded instruction therefore
needs LLVM MC assembly and disassembly coverage. Hardware tests remain the
authority for runtime behavior and performance.

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
- keep switches outside hard clauses;
- place switches correctly around barriers, waits, and `s_delay_alu`;
- treat a switch as an implicit X-counter drain;
- reject unsupported high-VGPR operand maps and incompatible VOPD windows;
- reset to the low window around inline assembly.

Emission buffers each function's `MCInst` values, labels, directives, and
alignment until finalization. The buffered stage inserts the required `s_nop`
between a MODE write and a following switch before printing. Automatic switch
insertion and compatible MODE patching remain `.5`. Branches and fallthrough
labels for uniform conditionals, EXEC conditionals, loops, and DMA-delay
regions use the same buffer. No later pass may change physical VGPR operands.

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
Scheduler timing still buckets semantic events into legacy resources. `.8`
owns independent split-counter scheduling data.

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

FLAT, GDS, ASYNC, and TENSOR remain rejected until Wave models every required
counter and token obligation.

Base bring-up handles LOAD, STORE, DS, KM, and X. ASYNC and TENSOR stay
unavailable until their operations carry explicit tokens.

Required cases:

- load result use waits on LOAD;
- store token consumers wait on STORE;
- LDS consumers and barriers wait on DS;
- scalar-memory consumers wait on KM;
- operations classified by LLVM as X events wait on X;
- synchronous acquire-release global atomics use LLVM's split-wait, cache
  writeback, returning atomic, and cache-invalidate sequence;
- CFG joins and loop backedges retain all incoming obligations;
- `s_endpgm` provides the implicit terminal STORE drain; pending scratch stores
  forbid early VGPR deallocation.

Combined LOAD+DS and STORE+DS waits are an encoding choice after the semantic
requirements are known. They are not separate IR semantics. The abstract split
wait op reaches assembly only through `MCInst`; the emitter prefers LOAD+DS,
then STORE+DS, and emits remaining counters independently.

## Expert Scheduling Mode 2

Expert scheduling mode 2 is separate from LLVM's gfx1250 coexecution scheduler:

- `amdgpu-sched-strategy=coexec` selects a pre-register-allocation ordering
  policy;
- `amdgpu-expert-scheduling-mode` changes hardware dependency handling and runs
  in late, post-register-allocation wait insertion.

Neither enables the other. Initial bring-up keeps `HW_REG_WAVE_SCHED_MODE` at
zero. Coexecution scheduling and normal split completion waits do not require
expert mode.

Expert mode makes the compiler track physical-VGPR hazards that normal hardware
mode handles. LLVM maintains software `VA_VDST_RD` and `VA_VDST_WR` scores over
one hardware `VA_VDST` field, plus `VM_VSRC`. It classifies:

- Core/Side-MACC, DP-MACC, TRANS, and XDL VALU reads and writes;
- LDS, FLAT, and VMEM VGPR source reads.

Late wait insertion then emits `s_waitcnt_depctr`. It also programs scheduling
mode 2 at function entry, disables it around calls and returns, and drains
incoming dependency state for non-entry functions.

Wave's post-regalloc ticket-wait pass is the right placement, but its current
scoreboard tracks memory completion tickets, not physical VGPR RAW, WAR, and WAW
hazards. A separate opt-in project must add:

- target and function controls, default off;
- physical-register event scores and conservative CFG/loop joins;
- exact VALU and memory-family classification;
- scaled-WMMA double increments and LDS-DMA classification;
- `s_waitcnt_depctr` and scheduling-mode machine ops with MCInst emission;
- entry, call, return, and non-entry transition rules;
- late wait placement that avoids WMMA coexecution shadows.

Public correctness gaps to account for:

- [LLVM PR 211333](https://github.com/llvm/llvm-project/pull/211333): preserve
  `vm_vsrc` waits with outstanding async operations and marks;
- [LLVM PR 211684](https://github.com/llvm/llvm-project/pull/211684): retain soft
  waits until every loop predecessor has contributed state;
- [LLVM issue 175248](https://github.com/llvm/llvm-project/issues/175248): hoist
  dependency waits out of WMMA coexecution shadows.

These do not block normal-mode ASYNC or TENSOR counters. Keep expert mode
rejected until Wave carries equivalent correctness and placement logic.

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
- use LLVM's occupancy limit, 1024 architectural maximum, and 16-register
  allocation granule;
- honor `target_waves` through `maxVGPRsForWaves`;
- clamp explicit budgets and fixed base-plus-width ranges to target
  addressability;
- keep physical indices `0` through `1023` in `RegType`;
- use gfx1250 even-base alignment for multi-dword tuples instead of
  `PowerOf2Ceil(width)`;
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

The implementation needs:

- dedicated `MmaKind` entries;
- dedicated WaveAMDMachine operations or one typed gfx1250 WMMA operation;
- exact target legality;
- exact A, B, accumulator, and result fragment layouts;
- fill-zero, extract, unpack, and output-store mappings;
- two-address or killed-accumulator semantics;
- MC operand order and modifiers from LLVM's WMMA profile;
- XDL2 schedule classification with an initial eight-cycle latency.

Do not alias the existing gfx11 `16x16x16` WMMA kind. Shape, operand widths,
layout, and encoding differ.

First GEMM uses global loads, ordinary LDS stores, barriers, and ordinary LDS
loads. Async staging waits for the advanced memory model.

## Scheduler And Hazards

`ArchData.cpp` and related generated tables do not accept ISA 12.5. Add an
exact gfx1250 entry based on LLVM's `GFX1250SpeedModel`.

Initial bucket values:

| Class | Cycles |
|---|---:|
| f16/bf16 `16x16x32` WMMA, XDL2 | 8 |
| normal VALU/FMA write | 5 |
| transcendental write | 8 |
| SALU write | 2 |
| LDS | 20 |
| scalar memory | 20 |
| VMEM | 320 |

These are scheduling inputs, not measured throughput claims.

Hazard repair must audit:

- WMMA and TRANS coexecution windows;
- WMMA accumulator reuse and source reuse;
- unclaused initial VMEM behavior;
- scratch-base forwarding;
- waits followed by dependent VALU;
- VGPR-window switches, MODE writes, and fallthrough state;
- delay-ALU skip regions crossing `S_SET_VGPR_MSB`;
- terminal memory operations.

Reuse existing instruction traits and LLVM feature predicates. No
provider-specific gfx1250 code belongs in base register allocation.

The existing AMDGPU scheduler project may supply common schedule-table and
hazard infrastructure. gfx1250 bring-up owns its exact data, classification,
and tests.

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
- base-path memory staging;
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
- incompatible VOPD operand windows;
- async, tensor, cluster, multicast, named-barrier, or SWMMAC operation used;
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
| waits | independent LOAD/STORE/DS/KM/X, joins, loops, atomics, termination |
| VGPR windows | all four operand fields, `v256`/`v512`/`v768`/`v1023`, tuples across 256, CFG resets, MODE writes, clauses, inline assembly, X drains |
| resources | 32-bank choice, 320 KiB bound, target tuple alignment, 1024-VGPR maximum and 16-register granule |
| WMMA | exact fragments, killed accumulator, f16 and bf16 emission |
| scheduler | generated-table check, XDL2 class, target hazards |
| Python | exact profile selection and wrong-family rejection |
| Integration | scalar/vector kernel, f16 GEMM, bf16 GEMM |
| hardware | reference correctness, descriptor/scratch smoke, GEMM runtime |
| PerfGolden | deterministic checked-in ASM after same-hardware benchmark |

MC tests run without hardware. Hardware tests are required before production
closure. Missing hardware keeps the validation and closeout work open.

## Landing Order

1. target capability contract;
2. gfx12.5 MC emission and buffered VGPR-window finalization;
3. kernel ABI and entry;
4. split wait counters;
5. buffer, LDS, full VGPR allocation, and register-resource fixes;
6. scalar/vector Integration bring-up;
7. f16/bf16 WMMA and fragment layouts;
8. scheduler and hazard model;
9. Python profile and GEMM Integration;
10. hardware validation and measured PerfGolden;
11. integrated-tree audit and epic closure.

Dependencies form a DAG where ABI and waits can proceed in parallel after MC
emission. High-VGPR enablement waits for both MC finalization and X-counter
support.

## Tracked Work

Epic: `7-gfx1250-wave-backend-bringup-fa4l`

| Bead | Scope | Blocking dependencies |
|---|---|---|
| `.1` | target capability contract | none |
| `.2` | gfx12.5 MC emission and VGPR-window finalization foundation | `.1` |
| `.3` | kernel ABI and entry | `.2` |
| `.4` | split wait counters | `.2` |
| `.5` | resources, SRDs, full VGPR allocation, and automatic window lowering | `.1`, `.2`, `.4` |
| `.6` | scalar/vector Integration bring-up | `.3`, `.4`, `.5` |
| `.7` | f16/bf16 WMMA layouts | `.6` |
| `.8` | scheduler resources and hazards | `.7` |
| `.9` | Python profile and GEMM Integration | `.7`, `.8` |
| `.10` | hardware validation and measured ASM | `.9` |
| `.11` | integrated-tree audit and epic closure | `.1` through `.10` |

`.2` is related to `7-wavemachine-mc-tablegen-s1g6`. `.8` is related to
`7-amdgpu-scheduler-sy5.9`. Related edges record reuse; they do not block the
bring-up DAG.

Before each implementation change:

```bash
cmake --build build --target check-wave-mlir -j $(nproc)
cmake --build build --target check-wavec -j $(nproc)
```

Run affected Integration, Target, Python, and PerfGolden tests in addition.
Final closeout runs full sequential gates, hooks, `git diff --check`, tracker
sync, and an unchanged regeneration check.

## Completion

Bring-up is complete when:

- unsupported target-family fallback is impossible;
- scalar/vector and f16/bf16 GEMM objects assemble and disassemble as gfx1250;
- all four VGPR windows pass MC, CFG, hazard, resource, and Integration tests;
- descriptor, waits, resources, and fragments match the LLVM contract;
- Integration tests compile in normal CI;
- hardware results match CPU references;
- checked-in assembly has a same-hardware benchmark record;
- the integrated tree passes all required gates;
- remaining advanced features have explicit diagnostics and separate scope.
