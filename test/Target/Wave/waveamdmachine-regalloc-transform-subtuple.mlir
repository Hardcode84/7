// RUN: wave-opt %s --waveamd-prepare-regalloc | FileCheck %s --check-prefix=PREP
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s --check-prefix=SCAN

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // PREP-LABEL: func.func @erase_reg_after(
  // PREP-NOT: waveamdmachine.reg_after
  // PREP: return [[SOURCE:%[^ :]+]]
  func.func @erase_reg_after(
      %source: !waveamdmachine.reg<sgpr, 2>,
      %dep: !waveamdmachine.mem.token) -> !waveamdmachine.reg<sgpr, 2> {
    %result = waveamdmachine.reg_after %source after %dep
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> !waveamdmachine.reg<sgpr, 2>
    return %result : !waveamdmachine.reg<sgpr, 2>
  }

  // PREP-LABEL: func.func @aligned_width2_halves(
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: return
  // SCAN-LABEL: func.func @aligned_width2_halves(
  // SCAN-SAME: [[SRC:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[#BASE:]]>
  // SCAN: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements [[SRC]]
  // SCAN-SAME: !waveamdmachine.reg<vgpr, 1, [[#BASE+2]]>
  // SCAN: [[LO:%.*]] = waveamdmachine.tuple_from_elements [[PARTS]]#0, [[PARTS]]#1
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE]]>
  // SCAN: [[HI:%.*]] = waveamdmachine.tuple_from_elements [[PARTS]]#2, [[PARTS]]#3
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>
  // SCAN: return [[LO]], [[HI]]
  func.func @aligned_width2_halves(%src: !waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %lo = waveamdmachine.tuple_from_elements %parts#0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %hi = waveamdmachine.tuple_from_elements %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    return %lo, %hi
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>
  }

  // PREP-LABEL: func.func @reused_aligned_view(
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: return
  // SCAN-LABEL: func.func @reused_aligned_view(
  // SCAN-SAME: [[SRC:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[#BASE:]]>
  // SCAN: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements [[SRC]]
  // SCAN: [[VIEW0:%.*]] = waveamdmachine.tuple_from_elements [[PARTS]]#2, [[PARTS]]#3
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>
  // SCAN: [[VIEW1:%.*]] = waveamdmachine.tuple_from_elements [[PARTS]]#2, [[PARTS]]#3
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>
  // SCAN: return [[VIEW0]], [[VIEW1]]
  func.func @reused_aligned_view(%src: !waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %view0 = waveamdmachine.tuple_from_elements %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %view1 = waveamdmachine.tuple_from_elements %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    return %view0, %view1
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>
  }

  // PREP-LABEL: func.func @fixed_aligned_view(
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: return
  // SCAN-LABEL: func.func @fixed_aligned_view(
  // SCAN: [[VIEW:%.*]] = waveamdmachine.tuple_from_elements
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, 10>
  func.func @fixed_aligned_view(%src: !waveamdmachine.reg<vgpr, 4, 8>)
      -> !waveamdmachine.reg<vgpr, 2> {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4, 8>)
          -> (!waveamdmachine.reg<vgpr, 1, 8>,
              !waveamdmachine.reg<vgpr, 1, 9>,
              !waveamdmachine.reg<vgpr, 1, 10>,
              !waveamdmachine.reg<vgpr, 1, 11>)
    %view = waveamdmachine.tuple_from_elements %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1, 10>,
           !waveamdmachine.reg<vgpr, 1, 11>)
          -> !waveamdmachine.reg<vgpr, 2>
    return %view : !waveamdmachine.reg<vgpr, 2>
  }

  // PREP-LABEL: func.func @fixed_view_conflict(
  // PREP: [[COPY0:%.*]] = waveamdmachine.copy_tuple
  // PREP: [[COPY1:%.*]] = waveamdmachine.copy_tuple
  // PREP: waveamdmachine.tuple_from_elements [[COPY0]], [[COPY1]]
  func.func @fixed_view_conflict(%src: !waveamdmachine.reg<vgpr, 4, 8>)
      -> !waveamdmachine.reg<vgpr, 2, 12> {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4, 8>)
          -> (!waveamdmachine.reg<vgpr, 1, 8>,
              !waveamdmachine.reg<vgpr, 1, 9>,
              !waveamdmachine.reg<vgpr, 1, 10>,
              !waveamdmachine.reg<vgpr, 1, 11>)
    %view = waveamdmachine.tuple_from_elements %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1, 10>,
           !waveamdmachine.reg<vgpr, 1, 11>)
          -> !waveamdmachine.reg<vgpr, 2, 12>
    return %view : !waveamdmachine.reg<vgpr, 2, 12>
  }

  // PREP-LABEL: func.func @aligned_view_loop_carry(
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: return
  // SCAN-LABEL: func.func @aligned_view_loop_carry(
  // SCAN-SAME: [[SRC:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[#BASE:]]>
  // SCAN: [[VIEW:%.*]] = waveamdmachine.tuple_from_elements
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>
  // SCAN: waveamdmachine.uniform_loop
  // SCAN-SAME: carries([[VIEW]] : !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>)
  // SCAN: ^bb0([[CARRY:%[^:]+]]: !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>):
  func.func @aligned_view_loop_carry(
      %src: !waveamdmachine.reg<vgpr, 4>,
      %cond: !waveamdmachine.reg<scc, 1>) -> !waveamdmachine.reg<vgpr, 2> {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %view = waveamdmachine.tuple_from_elements %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%view : !waveamdmachine.reg<vgpr, 2>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 2>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 2>)
    } -> !waveamdmachine.reg<vgpr, 2>
    return %loop : !waveamdmachine.reg<vgpr, 2>
  }

  // A loop init that is also read as an invariant in the body needs separate
  // writable carry storage.
  // PREP-LABEL: func.func @tuple_loop_init_with_invariant_use(
  // PREP: [[VIEW:%.*]] = waveamdmachine.tuple_from_elements
  // PREP: [[INIT:%.*]] = waveamdmachine.copy_tuple [[VIEW]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[INIT]]
  // PREP: waveamdmachine.v_mov_b32_tuple [[VIEW]]
  // SCAN-LABEL: func.func @tuple_loop_init_with_invariant_use(
  // SCAN-SAME: [[SRC:%[^:]+]]: !waveamdmachine.reg<vgpr, 2, [[#BASE:]]>
  // SCAN: [[VIEW:%.*]] = waveamdmachine.tuple_from_elements
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE]]>
  // SCAN: [[INIT:%.*]] = waveamdmachine.copy_tuple [[VIEW]]
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>
  // SCAN: waveamdmachine.uniform_loop
  // SCAN-SAME: carries([[INIT]] : !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>)
  // SCAN: ^bb0([[CARRY:%[^:]+]]: !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>):
  // SCAN: waveamdmachine.v_mov_b32_tuple [[VIEW]]
  // SCAN: waveamdmachine.v_mov_b32_tuple [[CARRY]]
  func.func @tuple_loop_init_with_invariant_use(
      %src: !waveamdmachine.reg<vgpr, 2>,
      %cond: !waveamdmachine.reg<scc, 1>) -> !waveamdmachine.reg<vgpr, 2> {
    %parts:2 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>)
    %view = waveamdmachine.tuple_from_elements %parts#0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%view : !waveamdmachine.reg<vgpr, 2>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 2>):
      %invariant = waveamdmachine.v_mov_b32_tuple %view {registers = 2 : i64}
          : (!waveamdmachine.reg<vgpr, 2>)
            -> !waveamdmachine.reg<vgpr, 2>
      %next = waveamdmachine.v_mov_b32_tuple %carry {registers = 2 : i64}
          : (!waveamdmachine.reg<vgpr, 2>)
            -> !waveamdmachine.reg<vgpr, 2>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%next : !waveamdmachine.reg<vgpr, 2>)
    } -> !waveamdmachine.reg<vgpr, 2>
    return %loop : !waveamdmachine.reg<vgpr, 2>
  }

  // CSE may share scalar zero with post-loop math; carry storage stays distinct.
  // PREP-LABEL: func.func @loop_init_with_post_loop_use(
  // PREP: [[INIT:%.*]] = waveamdmachine.s_mov_b32_value
  // PREP-NEXT: [[CARRY:%.*]] = waveamdmachine.copy_tuple [[INIT]]
  // PREP-NEXT: [[LOOP:%.*]] = waveamdmachine.uniform_loop
  // PREP-SAME: carries([[CARRY]]
  // PREP: [[POST:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[INIT]],
  // SCAN-LABEL: func.func @loop_init_with_post_loop_use(
  // SCAN: [[INIT:%.*]] = waveamdmachine.s_mov_b32_value
  // SCAN-SAME: -> !waveamdmachine.reg<sgpr, 1, [[#INIT_REG:]]>
  // SCAN-NEXT: [[CARRY:%.*]] = waveamdmachine.copy_tuple [[INIT]]
  // SCAN-SAME: -> !waveamdmachine.reg<sgpr, 1, [[#INIT_REG+1]]>
  // SCAN-NEXT: [[LOOP:%.*]] = waveamdmachine.uniform_loop
  // SCAN-SAME: carries([[CARRY]] : !waveamdmachine.reg<sgpr, 1, [[#INIT_REG+1]]>)
  // SCAN: [[POST:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[INIT]],
  // SCAN-SAME: !waveamdmachine.reg<sgpr, 1, [[#INIT_REG]]>
  func.func @loop_init_with_post_loop_use(
      %cond: !waveamdmachine.reg<scc, 1>)
      -> !waveamdmachine.reg<sgpr, 1> {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %init = waveamdmachine.s_mov_b32_value %zero
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%init : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %next, %scc = waveamdmachine.s_add_i32 %carry, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<scc, 1>)
      waveamdmachine.continue_if %cond
          : !waveamdmachine.reg<scc, 1>
          carries(%next : !waveamdmachine.reg<sgpr, 1>)
    } -> !waveamdmachine.reg<sgpr, 1>
    %post, %post_scc = waveamdmachine.s_add_i32 %init, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<scc, 1>)
    return %post : !waveamdmachine.reg<sgpr, 1>
  }

  // Forwarding an init unchanged is not an invariant body read.
  // PREP-LABEL: func.func @loop_init_passthrough(
  // PREP-SAME: [[SRC:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: waveamdmachine.continue_if
  // PREP-SAME: carries([[SRC]]
  // PREP: return
  // SCAN-LABEL: func.func @loop_init_passthrough(
  // SCAN-NOT: waveamdmachine.copy_tuple
  // SCAN: return
  func.func @loop_init_passthrough(
      %src: !waveamdmachine.reg<vgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>) -> !waveamdmachine.reg<vgpr, 1> {
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%src : !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 1>):
      %use = waveamdmachine.v_mov_b32_tuple %carry {registers = 1 : i64}
          : (!waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%src : !waveamdmachine.reg<vgpr, 1>)
    } -> !waveamdmachine.reg<vgpr, 1>
    return %loop : !waveamdmachine.reg<vgpr, 1>
  }

  // PREP-LABEL: func.func @loop_clobbering_live_parent_copies(
  // PREP: [[COPY0:%.*]] = waveamdmachine.copy_tuple
  // PREP: [[COPY1:%.*]] = waveamdmachine.copy_tuple
  // PREP: waveamdmachine.tuple_from_elements [[COPY0]], [[COPY1]]
  func.func @loop_clobbering_live_parent_copies(
      %src: !waveamdmachine.reg<vgpr, 4>,
      %cond: !waveamdmachine.reg<scc, 1>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 4>) {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %view = waveamdmachine.tuple_from_elements %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%view : !waveamdmachine.reg<vgpr, 2>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 2>):
      %next = waveamdmachine.v_mov_b32_tuple %carry {registers = 2 : i64}
          : (!waveamdmachine.reg<vgpr, 2>)
            -> !waveamdmachine.reg<vgpr, 2>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%next : !waveamdmachine.reg<vgpr, 2>)
    } -> !waveamdmachine.reg<vgpr, 2>
    %whole = waveamdmachine.v_mov_b32_tuple %src {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return %loop, %whole
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 4>
  }

  // Required reuse cannot clobber a live element borrowed by a packed tuple.
  // PREP-LABEL: func.func @required_reuse_packed_tuple_copies_live_element(
  // PREP-SAME: [[LIVE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
  // PREP-SAME: [[LOCAL:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
  // PREP: [[COPY:%.*]] = waveamdmachine.copy_tuple [[LIVE]]
  // PREP-NEXT: [[PACKED:%.*]] = waveamdmachine.tuple_from_elements [[COPY]], [[LOCAL]]
  // PREP-NEXT: [[SWAPPED:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[PACKED]]
  // PREP-NEXT: [[USE:%.*]] = waveamdmachine.v_mov_b32_tuple [[LIVE]]
  // PREP: return [[SWAPPED]], [[USE]]
  // SCAN-LABEL: func.func @required_reuse_packed_tuple_copies_live_element(
  // SCAN: [[COPY:%.*]] = waveamdmachine.copy_tuple
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 1, [[#BASE:]]>
  // SCAN-NEXT: [[PACKED:%.*]] = waveamdmachine.tuple_from_elements [[COPY]],
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE]]>
  // SCAN-NEXT: [[SWAPPED:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[PACKED]]
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE]]>
  func.func @required_reuse_packed_tuple_copies_live_element(
      %live: !waveamdmachine.reg<vgpr, 1>,
      %local: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>) {
    %packed = waveamdmachine.tuple_from_elements %live, %local
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %swapped = waveamdmachine.v_permlane32_swap_b32_tuple %packed
        : (!waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %use = waveamdmachine.v_mov_b32_tuple %live {registers = 1 : i64}
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return %swapped, %use
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  }

  // Multi-use required input gets private storage before destructive reuse.
  // PREP-LABEL: func.func @required_reuse_copies_shared_tuple(
  // PREP: [[SOURCE:%.*]] = waveamdmachine.tuple_from_elements
  // PREP-NEXT: [[COPY:%.*]] = waveamdmachine.copy_tuple [[SOURCE]]
  // PREP-NEXT: [[SWAPPED:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[COPY]]
  // PREP-NEXT: [[USE:%.*]] = waveamdmachine.v_mov_b32_tuple [[SOURCE]]
  // SCAN-LABEL: func.func @required_reuse_copies_shared_tuple(
  // SCAN: [[COPY:%.*]] = waveamdmachine.copy_tuple
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE:]]>
  // SCAN-NEXT: [[SWAPPED:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[COPY]]
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE]]>
  func.func @required_reuse_copies_shared_tuple(
      %lo: !waveamdmachine.reg<vgpr, 1>,
      %hi: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) {
    %source = waveamdmachine.tuple_from_elements %lo, %hi
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %swapped = waveamdmachine.v_permlane32_swap_b32_tuple %source
        : (!waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %use = waveamdmachine.v_mov_b32_tuple %source {registers = 2 : i64}
        : (!waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    return %swapped, %use
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>
  }

  // Inner carry storage cannot borrow an outer invariant live after the loop.
  // PREP-LABEL: func.func @nested_packed_loop_init_copies_live_element(
  // PREP: [[ZERO:%.*]] = waveamdmachine.imm 0
  // PREP: [[LIVE:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP: waveamdmachine.uniform_loop
  // PREP: [[FRESH:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP-NEXT: [[LOCAL:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP-NEXT: [[PACKED:%.*]] = waveamdmachine.tuple_from_elements [[LOCAL]], [[FRESH]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[PACKED]]
  // PREP: waveamdmachine.v_mov_b32_tuple [[LIVE]]
  func.func @nested_packed_loop_init_copies_live_element(
      %outer_cond: !waveamdmachine.reg<scc, 1>,
      %inner_cond: !waveamdmachine.reg<scc, 1>) {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %live = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.uniform_loop if %outer_cond
        : !waveamdmachine.reg<scc, 1> {
    ^bb0:
      %fresh = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %packed = waveamdmachine.tuple_from_elements %live, %fresh
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 2>
      %inner = waveamdmachine.uniform_loop if %inner_cond
          : !waveamdmachine.reg<scc, 1>
          carries(%packed : !waveamdmachine.reg<vgpr, 2>) {
      ^bb0(%carry: !waveamdmachine.reg<vgpr, 2>):
        waveamdmachine.continue_if %inner_cond
            : !waveamdmachine.reg<scc, 1>
            carries(%carry : !waveamdmachine.reg<vgpr, 2>)
      } -> !waveamdmachine.reg<vgpr, 2>
      %read = waveamdmachine.v_mov_b32_tuple %live {registers = 1 : i64}
          : (!waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.continue_if %outer_cond
          : !waveamdmachine.reg<scc, 1>
    }
    return
  }

  // PREP-LABEL: func.func @rematerialize_profitable_duplicate_loop_inits(
  // PREP: [[ZERO:%.*]] = waveamdmachine.imm 0
  // PREP: [[ONE:%.*]] = waveamdmachine.imm 1
  // PREP: [[LO0:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP: [[LO1:%.*]] = waveamdmachine.v_mov_b32_tuple [[ONE]]
  // PREP: [[INIT:%.*]] = waveamdmachine.tuple_from_elements [[LO0]], [[LO1]]
  // PREP: [[DUP0:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP: [[DUP1:%.*]] = waveamdmachine.v_mov_b32_tuple [[ONE]]
  // PREP: [[DUP:%.*]] = waveamdmachine.tuple_from_elements [[DUP0]], [[DUP1]]
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[INIT]], [[DUP]]
  func.func @rematerialize_profitable_duplicate_loop_inits(
      %cond: !waveamdmachine.reg<scc, 1>) {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %lo0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %lo1 = waveamdmachine.v_mov_b32_tuple %one {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %init = waveamdmachine.tuple_from_elements %lo0, %lo1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %loop:2 = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%init, %init : !waveamdmachine.reg<vgpr, 2>,
                !waveamdmachine.reg<vgpr, 2>) {
    ^bb0(%lhs: !waveamdmachine.reg<vgpr, 2>,
         %rhs: !waveamdmachine.reg<vgpr, 2>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%lhs, %rhs : !waveamdmachine.reg<vgpr, 2>,
                  !waveamdmachine.reg<vgpr, 2>)
    } -> !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>
    return
  }

  // PREP-LABEL: func.func @copy_expensive_duplicate_loop_inits(
  // PREP: [[ZERO:%.*]] = waveamdmachine.imm 0
  // PREP: [[ONE:%.*]] = waveamdmachine.imm 1
  // PREP: [[BASE:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP: [[INIT:%.*]] = waveamdmachine.v_add_u32 [[BASE]], [[ONE]]
  // PREP-NOT: waveamdmachine.v_add_u32
  // PREP: [[COPY:%.*]] = waveamdmachine.copy_tuple [[INIT]]
  // PREP-NOT: waveamdmachine.v_add_u32
  // PREP: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[INIT]], [[COPY]]
  func.func @copy_expensive_duplicate_loop_inits(
      %cond: !waveamdmachine.reg<scc, 1>) {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %base = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %init = waveamdmachine.v_add_u32 %base, %one
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %loop:2 = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%init, %init : !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%lhs: !waveamdmachine.reg<vgpr, 1>,
         %rhs: !waveamdmachine.reg<vgpr, 1>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%lhs, %rhs : !waveamdmachine.reg<vgpr, 1>,
                  !waveamdmachine.reg<vgpr, 1>)
    } -> !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>
    return
  }

  // PREP-LABEL: func.func @copy_hardware_resource_loop_inits(
  // PREP: {{%.*}}, [[VCC:%.*]] = waveamdmachine.v_add_u32_vcc
  // PREP: [[SELECTED:%.*]] = waveamdmachine.v_cndmask_b32_vcc {{.*}}, [[VCC]]
  // PREP-NOT: waveamdmachine.v_cndmask_b32_vcc
  // PREP: [[COPY:%.*]] = waveamdmachine.copy_tuple [[SELECTED]]
  // PREP: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[SELECTED]], [[COPY]]
  func.func @copy_hardware_resource_loop_inits(
      %lhs: !waveamdmachine.reg<vgpr, 1>,
      %rhs: !waveamdmachine.reg<vgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>) {
    %sum, %vcc = waveamdmachine.v_add_u32_vcc %lhs, %rhs
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
    %selected = waveamdmachine.v_cndmask_b32_vcc %lhs, %sum, %vcc
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %loop:2 = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%selected, %selected : !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%lhs_iter: !waveamdmachine.reg<vgpr, 1>,
         %rhs_iter: !waveamdmachine.reg<vgpr, 1>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%lhs_iter, %rhs_iter : !waveamdmachine.reg<vgpr, 1>,
                  !waveamdmachine.reg<vgpr, 1>)
    } -> !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>
    return
  }

  // PREP-LABEL: func.func @rematerialize_shared_mfma_accumulators(
  // PREP: [[ZERO:%.*]] = waveamdmachine.imm 0
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: [[ACC0:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP-NEXT: [[MMA0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, [[ACC0]]
  // PREP: [[ACC1:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP-NEXT: [[MMA1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, [[ACC1]]
  func.func @rematerialize_shared_mfma_accumulators()
      -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>) {
    %lhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
    %rhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %init = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %mma0 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs, %rhs, %init
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %mma1 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs, %rhs, %init
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return %mma0, %mma1
        : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>
  }

  // PREP-LABEL: func.func @copy_expensive_shared_mfma_accumulator(
  // PREP: [[ZERO:%.*]] = waveamdmachine.imm 0
  // PREP: [[BASE:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP: [[INIT:%.*]] = waveamdmachine.v_mov_b32_tuple [[BASE]]
  // PREP-NOT: waveamdmachine.v_mov_b32_tuple
  // PREP: [[COPY0:%.*]] = waveamdmachine.copy_tuple [[INIT]]
  // PREP-NEXT: [[MMA0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, [[COPY0]]
  // PREP-NOT: waveamdmachine.v_mov_b32_tuple
  // PREP: [[COPY1:%.*]] = waveamdmachine.copy_tuple [[INIT]]
  // PREP-NEXT: [[MMA1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, [[COPY1]]
  func.func @copy_expensive_shared_mfma_accumulator()
      -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>) {
    %lhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
    %rhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %base = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %init = waveamdmachine.v_mov_b32_tuple %base {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %mma0 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs, %rhs, %init
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %mma1 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs, %rhs, %init
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return %mma0, %mma1
        : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>
  }

  // PREP-LABEL: func.func @keep_single_mfma_accumulator(
  // PREP: [[ZERO:%.*]] = waveamdmachine.imm 0
  // PREP-NEXT: [[ACC:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
  // PREP-NEXT: [[UNRELATED:%.*]] = waveamdmachine.v_add_u32
  // PREP-NEXT: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, [[ACC]]
  func.func @keep_single_mfma_accumulator()
      -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>) {
    %lhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
    %rhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
    %scalar_lhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %scalar_rhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %init = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %unrelated = waveamdmachine.v_add_u32 %scalar_lhs, %scalar_rhs
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %mma = waveamdmachine.mfma_f32_16x16x32_f16 %lhs, %rhs, %init
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return %mma, %unrelated
        : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>
  }

  // PREP-LABEL: func.func @unaligned_reconstruction_copies(
  // PREP: [[COPY0:%.*]] = waveamdmachine.copy_tuple
  // PREP: [[COPY1:%.*]] = waveamdmachine.copy_tuple
  // PREP: waveamdmachine.tuple_from_elements [[COPY0]], [[COPY1]]
  func.func @unaligned_reconstruction_copies(
      %src: !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 2> {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %view = waveamdmachine.tuple_from_elements %parts#1, %parts#2
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    return %view : !waveamdmachine.reg<vgpr, 2>
  }
}
