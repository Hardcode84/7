// RUN: wave-opt %s --canonicalize | FileCheck %s --check-prefix=KEEP
// KEEP-LABEL: func.func @wave_anchor
// KEEP: wave.materialization_variants
// KEEP: wave.materialization_anchor
func.func @wave_anchor(%a: !wave.mem.token, %b: !wave.mem.token) {
  %choice = wave.materialization_variants %a, %b : !wave.mem.token
  wave.materialization_anchor %choice : !wave.mem.token
  return
}
