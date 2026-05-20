add_mlir_dialect(WaveAMDMachineOps waveamdmachine)
add_mlir_doc(WaveAMDMachineOps WaveAMDMachineOps Dialects/ -gen-dialect-doc)

set(LLVM_TARGET_DEFINITIONS WaveAMDMachineOps.td)
mlir_tablegen(WaveAMDMachineOpsEnums.h.inc -gen-enum-decls)
mlir_tablegen(WaveAMDMachineOpsEnums.cpp.inc -gen-enum-defs)
add_public_tablegen_target(MLIRWaveAMDMachineEnumsIncGen)

set(LLVM_TARGET_DEFINITIONS WaveAMDMachineInterfaces.td)
mlir_tablegen(WaveAMDMachineInterfaces.h.inc -gen-op-interface-decls)
mlir_tablegen(WaveAMDMachineInterfaces.cpp.inc -gen-op-interface-defs)
add_public_tablegen_target(MLIRWaveAMDMachineInterfacesIncGen)
