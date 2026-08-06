# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# The python bindings build MLIR upstream sources (nanobind passes,
# extension wrappers) that emit clang-only pragmas and benign macro
# redefinitions which gcc flags. We don't own that source; opt this
# subdirectory out of the top-level `-Werror`.
add_compile_options(-Wno-error)

include(AddMLIRPython)

# Co-locate Wave dialect bindings under the upstream `mlir` package so the
# generated `_mlir_libs/_mlir.so` and core sources stay reachable through
# their stock import paths. `mlir_configure_python_dev_packages` was
# invoked at the top level.
add_compile_definitions("MLIR_PYTHON_PACKAGE_PREFIX=${MLIR_PYTHON_PACKAGE_PREFIX}.")

declare_mlir_python_sources(WavePythonSources)

declare_mlir_python_sources(WavePythonSources.dsl
  ADD_TO_PARENT WavePythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir"
  SOURCES
    dialects/wave.py
    dialects/waveamd.py
    dialects/wavemeta.py
    dialects/wave_attention.py
    dialects/wave_dsl.py
    dialects/wave_flash_attention.py
    dialects/wave_matmul.py
    dialects/wave_target.py
)

declare_mlir_dialect_python_bindings(
  ADD_TO_PARENT WavePythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir"
  TD_FILE dialects/WaveOps.td
  GEN_ENUM_BINDINGS
  SOURCES_GLOB dialects/_wave_*_gen.py
  DIALECT_NAME wave)

declare_mlir_dialect_python_bindings(
  ADD_TO_PARENT WavePythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir"
  TD_FILE dialects/WaveAMDOps.td
  GEN_ENUM_BINDINGS
  SOURCES_GLOB dialects/_waveamd_*_gen.py
  DIALECT_NAME waveamd)

declare_mlir_dialect_python_bindings(
  ADD_TO_PARENT WavePythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir"
  TD_FILE dialects/WaveMetaOps.td
  GEN_ENUM_BINDINGS
  SOURCES_GLOB dialects/_wavemeta_*_gen.py
  DIALECT_NAME wavemeta)

declare_mlir_python_extension(WavePythonSources.NanobindExtension
  MODULE_NAME _waveDialectsNanobind
  ADD_TO_PARENT WavePythonSources
  SOURCES
    WaveExtensionNanobind.cpp
  EMBED_CAPI_LINK_LIBS
    MLIRCAPIIR
    WaveCAPI
)

declare_mlir_python_extension(WavePythonSources.SiteInitializer
  MODULE_NAME _site_initialize_0
  ADD_TO_PARENT WavePythonSources
  SOURCES
    WaveSiteInitialize.cpp
  EMBED_CAPI_LINK_LIBS
    MLIRCAPIArith
    MLIRCAPIFunc
    MLIRCAPIGPU
    MLIRCAPIIR
    MLIRCAPIMemRef
    MLIRCAPISCF
    MLIRCAPITransformDialect
    MLIRCAPIUB
    WaveCAPI
)

set(WavePythonModules_ROOT_PREFIX
  "${MLIR_BINARY_DIR}/${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}")
set(WAVE_PYTHON_MLIR_LIBS "${WavePythonModules_ROOT_PREFIX}/_mlir_libs")
set(WAVE_PYTHON_BUNDLE_TARGET WavePythonModules.extension._mlir.dso)
set(WAVE_PYTHON_NB_DOMAIN "mlir")

_flatten_mlir_python_targets(_wave_python_targets
  WavePythonSources
  MLIRPythonSources.Core
  MLIRPythonSources.Dialects.arith
  MLIRPythonSources.Dialects.func
  MLIRPythonSources.Dialects.gpu
  MLIRPythonSources.Dialects.memref
  MLIRPythonSources.Dialects.scf
  MLIRPythonSources.Dialects.transform
  MLIRPythonSources.Dialects.transform.interpreter
  MLIRPythonSources.Dialects.ub)

set(_wave_python_pure_targets)
set(_wave_python_bundle_link_libs)
set(_wave_python_embed_libs)
set(_wave_python_module_names)
foreach(source_target IN LISTS _wave_python_targets)
  get_target_property(source_type ${source_target} mlir_python_SOURCES_TYPE)
  if(source_type STREQUAL "pure")
    list(APPEND _wave_python_pure_targets ${source_target})
  elseif(source_type STREQUAL "extension" OR source_type STREQUAL "support")
    get_target_property(module_name ${source_target}
      mlir_python_EXTENSION_MODULE_NAME)
    if(source_type STREQUAL "extension")
      list(APPEND _wave_python_module_names ${module_name})
    endif()

    get_target_property(embed_libs ${source_target}
      mlir_python_EMBED_CAPI_LINK_LIBS)
    if(embed_libs)
      list(APPEND _wave_python_embed_libs ${embed_libs})
    endif()

    get_target_property(link_libs ${source_target} INTERFACE_LINK_LIBRARIES)
    if(link_libs)
      foreach(link_lib IN LISTS link_libs)
        set(is_python_source_target OFF)
        if(TARGET ${link_lib})
          get_property(has_source_type TARGET ${link_lib}
            PROPERTY mlir_python_SOURCES_TYPE SET)
          if(has_source_type)
            set(is_python_source_target ON)
          endif()
        endif()
        if(NOT is_python_source_target)
          list(APPEND _wave_python_bundle_link_libs ${link_lib})
        endif()
      endforeach()
    endif()
  endif()
