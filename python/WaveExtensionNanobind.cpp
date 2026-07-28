//===- WaveExtensionNanobind.cpp - Wave python bindings -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Wave-c/Dialects.h"
#include "mlir/Bindings/Python/Nanobind.h"
#include "mlir/Bindings/Python/NanobindAdaptors.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"

namespace nb = nanobind;
using mlir::python::nanobind_adaptors::mlir_attribute_subclass;
using mlir::python::nanobind_adaptors::mlir_type_subclass;

static MlirStringRef asMlirStringRef(const std::string &value) {
  return MlirStringRef{value.data(), value.size()};
}

struct PyTargetCapabilities {
  std::string chip;
  MlirWaveAMDTargetCapabilities value;
};

template <typename T>
static auto targetCapability(T MlirWaveAMDTargetCapabilities::*member) {
  return [member](const PyTargetCapabilities &capabilities) {
    return capabilities.value.*member;
  };
}

static void bindTargetEnums(nb::module_ &m) {
  using mlir::waveamd::MmaKind;
  using mlir::waveamdmachine::MatrixFamily;
  using mlir::waveamdmachine::RegClass;
  using mlir::waveamdmachine::WaitCounterFamily;

  nb::enum_<MmaKind>(m, "MmaKind")
      .value("WmmaI32_16x16x16_IU8", MmaKind::WmmaI32_16x16x16_IU8)
      .value("WmmaF32_16x16x16_F16", MmaKind::WmmaF32_16x16x16_F16)
      .value("WmmaF32_16x16x16_BF16", MmaKind::WmmaF32_16x16x16_BF16)
      .value("MfmaF32_16x16x16_F16", MmaKind::MfmaF32_16x16x16_F16)
      .value("MfmaF32_16x16x16_BF16", MmaKind::MfmaF32_16x16x16_BF16)
      .value("MfmaF32_16x16x32_F16", MmaKind::MfmaF32_16x16x32_F16)
      .value("MfmaF32_16x16x32_BF16", MmaKind::MfmaF32_16x16x32_BF16)
      .value("MfmaF32_32x32x16_F16", MmaKind::MfmaF32_32x32x16_F16)
      .value("MfmaF32_32x32x16_BF16", MmaKind::MfmaF32_32x32x16_BF16)
      .value("MfmaScaleF32_16x16x128_F4F4",
             MmaKind::MfmaScaleF32_16x16x128_F4F4)
      .value("WmmaF32_16x16x32_F16", MmaKind::WmmaF32_16x16x32_F16)
      .value("WmmaF32_16x16x32_BF16", MmaKind::WmmaF32_16x16x32_BF16)
      .def("__str__", [](MmaKind value) {
        return mlir::waveamd::stringifyMmaKind(value).str();
      });
  nb::enum_<MatrixFamily>(m, "MatrixFamily")
      .value("None", MatrixFamily::None)
      .value("Gfx1250", MatrixFamily::Gfx1250)
      .value("Gfx1251", MatrixFamily::Gfx1251)
      .def("__str__", [](MatrixFamily value) {
        return mlir::waveamdmachine::stringifyMatrixFamily(value).str();
      });
  nb::enum_<WaitCounterFamily>(m, "WaitCounterFamily")
      .value("Legacy", WaitCounterFamily::Legacy)
      .value("Gfx12Split", WaitCounterFamily::Gfx12Split)
      .def("__str__", [](WaitCounterFamily value) {
        return mlir::waveamdmachine::stringifyWaitCounterFamily(value).str();
      });
  nb::enum_<RegClass>(m, "RegClass")
      .value("SGPR", RegClass::SGPR)
      .value("VGPR", RegClass::VGPR)
      .value("AGPR", RegClass::AGPR)
      .value("SCC", RegClass::SCC)
      .value("VCC", RegClass::VCC)
      .def("__str__", [](RegClass value) {
        return mlir::waveamdmachine::stringifyRegClass(value).str();
      });
}

