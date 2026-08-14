# RUN: wavec %S/../../wavec/test/e2e/good/saxpy.wave | wave-opt | FileCheck %s
# RUN: wavec --emit=wave -o %t.wave %S/../../wavec/test/e2e/good/saxpy.wave
# RUN: FileCheck %s --check-prefix=WAVE < %t.wave
# RUN: wavec --emit=ast %S/../../wavec/test/e2e/good/saxpy.wave | FileCheck %s --check-prefix=AST
# RUN: wavec -S --offload-arch gfx1100 %S/../../wavec/test/e2e/good/saxpy.wave | FileCheck %s --check-prefix=ASM
# RUN: mkdir -p %t.root/bin %t.root/llvm-install/bin %t.empty
# RUN: cp %wave_obj_root/bin/wavec %t.root/bin/wavec
# RUN: ln -sfn %wave_obj_root/llvm-install/bin/ld.lld %t.root/llvm-install/bin/ld.lld
# RUN: env -u WAVE_LLVM_TOOLS_DIR \
# RUN:   WAVE_PIPELINES_DIR=%wave_obj_root/share/wave-mlir/pipelines \
# RUN:   PATH=%t.empty %t.root/bin/wavec -c -o %t.hsaco \
# RUN:   %S/../../wavec/test/e2e/good/saxpy.wave
# RUN: %llvm_readelf --notes %t.hsaco | FileCheck %s --check-prefix=NOTE
# RUN: wavec -c --target-features= -o %t.features.hsaco %S/../../wavec/test/e2e/good/saxpy.wave
# RUN: %llvm_readelf --notes %t.features.hsaco | FileCheck %s --check-prefix=NOTE
# RUN: not env WAVE_LLVM_TOOLS_DIR=%t.missing wavec -c -o %t.missing.hsaco %S/../../wavec/test/e2e/good/saxpy.wave 2>&1 | FileCheck %s --check-prefix=NO-LLD
# RUN: mkdir -p %t.no-lld/bin
# RUN: cp %wave_obj_root/bin/wavec %t.no-lld/bin/wavec
# RUN: not env -u WAVE_LLVM_TOOLS_DIR \
# RUN:   WAVE_PIPELINES_DIR=%wave_obj_root/share/wave-mlir/pipelines \
# RUN:   PATH=%t.empty %t.no-lld/bin/wavec -c -o %t.no-lld.hsaco \
# RUN:   %S/../../wavec/test/e2e/good/saxpy.wave 2>&1 \
# RUN:   | FileCheck %s --check-prefix=NO-DEFAULT-LLD

# CHECK: func.func @saxpy
# CHECK: wave.where
# CHECK: wave.store

# WAVE: func.func @saxpy
# WAVE: wave.where

# AST: (kernel "saxpy"
# AST: (call
# AST-NEXT: (ident "lane_id")

# ASM: .amdgcn_target "amdgcn-amd-amdhsa--gfx1100"
# ASM: saxpy:

# NOTE: amdhsa.kernels:
# NOTE: .name: saxpy

# NO-LLD: WAVE_LLVM_TOOLS_DIR does not contain executable ld.lld:
# NO-DEFAULT-LLD: unable to find ld.lld; set WAVE_LLVM_TOOLS_DIR to its bin directory
