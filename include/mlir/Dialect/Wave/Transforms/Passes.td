//===-- Passes.td - Wave transformation definitions --------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_PASSES_TD
#define MLIR_DIALECT_WAVE_TRANSFORMS_PASSES_TD

include "mlir/Pass/PassBase.td"

def ConvertWaveAMDToWaveAMDMachine : Pass<"waveamd-to-machine"> {
  let summary = "Select Wave/WaveAMD operations into inspectable WaveAMDMachine IR";
  let description = [{
    Lowers source-level Wave operations to generic WaveAMDMachine dialect
    operations. This is the explicit backend boundary: the result is still MLIR,
    but the values are selected into SGPR/VGPR-like register classes and
    machine-like operations.
  }];

  let dependentDialects = [
    "func::FuncDialect",
    "waveamd::WaveAMDDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveFormPackedMath : Pass<"wave-form-packed-math"> {
  let summary = "Form packed Wave math ops from scalar lane pairs";
  let description = [{
    Function-local SLP-style formation for adjacent scalar Wave SIMD values.
    The first version pairs only same-block f32->f16 casts and scalar f16
    fadd/fmul/fma trees, then materializes wave.pack leaves and wave.extract
    scalar users around packed vector<2xf16> operations.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "wave::WaveDialect"
  ];
}

def WaveAMDABILowering
    : Pass<"waveamd-abi-lowering"> {
  let summary = "Lower WaveAMDMachine function arguments to the AMDGPU kernel ABI";
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDHazardWaits
    : Pass<"waveamd-insert-hazard-waits"> {
  let summary = "Insert WaveAMDMachine waitcnt and hazard instructions";
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDDecomposeMemTuples
    : Pass<"waveamd-decompose-mem-tuples"> {
  let summary = "Decompose tuple memory ops into per-element scalar memory ops";
  let description = [{
    Each `*_load_tuple_b32` becomes N scalar `*_load_b32` ops at
    `inst_offset + i*4`, gathered via `tuple_from_elements` (data) and
    `token_join` (token). Each `*_store_tuple_b32` becomes a
    `tuple_to_elements` split followed by N scalar `*_store_b32` ops,
    joined via `token_join`. After this pass no `*_tuple_b32` mem ops
    remain. Runs before waitcnt insertion so the per-element tokens
    are visible to the scoreboard.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDTicketWaits
    : Pass<"waveamd-insert-ticket-waits"> {
  let summary = "Insert WaveAMDMachine waitcnt instructions using ticket scoreboards";
  let description = [{
    Tracks async memory operations with per-counter tickets and inserts the
    minimum waitcnt threshold required by SSA uses. This is the waitcnt pass
    intended for the staged WaveAMDMachine backend; pipeline hazards remain a
    separate concern.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDMachineSchedule
    : Pass<"waveamd-machine-schedule"> {
  let summary = "Apply model-based local WaveAMDMachine scheduling";
  let description = [{
    Scheduler pass over `waveamdmachine` IR. The default mode is a no-op; with
    `apply-schedule`, it discovers local scheduling regions, ranks legal
    candidate orders with the event simulator and pressure policy, and rewrites
    the region when the selected order is non-original.

    Intended placement is before ticket-wait and hazard-wait insertion. Hard
    boundaries include terminators, labels, branches, waitcnts, workgroup
    barriers, priority changes, region-bearing ops, and unsupported
    side-effecting ops. `uniform_loop` bodies are scanned as nested local
    regions, but the loop op itself is never part of an outer region.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
  let options = [
    Option<"applySchedule", "apply-schedule", "bool", /*default=*/"false",
           "Apply the best non-worse model-scored local schedule.">,
    Option<"beamSearch", "beam-search", "bool", /*default=*/"false",
           "Enable guided beam-search scheduler candidates.">,
    Option<"pressureAwareSelection", "pressure-aware-selection", "bool", /*default=*/"false",
           "Use register-pressure budgets to select scheduler candidates.">,
    Option<"modelWaves", "model-waves", "int", /*default=*/"1",
           "Wave count used by model-scored local scheduling.">,
    Option<"modelSimds", "model-simds", "int", /*default=*/"1",
           "SIMD count used by model-scored local scheduling.">,
    Option<"modelStartDelay", "model-start-delay", "int", /*default=*/"0",
           "Cycle delay between modeled waves.">,
    Option<"modelVmemValueLatency", "model-vmem-value-latency", "int", /*default=*/"-1",
           "VMEM-load value-ready latency used by model-scored local scheduling.">,
    Option<"modelSmemValueLatency", "model-smem-value-latency", "int", /*default=*/"-1",
           "SMEM-load value-ready latency used by model-scored local scheduling.">,
    Option<"modelLdsValueLatency", "model-lds-value-latency", "int", /*default=*/"-1",
           "LDS-load value-ready latency used by model-scored local scheduling.">,
    Option<"pressureVgprBudget", "pressure-vgpr-budget", "int", /*default=*/"-1",
           "Hard VGPR budget override for scheduler pressure policy; -1 uses the target default.">,
    Option<"pressureSgprBudget", "pressure-sgpr-budget", "int", /*default=*/"-1",
           "Hard SGPR budget override for scheduler pressure policy; -1 uses the target default.">,
    Option<"pressureCriticalVgprBudget", "pressure-critical-vgpr-budget", "int", /*default=*/"-1",
           "Critical VGPR budget override for scheduler pressure policy; -1 uses an explicit multi-wave target.">,
    Option<"pressureCriticalSgprBudget", "pressure-critical-sgpr-budget", "int", /*default=*/"-1",
           "Critical SGPR budget override for scheduler pressure policy; -1 uses an explicit multi-wave target.">,
    Option<"pressureTargetWavesOverride", "pressure-target-waves-override", "int", /*default=*/"-2",
           "Override waveamdmachine.target_waves; -2 uses explicit IR attrs, -1 disables derived critical budgets, 0 uses the target maximum.">
  ];
}

def WaveAMDMachineScheduleReport
    : Pass<"waveamd-machine-schedule-report"> {
  let summary = "Print WaveAMDMachine scheduler diagnostics";
  let description = [{
    Non-mutating diagnostics pass for the machine scheduler. It shares region
    discovery, dependence construction, scoring, candidate generation, and
    pressure measurement with `waveamd-machine-schedule`.

    Reports that need pressure clone the function before regalloc preparation,
    so the input IR is not rewritten.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
  let options = [
    Option<"printRegions", "print-regions", "bool", /*default=*/"false",
           "Print discovered local scheduling regions to stderr.">,
    Option<"printDeps", "print-deps", "bool", /*default=*/"false",
           "Print local scheduling dependences to stderr.">,
    Option<"printScore", "print-score", "bool", /*default=*/"false",
           "Print event-simulator scores for local scheduling regions.">,
    Option<"printCandidates", "print-candidates", "bool", /*default=*/"false",
           "Print model-scored scheduler candidate orders to stderr.">,
    Option<"printClasses", "print-classes", "bool", /*default=*/"false",
           "Print scheduler class, functional unit, and latency for each local-region op.">,
    Option<"beamSearch", "beam-search", "bool", /*default=*/"false",
           "Enable guided beam-search scheduler candidates.">,
    Option<"pressureAwareSelection", "pressure-aware-selection", "bool", /*default=*/"false",
           "Use register-pressure budgets to select scheduler candidates.">,
    Option<"modelWaves", "model-waves", "int", /*default=*/"1",
           "Wave count used by model-scored local scheduling.">,
    Option<"modelSimds", "model-simds", "int", /*default=*/"1",
           "SIMD count used by model-scored local scheduling.">,
    Option<"modelStartDelay", "model-start-delay", "int", /*default=*/"0",
           "Cycle delay between modeled waves.">,
    Option<"modelVmemValueLatency", "model-vmem-value-latency", "int", /*default=*/"-1",
           "VMEM-load value-ready latency used by model-scored local scheduling.">,
    Option<"modelSmemValueLatency", "model-smem-value-latency", "int", /*default=*/"-1",
           "SMEM-load value-ready latency used by model-scored local scheduling.">,
    Option<"modelLdsValueLatency", "model-lds-value-latency", "int", /*default=*/"-1",
           "LDS-load value-ready latency used by model-scored local scheduling.">,
    Option<"pressureVgprBudget", "pressure-vgpr-budget", "int", /*default=*/"-1",
           "Hard VGPR budget override for scheduler pressure diagnostics; -1 uses the target default.">,
    Option<"pressureSgprBudget", "pressure-sgpr-budget", "int", /*default=*/"-1",
           "Hard SGPR budget override for scheduler pressure diagnostics; -1 uses the target default.">,
    Option<"pressureCriticalVgprBudget", "pressure-critical-vgpr-budget", "int", /*default=*/"-1",
           "Critical VGPR budget override for scheduler pressure diagnostics; -1 uses an explicit multi-wave target.">,
    Option<"pressureCriticalSgprBudget", "pressure-critical-sgpr-budget", "int", /*default=*/"-1",
           "Critical SGPR budget override for scheduler pressure diagnostics; -1 uses an explicit multi-wave target.">,
    Option<"pressureTargetWavesOverride", "pressure-target-waves-override", "int", /*default=*/"-2",
           "Override waveamdmachine.target_waves; -2 uses explicit IR attrs, -1 disables derived critical budgets, 0 uses the target maximum.">,
    Option<"scoreFunc", "score-func", "std::string", /*default=*/"\"\"",
           "Function name whose local region should score a candidate order.">,
    Option<"scoreRegion", "score-region", "int", /*default=*/"-1",
           "Local region ordinal for score-order; -1 disables candidate scoring.">,
    Option<"scoreOrder", "score-order", "std::string", /*default=*/"\"\"",
           "Comma-separated op indices for a candidate local-region order.">
  ];
}

def WaveAMDRegAlloc
    : Pass<"waveamd-reg-alloc", "ModuleOp"> {
  let summary = "Allocate WaveAMDMachine virtual registers to physical registers";
  let description = [{
    Linear-scan VGPR/SGPR allocator over WaveAMDMachine IR. In the
    default mode (`mark-overflow=false`), running out of physical
    registers fails the pass. In `mark-overflow=true` (used by the
    autotuning loop) the pass instead annotates the offending func
    with `waveamdmachine.regalloc_overflowed = i64 1`, leaves the
    remaining intervals unallocated (so downstream passes will
    misbehave if they don't skip overflowed funcs), and -- once the
    module has been walked -- stamps a module-level
    `waveamdmachine.regalloc_overflowed_count = i64 N` summarising
    how many kernels overflowed.

    `vgpr-limit` / `sgpr-limit` override the per-class budget below
    the subtarget default; -1 keeps the target's number. Test-only
    knob (and a foot-gun in production: shrinking below what the
    pipeline needs guarantees overflow).
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
  let options = [
    Option<"markOverflow", "mark-overflow", "bool", /*default=*/"false",
           "Annotate overflowed funcs instead of failing the pass.">,
    Option<"vgprLimitOverride", "vgpr-limit", "int", /*default=*/"-1",
           "Cap VGPRs below the subtarget default; -1 means no cap.">,
    Option<"sgprLimitOverride", "sgpr-limit", "int", /*default=*/"-1",
           "Cap SGPRs below the subtarget default; -1 means no cap.">,
  ];
}

def WaveAMDResourceInfo
    : Pass<"waveamd-resource-info", "ModuleOp"> {
  let summary = "Annotate WaveAMDMachine functions with resource usage";
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDMetadata
    : Pass<"waveamd-metadata"> {
  let summary = "Attach AMDGPU metadata information to WaveAMDMachine IR";
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveSetTargetAttr
    : Pass<"wave-set-target-attr", "ModuleOp"> {
  let summary = "Stamp the AMDGPU target onto the module attribute the wave passes read";
  let description = [{
    Sets `waveamdmachine.target = "<triple>--<chip>"` on the operated-on
    module unless it already carries one. The wave-to-AMDGPU pipeline
    passes (decompose-mem-tuples, hazard-waits, ...) read this attribute
    to pick subtarget features. Tests / drivers invoke this once at the
    start of the pipeline so the downstream sequence stays target-agnostic.
  }];
  // Eagerly load every dialect a downstream pass in the compilation
  // library may pull in. `transform.apply_registered_pass` later
  // invokes those passes inside the multi-threaded execution context
  // the outer PassManager creates, where the MLIR registry refuses to
  // accept new dialect entries; pre-loading via this front pass turns
  // the inner registry merges into no-ops.
  let dependentDialects = [
    "LLVM::LLVMDialect",
    "ROCDL::ROCDLDialect",
    "arith::ArithDialect",
    "cf::ControlFlowDialect",
    "func::FuncDialect",
    "gpu::GPUDialect",
    "memref::MemRefDialect",
    "scf::SCFDialect",
    "wave::WaveDialect",
    "waveamd::WaveAMDDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
  let options = [
    Option<"chip", "chip", "std::string", /*default=*/"\"gfx1100\"",
           "AMDGPU chip identifier (e.g. gfx1100).">,
    Option<"triple", "triple", "std::string",
           /*default=*/"\"amdgcn-amd-amdhsa\"",
           "Target triple.">
  ];
}

def WaveCompileKernels
    : Pass<"wave-compile-kernels", "ModuleOp"> {
  let summary = "Compile wave kernels in `gpu.module` ops to in-place `gpu.binary`";
  let description = [{
    Walks `gpu.module` ops whose body contains at least one `func.func` with
    a `wave.kernel` attribute, drives the wave-to-AMDGPU backend in-memory to
    produce AMDGPU assembly, assembles it to an ELF object with the LLVM MC
    APIs, links the object to a HSACO blob using lld in-process, and replaces
    the source `gpu.module` with a `gpu.binary` of the same symbol carrying
    the result as a `#gpu.object<#rocdl.target, ...>` attribute.

    This is the in-tree analog of the
    `wave-translate | llvm-mc | ld.lld | wave-attach-gpu-binary` shell
    pipeline, but everything runs in-process so there are no
    user-visible filesystem intermediates.
  }];

  let dependentDialects = [
    "func::FuncDialect",
    "gpu::GPUDialect",
    "ROCDL::ROCDLDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];

  let options = [
    Option<"features", "features", "std::string", /*default=*/"\"\"",
           "Target features forwarded to the AMDGPU MC assembler.">
  ];
}

def WaveMetaSpecialize
    : Pass<"wavemeta-specialize", "ModuleOp"> {
  let summary = "Resolve wavemeta parameters and statically known control flow.";
  let description = [{
    Reads a module-scope `wavemeta.params = {name = value, ...}` dict
    attribute, binds matching `wavemeta.param` ops, then folds away
    `wavemeta.static_if` / `wavemeta.static_for` / `wavemeta.tuple_*`
    using a greedy rewriter. Surviving `!wavemeta.ptuple` types are
    expanded to scalar SSA values via dialect-conversion populators
    over `scf`, `func`, and `wavemeta` itself. Anything that still
    refers to a `wavemeta.*` op or `!wavemeta.ptuple` type after all
    that gets a diagnostic.
  }];
  let dependentDialects = [
    "arith::ArithDialect",
    "scf::SCFDialect"
  ];
  let options = [
    Option<"errorOnResidual", "error-on-residual", "bool",
           /*default=*/"true",
           "Fail the pass when any wavemeta.* op or !wavemeta.ptuple "
           "type remains after specialisation.">
  ];
}

def WaveAttachGPUBinary
    : Pass<"wave-attach-gpu-binary", "ModuleOp"> {
  let summary = "Embed a pre-compiled GPU binary as a `gpu.binary` op";
  let description = [{
    Reads a pre-compiled GPU binary (e.g. a HSACO produced by
    `wave-translate` + `llvm-mc` + `ld.lld`) and emits a top-level
    `gpu.binary @<symbol>` op carrying it as a `#gpu.object<..., bin = "...">`
    attribute. Use this pass to splice externally compiled kernels into a
    host MLIR module ahead of `gpu.launch_func` lowering, without going
    through the in-tree `gpu-module-to-binary` path.

    The pass takes the binary file path, the symbol name to mint, and the
    AMDGPU chip / target triple needed to construct the `#rocdl.target`
    attribute.
  }];

  let dependentDialects = [
    "gpu::GPUDialect",
    "ROCDL::ROCDLDialect"
  ];

  let options = [
    Option<"path", "path", "std::string", /*default=*/"\"\"",
           "Path to the pre-compiled GPU binary (e.g. HSACO).">,
    Option<"symbol", "symbol", "std::string", /*default=*/"\"wave_kernels\"",
           "Symbol name for the emitted `gpu.binary` op.">,
    Option<"chip", "chip", "std::string", /*default=*/"\"gfx1100\"",
           "AMDGPU chip identifier (e.g. gfx1100) for the `#rocdl.target`.">,
    Option<"triple", "triple", "std::string",
           /*default=*/"\"amdgcn-amd-amdhsa\"",
           "Target triple for the `#rocdl.target` attribute.">
  ];
}

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_PASSES_TD