static void
bindTargetFeatureCapabilities(nb::class_<PyTargetCapabilities> &cls) {
  cls.def_prop_ro(
         "supports_wave32",
         targetCapability(&MlirWaveAMDTargetCapabilities::supportsWave32))
      .def_prop_ro(
          "supports_wave64",
          targetCapability(&MlirWaveAMDTargetCapabilities::supportsWave64))
      .def_prop_ro("architected_flat_scratch",
                   targetCapability(
                       &MlirWaveAMDTargetCapabilities::architectedFlatScratch))
      .def_prop_ro(
          "architected_sgprs",
          targetCapability(&MlirWaveAMDTargetCapabilities::architectedSGPRs))
      .def_prop_ro("clusters",
                   targetCapability(&MlirWaveAMDTargetCapabilities::clusters))
      .def_prop_ro(
          "kernarg_preload",
          targetCapability(&MlirWaveAMDTargetCapabilities::kernargPreload))
      .def_prop_ro(
          "requires_initial_unclaused_vmem",
          targetCapability(
              &MlirWaveAMDTargetCapabilities::requiresInitialUnclausedVmem))
      .def_prop_ro("wait_xcnt",
                   targetCapability(&MlirWaveAMDTargetCapabilities::waitXcnt))
      .def_prop_ro(
          "vgpr_windowing",
          targetCapability(&MlirWaveAMDTargetCapabilities::vgprWindowing))
      .def_prop_ro(
          "setreg_vgpr_msb_fixup",
          targetCapability(&MlirWaveAMDTargetCapabilities::setregVGPRMSBFixup))
      .def_prop_ro("trans_coexecution_hazard",
                   targetCapability(
                       &MlirWaveAMDTargetCapabilities::transCoexecutionHazard))
      .def_prop_ro("wmma_coexecution_hazard",
                   targetCapability(
                       &MlirWaveAMDTargetCapabilities::wmmaCoexecutionHazard))
      .def_prop_ro(
          "scratch_base_forwarding_hazard",
          targetCapability(
              &MlirWaveAMDTargetCapabilities::scratchBaseForwardingHazard))
      .def_prop_ro(
          "descriptor_dx10_clamp_and_ieee_mode",
          targetCapability(
              &MlirWaveAMDTargetCapabilities::descriptorDX10ClampAndIEEEMode))
      .def_prop_ro(
          "descriptor_wgp_mode",
          targetCapability(&MlirWaveAMDTargetCapabilities::descriptorWGPMode))
      .def_prop_ro(
          "descriptor_shared_vgpr_count",
          targetCapability(
              &MlirWaveAMDTargetCapabilities::descriptorSharedVGPRCount))
      .def_prop_ro("descriptor_round_robin",
                   targetCapability(
                       &MlirWaveAMDTargetCapabilities::descriptorRoundRobin))
      .def_prop_ro(
          "descriptor_named_barrier_count",
          targetCapability(
              &MlirWaveAMDTargetCapabilities::descriptorNamedBarrierCount))
      .def_prop_ro("descriptor_architected_private_segment",
                   targetCapability(&MlirWaveAMDTargetCapabilities::
                                        descriptorArchitectedPrivateSegment));
}

