// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUNDTRIP

module {

// ROUNDTRIP-LABEL: func.func @split_barrier_ops(
// ROUNDTRIP: [[STATE:%.*]] = waveamdmachine.barrier_init
// ROUNDTRIP: [[ROOT:%.*]] = waveamdmachine.token
// ROUNDTRIP: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive [[STATE]] after [[ROOT]]
// ROUNDTRIP-SAME: -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
// ROUNDTRIP: [[READY:%.*]] = waveamdmachine.barrier_wait [[STATE]], [[TICKET]] after [[ARRIVED]]
// ROUNDTRIP-SAME: -> !waveamdmachine.mem.token
// ROUNDTRIP: waveamdmachine.token_join [[READY]]
func.func @split_barrier_ops() {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %root
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}
