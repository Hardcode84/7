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

namespace nb = nanobind;
using mlir::python::nanobind_adaptors::mlir_attribute_subclass;
using mlir::python::nanobind_adaptors::mlir_type_subclass;

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
          [](nb::object &cls, MlirType elementType,
             MlirAttribute addressSpace) {
            return cls(mlirWavePtrTypeGet(elementType, addressSpace));
          },
          nb::arg("cls"), nb::arg("element_type"), nb::arg("address_space"))
      .def_property_readonly(
          "element_type",
          [](MlirType self) { return mlirWavePtrTypeGetElementType(self); })
      .def_property_readonly("address_space", [](MlirType self) {
        return mlirWavePtrTypeGetAddressSpace(self);
      });
}

static void bindWaveIndexType(nb::module_ &m) {
  mlir_type_subclass(m, "WaveIndexType", mlirWaveTypeIsAWaveIndex)
      .def_classmethod(
          "get",
          [](nb::object &cls, int64_t width, MlirContext ctx) {
            return cls(mlirWaveWaveIndexTypeGet(ctx, width));
          },
          nb::arg("cls"), nb::arg("width") = 0, nb::arg("context"))
      .def_property_readonly("width", [](MlirType self) {
        return mlirWaveWaveIndexTypeGetWidth(self);
      });
}

// #wave.expr constructors. `get_from_bytes` is the structural path:
// callers pass the bytes produced by `ixsimpl.Context.serialize(expr)`
// and the dialect deserializes into its own symbol store via
// `ixs_deserialize_node`. `get` keeps the legacy text-parse entry
// point for callers that genuinely start from text.
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
  bindRegisterDialects(m);

  // Wave types.
  bindSimdType(m);
  bindMaskType(m);
  bindMemTokenType(m);
  bindPtrType(m);
  bindWaveIndexType(m);

  // Wave symbolic attributes.
  bindExprAttr(m);

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

  // WaveMeta types.
  bindPTupleType(m);
}