static void bindTargetCapabilities(nb::module_ &m) {
  using mlir::waveamdmachine::MatrixFamily;
  using mlir::waveamdmachine::WaitCounterFamily;

  nb::class_<PyTargetCapabilities> cls(m, "TargetCapabilities");
  cls.def_ro("chip", &PyTargetCapabilities::chip)
      .def_prop_ro("isa_major",
                   targetCapability(&MlirWaveAMDTargetCapabilities::isaMajor))
      .def_prop_ro("isa_minor",
                   targetCapability(&MlirWaveAMDTargetCapabilities::isaMinor))
      .def_prop_ro(
          "isa_stepping",
          targetCapability(&MlirWaveAMDTargetCapabilities::isaStepping))
      .def_prop_ro("default_wavefront_size",
                   targetCapability(
                       &MlirWaveAMDTargetCapabilities::defaultWavefrontSize))
      .def_prop_ro(
          "addressable_sgprs",
          targetCapability(&MlirWaveAMDTargetCapabilities::addressableSGPRs))
      .def_prop_ro(
          "addressable_vgprs",
          targetCapability(&MlirWaveAMDTargetCapabilities::addressableVGPRs))
      .def_prop_ro(
          "addressable_agprs",
          targetCapability(&MlirWaveAMDTargetCapabilities::addressableAGPRs))
      .def_prop_ro("vgpr_allocation_granule",
                   targetCapability(
                       &MlirWaveAMDTargetCapabilities::vgprAllocationGranule))
      .def_prop_ro(
          "vgpr_tuple_alignment",
          targetCapability(&MlirWaveAMDTargetCapabilities::vgprTupleAlignment))
      .def_prop_ro(
          "local_memory_bytes",
          targetCapability(&MlirWaveAMDTargetCapabilities::localMemoryBytes))
      .def_prop_ro(
          "addressable_local_memory_bytes",
          targetCapability(
              &MlirWaveAMDTargetCapabilities::addressableLocalMemoryBytes))
      .def_prop_ro("local_memory_bank_count",
                   targetCapability(
                       &MlirWaveAMDTargetCapabilities::localMemoryBankCount))
      .def_prop_ro(
          "execution_units_per_cu",
          targetCapability(&MlirWaveAMDTargetCapabilities::executionUnitsPerCU))
      .def_prop_ro(
          "max_waves_per_eu",
          targetCapability(&MlirWaveAMDTargetCapabilities::maxWavesPerEU))
      .def_prop_ro("total_vgprs",
                   targetCapability(&MlirWaveAMDTargetCapabilities::totalVGPRs))
      .def_prop_ro(
          "schedule_issue_width",
          targetCapability(&MlirWaveAMDTargetCapabilities::scheduleIssueWidth))
      .def_prop_ro(
          "max_user_sgprs",
          targetCapability(&MlirWaveAMDTargetCapabilities::maxUserSGPRs))
      .def_prop_ro("buffer_resource_base_bits",
                   targetCapability(
                       &MlirWaveAMDTargetCapabilities::bufferResourceBaseBits))
      .def_prop_ro(
          "buffer_resource_num_records_bits",
          targetCapability(
              &MlirWaveAMDTargetCapabilities::bufferResourceNumRecordsBits))
      .def_prop_ro("wait_counter_family",
                   [](const PyTargetCapabilities &capabilities) {
                     return static_cast<WaitCounterFamily>(
                         capabilities.value.waitCounterFamily);
                   })
      .def_prop_ro(
          "matrix_family", [](const PyTargetCapabilities &capabilities) {
            return static_cast<MatrixFamily>(capabilities.value.matrixFamily);
          });
  bindTargetFeatureCapabilities(cls);

  m.def(
      "get_target_capabilities",
      [](const std::string &chip, const std::string &features) -> nb::object {
        PyTargetCapabilities capabilities{chip, {}};
        if (!mlirWaveAMDGetTargetCapabilities(asMlirStringRef(chip),
                                              asMlirStringRef(features),
                                              &capabilities.value))
          return nb::none();
        return nb::cast(capabilities);
      },
      nb::arg("chip"), nb::arg("features") = "");
}

