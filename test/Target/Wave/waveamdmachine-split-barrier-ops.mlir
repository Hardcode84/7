// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUNDTRIP --implicit-check-not='scope workgroup'
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUNDTRIP --implicit-check-not='scope workgroup'

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

// ROUNDTRIP-LABEL: func.func @native_split_barrier_ops(
// ROUNDTRIP: [[ROOT:%.*]] = waveamdmachine.token
// ROUNDTRIP-NEXT: [[SIGNAL:%.*]] = waveamdmachine.s_barrier_signal [[ROOT]]
// ROUNDTRIP-NEXT: [[WAIT:%.*]] = waveamdmachine.s_barrier_wait [[SIGNAL]]
// ROUNDTRIP-NEXT: waveamdmachine.token_join [[WAIT]]
func.func @native_split_barrier_ops() {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %signal = waveamdmachine.s_barrier_signal %root scope workgroup
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %wait = waveamdmachine.s_barrier_wait %signal scope workgroup
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %wait
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// ROUNDTRIP-LABEL: func.func @wave_barrier_scopes(
// ROUNDTRIP: [[ROOT:%.*]] = wave.token
// ROUNDTRIP-NEXT: [[WORKGROUP:%.*]] = wave.barrier [[ROOT]]
// ROUNDTRIP-NEXT: [[CLUSTER:%.*]] = wave.barrier [[WORKGROUP]] scope cluster
func.func @wave_barrier_scopes() {
  %root = wave.token : !wave.mem.token
  %workgroup = wave.barrier %root scope workgroup
      : (!wave.mem.token) -> !wave.mem.token
  %cluster = wave.barrier %workgroup scope cluster
      : (!wave.mem.token) -> !wave.mem.token
  return
}

// ROUNDTRIP-LABEL: func.func @cluster_barrier_ops(
// ROUNDTRIP-SAME: [[SEED:%.*]]: !waveamdmachine.reg<scc, 1>
// ROUNDTRIP: [[ROOT:%.*]] = waveamdmachine.token
// ROUNDTRIP-NEXT: [[WHOLE:%.*]] = waveamdmachine.cluster_barrier [[ROOT]]
// ROUNDTRIP-NEXT: [[FIRST:%.*]], [[LOCAL:%.*]] = waveamdmachine.s_barrier_signal_isfirst [[SEED]] after [[ROOT]]
// ROUNDTRIP-NEXT: [[CLUSTER:%.*]] = waveamdmachine.s_barrier_signal [[LOCAL]] scope cluster
// ROUNDTRIP-NEXT: [[READY:%.*]] = waveamdmachine.s_barrier_wait [[CLUSTER]] scope cluster
// ROUNDTRIP-NEXT: waveamdmachine.token_join [[WHOLE]], [[READY]]
func.func @cluster_barrier_ops(
    %seed: !waveamdmachine.reg<scc, 1>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %whole = waveamdmachine.cluster_barrier %root
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %first, %local = waveamdmachine.s_barrier_signal_isfirst
      %seed after %root
      : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<scc, 1>, !waveamdmachine.mem.token)
  %cluster = waveamdmachine.s_barrier_signal %local scope cluster
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ready = waveamdmachine.s_barrier_wait %cluster scope cluster
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %whole, %ready
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}
