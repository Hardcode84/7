# RUN: wavec -I %S/Inputs -DW=32 %S/Inputs/wavec_preprocessor.wave \
# RUN:   | wave-opt | FileCheck %s --check-prefix=IR
# RUN: wavec -I %S/Inputs -UW -DW=32 %S/Inputs/wavec_preprocessor.wave \
# RUN:   | wave-opt | FileCheck %s --check-prefix=IR
# RUN: wavec -E -I %S/Inputs -DW=32 -o %t.pp %S/Inputs/wavec_preprocessor.wave
# RUN: FileCheck %s --check-prefix=PP < %t.pp
# RUN: wavec -include %S/Inputs/wavec_pp_forced.waveh -DW=32 \
# RUN:   %S/Inputs/wavec_preprocessor_forced.wave \
# RUN:   | wave-opt | FileCheck %s --check-prefix=FORCED
# RUN: not wavec -I %S/Inputs %S/Inputs/wavec_missing_include.wave \
# RUN:   2>&1 | FileCheck %s --check-prefix=MISSING

# IR: func.func @pp_include
# IR: wave.lane_id : !wave.simd<i32, 32>
# IR: wave.binary addi
# IR: wave.store

# PP: kernel {{\[\[}}amdgpu_wave_size(32){{\]\]}}
# PP-NOT: #include
# PP: void pp_include

# FORCED: func.func @pp_forced
# FORCED: wave.binary addi

# MISSING: 'does_not_exist.waveh' file not found