static void bindMmaCapabilities(nb::module_ &m) {
  using mlir::waveamd::MmaKind;
  using mlir::waveamdmachine::RegClass;

  nb::class_<MlirWaveAMDMmaCapabilities>(m, "MmaCapabilities")
      .def_prop_ro("kind",
                   [](const MlirWaveAMDMmaCapabilities &capabilities) {
                     return static_cast<MmaKind>(capabilities.kind);
                   })
      .def_prop_ro("operand_bank",
                   [](const MlirWaveAMDMmaCapabilities &capabilities) {
                     return static_cast<RegClass>(capabilities.operandBank);
                   })
      .def_prop_ro("accumulator_bank",
                   [](const MlirWaveAMDMmaCapabilities &capabilities) {
                     return static_cast<RegClass>(capabilities.accumulatorBank);
                   })
      .def_ro("operand_dwords", &MlirWaveAMDMmaCapabilities::operandDwords)
      .def_ro("accumulator_dwords",
              &MlirWaveAMDMmaCapabilities::accumulatorDwords)
      .def_ro("operand_alignment",
              &MlirWaveAMDMmaCapabilities::operandAlignment)
      .def_ro("accumulator_alignment",
              &MlirWaveAMDMmaCapabilities::accumulatorAlignment)
      .def_ro("m_tile", &MlirWaveAMDMmaCapabilities::mTile)
      .def_ro("n_tile", &MlirWaveAMDMmaCapabilities::nTile)
      .def_ro("k_tile", &MlirWaveAMDMmaCapabilities::kTile)
      .def_ro("lane_k_elements", &MlirWaveAMDMmaCapabilities::laneKElements);

  m.def(
      "get_mma_capabilities",
      [](const std::string &chip, MmaKind kind,
         const std::string &features) -> nb::object {
        MlirWaveAMDMmaCapabilities capabilities{};
        if (!mlirWaveAMDGetMmaCapabilities(
                asMlirStringRef(chip), static_cast<uint32_t>(kind),
                asMlirStringRef(features), &capabilities))
          return nb::none();
        return nb::cast(capabilities);
      },
      nb::arg("chip"), nb::arg("kind"), nb::arg("features") = "");
}

// Address-space attribute subclass.
//
// All three Wave address spaces (and the WaveAMD buffer one) are parameter-less
// markers: the only difference is the dialect-level TypeID. Bind them through
// the same shape so the Python surface stays uniform.
static void bindAddressSpaceAttr(nb::module_ &m, const char *name,
                                 bool (*isaFn)(MlirAttribute),
                                 MlirAttribute (*getFn)(MlirContext)) {
  mlir_attribute_subclass(m, name, isaFn)
      .def_classmethod(
          "get",
          [getFn](nb::object &cls, MlirContext ctx) { return cls(getFn(ctx)); },
          nb::arg("cls"), nb::arg("context"));
}

static void bindLoadCacheAttr(nb::module_ &m) {
  auto cls = mlir_attribute_subclass(m, "LoadCacheAttr",
                                     mlirWaveAMDAttributeIsALoadCache);
  cls.def_classmethod(
         "get",
         [](nb::object &cls, uint32_t value, MlirContext ctx) {
           return cls(mlirWaveAMDLoadCacheAttrGet(ctx, value));
         },
         nb::arg("cls"), nb::arg("value"), nb::arg("context"))
      .def_property_readonly("value", [](MlirAttribute self) {
        return mlirWaveAMDLoadCacheAttrGetValue(self);
      });
  cls.get_class().attr("NONE") = nb::int_(0);
  cls.get_class().attr("CA") = nb::int_(1);
  cls.get_class().attr("CG") = nb::int_(2);
  cls.get_class().attr("CS") = nb::int_(3);
  cls.get_class().attr("CV") = nb::int_(4);
}

static void bindStoreCacheAttr(nb::module_ &m) {
  auto cls = mlir_attribute_subclass(m, "StoreCacheAttr",
                                     mlirWaveAMDAttributeIsAStoreCache);
  cls.def_classmethod(
         "get",
         [](nb::object &cls, uint32_t value, MlirContext ctx) {
           return cls(mlirWaveAMDStoreCacheAttrGet(ctx, value));
         },
         nb::arg("cls"), nb::arg("value"), nb::arg("context"))
      .def_property_readonly("value", [](MlirAttribute self) {
        return mlirWaveAMDStoreCacheAttrGetValue(self);
      });
  cls.get_class().attr("NONE") = nb::int_(0);
  cls.get_class().attr("WB") = nb::int_(1);
  cls.get_class().attr("CG") = nb::int_(2);
  cls.get_class().attr("CS") = nb::int_(3);
  cls.get_class().attr("WT") = nb::int_(4);
}

