// RUN: wave-opt %s --canonicalize | FileCheck %s --check-prefix=KEEP
// RUN: wave-opt %s --canonicalize --waveamd-expand-materialization-variants --waveamd-collapse-materialization-variants | FileCheck %s --check-prefix=REMOVE --implicit-check-not=materialization_anchor --implicit-check-not=materialization_variants

// KEEP-LABEL: func.func @folded
// KEEP: waveamdmachine.materialization_anchor %{{.*}} : !waveamdmachine.mem.token
// REMOVE-LABEL: func.func @folded
// REMOVE-NEXT: return
func.func @folded(%token: !waveamdmachine.mem.token) {
  %choice = waveamdmachine.materialization_variants %token : !waveamdmachine.mem.token
  waveamdmachine.materialization_anchor %choice : !waveamdmachine.mem.token
  return
}
