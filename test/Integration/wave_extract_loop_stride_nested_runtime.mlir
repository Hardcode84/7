// REQUIRES: host-supports-amdgpu-wave, wave-python-bindings, host-has-hip-runtime
// RUN: mkdir -p %t.pipeline
// RUN: sed 's/"wave-extract-loop-strides"/"canonicalize"/' %wave_pipelines > %t.pipeline/pipelines.mlir
// RUN: sed 's/@W@/%wave_width/g' %S/wave_extract_loop_stride_nested.mlir | wave-opt --wave-set-target-attr=chip=%chip -o %t.input
// RUN: wave-opt %t.input --wave-extract-loop-strides -o %t.extracted
// RUN: FileCheck %S/wave_extract_loop_stride_nested.mlir < %t.extracted
// RUN: env PYTHONPATH=%wave_obj_root/python_packages/wave_mlir %python %S/Inputs/select_materialization_variant.py %t.extracted 0 > %t.original
// RUN: env PYTHONPATH=%wave_obj_root/python_packages/wave_mlir %python %S/Inputs/select_materialization_variant.py %t.extracted 1 > %t.carried
// RUN: env WAVE_PIPELINES_DIR=%t.pipeline wave-translate %t.input --wave-to-amdgpu-asm -o %t.baseline.s
// RUN: env WAVE_PIPELINES_DIR=%t.pipeline wave-translate %t.original --wave-to-amdgpu-asm -o %t.original.s
// RUN: env WAVE_PIPELINES_DIR=%t.pipeline wave-translate %t.carried --wave-to-amdgpu-asm -o %t.carried.s
// RUN: wave-translate %t.extracted --wave-to-amdgpu-asm -o %t.selected.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.baseline.s -o %t.baseline.o
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.original.s -o %t.original.o
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.carried.s -o %t.carried.o
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.selected.s -o %t.selected.o
// RUN: ld.lld --shared %t.baseline.o -o %t.baseline.hsaco
// RUN: ld.lld --shared %t.original.o -o %t.original.hsaco
// RUN: ld.lld --shared %t.carried.o -o %t.carried.hsaco
// RUN: ld.lld --shared %t.selected.o -o %t.selected.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/loop_stride_nested_runner.py --hip-lib=%hip_runtime_lib --wave-width=%wave_width %t.baseline.hsaco %t.original.hsaco %t.carried.hsaco %t.selected.hsaco | FileCheck %s
// CHECK: Nested offsets: 4 forms, 8 cases, 2048 words passed
