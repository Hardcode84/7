// RUN: wave-opt %s --waveamd-prepare-regalloc | FileCheck %s

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {
  // CHECK-LABEL: func.func @gfx1250_preserves_llvm_sgpr_tuple_view
  // CHECK: [[PARTS:%.*]]:3 = waveamdmachine.tuple_to_elements
  // CHECK-NOT: waveamdmachine.copy_tuple
  // CHECK: waveamdmachine.tuple_from_elements [[PARTS]]#1
  func.func @gfx1250_preserves_llvm_sgpr_tuple_view(
      %src: !waveamdmachine.reg<sgpr, 16>)
      -> !waveamdmachine.reg<sgpr, 8> {
    %parts:3 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<sgpr, 16>)
          -> (!waveamdmachine.reg<sgpr, 4>,
              !waveamdmachine.reg<sgpr, 8>,
              !waveamdmachine.reg<sgpr, 4>)
    %view = waveamdmachine.tuple_from_elements %parts#1
        : (!waveamdmachine.reg<sgpr, 8>)
          -> !waveamdmachine.reg<sgpr, 8>
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %done = waveamdmachine.tdm_load %parts#0, %view after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return %view : !waveamdmachine.reg<sgpr, 8>
  }

  // CHECK-LABEL: func.func @gfx1250_copies_nonexistent_sgpr_tuple_view
  // CHECK: [[PARTS:%.*]]:3 = waveamdmachine.tuple_to_elements
  // CHECK: [[COPY:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#1
  // CHECK: waveamdmachine.tuple_from_elements [[COPY]]
  func.func @gfx1250_copies_nonexistent_sgpr_tuple_view(
      %src: !waveamdmachine.reg<sgpr, 12>)
      -> !waveamdmachine.reg<sgpr, 8> {
    %parts:3 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<sgpr, 12>)
          -> (!waveamdmachine.reg<sgpr, 2>,
              !waveamdmachine.reg<sgpr, 8>,
              !waveamdmachine.reg<sgpr, 2>)
    %view = waveamdmachine.tuple_from_elements %parts#1
        : (!waveamdmachine.reg<sgpr, 8>)
          -> !waveamdmachine.reg<sgpr, 8>
    %d0 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %done = waveamdmachine.tdm_load %d0, %view after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return %view : !waveamdmachine.reg<sgpr, 8>
  }

  // CHECK-LABEL: func.func @gfx1250_preserves_even_tuple_view
  // CHECK: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements
  // CHECK-NOT: waveamdmachine.copy_tuple
  // CHECK: waveamdmachine.tuple_from_elements [[PARTS]]#1, [[PARTS]]#2
  func.func @gfx1250_preserves_even_tuple_view(
      %src: !waveamdmachine.reg<vgpr, 8>)
      -> !waveamdmachine.reg<vgpr, 4> {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 8>)
          -> (!waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>)
    %view = waveamdmachine.tuple_from_elements %parts#1, %parts#2
        : (!waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 4>
    return %view : !waveamdmachine.reg<vgpr, 4>
  }

  // CHECK-LABEL: func.func @gfx1250_reanchors_at_even_offset
  // CHECK: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements
  // CHECK-NOT: waveamdmachine.copy_tuple
  // CHECK: waveamdmachine.tuple_from_elements {{%.*}}, [[PARTS]]#0, [[PARTS]]#1
  func.func @gfx1250_reanchors_at_even_offset(
      %prefix: !waveamdmachine.reg<vgpr, 2>,
      %src: !waveamdmachine.reg<vgpr, 4>)
      -> !waveamdmachine.reg<vgpr, 6> {
    %parts:2 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>)
    %tuple = waveamdmachine.tuple_from_elements
        %prefix, %parts#0, %parts#1
        : (!waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 6>
    return %tuple : !waveamdmachine.reg<vgpr, 6>
  }

  // CHECK-LABEL: func.func @gfx1250_copies_odd_reanchor
  // CHECK: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements
  // CHECK: [[COPY0:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#0
  // CHECK: [[COPY1:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#1
  // CHECK: waveamdmachine.tuple_from_elements {{%.*}}, [[COPY0]], [[COPY1]]
  func.func @gfx1250_copies_odd_reanchor(
      %prefix: !waveamdmachine.reg<vgpr, 1>,
      %src: !waveamdmachine.reg<vgpr, 4>)
      -> !waveamdmachine.reg<vgpr, 5> {
    %parts:2 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>)
    %tuple = waveamdmachine.tuple_from_elements
        %prefix, %parts#0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 5>
    return %tuple : !waveamdmachine.reg<vgpr, 5>
  }
}

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"
} {
  // CHECK-LABEL: func.func @legacy_copies_misaligned_tuple_view
  // CHECK: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements
  // CHECK: [[COPY0:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#1
  // CHECK: [[COPY1:%.*]] = waveamdmachine.copy_tuple [[PARTS]]#2
  // CHECK: waveamdmachine.tuple_from_elements [[COPY0]], [[COPY1]]
  func.func @legacy_copies_misaligned_tuple_view(
      %src: !waveamdmachine.reg<vgpr, 8>)
      -> !waveamdmachine.reg<vgpr, 4> {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 8>)
          -> (!waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>)
    %view = waveamdmachine.tuple_from_elements %parts#1, %parts#2
        : (!waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 4>
    return %view : !waveamdmachine.reg<vgpr, 4>
  }

  // CHECK-LABEL: func.func @legacy_preserves_reanchor
  // CHECK: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements
  // CHECK-NOT: waveamdmachine.copy_tuple
  // CHECK: waveamdmachine.tuple_from_elements {{%.*}}, [[PARTS]]#0, [[PARTS]]#1
  func.func @legacy_preserves_reanchor(
      %prefix: !waveamdmachine.reg<vgpr, 2>,
      %src: !waveamdmachine.reg<vgpr, 4>)
      -> !waveamdmachine.reg<vgpr, 6> {
    %parts:2 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 2>,
              !waveamdmachine.reg<vgpr, 2>)
    %tuple = waveamdmachine.tuple_from_elements
        %prefix, %parts#0, %parts#1
        : (!waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 6>
    return %tuple : !waveamdmachine.reg<vgpr, 6>
  }
}
