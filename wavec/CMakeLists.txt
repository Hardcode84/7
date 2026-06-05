set(WAVEC_C_FLAGS
  -std=c99
  -pedantic
  -Werror
  -Wall
  -Wextra
)

set(WAVEC_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")

set(WAVEFRONT_SOURCES
  src/arena.c
  src/astdump.c
  src/diag.c
  src/lex.c
  src/parse.c
  src/sema.c
)

add_library(wavefront STATIC ${WAVEFRONT_SOURCES})
target_include_directories(wavefront PUBLIC "${WAVEC_INCLUDE_DIR}")
target_compile_options(wavefront PRIVATE
  $<$<COMPILE_LANGUAGE:C>:${WAVEC_C_FLAGS}>
)
set_target_properties(wavefront PROPERTIES
  C_EXTENSIONS OFF
  C_STANDARD 99
  C_STANDARD_REQUIRED ON
)

add_library(wavefront_lower STATIC src/lower.cpp)
target_include_directories(wavefront_lower PUBLIC "${WAVEC_INCLUDE_DIR}")
llvm_update_compile_flags(wavefront_lower)
target_link_libraries(wavefront_lower PUBLIC
  MLIRCAPIArith
  MLIRCAPIFunc
  MLIRCAPIIR
  MLIRCAPISCF
  WaveCAPI
)
set_target_properties(wavefront_lower PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED ON
)

function(wavec_add_c_test name source)
  add_executable(${name} "${source}")
  target_link_libraries(${name} PRIVATE wavefront)
  target_include_directories(${name} PRIVATE "${WAVEC_INCLUDE_DIR}")
  target_compile_options(${name} PRIVATE
    $<$<COMPILE_LANGUAGE:C>:${WAVEC_C_FLAGS}>
  )
  set_target_properties(${name} PROPERTIES
    C_EXTENSIONS OFF
    C_STANDARD 99
    C_STANDARD_REQUIRED ON
  )
  add_test(NAME wavec.${name} COMMAND ${name})
  set_tests_properties(wavec.${name} PROPERTIES LABELS wavec)
endfunction()

wavec_add_c_test(wavec_arena_test test/arena_test.c)
wavec_add_c_test(wavec_lex_test test/lex_test.c)
wavec_add_c_test(wavec_parse_test test/parse_test.c)
wavec_add_c_test(wavec_sema_test test/sema_test.c)

add_executable(wavec_lower_test
  test/lower_test.cpp
  src/arena.c
  src/diag.c
)
target_include_directories(wavec_lower_test PRIVATE "${WAVEC_INCLUDE_DIR}")
target_compile_options(wavec_lower_test PRIVATE
  $<$<COMPILE_LANGUAGE:C>:${WAVEC_C_FLAGS}>
)
llvm_update_compile_flags(wavec_lower_test)
target_link_libraries(wavec_lower_test PRIVATE wavefront_lower)
set_target_properties(wavec_lower_test PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED ON
)

add_test(NAME wavec.lower_goldens
  COMMAND ${CMAKE_COMMAND}
    -DLOWER_TEST=$<TARGET_FILE:wavec_lower_test>
    -DWAVE_OPT=$<TARGET_FILE:wave-opt>
    -DGOLDEN_DIR=${CMAKE_CURRENT_SOURCE_DIR}/test/golden/mlir
    -P ${CMAKE_CURRENT_SOURCE_DIR}/test/check_goldens.cmake
)
set_tests_properties(wavec.lower_goldens PROPERTIES LABELS wavec)

add_executable(wavec src/wavec.c)
target_include_directories(wavec PRIVATE "${WAVEC_INCLUDE_DIR}")
target_compile_options(wavec PRIVATE
  $<$<COMPILE_LANGUAGE:C>:${WAVEC_C_FLAGS}>
)
target_compile_definitions(wavec PRIVATE
  WAVEC_HAVE_LEX=1
  WAVEC_HAVE_LOWERING=1
  WAVEC_HAVE_PARSE=1
  WAVEC_HAVE_SEMA=1
)
target_link_libraries(wavec PRIVATE
  wavefront
  wavefront_lower
)
set_target_properties(wavec PROPERTIES
  C_EXTENSIONS OFF
  C_STANDARD 99
  C_STANDARD_REQUIRED ON
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY "${LLVM_RUNTIME_OUTPUT_INTDIR}"
)

find_program(WAVEC_FILECHECK FileCheck
  PATHS
    ${LLVM_TOOLS_BINARY_DIR}
    ${WAVE_LLVM_BUILD_TOOLS_DIR}
    ${LLVM_INSTALL_DIR}/bin
)
if(WAVEC_FILECHECK)
  add_test(NAME wavec.e2e
    COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/test/run_e2e.sh
      $<TARGET_FILE:wavec>
      $<TARGET_FILE:wave-opt>
      ${CMAKE_CURRENT_SOURCE_DIR}/test/e2e
      ${WAVEC_FILECHECK}
  )
  set_tests_properties(wavec.e2e PROPERTIES LABELS wavec)
endif()

set(WAVEC_TEST_DEPENDS
  wave-opt
  wavec
  wavec_arena_test
  wavec_lex_test
  wavec_lower_test
  wavec_parse_test
  wavec_sema_test
)

add_custom_target(check-wavec
  COMMAND ${CMAKE_CTEST_COMMAND} --test-dir ${CMAKE_BINARY_DIR}
          -L wavec --output-on-failure
  DEPENDS ${WAVEC_TEST_DEPENDS}
  USES_TERMINAL
)
