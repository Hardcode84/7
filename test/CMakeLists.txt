set(LLVM_TOOLS_DIR "${LLVM_TOOLS_BINARY_DIR}")
set(SHLIBEXT "${CMAKE_SHARED_LIBRARY_SUFFIX}")
set(WAVE_MLIR_TOOLS_DIR "${CMAKE_BINARY_DIR}/bin")
# Fallback for LLVM installs that don't ship FileCheck / count / not
# (i.e. ones configured without LLVM_INSTALL_UTILS=ON). Picks them up
# straight from the LLVM build tree.
set(WAVE_LLVM_BUILD_TOOLS_DIR "${WAVE_LLVM_PROJECT_BUILD_DIR}/bin")

configure_lit_site_cfg(
  ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
  ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py
  MAIN_CONFIG
  ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py
)

set(WAVE_MLIR_TEST_DEPENDS
  wave-calibrate-report
  wave-opt
  wave-sim-report
  wave-symbols-test
  wave-translate
)

add_lit_testsuite(check-wave-mlir "Running the wave-mlir regression tests"
  ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS ${WAVE_MLIR_TEST_DEPENDS}
)
set_target_properties(check-wave-mlir PROPERTIES FOLDER "Tests")

add_lit_testsuites(WAVE_MLIR ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS ${WAVE_MLIR_TEST_DEPENDS}
)
