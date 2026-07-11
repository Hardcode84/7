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
    machine-like operations. Module-level `wavemeta.params` may remain as
    metadata, but selected functions must contain only supported boundary
    types and no residual `wavemeta.*` ops.
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
    Pairs same-block supported f32->f16 casts and scalar f16 fadd/fmul/fma
    trees, then materializes wave.pack leaves and wave.extract scalar users
    around packed vector<2xf16> operations.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "wave::WaveDialect"
  ];
}

def WaveDelayLoopCarriedPacks : Pass<"wave-delay-loop-carried-packs"> {
  let summary = "Delay loop-carried sub-dword packs until their first use";
  let description = [{
    Splits selected `scf.for` loop-carried `wave.pack` values into scalar
    sub-dword loop carries, then recreates the pack in the loop body and after
    the loop. This moves repacking off the back-edge for byte/half-byte scale
    load patterns whose yielded pack operands are memory-read results.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "scf::SCFDialect",
    "wave::WaveDialect",
    "waveamd::WaveAMDDialect"
  ];
}

def WaveCoalesceMemory : Pass<"wave-coalesce-memory"> {
  let summary = "Coalesce adjacent Wave memory ops into vector payloads";
  let description = [{
    Coalesces same-block Wave memory operations with compatible token chains
    and constant symbolic address deltas. Load and store coalescing start from
    scalar lane-varying ops and recursively merge equal-width adjacent groups
    into vector payload memory ops.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "wave::WaveDialect"
  ];
}

def WaveCoalesceWhere : Pass<"wave-coalesce-where"> {
  let summary = "Coalesce adjacent Wave where regions with the same mask";
  let description = [{
    Merges same-block, then-only `wave.where` regions with identical mask SSA
    values. Speculatable operations between the regions sink into the merged
    body when all uses remain inside it. Escaping dependency slices hoist
    before the first region unless they depend on its results. Result and
    memory-token order is preserved.
  }];
  let dependentDialects = [
    "wave::WaveDialect"
  ];
}

def WaveCombinePointerOffsets : Pass<"wave-combine-pointer-offsets"> {
  let summary = "Combine chained Wave pointer offsets into one symbolic offset";
  let description = [{
    Folds chained `wave.ptr_add` offsets into one `wave.index_expr` feeding a
    single `wave.ptr_add`, and composes `wave.index_expr` values used as
    bindings by other `wave.index_expr` ops.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "wave::WaveDialect"
  ];
}

def WaveGenerateIndexExprs : Pass<"wave-generate-index-exprs"> {
  let summary = "Generate Wave index expressions for pointer offset arithmetic";
  let description = [{
    Promotes supported no-signed-wrap `wave.binary` arithmetic in address
    contexts to `wave.index_expr`. The pass rewrites `wave.ptr_add` offsets and
    `wave.index_expr` bindings, leaving unrelated arithmetic in SSA form.
  }];
  let dependentDialects = [
    "wave::WaveDialect"
  ];
}

def WaveNormalizePointerOffsets : Pass<"wave-normalize-pointer-offsets"> {
  let summary = "Normalize Wave typed pointers to byte-addressed pointers";
  let description = [{
    Converts typed `!wave.ptr<#space, T>` values to opaque byte-addressed
    `!wave.ptr<#space>` values and scales `wave.ptr_add` offsets by the
    original element size. Downstream pointer-offset planning then sees byte
    offsets only.
  }];
  let dependentDialects = [
    "arith::ArithDialect",
    "func::FuncDialect",
    "scf::SCFDialect",
    "wave::WaveDialect",
    "waveamd::WaveAMDDialect"
  ];
}

def WaveCleanupAllocs : Pass<"wave-cleanup-allocs"> {
  let summary = "Remove writes to unread Wave allocations";
  let description = [{
    Follows allocation pointer aliases through views and region branch edges.
    If an allocation has no reads and no unknown pointer escapes, removes
    writes to that allocation and repairs memory-token users.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "scf::SCFDialect",
    "wave::WaveDialect",
    "waveamd::WaveAMDDialect"
  ];
}

def WaveResolveAllocs : Pass<"wave-resolve-allocs"> {
  let summary = "Resolve Wave allocations to shared memory base offsets";
  let description = [{
    Computes allocation live intervals, assigns non-overlapping byte offsets,
    rewrites `wave.alloc` to `wave.shared_memory_base`, and updates fixed
    function-level `wave.lds_size` to cover the assigned storage.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "scf::SCFDialect",
    "wave::WaveDialect"
  ];
}

def WaveSimplifyIndexExprs : Pass<"wave-simplify-index-exprs"> {
  let summary = "Simplify Wave index expressions with integer range facts";
  let description = [{
    Runs MLIR integer range analysis, converts proven binding ranges into
    ixsimpl assumptions, and rewrites `wave.index_expr` expressions and binding
    lists when analysis makes symbols redundant.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "wave::WaveDialect"
  ];
}

def WavePromoteGlobalToBuffer : Pass<"wave-promote-global-to-buffer"> {
  let summary = "Promote proven-small global Wave memory ops to AMD buffers";
  let description = [{
    Inserts `waveamd.make_buffer` for uniform global pointer roots, then
    rewrites Wave memory operands whose byte offset and access size are proven
    to fit the buffer descriptor range. Pointers whose offsets are not proven
    bounded stay global and keep the addr64 fallback available.
  }];
  let dependentDialects = [
    "arith::ArithDialect",
    "func::FuncDialect",
    "wave::WaveDialect",
    "waveamd::WaveAMDDialect"
  ];
}

def WaveAMDDmaZeroFill : Pass<"waveamd-dma-zero-fill"> {
  let summary = "Flatten zero-fillable predicated buffer DMA-to-LDS ops";
  let description = [{
    Rewrites `wave.where` regions whose side effects are only opt-in
    `waveamd.dma_load_lds` ops into straight-line DMA. Inactive lanes route
    through a same-buffer out-of-bounds source offset, relying on buffer OOB
    zero-fill instead of EXEC masking. Regions with non-DMA side effects or
    non-buffer DMA sources are left untouched.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "wave::WaveDialect",
    "waveamd::WaveAMDDialect"
  ];
}

def WaveExtractLoopStrides : Pass<"wave-extract-loop-strides"> {
  let summary = "Expose IV-linear Wave pointer offsets as loop-carried strides";
  let description = [{
    Rewrites loop-local `wave.ptr_add(base, wave.index_expr(... iv ...))`
    address formation into a pointer iter_arg when ixsimpl proves the
    per-iteration stride `expr(iv + step) - expr(iv)` no longer depends on the
    loop IV. Machine lowering can then choose SGPR base carries, buffer soffset
    marching, or fallback from the ordinary carried-pointer form.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "scf::SCFDialect",
    "wave::WaveDialect"
  ];
}

def WaveStrengthReduceModulo : Pass<"wave-strength-reduce-modulo"> {
  let summary = "Strength-reduce constant-modulo SCF inductions";
  let description = [{
    Carries residues for SCF induction variables modulo positive constants.
    Constant-offset residues derive from the same carry.
  }];
  let dependentDialects = [
    "arith::ArithDialect",
    "scf::SCFDialect",
    "wave::WaveDialect"
  ];
}

def WaveExpandIntegerDivRem : Pass<"wave-expand-integer-div-rem"> {
  let summary = "Expand Wave integer div/rem into primitive integer ops";
  let description = [{
    Rewrites `wave.binary` div/rem operations into Wave integer primitives
    before machine selection. Constant unsigned divisors use magic-number
    quotient formation; proven dynamic power-of-two divisors use CTZ plus
    shifts/masks; dynamic i32 divisors use reciprocal refinement. Signed
    operations divide magnitudes and repair quotient/remainder signs.
  }];
  let dependentDialects = [
    "arith::ArithDialect",
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
  let summary = "Insert WaveAMDMachine hazard mitigation instructions";
  let description = [{
    Inserts target hazard mitigation (`s_nop` / `s_delay_alu`) over
    WaveAMDMachine IR. Intended placement is after ABI lowering,
    register allocation, and post-regalloc ticket-wait insertion. Ticket
    waits materialize the `s_waitcnt` producers this pass reacts to, and
    regalloc preparation may introduce VALU copies that must also be checked.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDHazardRepair
    : Pass<"waveamd-hazard-repair"> {
  let summary = "Move VALU/SALU fillers into local hazard gaps";
  let description = [{
    Runs before model scheduling. Scans each block and moves pure VALU/SALU ops
    into hazard gaps when SSA dominance holds and the move does not introduce a
    new or larger hazard elsewhere in the block. Fillers with singleton
    operands or live singleton results are left in place. A non-loop,
    non-isolated region may pull a dominating outer operand producer when all
    result users remain in that region, or hoist an M0 writer when its entry
    instruction supplies the missing hazard slot.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
  let options = [
    Option<"hoistM0AcrossRegions", "hoist-m0-across-regions", "bool",
           /*default=*/"true",
           "Hoist M0 writers across eligible region entries.">
  ];
}

def WaveAMDDecomposeMemTuples
    : Pass<"waveamd-decompose-mem-tuples"> {
  let summary = "Decompose tuple memory ops into wide chunk memory ops";
  let description = [{
    Each `*_load_tuple_b32` becomes widest-supported b32/b64/b96/b128
    chunks, gathered via `tuple_from_elements` (data) and `token_join`
    (token). Stores split through `tuple_to_elements` and emit the same
    chunk plan. After this pass no `*_tuple_b32` mem ops remain. Runs
    before waitcnt insertion so chunk-level tokens are visible.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDPairDsOps
    : Pass<"waveamd-pair-ds-ops"> {
  let summary = "Pair eligible WaveAMDMachine LDS b32/b64 DS ops";
  let description = [{
    Forms `ds_load2_*` / `ds_store2_*` for same-block b32/b64 LDS ops with
    the same address and explicit token ordering. Direct token chains become a
    single op at the earlier load or later store. Independent ops with the same
    input token are paired only when their result tokens flow to the same final
    consumer, including through RegionBranchOpInterface terminators.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDPackVGPRZeroMoves
    : Pass<"waveamd-pack-vgpr-zero-moves"> {
  let summary = "Pack VGPR moves into v_mov_b64 chunks";
  let description = [{
    Packs virtual adjacent zero fills so scheduling sees allocation copy work.
    Erases same-physical allocated `v_mov_b32_tuple` copies, rewrites allocated
    `v_mov_b32_tuple` zero fills into aligned
    `v_mov_b64_tuple` chunks plus scalar head/tail moves, and packs adjacent
    scalar VGPR copies with contiguous source and destination pairs.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDFormFusedInt
    : Pass<"waveamd-form-fused-int"> {
  let summary = "Form fused integer WaveAMDMachine VALU ops";
  let description = [{
    Function-local greedy peephole over selected WaveAMDMachine integer ops.
    The pass only rewrites same-block single-use producer/consumer chains into
    first-class target-supported fused ops, preserving memory tokens and
    hardware flag SSA by construction.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDCrossLanePeepholes
    : Pass<"waveamd-cross-lane-peepholes"> {
  let summary = "Form cheaper WaveAMDMachine cross-lane ops";
  let description = [{
    Function-local peepholes over selected WaveAMDMachine cross-lane ops.
    Rewrites recognized dynamic lane-address arithmetic into cheaper
    target-supported lane movement instructions while preserving waitcnt class.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDElideSCCBoolRoundtrip
    : Pass<"waveamd-elide-scc-bool-roundtrip"> {
  let summary = "Elide redundant SCC to bool to SCC roundtrips";
  let description = [{
    Rewrites `s_cmp_lg_u32(s_cselect_b32(scc, 1, 0), 0)` back to the
    original SCC. Intended placement is before `waveamd-preserve-hw-regs`,
    which will reinsert save/reload code only where a real SCC clobber exists.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDMachineCleanup
    : Pass<"waveamd-machine-cleanup"> {
  let summary = "Hoist redundant WaveAMDMachine prep before scheduling";
  let description = [{
    Hoists speculatable, memory-effect-free WaveAMDMachine prep ops out of
    structured EXEC regions when operands are available before the region and
    non-yield users remain inside it. EXEC, M0, and live SCC/VCC users stay in
    place.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDHoistTuples
    : Pass<"waveamd-hoist-tuples"> {
  let summary = "Hoist invariant tuple-like dwords out of machine loops";
  let description = [{
    Promotes loop-local `waveamdmachine.tuple_from_elements` ops when some tuple
    slots are loop-carried and some are invariant. The pass hoists an
    initializer tuple and carries it through the loop, using
    `waveamdmachine.update_tuple` for the loop-carried slots.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDLateTuples
    : Pass<"waveamd-late-tuples"> {
  let summary = "Sink WaveAMDMachine tuple aliases after scheduling";
  let description = [{
    Moves `tuple_to_elements` and `tuple_from_elements` to the latest same-block
    position that still dominates all tuple users.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDBufferRsrcToTuples
    : Pass<"waveamd-buffer-rsrc-to-tuples"> {
  let summary = "Convert buffer descriptor pseudo ops to tuple aliases";
  let description = [{
    Converts `waveamdmachine.make_buffer_rsrc` into SGPR tuple construction and
    `waveamdmachine.update_buffer_rsrc_base` into `waveamdmachine.update_tuple`.
    Selection still emits descriptor-shaped pseudo ops; later passes only see
    generic tuple manipulation.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDNarrowWideInt
    : Pass<"waveamd-narrow-wide-int"> {
  let summary = "Narrow proven 32-bit addends in wide WaveAMDMachine ops";
  let description = [{
    Rewrites selected wide integer Machine IR operations when local structure
    or integer range analysis proves one operand is zero-extended from 32 bits.
    This preserves arithmetic semantics while avoiding unnecessary two-dword
    offset tuples before register allocation.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDTicketWaits
    : Pass<"waveamd-insert-ticket-waits"> {
  let summary = "Insert WaveAMDMachine waitcnt instructions using ticket scoreboards";
  let description = [{
    Tracks async memory operations with per-counter tickets and inserts the
    minimum waitcnt threshold required by SSA uses. This is the waitcnt pass
    intended for the staged WaveAMDMachine backend; the default pipeline runs
    it after register allocation and memory-tuple decomposition. Pipeline
    hazards remain a separate concern. Terminal drains use `s_endpgm`'s
    implicit wait; VGPR-limited targets can release VGPRs while non-scratch
    stores finish.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDPreserveHardwareRegs
    : Pass<"waveamd-preserve-hw-regs"> {
  let summary = "Preserve singleton WaveAMDMachine hardware registers";
  let description = [{
    Inserts save/reload code when SCC, VCC, or M0 values are live across a
    clobber of the same singleton hardware resource. Unsupported cases are
    left for post-regalloc consumers to reject as the final correctness gate.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDMMAReusePreschedule
    : Pass<"waveamd-mma-reuse-preschedule"> {
  let summary = "Pre-schedule contiguous MMA runs for operand reuse";
  let description = [{
    Reorders contiguous same-block MMA operation runs before model scheduling.
    The first MMA in each run stays fixed. Each later position chooses the
    ready remaining MMA with the most distinct register SSA operands reused
    from the previously chosen MMA, using original order as the tie-breaker.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDScalarMaskPreschedule
    : Pass<"waveamd-scalar-mask-preschedule"> {
  let summary = "Prepare single-use scalar masks for scheduling";
  let description = [{
    Sinks SCC/VCC compare chains to their sole consumer before hazard repair and
    model scheduling. Single-use compare masks feed `exec_if` directly through
    VCC when no live VCC write crosses the mask. Register allocation then sees
    the repaired schedule.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDSplitBarriers
    : Pass<"waveamd-split-barriers"> {
  let summary = "Split eligible WaveAMDMachine barriers";
  let description = [{
    Rewrites eligible `waveamdmachine.s_barrier` ops in functions marked with
    `waveamdmachine.enable_split_barriers` into
    `barrier_init` / `barrier_arrive` / `barrier_wait` pseudos so scheduling
    can move independent work between arrive and wait.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDMaterializeSplitBarriers
    : Pass<"waveamd-materialize-split-barriers"> {
  let summary = "Lower WaveAMDMachine split barriers to LDS atomics";
  let description = [{
    Lowers split-barrier pseudos to LDS counter init, returning arrive atomics,
    and wait-side poll loops. Updates LDS accounting and shifts existing
    dynamic LDS addresses when barrier state is reserved as a prefix.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDMachineSchedule
    : Pass<"waveamd-machine-schedule"> {
  let summary = "Apply greedy gap-fill WaveAMDMachine scheduling";
  let description = [{
    Scheduler pass over `waveamdmachine` IR. The default mode is a no-op that
    still validates target and model options. With `apply-schedule`, it scans
    straight-line machine regions, uses original order as its baseline, and
    moves legal zero-stall ready instructions into modeled gaps until the
    blocked op no longer stalls or no filler remains.

    Pure work between redundant full barriers moves before the pair so barrier
    cleanup can merge it without draining memory early.

    VMEM loads move to their latest profitable issue point before first data
    use. The event model supplies value latency; movement preserves SSA,
    explicit token edges, and VMEM issue order.

    Within contiguous side-effect-free compute islands, ready instructions on
    multi-cycle resources start early and independent instructions on other
    resources fill their release slots. Resource occupancy comes from the
    target scheduling model, and register-pressure growth disables this policy
    for the affected region.

    Intended placement is before ticket-wait and hazard-wait insertion. Nested
    region ops split local scheduling regions; block terminators finish the
    block and are not scheduled. Only scheduler-supported WaveAMDMachine ops may
    appear inside a local region; any other op is a hard error.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
  let options = [
    Option<"applySchedule", "apply-schedule", "bool", /*default=*/"false",
           "Apply greedy local schedules.">,
    Option<"requireSelectedInput", "require-selected-input", "bool", /*default=*/"false",
           "Only schedule functions stamped by waveamd-to-machine.">,
    Option<"maxRegionOps", "max-region-ops", "int", /*default=*/"-1",
           "Skip scheduling regions above this op count; -1 disables the cap.">
  ];
}

def WaveAMDPrepareRegAlloc
    : Pass<"waveamd-prepare-regalloc"> {
  let summary = "Expose register-allocation copies in WaveAMDMachine IR";
  let description = [{
    Materializes copies required by tuple aliases, loop carries, destructive
    operands, and region yields before hazard repair and allocation.
  }];
  let dependentDialects = [
    "func::FuncDialect",
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDBarrierCleanup
    : Pass<"waveamd-barrier-cleanup"> {
  let summary = "Remove redundant WaveAMDMachine barriers";
  let description = [{
    Removes redundant machine barriers while preserving explicit memory-token
    ordering.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDMachineScheduleReport
    : Pass<"waveamd-machine-schedule-report"> {
  let summary = "Print WaveAMDMachine scheduler diagnostics";
  let description = [{
    Non-mutating diagnostics pass for the greedy gap-fill scheduler. It shares
    region discovery, dependence construction, stall modeling, greedy order
    construction, and instruction-state scoring with `waveamd-machine-schedule`.

    Functions may override the region cap with integer attribute
    `waveamdmachine.schedule_max_region_ops`; `-1` disables that cap.
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
           "Print instruction-state scores for local scheduling regions.">,
    Option<"printCandidates", "print-candidates", "bool", /*default=*/"false",
           "Print model-scored scheduler candidate orders to stderr.">,
    Option<"printClasses", "print-classes", "bool", /*default=*/"false",
           "Print scheduler class, functional unit, latency, and resource cycles for each local-region op.">,
    Option<"maxRegionOps", "max-region-ops", "int", /*default=*/"-1",
           "Skip scheduling diagnostics above this region op count; -1 disables the cap.">,
    Option<"scoreFunc", "score-func", "std::string", /*default=*/"\"\"",
           "Function name whose local region should score a candidate order.">,
    Option<"scoreRegion", "score-region", "int", /*default=*/"-1",
           "Local region ordinal for score-order; -1 disables candidate scoring.">,
    Option<"scoreOrder", "score-order", "std::string", /*default=*/"\"\"",
           "Comma-separated op indices for a candidate local-region order.">
  ];
}

def WaveAMDClearRegAllocAssignments
    : Pass<"waveamd-clear-regalloc-assignments", "ModuleOp"> {
  let summary = "Clear stale WaveAMDMachine physical register assignments";
  let description = [{
    Clears physical register indices written by earlier regalloc state. ABI and
    user-pinned fixed registers are left intact.
  }];
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}


def WaveAMDResourceInfo
    : Pass<"waveamd-resource-info", "ModuleOp"> {
  let summary = "Annotate WaveAMDMachine functions with resource usage";
  let dependentDialects = [
    "waveamdmachine::WaveAMDMachineDialect"
  ];
}

def WaveAMDVerifyMachineOperands
    : Pass<"waveamd-verify-machine-operands", "ModuleOp"> {
  let summary = "Verify target-specific WaveAMDMachine operand legality";
  let description = [{
    Checks final WaveAMDMachine operand forms before metadata and assembly
    emission. The pass uses the same instruction-info helpers as the AMDGPU
    target emitter for constant-bus use, literal placement, and VGPR operand
    requirements.
  }];
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
