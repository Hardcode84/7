//===- CalibrationData.cpp - HW-measured latency overlay ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"

#include "llvm/Support/Error.h"
#include "llvm/Support/JSON.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/TargetParser/TargetParser.h"

namespace mlir::waveamdmachine {

SchedClass parseSchedClassName(llvm::StringRef name) {
  for (size_t i = 0; i < static_cast<size_t>(SchedClass::NumSchedClasses);
       ++i) {
    SchedClass cls = static_cast<SchedClass>(i);
    if (getSchedClassName(cls) == name)
      return cls;
  }
  return SchedClass::NumSchedClasses;
}

static bool isaEq(const llvm::AMDGPU::IsaVersion &a,
                  const llvm::AMDGPU::IsaVersion &b) {
  return a.Major == b.Major && a.Minor == b.Minor && a.Stepping == b.Stepping;
}

namespace {
struct Parser {
  CalibrationData out;

  llvm::Error parseOneOverride(llvm::StringRef name,
                               const llvm::json::Value &value) {
    SchedClass cls = parseSchedClassName(name);
    if (cls == SchedClass::NumSchedClasses)
      return llvm::createStringError(llvm::inconvertibleErrorCode(),
                                     "unknown SchedClass name: " + name.str());
    const llvm::json::Object *obj = value.getAsObject();
    if (!obj)
      return llvm::createStringError(llvm::inconvertibleErrorCode(),
                                     "override for " + name.str() +
                                         " must be a JSON object");
    CalibrationOverride entry;
    if (auto cyc = obj->getInteger("cycles"))
      entry.cycles = static_cast<int>(*cyc);
    else
      return llvm::createStringError(llvm::inconvertibleErrorCode(),
                                     "override for " + name.str() +
                                         " missing integer 'cycles'");
    if (auto k = obj->getString("kernel"))
      entry.kernel = k->str();
    if (auto n = obj->getString("notes"))
      entry.notes = n->str();
    out.overrides.try_emplace(static_cast<int>(cls), std::move(entry));
    return llvm::Error::success();
  }

  static void readString(const llvm::json::Object &obj, llvm::StringRef key,
                         std::string &dst) {
    if (auto s = obj.getString(key))
      dst = s->str();
  }

  void readMetadata(const llvm::json::Object &obj) {
    readString(obj, "arch", out.arch);
    readString(obj, "device_name", out.deviceName);
    readString(obj, "rocm_version", out.rocmVersion);
    readString(obj, "measured_at", out.measuredAt);
    readString(obj, "notes", out.notes);
  }

  llvm::Error parseRoot(const llvm::json::Value &root) {
    const llvm::json::Object *obj = root.getAsObject();
    if (!obj)
      return llvm::createStringError(llvm::inconvertibleErrorCode(),
                                     "calibration JSON root must be an object");
    if (auto v = obj->getInteger("schema_version"); v && *v != 1)
      return llvm::createStringError(
          llvm::inconvertibleErrorCode(),
          "unsupported calibration schema_version (expected 1)");
    readMetadata(*obj);
    const llvm::json::Object *overridesObj = obj->getObject("overrides");
    if (!overridesObj)
      return llvm::Error::success();
    for (const auto &kv : *overridesObj)
      if (auto err = parseOneOverride(kv.first, kv.second))
        return err;
    return llvm::Error::success();
  }
};
} // namespace

llvm::Expected<CalibrationData>
CalibrationData::loadFromString(llvm::StringRef json) {
  llvm::Expected<llvm::json::Value> parsed = llvm::json::parse(json);
  if (!parsed)
    return parsed.takeError();
  Parser p;
  if (auto err = p.parseRoot(*parsed))
    return std::move(err);
  return std::move(p.out);
}

llvm::Expected<CalibrationData>
CalibrationData::loadFromFile(llvm::StringRef path) {
  llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> buf =
      llvm::MemoryBuffer::getFile(path);
  if (!buf)
    return llvm::createStringError(buf.getError(),
                                   "failed to read " + path.str());
  return loadFromString((*buf)->getBuffer());
}

std::optional<int> CalibrationData::getOverrideCycles(SchedClass cls) const {
  auto it = overrides.find(static_cast<int>(cls));
  if (it == overrides.end())
    return std::nullopt;
  return it->second.cycles;
}

const CalibrationOverride *CalibrationData::getOverride(SchedClass cls) const {
  auto it = overrides.find(static_cast<int>(cls));
  if (it == overrides.end())
    return nullptr;
  return &it->second;
}

bool CalibrationData::matchesArch(const ArchData &archData) const {
  if (arch.empty())
    return true;
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(arch);
  return isaEq(isa, archData.isa);
}

int getCalibratedLatency(const ArchData &arch, SchedClass cls,
                         const CalibrationData &calibration) {
  if (auto cyc = calibration.getOverrideCycles(cls))
    return *cyc;
  return getLatency(arch, cls);
}

} // namespace mlir::waveamdmachine
