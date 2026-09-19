// RUN: wave-opt %s --canonicalize | FileCheck %s

!v = !waveamdmachine.reg<vgpr, 1>
!s = !waveamdmachine.reg<sgpr, 1>
!t = !waveamdmachine.mem.token
!c = !waveamdmachine.reg<scc, 1>

// CHECK-LABEL: func.func @dead_stores
// CHECK-NEXT: return
func.func @dead_stores(%addr: !v, %value: !v, %offset: !s) {
  %ds = waveamdmachine.ds_store_b32 %addr, %value : (!v, !v) -> !t
  %scratch = waveamdmachine.scratch_store_b32 %addr, %value, %offset after %ds : (!v, !v, !s, !t) -> !t
  return
}

// CHECK-LABEL: func.func @atomic_stays
// CHECK: waveamdmachine.ds_add_u32
// CHECK: return
func.func @atomic_stays(%addr: !v, %value: !v) {
  waveamdmachine.ds_add_u32 %addr, %value : (!v, !v) -> ()
  return
}

// CHECK-LABEL: func.func @dead_load
// CHECK-NEXT: return
func.func @dead_load(%addr: !v, %dependency: !t) {
  %value, %token = waveamdmachine.ds_load_b32 %addr after %dependency
      : (!v, !t) -> (!v, !t)
  return
}

// CHECK-LABEL: func.func @dead_recurrence
// CHECK-NOT: ds_store
// CHECK: return
func.func @dead_recurrence(%addr: !v, %value: !v, %condition: !c) {
  %empty = waveamdmachine.token : !t
  %loop = waveamdmachine.uniform_loop if %condition : !c carries(%empty : !t) {
  ^bb0(%carry: !t):
    %write = waveamdmachine.ds_store_b32 %addr, %value after %carry : (!v, !v, !t) -> !t
    waveamdmachine.continue_if %condition : !c carries(%write : !t)
  } -> !t
  return
}