// Single `register_dialects(context, load=True)` entry point that exposes
// the user-facing `wave` / `waveamd` / `wavemeta` dialects and the
// lower-level `waveamdmachine` dialect. Callers normally only need the
// first three, but we wire the fourth one too so a Python-built module
// can be round-tripped through the WaveAMDMachine pipeline without
// re-registering out-of-band.
static void bindRegisterDialects(nb::module_ &m) {
  m.def(
      "register_dialects",
      [](MlirContext ctx, bool load) {
        MlirDialectHandle wave = mlirGetDialectHandle__wave__();
        MlirDialectHandle waveamd = mlirGetDialectHandle__waveamd__();
        MlirDialectHandle waveamdmachine =
            mlirGetDialectHandle__waveamdmachine__();
        MlirDialectHandle wavemeta = mlirGetDialectHandle__wavemeta__();
        mlirDialectHandleRegisterDialect(wave, ctx);
        mlirDialectHandleRegisterDialect(waveamd, ctx);
        mlirDialectHandleRegisterDialect(waveamdmachine, ctx);
        mlirDialectHandleRegisterDialect(wavemeta, ctx);
        if (load) {
          mlirDialectHandleLoadDialect(wave, ctx);
          mlirDialectHandleLoadDialect(waveamd, ctx);
          mlirDialectHandleLoadDialect(waveamdmachine, ctx);
          mlirDialectHandleLoadDialect(wavemeta, ctx);
        }
      },
      nb::arg("context"), nb::arg("load") = true);
}

// Wire wave passes to a single Python entry point so
// `PassManager.parse("wavemeta-specialize")` (and the other wave passes)
// resolve. Idempotent on the MLIR side -- the underlying TableGen
// registration de-dups.
static void bindRegisterPasses(nb::module_ &m) {
  m.def("register_passes", []() { mlirRegisterWavePasses(); });
}

static void bindSimdType(nb::module_ &m) {
  mlir_type_subclass(m, "SimdType", mlirWaveTypeIsASimd)
      .def_classmethod(
          "get",
          [](nb::object &cls, MlirType elementType, int64_t width) {
            return cls(mlirWaveSimdTypeGet(elementType, width));
          },
          nb::arg("cls"), nb::arg("element_type"), nb::arg("width") = 32)
      .def_property_readonly(
          "element_type",
          [](MlirType self) { return mlirWaveSimdTypeGetElementType(self); })
      .def_property_readonly("width", [](MlirType self) {
        return mlirWaveSimdTypeGetWidth(self);
      });
}

static void bindMaskType(nb::module_ &m) {
  mlir_type_subclass(m, "MaskType", mlirWaveTypeIsAMask)
      .def_classmethod(
          "get",
          [](nb::object &cls, int64_t width, MlirContext ctx) {
            return cls(mlirWaveMaskTypeGet(ctx, width));
          },
          nb::arg("cls"), nb::arg("width") = 32, nb::arg("context"))
      .def_property_readonly("width", [](MlirType self) {
        return mlirWaveMaskTypeGetWidth(self);
      });
}

static void bindMemTokenType(nb::module_ &m) {
  mlir_type_subclass(m, "MemTokenType", mlirWaveTypeIsAMemToken)
      .def_classmethod(
          "get",
          [](nb::object &cls, MlirContext ctx) {
            return cls(mlirWaveMemTokenTypeGet(ctx));
          },
          nb::arg("cls"), nb::arg("context"));
}

