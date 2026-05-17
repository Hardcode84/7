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
// both the user-facing `wave` / `waveamd` dialects and the lower-level
// `wavemachine` dialect. Callers normally only need the first two, but we
// wire the third one too so a Python-built module can be round-tripped
// through the WaveMachine pipeline without re-registering out-of-band.
static void bindRegisterDialects(nb::module_ &m) {
  m.def(
      "register_dialects",
      [](MlirContext ctx, bool load) {
        MlirDialectHandle wave = mlirGetDialectHandle__wave__();
        MlirDialectHandle waveamd = mlirGetDialectHandle__waveamd__();
        MlirDialectHandle wavemachine = mlirGetDialectHandle__wavemachine__();
        mlirDialectHandleRegisterDialect(wave, ctx);
        mlirDialectHandleRegisterDialect(waveamd, ctx);
        mlirDialectHandleRegisterDialect(wavemachine, ctx);
        if (load) {
          mlirDialectHandleLoadDialect(wave, ctx);
          mlirDialectHandleLoadDialect(waveamd, ctx);
          mlirDialectHandleLoadDialect(wavemachine, ctx);
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

// Text constructor for #wave.expr. Python passes the canonical ixsimpl
// source text; the dialect-owned store hash-conses it, so equal text
// returns pointer-equal attribute handles.
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
          nb::arg("cls"), nb::arg("text"), nb::arg("context"));
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
}
