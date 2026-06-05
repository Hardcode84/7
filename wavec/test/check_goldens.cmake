# Golden conformance check for the lowering stage. For each construct, run
# lower_test (which builds that golden's AST and lowers it), normalize both
# the output and the checked-in golden through wave-opt (SSA-name
# normalization), and require structural equality. Also runs the overfit
# probe (a permuted saxpy must NOT reproduce the canned golden).
#
# Invoked by ctest with -DLOWER_TEST, -DWAVE_OPT, -DGOLDEN_DIR.

if(NOT EXISTS "${WAVE_OPT}")
  message(FATAL_ERROR "wave-opt not found at ${WAVE_OPT}")
endif()

# Run lower_test <mode>, pipe through wave-opt, write normalized text to <out>.
function(lower_and_norm mode out)
  execute_process(
      COMMAND "${LOWER_TEST}" "${mode}"
      OUTPUT_VARIABLE raw RESULT_VARIABLE rc ERROR_VARIABLE err)
  if(NOT rc EQUAL 0)
    message(FATAL_ERROR "lower_test ${mode} failed (rc=${rc}): ${err}")
  endif()
  set(tmp "${CMAKE_CURRENT_BINARY_DIR}/_lt_${mode}.mlir")
  file(WRITE "${tmp}" "${raw}")
  execute_process(
      COMMAND "${WAVE_OPT}" "${tmp}"
      OUTPUT_VARIABLE norm RESULT_VARIABLE rc2 ERROR_VARIABLE err2)
  if(NOT rc2 EQUAL 0)
    message(FATAL_ERROR "wave-opt rejected lower_test ${mode} output: ${err2}")
  endif()
  set(${out} "${norm}" PARENT_SCOPE)
endfunction()

function(norm_golden path out)
  execute_process(
      COMMAND "${WAVE_OPT}" "${path}"
      OUTPUT_VARIABLE norm RESULT_VARIABLE rc ERROR_VARIABLE err)
  if(NOT rc EQUAL 0)
    message(FATAL_ERROR "wave-opt failed on golden ${path}: ${err}")
  endif()
  set(${out} "${norm}" PARENT_SCOPE)
endfunction()

function(assert_match mode golden)
  lower_and_norm("${mode}" mine)
  norm_golden("${golden}" gold)
  if(NOT mine STREQUAL gold)
    message(FATAL_ERROR "[${mode}] does not match golden ${golden}")
  endif()
  message(STATUS "[${mode}] MATCH")
endfunction()

assert_match(saxpy           "${GOLDEN_DIR}/saxpy.mlir")
assert_match(reduce_sum      "${GOLDEN_DIR}/reduce_sum.mlir")
assert_match(where_otherwise "${GOLDEN_DIR}/where_otherwise.mlir")
assert_match(uniform_if_else "${GOLDEN_DIR}/uniform_if_else.mlir")
assert_match(cast_f32_f16    "${GOLDEN_DIR}/cast_f32_f16.mlir")
assert_match(lds_roundtrip   "${GOLDEN_DIR}/lds_roundtrip.mlir")

# Overfit probe: the swapped-loads variant must be valid IR yet differ from
# the saxpy golden (proves derivation from the AST, not a canned template).
lower_and_norm("--swap" swapped)
norm_golden("${GOLDEN_DIR}/saxpy.mlir" saxpy_gold)
if(swapped STREQUAL saxpy_gold)
  message(FATAL_ERROR "overfit probe FAILED: swapped saxpy reproduced the golden")
endif()
message(STATUS "[overfit-probe] OK: swapped variant differs from golden")

message(STATUS "all lowering golden checks passed")