static void bindPtrType(nb::module_ &m) {
  mlir_type_subclass(m, "PtrType", mlirWaveTypeIsAPtr)
      .def_classmethod(
          "get",
          [](nb::object &cls, nb::object first, nb::object second) {
            if (second.is_none()) {
              MlirAttribute addressSpace = nb::cast<MlirAttribute>(first);
              return cls(mlirWavePtrTypeGetOpaque(
                  mlirAttributeGetContext(addressSpace), addressSpace));
            }
            MlirType elementType = nb::cast<MlirType>(first);
            MlirAttribute addressSpace = nb::cast<MlirAttribute>(second);
            return cls(mlirWavePtrTypeGet(elementType, addressSpace));
          },
          nb::arg("cls"), nb::arg("element_or_address_space"),
          nb::arg("address_space") = nb::none())
      .def_classmethod(
          "get_opaque",
          [](nb::object &cls, MlirAttribute addressSpace) {
            return cls(mlirWavePtrTypeGetOpaque(
                mlirAttributeGetContext(addressSpace), addressSpace));
          },
          nb::arg("cls"), nb::arg("address_space"))
      .def_property_readonly("element_type",
                             [](MlirType self) -> nb::object {
                               if (!mlirWavePtrTypeHasElementType(self))
                                 return nb::none();
                               return nb::cast(
                                   mlirWavePtrTypeGetElementType(self));
                             })
      .def_property_readonly("address_space", [](MlirType self) {
        return mlirWavePtrTypeGetAddressSpace(self);
      });
}

// `get_from_node_ptr` imports Python ixsimpl nodes into the dialect store.
// `get_from_bytes` stays for durable serialized blobs.
static void bindExprAttr(nb::module_ &m) {
  mlir_attribute_subclass(m, "ExprAttr", mlirWaveAttributeIsAExpr)
      .def_classmethod(
          "get",
          [](nb::object &cls, const std::string &text, MlirContext ctx) {
            MlirStringRef ref{text.data(), text.size()};
            MlirAttribute attr = mlirWaveExprAttrGetFromText(ctx, ref);
            if (!attr.ptr)
              throw nb::value_error(
                  ("invalid wave.expr text: " + text).c_str());
            return cls(attr);
          },
          nb::arg("cls"), nb::arg("text"), nb::arg("context"))
      .def_classmethod(
          "get_from_node_ptr",
          [](nb::object &cls, uintptr_t nodePtr, MlirContext ctx) {
            MlirAttribute attr = mlirWaveExprAttrGetFromNodePtr(ctx, nodePtr);
            if (!attr.ptr)
              throw nb::value_error("failed to import wave.expr node");
            return cls(attr);
          },
          nb::arg("cls"), nb::arg("node_ptr"), nb::arg("context"))
      .def_classmethod(
          "get_from_bytes",
          [](nb::object &cls, nb::bytes data, MlirContext ctx) {
            const uint8_t *buf =
                reinterpret_cast<const uint8_t *>(data.c_str());
            MlirAttribute attr =
                mlirWaveExprAttrGetFromBytes(ctx, buf, data.size());
            if (!attr.ptr)
              throw nb::value_error("failed to deserialize wave.expr bytes");
            return cls(attr);
          },
          nb::arg("cls"), nb::arg("data"), nb::arg("context"));
}

static void bindPredAttr(nb::module_ &m) {
  mlir_attribute_subclass(m, "PredAttr", mlirWaveAttributeIsAPred)
      .def_classmethod(
          "get",
          [](nb::object &cls, const std::string &text, MlirContext ctx) {
            MlirStringRef ref{text.data(), text.size()};
            MlirAttribute attr = mlirWavePredAttrGetFromText(ctx, ref);
            if (!attr.ptr)
              throw nb::value_error(
                  ("invalid wave.pred text: " + text).c_str());
            return cls(attr);
          },
          nb::arg("cls"), nb::arg("text"), nb::arg("context"))
      .def_classmethod(
          "get_from_node_ptr",
          [](nb::object &cls, uintptr_t nodePtr, MlirContext ctx) {
            MlirAttribute attr = mlirWavePredAttrGetFromNodePtr(ctx, nodePtr);
            if (!attr.ptr)
              throw nb::value_error("failed to import wave.pred node");
            return cls(attr);
          },
          nb::arg("cls"), nb::arg("node_ptr"), nb::arg("context"))
      .def_classmethod(
          "get_from_bytes",
          [](nb::object &cls, nb::bytes data, MlirContext ctx) {
            const uint8_t *buf =
                reinterpret_cast<const uint8_t *>(data.c_str());
            MlirAttribute attr =
                mlirWavePredAttrGetFromBytes(ctx, buf, data.size());
            if (!attr.ptr)
              throw nb::value_error("failed to deserialize wave.pred bytes");
            return cls(attr);
          },
          nb::arg("cls"), nb::arg("data"), nb::arg("context"));
}

