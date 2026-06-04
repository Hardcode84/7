# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

string(REPLACE "," ";" WAVE_PYTHON_MODULE_NAMES
  "${WAVE_PYTHON_MODULE_NAMES_CSV}")
file(MAKE_DIRECTORY "${WAVE_PYTHON_MLIR_LIBS}")
foreach(module_name IN LISTS WAVE_PYTHON_MODULE_NAMES)
  if(NOT module_name STREQUAL "_mlir")
    set(alias_path
      "${WAVE_PYTHON_MLIR_LIBS}/${module_name}${WAVE_PYTHON_MODULE_SUFFIX}")
    file(REMOVE "${alias_path}")
    execute_process(
      COMMAND "${CMAKE_COMMAND}" -E create_symlink
              "${WAVE_PYTHON_BUNDLE}" "${alias_path}"
      COMMAND_ERROR_IS_FATAL ANY)
  endif()
endforeach()