endforeach()
list(APPEND _wave_python_embed_libs
  MLIRCAPIConversion
  MLIRCAPITransforms)
list(REMOVE_DUPLICATES _wave_python_embed_libs)
list(REMOVE_DUPLICATES _wave_python_bundle_link_libs)
list(REMOVE_DUPLICATES _wave_python_module_names)

add_custom_target(WavePythonModules ALL)
add_custom_target(WavePythonModules.sources)
add_dependencies(WavePythonModules WavePythonModules.sources)
foreach(source_target IN LISTS _wave_python_pure_targets)
  set(sources_target "WavePythonModules.sources.${source_target}")
  add_mlir_python_sources_target(${sources_target}
    INSTALL_COMPONENT WavePythonModules
    INSTALL_DIR "${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}"
    OUTPUT_DIRECTORY "${WavePythonModules_ROOT_PREFIX}"
    SOURCES_TARGETS ${source_target})
  add_dependencies(WavePythonModules.sources ${sources_target})
endforeach()
_flatten_mlir_python_targets(_wave_python_header_targets
  MLIRPythonCAPI.HeaderSources)
add_mlir_python_sources_target(WavePythonModules.capi-headers
  INSTALL_COMPONENT WavePythonModules
  INSTALL_DIR "${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}/_mlir_libs/include"
  OUTPUT_DIRECTORY "${WAVE_PYTHON_MLIR_LIBS}/include"
  SOURCES_TARGETS ${_wave_python_header_targets})
add_dependencies(WavePythonModules.sources WavePythonModules.capi-headers)

if(MLIR_ENABLE_PYTHON_STABLE_ABI)
  set(_stable_abi_flag STABLE_ABI)
else()
  set(_stable_abi_flag "")
endif()

nanobind_add_module(${WAVE_PYTHON_BUNDLE_TARGET}
  NB_STATIC
  NB_DOMAIN ${WAVE_PYTHON_NB_DOMAIN}
  FREE_THREADED
  ${_stable_abi_flag}
)
foreach(source_target IN LISTS _wave_python_targets)
  get_target_property(source_type ${source_target} mlir_python_SOURCES_TYPE)
  if(source_type STREQUAL "extension" OR source_type STREQUAL "support")
    target_sources(${WAVE_PYTHON_BUNDLE_TARGET} PRIVATE
      "$<TARGET_GENEX_EVAL:${WAVE_PYTHON_BUNDLE_TARGET},$<TARGET_PROPERTY:${source_target},INTERFACE_SOURCES>>")
    target_include_directories(${WAVE_PYTHON_BUNDLE_TARGET} PRIVATE
      "$<TARGET_GENEX_EVAL:${WAVE_PYTHON_BUNDLE_TARGET},$<TARGET_PROPERTY:${source_target},INTERFACE_INCLUDE_DIRECTORIES>>")
  endif()
endforeach()
target_compile_definitions(${WAVE_PYTHON_BUNDLE_TARGET} PRIVATE
  MLIR_BINDINGS_PYTHON_DOMAIN=${WAVE_PYTHON_NB_DOMAIN}
  MLIR_CAPI_BUILDING_LIBRARY=1)
target_compile_options(${WAVE_PYTHON_BUNDLE_TARGET} PRIVATE
  -frtti
  -fexceptions
  -Wno-c++98-compat-extra-semi
  -Wno-cast-qual
  -Wno-covered-switch-default
  -Wno-deprecated-literal-operator
  -Wno-nested-anon-types
  -Wno-unused-parameter
  -Wno-zero-length-array
  -Wno-missing-field-initializers)
target_link_libraries(${WAVE_PYTHON_BUNDLE_TARGET} PRIVATE
  ${_wave_python_bundle_link_libs}
  ${_wave_python_embed_libs})
set_target_properties(${WAVE_PYTHON_BUNDLE_TARGET} PROPERTIES
  C_VISIBILITY_PRESET hidden
  CXX_VISIBILITY_PRESET hidden
  ARCHIVE_OUTPUT_DIRECTORY "${WAVE_PYTHON_MLIR_LIBS}"
  BINARY_OUTPUT_DIRECTORY "${WAVE_PYTHON_MLIR_LIBS}"
  LIBRARY_OUTPUT_DIRECTORY "${WAVE_PYTHON_MLIR_LIBS}"
  OUTPUT_NAME "_mlir"
  NO_SONAME ON
  RUNTIME_OUTPUT_DIRECTORY "${WAVE_PYTHON_MLIR_LIBS}"
  VISIBILITY_INLINES_HIDDEN ON)