static void bindRedistributionAttr(nb::module_ &m) {
  mlir_attribute_subclass(m, "RedistributionAttr",
                          mlirWaveAttributeIsARedistribution)
      .def_classmethod(
          "get",
          [](nb::object &cls, int64_t blocks, int64_t items,
             MlirAttribute sourceBlock, MlirAttribute sourceItem,
             MlirAttribute sourceSlot) {
            return cls(mlirWaveRedistributionAttrGet(blocks, items, sourceBlock,
                                                     sourceItem, sourceSlot));
          },
          nb::arg("cls"), nb::arg("blocks"), nb::arg("items"),
          nb::arg("source_block"), nb::arg("source_item"),
          nb::arg("source_slot"))
      .def_property_readonly("blocks",
                             [](MlirAttribute self) {
                               return mlirWaveRedistributionAttrGetBlocks(self);
                             })
      .def_property_readonly("items",
                             [](MlirAttribute self) {
                               return mlirWaveRedistributionAttrGetItems(self);
                             })
      .def_property_readonly("source_block",
                             [](MlirAttribute self) {
                               return mlirWaveRedistributionAttrGetSourceBlock(
                                   self);
                             })
      .def_property_readonly("source_item",
                             [](MlirAttribute self) {
                               return mlirWaveRedistributionAttrGetSourceItem(
                                   self);
                             })
      .def_property_readonly("source_slot", [](MlirAttribute self) {
        return mlirWaveRedistributionAttrGetSourceSlot(self);
      });
}

static void bindMemoryMappingAttr(nb::module_ &m) {
  mlir_attribute_subclass(m, "MemoryMappingAttr",
                          mlirWaveAttributeIsAMemoryMapping)
      .def_classmethod(
          "get",
          [](nb::object &cls, MlirAttribute bitOffset, nb::object base,
             nb::object targetBlock) {
            MlirAttribute baseAttr{nullptr};
            MlirAttribute targetBlockAttr{nullptr};
            if (!base.is_none())
              baseAttr = nb::cast<MlirAttribute>(base);
            if (!targetBlock.is_none())
              targetBlockAttr = nb::cast<MlirAttribute>(targetBlock);
            MlirContext context = mlirAttributeGetContext(bitOffset);
            return cls(mlirWaveMemoryMappingAttrGet(context, bitOffset,
                                                    baseAttr, targetBlockAttr));
          },
          nb::arg("cls"), nb::arg("bit_offset"), nb::arg("base") = nb::none(),
          nb::arg("target_block") = nb::none())
      .def_property_readonly("base",
                             [](MlirAttribute self) -> nb::object {
                               MlirAttribute base =
                                   mlirWaveMemoryMappingAttrGetBase(self);
                               return base.ptr ? nb::cast(base) : nb::none();
                             })
      .def_property_readonly(
          "target_block",
          [](MlirAttribute self) -> nb::object {
            MlirAttribute target =
                mlirWaveMemoryMappingAttrGetTargetBlock(self);
            return target.ptr ? nb::cast(target) : nb::none();
          })
      .def_property_readonly("bit_offset", [](MlirAttribute self) {
        return mlirWaveMemoryMappingAttrGetBitOffset(self);
      });
}

