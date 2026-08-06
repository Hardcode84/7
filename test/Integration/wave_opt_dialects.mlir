// RUN: wave-opt --show-dialects 2>&1 | FileCheck %s

// CHECK: Available Dialects: arith,builtin,cf,func,gpu,llvm,memref,rocdl,scf,transform,ub,wave,waveamd,waveamdmachine,wavemeta
