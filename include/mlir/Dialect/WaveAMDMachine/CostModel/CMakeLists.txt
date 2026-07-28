set(LLVM_TARGET_DEFINITIONS CostModelEnums.td)
mlir_tablegen(CostModelEnums.h.inc -gen-enum-decls)
mlir_tablegen(CostModelEnums.cpp.inc -gen-enum-defs)
add_public_tablegen_target(MLIRWaveAMDMachineCostModelEnumsIncGen)
