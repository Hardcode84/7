// RUN: wave-opt %s --waveamd-prepare-regalloc | FileCheck %s --check-prefix=PREP
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s --check-prefix=SCAN

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
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
