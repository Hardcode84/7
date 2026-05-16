add_subdirectory(Conversion)
add_subdirectory(Dialect)
add_subdirectory(Target)

if(MLIR_ENABLE_BINDINGS_PYTHON)
  add_subdirectory(CAPI)
endif()
