// RUN: wave-opt %s --waveamd-prepare-regalloc | FileCheck %s --check-prefix=PREP
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s --check-prefix=SCAN
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-prepare-regalloc,waveamd-pack-vgpr-zero-moves,waveamd-hazard-repair{hoist-m0-across-regions=false},waveamd-prepare-regalloc)' | FileCheck %s --check-prefix=REPREP

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

  // PREP-LABEL: func.func @aligned_view_prior_reads_loop_carry(
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: return
  // SCAN-LABEL: func.func @aligned_view_prior_reads_loop_carry(
  // SCAN-SAME: [[SRC:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[#BASE:]]>
  // SCAN: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements [[SRC]]
  // SCAN: [[VIEW:%.*]] = waveamdmachine.tuple_from_elements [[PARTS]]#2, [[PARTS]]#3
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>
  // SCAN: waveamdmachine.uniform_loop
  // SCAN-SAME: carries([[VIEW]] : !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>)
  // SCAN: ^bb0([[CARRY:%[^:]+]]: !waveamdmachine.reg<vgpr, 2, [[#BASE+2]]>):
  func.func @aligned_view_prior_reads_loop_carry(
      %src: !waveamdmachine.reg<vgpr, 4>,
      %cond: !waveamdmachine.reg<scc, 1>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>) {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %prior = waveamdmachine.v_add_u32 %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
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
    return %loop, %prior
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  }

  // PREP-LABEL: func.func @aligned_view_element_live_after_loop_copies(
  // PREP: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements
  // PREP-NEXT: [[COPY0:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#2
  // PREP-NEXT: [[COPY1:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#3
  // PREP-NEXT: waveamdmachine.tuple_from_elements [[COPY0]], [[COPY1]]
  func.func @aligned_view_element_live_after_loop_copies(
      %src: !waveamdmachine.reg<vgpr, 4>,
      %cond: !waveamdmachine.reg<scc, 1>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>) {
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
    %post = waveamdmachine.v_add_u32 %parts#2, %parts#3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return %loop, %post
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  }

  // PREP-LABEL: func.func @scalar_loop_init_tuple_slot_keeps_copy(
  // PREP: [[OTHER:%.*]] = waveamdmachine.s_mov_b32_value
  // PREP-NEXT: [[INIT:%.*]] = waveamdmachine.s_mov_b32_value
  // PREP-NEXT: [[COPY:%.*]] = waveamdmachine.copy_tuple [[INIT]]
  // PREP-NEXT: [[TUPLE:%.*]] = waveamdmachine.tuple_from_elements {{%.*}}, [[COPY]]
  // PREP: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[INIT]]
  // SCAN-LABEL: func.func @scalar_loop_init_tuple_slot_keeps_copy(
  // SCAN: [[OTHER:%.*]] = waveamdmachine.s_mov_b32_value
  // SCAN-NEXT: [[INIT:%.*]] = waveamdmachine.s_mov_b32_value
  // SCAN-SAME: -> !waveamdmachine.reg<sgpr, 1, [[#REG:]]>
  // SCAN: waveamdmachine.uniform_loop
  // SCAN-SAME: carries([[INIT]] : !waveamdmachine.reg<sgpr, 1, [[#REG]]>)
  // SCAN: ^bb0([[CARRY:%[^:]+]]: !waveamdmachine.reg<sgpr, 1, [[#REG]]>):
  // SCAN: waveamdmachine.continue_if
  // SCAN-SAME: carries({{%.*}} : !waveamdmachine.reg<sgpr, 1, [[#REG]]>)
  func.func @scalar_loop_init_tuple_slot_keeps_copy(
      %cond: !waveamdmachine.reg<scc, 1>)
      -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 2>) {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %other = waveamdmachine.s_mov_b32_value %one
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %init = waveamdmachine.s_mov_b32_value %zero
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %tuple = waveamdmachine.tuple_from_elements %other, %init
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 2>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%init : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %next, %next_scc = waveamdmachine.s_add_i32 %carry, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<scc, 1>)
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%next : !waveamdmachine.reg<sgpr, 1>)
    } -> !waveamdmachine.reg<sgpr, 1>
    return %loop, %tuple
        : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 2>
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
  // PREP: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements
  // PREP-NEXT: [[COPY0:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#2
  // PREP-NEXT: [[COPY1:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#3
  // PREP-NEXT: [[VIEW:%.*]] = waveamdmachine.tuple_from_elements [[COPY0]], [[COPY1]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[VIEW]]
  // PREP: waveamdmachine.v_mov_b32_tuple [[SRC:%[^ ]+]]
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

  // Tuple update and carried slice cannot clobber post-loop descriptor use.
  // PREP-LABEL: func.func @loop_update_tuple_base_live_after(
  // PREP-SAME: [[DESC:%[^:]+]]: !waveamdmachine.reg<sgpr, 4>
  // PREP: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements [[DESC]]
  // PREP: [[DESC_COPY:%.*]] = waveamdmachine.copy_tuple [[DESC]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[PARTS]]#0
  // PREP: [[UPDATED:%.*]] = waveamdmachine.update_tuple [[DESC_COPY]],
  // PREP: waveamdmachine.s_mov_b32_tuple [[UPDATED]]
  // PREP: waveamdmachine.s_mov_b32_tuple [[DESC]]
  func.func @loop_update_tuple_base_live_after(
      %desc: !waveamdmachine.reg<sgpr, 4>,
      %cond: !waveamdmachine.reg<scc, 1>)
      -> !waveamdmachine.reg<sgpr, 4> {
    %parts:2 = waveamdmachine.tuple_to_elements %desc
        : (!waveamdmachine.reg<sgpr, 4>)
          -> (!waveamdmachine.reg<sgpr, 2>,
              !waveamdmachine.reg<sgpr, 2>)
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%parts#0 : !waveamdmachine.reg<sgpr, 2>) {
    ^bb0(%base: !waveamdmachine.reg<sgpr, 2>):
      %updated = waveamdmachine.update_tuple %desc, %base {offsets = [0]}
          : (!waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.reg<sgpr, 2>)
            -> !waveamdmachine.reg<sgpr, 4>
      %body = waveamdmachine.s_mov_b32_tuple %updated {registers = 4 : i64}
          : (!waveamdmachine.reg<sgpr, 4>)
            -> !waveamdmachine.reg<sgpr, 4>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%base : !waveamdmachine.reg<sgpr, 2>)
    } -> !waveamdmachine.reg<sgpr, 2>
    %after = waveamdmachine.s_mov_b32_tuple %desc {registers = 4 : i64}
        : (!waveamdmachine.reg<sgpr, 4>)
          -> !waveamdmachine.reg<sgpr, 4>
    return %after : !waveamdmachine.reg<sgpr, 4>
  }

  // Loop iterations may take different uniform_if arms.
  // PREP-LABEL: func.func @loop_branch_update_tuple_base_live_next_iteration(
  // PREP-SAME: [[DESC:%[^:]+]]: !waveamdmachine.reg<sgpr, 2>
  // PREP: [[DESC_COPY:%.*]] = waveamdmachine.copy_tuple [[DESC]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP: waveamdmachine.uniform_if
  // PREP: waveamdmachine.update_tuple [[DESC_COPY]],
  // PREP: otherwise
  // PREP: waveamdmachine.s_mov_b32_tuple [[DESC]]
  func.func @loop_branch_update_tuple_base_live_next_iteration(
      %desc: !waveamdmachine.reg<sgpr, 2>,
      %seed: !waveamdmachine.reg<sgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>) {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%seed : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%iter: !waveamdmachine.reg<sgpr, 1>):
      %branch = waveamdmachine.s_cmp_eq_u32 %iter, %zero
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_if %branch {
        %updated = waveamdmachine.update_tuple %desc, %iter {offsets = [0]}
            : (!waveamdmachine.reg<sgpr, 2>,
               !waveamdmachine.reg<sgpr, 1>)
              -> !waveamdmachine.reg<sgpr, 2>
        %use = waveamdmachine.s_mov_b32_tuple %updated
            {registers = 2 : i64}
            : (!waveamdmachine.reg<sgpr, 2>)
              -> !waveamdmachine.reg<sgpr, 2>
        waveamdmachine.yield
      } otherwise {
        %use = waveamdmachine.s_mov_b32_tuple %desc {registers = 2 : i64}
            : (!waveamdmachine.reg<sgpr, 2>)
              -> !waveamdmachine.reg<sgpr, 2>
        waveamdmachine.yield
      } : !waveamdmachine.reg<scc, 1>
      %next, %next_scc = waveamdmachine.s_add_i32 %iter, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<scc, 1>)
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%next : !waveamdmachine.reg<sgpr, 1>)
    } -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  // Loop-local bases cannot survive a backedge.
  // PREP-LABEL: func.func @loop_local_update_base_stays_arm_local(
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: waveamdmachine.uniform_loop
  // PREP: [[BASE:%.*]] = waveamdmachine.s_mov_b32_tuple
  // PREP: waveamdmachine.uniform_if
  // PREP: waveamdmachine.update_tuple [[BASE]],
  // PREP: otherwise
  // PREP: waveamdmachine.s_mov_b32_tuple [[BASE]]
  // PREP-NOT: waveamdmachine.copy_tuple
  func.func @loop_local_update_base_stays_arm_local(
      %part: !waveamdmachine.reg<sgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>) {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1> {
    ^bb0:
      %base = waveamdmachine.s_mov_b32_tuple %zero {registers = 2 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
      waveamdmachine.uniform_if %cond {
        %updated = waveamdmachine.update_tuple %base, %part {offsets = [0]}
            : (!waveamdmachine.reg<sgpr, 2>,
               !waveamdmachine.reg<sgpr, 1>)
              -> !waveamdmachine.reg<sgpr, 2>
        %then = waveamdmachine.s_mov_b32_tuple %updated {registers = 2 : i64}
            : (!waveamdmachine.reg<sgpr, 2>)
              -> !waveamdmachine.reg<sgpr, 2>
        waveamdmachine.yield
      } otherwise {
        %else = waveamdmachine.s_mov_b32_tuple %base {registers = 2 : i64}
            : (!waveamdmachine.reg<sgpr, 2>)
              -> !waveamdmachine.reg<sgpr, 2>
        waveamdmachine.yield
      } : !waveamdmachine.reg<scc, 1>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
    return
  }

  // Outer loop owns storage reused by nested iterations.
  // PREP-LABEL: func.func @nested_loop_update_copy_uses_outer_anchor(
  // PREP-SAME: [[DESC:%[^:]+]]: !waveamdmachine.reg<sgpr, 2>
  // PREP: [[DESC_COPY:%.*]] = waveamdmachine.copy_tuple [[DESC]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP: waveamdmachine.uniform_loop
  // PREP: waveamdmachine.update_tuple [[DESC_COPY]],
  // PREP: waveamdmachine.s_mov_b32_tuple [[DESC]]
  func.func @nested_loop_update_copy_uses_outer_anchor(
      %desc: !waveamdmachine.reg<sgpr, 2>,
      %part: !waveamdmachine.reg<sgpr, 1>,
      %outer_cond: !waveamdmachine.reg<scc, 1>,
      %inner_cond: !waveamdmachine.reg<scc, 1>) {
    waveamdmachine.uniform_loop if %outer_cond
        : !waveamdmachine.reg<scc, 1> {
    ^bb0:
      waveamdmachine.uniform_loop if %inner_cond
          : !waveamdmachine.reg<scc, 1> {
      ^bb0:
        %updated = waveamdmachine.update_tuple %desc, %part {offsets = [0]}
            : (!waveamdmachine.reg<sgpr, 2>,
               !waveamdmachine.reg<sgpr, 1>)
              -> !waveamdmachine.reg<sgpr, 2>
        %use = waveamdmachine.s_mov_b32_tuple %updated {registers = 2 : i64}
            : (!waveamdmachine.reg<sgpr, 2>)
              -> !waveamdmachine.reg<sgpr, 2>
        waveamdmachine.continue_if %inner_cond
            : !waveamdmachine.reg<scc, 1>
      }
      waveamdmachine.continue_if %outer_cond
          : !waveamdmachine.reg<scc, 1>
    }
    %after = waveamdmachine.s_mov_b32_tuple %desc {registers = 2 : i64}
        : (!waveamdmachine.reg<sgpr, 2>)
          -> !waveamdmachine.reg<sgpr, 2>
    return
  }

  // Updating one tuple slot does not clobber a shared sibling.
  // PREP-LABEL: func.func @loop_update_keeps_shared_leaf(
  // PREP: [[INIT:%.*]] = waveamdmachine.tuple_from_elements
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[INIT]]
  func.func @loop_update_keeps_shared_leaf(
      %cond: !waveamdmachine.reg<scc, 1>)
      -> !waveamdmachine.reg<sgpr, 1> {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %base = waveamdmachine.s_mov_b32_value %zero
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %shared = waveamdmachine.s_mov_b32_value %one
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %init = waveamdmachine.tuple_from_elements %base, %shared
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 2>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%init : !waveamdmachine.reg<sgpr, 2>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 2>):
      %next, %scc = waveamdmachine.s_add_i32 %base, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<scc, 1>)
      %updated = waveamdmachine.update_tuple %carry, %next {offsets = [0]}
          : (!waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.reg<sgpr, 1>)
            -> !waveamdmachine.reg<sgpr, 2>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%updated : !waveamdmachine.reg<sgpr, 2>)
    } -> !waveamdmachine.reg<sgpr, 2>
    %after, %after_scc = waveamdmachine.s_add_i32 %shared, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<scc, 1>)
    return %after : !waveamdmachine.reg<sgpr, 1>
  }

  // Backedge tuple insertion cannot alias a distinct loop carry.
  // SCAN-LABEL: func.func @loop_update_does_not_alias_distinct_carry(
  // SCAN-SAME: !waveamdmachine.reg<sgpr, 1, [[#BASE:]]>
  // SCAN-SAME: !waveamdmachine.reg<sgpr, 2, [[#BASE+2]]>
  // SCAN: [[NEXT:%.*]], {{%.*}} = waveamdmachine.s_add_i32
  // SCAN-SAME: -> (!waveamdmachine.reg<sgpr, 1, [[#BASE+2]]>
  // SCAN: [[UPDATED:%.*]] = waveamdmachine.update_tuple {{%.*}}, [[NEXT]]
  // SCAN-SAME: -> !waveamdmachine.reg<sgpr, 2, [[#BASE+2]]>
  // SCAN: [[NEXT_COPY:%.*]] = waveamdmachine.copy_tuple [[NEXT]]
  // SCAN-SAME: -> !waveamdmachine.reg<sgpr, 1, [[#BASE]]>
  // SCAN-NEXT: waveamdmachine.continue_if
  // SCAN-SAME: carries([[NEXT_COPY]], [[UPDATED]]
  func.func @loop_update_does_not_alias_distinct_carry(
      %scalar_init: !waveamdmachine.reg<sgpr, 1>,
      %tuple_init: !waveamdmachine.reg<sgpr, 2>,
      %cond: !waveamdmachine.reg<scc, 1>) {
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %loop:2 = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%scalar_init, %tuple_init
            : !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<sgpr, 2>) {
    ^bb0(%scalar: !waveamdmachine.reg<sgpr, 1>,
         %tuple: !waveamdmachine.reg<sgpr, 2>):
      %next, %scc = waveamdmachine.s_add_i32 %scalar, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<scc, 1>)
      %updated = waveamdmachine.update_tuple %tuple, %next {offsets = [0]}
          : (!waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.reg<sgpr, 1>)
            -> !waveamdmachine.reg<sgpr, 2>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%next, %updated
              : !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<sgpr, 2>)
    } -> !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>
    return
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

  // PREP-LABEL: func.func @last_use_vgpr_splat_reuses_source(
  // PREP-SAME: [[SOURCE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
  // PREP: [[EARLIER:%.*]] = waveamdmachine.v_mov_b32_tuple [[SOURCE]]
  // PREP-NEXT: [[COPY:%.*]] = waveamdmachine.copy_tuple [[SOURCE]]
  // PREP-NEXT: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[SOURCE]], [[COPY]]
  // PREP-NEXT: [[SWAPPED:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[PAIR]]
  // PREP: return [[SWAPPED]], [[EARLIER]]
  // SCAN-LABEL: func.func @last_use_vgpr_splat_reuses_source(
  // SCAN-SAME: [[SOURCE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, [[#BASE:]]>
  // SCAN: [[COPY:%.*]] = waveamdmachine.copy_tuple [[SOURCE]]
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 1, [[#BASE+1]]>
  // SCAN-NEXT: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[SOURCE]], [[COPY]]
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE]]>
  // SCAN-NEXT: [[SWAPPED:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[PAIR]]
  // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 2, [[#BASE]]>
  func.func @last_use_vgpr_splat_reuses_source(
      %source: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>) {
    %earlier = waveamdmachine.v_mov_b32_tuple %source {registers = 1 : i64}
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %pair = waveamdmachine.v_mov_b32_tuple %source {registers = 2 : i64}
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %swapped = waveamdmachine.v_permlane32_swap_b32_tuple %pair
        : (!waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    return %swapped, %earlier
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  }

  // REPREP-LABEL: func.func @repeated_prep_reuses_last_use_splat(
  // REPREP-SAME: [[SOURCE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
  // REPREP: [[COPY:%.*]] = waveamdmachine.v_mov_b32_tuple [[SOURCE]]
  // REPREP-NEXT: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[SOURCE]], [[COPY]]
  // REPREP-NEXT: waveamdmachine.v_permlane32_swap_b32_tuple [[PAIR]]
  func.func @repeated_prep_reuses_last_use_splat(
      %source: !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2> {
    %pair = waveamdmachine.v_mov_b32_tuple %source {registers = 2 : i64}
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %swapped = waveamdmachine.v_permlane32_swap_b32_tuple %pair
        : (!waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    return %swapped : !waveamdmachine.reg<vgpr, 2>
  }

  // PREP-LABEL: func.func @last_use_vgpr_splat_loop_init_reuses_source(
  // PREP-SAME: [[SOURCE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
  // PREP: [[COPY:%.*]] = waveamdmachine.copy_tuple [[SOURCE]]
  // PREP-NEXT: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[SOURCE]], [[COPY]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[PAIR]]
  func.func @last_use_vgpr_splat_loop_init_reuses_source(
      %source: !waveamdmachine.reg<vgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>)
      -> !waveamdmachine.reg<vgpr, 2> {
    %pair = waveamdmachine.v_mov_b32_tuple %source {registers = 2 : i64}
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%pair : !waveamdmachine.reg<vgpr, 2>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 2>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 2>)
    } -> !waveamdmachine.reg<vgpr, 2>
    return %loop : !waveamdmachine.reg<vgpr, 2>
  }

  // PREP-LABEL: func.func @last_use_sgpr_splat_reuses_source(
  // PREP-SAME: [[SOURCE:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
  // PREP: [[COPY:%.*]] = waveamdmachine.copy_tuple [[SOURCE]]
  // PREP-NEXT: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[SOURCE]], [[COPY]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[PAIR]]
  // REPREP-LABEL: func.func @last_use_sgpr_splat_reuses_source(
  // REPREP-SAME: [[SOURCE:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
  // REPREP: [[COPY:%.*]] = waveamdmachine.s_mov_b32_tuple [[SOURCE]]
  // REPREP-NEXT: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[SOURCE]], [[COPY]]
  // REPREP-NEXT: waveamdmachine.uniform_loop
  // REPREP-SAME: carries([[PAIR]]
  // SCAN-LABEL: func.func @last_use_sgpr_splat_reuses_source(
  // SCAN-SAME: [[SOURCE:%[^:]+]]: !waveamdmachine.reg<sgpr, 1, [[#BASE:]]>
  // SCAN: [[COPY:%.*]] = waveamdmachine.copy_tuple [[SOURCE]]
  // SCAN-SAME: -> !waveamdmachine.reg<sgpr, 1, [[#BASE+1]]>
  // SCAN-NEXT: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[SOURCE]], [[COPY]]
  // SCAN-SAME: -> !waveamdmachine.reg<sgpr, 2, [[#BASE]]>
  func.func @last_use_sgpr_splat_reuses_source(
      %source: !waveamdmachine.reg<sgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>)
      -> !waveamdmachine.reg<sgpr, 2> {
    %pair = waveamdmachine.s_mov_b32_tuple %source {registers = 2 : i64}
        : (!waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 2>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%pair : !waveamdmachine.reg<sgpr, 2>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 2>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<sgpr, 2>)
    } -> !waveamdmachine.reg<sgpr, 2>
    return %loop : !waveamdmachine.reg<sgpr, 2>
  }

  // PREP-LABEL: func.func @cross_class_splat_keeps_full_copy(
  // PREP: [[PAIR:%.*]] = waveamdmachine.v_mov_b32_tuple [[SOURCE:%[^ ]+]]
  // PREP-NEXT: waveamdmachine.uniform_loop
  // PREP-SAME: carries([[PAIR]]
  func.func @cross_class_splat_keeps_full_copy(
      %source: !waveamdmachine.reg<sgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>)
      -> !waveamdmachine.reg<vgpr, 2> {
    %pair = waveamdmachine.v_mov_b32_tuple %source {registers = 2 : i64}
        : (!waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %loop = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%pair : !waveamdmachine.reg<vgpr, 2>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 2>):
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 2>)
    } -> !waveamdmachine.reg<vgpr, 2>
    return %loop : !waveamdmachine.reg<vgpr, 2>
  }

  // PREP-LABEL: func.func @live_vgpr_splat_keeps_full_copy(
  // PREP: [[PAIR:%.*]] = waveamdmachine.v_mov_b32_tuple [[SOURCE:%[^ ]+]]
  // PREP-NEXT: [[SWAPPED:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[PAIR]]
  // PREP-NEXT: [[LATER:%.*]] = waveamdmachine.v_mov_b32_tuple [[SOURCE]]
  // PREP: return [[SWAPPED]], [[LATER]]
  func.func @live_vgpr_splat_keeps_full_copy(
      %source: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>) {
    %pair = waveamdmachine.v_mov_b32_tuple %source {registers = 2 : i64}
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %swapped = waveamdmachine.v_permlane32_swap_b32_tuple %pair
        : (!waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %later = waveamdmachine.v_mov_b32_tuple %source {registers = 1 : i64}
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return %swapped, %later
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  }

  // PREP-LABEL: func.func @loop_invariant_vgpr_splat_keeps_full_copy(
  // PREP: waveamdmachine.uniform_loop
  // PREP: [[PAIR:%.*]] = waveamdmachine.v_mov_b32_tuple [[SOURCE:%[^ ]+]]
  // PREP-NEXT: waveamdmachine.v_permlane32_swap_b32_tuple [[PAIR]]
  func.func @loop_invariant_vgpr_splat_keeps_full_copy(
      %source: !waveamdmachine.reg<vgpr, 1>,
      %cond: !waveamdmachine.reg<scc, 1>) {
    waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1> {
    ^bb0:
      %pair = waveamdmachine.v_mov_b32_tuple %source {registers = 2 : i64}
          : (!waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 2>
      %swapped = waveamdmachine.v_permlane32_swap_b32_tuple %pair
          : (!waveamdmachine.reg<vgpr, 2>)
            -> !waveamdmachine.reg<vgpr, 2>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
    return
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

  // RegionBranch flow drives dead incoming join reuse.
  // PREP-LABEL: func.func @scf_if_dead_incoming_aliases_join(
  // PREP-SAME: [[INPUT:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
  // PREP: scf.if
  // PREP-NEXT: scf.yield [[INPUT]]
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: return
  // SCAN-LABEL: func.func @scf_if_dead_incoming_aliases_join(
  // SCAN-SAME: [[INPUT:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, [[#REG:]]>
  // SCAN: [[RESULT:%.*]] = scf.if
  // SCAN-NEXT: scf.yield [[INPUT]]
  // SCAN: return [[RESULT]] : !waveamdmachine.reg<vgpr, 1, [[#REG]]>
  func.func @scf_if_dead_incoming_aliases_join(
      %condition: i1, %input: !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1> {
    %result = scf.if %condition -> !waveamdmachine.reg<vgpr, 1> {
      scf.yield %input : !waveamdmachine.reg<vgpr, 1>
    } else {
      %alternative = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      scf.yield %alternative : !waveamdmachine.reg<vgpr, 1>
    }
    return %result : !waveamdmachine.reg<vgpr, 1>
  }

  // Live incoming storage cannot be the destructive join destination.
  // PREP-LABEL: func.func @scf_if_live_incoming_copies(
  // PREP-SAME: [[INPUT:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
  // PREP: scf.if
  // PREP-NEXT: [[COPY:%.*]] = waveamdmachine.copy_tuple [[INPUT]]
  // PREP-NEXT: scf.yield [[COPY]]
  // PREP: waveamdmachine.v_add_u32 [[INPUT]], [[INPUT]]
  func.func @scf_if_live_incoming_copies(
      %condition: i1, %input: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>) {
    %result = scf.if %condition -> !waveamdmachine.reg<vgpr, 1> {
      scf.yield %input : !waveamdmachine.reg<vgpr, 1>
    } else {
      %alternative = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      scf.yield %alternative : !waveamdmachine.reg<vgpr, 1>
    }
    %post = waveamdmachine.v_add_u32 %input, %input
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return %result, %post
        : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  }

  // Multi-region cycle forwards one logical slot without a copy.
  // PREP-LABEL: func.func @scf_while_preserves_carry_slot(
  // PREP-NOT: waveamdmachine.copy_tuple
  // PREP: scf.condition
  // PREP: scf.yield
  // PREP: return
  // SCAN-LABEL: func.func @scf_while_preserves_carry_slot(
  // SCAN-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, [[#REG:]]>
  // SCAN: [[RESULT:%.*]] = scf.while
  // SCAN: return [[RESULT]] : !waveamdmachine.reg<vgpr, 1, [[#REG]]>
  func.func @scf_while_preserves_carry_slot(
      %condition: i1, %init: !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1> {
    %result = scf.while (%before = %init)
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1> {
      scf.condition(%condition) %before : !waveamdmachine.reg<vgpr, 1>
    } do {
    ^bb0(%after: !waveamdmachine.reg<vgpr, 1>):
      scf.yield %after : !waveamdmachine.reg<vgpr, 1>
    }
    return %result : !waveamdmachine.reg<vgpr, 1>
  }

  // Cycle copies use one parallel-transfer snapshot.
  // PREP-LABEL: func.func @scf_for_parallel_carry_swap(
  // PREP: scf.for
  // PREP: [[RHS_COPY:%.*]] = waveamdmachine.copy_tuple [[RHS:%[^ ]+]]
  // PREP-NEXT: [[LHS_COPY:%.*]] = waveamdmachine.copy_tuple [[LHS:%[^ ]+]]
  // PREP-NEXT: scf.yield [[RHS_COPY]], [[LHS_COPY]]
  // SCAN-LABEL: func.func @scf_for_parallel_carry_swap(
  // SCAN-SAME: waveamdmachine.regalloc_assignments
  func.func @scf_for_parallel_carry_swap(
      %lower: index, %upper: index, %step: index,
      %lhs: !waveamdmachine.reg<vgpr, 1>,
      %rhs: !waveamdmachine.reg<vgpr, 1>)
      -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>) {
    %results:2 = scf.for %i = %lower to %upper step %step
        iter_args(%lhs_iter = %lhs, %rhs_iter = %rhs)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>) {
      scf.yield %rhs_iter, %lhs_iter
          : !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>
    }
    return %results#0, %results#1
        : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  }

  // Nested branches share outer carry storage without crossing sibling arms.
  // PREP-LABEL: func.func @scf_for_nested_if(
  // PREP: scf.for
  // PREP: scf.if
  // PREP: scf.yield
  // PREP: scf.yield
  // PREP: scf.yield
  // SCAN-LABEL: func.func @scf_for_nested_if(
  // SCAN-SAME: waveamdmachine.regalloc_assignments
  func.func @scf_for_nested_if(
      %lower: index, %upper: index, %step: index, %condition: i1,
      %init: !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1> {
    %result = scf.for %i = %lower to %upper step %step
        iter_args(%carry = %init) -> !waveamdmachine.reg<vgpr, 1> {
      %next = scf.if %condition -> !waveamdmachine.reg<vgpr, 1> {
        %changed = waveamdmachine.v_add_u32 %carry, %carry
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        scf.yield %changed : !waveamdmachine.reg<vgpr, 1>
      } else {
        scf.yield %carry : !waveamdmachine.reg<vgpr, 1>
      }
      scf.yield %next : !waveamdmachine.reg<vgpr, 1>
    }
    return %result : !waveamdmachine.reg<vgpr, 1>
  }
}