static void bindFragmentType(nb::module_ &m) {
  mlir_type_subclass(m, "FragmentType", mlirWaveAMDTypeIsAFragment)
      .def_classmethod(
          "get",
          [](nb::object &cls, int64_t role, MlirType elementType, int64_t rows,
             int64_t columns, int64_t waveSize, int64_t registers,
             MlirContext ctx) {
            return cls(mlirWaveAMDFragmentTypeGet(
                ctx, role, elementType, rows, columns, waveSize, registers));
          },
          nb::arg("cls"), nb::arg("role"), nb::arg("element_type"),
          nb::arg("rows") = 16, nb::arg("columns") = 16,
          nb::arg("wave_size") = 32, nb::arg("registers") = 4,
          nb::arg("context"))
      .def_property_readonly(
          "role",
          [](MlirType self) { return mlirWaveAMDFragmentTypeGetRole(self); })
      .def_property_readonly("element_type",
                             [](MlirType self) {
                               return mlirWaveAMDFragmentTypeGetElementType(
                                   self);
                             })
      .def_property_readonly(
          "rows",
          [](MlirType self) { return mlirWaveAMDFragmentTypeGetRows(self); })
      .def_property_readonly(
          "columns",
          [](MlirType self) { return mlirWaveAMDFragmentTypeGetColumns(self); })
      .def_property_readonly("wave_size",
                             [](MlirType self) {
                               return mlirWaveAMDFragmentTypeGetWaveSize(self);
                             })
      .def_property_readonly("registers", [](MlirType self) {
        return mlirWaveAMDFragmentTypeGetRegisters(self);
      });
}

// `!wavemeta.ptuple<T, W>` constructor + accessors. The width attribute
// is passed through verbatim: callers hand in an `IntegerAttr` for a
// concrete count or a `StringAttr` for a parameter-named width.
static void bindPTupleType(nb::module_ &m) {
  mlir_type_subclass(m, "PTupleType", mlirWaveMetaTypeIsAPTuple)
      .def_classmethod(
          "get",
          [](nb::object &cls, MlirType elementType, MlirAttribute width) {
            return cls(mlirWaveMetaPTupleTypeGet(elementType, width));
          },
          nb::arg("cls"), nb::arg("element_type"), nb::arg("width"))
      .def_property_readonly("element_type",
                             [](MlirType self) {
                               return mlirWaveMetaPTupleTypeGetElementType(
                                   self);
                             })
      .def_property_readonly("width", [](MlirType self) {
        return mlirWaveMetaPTupleTypeGetWidth(self);
      });
}

NB_MODULE(_waveDialectsNanobind, m) {
  bindTargetEnums(m);
  bindTargetCapabilities(m);
  bindMmaCapabilities(m);

  bindRegisterDialects(m);
  bindRegisterPasses(m);

  // Wave types.
  bindSimdType(m);
  bindMaskType(m);
  bindMemTokenType(m);
  bindPtrType(m);

  // Wave symbolic attributes.
  bindExprAttr(m);
  bindPredAttr(m);
  bindRedistributionAttr(m);
  bindMemoryMappingAttr(m);

  // Wave address-space attributes.
  bindAddressSpaceAttr(m, "GlobalAddressSpaceAttr",
                       mlirWaveAttributeIsAGlobalAddressSpace,
                       mlirWaveGlobalAddressSpaceAttrGet);
  bindAddressSpaceAttr(m, "SharedAddressSpaceAttr",
                       mlirWaveAttributeIsASharedAddressSpace,
                       mlirWaveSharedAddressSpaceAttrGet);
  bindAddressSpaceAttr(m, "PrivateAddressSpaceAttr",
                       mlirWaveAttributeIsAPrivateAddressSpace,
                       mlirWavePrivateAddressSpaceAttrGet);

  // WaveAMD types and attributes.
  bindFragmentType(m);
  bindAddressSpaceAttr(m, "BufferAddressSpaceAttr",
                       mlirWaveAMDAttributeIsABufferAddressSpace,
                       mlirWaveAMDBufferAddressSpaceAttrGet);
  bindLoadCacheAttr(m);
  bindStoreCacheAttr(m);

  // WaveMeta types.
  bindPTupleType(m);
}