mlir_python_setup_extension_rpath(${WAVE_PYTHON_BUNDLE_TARGET})
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(WAVE_PYTHON_MODULE_EXPORTS
      "${CMAKE_CURRENT_SOURCE_DIR}/wave-python-module.exports")
  target_link_options(${WAVE_PYTHON_BUNDLE_TARGET} PRIVATE
    "LINKER:--exclude-libs,ALL"
    "LINKER:--version-script=${WAVE_PYTHON_MODULE_EXPORTS}")
  set_property(TARGET ${WAVE_PYTHON_BUNDLE_TARGET} APPEND PROPERTY
    LINK_DEPENDS "${WAVE_PYTHON_MODULE_EXPORTS}")
endif()
install(TARGETS ${WAVE_PYTHON_BUNDLE_TARGET}
  COMPONENT WavePythonModules
  LIBRARY DESTINATION "${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}/_mlir_libs"
  RUNTIME DESTINATION "${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}/_mlir_libs")

if(MLIR_ENABLE_PYTHON_STABLE_ABI AND NOT (NB_ABI MATCHES "[0-9]t"))
  set(WAVE_PYTHON_MODULE_SUFFIX "${NB_SUFFIX_S}")
else()
  set(WAVE_PYTHON_MODULE_SUFFIX "${NB_SUFFIX}")
endif()
list(JOIN _wave_python_module_names "," WAVE_PYTHON_MODULE_NAMES_CSV)

set(_wave_python_extension_aliases)
foreach(module_name IN LISTS _wave_python_module_names)
  if(NOT module_name STREQUAL "_mlir")
    list(APPEND _wave_python_extension_aliases
      "${WAVE_PYTHON_MLIR_LIBS}/${module_name}${WAVE_PYTHON_MODULE_SUFFIX}")
    add_custom_target(WavePythonModules.extension.${module_name}.dso
      DEPENDS WavePythonModules.extension-links)
  endif()
endforeach()
set(_wave_python_extension_links_stamp
  "${CMAKE_CURRENT_BINARY_DIR}/WavePythonModules.extension-links.stamp")
add_custom_command(
  OUTPUT "${_wave_python_extension_links_stamp}"
  BYPRODUCTS ${_wave_python_extension_aliases}
  COMMAND "${CMAKE_COMMAND}" -DWAVE_PYTHON_MLIR_LIBS=${WAVE_PYTHON_MLIR_LIBS}
          -P "${CMAKE_CURRENT_SOURCE_DIR}/wave-python-cleanup.cmake"
  COMMAND "${CMAKE_COMMAND}"
          -DWAVE_PYTHON_MLIR_LIBS=${WAVE_PYTHON_MLIR_LIBS}
          -DWAVE_PYTHON_BUNDLE=$<TARGET_FILE:${WAVE_PYTHON_BUNDLE_TARGET}>
          -DWAVE_PYTHON_MODULE_SUFFIX=${WAVE_PYTHON_MODULE_SUFFIX}
          -DWAVE_PYTHON_MODULE_NAMES_CSV=${WAVE_PYTHON_MODULE_NAMES_CSV}
          -P "${CMAKE_CURRENT_SOURCE_DIR}/wave-python-link-aliases.cmake"
  COMMAND "${CMAKE_COMMAND}" -E touch
          "${_wave_python_extension_links_stamp}"
  DEPENDS
    ${WAVE_PYTHON_BUNDLE_TARGET}
    "${CMAKE_CURRENT_SOURCE_DIR}/wave-python-cleanup.cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/wave-python-link-aliases.cmake"
  VERBATIM)
add_custom_target(WavePythonModules.extension-links ALL
  DEPENDS "${_wave_python_extension_links_stamp}")
add_dependencies(WavePythonModules
  ${WAVE_PYTHON_BUNDLE_TARGET}
  WavePythonModules.extension-links)

set(_wave_python_install_aliases_code "
set(WAVE_PYTHON_MLIR_LIBS \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${MLIR_BINDINGS_PYTHON_INSTALL_PREFIX}/_mlir_libs\")
set(WAVE_PYTHON_BUNDLE \"_mlir${WAVE_PYTHON_MODULE_SUFFIX}\")
set(WAVE_PYTHON_MODULE_SUFFIX \"${WAVE_PYTHON_MODULE_SUFFIX}\")
set(WAVE_PYTHON_MODULE_NAMES_CSV \"${WAVE_PYTHON_MODULE_NAMES_CSV}\")
include(\"${CMAKE_CURRENT_SOURCE_DIR}/wave-python-cleanup.cmake\")
include(\"${CMAKE_CURRENT_SOURCE_DIR}/wave-python-link-aliases.cmake\")
")
install(CODE "${_wave_python_install_aliases_code}" COMPONENT WavePythonModules)

if(NOT LLVM_ENABLE_IDE)
  add_llvm_install_targets(
    install-WavePythonModules
    DEPENDS WavePythonModules
    COMPONENT WavePythonModules)
endif()
