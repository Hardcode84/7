//===- AMDGPU.cpp - WaveAMDMachine to AMDGPU backend
//-------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Target/Wave/AMDGPU.h"

#include "MCTargetDesc/AMDGPUMCTargetDesc.h"
#include "SIDefines.h"
#include "Utils/AMDGPUBaseInfo.h"
#include "lld/Common/Driver.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Dialect/Transform/Transforms/TransformInterpreterUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveAMDABI.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDEntryRegs.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDExecIfUtils.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/OwningOpRef.h"
#include "mlir/Target/LLVM/ROCDL/Utils.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallBitVector.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/ADT/bit.h"
#include "llvm/Config/Targets.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/AMDHSAKernelDescriptor.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/FileUtilities.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/SaveAndRestore.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"
#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <cstdlib>
#include <limits>
#include <optional>
#include <variant>

LLD_HAS_DRIVER(elf)

using namespace mlir;

namespace {

static constexpr llvm::StringLiteral kDefaultTargetTriple = "amdgcn-amd-amdhsa";
static constexpr llvm::StringLiteral kDefaultTargetChip = "gfx1100";
static constexpr llvm::StringLiteral kPrivateSegmentFixedSizeAttr =
    "waveamdmachine.private_segment_fixed_size";
static constexpr llvm::StringLiteral kUsesFlatScratchAttr =
    "waveamdmachine.uses_flat_scratch";
static constexpr llvm::StringLiteral kSGPRSpillCountAttr =
    "waveamdmachine.sgpr_spill_count";
static constexpr llvm::StringLiteral kVGPRSpillCountAttr =
    "waveamdmachine.vgpr_spill_count";
static constexpr llvm::StringLiteral kMemoryCacheAttrName = "cache";

static constexpr unsigned kSdwaUnusedPad = 0;
static constexpr unsigned kSdwaWord1 = 5;
static constexpr unsigned kSdwaDword = 6;

static bool isSupportedBackendTarget(const llvm::AMDGPU::IsaVersion &isa,
                                     llvm::AMDGPU::GPUKind kind) {
  return isa.Major == 8 || isa.Major == 9 || isa.Major == 11 ||
         kind == llvm::AMDGPU::GK_GFX1250;
}

static bool isGfx950(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 5 && isa.Stepping == 0;
}

static bool isGfx940PlusIsa(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 &&
         (isa.Minor == 4 || (isa.Minor == 5 && isa.Stepping == 0));
}

static LogicalResult
checkSupportedBackendTarget(ModuleOp module, StringRef triple, StringRef chip,
                            const llvm::AMDGPU::IsaVersion &isa,
                            llvm::AMDGPU::GPUKind kind) {
  if (isa.Major == 0)
    return module.emitError("unsupported AMDGPU target: ")
           << triple << "--" << chip;
  if (!isSupportedBackendTarget(isa, kind))
    return module.emitError("wave AMDGPU backend does not support target: ")
           << triple << "--" << chip
           << " (supported targets: gfx8, gfx9, gfx11, gfx1250)";
  return success();
}

static LogicalResult
checkSupportedBackendTarget(ModuleOp module, StringRef triple, StringRef chip) {
  return checkSupportedBackendTarget(module, triple, chip,
                                     llvm::AMDGPU::getIsaVersion(chip),
                                     llvm::AMDGPU::parseArchAMDGCN(chip));
}

struct KernelArgInfo {
  std::string name;
  unsigned offset = 0;
  unsigned size = 0;
  bool isGlobalBuffer = false;
};

struct KernelMetadataEntryInfo {
  std::string name;
  std::string value;
};

struct KernelInfo {
  std::string name;
  SmallVector<KernelArgInfo> args;
  SmallVector<KernelMetadataEntryInfo> metadataEntries;
  unsigned kernargSize = 0;
  unsigned sgprCount = 0;
  unsigned vgprCount = 0;
  unsigned agprCount = 0;
  unsigned sgprSpillCount = 0;
  unsigned vgprSpillCount = 0;
  unsigned maxFlatWorkgroupSize = 1024;
  unsigned fixedLdsSize = 0;
  unsigned privateSegmentFixedSize = 0;
};

static bool isMetadataKeyChar(char c) {
  return ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') ||
         ('0' <= c && c <= '9') || c == '_' || c == '-' || c == '.';
}

static LogicalResult validateMetadataKey(Operation *diagOp, StringRef name) {
  if (name.empty())
    return diagOp->emitError("waveamdmachine.metadata entry name is empty");
  if (name.starts_with("."))
    return diagOp->emitError("waveamdmachine.metadata entry `")
           << name << "` uses reserved HSA metadata key namespace";
  if (llvm::all_of(name, isMetadataKeyChar))
    return success();
  return diagOp->emitError("waveamdmachine.metadata entry `")
         << name << "` has unsupported YAML key characters";
}

static LogicalResult printMetadataString(Operation *diagOp, StringRef value,
                                         raw_ostream &os) {
  os << '"';
  for (char c : value) {
    switch (c) {
    case '"':
    case '\\':
      os << '\\' << c;
      break;
    case '\n':
    case '\r':
    case '\t':
      return diagOp->emitError(
          "waveamdmachine.metadata string values cannot contain control "
          "characters");
    default:
      os << c;
      break;
    }
  }
  os << '"';
  return success();
}

static LogicalResult printMetadataValue(Operation *diagOp, Attribute attr,
                                        raw_ostream &os) {
  if (auto boolAttr = dyn_cast<BoolAttr>(attr)) {
    os << (boolAttr.getValue() ? "true" : "false");
    return success();
  }
  if (auto intAttr = dyn_cast<IntegerAttr>(attr)) {
    os << intAttr.getInt();
    return success();
  }
  if (auto stringAttr = dyn_cast<StringAttr>(attr))
    return printMetadataString(diagOp, stringAttr.getValue(), os);
  return diagOp->emitError()
         << "waveamdmachine.metadata entry values must be integer, bool, or "
            "string attributes";
}

static FailureOr<SmallVector<KernelMetadataEntryInfo>>
collectKernelMetadataEntries(func::FuncOp func) {
  FailureOr<SmallVector<waveamdmachine::KernelMetadataEntry>> entries =
      waveamdmachine::getKernelMetadataEntries(func);
  if (failed(entries))
    return failure();

  SmallVector<KernelMetadataEntryInfo> out;
  DenseSet<StringRef> seen;
  out.reserve(entries->size());
  for (const waveamdmachine::KernelMetadataEntry &entry : *entries) {
    StringRef name = entry.name.getValue();
    if (failed(validateMetadataKey(func, name)))
      return failure();
    if (!seen.insert(name).second)
      return func.emitError("duplicate waveamdmachine.metadata entry `")
             << name << "`";
    std::string value;
    llvm::raw_string_ostream valueOS(value);
    if (failed(printMetadataValue(func, entry.value, valueOS)))
      return failure();
    out.push_back({name.str(), valueOS.str()});
  }
  return out;
}

struct KernelRegisterUsage {
  unsigned vgprCount = 0;
  unsigned agprCount = 0;
};

struct KernelEntryValueUsage {
  bool workgroupIdX = false;
  bool workgroupIdY = false;
  bool workgroupIdZ = false;
  unsigned maxWorkitemIdAxis = 0;
};

struct BufferedMCInstruction {
  llvm::MCInst inst;
  Operation *origin = nullptr;
  size_t bufferId = 0;
  unsigned indent = 0;
  bool synthetic = false;
};

struct BufferedMCLine {
  std::string text;
  unsigned indent = 0;
};

struct BufferedMCLabel {
  llvm::MCSymbol *symbol = nullptr;
};

struct BufferedMCAlign {
  unsigned log2 = 0;
};

using BufferedMCItem = std::variant<BufferedMCInstruction, BufferedMCLine,
                                    BufferedMCLabel, BufferedMCAlign>;

struct PackedDelayAluSpan {
  SmallVector<size_t> skippedIds;
  size_t delayId = 0;
  size_t targetId = 0;
  unsigned id0 = 0;
  unsigned id1 = 0;
};

static constexpr std::array<unsigned, 4> kVGPRWindowModeFieldMasks = {
    static_cast<unsigned>(llvm::AMDGPU::Hwreg::SRC0_VGPR_MSB),
    static_cast<unsigned>(llvm::AMDGPU::Hwreg::SRC1_VGPR_MSB),
    static_cast<unsigned>(llvm::AMDGPU::Hwreg::SRC2_VGPR_MSB),
    static_cast<unsigned>(llvm::AMDGPU::Hwreg::DST_VGPR_MSB)};
static constexpr unsigned kVGPRWindowFieldCount =
    kVGPRWindowModeFieldMasks.size();
static constexpr unsigned kVGPRWindowModeRegisterShift =
    llvm::countr_zero_constexpr<unsigned>(
        static_cast<unsigned>(llvm::AMDGPU::Hwreg::VGPR_MSB_MASK));
static constexpr unsigned kVGPRWindowModeWidth =
    llvm::popcount(static_cast<unsigned>(llvm::AMDGPU::Hwreg::VGPR_MSB_MASK));
static constexpr unsigned kVGPRWindowFieldWidth =
    llvm::popcount(static_cast<unsigned>(llvm::AMDGPU::Hwreg::DST_VGPR_MSB));
static constexpr unsigned kVGPRWindowModeMask =
    static_cast<unsigned>(llvm::AMDGPU::Hwreg::VGPR_MSB_MASK) >>
    kVGPRWindowModeRegisterShift;
static constexpr unsigned kVGPRWindowModeRotation =
    llvm::countr_zero_constexpr<unsigned>(
        static_cast<unsigned>(llvm::AMDGPU::Hwreg::SRC0_VGPR_MSB)) -
    kVGPRWindowModeRegisterShift;
static constexpr unsigned kSClauseMaxLength =
    llvm::maskTrailingOnes<unsigned>(waveamdmachine::kSClauseLengthBits);
static constexpr unsigned kSClauseBreakMask =
    llvm::maskTrailingOnes<unsigned>(waveamdmachine::kSClauseBreakBits);

static constexpr unsigned getVGPRWindowFieldShift(unsigned modeFieldMask) {
  unsigned modeOffset =
      llvm::countr_zero_constexpr(modeFieldMask) - kVGPRWindowModeRegisterShift;
  return (modeOffset + kVGPRWindowModeWidth - kVGPRWindowModeRotation) %
         kVGPRWindowModeWidth;
}

static constexpr unsigned convertVGPRWindowModeToSetreg(unsigned mode) {
  if (!kVGPRWindowModeRotation)
    return mode & kVGPRWindowModeMask;
  return ((mode << kVGPRWindowModeRotation) |
          (mode >> (kVGPRWindowModeWidth - kVGPRWindowModeRotation))) &
         kVGPRWindowModeMask;
}

struct VGPRWindowMode {
  std::array<std::optional<unsigned>, kVGPRWindowFieldCount> fields;

  bool update(const VGPRWindowMode &newMode, bool &rewritten) {
    bool updated = false;
    for (unsigned field : llvm::seq<unsigned>(0, kVGPRWindowFieldCount)) {
      if (!newMode.fields[field])
        continue;
      if (*newMode.fields[field] != fields[field].value_or(0)) {
        updated = true;
        rewritten |= fields[field].has_value();
      }
      fields[field] = newMode.fields[field];
    }
    return updated;
  }

  unsigned encode() const {
    unsigned value = 0;
    for (unsigned field : llvm::seq<unsigned>(0, kVGPRWindowFieldCount))
      value |= fields[field].value_or(0)
               << getVGPRWindowFieldShift(kVGPRWindowModeFieldMasks[field]);
    return value;
  }

  static VGPRWindowMode concrete(unsigned value) {
    VGPRWindowMode mode;
    unsigned fieldMask =
        llvm::maskTrailingOnes<unsigned>(kVGPRWindowFieldWidth);
    for (unsigned field : llvm::seq<unsigned>(0, kVGPRWindowFieldCount))
      mode.fields[field] =
          (value >> getVGPRWindowFieldShift(kVGPRWindowModeFieldMasks[field])) &
          fieldMask;
    return mode;
  }
};

struct VGPRWindowClauseState {
  std::optional<size_t> itemIndex;
  unsigned length = 0;
  unsigned remaining = 0;
  unsigned breaks = 0;

  void clear() {
    itemIndex.reset();
    length = 0;
    remaining = 0;
    breaks = 0;
  }
};

#include "AMDGPUOpcodes.def"

struct AMDGPUOpcodeSet {
#define WAVE_AMDGPU_OPCODE_FIELD(name, pseudoOpcode, viOpcode, gfx11Opcode)    \
  unsigned name = 0;
  WAVE_AMDGPU_OPCODE_LIST(WAVE_AMDGPU_OPCODE_FIELD)
#undef WAVE_AMDGPU_OPCODE_FIELD
};

static unsigned resolveMCOpcode(unsigned pseudoOpcode, unsigned family,
                                const llvm::MCSubtargetInfo &sti) {
  int32_t opcode = llvm::AMDGPU::getMCOpcode(pseudoOpcode, family);
  if (opcode == llvm::AMDGPU::INSTRUCTION_LIST_END &&
      llvm::AMDGPU::isGFX1250(sti))
    opcode =
        llvm::AMDGPU::getMCOpcode(pseudoOpcode, llvm::SIEncodingFamily::GFX12);
  if (opcode == -1)
    return pseudoOpcode;
  return static_cast<unsigned>(opcode);
}

static AMDGPUOpcodeSet makeAMDGPUOpcodeSet(const llvm::AMDGPU::IsaVersion &isa,
                                           const llvm::MCSubtargetInfo &sti) {
  bool useVIEncoding = isa.Major == 8 || isa.Major == 9;
  bool useGfx1250Encoding = llvm::AMDGPU::isGFX1250(sti);
  AMDGPUOpcodeSet opcodes;
#define WAVE_AMDGPU_OPCODE_INIT(name, pseudoOpcode, viOpcode, gfx11Opcode)     \
  if (useVIEncoding)                                                           \
    opcodes.name = static_cast<unsigned>(llvm::AMDGPU::viOpcode);              \
  else if (useGfx1250Encoding)                                                 \
    opcodes.name = resolveMCOpcode(llvm::AMDGPU::pseudoOpcode,                 \
                                   llvm::SIEncodingFamily::GFX1250, sti);      \
  else                                                                         \
    opcodes.name = static_cast<unsigned>(llvm::AMDGPU::gfx11Opcode);
  WAVE_AMDGPU_OPCODE_LIST(WAVE_AMDGPU_OPCODE_INIT)
#undef WAVE_AMDGPU_OPCODE_INIT
  return opcodes;
}

#undef WAVE_AMDGPU_OPCODE_LIST

static_assert(llvm::AMDGPU::SGPR1 == llvm::AMDGPU::SGPR0 + 1,
              "SGPR enum layout must be contiguous");
static_assert(llvm::AMDGPU::SGPR2_SGPR3 == llvm::AMDGPU::SGPR0_SGPR1 + 1,
              "SGPR pair enum layout must be contiguous");
static_assert(llvm::AMDGPU::SGPR4_SGPR5_SGPR6_SGPR7 ==
                  llvm::AMDGPU::SGPR0_SGPR1_SGPR2_SGPR3 + 1,
              "SGPR quad enum layout must be contiguous");
static_assert(
    llvm::AMDGPU::SGPR4_SGPR5_SGPR6_SGPR7_SGPR8_SGPR9_SGPR10_SGPR11 ==
        llvm::AMDGPU::SGPR0_SGPR1_SGPR2_SGPR3_SGPR4_SGPR5_SGPR6_SGPR7 + 1,
    "SGPR octuple enum layout must be contiguous");
static_assert(llvm::AMDGPU::VGPR1 == llvm::AMDGPU::VGPR0 + 1,
              "VGPR enum layout must be contiguous");
static_assert(llvm::AMDGPU::VGPR1_LO16 == llvm::AMDGPU::VGPR0_LO16 + 1,
              "VGPR_LO16 enum layout must be contiguous");
static_assert(llvm::AMDGPU::VGPR1_VGPR2 == llvm::AMDGPU::VGPR0_VGPR1 + 1,
              "VGPR pair enum layout must be contiguous");
static_assert(llvm::AMDGPU::VGPR1_VGPR2_VGPR3 ==
                  llvm::AMDGPU::VGPR0_VGPR1_VGPR2 + 1,
              "VGPR triple enum layout must be contiguous");
static_assert(llvm::AMDGPU::VGPR1_VGPR2_VGPR3_VGPR4 ==
                  llvm::AMDGPU::VGPR0_VGPR1_VGPR2_VGPR3 + 1,
              "VGPR quad enum layout must be contiguous");
static_assert(
    llvm::AMDGPU::VGPR1_VGPR2_VGPR3_VGPR4_VGPR5_VGPR6_VGPR7_VGPR8 ==
        llvm::AMDGPU::VGPR0_VGPR1_VGPR2_VGPR3_VGPR4_VGPR5_VGPR6_VGPR7 + 1,
    "VGPR octuple enum layout must be contiguous");
static_assert(
    llvm::AMDGPU::
            VGPR1_VGPR2_VGPR3_VGPR4_VGPR5_VGPR6_VGPR7_VGPR8_VGPR9_VGPR10_VGPR11_VGPR12_VGPR13_VGPR14_VGPR15_VGPR16 ==
        llvm::AMDGPU::
                VGPR0_VGPR1_VGPR2_VGPR3_VGPR4_VGPR5_VGPR6_VGPR7_VGPR8_VGPR9_VGPR10_VGPR11_VGPR12_VGPR13_VGPR14_VGPR15 +
            1,
    "VGPR 16-tuple enum layout must be contiguous");
static_assert(llvm::AMDGPU::AGPR1 == llvm::AMDGPU::AGPR0 + 1,
              "AGPR enum layout must be contiguous");
static_assert(llvm::AMDGPU::AGPR1_AGPR2 == llvm::AMDGPU::AGPR0_AGPR1 + 1,
              "AGPR pair enum layout must be contiguous");
static_assert(llvm::AMDGPU::AGPR1_AGPR2_AGPR3 ==
                  llvm::AMDGPU::AGPR0_AGPR1_AGPR2 + 1,
              "AGPR triple enum layout must be contiguous");
static_assert(llvm::AMDGPU::AGPR1_AGPR2_AGPR3_AGPR4 ==
                  llvm::AMDGPU::AGPR0_AGPR1_AGPR2_AGPR3 + 1,
              "AGPR quad enum layout must be contiguous");
static_assert(
    llvm::AMDGPU::AGPR1_AGPR2_AGPR3_AGPR4_AGPR5_AGPR6_AGPR7_AGPR8 ==
        llvm::AMDGPU::AGPR0_AGPR1_AGPR2_AGPR3_AGPR4_AGPR5_AGPR6_AGPR7 + 1,
    "AGPR octuple enum layout must be contiguous");
static_assert(
    llvm::AMDGPU::
            AGPR1_AGPR2_AGPR3_AGPR4_AGPR5_AGPR6_AGPR7_AGPR8_AGPR9_AGPR10_AGPR11_AGPR12_AGPR13_AGPR14_AGPR15_AGPR16 ==
        llvm::AMDGPU::
                AGPR0_AGPR1_AGPR2_AGPR3_AGPR4_AGPR5_AGPR6_AGPR7_AGPR8_AGPR9_AGPR10_AGPR11_AGPR12_AGPR13_AGPR14_AGPR15 +
            1,
    "AGPR 16-tuple enum layout must be contiguous");

class WaveAMDGPUEmitter {
public:
  explicit WaveAMDGPUEmitter(raw_ostream &os) : os(os) {}

  LogicalResult emit(Operation *op) {
    auto module = dyn_cast<ModuleOp>(op);
    if (!module)
      return op->emitError("wave AMDGPU backend expects a module operation");
    if (failed(initializeMC(op)))
      return failure();
    if (failed(verifyAGPRTargetSupport(module)))
      return failure();
    if (failed(wave::verifyWaveAMDRegAllocations(
            module, "wave-to-amdgpu-asm",
            wave::WaveAMDRegAllocVerificationScope::AllValues)))
      return failure();

    os << "\t.text\n";
    os << "\t.amdgcn_target \"" << getTargetID() << "\"\n";
    os << "\t.amdhsa_code_object_version 6\n";
    SmallVector<func::FuncOp> funcs;
    for (func::FuncOp func : module.getOps<func::FuncOp>()) {
      if (!func.isExternal())
        funcs.push_back(func);
    }
    module.walk([&](gpu::GPUModuleOp gpuModule) {
      for (func::FuncOp func : gpuModule.getOps<func::FuncOp>()) {
        if (!func.isExternal() &&
            func->hasAttr(wave::WaveDialect::getKernelAttrName()))
          funcs.push_back(func);
      }
    });
    for (func::FuncOp func : funcs) {
      if (failed(emitFunction(func)))
        return failure();
    }
    return emitMetadata();
  }

private:
  raw_ostream &os;
  std::unique_ptr<llvm::MCRegisterInfo> mri;
  std::unique_ptr<llvm::MCAsmInfo> mai;
  std::unique_ptr<llvm::MCInstrInfo> mcii;
  std::unique_ptr<llvm::MCSubtargetInfo> sti;
  std::unique_ptr<llvm::MCContext> mcContext;
  std::unique_ptr<llvm::MCInstPrinter> instPrinter;
  SmallVector<KernelInfo> kernels;
  SmallVector<BufferedMCItem> mcBuffer;
  std::optional<waveamdmachine::AMDGPUTargetCapabilities> targetCapabilities;
  llvm::AMDGPU::IsaVersion isaVersion;
  llvm::AMDGPU::GPUKind targetKind = llvm::AMDGPU::GK_NONE;
  AMDGPUOpcodeSet opcodes;
  std::string targetTriple = kDefaultTargetTriple.str();
  std::string targetChip = kDefaultTargetChip.str();
  std::string targetFeatures;
  unsigned wavefrontSize = 32;
  unsigned indent = 1;
  // Per-function structured-control state.
  unsigned loopCounter = 0;
  unsigned ifCounter = 0;
  unsigned execIfCounter = 0;
  unsigned dmaIssueDelayCounter = 0;
  unsigned execIfSaveBase = 0;
  unsigned execIfSaveCursor = 0;
  std::string funcLabelPrefix;
  Operation *emissionSource = nullptr;
  bool bufferingMC = false;

  LogicalResult initializeMC(Operation *op) {
    static llvm::once_flag initializeBackendOnce;
    llvm::call_once(initializeBackendOnce, []() {
      llvm::InitializeAllTargetInfos();
      llvm::InitializeAllTargetMCs();
      llvm::InitializeAllAsmPrinters();
      // The `wave-compile-kernels` pass round-trips through MC asm parsing
      // (`ROCDL::assembleIsa`), so the asm parser needs registering too.
      llvm::InitializeAllAsmParsers();
    });
    auto module = dyn_cast<ModuleOp>(op);
    if (!module)
      module = op->getParentOfType<ModuleOp>();
    if (!module)
      return op->emitError("wave AMDGPU backend expects a module operation");

    auto targetAttr =
        module->getAttrOfType<StringAttr>("waveamdmachine.target");
    if (targetAttr) {
      FailureOr<waveamdmachine::AMDGPUTarget> target =
          waveamdmachine::parseAMDGPUTargetAttr(
              targetAttr.getValue(), [&]() { return module.emitError(); });
      if (failed(target))
        return failure();
      targetTriple = target->triple;
      targetChip = target->chip;
      targetFeatures = target->features;
    }

    llvm::Triple triple(targetTriple);
    std::string error;
    const llvm::Target *target =
        llvm::TargetRegistry::lookupTarget(triple, error);
    if (!target)
      return op->emitError("failed to lookup AMDGPU target: ") << error;
    llvm::MCTargetOptions mcOptions;
    isaVersion = llvm::AMDGPU::getIsaVersion(targetChip);
    targetKind = llvm::AMDGPU::parseArchAMDGCN(targetChip);
    if (failed(checkSupportedBackendTarget(module, targetTriple, targetChip,
                                           isaVersion, targetKind)))
      return failure();
    std::optional<unsigned> defaultWavefrontSize =
        waveamdmachine::getAMDGPUDefaultWavefrontSize(targetChip);
    if (!defaultWavefrontSize)
      return module.emitError("unsupported AMDGPU target: ")
             << targetTriple << "--" << targetChip;
    wavefrontSize = *defaultWavefrontSize;
    if (targetAttr) {
      FailureOr<unsigned> targetWavefrontSize =
          waveamdmachine::getAMDGPUWavefrontSize(module, "wave-to-amdgpu-asm");
      if (failed(targetWavefrontSize))
        return failure();
      wavefrontSize = *targetWavefrontSize;
    }
    FailureOr<std::string> features =
        waveamdmachine::getAMDGPUAssemblerFeatures(module, "",
                                                   "wave-to-amdgpu-asm");
    if (failed(features))
      return failure();
    mri.reset(target->createMCRegInfo(triple));
    mai.reset(target->createMCAsmInfo(*mri, triple, mcOptions));
    mcii.reset(target->createMCInstrInfo());
    sti.reset(target->createMCSubtargetInfo(triple, targetChip, *features));
    if (!sti)
      return module.emitError("unsupported AMDGPU target: ")
             << targetTriple << "--" << targetChip;
    targetCapabilities = waveamdmachine::getAMDGPUTargetCapabilities(*sti);
    opcodes = makeAMDGPUOpcodeSet(isaVersion, *sti);
    mcContext = std::make_unique<llvm::MCContext>(triple, *mai, *mri, *sti);
    unsigned asmVariant = mai->getOutputAssemblerDialect();
    instPrinter.reset(
        target->createMCInstPrinter(triple, asmVariant, *mai, *mcii, *mri));
    if (!instPrinter)
      return op->emitError("failed to create AMDGPU MCInstPrinter");
    return success();
  }

  bool isGfx8Or9() const {
    return isaVersion.Major == 8 || isaVersion.Major == 9;
  }
  bool isGfx11() const { return isaVersion.Major == 11; }
  bool isGfx1250() const { return targetKind == llvm::AMDGPU::GK_GFX1250; }
  bool hasVGPRWindowing() const {
    return sti->hasFeature(llvm::AMDGPU::Feature1024AddressableVGPRs);
  }
  bool hasSetregVGPRMSBFixup() const {
    if (targetCapabilities)
      return targetCapabilities->setregVGPRMSBFixup;
    return sti->hasFeature(llvm::AMDGPU::FeatureSetregVGPRMSBFixup);
  }
  bool isGfx90APlus() const { return llvm::AMDGPU::isGFX90A(*sti); }
  bool isGfx940Plus() const { return isGfx940PlusIsa(isaVersion); }
  bool hasAGPRs() const { return waveamdmachine::supportsAGPRs(isaVersion); }
  bool hasArchitectedSGPRs() const {
    if (targetCapabilities)
      return targetCapabilities->architectedSGPRs;
    return sti->hasFeature(llvm::AMDGPU::FeatureArchitectedSGPRs);
  }
  bool hasClusters() const {
    if (targetCapabilities)
      return targetCapabilities->clusters;
    return sti->hasFeature(llvm::AMDGPU::FeatureClusters);
  }
  bool requiresInitialUnclausedVmem() const {
    if (targetCapabilities)
      return targetCapabilities->requiresInitialUnclausedVmem;
    return sti->hasFeature(llvm::AMDGPU::FeatureRequiresInitialUnclausedVmem);
  }
  bool hasWaitXcnt() const {
    if (targetCapabilities)
      return targetCapabilities->waitXcnt;
    return sti->hasFeature(llvm::AMDGPU::FeatureWaitXcnt);
  }
  bool rejectLegacyVMemToLDS() const { return llvm::AMDGPU::isGFX1250(*sti); }
  bool usesSplitWaitCounters() const {
    if (targetCapabilities)
      return targetCapabilities->waitCounterFamily ==
             waveamdmachine::WaitCounterFamily::Gfx12Split;
    return llvm::AMDGPU::isGFX12Plus(*sti);
  }
  bool supportsPrivateSegmentEnable() const {
    if (targetCapabilities)
      return targetCapabilities->kernelDescriptor.architectedPrivateSegment;
    return llvm::AMDGPU::hasArchitectedFlatScratch(*sti);
  }
  bool supportsDescriptorDX10AndIEEE() const {
    if (targetCapabilities)
      return targetCapabilities->kernelDescriptor.dx10ClampAndIEEEMode;
    return sti->hasFeature(llvm::AMDGPU::FeatureDX10ClampAndIEEEMode);
  }
  bool supportsDescriptorWGPMode() const {
    if (targetCapabilities)
      return targetCapabilities->kernelDescriptor.wgpMode;
    return llvm::AMDGPU::supportsWGP(*sti);
  }
  bool supportsMetadataWGPMode() const {
    return isGfx8Or9() || supportsDescriptorWGPMode();
  }
  bool supportsDescriptorSharedVGPRCount() const {
    if (targetCapabilities)
      return targetCapabilities->kernelDescriptor.sharedVGPRCount;
    return llvm::AMDGPU::isGFX10_GFX11(*sti);
  }
  bool supportsDescriptorRoundRobin() const {
    if (targetCapabilities)
      return targetCapabilities->kernelDescriptor.roundRobin;
    return llvm::AMDGPU::isGFX12Plus(*sti);
  }
  bool supportsDescriptorNamedBarrierCount() const {
    if (targetCapabilities)
      return targetCapabilities->kernelDescriptor.namedBarrierCount;
    return llvm::AMDGPU::isGFX1250Plus(*sti);
  }
  unsigned postVIOpcode(unsigned pseudoOpcode) const {
    unsigned family = isGfx1250() ? llvm::SIEncodingFamily::GFX1250
                                  : llvm::SIEncodingFamily::GFX11;
    return resolveMCOpcode(pseudoOpcode, family, *sti);
  }

  unsigned sMovB32() const { return opcodes.sMovB32; }
  unsigned sAddI32() const { return opcodes.sAddI32; }
  unsigned sMulI32() const { return opcodes.sMulI32; }
  unsigned sLshlB32() const { return opcodes.sLshlB32; }
  unsigned sLshrB32() const { return opcodes.sLshrB32; }
  unsigned sAshrI32() const { return opcodes.sAshrI32; }
  unsigned sLshrB64() const { return opcodes.sLshrB64; }
  unsigned sAshrI64() const { return opcodes.sAshrI64; }
  unsigned sFf1I32B32() const { return opcodes.sFf1I32B32; }
  unsigned sFf1I32B64() const { return opcodes.sFf1I32B64; }
  unsigned sFlbitI32B32() const { return opcodes.sFlbitI32B32; }
  unsigned sFlbitI32B64() const { return opcodes.sFlbitI32B64; }
  unsigned sAndB32() const { return opcodes.sAndB32; }
  unsigned sAndB64() const { return opcodes.sAndB64; }
  unsigned sOrB32() const { return opcodes.sOrB32; }
  unsigned sOrB64() const { return opcodes.sOrB64; }
  unsigned sXorB32() const { return opcodes.sXorB32; }
  unsigned sXorB64() const { return opcodes.sXorB64; }
  unsigned sAndn2B32() const { return opcodes.sAndn2B32; }
  unsigned sAndn2B64() const { return opcodes.sAndn2B64; }
  unsigned sAndSaveexecB64() const { return opcodes.sAndSaveexecB64; }
  unsigned sMovB64() const { return opcodes.sMovB64; }
  unsigned sAddU32() const { return opcodes.sAddU32; }
  unsigned sAddcU32() const { return opcodes.sAddcU32; }
  unsigned sMulHiU32() const { return opcodes.sMulHiU32; }
  unsigned sCmpEqI32() const { return opcodes.sCmpEqI32; }
  unsigned sCmpLgI32() const { return opcodes.sCmpLgI32; }
  unsigned sCmpGtI32() const { return opcodes.sCmpGtI32; }
  unsigned sCmpGeI32() const { return opcodes.sCmpGeI32; }
  unsigned sCmpLtI32() const { return opcodes.sCmpLtI32; }
  unsigned sCmpLeI32() const { return opcodes.sCmpLeI32; }
  unsigned sCmpEqU32() const { return opcodes.sCmpEqU32; }
  unsigned sCmpLgU32() const { return opcodes.sCmpLgU32; }
  unsigned sCmpGtU32() const { return opcodes.sCmpGtU32; }
  unsigned sCmpGeU32() const { return opcodes.sCmpGeU32; }
  unsigned sCmpLtU32() const { return opcodes.sCmpLtU32; }
  unsigned sCmpLeU32() const { return opcodes.sCmpLeU32; }
  unsigned sCmpEqU64() const { return opcodes.sCmpEqU64; }
  unsigned sCmpLgU64() const { return opcodes.sCmpLgU64; }
  unsigned sCselectB32() const { return opcodes.sCselectB32; }
  unsigned sBranch() const { return opcodes.sBranch; }
  unsigned sCbranchScc0() const { return opcodes.sCbranchScc0; }
  unsigned sCbranchScc1() const { return opcodes.sCbranchScc1; }
  unsigned sCbranchVccnz() const { return opcodes.sCbranchVccnz; }
  unsigned sCbranchExecz() const { return opcodes.sCbranchExecz; }
  unsigned sGetregB32() const { return opcodes.sGetregB32; }
  unsigned sSetregImm32B32() const { return opcodes.sSetregImm32B32; }
  unsigned sLoadB32() const { return opcodes.sLoadB32; }
  unsigned sLoadB64() const { return opcodes.sLoadB64; }
  unsigned sLoadB128() const { return opcodes.sLoadB128; }
  unsigned sLoadB256() const { return opcodes.sLoadB256; }
  unsigned sWaitcnt() const { return opcodes.sWaitcnt; }
  unsigned sWaitAlu() const {
    return postVIOpcode(llvm::AMDGPU::S_WAITCNT_DEPCTR);
  }
  unsigned sNop() const { return opcodes.sNop; }
  unsigned sDelayAlu() const { return postVIOpcode(llvm::AMDGPU::S_DELAY_ALU); }
  unsigned sSleep() const { return opcodes.sSleep; }
  unsigned sSetprio() const { return opcodes.sSetprio; }
  unsigned sSendmsg() const { return opcodes.sSendmsg; }
  unsigned sBarrier() const { return opcodes.sBarrier; }
  unsigned sEndpgm() const { return opcodes.sEndpgm; }
  unsigned sSetpcB64() const { return opcodes.sSetpcB64; }
  unsigned vMbcntLo() const { return opcodes.vMbcntLo; }
  unsigned vMbcntHi() const { return opcodes.vMbcntHi; }
  unsigned vNop() const { return opcodes.vNop; }
  unsigned vMovB32() const { return opcodes.vMovB32; }
  unsigned vMovB64() const { return opcodes.vMovB64; }
  unsigned vCndmaskB32() const { return opcodes.vCndmaskB32; }
  unsigned vCndmaskB32Vcc() const { return opcodes.vCndmaskB32Vcc; }
  unsigned vAndB32() const { return opcodes.vAndB32; }
  unsigned vOrB32() const { return opcodes.vOrB32; }
  unsigned vXorB32() const { return opcodes.vXorB32; }
  unsigned vLshlrevB32() const { return opcodes.vLshlrevB32; }
  unsigned vLshrrevB32() const { return opcodes.vLshrrevB32; }
  unsigned vAshrrevI32() const { return opcodes.vAshrrevI32; }
  unsigned vLshrrevB64() const { return opcodes.vLshrrevB64; }
  unsigned vAshrrevI64() const { return opcodes.vAshrrevI64; }
  unsigned vFfbhU32() const { return opcodes.vFfbhU32; }
  unsigned vFfblB32() const { return opcodes.vFfblB32; }
  unsigned vReadfirstlaneB32() const { return opcodes.vReadfirstlaneB32; }
  unsigned vMulLoU32() const { return opcodes.vMulLoU32; }
  unsigned vMulHiU32() const { return opcodes.vMulHiU32; }
  unsigned vAdd3U32() const { return opcodes.vAdd3U32; }
  unsigned vBfeU32() const { return opcodes.vBfeU32; }
  unsigned vMadI32I24() const { return opcodes.vMadI32I24; }
  unsigned vMadU32U24() const { return opcodes.vMadU32U24; }
  unsigned vLshlAddU32() const { return opcodes.vLshlAddU32; }
  unsigned vAddLshlU32() const { return opcodes.vAddLshlU32; }
  unsigned vAndOrB32() const { return opcodes.vAndOrB32; }
  unsigned vOr3B32() const { return opcodes.vOr3B32; }
  unsigned vXadU32() const { return opcodes.vXadU32; }
  unsigned vPermB32() const { return opcodes.vPermB32; }
  unsigned vPermlane32SwapB32() const {
    assert(waveamdmachine::VPermlane32SwapB32TupleOp::isSupportedOnIsa(
               isaVersion) &&
           "v_permlane32_swap_b32 requires supported target");
    return llvm::AMDGPU::V_PERMLANE32_SWAP_B32_e32_gfx9;
  }
  unsigned vBitOp3B32() const { return opcodes.vBitOp3B32; }
  unsigned vAddF32() const { return opcodes.vAddF32; }
  unsigned vSubF32() const { return opcodes.vSubF32; }
  unsigned vMulF32() const { return opcodes.vMulF32; }
  unsigned vFmaF32() const { return opcodes.vFmaF32; }
  unsigned vMaxF32() const { return opcodes.vMaxF32; }
  unsigned vMax3F32() const { return opcodes.vMax3F32; }
  unsigned vExpF32() const { return opcodes.vExpF32; }
  unsigned vRcpF32() const { return opcodes.vRcpF32; }
  unsigned vRcpIFlagF32() const { return opcodes.vRcpIFlagF32; }
  unsigned vCvtF32U32() const { return opcodes.vCvtF32U32; }
  unsigned vCvtU32F32() const { return opcodes.vCvtU32F32; }
  unsigned vCvtF16F32() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_CVT_F16_F32_e64_vi;
    return postVIOpcode(llvm::AMDGPU::V_CVT_F16_F32_t16_e64);
  }
  unsigned vCvtF32F16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_CVT_F32_F16_e64_vi;
    return postVIOpcode(llvm::AMDGPU::V_CVT_F32_F16_t16_e64);
  }
  unsigned vCvtF32F16E32() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_CVT_F32_F16_e32_vi;
    llvm_unreachable("v_cvt_f32_f16_e32 requires gfx8/gfx9");
  }
  unsigned vCvtF32F16Sdwa() const {
    if (isaVersion.Major == 8)
      return llvm::AMDGPU::V_CVT_F32_F16_sdwa_vi;
    if (isaVersion.Major == 9)
      return llvm::AMDGPU::V_CVT_F32_F16_sdwa_gfx9;
    llvm_unreachable("v_cvt_f32_f16_sdwa requires gfx8/gfx9");
  }
  bool usesTrue16Cvt() const {
    return sti->hasFeature(llvm::AMDGPU::FeatureTrue16BitInsts);
  }
  bool supportsCvtPkRtzF16F32() const {
    return isGfx8Or9() || sti->hasFeature(llvm::AMDGPU::FeatureVOP3PInsts);
  }
  bool supportsCvtPkF16F32() const {
    return waveamdmachine::supportsCvtPkF16F32Inst(isaVersion);
  }
  bool supportsCvtPkBF16F32() const {
    return waveamdmachine::supportsCvtPkBF16F32Inst(isaVersion);
  }
  bool supportsPackedF16() const {
    return sti->hasFeature(llvm::AMDGPU::FeatureVOP3PInsts);
  }
  bool supportsPackedF32() const {
    return isGfx8Or9() || sti->hasFeature(llvm::AMDGPU::FeaturePackedFP32Ops);
  }
  unsigned vCvtPkRtzF16F32() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_CVT_PKRTZ_F16_F32_e64_vi;
    return postVIOpcode(llvm::AMDGPU::V_CVT_PKRTZ_F16_F32_e32);
  }
  unsigned vCvtPkF16F32() const {
    if (isaVersion.Major == 13)
      return llvm::AMDGPU::V_CVT_PK_F16_F32_e64_gfx13;
    if (isGfx1250())
      return postVIOpcode(llvm::AMDGPU::V_CVT_PK_F16_F32_e64);
    return llvm::AMDGPU::V_CVT_PK_F16_F32_gfx9;
  }
  unsigned vCvtPkBF16F32() const {
    if (isaVersion.Major == 13)
      return llvm::AMDGPU::V_CVT_PK_BF16_F32_e64_gfx13;
    if (isGfx1250())
      return postVIOpcode(llvm::AMDGPU::V_CVT_PK_BF16_F32_e64);
    return llvm::AMDGPU::V_CVT_PK_BF16_F32_vi;
  }
  unsigned vPkAddF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_ADD_F16_vi;
    return postVIOpcode(llvm::AMDGPU::V_PK_ADD_F16);
  }
  unsigned vPkMulF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_MUL_F16_vi;
    return postVIOpcode(llvm::AMDGPU::V_PK_MUL_F16);
  }
  unsigned vPkFmaF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_FMA_F16_vi;
    return postVIOpcode(llvm::AMDGPU::V_PK_FMA_F16);
  }
  unsigned vPkAddF32() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_ADD_F32_vi;
    if (isGfx1250())
      return postVIOpcode(llvm::AMDGPU::V_PK_ADD_F32);
    llvm_unreachable("v_pk_add_f32 is unsupported on this ISA");
  }
  unsigned vPkMulF32() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_MUL_F32_vi;
    if (isGfx1250())
      return postVIOpcode(llvm::AMDGPU::V_PK_MUL_F32);
    llvm_unreachable("v_pk_mul_f32 is unsupported on this ISA");
  }
  unsigned vPkFmaF32() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_FMA_F32_vi;
    if (isGfx1250())
      return postVIOpcode(llvm::AMDGPU::V_PK_FMA_F32);
    llvm_unreachable("v_pk_fma_f32 is unsupported on this ISA");
  }
  unsigned vCmpEqF32() const { return opcodes.vCmpEqF32; }
  unsigned vCmpLtF32() const { return opcodes.vCmpLtF32; }
  unsigned vCmpLeF32() const { return opcodes.vCmpLeF32; }
  unsigned vCmpGtF32() const { return opcodes.vCmpGtF32; }
  unsigned vCmpGeF32() const { return opcodes.vCmpGeF32; }
  unsigned vCmpEqU32() const { return opcodes.vCmpEqU32; }
  unsigned vCmpNeU32() const { return opcodes.vCmpNeU32; }
  unsigned vCmpLtU32() const { return opcodes.vCmpLtU32; }
  unsigned vCmpLeU32() const { return opcodes.vCmpLeU32; }
  unsigned vCmpGtU32() const { return opcodes.vCmpGtU32; }
  unsigned vCmpGeU32() const { return opcodes.vCmpGeU32; }
  unsigned vCmpLtI32() const { return opcodes.vCmpLtI32; }
  unsigned vCmpLeI32() const { return opcodes.vCmpLeI32; }
  unsigned vCmpGtI32() const { return opcodes.vCmpGtI32; }
  unsigned vCmpGeI32() const { return opcodes.vCmpGeI32; }
  unsigned vCmpxEqU32() const { return opcodes.vCmpxEqU32; }
  unsigned vCmpxNeU32() const { return opcodes.vCmpxNeU32; }
  unsigned vCmpxLtU32() const { return opcodes.vCmpxLtU32; }
  unsigned vCmpxLeU32() const { return opcodes.vCmpxLeU32; }
  unsigned vCmpxGtU32() const { return opcodes.vCmpxGtU32; }
  unsigned vCmpxGeU32() const { return opcodes.vCmpxGeU32; }
  unsigned vCmpxLtI32() const { return opcodes.vCmpxLtI32; }
  unsigned vCmpxLeI32() const { return opcodes.vCmpxLeI32; }
  unsigned vCmpxGtI32() const { return opcodes.vCmpxGtI32; }
  unsigned vCmpxGeI32() const { return opcodes.vCmpxGeI32; }
  unsigned mfmaF32_16x16x16F16(bool agprCD) const {
    if (isGfx940Plus())
      return agprCD ? llvm::AMDGPU::V_MFMA_F32_16X16X16F16_gfx940_acd
                    : llvm::AMDGPU::V_MFMA_F32_16X16X16F16_gfx940_vcd;
    return agprCD ? llvm::AMDGPU::V_MFMA_F32_16X16X16F16_gfx90a_acd
                  : llvm::AMDGPU::V_MFMA_F32_16X16X16F16_gfx90a_vcd;
  }
  unsigned mfmaF32_16x16x16BF16(bool agprCD) const {
    return agprCD ? llvm::AMDGPU::V_MFMA_F32_16X16X16BF16_1K_gfx940_acd
                  : llvm::AMDGPU::V_MFMA_F32_16X16X16BF16_1K_gfx940_vcd;
  }
  unsigned mfmaF32_16x16x32F16(bool agprCD) const {
    return agprCD ? llvm::AMDGPU::V_MFMA_F32_16X16X32_F16_gfx940_acd
                  : llvm::AMDGPU::V_MFMA_F32_16X16X32_F16_gfx940_vcd;
  }
  unsigned mfmaF32_16x16x32BF16(bool agprCD) const {
    return agprCD ? llvm::AMDGPU::V_MFMA_F32_16X16X32_BF16_gfx940_acd
                  : llvm::AMDGPU::V_MFMA_F32_16X16X32_BF16_gfx940_vcd;
  }
  unsigned mfmaF32_32x32x16F16(bool agprCD) const {
    return agprCD ? llvm::AMDGPU::V_MFMA_F32_32X32X16_F16_gfx940_acd
                  : llvm::AMDGPU::V_MFMA_F32_32X32X16_F16_gfx940_vcd;
  }
  unsigned mfmaF32_32x32x16BF16(bool agprCD) const {
    return agprCD ? llvm::AMDGPU::V_MFMA_F32_32X32X16_BF16_gfx940_acd
                  : llvm::AMDGPU::V_MFMA_F32_32X32X16_BF16_gfx940_vcd;
  }
  unsigned mfmaScaleF32_16x16x128F4F4(bool agprCD) const {
    return agprCD ? llvm::AMDGPU::
                        V_MFMA_SCALE_F32_16X16X128_F8F6F4_f4_f4_gfx940_acd
                  : llvm::AMDGPU::
                        V_MFMA_SCALE_F32_16X16X128_F8F6F4_f4_f4_gfx940_vcd;
  }
  unsigned mfmaScaleF32_32x32x64F4F4(bool agprCD) const {
    return agprCD
               ? llvm::AMDGPU::V_MFMA_SCALE_F32_32X32X64_F8F6F4_f4_f4_gfx940_acd
               : llvm::AMDGPU::
                     V_MFMA_SCALE_F32_32X32X64_F8F6F4_f4_f4_gfx940_vcd;
  }

  unsigned vAccvgprReadB32() const {
    return llvm::AMDGPU::V_ACCVGPR_READ_B32_vi;
  }

  unsigned vAccvgprWriteB32() const {
    return llvm::AMDGPU::V_ACCVGPR_WRITE_B32_vi;
  }

  unsigned bufferStoreB32() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_STORE_DWORD_OFFEN_gfx90a;
    return opcodes.bufferStoreB32;
  }

  unsigned globalPrefetchB8() const { return opcodes.globalPrefetchB8; }

  unsigned sSetVgprMsb() const {
    return postVIOpcode(llvm::AMDGPU::S_SET_VGPR_MSB);
  }
  unsigned sClause() const { return postVIOpcode(llvm::AMDGPU::S_CLAUSE); }
  unsigned sWaitXcnt() const { return postVIOpcode(llvm::AMDGPU::S_WAIT_XCNT); }

  unsigned bufferStoreB8() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_STORE_BYTE_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_STORE_BYTE_OFFEN_vi;
    return postVIOpcode(llvm::AMDGPU::BUFFER_STORE_BYTE_OFFEN);
  }

  unsigned bufferStoreB16() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_vi;
    return postVIOpcode(llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN);
  }

  unsigned bufferLoadB32() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_DWORD_OFFEN_gfx90a;
    return opcodes.bufferLoadB32;
  }

  unsigned bufferLoadU8() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_UBYTE_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_LOAD_UBYTE_OFFEN_vi;
    return postVIOpcode(llvm::AMDGPU::BUFFER_LOAD_UBYTE_OFFEN);
  }

  unsigned bufferLoadU8D16() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_UBYTE_D16_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_LOAD_UBYTE_D16_OFFEN_vi;
    return postVIOpcode(llvm::AMDGPU::BUFFER_LOAD_UBYTE_D16_OFFEN);
  }

  unsigned bufferLoadU8D16Hi() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_UBYTE_D16_HI_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_LOAD_UBYTE_D16_HI_OFFEN_vi;
    return postVIOpcode(llvm::AMDGPU::BUFFER_LOAD_UBYTE_D16_HI_OFFEN);
  }

  unsigned bufferLoadI8() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_SBYTE_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_LOAD_SBYTE_OFFEN_vi;
    return postVIOpcode(llvm::AMDGPU::BUFFER_LOAD_SBYTE_OFFEN);
  }

  unsigned bufferLoadB16() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_vi;
    return postVIOpcode(llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN);
  }

  unsigned globalStoreB32() const { return opcodes.globalStoreB32; }

  unsigned globalStoreB8() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_BYTE_SADDR_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_STORE_BYTE_SADDR);
  }

  unsigned globalStoreB32Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_DWORD_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_STORE_DWORD);
  }

  unsigned globalStoreB8Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_BYTE_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_STORE_BYTE);
  }

  unsigned globalStoreB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR);
  }

  unsigned globalStoreB16Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_STORE_SHORT);
  }

  unsigned globalLoadB32() const { return opcodes.globalLoadB32; }

  unsigned globalAtomicAddSaddrRtnU32() const {
    if (usesSplitWaitCounters())
      return postVIOpcode(llvm::AMDGPU::GLOBAL_ATOMIC_ADD_SADDR_RTN);
    return llvm::AMDGPU::GLOBAL_ATOMIC_ADD_SADDR_RTN_vi;
  }

  unsigned globalLoadU8() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_UBYTE_SADDR_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_LOAD_UBYTE_SADDR);
  }

  unsigned globalLoadI8() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_SBYTE_SADDR_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_LOAD_SBYTE_SADDR);
  }

  unsigned globalLoadB32Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_DWORD_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_LOAD_DWORD);
  }

  unsigned globalLoadU8Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_UBYTE_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_LOAD_UBYTE);
  }

  unsigned globalLoadI8Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_SBYTE_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_LOAD_SBYTE);
  }

  unsigned globalLoadB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR);
  }

  unsigned globalLoadB16Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_vi;
    return postVIOpcode(llvm::AMDGPU::GLOBAL_LOAD_USHORT);
  }

  unsigned globalLoadB64() const { return opcodes.globalLoadB64; }
  unsigned globalLoadB96() const { return opcodes.globalLoadB96; }
  unsigned globalLoadB128() const { return opcodes.globalLoadB128; }
  unsigned globalLoadB64Addr64() const { return opcodes.globalLoadB64Addr64; }
  unsigned globalLoadB96Addr64() const { return opcodes.globalLoadB96Addr64; }
  unsigned globalLoadB128Addr64() const { return opcodes.globalLoadB128Addr64; }
  unsigned globalStoreB64() const { return opcodes.globalStoreB64; }
  unsigned globalStoreB96() const { return opcodes.globalStoreB96; }
  unsigned globalStoreB128() const { return opcodes.globalStoreB128; }
  unsigned globalStoreB64Addr64() const { return opcodes.globalStoreB64Addr64; }
  unsigned globalStoreB96Addr64() const { return opcodes.globalStoreB96Addr64; }
  unsigned globalStoreB128Addr64() const {
    return opcodes.globalStoreB128Addr64;
  }
  unsigned bufferLoadB64() const { return opcodes.bufferLoadB64; }
  unsigned bufferLoadB96() const { return opcodes.bufferLoadB96; }
  unsigned bufferLoadB128() const { return opcodes.bufferLoadB128; }
  unsigned bufferStoreB64() const { return opcodes.bufferStoreB64; }
  unsigned bufferStoreB96() const { return opcodes.bufferStoreB96; }
  unsigned bufferStoreB128() const { return opcodes.bufferStoreB128; }
  unsigned dsReadB64() const { return opcodes.dsReadB64; }
  unsigned dsReadB64TrB4() const { return opcodes.dsReadB64TrB4; }
  unsigned dsReadB96TrB6() const { return opcodes.dsReadB96TrB6; }
  unsigned dsReadB64TrB8() const { return opcodes.dsReadB64TrB8; }
  unsigned dsReadB64TrB16() const { return opcodes.dsReadB64TrB16; }
  unsigned dsReadB96() const { return opcodes.dsReadB96; }
  unsigned dsReadB128() const { return opcodes.dsReadB128; }
  unsigned dsRead2B32() const { return opcodes.dsRead2B32; }
  unsigned dsRead2B64() const { return opcodes.dsRead2B64; }
  unsigned dsRead2St64B32() const { return opcodes.dsRead2St64B32; }
  unsigned dsRead2St64B64() const { return opcodes.dsRead2St64B64; }
  unsigned dsWriteB8() const { return opcodes.dsWriteB8; }
  unsigned dsWriteB64() const { return opcodes.dsWriteB64; }
  unsigned dsWriteB96() const { return opcodes.dsWriteB96; }
  unsigned dsWriteB128() const { return opcodes.dsWriteB128; }
  unsigned dsWrite2B32() const { return opcodes.dsWrite2B32; }
  unsigned dsWrite2B64() const { return opcodes.dsWrite2B64; }
  unsigned dsWrite2St64B32() const { return opcodes.dsWrite2St64B32; }
  unsigned dsWrite2St64B64() const { return opcodes.dsWrite2St64B64; }

  unsigned globalLoadLdsB32() const {
    return isGfx90APlus() ? llvm::AMDGPU::GLOBAL_LOAD_LDS_DWORD_SADDR_gfx940
                          : llvm::AMDGPU::GLOBAL_LOAD_LDS_DWORD_SADDR_vi;
  }

  unsigned globalLoadLdsB128() const {
    return isGfx90APlus() ? llvm::AMDGPU::GLOBAL_LOAD_LDS_DWORDX4_SADDR_gfx940
                          : llvm::AMDGPU::GLOBAL_LOAD_LDS_DWORDX4_SADDR_vi;
  }

  unsigned bufferLoadLdsB32() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_DWORD_LDS_OFFEN_gfx90a;
    return opcodes.bufferLoadLdsB32;
  }

  unsigned bufferLoadLdsB128() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_DWORDX4_LDS_OFFEN_gfx90a;
    return llvm::AMDGPU::BUFFER_LOAD_DWORDX4_LDS_OFFEN_vi;
  }

  unsigned dsReadB32() const { return opcodes.dsReadB32; }
  unsigned dsReadAddTidB32() const { return opcodes.dsReadAddTidB32; }
  unsigned dsSwizzleB32() const { return opcodes.dsSwizzleB32; }
  unsigned dsPermuteB32() const { return opcodes.dsPermuteB32; }
  unsigned dsBpermuteB32() const { return opcodes.dsBpermuteB32; }
  unsigned dsAddU32() const { return opcodes.dsAddU32; }
  unsigned dsAddRtnU32() const { return opcodes.dsAddRtnU32; }

  unsigned dsReadU8() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::DS_READ_U8_vi_gfx9;
    return postVIOpcode(llvm::AMDGPU::DS_READ_U8_gfx9);
  }

  unsigned dsReadI8() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::DS_READ_I8_vi_gfx9;
    return postVIOpcode(llvm::AMDGPU::DS_READ_I8_gfx9);
  }

  unsigned dsReadB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::DS_READ_U16_vi_gfx9;
    return postVIOpcode(llvm::AMDGPU::DS_READ_U16_gfx9);
  }

  unsigned dsWriteB32() const { return opcodes.dsWriteB32; }
  unsigned dsWriteAddTidB32() const { return opcodes.dsWriteAddTidB32; }

  unsigned scratchLoadB32Saddr() const { return opcodes.scratchLoadB32; }

  unsigned scratchLoadB32Ve() const {
    if (isGfx940Plus())
      return llvm::AMDGPU::SCRATCH_LOAD_DWORD_VE_gfx940;
    return postVIOpcode(llvm::AMDGPU::SCRATCH_LOAD_DWORD);
  }

  unsigned scratchLoadB32Svs() const {
    if (isGfx940Plus())
      return llvm::AMDGPU::SCRATCH_LOAD_DWORD_SVS_gfx940;
    return postVIOpcode(llvm::AMDGPU::SCRATCH_LOAD_DWORD_SVS);
  }

  unsigned scratchStoreB32Saddr() const { return opcodes.scratchStoreB32; }

  unsigned scratchStoreB32Ve() const {
    if (isGfx940Plus())
      return llvm::AMDGPU::SCRATCH_STORE_DWORD_VE_gfx940;
    return postVIOpcode(llvm::AMDGPU::SCRATCH_STORE_DWORD);
  }

  unsigned scratchStoreB32Svs() const {
    if (isGfx940Plus())
      return llvm::AMDGPU::SCRATCH_STORE_DWORD_SVS_gfx940;
    return postVIOpcode(llvm::AMDGPU::SCRATCH_STORE_DWORD_SVS);
  }

  unsigned dsWriteB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::DS_WRITE_B16_vi_gfx9;
    return postVIOpcode(llvm::AMDGPU::DS_WRITE_B16_gfx9);
  }

  std::optional<unsigned> getImmediate(Value value) const {
    if (auto imm = value.getDefiningOp<waveamdmachine::ImmOp>())
      return static_cast<unsigned>(imm.getValue());
    return std::nullopt;
  }

  LogicalResult requireConstantBus(Operation &op, StringRef mnemonic,
                                   ArrayRef<Value> operands) const {
    return waveamdmachine::requireConstantBus(
        &op, mnemonic, operands, isaVersion, targetChip,
        [](Value lhs, Value rhs) {
          return waveamdmachine::isSamePhysicalReg(lhs, rhs);
        });
  }

  LogicalResult requireOperandLegality(Operation &op,
                                       StringRef mnemonic) const {
    auto legality = cast<waveamdmachine::OperandLegalityOpInterface>(op);
    return waveamdmachine::requireOperandLegality(
        &op, mnemonic, legality.getOperandLegality(), isaVersion, targetChip,
        [](Value lhs, Value rhs) {
          return waveamdmachine::isSamePhysicalReg(lhs, rhs);
        });
  }

  void emitLine(StringRef line) {
    if (bufferingMC) {
      mcBuffer.push_back(BufferedMCLine{line.str(), indent});
      return;
    }
    for (unsigned i = 0; i < indent; ++i)
      os << '\t';
    os << line << '\n';
  }

  void emitLine(const Twine &line) {
    SmallString<128> storage;
    emitLine(line.toStringRef(storage));
  }

  void emitLabel(StringRef name) {
    llvm::MCSymbol *symbol = mcContext->getOrCreateSymbol(name);
    if (bufferingMC) {
      mcBuffer.push_back(BufferedMCLabel{symbol});
      return;
    }
    os << symbol->getName() << ":\n";
  }

  void emitAlign(unsigned log2) {
    if (bufferingMC) {
      mcBuffer.push_back(BufferedMCAlign{log2});
      return;
    }
    os << "\t.p2align\t" << log2 << "\n";
  }

  void printIndent(unsigned count) {
    for (unsigned i = 0; i < count; ++i)
      os << '\t';
  }

  bool isModeSetreg(const llvm::MCInst &inst) const {
    if (inst.getOpcode() != sSetregImm32B32())
      return false;
    int simm16Index = llvm::AMDGPU::getNamedOperandIdx(
        inst.getOpcode(), llvm::AMDGPU::OpName::simm16);
    if (simm16Index < 0 ||
        static_cast<unsigned>(simm16Index) >= inst.getNumOperands())
      return false;
    const llvm::MCOperand &simm16 = inst.getOperand(simm16Index);
    if (!simm16.isImm())
      return false;
    return std::get<0>(llvm::AMDGPU::Hwreg::HwregEncoding::decode(
               simm16.getImm())) == llvm::AMDGPU::Hwreg::ID_MODE;
  }

  int getVGPRWindowOperandIndex(unsigned opcode,
                                const llvm::AMDGPU::OpName *table,
                                unsigned field) const {
    if (!table || table[field] == llvm::AMDGPU::OpName::NUM_OPERAND_NAMES)
      return -1;
    return llvm::AMDGPU::getNamedOperandIdx(opcode, table[field]);
  }

  bool hasUnsupportedVGPRWindowMapping(const llvm::MCInstrDesc &desc) const {
    return llvm::SIInstrFlags::isMIMG(desc) ||
           llvm::SIInstrFlags::isVSAMPLE(desc) ||
           llvm::SIInstrFlags::isEXP(desc);
  }

  std::optional<unsigned> getVGPRWindowMSBs(const llvm::MCInst &inst,
                                            const llvm::AMDGPU::OpName *table,
                                            unsigned field) const {
    int index = getVGPRWindowOperandIndex(inst.getOpcode(), table, field);
    if (index < 0 || static_cast<unsigned>(index) >= inst.getNumOperands())
      return std::nullopt;
    const llvm::MCInstrDesc &desc = mcii->get(inst.getOpcode());
    if (static_cast<unsigned>(index) >= desc.getNumOperands())
      return std::nullopt;
    // Concrete VOP3 MC src2 is encoded; LLVM skips shrinkable pre-MC pseudos.
    if (table[field] == llvm::AMDGPU::OpName::src2 &&
        llvm::SIInstrFlags::isVOP2(desc) &&
        static_cast<unsigned>(index) >= desc.getNumDefs() &&
        desc.getOperandConstraint(index, llvm::MCOI::TIED_TO) >= 0)
      return std::nullopt;
    const llvm::MCOperand &operand = inst.getOperand(index);
    if (!operand.isReg())
      return std::nullopt;
    llvm::MCRegister reg = operand.getReg();
    if (!llvm::AMDGPU::getVGPRPhysRegClass(reg, *mri))
      return std::nullopt;
    return llvm::AMDGPU::getVGPREncodingMSBs(reg, *mri);
  }

  FailureOr<VGPRWindowMode>
  computeVGPRWindowMode(const BufferedMCInstruction &instruction) const {
    const llvm::MCInst &inst = instruction.inst;
    const llvm::MCInstrDesc &desc = mcii->get(inst.getOpcode());
    Operation *origin =
        instruction.origin ? instruction.origin : emissionSource;
    if (hasUnsupportedVGPRWindowMapping(desc)) {
      for (auto [index, operand] : llvm::enumerate(inst)) {
        if (!operand.isReg() ||
            !llvm::AMDGPU::getVGPRPhysRegClass(operand.getReg(), *mri) ||
            llvm::AMDGPU::getVGPREncodingMSBs(operand.getReg(), *mri) == 0)
          continue;
        origin->emitError("LLVM VGPR-window mapping is unavailable for ")
            << mcii->getName(inst.getOpcode()) << " emitted by "
            << origin->getName() << ": operand " << index << " has MSBs "
            << llvm::AMDGPU::getVGPREncodingMSBs(operand.getReg(), *mri);
        return failure();
      }
      return VGPRWindowMode();
    }

    auto [primary, secondary] =
        llvm::AMDGPU::getVGPRLoweringOperandTables(desc);
    VGPRWindowMode mode;
    unsigned fieldMask =
        llvm::maskTrailingOnes<unsigned>(kVGPRWindowFieldWidth);
    for (unsigned field : llvm::seq<unsigned>(0, kVGPRWindowFieldCount)) {
      std::optional<unsigned> primaryMSBs =
          getVGPRWindowMSBs(inst, primary, field);
      std::optional<unsigned> secondaryMSBs =
          getVGPRWindowMSBs(inst, secondary, field);
      if (primaryMSBs && secondaryMSBs && primaryMSBs != secondaryMSBs) {
        int primaryIndex =
            getVGPRWindowOperandIndex(inst.getOpcode(), primary, field);
        int secondaryIndex =
            getVGPRWindowOperandIndex(inst.getOpcode(), secondary, field);
        origin->emitError("incompatible VGPR windows for ")
            << mcii->getName(inst.getOpcode()) << " emitted by "
            << origin->getName() << ": field " << field << ", operands "
            << primaryIndex << '/' << secondaryIndex << " have MSBs "
            << *primaryMSBs << '/' << *secondaryMSBs;
        return failure();
      }
      mode.fields[field] = primaryMSBs ? primaryMSBs : secondaryMSBs;
      if (mode.fields[field] && *mode.fields[field] > fieldMask) {
        origin->emitError("VGPR window for ")
            << mcii->getName(inst.getOpcode()) << " field " << field
            << " exceeds LLVM selector encoding";
        return failure();
      }
    }
    return mode;
  }

  bool isVGPRWindowProgramStateInstruction(const llvm::MCInst &inst) const {
    unsigned opcode = inst.getOpcode();
    return opcode == sWaitcnt() || opcode == sWaitAlu() ||
           opcode == sDelayAlu() || opcode == sBarrier() ||
           opcode == sWaitXcnt() ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_LOADCNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_LOADCNT_DSCNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_STORECNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_STORECNT_DSCNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_SAMPLECNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_BVHCNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_EXPCNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_DSCNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_KMCNT) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_WAIT_IDLE) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_BARRIER_SIGNAL_IMM) ||
           opcode == postVIOpcode(llvm::AMDGPU::S_BARRIER_WAIT);
  }

  size_t getVGPRWindowInsertionPoint(ArrayRef<BufferedMCItem> finalized,
                                     size_t before) const {
    size_t insertion = before;
    size_t cursor = before;
    while (cursor != 0) {
      const BufferedMCItem &item = finalized[cursor - 1];
      if (const auto *instruction = std::get_if<BufferedMCInstruction>(&item)) {
        if (!isVGPRWindowProgramStateInstruction(instruction->inst))
          break;
        insertion = cursor - 1;
        --cursor;
        continue;
      }
      if (std::holds_alternative<BufferedMCLabel>(item) ||
          std::holds_alternative<BufferedMCAlign>(item))
        break;
      --cursor;
    }
    return insertion;
  }

  const BufferedMCInstruction *
  getPreviousMCInstruction(ArrayRef<BufferedMCItem> finalized,
                           size_t insertion) const {
    while (insertion != 0) {
      --insertion;
      if (const auto *instruction =
              std::get_if<BufferedMCInstruction>(&finalized[insertion]))
        return instruction;
    }
    return nullptr;
  }

  static void trackBufferedInsert(std::optional<size_t> &tracked,
                                  size_t insertion) {
    if (tracked && *tracked >= insertion)
      ++*tracked;
  }

  static void trackBufferedErase(std::optional<size_t> &tracked,
                                 size_t erased) {
    if (!tracked)
      return;
    if (*tracked == erased) {
      tracked.reset();
      return;
    }
    if (*tracked > erased)
      --*tracked;
  }

  FailureOr<size_t>
  prepareVGPRWindowClauseInsertion(SmallVectorImpl<BufferedMCItem> &finalized,
                                   std::optional<size_t> &mostRecentModeSet,
                                   VGPRWindowClauseState &clause,
                                   Operation *origin) const {
    if (!clause.remaining)
      return getVGPRWindowInsertionPoint(finalized, finalized.size());
    if (!clause.itemIndex) {
      origin->emitError("missing buffered s_clause");
      return failure();
    }
    if (clause.remaining == clause.length)
      return getVGPRWindowInsertionPoint(finalized, *clause.itemIndex);

    size_t clauseIndex = *clause.itemIndex;
    if (clause.breaks) {
      finalized.erase(finalized.begin() + clauseIndex);
      trackBufferedErase(mostRecentModeSet, clauseIndex);
      clause.clear();
      return getVGPRWindowInsertionPoint(finalized, finalized.size());
    }

    auto *clauseInstruction =
        std::get_if<BufferedMCInstruction>(&finalized[clauseIndex]);
    if (!clauseInstruction ||
        clauseInstruction->inst.getOpcode() != sClause() ||
        clauseInstruction->inst.getNumOperands() != 1 ||
        !clauseInstruction->inst.getOperand(0).isImm()) {
      origin->emitError("malformed buffered s_clause");
      return failure();
    }
    if (clause.length < kSClauseMaxLength)
      clauseInstruction->inst.getOperand(0).setImm(
          clause.length |
          (clause.breaks << waveamdmachine::kSClauseBreakShift));
    ++clause.length;
    return getVGPRWindowInsertionPoint(finalized, finalized.size());
  }

  BufferedMCInstruction
  makeImmediateMCInstruction(unsigned opcode, int64_t immediate,
                             Operation *origin,
                             unsigned instructionIndent) const {
    llvm::MCInst inst;
    inst.setOpcode(opcode);
    inst.addOperand(llvm::MCOperand::createImm(immediate));
    return {inst, origin, /*bufferId=*/0, instructionIndent,
            /*synthetic=*/true};
  }

  FailureOr<std::optional<size_t>>
  getClauseCoveringInstruction(ArrayRef<BufferedMCItem> items,
                               size_t targetIndex) const {
    std::optional<size_t> clauseIndex;
    unsigned remaining = 0;
    for (size_t index = 0; index <= targetIndex; ++index) {
      if (std::holds_alternative<BufferedMCLabel>(items[index])) {
        if (remaining)
          return emissionSource->emitError("s_clause crosses a label");
        continue;
      }
      const auto *instruction =
          std::get_if<BufferedMCInstruction>(&items[index]);
      if (!instruction || instruction->synthetic)
        continue;
      if (instruction->inst.getOpcode() == sClause()) {
        Operation *origin =
            instruction->origin ? instruction->origin : emissionSource;
        if (remaining)
          return origin->emitError("nested s_clause is unsupported");
        if (instruction->inst.getNumOperands() != 1 ||
            !instruction->inst.getOperand(0).isImm())
          return origin->emitError("malformed LLVM MC operands for s_clause");
        int64_t immediate = instruction->inst.getOperand(0).getImm();
        unsigned validMask =
            kSClauseMaxLength |
            (kSClauseBreakMask << waveamdmachine::kSClauseBreakShift);
        if (immediate < 0 ||
            (static_cast<uint64_t>(immediate) & ~uint64_t(validMask)) != 0)
          return origin->emitError("invalid s_clause immediate");
        unsigned encodedLength = immediate & kSClauseMaxLength;
        if (encodedLength == 0 || encodedLength == kSClauseMaxLength)
          return origin->emitError("invalid s_clause length");
        clauseIndex = index;
        remaining = encodedLength + 1;
        if (index == targetIndex)
          return std::optional<size_t>();
        continue;
      }
      if (index == targetIndex)
        return remaining ? clauseIndex : std::optional<size_t>();
      if (remaining && --remaining == 0)
        clauseIndex.reset();
    }
    return std::optional<size_t>();
  }

  FailureOr<SmallVector<PackedDelayAluSpan>>
  collectPackedDelayAluSpans(ArrayRef<BufferedMCItem> items) const {
    // LLVM exposes SDelayALU as a raw immediate; mirror its MC parser domain.
    constexpr unsigned id0Mask = 0xf;
    constexpr unsigned skipShift = 4;
    constexpr unsigned skipMask = 0x7;
    constexpr unsigned id1Shift = 7;
    constexpr unsigned id1Mask = 0xf;
    constexpr unsigned maxPackedSkip = 5;
    constexpr unsigned numInstructionIds = 12;
    constexpr unsigned packedMask =
        id0Mask | (skipMask << skipShift) | (id1Mask << id1Shift);

    SmallVector<PackedDelayAluSpan> spans;
    for (size_t delayIndex = 0; delayIndex < items.size(); ++delayIndex) {
      const auto *delay =
          std::get_if<BufferedMCInstruction>(&items[delayIndex]);
      if (!delay || delay->inst.getOpcode() != sDelayAlu() ||
          delay->inst.getNumOperands() != 1 ||
          !delay->inst.getOperand(0).isImm())
        continue;

      int64_t immediate = delay->inst.getOperand(0).getImm();
      Operation *origin = delay->origin ? delay->origin : emissionSource;
      if (immediate < 0 ||
          (static_cast<uint64_t>(immediate) & ~uint64_t(packedMask)) != 0)
        return origin->emitError("invalid packed s_delay_alu immediate");
      unsigned id0 = immediate & id0Mask;
      unsigned id1 = (immediate >> id1Shift) & id1Mask;
      if (id0 >= numInstructionIds || id1 >= numInstructionIds)
        return origin->emitError("invalid packed s_delay_alu instruction ID");
      if (!id1)
        continue;
      unsigned skip = (immediate >> skipShift) & skipMask;
      if (skip > maxPackedSkip)
        return origin->emitError("invalid packed s_delay_alu skip");

      PackedDelayAluSpan span;
      span.delayId = delay->bufferId;
      span.id0 = id0;
      span.id1 = id1;
      unsigned remaining = skip;
      for (size_t index = delayIndex + 1; index < items.size(); ++index) {
        if (std::holds_alternative<BufferedMCLabel>(items[index]))
          return origin->emitError("packed s_delay_alu crosses a label");
        const auto *instruction =
            std::get_if<BufferedMCInstruction>(&items[index]);
        if (!instruction || instruction->synthetic)
          continue;
        if (remaining == 0) {
          span.targetId = instruction->bufferId;
          break;
        }
        const llvm::MCInstrDesc &desc =
            mcii->get(instruction->inst.getOpcode());
        if (desc.isTerminator() || desc.isCall())
          return origin->emitError("packed s_delay_alu crosses control flow");
        span.skippedIds.push_back(instruction->bufferId);
        --remaining;
      }
      if (!span.targetId)
        return origin->emitError("packed s_delay_alu target is missing");
      spans.push_back(std::move(span));
    }
    return spans;
  }

  std::optional<size_t> findBufferedInstruction(ArrayRef<BufferedMCItem> items,
                                                size_t bufferId) const {
    for (size_t index = 0; index < items.size(); ++index) {
      const auto *instruction =
          std::get_if<BufferedMCInstruction>(&items[index]);
      if (instruction && instruction->bufferId == bufferId)
        return index;
    }
    return std::nullopt;
  }

  bool
  packedDelayAluSurvivesFinalization(const PackedDelayAluSpan &span,
                                     ArrayRef<BufferedMCItem> finalized) const {
    std::optional<size_t> delayIndex =
        findBufferedInstruction(finalized, span.delayId);
    std::optional<size_t> targetIndex =
        findBufferedInstruction(finalized, span.targetId);
    if (!delayIndex || !targetIndex || *targetIndex <= *delayIndex)
      return false;

    SmallVector<size_t> skippedIds;
    for (size_t index = *delayIndex + 1; index < *targetIndex; ++index) {
      const auto *instruction =
          std::get_if<BufferedMCInstruction>(&finalized[index]);
      if (!instruction)
        continue;
      if (instruction->synthetic || !instruction->bufferId ||
          instruction->inst.getOpcode() == sSetVgprMsb())
        return false;
      skippedIds.push_back(instruction->bufferId);
    }
    return skippedIds == span.skippedIds;
  }

  LogicalResult unpackPackedDelayAlu(SmallVectorImpl<BufferedMCItem> &items,
                                     ArrayRef<PackedDelayAluSpan> spans) const {
    for (const PackedDelayAluSpan &span : spans) {
      std::optional<size_t> delayIndex =
          findBufferedInstruction(items, span.delayId);
      std::optional<size_t> targetIndex =
          findBufferedInstruction(items, span.targetId);
      if (!delayIndex || !targetIndex)
        return emissionSource->emitError(
            "packed s_delay_alu buffer identity is missing");

      auto *delay = std::get_if<BufferedMCInstruction>(&items[*delayIndex]);
      Operation *origin = delay->origin ? delay->origin : emissionSource;
      FailureOr<std::optional<size_t>> clauseIndex =
          getClauseCoveringInstruction(items, *targetIndex);
      if (failed(clauseIndex))
        return failure();
      delay->inst.getOperand(0).setImm(span.id0);
      BufferedMCInstruction second = makeImmediateMCInstruction(
          sDelayAlu(), span.id1, origin, delay->indent);
      if (*clauseIndex) {
        size_t erased = **clauseIndex;
        items.erase(items.begin() + erased);
        if (erased < *targetIndex)
          --*targetIndex;
      }
      items.insert(items.begin() + *targetIndex, std::move(second));
    }
    return success();
  }

  LogicalResult insertVGPRWindowMode(
      VGPRWindowMode newMode, SmallVectorImpl<BufferedMCItem> &finalized,
      VGPRWindowMode &currentMode, std::optional<size_t> &mostRecentModeSet,
      VGPRWindowClauseState &clause, bool &xCntIsZero, bool &fallthroughModeSet,
      Operation *origin, unsigned instructionIndent) const {
    unsigned oldMode = currentMode.encode();
    bool rewritten = false;
    if (!currentMode.update(newMode, rewritten))
      return success();

    if (mostRecentModeSet && !rewritten) {
      auto *modeSet =
          std::get_if<BufferedMCInstruction>(&finalized[*mostRecentModeSet]);
      if (modeSet && modeSet->inst.getNumOperands() == 1 &&
          modeSet->inst.getOperand(0).isImm()) {
        int64_t oldModeBits = modeSet->inst.getOperand(0).getImm() &
                              (kVGPRWindowModeMask << kVGPRWindowModeWidth);
        modeSet->inst.getOperand(0).setImm(currentMode.encode() | oldModeBits);
        return success();
      }
      mostRecentModeSet.reset();
    }

    FailureOr<size_t> preparedInsertion = prepareVGPRWindowClauseInsertion(
        finalized, mostRecentModeSet, clause, origin);
    if (failed(preparedInsertion))
      return failure();
    size_t insertion = *preparedInsertion;
    for (size_t index = insertion; index < finalized.size();) {
      const auto *instruction =
          std::get_if<BufferedMCInstruction>(&finalized[index]);
      if (instruction && instruction->inst.getOpcode() == sWaitXcnt()) {
        finalized.erase(finalized.begin() + index);
        trackBufferedErase(mostRecentModeSet, index);
        trackBufferedErase(clause.itemIndex, index);
        continue;
      }
      ++index;
    }

    const BufferedMCInstruction *previous =
        getPreviousMCInstruction(finalized, insertion);
    if (hasSetregVGPRMSBFixup() &&
        (fallthroughModeSet || (previous && isModeSetreg(previous->inst)))) {
      trackBufferedInsert(clause.itemIndex, insertion);
      finalized.insert(
          finalized.begin() + insertion,
          makeImmediateMCInstruction(sNop(), 0, origin, instructionIndent));
      ++insertion;
    }

    int64_t immediate = newMode.encode() | (oldMode << kVGPRWindowModeWidth);
    trackBufferedInsert(clause.itemIndex, insertion);
    finalized.insert(finalized.begin() + insertion,
                     makeImmediateMCInstruction(sSetVgprMsb(), immediate,
                                                origin, instructionIndent));
    mostRecentModeSet = insertion;
    currentMode = newMode;
    xCntIsZero = true;
    fallthroughModeSet = false;
    return success();
  }

  LogicalResult handleModeSetreg(BufferedMCInstruction instruction,
                                 SmallVectorImpl<BufferedMCItem> &finalized,
                                 VGPRWindowMode &currentMode,
                                 std::optional<size_t> &mostRecentModeSet,
                                 bool &xCntIsZero) const {
    Operation *origin =
        instruction.origin ? instruction.origin : emissionSource;
    int simm16Index = llvm::AMDGPU::getNamedOperandIdx(
        instruction.inst.getOpcode(), llvm::AMDGPU::OpName::simm16);
    int immediateIndex = llvm::AMDGPU::getNamedOperandIdx(
        instruction.inst.getOpcode(), llvm::AMDGPU::OpName::imm);
    if (simm16Index < 0 || immediateIndex < 0 ||
        static_cast<unsigned>(simm16Index) >=
            instruction.inst.getNumOperands() ||
        static_cast<unsigned>(immediateIndex) >=
            instruction.inst.getNumOperands() ||
        !instruction.inst.getOperand(simm16Index).isImm() ||
        !instruction.inst.getOperand(immediateIndex).isImm())
      return origin->emitError("malformed LLVM MC operands for MODE setreg");

    if (instruction.inst.getOpcode() !=
            llvm::AMDGPU::S_SETREG_IMM32_B32_gfx12 ||
        immediateIndex != 0 || simm16Index != 1)
      return origin->emitError(
          "unsupported LLVM MC operand layout for MODE setreg");
    std::optional<unsigned> encodedMode =
        llvm::AMDGPU::convertSetRegImmToVgprMSBs(instruction.inst,
                                                 hasSetregVGPRMSBFixup());
    if (!encodedMode) {
      finalized.push_back(instruction);
      return success();
    }
    mostRecentModeSet.reset();

    auto encoding = llvm::AMDGPU::Hwreg::HwregEncoding::decode(
        instruction.inst.getOperand(simm16Index).getImm());
    unsigned offset = std::get<1>(encoding);
    unsigned size = std::get<2>(encoding);

    constexpr unsigned vgprMSBShift = llvm::countr_zero_constexpr<unsigned>(
        llvm::AMDGPU::Hwreg::DST_VGPR_MSB);
    unsigned setregMode = convertVGPRWindowModeToSetreg(currentMode.encode());
    llvm::MCOperand &immediate = instruction.inst.getOperand(immediateIndex);
    if (!offset || size <= vgprMSBShift) {
      int64_t value =
          (immediate.getImm() & ~int64_t(llvm::AMDGPU::Hwreg::VGPR_MSB_MASK)) |
          (int64_t(setregMode) << vgprMSBShift);
      immediate.setImm(value);
      finalized.push_back(instruction);
      return success();
    }

    finalized.push_back(instruction);
    if (*encodedMode == currentMode.encode())
      return success();

    finalized.push_back(
        makeImmediateMCInstruction(sNop(), 0, origin, instruction.indent));
    int64_t restoreMode =
        currentMode.encode() | (currentMode.encode() << kVGPRWindowModeWidth);
    finalized.push_back(makeImmediateMCInstruction(sSetVgprMsb(), restoreMode,
                                                   origin, instruction.indent));
    mostRecentModeSet = finalized.size() - 1;
    xCntIsZero = true;
    return success();
  }

  LogicalResult handleExplicitVGPRWindowMode(
      BufferedMCInstruction instruction,
      SmallVectorImpl<BufferedMCItem> &finalized, VGPRWindowMode &currentMode,
      std::optional<size_t> &mostRecentModeSet, bool &xCntIsZero,
      bool &fallthroughModeSet) const {
    Operation *origin =
        instruction.origin ? instruction.origin : emissionSource;
    if (instruction.inst.getNumOperands() != 1 ||
        !instruction.inst.getOperand(0).isImm())
      return origin->emitError("malformed LLVM MC operands for s_set_vgpr_msb");

    mostRecentModeSet.reset();
    const BufferedMCInstruction *previous =
        getPreviousMCInstruction(finalized, finalized.size());
    if (hasSetregVGPRMSBFixup() &&
        (fallthroughModeSet || (previous && isModeSetreg(previous->inst))))
      finalized.push_back(
          makeImmediateMCInstruction(sNop(), 0, origin, instruction.indent));
    unsigned newMode =
        instruction.inst.getOperand(0).getImm() & kVGPRWindowModeMask;
    instruction.inst.getOperand(0).setImm(
        newMode | (currentMode.encode() << kVGPRWindowModeWidth));
    finalized.push_back(instruction);
    currentMode = VGPRWindowMode::concrete(newMode);
    xCntIsZero = true;
    fallthroughModeSet = false;
    return success();
  }

  LogicalResult
  finalizeVGPRWindowBuffer(SmallVector<BufferedMCItem> &items) const {
    SmallVector<BufferedMCItem> finalized;
    VGPRWindowMode currentMode;
    std::optional<size_t> mostRecentModeSet;
    VGPRWindowClauseState clause;
    bool xCntIsZero = false;
    bool fallthroughModeSet = false;
    auto consumeClauseMember = [&]() {
      if (!clause.remaining)
        return;
      --clause.remaining;
      if (!clause.remaining)
        clause.clear();
    };
    for (const BufferedMCItem &item : items) {
      if (std::holds_alternative<BufferedMCLabel>(item)) {
        if (clause.remaining)
          return emissionSource->emitError("s_clause crosses a label");
        if (failed(insertVGPRWindowMode(VGPRWindowMode::concrete(0), finalized,
                                        currentMode, mostRecentModeSet, clause,
                                        xCntIsZero, fallthroughModeSet,
                                        emissionSource, indent)))
          return failure();
        const BufferedMCInstruction *previous =
            getPreviousMCInstruction(finalized, finalized.size());
        fallthroughModeSet = previous && isModeSetreg(previous->inst);
        finalized.push_back(item);
        mostRecentModeSet.reset();
        xCntIsZero = false;
        continue;
      }

      const auto *bufferedInstruction =
          std::get_if<BufferedMCInstruction>(&item);
      if (!bufferedInstruction) {
        finalized.push_back(item);
        continue;
      }

      BufferedMCInstruction instruction = *bufferedInstruction;
      llvm::MCInst &inst = instruction.inst;
      Operation *origin =
          instruction.origin ? instruction.origin : emissionSource;
      if (inst.getOpcode() == sClause()) {
        if (clause.remaining)
          return origin->emitError("nested s_clause is unsupported");
        if (inst.getNumOperands() != 1 || !inst.getOperand(0).isImm())
          return origin->emitError("malformed LLVM MC operands for s_clause");
        int64_t immediate = inst.getOperand(0).getImm();
        unsigned validMask =
            kSClauseMaxLength |
            (kSClauseBreakMask << waveamdmachine::kSClauseBreakShift);
        if (immediate < 0 ||
            (static_cast<uint64_t>(immediate) & ~uint64_t(validMask)) != 0)
          return origin->emitError("invalid s_clause immediate");
        unsigned encodedLength = immediate & kSClauseMaxLength;
        if (encodedLength == 0 || encodedLength == kSClauseMaxLength)
          return origin->emitError("invalid s_clause length");
        clause.itemIndex = finalized.size();
        clause.length = encodedLength + 1;
        clause.remaining = clause.length;
        clause.breaks = (immediate >> waveamdmachine::kSClauseBreakShift) &
                        kSClauseBreakMask;
        finalized.push_back(instruction);
        continue;
      }
      if (inst.getOpcode() == sSetVgprMsb()) {
        if (clause.remaining)
          return origin->emitError(
              "s_set_vgpr_msb cannot be a hard-clause member");
        if (failed(handleExplicitVGPRWindowMode(
                instruction, finalized, currentMode, mostRecentModeSet,
                xCntIsZero, fallthroughModeSet)))
          return failure();
        continue;
      }
      if (hasSetregVGPRMSBFixup() && isModeSetreg(inst)) {
        if (clause.remaining)
          return origin->emitError(
              "MODE setreg cannot be a hard-clause member");
        if (failed(handleModeSetreg(instruction, finalized, currentMode,
                                    mostRecentModeSet, xCntIsZero)))
          return failure();
        fallthroughModeSet = false;
        continue;
      }

      const llvm::MCInstrDesc &desc = mcii->get(inst.getOpcode());
      if (desc.isTerminator() || desc.isCall()) {
        if (clause.remaining)
          return origin->emitError(
              "s_clause reaches a terminator before all members");
        if (inst.getOpcode() == sEndpgm())
          currentMode = {};
        else if (failed(insertVGPRWindowMode(
                     VGPRWindowMode::concrete(0), finalized, currentMode,
                     mostRecentModeSet, clause, xCntIsZero, fallthroughModeSet,
                     origin, instruction.indent)))
          return failure();
        finalized.push_back(instruction);
        mostRecentModeSet.reset();
        xCntIsZero = false;
        continue;
      }

      if (inst.getOpcode() == sWaitXcnt() && xCntIsZero) {
        if (clause.remaining)
          return origin->emitError(
              "redundant s_wait_xcnt cannot be a hard-clause member");
        continue;
      }

      FailureOr<VGPRWindowMode> newMode = computeVGPRWindowMode(instruction);
      if (failed(newMode))
        return failure();
      if (failed(insertVGPRWindowMode(
              *newMode, finalized, currentMode, mostRecentModeSet, clause,
              xCntIsZero, fallthroughModeSet, origin, instruction.indent)))
        return failure();
      finalized.push_back(instruction);
      consumeClauseMember();
      if (!isVGPRWindowProgramStateInstruction(inst))
        fallthroughModeSet = false;
      if (llvm::SIInstrFlags::isVMEM(desc) || llvm::SIInstrFlags::isSMRD(desc))
        xCntIsZero = false;
    }

    if (clause.remaining)
      return emissionSource->emitError(
          "s_clause reaches function end before all members");
    if (failed(insertVGPRWindowMode(VGPRWindowMode::concrete(0), finalized,
                                    currentMode, mostRecentModeSet, clause,
                                    xCntIsZero, fallthroughModeSet,
                                    emissionSource, indent)))
      return failure();
    items = std::move(finalized);
    return success();
  }

  LogicalResult finalizeMCBuffer() {
    if (!hasVGPRWindowing())
      return success();

    size_t nextBufferId = 1;
    for (BufferedMCItem &item : mcBuffer) {
      auto *instruction = std::get_if<BufferedMCInstruction>(&item);
      if (instruction)
        instruction->bufferId = nextBufferId++;
    }

    FailureOr<SmallVector<PackedDelayAluSpan>> spans =
        collectPackedDelayAluSpans(mcBuffer);
    if (failed(spans))
      return failure();

    SmallVector<PackedDelayAluSpan> unpackedSpans;
    DenseSet<size_t> unpackedIds;
    while (true) {
      SmallVector<BufferedMCItem> finalized = mcBuffer;
      if (failed(unpackPackedDelayAlu(finalized, unpackedSpans)) ||
          failed(finalizeVGPRWindowBuffer(finalized)))
        return failure();

      bool changed = false;
      for (const PackedDelayAluSpan &span : *spans) {
        if (unpackedIds.contains(span.delayId) ||
            packedDelayAluSurvivesFinalization(span, finalized))
          continue;
        unpackedSpans.push_back(span);
        unpackedIds.insert(span.delayId);
        changed = true;
      }
      if (changed)
        continue;
      mcBuffer = std::move(finalized);
      break;
    }
    return success();
  }

  LogicalResult printMCBuffer() {
    if (failed(finalizeMCBuffer()))
      return failure();
    for (const BufferedMCItem &item : mcBuffer) {
      if (const auto *instruction = std::get_if<BufferedMCInstruction>(&item)) {
        printIndent(instruction->indent);
        instPrinter->printInst(&instruction->inst, /*Address=*/0,
                               /*Annot=*/"", *sti, os);
        os << '\n';
        continue;
      }
      if (const auto *line = std::get_if<BufferedMCLine>(&item)) {
        printIndent(line->indent);
        os << line->text << '\n';
        continue;
      }
      if (const auto *label = std::get_if<BufferedMCLabel>(&item)) {
        os << label->symbol->getName() << ":\n";
        continue;
      }
      os << "\t.p2align\t" << std::get<BufferedMCAlign>(item).log2 << '\n';
    }
    mcBuffer.clear();
    return success();
  }

  unsigned getIntAttr(Operation *op, StringRef name, unsigned fallback) const {
    if (auto attr = op->getAttrOfType<IntegerAttr>(name))
      return attr.getInt();
    return fallback;
  }

  unsigned getNonVolatileMemoryCPol() const {
    return isGfx1250() ? llvm::AMDGPU::CPol::NV : 0;
  }

  FailureOr<unsigned> getLoadCacheCPol(Operation &op) const {
    Attribute cache = op.getAttr(kMemoryCacheAttrName);
    if (!cache)
      return 0u;
    auto attr = dyn_cast<waveamd::LoadCacheAttr>(cache);
    if (!attr) {
      op.emitError("load cache modifier must use #waveamd.load_cache");
      return failure();
    }

    if (isGfx1250()) {
      switch (attr.getValue()) {
      case waveamd::LoadCacheKind::None:
      case waveamd::LoadCacheKind::CA:
        return 0u;
      case waveamd::LoadCacheKind::CG:
      case waveamd::LoadCacheKind::CS:
      case waveamd::LoadCacheKind::CV:
        op.emitError("gfx1250 load cache modifier is not implemented: ")
            << waveamd::stringifyLoadCacheKind(attr.getValue());
        return failure();
      }
      op.emitError("unknown gfx1250 load cache modifier");
      return failure();
    }

    // CDNA3/4 cpol bits encode SC0/NT/SC1.
    if (isGfx940Plus()) {
      switch (attr.getValue()) {
      case waveamd::LoadCacheKind::None:
      case waveamd::LoadCacheKind::CA:
        return 0u;
      case waveamd::LoadCacheKind::CG:
      case waveamd::LoadCacheKind::CS:
        return llvm::AMDGPU::CPol::SC0 | llvm::AMDGPU::CPol::NT;
      case waveamd::LoadCacheKind::CV:
        return llvm::AMDGPU::CPol::SC0 | llvm::AMDGPU::CPol::SC1;
      }
    }

    switch (attr.getValue()) {
    case waveamd::LoadCacheKind::None:
    case waveamd::LoadCacheKind::CA:
      return 0u;
    case waveamd::LoadCacheKind::CG:
      return llvm::AMDGPU::CPol::GLC;
    case waveamd::LoadCacheKind::CS:
      return llvm::AMDGPU::CPol::GLC | llvm::AMDGPU::CPol::SLC;
    case waveamd::LoadCacheKind::CV:
      return llvm::AMDGPU::CPol::GLC |
             (isGfx11() ? llvm::AMDGPU::CPol::DLC : 0);
    }
    llvm_unreachable("unknown load cache modifier");
  }

  FailureOr<unsigned> getStoreCacheCPol(Operation &op) const {
    Attribute cache = op.getAttr(kMemoryCacheAttrName);
    if (!cache)
      return 0u;
    auto attr = dyn_cast<waveamd::StoreCacheAttr>(cache);
    if (!attr) {
      op.emitError("store cache modifier must use #waveamd.store_cache");
      return failure();
    }

    if (isGfx1250()) {
      switch (attr.getValue()) {
      case waveamd::StoreCacheKind::None:
      case waveamd::StoreCacheKind::WB:
        return 0u;
      case waveamd::StoreCacheKind::CG:
      case waveamd::StoreCacheKind::CS:
      case waveamd::StoreCacheKind::WT:
        op.emitError("gfx1250 store cache modifier is not implemented: ")
            << waveamd::stringifyStoreCacheKind(attr.getValue());
        return failure();
      }
      op.emitError("unknown gfx1250 store cache modifier");
      return failure();
    }

    if (isGfx940Plus()) {
      switch (attr.getValue()) {
      case waveamd::StoreCacheKind::None:
      case waveamd::StoreCacheKind::WB:
      case waveamd::StoreCacheKind::CG:
        return 0u;
      case waveamd::StoreCacheKind::CS:
        return llvm::AMDGPU::CPol::SC0 | llvm::AMDGPU::CPol::NT;
      case waveamd::StoreCacheKind::WT:
        return llvm::AMDGPU::CPol::SC0 | llvm::AMDGPU::CPol::SC1;
      }
    }

    switch (attr.getValue()) {
    case waveamd::StoreCacheKind::None:
    case waveamd::StoreCacheKind::WB:
      return 0u;
    case waveamd::StoreCacheKind::CG:
      return llvm::AMDGPU::CPol::GLC;
    case waveamd::StoreCacheKind::CS:
      return llvm::AMDGPU::CPol::GLC | llvm::AMDGPU::CPol::SLC;
    case waveamd::StoreCacheKind::WT:
      return llvm::AMDGPU::CPol::SLC;
    }
    llvm_unreachable("unknown store cache modifier");
  }

  LogicalResult rejectCacheAttr(Operation &op, StringRef opKind) const {
    if (op.getAttr(kMemoryCacheAttrName))
      return op.emitError(opKind) << " does not support cache modifiers";
    return success();
  }

  FailureOr<unsigned> getFixedLDSSize(func::FuncOp func) const {
    unsigned total = getIntAttr(func, "waveamdmachine.lds_size", 0);
    unsigned dynamic = getIntAttr(func, "waveamdmachine.dynamic_lds_size", 0);
    if (dynamic > total)
      return func.emitError("dynamic LDS size exceeds total LDS size");
    return total - dynamic;
  }

  FailureOr<unsigned> getPrivateSegmentFixedSize(func::FuncOp func) const {
    IntegerAttr attr =
        func->getAttrOfType<IntegerAttr>(kPrivateSegmentFixedSizeAttr);
    if (!attr)
      return 0;
    int64_t value = attr.getInt();
    if (value < 0 ||
        static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
      return func.emitError("private segment fixed size must fit u32");
    return static_cast<unsigned>(value);
  }

  bool getBoolAttr(Operation *op, StringRef name, bool fallback) const {
    if (auto attr = op->getAttrOfType<BoolAttr>(name))
      return attr.getValue();
    return fallback;
  }

  static KernelEntryValueUsage getKernelEntryValueUsage(func::FuncOp func) {
    KernelEntryValueUsage usage;
    func.walk([&](Operation *op) {
      if (isa<waveamdmachine::SWorkgroupIdXOp>(op))
        usage.workgroupIdX = true;
      if (isa<waveamdmachine::SWorkgroupIdYOp>(op))
        usage.workgroupIdY = true;
      if (isa<waveamdmachine::SWorkgroupIdZOp>(op))
        usage.workgroupIdZ = true;
      if (waveamdmachine::VWorkitemIdXOp workitemX =
              dyn_cast<waveamdmachine::VWorkitemIdXOp>(op)) {
        IntegerAttr axis = workitemX->getAttrOfType<IntegerAttr>(
            wave::getWaveAMDWorkitemIdAxisAttrName());
        if (axis && axis.getInt() >= 0 && axis.getInt() <= 2)
          usage.maxWorkitemIdAxis = std::max(
              usage.maxWorkitemIdAxis, static_cast<unsigned>(axis.getInt()));
      }
      if (isa<waveamdmachine::VWorkitemIdYOp>(op))
        usage.maxWorkitemIdAxis = std::max(usage.maxWorkitemIdAxis, 1u);
      if (isa<waveamdmachine::VWorkitemIdZOp>(op))
        usage.maxWorkitemIdAxis = 2;
    });
    return usage;
  }

  FailureOr<unsigned> getKernelSGPRCount(func::FuncOp func) const {
    FailureOr<unsigned> minimum =
        wave::getWaveAMDMinReportedSGPRs(func, "wave-to-amdgpu-asm");
    if (failed(minimum))
      return failure();
    return getIntAttr(func, "waveamdmachine.sgpr_count", *minimum);
  }

  LogicalResult
  emitKernelEntrySequence(func::FuncOp func,
                          const wave::WaveAMDKernelEntryRegs &entryRegs) {
    if (requiresInitialUnclausedVmem()) {
      if (entryRegs.kernargSegmentPtrWidth != 2)
        return func.emitError(
            "wave-to-amdgpu-asm target entry sequence requires an SGPR pair "
            "kernarg pointer");
      unsigned kernargPtr = mcSGPRReg(entryRegs.kernargSegmentPtrSGPR,
                                      entryRegs.kernargSegmentPtrWidth);
      unsigned workitemX = mcVGPRReg(entryRegs.workitemIdVGPR(0), /*width=*/1);
      unsigned requiredKernargPtr =
          llvm::AMDGPU::getMCReg(llvm::AMDGPU::SGPR0_SGPR1, *sti).id();
      unsigned requiredWorkitemX =
          llvm::AMDGPU::getMCReg(llvm::AMDGPU::VGPR0, *sti).id();
      if (kernargPtr != requiredKernargPtr || workitemX != requiredWorkitemX)
        return func.emitError(
            "wave-to-amdgpu-asm entry register layout does not satisfy "
            "target prologue operands");
      if (failed(emitMC(
              globalPrefetchB8(),
              {llvm::MCOperand::createReg(kernargPtr),
               llvm::MCOperand::createReg(workitemX),
               llvm::MCOperand::createImm(0),
               llvm::MCOperand::createImm(llvm::AMDGPU::CPol::SCOPE_SE |
                                          llvm::AMDGPU::CPol::TH_RT)})) ||
          failed(emitMC(vNop(), {})))
        return failure();
    }

    if (!hasWaitXcnt())
      return success();
    unsigned replayMask = llvm::AMDGPU::Hwreg::REPLAY_MODE;
    unsigned replayOffset = llvm::countr_zero(replayMask);
    unsigned replayWidth = llvm::popcount(replayMask);
    unsigned replayEncoding = llvm::AMDGPU::Hwreg::HwregEncoding::encode(
        llvm::AMDGPU::Hwreg::ID_MODE, replayOffset, replayWidth);
    return emitMC(sSetregImm32B32(),
                  {llvm::MCOperand::createImm(1),
                   llvm::MCOperand::createImm(replayEncoding)});
  }

  LogicalResult
  emitArchitectedWorkgroupIdRaw(const wave::WaveAMDKernelEntryRegs &entryRegs,
                                unsigned axis) {
    unsigned result = mcSGPRReg(entryRegs.workgroupIdSGPR(axis), /*width=*/1);
    if (axis == 0) {
      unsigned ttmp9 = llvm::AMDGPU::getMCReg(llvm::AMDGPU::TTMP9, *sti).id();
      return emitMC(sMovB32(), {llvm::MCOperand::createReg(result),
                                llvm::MCOperand::createReg(ttmp9)});
    }

    unsigned ttmp7 = llvm::AMDGPU::getMCReg(llvm::AMDGPU::TTMP7, *sti).id();
    constexpr unsigned halfBits = std::numeric_limits<uint16_t>::digits;
    if (axis == 1)
      return emitMC(sAndB32(), {llvm::MCOperand::createReg(result),
                                llvm::MCOperand::createReg(ttmp7),
                                llvm::MCOperand::createImm(
                                    std::numeric_limits<uint16_t>::max())});
    if (axis == 2)
      return emitMC(sLshrB32(), {llvm::MCOperand::createReg(result),
                                 llvm::MCOperand::createReg(ttmp7),
                                 llvm::MCOperand::createImm(halfBits)});
    return emissionSource->emitError("invalid architected workgroup ID axis");
  }

  LogicalResult emitSALUCycleDelay() {
    return emitMC(sDelayAlu(),
                  {llvm::MCOperand::createImm(
                      waveamdmachine::encodeSDelayAluSALUCycle(/*cycles=*/1))});
  }

  LogicalResult
  emitClusterWorkgroupId(const wave::WaveAMDKernelEntryRegs &entryRegs,
                         unsigned axis, unsigned temp0, unsigned temp1,
                         unsigned statusEncoding) {
    constexpr unsigned clusterFieldBits = 4;
    constexpr unsigned clusterFieldMask = (unsigned{1} << clusterFieldBits) - 1;
    unsigned ttmp6 = llvm::AMDGPU::getMCReg(llvm::AMDGPU::TTMP6, *sti).id();
    unsigned result = mcSGPRReg(entryRegs.workgroupIdSGPR(axis), /*width=*/1);
    unsigned localShift = axis * clusterFieldBits;
    unsigned maxShift = (3 + axis) * clusterFieldBits;

    if (failed(emitArchitectedWorkgroupIdRaw(entryRegs, axis)) ||
        failed(emitMC(sLshrB32(), {llvm::MCOperand::createReg(temp0),
                                   llvm::MCOperand::createReg(ttmp6),
                                   llvm::MCOperand::createImm(maxShift)})) ||
        failed(emitMC(sLshrB32(), {llvm::MCOperand::createReg(temp1),
                                   llvm::MCOperand::createReg(ttmp6),
                                   llvm::MCOperand::createImm(localShift)})) ||
        failed(emitMC(sAndB32(),
                      {llvm::MCOperand::createReg(temp0),
                       llvm::MCOperand::createReg(temp0),
                       llvm::MCOperand::createImm(clusterFieldMask)})) ||
        failed(emitMC(sAndB32(),
                      {llvm::MCOperand::createReg(temp1),
                       llvm::MCOperand::createReg(temp1),
                       llvm::MCOperand::createImm(clusterFieldMask)})) ||
        failed(emitMC(sAddI32(), {llvm::MCOperand::createReg(temp0),
                                  llvm::MCOperand::createReg(temp0),
                                  llvm::MCOperand::createImm(1)})) ||
        failed(emitSALUCycleDelay()) ||
        failed(emitMC(sMulI32(), {llvm::MCOperand::createReg(temp0),
                                  llvm::MCOperand::createReg(result),
                                  llvm::MCOperand::createReg(temp0)})) ||
        failed(emitSALUCycleDelay()) ||
        failed(emitMC(sAddI32(), {llvm::MCOperand::createReg(temp1),
                                  llvm::MCOperand::createReg(temp1),
                                  llvm::MCOperand::createReg(temp0)})) ||
        failed(emitMC(sGetregB32(),
                      {llvm::MCOperand::createReg(temp0),
                       llvm::MCOperand::createImm(statusEncoding)})) ||
        failed(emitSALUCycleDelay()) ||
        failed(emitMC(sCmpEqU32(), {llvm::MCOperand::createReg(temp0),
                                    llvm::MCOperand::createImm(0)})) ||
        failed(emitMC(sCselectB32(), {llvm::MCOperand::createReg(result),
                                      llvm::MCOperand::createReg(result),
                                      llvm::MCOperand::createReg(temp1)})))
      return failure();
    return success();
  }

  LogicalResult
  emitArchitectedWorkgroupIds(func::FuncOp func,
                              const wave::WaveAMDKernelEntryRegs &entryRegs) {
    if (!hasArchitectedSGPRs())
      return success();

    KernelEntryValueUsage usage = getKernelEntryValueUsage(func);
    std::array<bool, 3> used = {usage.workgroupIdX, usage.workgroupIdY,
                                usage.workgroupIdZ};
    if (!hasClusters()) {
      for (unsigned axis : llvm::seq<unsigned>(0, 3))
        if (used[axis] &&
            failed(emitArchitectedWorkgroupIdRaw(entryRegs, axis)))
          return failure();
      return success();
    }

    constexpr unsigned clusterStatusOffset = 6;
    constexpr unsigned clusterStatusBits = 4;
    unsigned statusEncoding = llvm::AMDGPU::Hwreg::HwregEncoding::encode(
        llvm::AMDGPU::Hwreg::ID_IB_STS2, clusterStatusOffset,
        clusterStatusBits);
    unsigned temp0 = mcSGPRReg(entryRegs.reservedSGPRs, /*width=*/1);
    unsigned temp1 = mcSGPRReg(entryRegs.reservedSGPRs + 1, /*width=*/1);
    bool emitted = false;
    // TTMP6: local XYZ nibbles, then max XYZ nibbles.
    for (unsigned axis : llvm::seq<unsigned>(0, 3)) {
      if (!used[axis])
        continue;
      if (failed(emitClusterWorkgroupId(entryRegs, axis, temp0, temp1,
                                        statusEncoding)))
        return failure();
      emitted = true;
    }
    if (emitted)
      return emitSALUCycleDelay();
    return success();
  }

  LogicalResult emitFunction(func::FuncOp func) {
    if (!func.getBody().hasOneBlock())
      return func.emitError(
          "WaveAMDMachine AMDGPU emitter supports one-block funcs");
    bool isKernel = func->hasAttr(wave::WaveDialect::getKernelAttrName());
    wave::WaveAMDKernelEntryRegs entryRegs;
    if (isKernel) {
      entryRegs = wave::getWaveAMDKernelEntryRegs(func);
      if (failed(verifyKernelDescriptor(func, entryRegs)))
        return failure();
    }

    bool emitPreloadCompatProlog = false;
    if (isKernel && entryRegs.kernargPreloadDwords != 0) {
      FailureOr<bool> needsProlog =
          wave::needsWaveAMDKernargPreloadCompatProlog(func,
                                                       "wave-to-amdgpu-asm");
      if (failed(needsProlog))
        return failure();
      emitPreloadCompatProlog = *needsProlog;
    }

    loopCounter = 0;
    ifCounter = 0;
    execIfCounter = 0;
    dmaIssueDelayCounter = 0;
    execIfSaveCursor = 0;
    funcLabelPrefix = (".L" + Twine(func.getSymName())).str();
    wave::WaveAMDExecIfSaveStackInfo execIfSaveInfo =
        wave::getWaveAMDExecIfSaveStackInfo(func);
    if (execIfSaveInfo.maxDwords != 0 &&
        !func->hasAttr("waveamdmachine.sgpr_count"))
      return func.emitError(
          "wave-to-amdgpu-asm exec_if requires waveamdmachine.sgpr_count");
    unsigned sgprCount = getIntAttr(func, "waveamdmachine.sgpr_count", 0);
    execIfSaveBase = wave::getWaveAMDExecIfSaveBase(func, sgprCount);
    if (execIfSaveInfo.maxDwords != 0 &&
        execIfSaveBase + execIfSaveInfo.maxDwords > sgprCount)
      return func.emitError("wave-to-amdgpu-asm sgpr_count does not cover "
                            "exec_if save stack");

    os << "\n\t.globl\t" << func.getSymName() << "\n";
    os << "\t.p2align\t8\n";
    os << "\t.type\t" << func.getSymName() << ",@function\n";
    os << func.getSymName() << ":\n";
    mcBuffer.clear();
    llvm::SaveAndRestore<bool> saveBuffering(bufferingMC, true);
    llvm::SaveAndRestore<Operation *> saveSource(emissionSource, func);
    if (isKernel && failed(emitKernelEntrySequence(func, entryRegs)))
      return failure();
    if (emitPreloadCompatProlog) {
      std::string realEntryLabel = funcLabelPrefix + ".kernarg_preload_entry";
      if (failed(emitKernargPreloadCompatProlog(entryRegs, realEntryLabel)))
        return failure();
      emitAlign(8);
      emitLabel(realEntryLabel);
    }
    if (isKernel && failed(emitArchitectedWorkgroupIds(func, entryRegs)))
      return failure();
    emitLine(
        StringRef("; wave backend: WaveAMDMachine MLIR pipeline finalized"));

    for (Operation &op : func.getBody().front()) {
      if (isa<func::ReturnOp>(op))
        continue;
      if (!waveamdmachine::isWaveAMDMachineOp(&op))
        return op.emitError(
            "unexpected non-WaveAMDMachine operation in emitter");
      if (failed(emitOperation(op)))
        return failure();
    }

    if (failed(printMCBuffer()))
      return failure();
    if (isKernel && supportsDescriptorRoundRobin()) {
      std::string functionEndLabel = funcLabelPrefix + ".end";
      os << functionEndLabel << ":\n";
      os << "\t.size\t" << func.getSymName() << ", " << functionEndLabel << "-"
         << func.getSymName() << "\n";
    } else {
      os << "\t.size\t" << func.getSymName() << ", .-" << func.getSymName()
         << "\n";
    }
    if (isKernel) {
      KernelInfo info;
      info.name = func.getSymName().str();
      info.kernargSize = getKernelArgSize(func);
      FailureOr<unsigned> sgprCount = getKernelSGPRCount(func);
      if (failed(sgprCount))
        return failure();
      info.sgprCount = *sgprCount;
      KernelRegisterUsage regUsage = getKernelRegisterUsage(func);
      info.agprCount = regUsage.agprCount;
      info.vgprCount = getTotalVGPRCount(regUsage.vgprCount, info.agprCount);
      info.sgprSpillCount = getIntAttr(func, kSGPRSpillCountAttr, 0);
      info.vgprSpillCount = getIntAttr(func, kVGPRSpillCountAttr, 0);
      FailureOr<unsigned> maxFlatWorkgroupSize = getMaxFlatWorkgroupSize(func);
      if (failed(maxFlatWorkgroupSize))
        return failure();
      info.maxFlatWorkgroupSize = *maxFlatWorkgroupSize;
      FailureOr<unsigned> fixedLdsSize = getFixedLDSSize(func);
      if (failed(fixedLdsSize))
        return failure();
      info.fixedLdsSize = *fixedLdsSize;
      FailureOr<unsigned> privateSegmentFixedSize =
          getPrivateSegmentFixedSize(func);
      if (failed(privateSegmentFixedSize))
        return failure();
      info.privateSegmentFixedSize = *privateSegmentFixedSize;
      SmallVector<waveamd::KernargSlot> layout =
          waveamd::getKernargLayout(func.getFunctionType().getInputs());
      for (auto [index, slot] : llvm::enumerate(layout)) {
        info.args.push_back(KernelArgInfo{("arg" + Twine(index)).str(),
                                          slot.offset, slot.size,
                                          slot.isGlobalBuffer});
      }
      FailureOr<SmallVector<KernelMetadataEntryInfo>> metadataEntries =
          collectKernelMetadataEntries(func);
      if (failed(metadataEntries))
        return failure();
      info.metadataEntries = std::move(*metadataEntries);
      kernels.push_back(std::move(info));
      if (failed(emitKernelDescriptor(func)))
        return failure();
    }
    return success();
  }

  unsigned getKernelArgSize(func::FuncOp func) const {
    if (auto attr =
            func->getAttrOfType<IntegerAttr>("waveamdmachine.kernarg_size"))
      return attr.getInt();
    return waveamd::getKernargSegmentSize(func.getFunctionType().getInputs());
  }

  static bool isAGPRType(Type type) {
    auto regType = dyn_cast<waveamdmachine::RegType>(type);
    return regType && regType.getRegClass() == waveamdmachine::RegClass::AGPR;
  }

  static bool isVCCType(Type type) {
    auto regType = dyn_cast<waveamdmachine::RegType>(type);
    return regType && regType.getRegClass() == waveamdmachine::RegClass::VCC;
  }

  FailureOr<unsigned> getMaxFlatWorkgroupSize(func::FuncOp func) const {
    Operation *op = func.getOperation();
    for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
      DenseI32ArrayAttr attr = op->getAttrOfType<DenseI32ArrayAttr>(name);
      if (!attr)
        continue;
      if (attr.empty() || attr.size() > 3)
        return func.emitError(name) << " must contain one to three dimensions";

      uint64_t product = 1;
      for (int32_t dim : attr.asArrayRef()) {
        if (dim <= 0)
          return func.emitError(name) << " dimensions must be positive";
        product *= static_cast<uint32_t>(dim);
        if (product > std::numeric_limits<unsigned>::max())
          return func.emitError(name) << " flat size must fit u32";
      }
      return static_cast<unsigned>(product);
    }
    return 1024;
  }

  bool usesVCC(func::FuncOp func) const {
    bool found = false;
    func.walk([&](Operation *op) {
      for (Value value :
           llvm::concat<Value>(op->getOperands(), op->getResults())) {
        if (isVCCType(value.getType())) {
          found = true;
          return WalkResult::interrupt();
        }
      }
      for (Region &region : op->getRegions())
        for (Block &block : region)
          for (BlockArgument arg : block.getArguments())
            if (isVCCType(arg.getType())) {
              found = true;
              return WalkResult::interrupt();
            }
      return WalkResult::advance();
    });
    return found;
  }

  static void noteRegisterUsage(Value value, KernelRegisterUsage &usage) {
    auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!regType || regType.getIndex() < 0)
      return;

    unsigned end =
        static_cast<unsigned>(regType.getIndex()) + regType.getWidth();
    if (regType.getRegClass() == waveamdmachine::RegClass::VGPR)
      usage.vgprCount = std::max(usage.vgprCount, end);
    if (regType.getRegClass() == waveamdmachine::RegClass::AGPR)
      usage.agprCount = std::max(usage.agprCount, end);
  }

  KernelRegisterUsage getKernelRegisterUsage(func::FuncOp func) const {
    KernelRegisterUsage usage;
    func.walk([&](Operation *op) {
      for (Value value :
           llvm::concat<Value>(op->getOperands(), op->getResults()))
        noteRegisterUsage(value, usage);
      for (Region &region : op->getRegions())
        for (Block &block : region)
          for (BlockArgument arg : block.getArguments())
            noteRegisterUsage(arg, usage);
      return WalkResult::advance();
    });
    usage.vgprCount =
        std::max(usage.vgprCount, wave::getWaveAMDMinReportedVGPRs(func));
    return usage;
  }

  LogicalResult verifyAGPRTargetSupport(ModuleOp module) const {
    if (hasAGPRs())
      return success();
    WalkResult walk = module.walk([&](Operation *op) {
      for (Value value :
           llvm::concat<Value>(op->getOperands(), op->getResults())) {
        if (!isAGPRType(value.getType()))
          continue;
        op->emitError()
            << "wave-to-amdgpu-asm AGPR registers require target with AGPR "
               "support";
        return WalkResult::interrupt();
      }
      for (Region &region : op->getRegions())
        for (Block &block : region)
          for (BlockArgument arg : block.getArguments())
            if (isAGPRType(arg.getType())) {
              op->emitError()
                  << "wave-to-amdgpu-asm AGPR registers require target with "
                     "AGPR support";
              return WalkResult::interrupt();
            }
      return WalkResult::advance();
    });
    return success(!walk.wasInterrupted());
  }

  static unsigned alignUp(unsigned value, unsigned granule) {
    return ((value + granule - 1) / granule) * granule;
  }

  unsigned getTotalVGPRCount(unsigned archVGPRCount, unsigned agprCount) const {
    if (isGfx90APlus() && agprCount != 0)
      return alignUp(archVGPRCount, 4) + agprCount;
    return std::max(archVGPRCount, agprCount);
  }

  unsigned getAddressableVGPRCount() const {
    return llvm::AMDGPU::IsaInfo::getAddressableNumArchVGPRs(*sti);
  }

  unsigned getAddressableAGPRCount() const {
    return waveamdmachine::getAMDGPUAddressableAGPRs(*sti);
  }

  LogicalResult verifyVGPRAddressability(Operation &op) const {
    if (!hasVGPRWindowing())
      return success();
    unsigned limit = getAddressableVGPRCount();
    auto verify = [&](Value value) -> LogicalResult {
      auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
      if (!regType || regType.getRegClass() != waveamdmachine::RegClass::VGPR ||
          regType.getIndex() < 0)
        return success();
      uint64_t first = static_cast<uint64_t>(regType.getIndex());
      unsigned width = regType.getWidth();
      if (width <= limit && first <= limit - width)
        return success();
      return op.emitError("VGPR range v")
             << first << ":v" << first + width - 1
             << " exceeds LLVM addressable count " << limit;
    };
    for (Value operand : op.getOperands())
      if (failed(verify(operand)))
        return failure();
    for (Value result : op.getResults())
      if (failed(verify(result)))
        return failure();
    return success();
  }

  LogicalResult verifyKernelRegisterAddressability(
      func::FuncOp func, const KernelRegisterUsage &regUsage) const {
    unsigned addressableVGPRCount = getAddressableVGPRCount();
    if (regUsage.vgprCount > addressableVGPRCount)
      return func.emitError("wave-to-amdgpu-asm VGPR allocation requires ")
             << regUsage.vgprCount << " addressable VGPRs, but target supports "
             << addressableVGPRCount;

    unsigned addressableAGPRCount = getAddressableAGPRCount();
    if (regUsage.agprCount > addressableAGPRCount)
      return func.emitError("wave-to-amdgpu-asm AGPR allocation requires ")
             << regUsage.agprCount << " addressable AGPRs, but target supports "
             << addressableAGPRCount;
    return success();
  }

  LogicalResult
  verifyKernelDescriptor(func::FuncOp func,
                         const wave::WaveAMDKernelEntryRegs &entryRegs) const {
    unsigned maxUserSGPRs = llvm::AMDGPU::getMaxNumUserSGPRs(*sti);
    if (entryRegs.userSGPRCount > maxUserSGPRs)
      return func.emitError("wave-to-amdgpu-asm kernarg preload consumes ")
             << entryRegs.userSGPRCount << " user SGPRs, but target supports "
             << maxUserSGPRs;
    constexpr unsigned preloadOffsetWidth =
        llvm::amdhsa::KERNARG_PRELOAD_SPEC_OFFSET_WIDTH;
    if (entryRegs.kernargPreloadDwords != 0 &&
        !llvm::isUInt<preloadOffsetWidth>(entryRegs.kernargPreloadOffsetDwords))
      return func.emitError("wave-to-amdgpu-asm kernarg preload offset must be "
                            "less than ")
             << (uint64_t{1} << preloadOffsetWidth) << " dwords";
    FailureOr<unsigned> minSGPRCount =
        wave::getWaveAMDMinReportedSGPRs(func, "wave-to-amdgpu-asm");
    if (failed(minSGPRCount))
      return failure();
    unsigned sgprCount =
        getIntAttr(func, "waveamdmachine.sgpr_count", *minSGPRCount);
    if (sgprCount < *minSGPRCount)
      return func.emitError("wave-to-amdgpu-asm sgpr_count ")
             << sgprCount << " does not cover kernel ABI register count "
             << *minSGPRCount;
    FailureOr<unsigned> privateSegmentFixedSize =
        getPrivateSegmentFixedSize(func);
    if (failed(privateSegmentFixedSize))
      return failure();
    bool usesFlatScratch = getBoolAttr(func, kUsesFlatScratchAttr, false);
    if ((*privateSegmentFixedSize != 0 || usesFlatScratch) &&
        !supportsPrivateSegmentEnable())
      return func.emitError("wave-to-amdgpu-asm private segment requires "
                            "architected flat scratch target");
    return wave::verifyWaveAMDKernargPreloadTarget(func, "wave-to-amdgpu-asm");
  }

  static unsigned chooseKernargPreloadLoadWidth(unsigned phys,
                                                unsigned offsetDwords,
                                                unsigned remainingDwords) {
    if (remainingDwords >= 8 && phys % 4 == 0 && offsetDwords % 8 == 0)
      return 8;
    if (remainingDwords >= 4 && phys % 4 == 0 && offsetDwords % 4 == 0)
      return 4;
    if (remainingDwords >= 2 && phys % 2 == 0 && offsetDwords % 2 == 0)
      return 2;
    return 1;
  }

  LogicalResult
  emitKernargPreloadCompatProlog(const wave::WaveAMDKernelEntryRegs &entryRegs,
                                 StringRef realEntryLabel) {
    unsigned remainingDwords = entryRegs.kernargPreloadDwords;
    unsigned preloadSGPR =
        entryRegs.kernargSegmentPtrSGPR + entryRegs.kernargSegmentPtrWidth;
    unsigned offsetDwords = entryRegs.kernargPreloadOffsetDwords;
    unsigned kernargPtr = mcSGPRReg(entryRegs.kernargSegmentPtrSGPR,
                                    entryRegs.kernargSegmentPtrWidth);
    while (remainingDwords != 0) {
      unsigned width = chooseKernargPreloadLoadWidth(preloadSGPR, offsetDwords,
                                                     remainingDwords);
      unsigned opcode = sLoadB32();
      if (width == 8)
        opcode = sLoadB256();
      else if (width == 4)
        opcode = sLoadB128();
      else if (width == 2)
        opcode = sLoadB64();
      if (failed(
              emitMC(opcode,
                     {llvm::MCOperand::createReg(mcSGPRReg(preloadSGPR, width)),
                      llvm::MCOperand::createReg(kernargPtr),
                      llvm::MCOperand::createImm(offsetDwords * 4),
                      llvm::MCOperand::createImm(getNonVolatileMemoryCPol())})))
        return failure();
      preloadSGPR += width;
      offsetDwords += width;
      remainingDwords -= width;
    }

    unsigned waitcnt = llvm::AMDGPU::encodeWaitcnt(
        isaVersion, llvm::AMDGPU::getVmcntBitMask(isaVersion),
        llvm::AMDGPU::getExpcntBitMask(isaVersion), /*lgkmcnt=*/0);
    if (failed(emitMC(sWaitcnt(), {llvm::MCOperand::createImm(waitcnt)})))
      return failure();
    return emitMC(sBranch(), {labelOperand(realEntryLabel)});
  }

  LogicalResult emitKernelDescriptor(func::FuncOp func) {
    unsigned kernargSize = getKernelArgSize(func);
    FailureOr<unsigned> sgprCount = getKernelSGPRCount(func);
    if (failed(sgprCount))
      return failure();
    KernelRegisterUsage regUsage = getKernelRegisterUsage(func);
    unsigned vgprCount = regUsage.vgprCount;
    unsigned agprCount = regUsage.agprCount;
    unsigned totalVGPRCount = getTotalVGPRCount(vgprCount, agprCount);
    if (failed(verifyKernelRegisterAddressability(func, regUsage)))
      return failure();
    bool reserveVCC = usesVCC(func);
    FailureOr<unsigned> fixedLdsSize = getFixedLDSSize(func);
    if (failed(fixedLdsSize))
      return failure();
    FailureOr<unsigned> privateSegmentFixedSize =
        getPrivateSegmentFixedSize(func);
    if (failed(privateSegmentFixedSize))
      return failure();
    bool usesFlatScratch = getBoolAttr(func, kUsesFlatScratchAttr, false);
    KernelEntryValueUsage entryUsage = getKernelEntryValueUsage(func);
    bool usesWgY = entryUsage.workgroupIdY;
    bool usesWgZ = entryUsage.workgroupIdZ;
    wave::WaveAMDKernelEntryRegs entryRegs =
        wave::getWaveAMDKernelEntryRegs(func);
    if (failed(verifyKernelDescriptor(func, entryRegs)))
      return failure();

    os << "\t.section\t.rodata,\"a\",@progbits\n";
    os << "\t.p2align\t6, 0x0\n";
    os << "\t.amdhsa_kernel " << func.getSymName() << "\n";
    os << "\t\t.amdhsa_group_segment_fixed_size " << *fixedLdsSize << "\n";
    os << "\t\t.amdhsa_private_segment_fixed_size " << *privateSegmentFixedSize
       << "\n";
    os << "\t\t.amdhsa_kernarg_size " << kernargSize << "\n";
    os << "\t\t.amdhsa_user_sgpr_count " << entryRegs.userSGPRCount << "\n";
    os << "\t\t.amdhsa_user_sgpr_kernarg_segment_ptr "
       << (entryRegs.kernargSegmentPtrWidth != 0 ? 1 : 0) << "\n";
    if (entryRegs.kernargPreloadDwords != 0) {
      os << "\t\t.amdhsa_user_sgpr_kernarg_preload_length "
         << entryRegs.kernargPreloadDwords << "\n";
      os << "\t\t.amdhsa_user_sgpr_kernarg_preload_offset "
         << entryRegs.kernargPreloadOffsetDwords << "\n";
    }
    if (!isGfx8Or9() && wavefrontSize == 32) {
      os << "\t\t.amdhsa_wavefront_size32 1\n";
      os << "\t\t.amdhsa_uses_dynamic_stack 0\n";
    }
    if (supportsPrivateSegmentEnable())
      os << "\t\t.amdhsa_enable_private_segment "
         << ((*privateSegmentFixedSize != 0 || usesFlatScratch) ? 1 : 0)
         << "\n";
    os << "\t\t.amdhsa_system_sgpr_workgroup_id_x 1\n";
    os << "\t\t.amdhsa_system_sgpr_workgroup_id_y " << (usesWgY ? 1 : 0)
       << "\n";
    os << "\t\t.amdhsa_system_sgpr_workgroup_id_z " << (usesWgZ ? 1 : 0)
       << "\n";
    os << "\t\t.amdhsa_system_sgpr_workgroup_info 0\n";
    os << "\t\t.amdhsa_system_vgpr_workitem_id " << entryUsage.maxWorkitemIdAxis
       << "\n";
    os << "\t\t.amdhsa_next_free_vgpr " << totalVGPRCount << "\n";
    os << "\t\t.amdhsa_next_free_sgpr " << *sgprCount << "\n";
    if (isGfx90APlus()) {
      unsigned accumOffset = alignUp(std::max(vgprCount, 1u), 4);
      os << "\t\t.amdhsa_accum_offset " << accumOffset << "\n";
    }
    if (supportsDescriptorNamedBarrierCount())
      os << "\t\t.amdhsa_named_barrier_count 0\n";
    os << "\t\t.amdhsa_reserve_vcc " << (reserveVCC ? 1 : 0) << "\n";
    os << "\t\t.amdhsa_float_round_mode_32 0\n";
    os << "\t\t.amdhsa_float_round_mode_16_64 0\n";
    os << "\t\t.amdhsa_float_denorm_mode_32 3\n";
    os << "\t\t.amdhsa_float_denorm_mode_16_64 3\n";
    if (supportsDescriptorDX10AndIEEE()) {
      os << "\t\t.amdhsa_dx10_clamp 1\n";
      os << "\t\t.amdhsa_ieee_mode 1\n";
    }
    os << "\t\t.amdhsa_fp16_overflow 0\n";
    if (!isGfx8Or9()) {
      if (supportsDescriptorWGPMode())
        os << "\t\t.amdhsa_workgroup_processor_mode 1\n";
      os << "\t\t.amdhsa_memory_ordered 1\n";
      os << "\t\t.amdhsa_forward_progress 1\n";
      if (supportsDescriptorSharedVGPRCount())
        os << "\t\t.amdhsa_shared_vgpr_count 0\n";
      if (supportsDescriptorRoundRobin()) {
        os << "\t\t.amdhsa_inst_pref_size instprefsize(" << funcLabelPrefix
           << ".end-" << func.getSymName() << ")\n";
        os << "\t\t.amdhsa_round_robin_scheduling 0\n";
      } else {
        os << "\t\t.amdhsa_inst_pref_size 1\n";
      }
    }
    os << "\t.end_amdhsa_kernel\n";
    os << "\t.text\n";
    os << "\t.set .L" << func.getSymName() << ".num_vgpr, " << vgprCount
       << "\n";
    os << "\t.set .L" << func.getSymName() << ".num_agpr, " << agprCount
       << "\n";
    os << "\t.set .L" << func.getSymName() << ".numbered_sgpr, " << *sgprCount
       << "\n";
    os << "\t.set .L" << func.getSymName() << ".num_named_barrier, 0\n";
    os << "\t.set .L" << func.getSymName() << ".private_seg_size, "
       << *privateSegmentFixedSize << "\n";
    os << "\t.set .L" << func.getSymName() << ".uses_vcc, "
       << (reserveVCC ? 1 : 0) << "\n";
    os << "\t.set .L" << func.getSymName() << ".uses_flat_scratch, "
       << (usesFlatScratch ? 1 : 0) << "\n";
    os << "\t.set .L" << func.getSymName() << ".has_dyn_sized_stack, 0\n";
    os << "\t.set .L" << func.getSymName() << ".has_recursion, 0\n";
    os << "\t.set .L" << func.getSymName() << ".has_indirect_call, 0\n";
    return success();
  }

  LogicalResult emitMetadata() {
    if (kernels.empty())
      return success();

    os << "\t.amdgpu_metadata\n";
    os << "---\n";
    os << "amdhsa.kernels:\n";
    for (const KernelInfo &kernel : kernels) {
      // `.args:` followed by a newline-only block is parsed as `null`
      // by the msgpack YAML reader, which then aborts in
      // `MsgPackDocumentYAML`. Emit an explicit empty list when the
      // kernel has no args so `llvm-mc` can round-trip the metadata.
      if (kernel.args.empty()) {
        os << "  - .args:           []\n";
      } else {
        os << "  - .args:\n";
      }
      for (const KernelArgInfo &arg : kernel.args) {
        if (arg.isGlobalBuffer) {
          os << "      - .address_space:  global\n";
          os << "        .name:           " << arg.name << "\n";
          os << "        .offset:         " << arg.offset << "\n";
          os << "        .size:           " << arg.size << "\n";
          os << "        .value_kind:     global_buffer\n";
        } else {
          os << "      - .name:           " << arg.name << "\n";
          os << "        .offset:         " << arg.offset << "\n";
          os << "        .size:           " << arg.size << "\n";
          os << "        .value_kind:     by_value\n";
        }
      }
      os << "    .group_segment_fixed_size: " << kernel.fixedLdsSize << "\n";
      os << "    .kernarg_segment_align: 8\n";
      os << "    .kernarg_segment_size: " << kernel.kernargSize << "\n";
      os << "    .max_flat_workgroup_size: " << kernel.maxFlatWorkgroupSize
         << "\n";
      os << "    .name:           " << kernel.name << "\n";
      os << "    .private_segment_fixed_size: "
         << kernel.privateSegmentFixedSize << "\n";
      os << "    .sgpr_count:     " << kernel.sgprCount << "\n";
      os << "    .sgpr_spill_count: " << kernel.sgprSpillCount << "\n";
      os << "    .symbol:         " << kernel.name << ".kd\n";
      os << "    .uses_dynamic_stack: false\n";
      os << "    .vgpr_count:     " << kernel.vgprCount << "\n";
      if (hasAGPRs())
        os << "    .agpr_count:     " << kernel.agprCount << "\n";
      os << "    .vgpr_spill_count: " << kernel.vgprSpillCount << "\n";
      os << "    .wavefront_size: " << wavefrontSize << "\n";
      if (supportsMetadataWGPMode())
        os << "    .workgroup_processor_mode: 1\n";
      for (const KernelMetadataEntryInfo &entry : kernel.metadataEntries)
        os << "    " << entry.name << ": " << entry.value << "\n";
    }
    os << "amdhsa.target:   " << getTargetID() << "\n";
    os << "amdhsa.version:\n";
    os << "  - 1\n";
    os << "  - 2\n";
    os << "...\n";
    os << "\t.end_amdgpu_metadata\n";
    return success();
  }

  std::string getTargetID() const {
    if (targetFeatures.empty())
      return targetTriple + "--" + targetChip;
    return targetTriple + "--" + targetChip + ":" + targetFeatures;
  }

  unsigned getPhys(Value value) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    if (regType.getIndex() >= 0)
      return regType.getIndex();
    llvm_unreachable("expected allocated WaveAMDMachine register");
  }

  std::string physReg(Value value) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    unsigned phys = getPhys(value);
    StringRef prefix = "s";
    if (regType.getRegClass() == waveamdmachine::RegClass::VGPR)
      prefix = "v";
    if (regType.getRegClass() == waveamdmachine::RegClass::AGPR)
      prefix = "a";
    if (regType.getWidth() == 1)
      return (prefix + Twine(phys)).str();
    return (prefix + Twine("[") + Twine(phys) + ":" +
            Twine(phys + regType.getWidth() - 1) + "]")
        .str();
  }

  std::string operandToString(Value value) const {
    if (Operation *def = value.getDefiningOp())
      if (isa<waveamdmachine::ImmOp>(def))
        return Twine(def->getAttrOfType<IntegerAttr>("value").getInt()).str();
    return physReg(value);
  }

  unsigned namedPhysReg(StringRef name) const {
    if (name.consume_front("s[")) {
      StringRef first;
      StringRef last;
      std::tie(first, last) = name.split(':');
      if (!last.consume_back("]"))
        llvm_unreachable("unknown physical register name");
      unsigned start = 0;
      unsigned end = 0;
      if (first.getAsInteger(10, start) || last.getAsInteger(10, end))
        llvm_unreachable("unknown physical register name");
      unsigned width = end - start + 1;
      if (width == 2)
        return llvm::AMDGPU::SGPR0_SGPR1 + start / 2;
      if (width == 4)
        return llvm::AMDGPU::SGPR0_SGPR1_SGPR2_SGPR3 + start / 4;
      llvm_unreachable("unknown physical register name");
    }
    if (name.consume_front("s")) {
      unsigned phys = 0;
      if (!name.getAsInteger(10, phys))
        return llvm::AMDGPU::SGPR0 + phys;
      llvm_unreachable("unknown physical register name");
    }
    if (name.consume_front("a")) {
      unsigned phys = 0;
      if (!name.getAsInteger(10, phys))
        return llvm::AMDGPU::AGPR0 + phys;
      llvm_unreachable("unknown physical register name");
    }
    if (name == "s0")
      return llvm::AMDGPU::SGPR0;
    if (name == "s[0:1]")
      return llvm::AMDGPU::SGPR0_SGPR1;
    if (name == "vcc")
      return llvm::AMDGPU::VCC;
    if (name == "m0")
      return llvm::AMDGPU::M0;
    if (name == "exec")
      return llvm::AMDGPU::EXEC;
    if (name == "exec_lo")
      return llvm::AMDGPU::EXEC_LO;
    if (name == "null")
      return llvm::AMDGPU::SGPR_NULL;
    if (name == "vcc_lo")
      return llvm::AMDGPU::VCC_LO;
    if (name == "vcc_hi")
      return llvm::AMDGPU::VCC_HI;
    llvm_unreachable("unknown physical register name");
  }

  unsigned mcReg(Value value) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    unsigned phys = getPhys(value);
    if (regType.getRegClass() == waveamdmachine::RegClass::VGPR)
      return mcVGPRReg(phys, regType.getWidth());
    if (regType.getRegClass() == waveamdmachine::RegClass::AGPR)
      return mcAGPRReg(phys, regType.getWidth());
    return mcSGPRReg(phys, regType.getWidth());
  }

  unsigned mcSGPRReg(unsigned phys, unsigned width) const {
    switch (width) {
    case 1:
      return llvm::AMDGPU::SGPR0 + phys;
    case 2:
      assert(phys % 2 == 0 && "SGPR pair must be aligned");
      return llvm::AMDGPU::SGPR0_SGPR1 + phys / 2;
    case 4:
      assert(phys % 4 == 0 && "SGPR quad must be aligned");
      return llvm::AMDGPU::SGPR0_SGPR1_SGPR2_SGPR3 + phys / 4;
    case 8:
      assert(phys % 4 == 0 && "SGPR octuple must be SReg_256 aligned");
      return llvm::AMDGPU::SGPR0_SGPR1_SGPR2_SGPR3_SGPR4_SGPR5_SGPR6_SGPR7 +
             phys / 4;
    default:
      llvm_unreachable("unsupported SGPR tuple width");
    }
  }

  unsigned mcVGPRReg(unsigned phys, unsigned width) const {
    unsigned lowVGPRCount = (mri->getEncodingValue(llvm::AMDGPU::VGPR255) &
                             llvm::AMDGPU::HWEncoding::REG_IDX_MASK) +
                            1;
    unsigned lowPhys = phys % lowVGPRCount;
    unsigned msbs = phys / lowVGPRCount;
    unsigned lowReg;
    switch (width) {
    case 1:
      lowReg = llvm::AMDGPU::VGPR0 + lowPhys;
      break;
    case 2:
      lowReg = llvm::AMDGPU::VGPR0_VGPR1 + lowPhys;
      break;
    case 3:
      lowReg = llvm::AMDGPU::VGPR0_VGPR1_VGPR2 + lowPhys;
      break;
    case 4:
      lowReg = llvm::AMDGPU::VGPR0_VGPR1_VGPR2_VGPR3 + lowPhys;
      break;
    case 8:
      lowReg = llvm::AMDGPU::VGPR0_VGPR1_VGPR2_VGPR3_VGPR4_VGPR5_VGPR6_VGPR7 +
               lowPhys;
      break;
    case 16:
      lowReg =
          llvm::AMDGPU::
              VGPR0_VGPR1_VGPR2_VGPR3_VGPR4_VGPR5_VGPR6_VGPR7_VGPR8_VGPR9_VGPR10_VGPR11_VGPR12_VGPR13_VGPR14_VGPR15 +
          lowPhys;
      break;
    default:
      llvm_unreachable("unsupported VGPR tuple width");
    }
    return llvm::AMDGPU::getVGPRWithMSBs(llvm::MCRegister(lowReg), msbs, *mri)
        .id();
  }

  unsigned mcAGPRReg(unsigned phys, unsigned width) const {
    switch (width) {
    case 1:
      return llvm::AMDGPU::AGPR0 + phys;
    case 2:
      return llvm::AMDGPU::AGPR0_AGPR1 + phys;
    case 3:
      return llvm::AMDGPU::AGPR0_AGPR1_AGPR2 + phys;
    case 4:
      return llvm::AMDGPU::AGPR0_AGPR1_AGPR2_AGPR3 + phys;
    case 8:
      return llvm::AMDGPU::AGPR0_AGPR1_AGPR2_AGPR3_AGPR4_AGPR5_AGPR6_AGPR7 +
             phys;
    case 16:
      return llvm::AMDGPU::
                 AGPR0_AGPR1_AGPR2_AGPR3_AGPR4_AGPR5_AGPR6_AGPR7_AGPR8_AGPR9_AGPR10_AGPR11_AGPR12_AGPR13_AGPR14_AGPR15 +
             phys;
    default:
      llvm_unreachable("unsupported AGPR tuple width");
    }
  }

  llvm::MCOperand toMCVGPRComponent(Value value, unsigned component) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    if (regType.getRegClass() != waveamdmachine::RegClass::VGPR ||
        component >= regType.getWidth())
      llvm_unreachable("expected valid VGPR tuple component");
    return llvm::MCOperand::createReg(mcVGPRReg(getPhys(value) + component, 1));
  }

  llvm::MCOperand toMCVGPRPairFromLo(Value value) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    if (regType.getRegClass() != waveamdmachine::RegClass::VGPR ||
        regType.getWidth() != 1)
      llvm_unreachable("expected scalar VGPR pair base");
    return llvm::MCOperand::createReg(mcVGPRReg(getPhys(value), 2));
  }

  llvm::MCOperand toMCVGPRLo16(Value value) const {
    waveamdmachine::RegType regType =
        cast<waveamdmachine::RegType>(value.getType());
    if (regType.getRegClass() != waveamdmachine::RegClass::VGPR ||
        regType.getWidth() != 1)
      llvm_unreachable("expected scalar VGPR");
    return llvm::MCOperand::createReg(llvm::AMDGPU::VGPR0_LO16 +
                                      getPhys(value));
  }

  llvm::MCOperand toMCSGPRComponent(Value value, unsigned component) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    if (regType.getRegClass() != waveamdmachine::RegClass::SGPR ||
        component >= regType.getWidth())
      llvm_unreachable("expected valid SGPR tuple component");
    return llvm::MCOperand::createReg(llvm::AMDGPU::SGPR0 + getPhys(value) +
                                      component);
  }

  llvm::MCOperand toMCAGPRComponent(Value value, unsigned component) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    if (regType.getRegClass() != waveamdmachine::RegClass::AGPR ||
        component >= regType.getWidth())
      llvm_unreachable("expected valid AGPR tuple component");
    return llvm::MCOperand::createReg(mcAGPRReg(getPhys(value) + component, 1));
  }

  llvm::MCOperand toMCB32Component(Value value, unsigned component) {
    waveamdmachine::RegType regType =
        dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!regType || regType.getWidth() == 1)
      return toMCOperand(value);
    if (regType.getRegClass() == waveamdmachine::RegClass::VGPR)
      return toMCVGPRComponent(value, component);
    if (regType.getRegClass() == waveamdmachine::RegClass::SGPR)
      return toMCSGPRComponent(value, component);
    if (regType.getRegClass() == waveamdmachine::RegClass::AGPR)
      return toMCAGPRComponent(value, component);
    llvm_unreachable("expected GPR tuple component");
  }

  llvm::MCOperand toMCB32(Value value) { return toMCB32Component(value, 0); }

  llvm::MCOperand toMCOperand(Value value) {
    if (Operation *def = value.getDefiningOp())
      if (isa<waveamdmachine::ImmOp>(def))
        return llvm::MCOperand::createImm(
            def->getAttrOfType<IntegerAttr>("value").getInt());
    return llvm::MCOperand::createReg(mcReg(value));
  }

  llvm::MCOperand labelOperand(StringRef name) {
    llvm::MCSymbol *sym = mcContext->getOrCreateSymbol(name);
    return llvm::MCOperand::createExpr(
        llvm::MCSymbolRefExpr::create(sym, *mcContext));
  }

  LogicalResult validateHighVGPREncoding(const llvm::MCInst &inst) const {
    if (!hasVGPRWindowing())
      return success();
    unsigned opcode = inst.getOpcode();
    const llvm::MCInstrDesc &desc = mcii->get(opcode);
    if (hasUnsupportedVGPRWindowMapping(desc)) {
      for (auto [index, operand] : llvm::enumerate(inst)) {
        if (!operand.isReg() ||
            !llvm::AMDGPU::getVGPRPhysRegClass(operand.getReg(), *mri) ||
            llvm::AMDGPU::getVGPREncodingMSBs(operand.getReg(), *mri) == 0)
          continue;
        return emissionSource->emitError(
                   "LLVM VGPR-window mapping is unavailable for ")
               << mcii->getName(opcode) << " emitted by "
               << emissionSource->getName() << ": operand " << index
               << " has MSBs "
               << llvm::AMDGPU::getVGPREncodingMSBs(operand.getReg(), *mri);
      }
      return success();
    }

    auto [primary, secondary] =
        llvm::AMDGPU::getVGPRLoweringOperandTables(desc);

    if (secondary) {
      for (unsigned field : llvm::seq<unsigned>(0, kVGPRWindowFieldCount)) {
        int primaryIndex = getVGPRWindowOperandIndex(opcode, primary, field);
        int secondaryIndex =
            getVGPRWindowOperandIndex(opcode, secondary, field);
        if (primaryIndex < 0 || secondaryIndex < 0 ||
            static_cast<unsigned>(primaryIndex) >= inst.getNumOperands() ||
            static_cast<unsigned>(secondaryIndex) >= inst.getNumOperands())
          continue;
        const llvm::MCOperand &primaryOperand = inst.getOperand(primaryIndex);
        const llvm::MCOperand &secondaryOperand =
            inst.getOperand(secondaryIndex);
        if (!primaryOperand.isReg() || !secondaryOperand.isReg())
          continue;
        llvm::MCRegister primaryReg = primaryOperand.getReg();
        llvm::MCRegister secondaryReg = secondaryOperand.getReg();
        if (!llvm::AMDGPU::getVGPRPhysRegClass(primaryReg, *mri) ||
            !llvm::AMDGPU::getVGPRPhysRegClass(secondaryReg, *mri))
          continue;
        unsigned primaryMSBs =
            llvm::AMDGPU::getVGPREncodingMSBs(primaryReg, *mri);
        unsigned secondaryMSBs =
            llvm::AMDGPU::getVGPREncodingMSBs(secondaryReg, *mri);
        if (primaryMSBs == secondaryMSBs)
          continue;
        return emissionSource->emitError("incompatible VGPR windows for ")
               << mcii->getName(opcode) << " emitted by "
               << emissionSource->getName() << ": field " << field
               << ", operands " << primaryIndex << '/' << secondaryIndex
               << " have MSBs " << primaryMSBs << '/' << secondaryMSBs;
      }
    }

    for (auto [index, operand] : llvm::enumerate(inst)) {
      if (!operand.isReg())
        continue;
      llvm::MCRegister reg = operand.getReg();
      if (!llvm::AMDGPU::getVGPRPhysRegClass(reg, *mri) ||
          llvm::AMDGPU::getVGPREncodingMSBs(reg, *mri) == 0)
        continue;
      bool mapped = false;
      for (unsigned field = 0; field < kVGPRWindowFieldCount && !mapped;
           ++field)
        mapped = getVGPRWindowOperandIndex(opcode, primary, field) ==
                     static_cast<int>(index) ||
                 getVGPRWindowOperandIndex(opcode, secondary, field) ==
                     static_cast<int>(index);
      if (mapped)
        continue;
      return emissionSource->emitError("high VGPR operand ")
             << index << " (MSBs "
             << llvm::AMDGPU::getVGPREncodingMSBs(reg, *mri) << ") of "
             << mcii->getName(opcode) << " emitted by "
             << emissionSource->getName() << " has no LLVM VGPR-window mapping";
    }
    return success();
  }

  LogicalResult validateMCRegisterClasses(const llvm::MCInst &inst) const {
    unsigned opcode = inst.getOpcode();
    const llvm::MCInstrDesc &desc = mcii->get(opcode);
    unsigned hwMode = sti->getHwMode(llvm::MCSubtargetInfo::HwMode_RegInfo);
    for (auto [index, operand] : llvm::enumerate(inst)) {
      if (!operand.isReg() || index >= desc.getNumOperands())
        continue;
      int16_t regClassId =
          mcii->getOpRegClassID(desc.operands()[index], hwMode);
      if (regClassId < 0)
        continue;
      if (static_cast<unsigned>(regClassId) >= mri->getNumRegClasses())
        return emissionSource->emitError("invalid LLVM MC register class for ")
               << mcii->getName(opcode) << " operand " << index;
      llvm::MCRegister reg = operand.getReg();
      if (reg.id() >= mri->getNumRegs())
        return emissionSource->emitError("invalid LLVM MC register ")
               << reg.id() << " for " << mcii->getName(opcode) << " operand "
               << index;
      const llvm::MCRegisterClass &regClass = mri->getRegClass(regClassId);
      if (regClass.contains(reg) ||
          regClass.contains(llvm::AMDGPU::mc2PseudoReg(reg)))
        continue;
      return emissionSource->emitError("LLVM MC register-class mismatch for ")
             << mcii->getName(opcode) << " operand " << index << ": "
             << mri->getName(reg) << " is not "
             << mri->getRegClassName(&regClass);
    }
    return success();
  }

  LogicalResult emitMC(unsigned opcode, ArrayRef<llvm::MCOperand> operands) {
    if (opcode == llvm::AMDGPU::INSTRUCTION_LIST_END ||
        opcode >= mcii->getNumOpcodes())
      return emissionSource->emitError("no LLVM MC opcode mapping for ")
             << emissionSource->getName() << " on " << targetChip;
    const llvm::MCInstrDesc &desc = mcii->get(opcode);
    if (!desc.isVariadic() && operands.size() != desc.getNumOperands())
      return emissionSource->emitError("LLVM MC operand count mismatch for ")
             << emissionSource->getName() << ": " << mcii->getName(opcode)
             << " expects " << desc.getNumOperands() << ", got "
             << operands.size();
    llvm::MCInst inst;
    inst.setOpcode(opcode);
    for (const llvm::MCOperand &operand : operands)
      inst.addOperand(operand);
    if (failed(validateHighVGPREncoding(inst)) ||
        failed(validateMCRegisterClasses(inst)))
      return failure();
    if (bufferingMC) {
      mcBuffer.push_back(
          BufferedMCInstruction{inst, emissionSource, /*bufferId=*/0, indent});
      return success();
    }
    printIndent(indent);
    instPrinter->printInst(&inst, /*Address=*/0, /*Annot=*/"", *sti, os);
    os << '\n';
    return success();
  }

  LogicalResult emitGfx1250Wmma(unsigned pseudoOpcode, Value dst, Value a,
                                Value b, Value acc) {
    if (!isGfx1250())
      return emissionSource->emitError("gfx1250 WMMA unsupported on target");
    llvm::MCOperand dstOperand = toMCOperand(dst);
    llvm::MCOperand accOperand = toMCOperand(acc);
    if (!accOperand.isReg() || accOperand.getReg() != dstOperand.getReg()) {
      pseudoOpcode = llvm::AMDGPU::mapWMMA2AddrTo3AddrOpcode(pseudoOpcode);
      if (pseudoOpcode == ~0u)
        return emissionSource->emitError(
            "LLVM WMMA three-address mapping is unavailable");
    }
    unsigned opcode = postVIOpcode(pseudoOpcode);
    if (opcode == llvm::AMDGPU::INSTRUCTION_LIST_END ||
        opcode >= mcii->getNumOpcodes())
      return emissionSource->emitError(
          "LLVM WMMA MC opcode mapping is unavailable");
    const llvm::MCInstrDesc &desc = mcii->get(opcode);
    SmallVector<llvm::MCOperand> operands(desc.getNumOperands(),
                                          llvm::MCOperand::createImm(0));
    llvm::SmallBitVector assigned(desc.getNumOperands());
    auto setOperand = [&](llvm::AMDGPU::OpName name,
                          llvm::MCOperand operand) -> LogicalResult {
      int index = llvm::AMDGPU::getNamedOperandIdx(opcode, name);
      if (index < 0 || static_cast<unsigned>(index) >= operands.size())
        return emissionSource->emitError(
            "LLVM MC WMMA operand schema mismatch");
      operands[index] = operand;
      assigned.set(index);
      return success();
    };
    llvm::MCOperand zero = llvm::MCOperand::createImm(0);
    if (failed(setOperand(llvm::AMDGPU::OpName::vdst, dstOperand)) ||
        failed(setOperand(llvm::AMDGPU::OpName::src0, toMCOperand(a))) ||
        failed(setOperand(llvm::AMDGPU::OpName::src1, toMCOperand(b))) ||
        failed(setOperand(llvm::AMDGPU::OpName::src2_modifiers, zero)) ||
        failed(setOperand(llvm::AMDGPU::OpName::src2, accOperand)) ||
        failed(setOperand(llvm::AMDGPU::OpName::matrix_a_reuse, zero)) ||
        failed(setOperand(llvm::AMDGPU::OpName::matrix_b_reuse, zero)) ||
        failed(setOperand(llvm::AMDGPU::OpName::neg_lo, zero)) ||
        failed(setOperand(llvm::AMDGPU::OpName::neg_hi, zero)))
      return failure();
    if (!assigned.all())
      return emissionSource->emitError("LLVM MC WMMA operand schema changed");
    return emitMC(opcode, operands);
  }

  LogicalResult emitLegacyLdsDma(unsigned opcode,
                                 SmallVector<llvm::MCOperand> operands) {
    int isAsyncIndex =
        llvm::AMDGPU::getNamedOperandIdx(opcode, llvm::AMDGPU::OpName::IsAsync);
    if (isAsyncIndex < 0)
      return emissionSource->emitError(
          "LLVM MC opcode has no legacy LDS-DMA IsAsync operand");
    if (static_cast<unsigned>(isAsyncIndex) > operands.size())
      return emissionSource->emitError(
          "LLVM MC legacy LDS-DMA IsAsync operand is out of order");
    operands.insert(operands.begin() + isAsyncIndex,
                    llvm::MCOperand::createImm(0));
    return emitMC(opcode, operands);
  }

  LogicalResult emitMCValues(unsigned opcode, ValueRange operands) {
    SmallVector<llvm::MCOperand> mcOperands;
    for (Value operand : operands)
      mcOperands.push_back(toMCOperand(operand));
    return emitMC(opcode, mcOperands);
  }

  LogicalResult emitSNopCycles(uint64_t cycles) {
    while (cycles != 0) {
      uint64_t chunk = std::min<uint64_t>(cycles, 16);
      if (failed(emitMC(sNop(), {llvm::MCOperand::createImm(chunk - 1)})))
        return failure();
      cycles -= chunk;
    }
    return success();
  }

  LogicalResult emitDmaIssueDelay(waveamdmachine::DmaIssueDelayOp delay) {
    Value condition = delay.getSkipCondition();
    std::string skipLabel;
    if (condition) {
      skipLabel = (funcLabelPrefix + ".dma_issue_delay_" +
                   Twine(dmaIssueDelayCounter++))
                      .str();
      if (failed(emitMC(sCbranchVccnz(), {labelOperand(skipLabel)})))
        return failure();
    }
    if (failed(emitSNopCycles(
            static_cast<uint64_t>(delay.getCyclesAttr().getInt()))))
      return failure();
    if (condition)
      emitLabel(skipLabel);
    return success();
  }

  unsigned packedSrcMods(unsigned opSel, unsigned opSelHi, unsigned negLo,
                         unsigned negHi, unsigned operandIndex) const {
    return ((negLo >> operandIndex) & 1) |
           (((negHi >> operandIndex) & 1) << 1) |
           (((opSel >> operandIndex) & 1) << 2) |
           (((opSelHi >> operandIndex) & 1) << 3);
  }

  unsigned packedSrcMods(unsigned opSel, unsigned opSelHi,
                         unsigned operandIndex) const {
    return packedSrcMods(opSel, opSelHi, 0, 0, operandIndex);
  }

  LogicalResult emitPackedBinary(unsigned opcode, Operation &op) {
    unsigned opSel = getIntAttr(&op, "op_sel", 0);
    unsigned opSelHi = getIntAttr(&op, "op_sel_hi", 3);
    unsigned negLo = getIntAttr(&op, "neg_lo", 0);
    unsigned negHi = getIntAttr(&op, "neg_hi", 0);
    return emitMC(
        opcode,
        {toMCOperand(op.getResult(0)),
         llvm::MCOperand::createImm(
             packedSrcMods(opSel, opSelHi, negLo, negHi, 0)),
         toMCOperand(op.getOperand(0)),
         llvm::MCOperand::createImm(
             packedSrcMods(opSel, opSelHi, negLo, negHi, 1)),
         toMCOperand(op.getOperand(1)),
         llvm::MCOperand::createImm(getBoolAttr(&op, "clamp", false)),
         llvm::MCOperand::createImm(opSel), llvm::MCOperand::createImm(opSelHi),
         llvm::MCOperand::createImm(negLo), llvm::MCOperand::createImm(negHi)});
  }

  LogicalResult emitPackedTernary(unsigned opcode, Operation &op) {
    unsigned opSel = getIntAttr(&op, "op_sel", 0);
    unsigned opSelHi = getIntAttr(&op, "op_sel_hi", 7);
    unsigned negLo = getIntAttr(&op, "neg_lo", 0);
    unsigned negHi = getIntAttr(&op, "neg_hi", 0);
    return emitMC(
        opcode,
        {toMCOperand(op.getResult(0)),
         llvm::MCOperand::createImm(
             packedSrcMods(opSel, opSelHi, negLo, negHi, 0)),
         toMCOperand(op.getOperand(0)),
         llvm::MCOperand::createImm(
             packedSrcMods(opSel, opSelHi, negLo, negHi, 1)),
         toMCOperand(op.getOperand(1)),
         llvm::MCOperand::createImm(
             packedSrcMods(opSel, opSelHi, negLo, negHi, 2)),
         toMCOperand(op.getOperand(2)),
         llvm::MCOperand::createImm(getBoolAttr(&op, "clamp", false)),
         llvm::MCOperand::createImm(opSel), llvm::MCOperand::createImm(opSelHi),
         llvm::MCOperand::createImm(negLo), llvm::MCOperand::createImm(negHi)});
  }

  LogicalResult emitTernaryF32(unsigned opcode, Operation &op) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), llvm::MCOperand::createImm(0),
                   toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
                   toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
                   toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(0),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitPackedCvtVOP3(unsigned opcode, Operation &op) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), llvm::MCOperand::createImm(0),
                   toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
                   toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitCvtF32F16Sdwa(Operation &op) {
    unsigned src0Sel = getIntAttr(&op, "src0_sel", kSdwaWord1);
    SmallVector<llvm::MCOperand> operands = {
        toMCOperand(op.getResult(0)), llvm::MCOperand::createImm(0),
        toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0)};
    if (isaVersion.Major == 9)
      operands.push_back(llvm::MCOperand::createImm(0));
    operands.push_back(llvm::MCOperand::createImm(kSdwaDword));
    operands.push_back(llvm::MCOperand::createImm(kSdwaUnusedPad));
    operands.push_back(llvm::MCOperand::createImm(src0Sel));
    return emitMC(vCvtF32F16Sdwa(), operands);
  }

  LogicalResult emitTernaryInt(unsigned opcode, Operation &op) {
    if (failed(requireOperandLegality(op, op.getName().stripDialect())))
      return failure();
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCB32(op.getOperand(0)),
                   toMCB32(op.getOperand(1)), toMCB32(op.getOperand(2))});
  }

  LogicalResult emitBitOp3B32(Operation &op) {
    if (failed(requireOperandLegality(op, op.getName().stripDialect())))
      return failure();
    return emitMC(vBitOp3B32(),
                  {toMCOperand(op.getResult(0)), toMCB32(op.getOperand(0)),
                   toMCB32(op.getOperand(1)), toMCB32(op.getOperand(2)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "bitop3", 0))});
  }

  LogicalResult emitTernaryIntClamp(unsigned opcode, Operation &op) {
    if (failed(requireOperandLegality(op, op.getName().stripDialect())))
      return failure();
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCB32(op.getOperand(0)),
                   toMCB32(op.getOperand(1)), toMCB32(op.getOperand(2)),
                   llvm::MCOperand::createImm(0)});
  }

  // Shared emit shapes for the width-parameterised mem ops. The MC
  // operand order is what the LLVM AMDGPU printer expects per family:
  //   GLOBAL_*_SADDR: vdst/vdata, saddr, vaddr, offset, cpol
  //   BUFFER_*_OFFEN: vdst/vdata, vaddr, srsrc, soffset, offset, cpol
  //   DS_READ_*:      vdst, vaddr, offset, gds
  //   DS_WRITE_*:     vaddr, vdata, offset, gds
  LogicalResult emitGlobalLoad(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    FailureOr<unsigned> cpol = getLoadCacheCPol(op);
    if (failed(cpol))
      return failure();
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(1)),
                   toMCOperand(op.getOperand(0)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(*cpol)});
  }

  LogicalResult emitGlobalStore(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    FailureOr<unsigned> cpol = getStoreCacheCPol(op);
    if (failed(cpol))
      return failure();
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   toMCOperand(op.getOperand(2)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(*cpol)});
  }

  LogicalResult emitGlobalAtomicAddAcqRel(Operation &op) {
    if (!waveamdmachine::GlobalAtomicAddAcqRelU32Op::isSupportedOnIsa(
            isaVersion))
      return op.emitError(
          "agent-scoped acquire-release global atomic requires gfx940+ or "
          "gfx1250");

    if (usesSplitWaitCounters()) {
      unsigned scope = llvm::AMDGPU::CPol::SCOPE_DEV;
      unsigned atomicCpol = llvm::AMDGPU::CPol::TH_ATOMIC_RETURN | scope;
      unsigned loadDsZero = llvm::AMDGPU::encodeLoadcntDscnt(isaVersion, 0, 0);
      if (failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_LOADCNT),
                        {llvm::MCOperand::createImm(0)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_STORECNT),
                        {llvm::MCOperand::createImm(0)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::GLOBAL_WB),
                        {llvm::MCOperand::createImm(scope)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_STORECNT),
                        {llvm::MCOperand::createImm(0)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_XCNT),
                        {llvm::MCOperand::createImm(0)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_LOADCNT_DSCNT),
                        {llvm::MCOperand::createImm(loadDsZero)})) ||
          failed(emitMC(
              globalAtomicAddSaddrRtnU32(),
              {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
               toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
               llvm::MCOperand::createImm(getIntAttr(&op, "inst_offset", 0)),
               llvm::MCOperand::createImm(atomicCpol)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_LOADCNT),
                        {llvm::MCOperand::createImm(0)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::GLOBAL_INV),
                        {llvm::MCOperand::createImm(scope)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_LOADCNT),
                        {llvm::MCOperand::createImm(0)})))
        return failure();
      return success();
    }

    unsigned waitAll = llvm::AMDGPU::encodeWaitcnt(
        isaVersion, /*vmcnt=*/0, /*expcnt=*/~0u, /*lgkmcnt=*/0);
    unsigned waitVmem = llvm::AMDGPU::encodeWaitcnt(
        isaVersion, /*vmcnt=*/0, /*expcnt=*/~0u, /*lgkmcnt=*/~0u);
    if (failed(emitMC(llvm::AMDGPU::BUFFER_WBL2_gfx940,
                      {llvm::MCOperand::createImm(llvm::AMDGPU::CPol::SC1)})) ||
        failed(emitMC(sWaitcnt(), {llvm::MCOperand::createImm(waitAll)})) ||
        failed(emitMC(
            globalAtomicAddSaddrRtnU32(),
            {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
             toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
             llvm::MCOperand::createImm(getIntAttr(&op, "inst_offset", 0)),
             llvm::MCOperand::createImm(llvm::AMDGPU::CPol::SC0)})) ||
        failed(emitMC(sWaitcnt(), {llvm::MCOperand::createImm(waitVmem)})))
      return failure();
    return emitMC(llvm::AMDGPU::BUFFER_INV_gfx940,
                  {llvm::MCOperand::createImm(llvm::AMDGPU::CPol::SC1)});
  }

  LogicalResult emitGlobalAddrLoad(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    FailureOr<unsigned> cpol = getLoadCacheCPol(op);
    if (failed(cpol))
      return failure();
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(*cpol)});
  }

  LogicalResult emitGlobalAddrStore(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    FailureOr<unsigned> cpol = getStoreCacheCPol(op);
    if (failed(cpol))
      return failure();
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(*cpol)});
  }

  LogicalResult emitBufferLoad(Operation &op, unsigned opcode,
                               bool tiedDestination = false) {
    FailureOr<llvm::MCOperand> soffset =
        getBufferSoffsetOperand(op, opcode, op.getOperand(2));
    if (failed(soffset))
      return failure();
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    FailureOr<unsigned> cpol = getLoadCacheCPol(op);
    if (failed(cpol))
      return failure();
    SmallVector<llvm::MCOperand> operands = {
        toMCOperand(op.getResult(0)),
        toMCOperand(op.getOperand(0)),
        toMCOperand(op.getOperand(1)),
        *soffset,
        llvm::MCOperand::createImm(instOffset),
        llvm::MCOperand::createImm(*cpol),
        llvm::MCOperand::createImm(0)};
    if (tiedDestination)
      operands.push_back(toMCOperand(op.getResult(0)));
    return emitMC(opcode, operands);
  }

  LogicalResult emitBufferLoadD16Hi(Operation &op, unsigned opcode) {
    FailureOr<llvm::MCOperand> soffset =
        getBufferSoffsetOperand(op, opcode, op.getOperand(3));
    if (failed(soffset))
      return failure();
    if (!waveamdmachine::isSamePhysicalReg(op.getResult(0), op.getOperand(1)))
      return op.emitError("D16 high load result must reuse preserved operand");
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    FailureOr<unsigned> cpol = getLoadCacheCPol(op);
    if (failed(cpol))
      return failure();
    return emitMC(
        opcode, {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                 toMCOperand(op.getOperand(2)), *soffset,
                 llvm::MCOperand::createImm(instOffset),
                 llvm::MCOperand::createImm(*cpol),
                 llvm::MCOperand::createImm(0), toMCOperand(op.getResult(0))});
  }

  LogicalResult emitScratchLoad(Operation &op) {
    if (failed(rejectCacheAttr(op, "scratch load")))
      return failure();
    if (failed(rejectNonZeroLiteralScratchVaddr(op, op.getOperand(0))) ||
        failed(rejectNonZeroLiteralScratchSaddr(op, op.getOperand(1))))
      return failure();
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    bool vaddrOff = getImmediate(op.getOperand(0)).has_value();
    bool saddrOff = getImmediate(op.getOperand(1)).has_value();
    if (vaddrOff && saddrOff)
      return op.emitError(
          "scratch load requires at least one address register");
    if (vaddrOff)
      return emitMC(scratchLoadB32Saddr(),
                    {toMCOperand(op.getResult(0)),
                     toMCOperand(op.getOperand(1)),
                     llvm::MCOperand::createImm(instOffset),
                     llvm::MCOperand::createImm(getNonVolatileMemoryCPol())});
    if (saddrOff)
      return emitMC(scratchLoadB32Ve(),
                    {toMCOperand(op.getResult(0)),
                     toMCOperand(op.getOperand(0)),
                     llvm::MCOperand::createImm(instOffset),
                     llvm::MCOperand::createImm(getNonVolatileMemoryCPol())});
    return emitMC(scratchLoadB32Svs(),
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(getNonVolatileMemoryCPol())});
  }

  LogicalResult emitScratchStore(Operation &op) {
    if (failed(rejectCacheAttr(op, "scratch store")))
      return failure();
    if (failed(rejectNonZeroLiteralScratchVaddr(op, op.getOperand(0))) ||
        failed(rejectNonZeroLiteralScratchSaddr(op, op.getOperand(2))))
      return failure();
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    bool vaddrOff = getImmediate(op.getOperand(0)).has_value();
    bool saddrOff = getImmediate(op.getOperand(2)).has_value();
    if (vaddrOff && saddrOff)
      return op.emitError(
          "scratch store requires at least one address register");
    if (vaddrOff)
      return emitMC(scratchStoreB32Saddr(),
                    {toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(2)),
                     llvm::MCOperand::createImm(instOffset),
                     llvm::MCOperand::createImm(getNonVolatileMemoryCPol())});
    if (saddrOff)
      return emitMC(scratchStoreB32Ve(),
                    {toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(0)),
                     llvm::MCOperand::createImm(instOffset),
                     llvm::MCOperand::createImm(getNonVolatileMemoryCPol())});
    return emitMC(scratchStoreB32Svs(),
                  {toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(0)),
                   toMCOperand(op.getOperand(2)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(getNonVolatileMemoryCPol())});
  }

  LogicalResult emitBufferLoadLds(Operation &op, unsigned opcode) {
    if (failed(rejectCacheAttr(op, "buffer LDS load")))
      return failure();
    if (failed(rejectNonZeroLiteralSoffset(op, op.getOperand(2))))
      return failure();
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    int64_t aux = getIntAttr(&op, "aux", 0);
    return emitLegacyLdsDma(
        opcode,
        {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
         toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(instOffset),
         llvm::MCOperand::createImm(aux), llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitBufferStore(Operation &op, unsigned opcode) {
    FailureOr<llvm::MCOperand> soffset =
        getBufferSoffsetOperand(op, opcode, op.getOperand(3));
    if (failed(soffset))
      return failure();
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    FailureOr<unsigned> cpol = getStoreCacheCPol(op);
    if (failed(cpol))
      return failure();
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(0)),
                   toMCOperand(op.getOperand(2)), *soffset,
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(*cpol),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult rejectNonZeroLiteralSoffset(Operation &op, Value soffset) {
    if (std::optional<unsigned> imm = getImmediate(soffset))
      if (*imm != 0)
        return op.emitError("buffer nonzero literal soffset must be SGPR");
    return success();
  }

  FailureOr<llvm::MCOperand>
  getBufferSoffsetOperand(Operation &op, unsigned opcode, Value soffset) {
    if (failed(rejectNonZeroLiteralSoffset(op, soffset)))
      return failure();
    llvm::MCOperand operand = toMCOperand(soffset);
    if (!operand.isImm())
      return operand;
    int index =
        llvm::AMDGPU::getNamedOperandIdx(opcode, llvm::AMDGPU::OpName::soffset);
    if (index < 0)
      return op.emitError("LLVM MC opcode has no named soffset operand");
    if (mcii->get(opcode).operands()[index].OperandType ==
        llvm::MCOI::OPERAND_REGISTER)
      return llvm::MCOperand::createReg(namedPhysReg("null"));
    return operand;
  }

  LogicalResult rejectNonZeroLiteralScratchVaddr(Operation &op, Value vaddr) {
    if (std::optional<unsigned> imm = getImmediate(vaddr))
      if (*imm != 0)
        return op.emitError("scratch nonzero literal vaddr must be VGPR");
    return success();
  }

  LogicalResult rejectNonZeroLiteralScratchSaddr(Operation &op, Value saddr) {
    if (std::optional<unsigned> imm = getImmediate(saddr))
      if (*imm != 0)
        return op.emitError("scratch nonzero literal saddr must be SGPR");
    return success();
  }

  LogicalResult emitDsLoad(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsLoad2(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset0", 0)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset1", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsStore(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsStore2(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   toMCOperand(op.getOperand(2)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset0", 0)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset1", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsAdd(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsAddRtn(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsAddTidLoad(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsAddTidStore(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsPermute(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0))});
  }

  LogicalResult emitVAddU32(llvm::MCOperand dst, llvm::MCOperand lhs,
                            llvm::MCOperand rhs, Operation &op) {
    if (isaVersion.Major == 8)
      return op.emitError("v_add_u32 without VCC result unsupported on gfx8");
    if (isaVersion.Major == 9)
      return emitMC(llvm::AMDGPU::V_ADD_U32_e32_gfx9, {dst, lhs, rhs});
    return emitMC(postVIOpcode(llvm::AMDGPU::V_ADD_U32_e32), {dst, lhs, rhs});
  }

  LogicalResult emitVAddU32Vcc(llvm::MCOperand dst, llvm::MCOperand lhs,
                               llvm::MCOperand rhs) {
    if (isaVersion.Major == 8)
      return emitMC(llvm::AMDGPU::V_ADD_U32_e32_vi, {dst, lhs, rhs});
    if (isaVersion.Major == 9)
      return emitMC(llvm::AMDGPU::V_ADD_CO_U32_e32_gfx9, {dst, lhs, rhs});
    llvm::MCOperand vccLo = llvm::MCOperand::createReg(namedPhysReg("vcc_lo"));
    llvm::MCOperand clamp = llvm::MCOperand::createImm(0);
    return emitMC(postVIOpcode(llvm::AMDGPU::V_ADD_CO_U32_e64),
                  {dst, vccLo, lhs, rhs, clamp});
  }

  LogicalResult emitVMulLoU32(Operation &op, Value dst, Value lhs, Value rhs) {
    if (failed(waveamdmachine::requireVMulU32OperandLegality(
            &op, "v_mul_lo_u32", isaVersion, targetChip,
            [](Value lhs, Value rhs) {
              return waveamdmachine::isSamePhysicalReg(lhs, rhs);
            })))
      return failure();
    if (isGfx8Or9()) {
      std::optional<unsigned> lhsImm = getImmediate(lhs);
      std::optional<unsigned> rhsImm = getImmediate(rhs);
      if (lhsImm || rhsImm) {
        Value immValue = lhsImm ? lhs : rhs;
        Value regValue = lhsImm ? rhs : lhs;
        if (failed(emitMC(vMovB32(), {toMCOperand(dst), toMCB32(immValue)})))
          return failure();
        return emitMC(vMulLoU32(),
                      {toMCOperand(dst), toMCOperand(dst), toMCB32(regValue)});
      }
    }
    return emitMC(vMulLoU32(), {toMCOperand(dst), toMCB32(lhs), toMCB32(rhs)});
  }

  LogicalResult emitVMulHiU32(Operation &op, Value dst, Value lhs, Value rhs) {
    if (failed(waveamdmachine::requireVMulU32OperandLegality(
            &op, "v_mul_hi_u32", isaVersion, targetChip,
            [](Value lhs, Value rhs) {
              return waveamdmachine::isSamePhysicalReg(lhs, rhs);
            })))
      return failure();
    if (isGfx8Or9()) {
      std::optional<unsigned> lhsImm = getImmediate(lhs);
      std::optional<unsigned> rhsImm = getImmediate(rhs);
      if (lhsImm || rhsImm) {
        Value immValue = lhsImm ? lhs : rhs;
        Value regValue = lhsImm ? rhs : lhs;
        if (failed(emitMC(vMovB32(), {toMCOperand(dst), toMCB32(immValue)})))
          return failure();
        return emitMC(vMulHiU32(),
                      {toMCOperand(dst), toMCOperand(dst), toMCB32(regValue)});
      }
    }
    return emitMC(vMulHiU32(), {toMCOperand(dst), toMCB32(lhs), toMCB32(rhs)});
  }

  LogicalResult emitUniformLoop(waveamdmachine::UniformLoopOp loop) {
    unsigned id = loopCounter++;
    std::string headLabel = (funcLabelPrefix + ".loop_head_" + Twine(id)).str();
    std::string exitLabel = (funcLabelPrefix + ".loop_exit_" + Twine(id)).str();
    if (loop.getEntryCond()) {
      // SCC was already set by an upstream s_cmp; skip body if false.
      if (failed(emitMC(sCbranchScc0(), {labelOperand(exitLabel)})))
        return failure();
    }
    if (IntegerAttr alignmentAttr = loop.getFetchAlignmentAttr()) {
      uint64_t alignment = alignmentAttr.getValue().getZExtValue();
      uint64_t phase = 0;
      if (IntegerAttr phaseAttr = loop.getFetchPhaseAttr())
        phase = phaseAttr.getValue().getZExtValue();
      emitAlign(llvm::Log2_64(alignment));
      for ([[maybe_unused]] unsigned unused :
           llvm::seq<unsigned>(static_cast<unsigned>(phase / 4)))
        if (failed(emitMC(sNop(), {llvm::MCOperand::createImm(0)})))
          return failure();
    }
    emitLabel(headLabel);
    Block &body = loop.getBody().front();
    auto term = cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
    for (Operation &child : body) {
      if (&child == term.getOperation())
        continue;
      if (failed(emitOperation(child)))
        return failure();
    }
    // continue_if: the SCC operand has been set by the upstream s_cmp;
    // we branch back to the head if SCC==1, else fall through.
    if (failed(emitMC(sCbranchScc1(), {labelOperand(headLabel)})))
      return failure();
    emitLabel(exitLabel);
    return success();
  }

  LogicalResult emitUniformIfRegion(Region &region) {
    if (region.empty())
      return success();
    Block &body = region.front();
    Operation *term = body.getTerminator();
    for (Operation &child : body) {
      if (&child == term)
        continue;
      if (failed(emitOperation(child)))
        return failure();
    }
    return success();
  }

  LogicalResult emitUniformIf(waveamdmachine::UniformIfOp uniformIf) {
    unsigned id = ifCounter++;
    bool hasElse = !uniformIf.getElseRegion().empty();
    std::string endLabel = (funcLabelPrefix + ".if_end_" + Twine(id)).str();
    std::string elseLabel =
        hasElse ? (funcLabelPrefix + ".if_else_" + Twine(id)).str() : endLabel;
    if (failed(emitMC(sCbranchScc0(), {labelOperand(elseLabel)})))
      return failure();
    if (failed(emitUniformIfRegion(uniformIf.getThenRegion())))
      return failure();
    if (hasElse) {
      if (failed(emitMC(sBranch(), {labelOperand(endLabel)})))
        return failure();
      emitLabel(elseLabel);
      if (failed(emitUniformIfRegion(uniformIf.getElseRegion())))
        return failure();
    }
    emitLabel(endLabel);
    return success();
  }

  llvm::MCOperand getExecSaveOperand(unsigned slot, unsigned width) const {
    return llvm::MCOperand::createReg(mcSGPRReg(execIfSaveBase + slot, width));
  }

  llvm::MCOperand getExecMaskOperand(Value condition) {
    if (isVCCType(condition.getType()))
      return llvm::MCOperand::createReg(
          namedPhysReg(wavefrontSize == 32 ? "vcc_lo" : "vcc"));
    return toMCOperand(condition);
  }

  LogicalResult emitExecSave(Value condition, unsigned width,
                             llvm::MCOperand save) {
    llvm::MCOperand mask = getExecMaskOperand(condition);
    if (width == 2)
      return emitMC(sAndSaveexecB64(), {save, mask});
    if (isGfx8Or9()) {
      llvm::MCOperand execLo =
          llvm::MCOperand::createReg(namedPhysReg("exec_lo"));
      if (failed(emitMC(sMovB32(), {save, execLo})))
        return failure();
      return emitMC(sAndB32(), {execLo, execLo, mask});
    }
    return emitMC(postVIOpcode(llvm::AMDGPU::S_AND_SAVEEXEC_B32), {save, mask});
  }

  LogicalResult emitExecElse(Value condition, unsigned width,
                             llvm::MCOperand save) {
    llvm::MCOperand mask = getExecMaskOperand(condition);
    if (width == 2)
      return emitMC(
          sAndn2B64(),
          {llvm::MCOperand::createReg(namedPhysReg("exec")), save, mask});
    return emitMC(
        sAndn2B32(),
        {llvm::MCOperand::createReg(namedPhysReg("exec_lo")), save, mask});
  }

  LogicalResult emitExecRestore(unsigned width, llvm::MCOperand save) {
    if (width == 2)
      return emitMC(sMovB64(),
                    {llvm::MCOperand::createReg(namedPhysReg("exec")), save});
    return emitMC(sMovB32(),
                  {llvm::MCOperand::createReg(namedPhysReg("exec_lo")), save});
  }

  LogicalResult emitCopy(Value dst, Value src, Operation *op) {
    if (isa<waveamdmachine::MemTokenType>(dst.getType()))
      return success();
    if (src.getDefiningOp<waveamdmachine::UninitOp>())
      return success();
    if (waveamdmachine::isSamePhysicalReg(dst, src))
      return success();

    waveamdmachine::RegType dstType =
        dyn_cast<waveamdmachine::RegType>(dst.getType());
    if (!dstType)
      return op->emitError("copy requires a register result");
    if (dstType.getRegClass() == waveamdmachine::RegClass::VGPR) {
      for (unsigned i : llvm::seq<unsigned>(0, dstType.getWidth()))
        if (failed(emitMC(vMovB32(), {toMCVGPRComponent(dst, i),
                                      toMCB32Component(src, i)})))
          return failure();
      return success();
    }
    if (dstType.getRegClass() == waveamdmachine::RegClass::SGPR) {
      for (unsigned i : llvm::seq<unsigned>(0, dstType.getWidth()))
        if (failed(emitMC(sMovB32(), {toMCSGPRComponent(dst, i),
                                      toMCB32Component(src, i)})))
          return failure();
      return success();
    }
    return op->emitError("copy supports only SGPR/VGPR results");
  }

  LogicalResult emitSplitWaitcnt(waveamdmachine::SWaitcntSplitOp wait) {
    if (!usesSplitWaitCounters())
      return wait.emitError("s_waitcnt_split requires split wait counters");

    std::optional<uint32_t> loadcnt = wait.getLoadcnt();
    std::optional<uint32_t> storecnt = wait.getStorecnt();
    std::optional<uint32_t> dscnt = wait.getDscnt();
    std::optional<uint32_t> kmcnt = wait.getKmcnt();
    std::optional<uint32_t> xcnt = wait.getXcnt();

    auto validate = [&](StringRef name, std::optional<uint32_t> count,
                        unsigned max) -> LogicalResult {
      if (!count || *count <= max)
        return success();
      return wait.emitError() << name << " value " << *count
                              << " exceeds target maximum " << max;
    };
    if (failed(validate("loadcnt", loadcnt,
                        llvm::AMDGPU::getLoadcntBitMask(isaVersion))) ||
        failed(validate("storecnt", storecnt,
                        llvm::AMDGPU::getStorecntBitMask(isaVersion))) ||
        failed(validate("dscnt", dscnt,
                        llvm::AMDGPU::getDscntBitMask(isaVersion))) ||
        failed(validate("kmcnt", kmcnt,
                        llvm::AMDGPU::getKmcntBitMask(isaVersion))) ||
        failed(
            validate("xcnt", xcnt, llvm::AMDGPU::getXcntBitMask(isaVersion))))
      return failure();
    if (xcnt && !hasWaitXcnt())
      return wait.emitError("xcnt unsupported on target");

    if (dscnt && loadcnt) {
      unsigned encoded =
          llvm::AMDGPU::encodeLoadcntDscnt(isaVersion, *loadcnt, *dscnt);
      if (failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_LOADCNT_DSCNT),
                        {llvm::MCOperand::createImm(encoded)})))
        return failure();
      loadcnt.reset();
      dscnt.reset();
    } else if (dscnt && storecnt) {
      unsigned encoded =
          llvm::AMDGPU::encodeStorecntDscnt(isaVersion, *storecnt, *dscnt);
      if (failed(emitMC(postVIOpcode(llvm::AMDGPU::S_WAIT_STORECNT_DSCNT),
                        {llvm::MCOperand::createImm(encoded)})))
        return failure();
      storecnt.reset();
      dscnt.reset();
    }

    auto emit = [&](std::optional<uint32_t> count,
                    unsigned opcode) -> LogicalResult {
      if (!count)
        return success();
      return emitMC(postVIOpcode(opcode), {llvm::MCOperand::createImm(*count)});
    };
    if (failed(emit(loadcnt, llvm::AMDGPU::S_WAIT_LOADCNT)) ||
        failed(emit(storecnt, llvm::AMDGPU::S_WAIT_STORECNT)) ||
        failed(emit(dscnt, llvm::AMDGPU::S_WAIT_DSCNT)) ||
        failed(emit(kmcnt, llvm::AMDGPU::S_WAIT_KMCNT)) ||
        failed(emit(xcnt, llvm::AMDGPU::S_WAIT_XCNT)))
      return failure();
    return success();
  }

  LogicalResult emitYieldCopies(waveamdmachine::ExecIfOp execIf,
                                Region &region) {
    if (region.empty())
      return success();
    waveamdmachine::YieldOp yield =
        cast<waveamdmachine::YieldOp>(region.front().getTerminator());
    for (auto [result, value] :
         llvm::zip_equal(execIf.getResults(), yield.getValues()))
      if (failed(emitCopy(result, value, yield.getOperation())))
        return failure();
    return success();
  }

  LogicalResult emitExecIfRegion(waveamdmachine::ExecIfOp execIf,
                                 Region &region) {
    if (region.empty())
      return success();
    waveamdmachine::YieldOp yield =
        cast<waveamdmachine::YieldOp>(region.front().getTerminator());
    for (Operation &child : region.front()) {
      if (&child == yield.getOperation())
        continue;
      if (failed(emitOperation(child)))
        return failure();
    }
    return emitYieldCopies(execIf, region);
  }

  LogicalResult emitExecIf(waveamdmachine::ExecIfOp execIf) {
    unsigned id = execIfCounter++;
    Value condition = execIf.getCondition();
    unsigned width = wave::getWaveAMDExecIfMaskDwords(execIf);
    unsigned savedCursor = execIfSaveCursor;
    unsigned saveSlot =
        wave::alignWaveAMDExecIfSaveSlot(execIfSaveCursor, width);
    execIfSaveCursor = saveSlot + width;

    std::string endLabel = (funcLabelPrefix + ".exec_endif_" + Twine(id)).str();
    bool hasElse = !execIf.getElseRegion().empty();
    std::string elseLabel =
        hasElse ? (funcLabelPrefix + ".exec_else_" + Twine(id)).str()
                : endLabel;
    llvm::MCOperand save = getExecSaveOperand(saveSlot, width);
    if (failed(emitExecSave(condition, width, save)) ||
        failed(emitMC(sCbranchExecz(), {labelOperand(elseLabel)})) ||
        failed(emitExecIfRegion(execIf, execIf.getThenRegion())))
      return failure();
    if (hasElse) {
      emitLabel(elseLabel);
      if (failed(emitExecElse(condition, width, save)) ||
          failed(emitMC(sCbranchExecz(), {labelOperand(endLabel)})) ||
          failed(emitExecIfRegion(execIf, execIf.getElseRegion())))
        return failure();
    }
    emitLabel(endLabel);
    if (failed(emitExecRestore(width, save)))
      return failure();
    execIfSaveCursor = savedCursor;
    return success();
  }

  LogicalResult emitOperation(Operation &op) {
    llvm::SaveAndRestore<Operation *> saveSource(emissionSource, &op);
    if (failed(verifyVGPRAddressability(op)))
      return failure();
    auto operandString = [&](unsigned i) {
      return operandToString(op.getOperand(i));
    };
    auto result = [&]() { return op.getResult(0); };
    StringRef name = op.getName().getStringRef();

    if (op.hasTrait<OpTrait::waveamdmachine::NoAsmEmission>())
      return success();
    if (isa<waveamdmachine::LabelOp>(op)) {
      emitLabel(op.getAttrOfType<StringAttr>("name"));
      return success();
    }
    if (isa<waveamdmachine::VMbcntLoOp>(op))
      return emitMC(vMbcntLo(),
                    {toMCOperand(result()), llvm::MCOperand::createImm(-1),
                     llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::VMbcntHiOp>(op))
      return emitMC(vMbcntHi(),
                    {toMCOperand(result()), llvm::MCOperand::createImm(-1),
                     toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::SGetregShaderCyclesOp>(op)) {
      uint64_t encoding = llvm::AMDGPU::Hwreg::HwregEncoding::encode(
          llvm::AMDGPU::Hwreg::ID_SHADER_CYCLES, 0, 32);
      return emitMC(sGetregB32(), {toMCOperand(result()),
                                   llvm::MCOperand::createImm(encoding)});
    }
    if (waveamdmachine::SGetregHwIdOp hwId =
            dyn_cast<waveamdmachine::SGetregHwIdOp>(op)) {
      if (isGfx1250())
        return op.emitError(
            "s_getreg_hw_id requires gfx1250 wave-HW-ID lowering");
      unsigned id = isaVersion.Major >= 10 ? llvm::AMDGPU::Hwreg::ID_HW_ID1
                                           : llvm::AMDGPU::Hwreg::ID_HW_ID;
      uint64_t encoding = llvm::AMDGPU::Hwreg::HwregEncoding::encode(
          id, hwId.getOffset(), hwId.getWidth());
      return emitMC(sGetregB32(), {toMCOperand(result()),
                                   llvm::MCOperand::createImm(encoding)});
    }
    if (auto copy = dyn_cast<waveamdmachine::CopyTupleOp>(op))
      return emitCopy(copy.getResult(), copy.getSource(), copy.getOperation());
    if (isa<waveamdmachine::VMovB32TupleOp>(op)) {
      auto regType = cast<waveamdmachine::RegType>(result().getType());
      Value src = op.getOperand(0);
      for (unsigned i = 0, e = regType.getWidth(); i != e; ++i) {
        llvm::MCOperand srcOp = toMCB32Component(src, i);
        if (failed(emitMC(vMovB32(), {toMCVGPRComponent(result(), i), srcOp})))
          return failure();
      }
      return success();
    }
    if (auto swap = dyn_cast<waveamdmachine::VPermlane32SwapB32TupleOp>(op)) {
      if (!waveamdmachine::VPermlane32SwapB32TupleOp::isSupportedOnIsa(
              isaVersion))
        return op.emitError(
            "v_permlane32_swap_b32_tuple unsupported on target");
      Value source = swap.getSource();
      Value destination = swap.getResult();
      if (getPhys(source) != getPhys(destination))
        return op.emitError(
            "v_permlane32_swap_b32_tuple result must reuse its source tuple");
      waveamdmachine::RegType type =
          cast<waveamdmachine::RegType>(destination.getType());
      unsigned halfWidth = type.getWidth() / 2;
      for (unsigned i : llvm::seq<unsigned>(0, halfWidth))
        if (failed(emitMC(vPermlane32SwapB32(),
                          {toMCVGPRComponent(destination, i),
                           toMCVGPRComponent(destination, halfWidth + i),
                           toMCVGPRComponent(source, i),
                           toMCVGPRComponent(source, halfWidth + i)})))
          return failure();
      return success();
    }
    if (isa<waveamdmachine::VMovB64TupleOp>(op)) {
      if (!waveamdmachine::VMovB64TupleOp::isSupportedOnIsa(isaVersion))
        return op.emitError("v_mov_b64_tuple unsupported on target");
      return emitMC(vMovB64(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    }
    if (auto move = dyn_cast<waveamdmachine::VMovB64FromElementsOp>(op)) {
      if (!waveamdmachine::VMovB64FromElementsOp::isSupportedOnIsa(isaVersion))
        return op.emitError("v_mov_b64_from_elements unsupported on target");
      return emitMC(vMovB64(), {toMCOperand(result()),
                                toMCVGPRPairFromLo(move.getSourceLo())});
    }
    if (isa<waveamdmachine::VCndmaskB32TupleOp>(op)) {
      waveamdmachine::RegType regType =
          cast<waveamdmachine::RegType>(result().getType());
      Value falseValue = op.getOperand(0);
      Value trueValue = op.getOperand(1);
      Value condition = op.getOperand(2);
      for (unsigned i : llvm::seq<unsigned>(0, regType.getWidth()))
        if (failed(emitMC(
                vCndmaskB32(),
                {toMCVGPRComponent(result(), i), llvm::MCOperand::createImm(0),
                 toMCB32Component(falseValue, i), llvm::MCOperand::createImm(0),
                 toMCB32Component(trueValue, i), toMCOperand(condition)})))
          return failure();
      return success();
    }
    if (isa<waveamdmachine::VCndmaskB32VccOp>(op)) {
      if (failed(requireOperandLegality(op, "v_cndmask_b32_vcc")))
        return failure();
      waveamdmachine::RegType regType =
          cast<waveamdmachine::RegType>(result().getType());
      Value falseValue = op.getOperand(0);
      Value trueValue = op.getOperand(1);
      for (unsigned i : llvm::seq<unsigned>(0, regType.getWidth()))
        if (failed(emitMC(vCndmaskB32Vcc(), {toMCVGPRComponent(result(), i),
                                             toMCB32Component(falseValue, i),
                                             toMCB32Component(trueValue, i)})))
          return failure();
      return success();
    }
    if (isa<waveamdmachine::SMovB32TupleOp>(op)) {
      auto regType = cast<waveamdmachine::RegType>(result().getType());
      Value src = op.getOperand(0);
      auto srcType = dyn_cast<waveamdmachine::RegType>(src.getType());
      bool srcTuple = srcType &&
                      srcType.getRegClass() == waveamdmachine::RegClass::SGPR &&
                      srcType.getWidth() == regType.getWidth();
      for (unsigned i = 0, e = regType.getWidth(); i != e; ++i) {
        llvm::MCOperand srcOp =
            srcTuple ? toMCSGPRComponent(src, i) : toMCOperand(src);
        if (failed(emitMC(sMovB32(), {toMCSGPRComponent(result(), i), srcOp})))
          return failure();
      }
      return success();
    }
    if (isa<waveamdmachine::VAccvgprReadB32TupleOp>(op)) {
      if (!hasAGPRs())
        return op.emitError("v_accvgpr_read_b32 requires AGPR support");
      auto regType = cast<waveamdmachine::RegType>(result().getType());
      Value src = op.getOperand(0);
      for (unsigned i : llvm::seq<unsigned>(0, regType.getWidth()))
        if (failed(emitMC(vAccvgprReadB32(), {toMCVGPRComponent(result(), i),
                                              toMCAGPRComponent(src, i)})))
          return failure();
      return success();
    }
    if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(op)) {
      if (!hasAGPRs())
        return op.emitError("v_accvgpr_write_b32 requires AGPR support");
      auto regType = cast<waveamdmachine::RegType>(result().getType());
      Value src = op.getOperand(0);
      for (unsigned i : llvm::seq<unsigned>(0, regType.getWidth()))
        if (failed(emitMC(vAccvgprWriteB32(), {toMCAGPRComponent(result(), i),
                                               toMCB32Component(src, i)})))
          return failure();
      return success();
    }
    if (isa<waveamdmachine::WmmaI32_16x16x16_IU8Op>(op))
      return emitMC(
          postVIOpcode(llvm::AMDGPU::V_WMMA_I32_16X16X16_IU8_twoaddr_w32),
          {toMCOperand(result()), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::WmmaF32_16x16x16_F16Op>(op))
      return emitMC(
          postVIOpcode(llvm::AMDGPU::V_WMMA_F32_16X16X16_F16_twoaddr_w32),
          {toMCOperand(result()), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::WmmaF32_16x16x16_BF16Op>(op))
      return emitMC(
          postVIOpcode(llvm::AMDGPU::V_WMMA_F32_16X16X16_BF16_twoaddr_w32),
          {toMCOperand(result()), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::WmmaF32_16x16x32_F16Op>(op))
      return emitGfx1250Wmma(llvm::AMDGPU::V_WMMA_F32_16X16X32_F16_w32_twoaddr,
                             result(), op.getOperand(0), op.getOperand(1),
                             op.getOperand(2));
    if (isa<waveamdmachine::WmmaF32_16x16x32_BF16Op>(op))
      return emitGfx1250Wmma(llvm::AMDGPU::V_WMMA_F32_16X16X32_BF16_w32_twoaddr,
                             result(), op.getOperand(0), op.getOperand(1),
                             op.getOperand(2));
    if (isa<waveamdmachine::MfmaF32_16x16x16_F16Op>(op)) {
      if (!isGfx90APlus())
        return op.emitError("mfma.f32.16x16x16.f16 requires gfx90a+");
      return emitMC(
          mfmaF32_16x16x16F16(isAGPRType(result().getType())),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::MfmaF32_16x16x16_BF16Op>(op)) {
      if (!isGfx940Plus())
        return op.emitError("mfma.f32.16x16x16.bf16 requires gfx940+");
      return emitMC(
          mfmaF32_16x16x16BF16(isAGPRType(result().getType())),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::MfmaF32_16x16x32_F16Op>(op)) {
      if (!isGfx950(isaVersion))
        return op.emitError("mfma.f32.16x16x32.f16 requires gfx950");
      return emitMC(
          mfmaF32_16x16x32F16(isAGPRType(result().getType())),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::MfmaF32_16x16x32_BF16Op>(op)) {
      if (!isGfx950(isaVersion))
        return op.emitError("mfma.f32.16x16x32.bf16 requires gfx950");
      return emitMC(
          mfmaF32_16x16x32BF16(isAGPRType(result().getType())),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::MfmaF32_32x32x16_F16Op>(op)) {
      if (!isGfx950(isaVersion))
        return op.emitError("mfma.f32.32x32x16.f16 requires gfx950");
      return emitMC(
          mfmaF32_32x32x16F16(isAGPRType(result().getType())),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::MfmaF32_32x32x16_BF16Op>(op)) {
      if (!isGfx950(isaVersion))
        return op.emitError("mfma.f32.32x32x16.bf16 requires gfx950");
      return emitMC(
          mfmaF32_32x32x16BF16(isAGPRType(result().getType())),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    auto emitMfmaScale = [&](auto scaleOp, unsigned opcode) -> LogicalResult {
      unsigned scaleIdxA = scaleOp.getScaleIdxA();
      unsigned scaleIdxB = scaleOp.getScaleIdxB();
      return emitMC(
          opcode,
          {toMCOperand(result()), toMCOperand(scaleOp.getA()),
           toMCOperand(scaleOp.getB()), toMCOperand(scaleOp.getAcc()),
           llvm::MCOperand::createImm(4), llvm::MCOperand::createImm(4),
           toMCOperand(scaleOp.getAScale()), toMCOperand(scaleOp.getBScale()),
           llvm::MCOperand::createImm(
               packedSrcMods(scaleIdxA & 1, scaleIdxA >> 1, 0)),
           llvm::MCOperand::createImm(
               packedSrcMods(scaleIdxB & 1, scaleIdxB >> 1, 0))});
    };
    if (auto scaleOp =
            dyn_cast<waveamdmachine::MfmaScaleF32_16x16x128_F4F4Op>(op)) {
      if (!isGfx950(isaVersion))
        return scaleOp.emitError(
            "mfma.scale.f32.16x16x128.f4.f4 requires gfx950");
      return emitMfmaScale(
          scaleOp, mfmaScaleF32_16x16x128F4F4(isAGPRType(result().getType())));
    }
    if (auto scaleOp =
            dyn_cast<waveamdmachine::MfmaScaleF32_32x32x64_F4F4Op>(op)) {
      if (!isGfx950(isaVersion))
        return scaleOp.emitError(
            "mfma.scale.f32.32x32x64.f4.f4 requires gfx950");
      return emitMfmaScale(
          scaleOp, mfmaScaleF32_32x32x64F4F4(isAGPRType(result().getType())));
    }
    if (isa<waveamdmachine::VAddU32Op>(op)) {
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (failed(requireOperandLegality(op, "v_add_u32")))
        return failure();
      waveamdmachine::putVGPROperandLast(lhs, rhs);
      return emitVAddU32(toMCOperand(result()), toMCB32(lhs), toMCB32(rhs), op);
    }
    if (isa<waveamdmachine::VAddU32VccOp>(op)) {
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (failed(requireOperandLegality(op, "v_add_u32_vcc")))
        return failure();
      waveamdmachine::putVGPROperandLast(lhs, rhs);
      return emitVAddU32Vcc(toMCOperand(result()), toMCB32(lhs), toMCB32(rhs));
    }
    if (isa<waveamdmachine::VAndB32Op, waveamdmachine::VOrB32Op,
            waveamdmachine::VXorB32Op>(op)) {
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (failed(requireOperandLegality(op, op.getName().stripDialect())))
        return failure();
      waveamdmachine::putVGPROperandLast(lhs, rhs);
      unsigned opcode = isa<waveamdmachine::VAndB32Op>(op)  ? vAndB32()
                        : isa<waveamdmachine::VOrB32Op>(op) ? vOrB32()
                                                            : vXorB32();
      return emitMC(opcode,
                    {toMCOperand(result()), toMCB32(lhs), toMCB32(rhs)});
    }
    if (isa<waveamdmachine::VLshlrevB32Op>(op)) {
      if (failed(requireOperandLegality(op, "v_lshlrev_b32")))
        return failure();
      return emitMC(vLshlrevB32(),
                    {toMCOperand(result()), toMCB32(op.getOperand(1)),
                     toMCB32(op.getOperand(0))});
    }
    if (isa<waveamdmachine::VLshrrevB32Op>(op)) {
      if (failed(requireOperandLegality(op, "v_lshrrev_b32")))
        return failure();
      return emitMC(vLshrrevB32(),
                    {toMCOperand(result()), toMCB32(op.getOperand(1)),
                     toMCB32(op.getOperand(0))});
    }
    if (isa<waveamdmachine::VAshrrevI32Op>(op)) {
      if (failed(requireOperandLegality(op, "v_ashrrev_i32")))
        return failure();
      return emitMC(vAshrrevI32(),
                    {toMCOperand(result()), toMCB32(op.getOperand(1)),
                     toMCB32(op.getOperand(0))});
    }
    if (isa<waveamdmachine::VMulLoU32Op>(op))
      return emitVMulLoU32(op, result(), op.getOperand(0), op.getOperand(1));
    if (isa<waveamdmachine::VMulHiU32Op>(op))
      return emitVMulHiU32(op, result(), op.getOperand(0), op.getOperand(1));
    if (isa<waveamdmachine::VFfbhU32Op, waveamdmachine::VFfblB32Op>(op)) {
      unsigned opcode =
          isa<waveamdmachine::VFfbhU32Op>(op) ? vFfbhU32() : vFfblB32();
      return emitMC(opcode, {toMCOperand(result()), toMCB32(op.getOperand(0))});
    }
    if (isa<waveamdmachine::VMadI32I24Op, waveamdmachine::VMadU32U24Op>(op)) {
      unsigned opcode =
          isa<waveamdmachine::VMadI32I24Op>(op) ? vMadI32I24() : vMadU32U24();
      return emitTernaryIntClamp(opcode, op);
    }
    if (isa<waveamdmachine::VAdd3U32Op, waveamdmachine::VBfeU32Op,
            waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddLshlU32Op,
            waveamdmachine::VAndOrB32Op, waveamdmachine::VOr3B32Op,
            waveamdmachine::VXadU32Op, waveamdmachine::VPermB32Op>(op)) {
      unsigned opcode = isa<waveamdmachine::VAdd3U32Op>(op)      ? vAdd3U32()
                        : isa<waveamdmachine::VBfeU32Op>(op)     ? vBfeU32()
                        : isa<waveamdmachine::VLshlAddU32Op>(op) ? vLshlAddU32()
                        : isa<waveamdmachine::VAddLshlU32Op>(op) ? vAddLshlU32()
                        : isa<waveamdmachine::VAndOrB32Op>(op)   ? vAndOrB32()
                        : isa<waveamdmachine::VOr3B32Op>(op)     ? vOr3B32()
                        : isa<waveamdmachine::VXadU32Op>(op)     ? vXadU32()
                                                                 : vPermB32();
      return emitTernaryInt(opcode, op);
    }
    if (isa<waveamdmachine::VBitOp3B32Op>(op))
      return emitBitOp3B32(op);
    if (isa<waveamdmachine::VAddF32Op, waveamdmachine::VSubF32Op,
            waveamdmachine::VMulF32Op, waveamdmachine::VMaxF32Op>(op)) {
      unsigned opcode = isa<waveamdmachine::VAddF32Op>(op)   ? vAddF32()
                        : isa<waveamdmachine::VSubF32Op>(op) ? vSubF32()
                        : isa<waveamdmachine::VMulF32Op>(op) ? vMulF32()
                                                             : vMaxF32();
      return emitMC(opcode,
                    {toMCOperand(result()), toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
    }
    if (isa<waveamdmachine::VFmaF32Op, waveamdmachine::VMax3F32Op>(op)) {
      unsigned opcode =
          isa<waveamdmachine::VFmaF32Op>(op) ? vFmaF32() : vMax3F32();
      return emitTernaryF32(opcode, op);
    }
    if (isa<waveamdmachine::VExpF32Op, waveamdmachine::VRcpF32Op,
            waveamdmachine::VRcpIFlagF32Op>(op)) {
      unsigned opcode = isa<waveamdmachine::VExpF32Op>(op)   ? vExpF32()
                        : isa<waveamdmachine::VRcpF32Op>(op) ? vRcpF32()
                                                             : vRcpIFlagF32();
      return emitMC(opcode,
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::VCvtF32U32Op, waveamdmachine::VCvtU32F32Op>(op)) {
      unsigned opcode =
          isa<waveamdmachine::VCvtF32U32Op>(op) ? vCvtF32U32() : vCvtU32F32();
      return emitMC(opcode,
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::VCvtF32F16E32Op>(op))
      return emitMC(vCvtF32F16E32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::VCvtF32F16SdwaOp>(op))
      return emitCvtF32F16Sdwa(op);
    if (isa<waveamdmachine::VCvtF16F32Op, waveamdmachine::VCvtF32F16Op>(op)) {
      bool f16FromF32 = isa<waveamdmachine::VCvtF16F32Op>(op);
      unsigned opcode = f16FromF32 ? vCvtF16F32() : vCvtF32F16();
      if (usesTrue16Cvt()) {
        llvm::MCOperand dst =
            f16FromF32 ? toMCVGPRLo16(result()) : toMCOperand(result());
        llvm::MCOperand src = f16FromF32 ? toMCOperand(op.getOperand(0))
                                         : toMCVGPRLo16(op.getOperand(0));
        return emitMC(opcode, {dst, llvm::MCOperand::createImm(0), src,
                               llvm::MCOperand::createImm(0),
                               llvm::MCOperand::createImm(0),
                               llvm::MCOperand::createImm(0)});
      }
      return emitMC(
          opcode, {toMCOperand(result()), llvm::MCOperand::createImm(0),
                   toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
                   llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::VCvtPkRtzF16F32Op>(op)) {
      if (!supportsCvtPkRtzF16F32())
        return op.emitError("v_cvt_pk_rtz_f16_f32 unsupported on target");
      if (isGfx8Or9())
        return emitPackedCvtVOP3(vCvtPkRtzF16F32(), op);
      return emitMC(vCvtPkRtzF16F32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
    }
    if (isa<waveamdmachine::VCvtPkF16F32Op>(op)) {
      if (!supportsCvtPkF16F32())
        return op.emitError("v_cvt_pk_f16_f32 requires cvt-pk-f16-f32-inst");
      return emitPackedCvtVOP3(vCvtPkF16F32(), op);
    }
    if (isa<waveamdmachine::VCvtPkBF16F32Op>(op)) {
      if (!supportsCvtPkBF16F32())
        return op.emitError("v_cvt_pk_bf16_f32 requires bf16-cvt-insts");
      return emitPackedCvtVOP3(vCvtPkBF16F32(), op);
    }
    if (isa<waveamdmachine::VPkAddF16Op, waveamdmachine::VPkMulF16Op>(op)) {
      if (!supportsPackedF16())
        return op.emitError("v_pk_*_f16 requires gfx9/gfx11");
      unsigned opcode =
          isa<waveamdmachine::VPkAddF16Op>(op) ? vPkAddF16() : vPkMulF16();
      return emitPackedBinary(opcode, op);
    }
    if (isa<waveamdmachine::VPkFmaF16Op>(op)) {
      if (!supportsPackedF16())
        return op.emitError("v_pk_fma_f16 requires gfx9/gfx11");
      return emitPackedTernary(vPkFmaF16(), op);
    }
    if (isa<waveamdmachine::VPkAddF32Op, waveamdmachine::VPkMulF32Op>(op)) {
      if (!supportsPackedF32())
        return op.emitError("v_pk_*_f32 requires gfx8/gfx9/gfx12");
      unsigned opcode =
          isa<waveamdmachine::VPkAddF32Op>(op) ? vPkAddF32() : vPkMulF32();
      return emitPackedBinary(opcode, op);
    }
    if (isa<waveamdmachine::VPkFmaF32Op>(op)) {
      if (!supportsPackedF32())
        return op.emitError("v_pk_fma_f32 requires gfx8/gfx9/gfx12");
      return emitPackedTernary(vPkFmaF32(), op);
    }
    if (isa<waveamdmachine::VCmpxEqU32Op, waveamdmachine::VCmpxNeU32Op,
            waveamdmachine::VCmpxLtU32Op, waveamdmachine::VCmpxLeU32Op,
            waveamdmachine::VCmpxGtU32Op, waveamdmachine::VCmpxGeU32Op,
            waveamdmachine::VCmpxLtI32Op, waveamdmachine::VCmpxLeI32Op,
            waveamdmachine::VCmpxGtI32Op, waveamdmachine::VCmpxGeI32Op>(op)) {
      unsigned opcode = isa<waveamdmachine::VCmpxEqU32Op>(op)   ? vCmpxEqU32()
                        : isa<waveamdmachine::VCmpxNeU32Op>(op) ? vCmpxNeU32()
                        : isa<waveamdmachine::VCmpxLtU32Op>(op) ? vCmpxLtU32()
                        : isa<waveamdmachine::VCmpxLeU32Op>(op) ? vCmpxLeU32()
                        : isa<waveamdmachine::VCmpxGtU32Op>(op) ? vCmpxGtU32()
                        : isa<waveamdmachine::VCmpxGeU32Op>(op) ? vCmpxGeU32()
                        : isa<waveamdmachine::VCmpxLtI32Op>(op) ? vCmpxLtI32()
                        : isa<waveamdmachine::VCmpxLeI32Op>(op) ? vCmpxLeI32()
                        : isa<waveamdmachine::VCmpxGtI32Op>(op) ? vCmpxGtI32()
                                                                : vCmpxGeI32();
      if (failed(requireOperandLegality(op, op.getName().stripDialect())))
        return failure();
      SmallVector<llvm::MCOperand> operands;
      if (llvm::AMDGPU::getNamedOperandIdx(opcode,
                                           llvm::AMDGPU::OpName::sdst) >= 0)
        operands.push_back(llvm::MCOperand::createReg(
            namedPhysReg(wavefrontSize == 32 ? "exec_lo" : "exec")));
      operands.push_back(toMCB32(op.getOperand(0)));
      operands.push_back(toMCB32(op.getOperand(1)));
      return emitMC(opcode, operands);
    }
    if (isa<waveamdmachine::VCmpEqF32Op, waveamdmachine::VCmpEqF32VccOp,
            waveamdmachine::VCmpLtF32Op, waveamdmachine::VCmpLtF32VccOp,
            waveamdmachine::VCmpLeF32Op, waveamdmachine::VCmpLeF32VccOp,
            waveamdmachine::VCmpGtF32Op, waveamdmachine::VCmpGtF32VccOp,
            waveamdmachine::VCmpGeF32Op, waveamdmachine::VCmpGeF32VccOp,
            waveamdmachine::VCmpEqU32Op, waveamdmachine::VCmpEqU32VccOp,
            waveamdmachine::VCmpNeU32Op, waveamdmachine::VCmpNeU32VccOp,
            waveamdmachine::VCmpLtU32Op, waveamdmachine::VCmpLtU32VccOp,
            waveamdmachine::VCmpLeU32Op, waveamdmachine::VCmpLeU32VccOp,
            waveamdmachine::VCmpGtU32Op, waveamdmachine::VCmpGtU32VccOp,
            waveamdmachine::VCmpGeU32Op, waveamdmachine::VCmpGeU32VccOp,
            waveamdmachine::VCmpLtI32Op, waveamdmachine::VCmpLtI32VccOp,
            waveamdmachine::VCmpLeI32Op, waveamdmachine::VCmpLeI32VccOp,
            waveamdmachine::VCmpGtI32Op, waveamdmachine::VCmpGtI32VccOp,
            waveamdmachine::VCmpGeI32Op, waveamdmachine::VCmpGeI32VccOp>(op)) {
      bool floatCmp =
          isa<waveamdmachine::VCmpEqF32Op, waveamdmachine::VCmpEqF32VccOp,
              waveamdmachine::VCmpLtF32Op, waveamdmachine::VCmpLtF32VccOp,
              waveamdmachine::VCmpLeF32Op, waveamdmachine::VCmpLeF32VccOp,
              waveamdmachine::VCmpGtF32Op, waveamdmachine::VCmpGtF32VccOp,
              waveamdmachine::VCmpGeF32Op, waveamdmachine::VCmpGeF32VccOp>(op);
      unsigned opcode =
          isa<waveamdmachine::VCmpEqF32Op, waveamdmachine::VCmpEqF32VccOp>(op)
              ? vCmpEqF32()
          : isa<waveamdmachine::VCmpLtF32Op, waveamdmachine::VCmpLtF32VccOp>(op)
              ? vCmpLtF32()
          : isa<waveamdmachine::VCmpLeF32Op, waveamdmachine::VCmpLeF32VccOp>(op)
              ? vCmpLeF32()
          : isa<waveamdmachine::VCmpGtF32Op, waveamdmachine::VCmpGtF32VccOp>(op)
              ? vCmpGtF32()
          : isa<waveamdmachine::VCmpGeF32Op, waveamdmachine::VCmpGeF32VccOp>(op)
              ? vCmpGeF32()
          : isa<waveamdmachine::VCmpEqU32Op, waveamdmachine::VCmpEqU32VccOp>(op)
              ? vCmpEqU32()
          : isa<waveamdmachine::VCmpNeU32Op, waveamdmachine::VCmpNeU32VccOp>(op)
              ? vCmpNeU32()
          : isa<waveamdmachine::VCmpLtU32Op, waveamdmachine::VCmpLtU32VccOp>(op)
              ? vCmpLtU32()
          : isa<waveamdmachine::VCmpLeU32Op, waveamdmachine::VCmpLeU32VccOp>(op)
              ? vCmpLeU32()
          : isa<waveamdmachine::VCmpGtU32Op, waveamdmachine::VCmpGtU32VccOp>(op)
              ? vCmpGtU32()
          : isa<waveamdmachine::VCmpGeU32Op, waveamdmachine::VCmpGeU32VccOp>(op)
              ? vCmpGeU32()
          : isa<waveamdmachine::VCmpLtI32Op, waveamdmachine::VCmpLtI32VccOp>(op)
              ? vCmpLtI32()
          : isa<waveamdmachine::VCmpLeI32Op, waveamdmachine::VCmpLeI32VccOp>(op)
              ? vCmpLeI32()
          : isa<waveamdmachine::VCmpGtI32Op, waveamdmachine::VCmpGtI32VccOp>(op)
              ? vCmpGtI32()
              : vCmpGeI32();
      bool writesVcc =
          isa<waveamdmachine::VCmpEqF32VccOp, waveamdmachine::VCmpLtF32VccOp,
              waveamdmachine::VCmpLeF32VccOp, waveamdmachine::VCmpGtF32VccOp,
              waveamdmachine::VCmpGeF32VccOp, waveamdmachine::VCmpEqU32VccOp,
              waveamdmachine::VCmpNeU32VccOp, waveamdmachine::VCmpLtU32VccOp,
              waveamdmachine::VCmpLeU32VccOp, waveamdmachine::VCmpGtU32VccOp,
              waveamdmachine::VCmpGeU32VccOp, waveamdmachine::VCmpLtI32VccOp,
              waveamdmachine::VCmpLeI32VccOp, waveamdmachine::VCmpGtI32VccOp,
              waveamdmachine::VCmpGeI32VccOp>(op);
      waveamdmachine::RegType resultType =
          cast<waveamdmachine::RegType>(result().getType());
      if (!writesVcc && resultType.getWidth() * 32 != wavefrontSize)
        return op.emitError()
               << "direct result width " << resultType.getWidth() * 32
               << " does not match wave" << wavefrontSize;
      llvm::MCOperand dst =
          writesVcc ? llvm::MCOperand::createReg(
                          namedPhysReg(wavefrontSize == 32 ? "vcc_lo" : "vcc"))
                    : toMCOperand(result());
      if (failed(requireOperandLegality(op, op.getName().stripDialect())))
        return failure();
      if (floatCmp) {
        llvm::MCOperand zero = llvm::MCOperand::createImm(0);
        if (failed(emitMC(opcode, {dst, zero, toMCB32(op.getOperand(0)), zero,
                                   toMCB32(op.getOperand(1)), zero})))
          return failure();
      } else if (failed(emitMC(opcode, {dst, toMCB32(op.getOperand(0)),
                                        toMCB32(op.getOperand(1))})))
        return failure();
      if (!writesVcc)
        return success();
      if (result().use_empty())
        return success();
      if (resultType.getWidth() == 2)
        return emitMC(sMovB64(),
                      {toMCOperand(result()),
                       llvm::MCOperand::createReg(namedPhysReg("vcc"))});
      return emitMC(sMovB32(),
                    {toMCOperand(result()),
                     llvm::MCOperand::createReg(namedPhysReg("vcc_lo"))});
    }
    if (isa<waveamdmachine::SMovB32Op>(op)) {
      StringRef dst = op.getAttrOfType<StringAttr>("dst").getValue();
      std::string src = operandString(0);
      if (dst != src)
        return emitMC(sMovB32(), {llvm::MCOperand::createReg(namedPhysReg(dst)),
                                  toMCOperand(op.getOperand(0))});
      return success();
    }
    if (isa<waveamdmachine::SMovB32ValueOp>(op)) {
      // Coalescing in the regalloc may have folded source==dest;
      // skip in that case to avoid a `s_mov_b32 sX, sX`.
      Value src = op.getOperand(0);
      if (auto srcRt = dyn_cast<waveamdmachine::RegType>(src.getType())) {
        if (srcRt.getRegClass() == waveamdmachine::RegClass::SGPR &&
            srcRt.getIndex() == getPhys(op.getResult(0)))
          return success();
      }
      return emitMC(sMovB32(),
                    {toMCOperand(op.getResult(0)), toMCOperand(src)});
    }
    if (isa<waveamdmachine::SAddI32Op>(op))
      return emitMC(sAddI32(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (auto add = dyn_cast<waveamdmachine::SAddM0I32Op>(op)) {
      llvm::MCOperand lhs = isa<waveamdmachine::M0Type>(add.getLhs().getType())
                                ? llvm::MCOperand::createReg(namedPhysReg("m0"))
                                : toMCOperand(add.getLhs());
      return emitMC(sAddI32(), {llvm::MCOperand::createReg(namedPhysReg("m0")),
                                lhs, toMCOperand(add.getRhs())});
    }
    if (isa<waveamdmachine::SMulI32Op>(op))
      return emitMC(sMulI32(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SMulHiU32Op>(op))
      return emitMC(sMulHiU32(), {toMCOperand(op.getResult(0)),
                                  toMCOperand(op.getOperand(0)),
                                  toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SLshlB32Op>(op))
      return emitMC(sLshlB32(), {toMCOperand(op.getResult(0)),
                                 toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SLshrB32Op>(op))
      return emitMC(sLshrB32(), {toMCOperand(op.getResult(0)),
                                 toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SAshrI32Op>(op))
      return emitMC(sAshrI32(), {toMCOperand(op.getResult(0)),
                                 toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SFlbitI32B32Op, waveamdmachine::SFf1I32B32Op>(op)) {
      unsigned opcode = isa<waveamdmachine::SFlbitI32B32Op>(op) ? sFlbitI32B32()
                                                                : sFf1I32B32();
      return emitMC(opcode, {toMCOperand(op.getResult(0)),
                             toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::SAndB32Op>(op))
      return emitMC(sAndB32(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SAndB64Op>(op))
      return emitMC(sAndB64(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SOrB32Op>(op))
      return emitMC(sOrB32(), {toMCOperand(op.getResult(0)),
                               toMCOperand(op.getOperand(0)),
                               toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SOrB64Op>(op))
      return emitMC(sOrB64(), {toMCOperand(op.getResult(0)),
                               toMCOperand(op.getOperand(0)),
                               toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SXorB32Op>(op))
      return emitMC(sXorB32(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SXorB64Op>(op))
      return emitMC(sXorB64(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SAddU64Op>(op)) {
      // Carry-chain: `s_add_u32 lo` sets SCC; `s_addc_u32 hi` consumes
      // and re-sets it. Component splits go through the SGPR helper.
      Value res = op.getResult(0);
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (failed(emitMC(sAddU32(),
                        {toMCSGPRComponent(res, 0), toMCSGPRComponent(lhs, 0),
                         toMCSGPRComponent(rhs, 0)})))
        return failure();
      return emitMC(sAddcU32(),
                    {toMCSGPRComponent(res, 1), toMCSGPRComponent(lhs, 1),
                     toMCSGPRComponent(rhs, 1)});
    }
    if (isa<waveamdmachine::SAddU64U32Op>(op)) {
      // Zero-extended offset: high addend is an immediate 0, so the
      // carry-chain widens the 32-bit offset without a second register.
      Value res = op.getResult(0);
      Value base = op.getOperand(0);
      if (failed(emitMC(sAddU32(),
                        {toMCSGPRComponent(res, 0), toMCSGPRComponent(base, 0),
                         toMCOperand(op.getOperand(1))})))
        return failure();
      return emitMC(sAddcU32(),
                    {toMCSGPRComponent(res, 1), toMCSGPRComponent(base, 1),
                     llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::VAddU64Op>(op)) {
      Value res = op.getResult(0);
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      llvm::MCOperand clamp = llvm::MCOperand::createImm(0);
      if (isaVersion.Major == 9) {
        llvm::MCOperand vcc = llvm::MCOperand::createReg(namedPhysReg("vcc"));
        if (failed(emitMC(llvm::AMDGPU::V_ADD_CO_U32_e64_gfx9,
                          {toMCVGPRComponent(res, 0), vcc,
                           toMCVGPRComponent(lhs, 0), toMCVGPRComponent(rhs, 0),
                           clamp})))
          return failure();
        return emitMC(llvm::AMDGPU::V_ADDC_CO_U32_e64_gfx9,
                      {toMCVGPRComponent(res, 1), vcc,
                       toMCVGPRComponent(lhs, 1), toMCVGPRComponent(rhs, 1),
                       vcc, clamp});
      }
      if (!isGfx11() && !isGfx1250())
        return op.emitError("v_add_u64 unsupported on this target");
      llvm::MCOperand vccLo =
          llvm::MCOperand::createReg(namedPhysReg("vcc_lo"));
      if (failed(emitMC(postVIOpcode(llvm::AMDGPU::V_ADD_CO_U32_e64),
                        {toMCVGPRComponent(res, 0), vccLo,
                         toMCVGPRComponent(lhs, 0), toMCVGPRComponent(rhs, 0),
                         clamp})))
        return failure();
      return emitMC(postVIOpcode(llvm::AMDGPU::V_ADDC_U32_e64),
                    {toMCVGPRComponent(res, 1), vccLo,
                     toMCVGPRComponent(lhs, 1), toMCVGPRComponent(rhs, 1),
                     vccLo, clamp});
    }
    if (isa<waveamdmachine::VAddU64U32Op>(op)) {
      Value res = op.getResult(0);
      Value base = op.getOperand(0);
      llvm::MCOperand offset = toMCOperand(op.getOperand(1));
      llvm::MCOperand zero = llvm::MCOperand::createImm(0);
      llvm::MCOperand clamp = llvm::MCOperand::createImm(0);
      if (isaVersion.Major == 9) {
        llvm::MCOperand vcc = llvm::MCOperand::createReg(namedPhysReg("vcc"));
        if (failed(emitMC(llvm::AMDGPU::V_ADD_CO_U32_e64_gfx9,
                          {toMCVGPRComponent(res, 0), vcc,
                           toMCVGPRComponent(base, 0), offset, clamp})))
          return failure();
        return emitMC(llvm::AMDGPU::V_ADDC_CO_U32_e64_gfx9,
                      {toMCVGPRComponent(res, 1), vcc,
                       toMCVGPRComponent(base, 1), zero, vcc, clamp});
      }
      if (!isGfx11() && !isGfx1250())
        return op.emitError("v_add_u64_u32 unsupported on this target");
      llvm::MCOperand vccLo =
          llvm::MCOperand::createReg(namedPhysReg("vcc_lo"));
      if (failed(emitMC(postVIOpcode(llvm::AMDGPU::V_ADD_CO_U32_e64),
                        {toMCVGPRComponent(res, 0), vccLo,
                         toMCVGPRComponent(base, 0), offset, clamp})))
        return failure();
      return emitMC(postVIOpcode(llvm::AMDGPU::V_ADDC_U32_e64),
                    {toMCVGPRComponent(res, 1), vccLo,
                     toMCVGPRComponent(base, 1), zero, vccLo, clamp});
    }
    if (isa<waveamdmachine::SMulU64Op>(op)) {
      // 64-bit mul-low expanded as the canonical four-mul, two-add
      // sequence:
      //   r_lo = a_lo * b_lo
      //   r_hi = mul_hi(a_lo, b_lo)
      //   r_hi += a_lo * b_hi    (scratch holds the cross product)
      //   r_hi += a_hi * b_lo
      // SCC from each s_add_i32 is dead.
      Value res = op.getResult(0);
      Value scratch = op.getResult(1);
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (failed(emitMC(sMulI32(),
                        {toMCSGPRComponent(res, 0), toMCSGPRComponent(lhs, 0),
                         toMCSGPRComponent(rhs, 0)})) ||
          failed(emitMC(sMulHiU32(),
                        {toMCSGPRComponent(res, 1), toMCSGPRComponent(lhs, 0),
                         toMCSGPRComponent(rhs, 0)})) ||
          failed(emitMC(sMulI32(),
                        {toMCOperand(scratch), toMCSGPRComponent(lhs, 0),
                         toMCSGPRComponent(rhs, 1)})) ||
          failed(emitMC(sAddI32(),
                        {toMCSGPRComponent(res, 1), toMCSGPRComponent(res, 1),
                         toMCOperand(scratch)})) ||
          failed(emitMC(sMulI32(),
                        {toMCOperand(scratch), toMCSGPRComponent(lhs, 1),
                         toMCSGPRComponent(rhs, 0)})))
        return failure();
      return emitMC(sAddI32(),
                    {toMCSGPRComponent(res, 1), toMCSGPRComponent(res, 1),
                     toMCOperand(scratch)});
    }
    if (isa<waveamdmachine::VMulU64Op>(op)) {
      // Vector mirror of s_mul_u64. v_add_u32 (no-carry) chains the
      // cross-products into the high half.
      Value res = op.getResult(0);
      Value scratch = op.getResult(1);
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (failed(emitMC(postVIOpcode(llvm::AMDGPU::V_MUL_LO_U32_e64),
                        {toMCVGPRComponent(res, 0), toMCVGPRComponent(lhs, 0),
                         toMCVGPRComponent(rhs, 0)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::V_MUL_HI_U32_e64),
                        {toMCVGPRComponent(res, 1), toMCVGPRComponent(lhs, 0),
                         toMCVGPRComponent(rhs, 0)})) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::V_MUL_LO_U32_e64),
                        {toMCOperand(scratch), toMCVGPRComponent(lhs, 0),
                         toMCVGPRComponent(rhs, 1)})) ||
          failed(emitVAddU32(toMCVGPRComponent(res, 1),
                             toMCVGPRComponent(res, 1), toMCOperand(scratch),
                             op)) ||
          failed(emitMC(postVIOpcode(llvm::AMDGPU::V_MUL_LO_U32_e64),
                        {toMCOperand(scratch), toMCVGPRComponent(lhs, 1),
                         toMCVGPRComponent(rhs, 0)})))
        return failure();
      return emitVAddU32(toMCVGPRComponent(res, 1), toMCVGPRComponent(res, 1),
                         toMCOperand(scratch), op);
    }
    if (isa<waveamdmachine::VXorB64Op>(op)) {
      Value res = op.getResult(0);
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (failed(emitMC(vXorB32(),
                        {toMCVGPRComponent(res, 0), toMCVGPRComponent(lhs, 0),
                         toMCVGPRComponent(rhs, 0)})))
        return failure();
      return emitMC(vXorB32(),
                    {toMCVGPRComponent(res, 1), toMCVGPRComponent(lhs, 1),
                     toMCVGPRComponent(rhs, 1)});
    }
    if (isa<waveamdmachine::SLshlB64Op>(op))
      return emitMC(postVIOpcode(llvm::AMDGPU::S_LSHL_B64),
                    {toMCOperand(op.getResult(0)),
                     toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::VLshlrevB64Op>(op))
      return emitMC(postVIOpcode(llvm::AMDGPU::V_LSHLREV_B64_pseudo_e64),
                    {toMCOperand(op.getResult(0)),
                     toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SLshrB64Op>(op))
      return emitMC(sLshrB64(), {toMCOperand(op.getResult(0)),
                                 toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SAshrI64Op>(op))
      return emitMC(sAshrI64(), {toMCOperand(op.getResult(0)),
                                 toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SFlbitI32B64Op, waveamdmachine::SFf1I32B64Op>(op)) {
      unsigned opcode = isa<waveamdmachine::SFlbitI32B64Op>(op) ? sFlbitI32B64()
                                                                : sFf1I32B64();
      return emitMC(opcode, {toMCOperand(op.getResult(0)),
                             toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::VLshrrevB64Op>(op))
      return emitMC(vLshrrevB64(), {toMCOperand(op.getResult(0)),
                                    toMCOperand(op.getOperand(0)),
                                    toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::VAshrrevI64Op>(op))
      return emitMC(vAshrrevI64(), {toMCOperand(op.getResult(0)),
                                    toMCOperand(op.getOperand(0)),
                                    toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SMovB64ImmOp>(op)) {
      // Lift a 64-bit immediate into an SGPR pair: low half then high.
      int64_t value = op.getAttrOfType<IntegerAttr>("value").getInt();
      Value res = op.getResult(0);
      if (failed(emitMC(sMovB32(),
                        {toMCSGPRComponent(res, 0),
                         llvm::MCOperand::createImm(value & 0xffffffff)})))
        return failure();
      return emitMC(
          sMovB32(),
          {toMCSGPRComponent(res, 1),
           llvm::MCOperand::createImm(
               static_cast<int64_t>(static_cast<uint64_t>(value) >> 32) &
               0xffffffff)});
    }
    if (isa<waveamdmachine::SCmpEqU64Op, waveamdmachine::SCmpLgU64Op>(op)) {
      unsigned opcode =
          isa<waveamdmachine::SCmpEqU64Op>(op) ? sCmpEqU64() : sCmpLgU64();
      auto toScalar64Operand = [&](Value value) {
        if (isVCCType(value.getType()))
          return llvm::MCOperand::createReg(namedPhysReg("vcc"));
        return toMCOperand(value);
      };
      return emitMC(opcode, {toScalar64Operand(op.getOperand(0)),
                             toScalar64Operand(op.getOperand(1))});
    }
    if (isa<waveamdmachine::SCmpEqI32Op, waveamdmachine::SCmpLgI32Op,
            waveamdmachine::SCmpGtI32Op, waveamdmachine::SCmpGeI32Op,
            waveamdmachine::SCmpLtI32Op, waveamdmachine::SCmpLeI32Op,
            waveamdmachine::SCmpEqU32Op, waveamdmachine::SCmpLgU32Op,
            waveamdmachine::SCmpGtU32Op, waveamdmachine::SCmpGeU32Op,
            waveamdmachine::SCmpLtU32Op, waveamdmachine::SCmpLeU32Op>(op)) {
      unsigned opcode = llvm::TypeSwitch<Operation *, unsigned>(&op)
                            .Case<waveamdmachine::SCmpEqI32Op>(
                                [&](auto) { return sCmpEqI32(); })
                            .Case<waveamdmachine::SCmpLgI32Op>(
                                [&](auto) { return sCmpLgI32(); })
                            .Case<waveamdmachine::SCmpGtI32Op>(
                                [&](auto) { return sCmpGtI32(); })
                            .Case<waveamdmachine::SCmpGeI32Op>(
                                [&](auto) { return sCmpGeI32(); })
                            .Case<waveamdmachine::SCmpLtI32Op>(
                                [&](auto) { return sCmpLtI32(); })
                            .Case<waveamdmachine::SCmpLeI32Op>(
                                [&](auto) { return sCmpLeI32(); })
                            .Case<waveamdmachine::SCmpEqU32Op>(
                                [&](auto) { return sCmpEqU32(); })
                            .Case<waveamdmachine::SCmpLgU32Op>(
                                [&](auto) { return sCmpLgU32(); })
                            .Case<waveamdmachine::SCmpGtU32Op>(
                                [&](auto) { return sCmpGtU32(); })
                            .Case<waveamdmachine::SCmpGeU32Op>(
                                [&](auto) { return sCmpGeU32(); })
                            .Case<waveamdmachine::SCmpLtU32Op>(
                                [&](auto) { return sCmpLtU32(); })
                            .Case<waveamdmachine::SCmpLeU32Op>(
                                [&](auto) { return sCmpLeU32(); });
      return emitMC(opcode, {toMCOperand(op.getOperand(0)),
                             toMCOperand(op.getOperand(1))});
    }
    if (isa<waveamdmachine::SCSelectB32Op>(op))
      return emitMC(sCselectB32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(2))});
    if (isa<waveamdmachine::SReadVccB32Op>(op)) {
      if (wavefrontSize != 32)
        return op.emitError("s_read_vcc_b32 supports wave32 only");
      return emitMC(sMovB32(),
                    {toMCOperand(result()),
                     llvm::MCOperand::createReg(namedPhysReg("vcc_lo"))});
    }
    if (isa<waveamdmachine::SMovVccB32Op>(op)) {
      if (failed(emitMC(sMovB32(),
                        {llvm::MCOperand::createReg(namedPhysReg("vcc_lo")),
                         toMCOperand(op.getOperand(0))})))
        return failure();
      if (wavefrontSize == 32)
        return success();
      return emitMC(sMovB32(),
                    {llvm::MCOperand::createReg(namedPhysReg("vcc_hi")),
                     llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::SCBranchScc0Op>(op))
      return emitMC(sCbranchScc0(),
                    {labelOperand(op.getAttrOfType<StringAttr>("label"))});
    if (isa<waveamdmachine::SCBranchScc1Op>(op))
      return emitMC(sCbranchScc1(),
                    {labelOperand(op.getAttrOfType<StringAttr>("label"))});
    if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op))
      return emitExecIf(execIf);
    if (auto uniformIf = dyn_cast<waveamdmachine::UniformIfOp>(op))
      return emitUniformIf(uniformIf);
    if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
      return emitUniformLoop(loop);
    if (isa<waveamdmachine::ContinueIfOp>(op))
      // continue_if is consumed by emitUniformLoop; reaching it
      // here would mean the loop op didn't recurse properly.
      return op.emitError(
          "waveamdmachine.continue_if escaped its parent uniform_loop");
    if (isa<waveamdmachine::SLoadB32Op>(op))
      return emitMC(
          sLoadB32(),
          {toMCOperand(result()),
           llvm::MCOperand::createReg(
               namedPhysReg(op.getAttrOfType<StringAttr>("base").getValue())),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::SLoadB64Op>(op))
      return emitMC(
          sLoadB64(),
          {toMCOperand(result()),
           llvm::MCOperand::createReg(
               namedPhysReg(op.getAttrOfType<StringAttr>("base").getValue())),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::SLoadB128Op>(op))
      return emitMC(
          sLoadB128(),
          {toMCOperand(result()),
           llvm::MCOperand::createReg(
               namedPhysReg(op.getAttrOfType<StringAttr>("base").getValue())),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0)});
    if (auto wait = dyn_cast<waveamdmachine::SWaitcntSplitOp>(op))
      return emitSplitWaitcnt(wait);
    if (auto wait = dyn_cast<waveamdmachine::SWaitcntOp>(op)) {
      if (usesSplitWaitCounters())
        return op.emitError("s_waitcnt requires split-wait lowering");
      unsigned encoded = llvm::AMDGPU::encodeWaitcnt(
          isaVersion, wait.getVmcnt().value_or(~0u),
          wait.getExpcnt().value_or(~0u), wait.getLgkmcnt().value_or(~0u));
      return emitMC(sWaitcnt(), {llvm::MCOperand::createImm(encoded)});
    }
    if (auto wait = dyn_cast<waveamdmachine::SWaitcntVscntOp>(op)) {
      if (usesSplitWaitCounters())
        return op.emitError("s_waitcnt_vscnt requires split-wait lowering");
      if (isGfx8Or9()) {
        unsigned vmcnt = wait.getVscnt();
        unsigned encoded =
            llvm::AMDGPU::encodeWaitcnt(isaVersion, vmcnt, /*expcnt=*/~0u,
                                        /*lgkmcnt=*/~0u);
        return emitMC(sWaitcnt(), {llvm::MCOperand::createImm(encoded)});
      }
      return emitMC(postVIOpcode(llvm::AMDGPU::S_WAITCNT_VSCNT),
                    {llvm::MCOperand::createReg(namedPhysReg("null")),
                     llvm::MCOperand::createImm(wait.getVscnt())});
    }
    if (auto wait = dyn_cast<waveamdmachine::SWaitAluOp>(op)) {
      if (!waveamdmachine::SWaitAluOp::isSupportedOnIsa(isaVersion))
        return op.emitError("s_wait_alu unsupported on target");
      if ((wait.getVaVdst() &&
           *wait.getVaVdst() > llvm::AMDGPU::DepCtr::getVaVdstBitMask()) ||
          (wait.getSaSdst() &&
           *wait.getSaSdst() > llvm::AMDGPU::DepCtr::getSaSdstBitMask()) ||
          (wait.getVaSdst() &&
           *wait.getVaSdst() > llvm::AMDGPU::DepCtr::getVaSdstBitMask()))
        return op.emitError("s_wait_alu dependency count out of range");
      unsigned encoded = waveamdmachine::encodeDepCtrWait(
          wait.getVaVdst(), wait.getSaSdst(), wait.getVaSdst(), *sti);
      return emitMC(sWaitAlu(), {llvm::MCOperand::createImm(encoded)});
    }
    if (isa<waveamdmachine::SNopOp>(op))
      return emitMCValues(sNop(), op.getOperands());
    if (isa<waveamdmachine::VNopOp>(op))
      return emitMC(vNop(), {});
    if (auto delay = dyn_cast<waveamdmachine::DmaIssueDelayOp>(op))
      return emitDmaIssueDelay(delay);
    if (isa<waveamdmachine::SSleepOp>(op))
      return emitMCValues(sSleep(), op.getOperands());
    if (isa<waveamdmachine::SSetprioOp>(op))
      return emitMCValues(sSetprio(), op.getOperands());
    if (auto setreg = dyn_cast<waveamdmachine::SSetregImm32B32Op>(op)) {
      if (!waveamdmachine::SSetregImm32B32Op::isSupportedOnIsa(isaVersion))
        return op.emitError("s_setreg_imm32_b32 unsupported on target");
      uint64_t encoding = llvm::AMDGPU::Hwreg::HwregEncoding::encode(
          setreg.getHwreg(), setreg.getOffset(), setreg.getWidth());
      return emitMC(sSetregImm32B32(),
                    {llvm::MCOperand::createImm(setreg.getImm()),
                     llvm::MCOperand::createImm(encoding)});
    }
    if (auto clause = dyn_cast<waveamdmachine::SClauseOp>(op)) {
      if (!waveamdmachine::SClauseOp::isSupportedOnIsa(isaVersion))
        return op.emitError("s_clause unsupported on target");
      unsigned immediate =
          (clause.getLength() - 1) |
          (clause.getBreaks() << waveamdmachine::kSClauseBreakShift);
      return emitMC(sClause(), {llvm::MCOperand::createImm(immediate)});
    }
    if (auto set = dyn_cast<waveamdmachine::SSetVgprMsbOp>(op)) {
      if (!hasVGPRWindowing())
        return op.emitError("s_set_vgpr_msb unsupported on target");
      auto immediate = set.getSource().getDefiningOp<waveamdmachine::ImmOp>();
      if (!immediate || !llvm::isUInt<16>(immediate.getValue()))
        return op.emitError("s_set_vgpr_msb immediate must fit u16");
      return emitMC(sSetVgprMsb(),
                    {llvm::MCOperand::createImm(immediate.getValue())});
    }
    if (isa<waveamdmachine::SDelayAluOp>(op)) {
      if (isGfx8Or9())
        return success();
      return emitMCValues(sDelayAlu(), op.getOperands());
    }
    if (isa<waveamdmachine::SAndSaveexecB32Op>(op)) {
      if (isGfx8Or9()) {
        if (failed(emitMC(sMovB32(), {toMCOperand(result()),
                                      llvm::MCOperand::createReg(
                                          namedPhysReg("exec_lo"))})))
          return failure();
        return emitMC(sAndB32(),
                      {llvm::MCOperand::createReg(namedPhysReg("exec_lo")),
                       llvm::MCOperand::createReg(namedPhysReg("exec_lo")),
                       toMCOperand(op.getOperand(0))});
      }
      return emitMC(postVIOpcode(llvm::AMDGPU::S_AND_SAVEEXEC_B32),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::SAndSaveexecB64Op>(op))
      return emitMC(sAndSaveexecB64(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::SAndn2ExecB32Op>(op)) {
      return emitMC(sAndn2B32(),
                    {llvm::MCOperand::createReg(namedPhysReg("exec_lo")),
                     toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
    }
    if (isa<waveamdmachine::SAndn2ExecB64Op>(op)) {
      return emitMC(sAndn2B64(),
                    {llvm::MCOperand::createReg(namedPhysReg("exec")),
                     toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
    }
    if (isa<waveamdmachine::SCBranchExeczOp>(op))
      return emitMC(sCbranchExecz(),
                    {labelOperand(op.getAttrOfType<StringAttr>("label"))});
    if (isa<waveamdmachine::SMovExecLoOp>(op)) {
      return emitMC(sMovB32(),
                    {llvm::MCOperand::createReg(namedPhysReg("exec_lo")),
                     toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::SMovExecB64Op>(op)) {
      return emitMC(sMovB64(),
                    {llvm::MCOperand::createReg(namedPhysReg("exec")),
                     toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::SMovM0Op>(op))
      return emitMC(sMovB32(), {llvm::MCOperand::createReg(namedPhysReg("m0")),
                                toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::VReadfirstlaneB32Op>(op))
      return emitMC(vReadfirstlaneB32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::GlobalStoreB8Addr64Op>(op))
      return emitGlobalAddrStore(op, globalStoreB8Addr64());
    if (isa<waveamdmachine::GlobalStoreB16Addr64Op>(op))
      return emitGlobalAddrStore(op, globalStoreB16Addr64());
    if (isa<waveamdmachine::GlobalStoreB32Addr64Op>(op))
      return emitGlobalAddrStore(op, globalStoreB32Addr64());
    if (isa<waveamdmachine::GlobalStoreB64Addr64Op>(op))
      return emitGlobalAddrStore(op, globalStoreB64Addr64());
    if (isa<waveamdmachine::GlobalStoreB96Addr64Op>(op))
      return emitGlobalAddrStore(op, globalStoreB96Addr64());
    if (isa<waveamdmachine::GlobalStoreB128Addr64Op>(op))
      return emitGlobalAddrStore(op, globalStoreB128Addr64());
    if (isa<waveamdmachine::GlobalStoreB8Op>(op))
      return emitGlobalStore(op, globalStoreB8());
    if (isa<waveamdmachine::GlobalStoreB16Op>(op))
      return emitGlobalStore(op, globalStoreB16());
    if (isa<waveamdmachine::GlobalStoreB32Op>(op))
      return emitGlobalStore(op, globalStoreB32());
    if (isa<waveamdmachine::GlobalStoreB64Op>(op))
      return emitGlobalStore(op, globalStoreB64());
    if (isa<waveamdmachine::GlobalStoreB96Op>(op))
      return emitGlobalStore(op, globalStoreB96());
    if (isa<waveamdmachine::GlobalStoreB128Op>(op))
      return emitGlobalStore(op, globalStoreB128());
    // GLOBAL_LOAD_DWORD_SADDR encodes its MC operands as
    //   vdst, saddr, vaddr, offset, cpol
    // -- the SADDR variants put the SGPR base first, unlike the *non*-SADDR
    // store variants we use elsewhere.
    if (isa<waveamdmachine::GlobalLoadU8Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadU8Addr64());
    if (isa<waveamdmachine::GlobalLoadI8Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadI8Addr64());
    if (isa<waveamdmachine::GlobalLoadB16Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadB16Addr64());
    if (isa<waveamdmachine::GlobalLoadB32Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadB32Addr64());
    if (isa<waveamdmachine::GlobalLoadB64Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadB64Addr64());
    if (isa<waveamdmachine::GlobalLoadB96Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadB96Addr64());
    if (isa<waveamdmachine::GlobalLoadB128Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadB128Addr64());
    if (isa<waveamdmachine::GlobalLoadU8Op>(op))
      return emitGlobalLoad(op, globalLoadU8());
    if (isa<waveamdmachine::GlobalLoadI8Op>(op))
      return emitGlobalLoad(op, globalLoadI8());
    if (isa<waveamdmachine::GlobalLoadB16Op>(op))
      return emitGlobalLoad(op, globalLoadB16());
    if (isa<waveamdmachine::GlobalLoadB32Op>(op))
      return emitGlobalLoad(op, globalLoadB32());
    if (isa<waveamdmachine::GlobalAtomicAddAcqRelU32Op>(op))
      return emitGlobalAtomicAddAcqRel(op);
    if (isa<waveamdmachine::GlobalLoadB64Op>(op))
      return emitGlobalLoad(op, globalLoadB64());
    if (isa<waveamdmachine::GlobalLoadB96Op>(op))
      return emitGlobalLoad(op, globalLoadB96());
    if (isa<waveamdmachine::GlobalLoadB128Op>(op))
      return emitGlobalLoad(op, globalLoadB128());
    if (isa<waveamdmachine::GlobalLoadTupleB32Op,
            waveamdmachine::BufferLoadTupleB32Op,
            waveamdmachine::DsLoadTupleB32Op,
            waveamdmachine::GlobalStoreTupleB32Op,
            waveamdmachine::BufferStoreTupleB32Op,
            waveamdmachine::DsStoreTupleB32Op>(op))
      return op.emitError(
          "tuple-mem op reached asm emit; waveamd-decompose-mem-tuples "
          "must run before wave-to-amdgpu-asm");
    // MUBUF OFFEN variants (BUFFER_{LOAD,STORE}_DWORD_OFFEN) take the
    // operands in the order vdata/vdst, vaddr, srsrc, soffset, offset,
    // cpol. The SGPR descriptor (`srsrc`) is an SGPR4 tuple, the per-lane
    // VGPR offset is fed through `vaddr` with the `offen` flag, and `soffset`
    // is a hard-zero immediate; `cpol` is the unset cache-policy.
    // MUBUF OFFEN operand layout (MC):
    //   STORE: vdata, vaddr, srsrc, soffset, offset, cpol
    //   LOAD : vdst, vaddr, srsrc, soffset, offset, cpol
    // Our IR layout (waveamdmachine):
    //   STORE: offset(VGPR1), value(VGPR1), descriptor(SGPR4),
    //          soffset(SGPR1OrImm), [dep], inst_offset attr
    //   LOAD : offset(VGPR1), descriptor(SGPR4),
    //          soffset(SGPR1OrImm), [dep], inst_offset attr
    if (isa<waveamdmachine::BufferStoreB8Op>(op))
      return emitBufferStore(op, bufferStoreB8());
    if (isa<waveamdmachine::BufferStoreB16Op>(op))
      return emitBufferStore(op, bufferStoreB16());
    if (isa<waveamdmachine::BufferStoreB32Op>(op))
      return emitBufferStore(op, bufferStoreB32());
    if (isa<waveamdmachine::BufferStoreB64Op>(op))
      return emitBufferStore(op, bufferStoreB64());
    if (isa<waveamdmachine::BufferStoreB96Op>(op))
      return emitBufferStore(op, bufferStoreB96());
    if (isa<waveamdmachine::BufferStoreB128Op>(op))
      return emitBufferStore(op, bufferStoreB128());
    if (isa<waveamdmachine::BufferLoadU8D16Op>(op))
      return emitBufferLoad(op, bufferLoadU8D16(), /*tiedDestination=*/true);
    if (isa<waveamdmachine::BufferLoadU8D16HiOp>(op))
      return emitBufferLoadD16Hi(op, bufferLoadU8D16Hi());
    if (isa<waveamdmachine::BufferLoadU8Op>(op))
      return emitBufferLoad(op, bufferLoadU8());
    if (isa<waveamdmachine::BufferLoadI8Op>(op))
      return emitBufferLoad(op, bufferLoadI8());
    if (isa<waveamdmachine::BufferLoadB16Op>(op))
      return emitBufferLoad(op, bufferLoadB16());
    if (isa<waveamdmachine::BufferLoadB32Op>(op))
      return emitBufferLoad(op, bufferLoadB32());
    if (isa<waveamdmachine::BufferLoadB64Op>(op))
      return emitBufferLoad(op, bufferLoadB64());
    if (isa<waveamdmachine::BufferLoadB96Op>(op))
      return emitBufferLoad(op, bufferLoadB96());
    if (isa<waveamdmachine::BufferLoadB128Op>(op))
      return emitBufferLoad(op, bufferLoadB128());
    if (isa<waveamdmachine::ScratchLoadB32Op>(op))
      return emitScratchLoad(op);
    if (isa<waveamdmachine::ScratchStoreB32Op>(op))
      return emitScratchStore(op);
    if (rejectLegacyVMemToLDS() && isa<waveamdmachine::GlobalLoadLdsB32Op,
                                       waveamdmachine::GlobalLoadLdsB128Op,
                                       waveamdmachine::BufferLoadLdsB32Op,
                                       waveamdmachine::BufferLoadLdsB128Op>(op))
      return op.emitError("no legacy VMEM-to-LDS MC mapping for target ")
             << targetChip << ": " << op.getName();
    if (isa<waveamdmachine::GlobalLoadLdsB32Op>(op)) {
      if (failed(rejectCacheAttr(op, "global LDS load")))
        return failure();
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitLegacyLdsDma(globalLoadLdsB32(),
                              {toMCOperand(op.getOperand(1)),
                               toMCOperand(op.getOperand(0)),
                               llvm::MCOperand::createImm(instOffset),
                               llvm::MCOperand::createImm(aux)});
    }
    if (isa<waveamdmachine::GlobalLoadLdsB128Op>(op)) {
      if (failed(rejectCacheAttr(op, "global LDS load")))
        return failure();
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitLegacyLdsDma(globalLoadLdsB128(),
                              {toMCOperand(op.getOperand(1)),
                               toMCOperand(op.getOperand(0)),
                               llvm::MCOperand::createImm(instOffset),
                               llvm::MCOperand::createImm(aux)});
    }
    if (isa<waveamdmachine::BufferLoadLdsB32Op>(op)) {
      return emitBufferLoadLds(op, bufferLoadLdsB32());
    }
    if (isa<waveamdmachine::BufferLoadLdsB128Op>(op)) {
      return emitBufferLoadLds(op, bufferLoadLdsB128());
    }
    if (isa<waveamdmachine::DsLoadU8Op>(op))
      return emitDsLoad(op, dsReadU8());
    if (isa<waveamdmachine::DsLoadI8Op>(op))
      return emitDsLoad(op, dsReadI8());
    if (isa<waveamdmachine::DsLoadB16Op>(op))
      return emitDsLoad(op, dsReadB16());
    if (isa<waveamdmachine::DsLoadAddTidB32Op>(op)) {
      if (isaVersion.Major < 9)
        return op.emitError("ds_load_addtid_b32 requires gfx9+");
      return emitDsAddTidLoad(op, dsReadAddTidB32());
    }
    if (isa<waveamdmachine::DsLoadB32Op>(op))
      return emitDsLoad(op, dsReadB32());
    if (isa<waveamdmachine::DsLoad2B32Op>(op)) {
      unsigned opcode =
          getBoolAttr(&op, "st64", false) ? dsRead2St64B32() : dsRead2B32();
      return emitDsLoad2(op, opcode);
    }
    if (isa<waveamdmachine::DsLoadB64Op>(op))
      return emitDsLoad(op, dsReadB64());
    if (isa<waveamdmachine::DsLoad2B64Op>(op)) {
      unsigned opcode =
          getBoolAttr(&op, "st64", false) ? dsRead2St64B64() : dsRead2B64();
      return emitDsLoad2(op, opcode);
    }
    if (isa<waveamdmachine::DsReadTrB64B4Op>(op)) {
      if (!waveamdmachine::DsReadTrB64B4Op::isSupportedOnIsa(isaVersion))
        return op.emitError("ds_read_tr_b64_b4 requires gfx950");
      return emitDsLoad(op, dsReadB64TrB4());
    }
    if (isa<waveamdmachine::DsReadTrB64B8Op>(op)) {
      if (!waveamdmachine::DsReadTrB64B8Op::isSupportedOnIsa(isaVersion))
        return op.emitError("ds_read_tr_b64_b8 requires gfx950");
      return emitDsLoad(op, dsReadB64TrB8());
    }
    if (isa<waveamdmachine::DsReadTrB96B6Op>(op)) {
      if (!waveamdmachine::DsReadTrB96B6Op::isSupportedOnIsa(isaVersion))
        return op.emitError("ds_read_tr_b96_b6 requires gfx950");
      return emitDsLoad(op, dsReadB96TrB6());
    }
    if (isa<waveamdmachine::DsReadTrB64B16Op>(op)) {
      if (!waveamdmachine::DsReadTrB64B16Op::isSupportedOnIsa(isaVersion))
        return op.emitError("ds_read_tr_b64_b16 requires gfx950");
      return emitDsLoad(op, dsReadB64TrB16());
    }
    if (isa<waveamdmachine::DsLoadB96Op>(op))
      return emitDsLoad(op, dsReadB96());
    if (isa<waveamdmachine::DsLoadB128Op>(op))
      return emitDsLoad(op, dsReadB128());
    if (isa<waveamdmachine::DsSwizzleB32Op>(op))
      return emitDsLoad(op, dsSwizzleB32());
    if (isa<waveamdmachine::DsPermuteB32Op>(op))
      return emitDsPermute(op, dsPermuteB32());
    if (isa<waveamdmachine::DsBpermuteB32Op>(op))
      return emitDsPermute(op, dsBpermuteB32());
    if (isa<waveamdmachine::DsStoreB16Op>(op))
      return emitDsStore(op, dsWriteB16());
    if (isa<waveamdmachine::DsStoreB8Op>(op))
      return emitDsStore(op, dsWriteB8());
    if (isa<waveamdmachine::DsAddU32Op>(op))
      return emitDsAdd(op, dsAddU32());
    if (isa<waveamdmachine::DsAddRtnU32Op>(op))
      return emitDsAddRtn(op, dsAddRtnU32());
    if (isa<waveamdmachine::DsStoreAddTidB32Op>(op)) {
      if (isaVersion.Major < 9)
        return op.emitError("ds_store_addtid_b32 requires gfx9+");
      return emitDsAddTidStore(op, dsWriteAddTidB32());
    }
    if (isa<waveamdmachine::DsStoreB32Op>(op))
      return emitDsStore(op, dsWriteB32());
    if (isa<waveamdmachine::DsStore2B32Op>(op)) {
      unsigned opcode =
          getBoolAttr(&op, "st64", false) ? dsWrite2St64B32() : dsWrite2B32();
      return emitDsStore2(op, opcode);
    }
    if (isa<waveamdmachine::DsStoreB64Op>(op))
      return emitDsStore(op, dsWriteB64());
    if (isa<waveamdmachine::DsStore2B64Op>(op)) {
      unsigned opcode =
          getBoolAttr(&op, "st64", false) ? dsWrite2St64B64() : dsWrite2B64();
      return emitDsStore2(op, opcode);
    }
    if (isa<waveamdmachine::DsStoreB96Op>(op))
      return emitDsStore(op, dsWriteB96());
    if (isa<waveamdmachine::DsStoreB128Op>(op))
      return emitDsStore(op, dsWriteB128());
    if (isa<waveamdmachine::SBarrierOp>(op) && isGfx1250()) {
      if (failed(emitMC(postVIOpcode(llvm::AMDGPU::S_BARRIER_SIGNAL_IMM),
                        {llvm::MCOperand::createImm(-1)})))
        return failure();
      return emitMC(postVIOpcode(llvm::AMDGPU::S_BARRIER_WAIT),
                    {llvm::MCOperand::createImm(-1)});
    }
    if (isa<waveamdmachine::SBarrierOp>(op))
      return emitMC(sBarrier(), {});
    if (isa<waveamdmachine::SSendmsgDeallocVgprsOp>(op)) {
      if (!waveamdmachine::SSendmsgDeallocVgprsOp::isSupportedOnIsa(isaVersion))
        return op.emitError("s_sendmsg_dealloc_vgprs unsupported on target");
      return emitMC(sSendmsg(),
                    {llvm::MCOperand::createImm(
                        llvm::AMDGPU::SendMsg::ID_DEALLOC_VGPRS_GFX11Plus)});
    }
    if (isa<waveamdmachine::SEndpgmOp>(op))
      return emitMC(sEndpgm(), {llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::SSetpcB64Op>(op)) {
      return emitMC(sSetpcB64(),
                    {llvm::MCOperand::createReg(namedPhysReg("s[30:31]"))});
    }

    return op.emitError("unsupported WaveAMDMachine opcode: ") << name;
  }
};

#ifndef WAVE_DEFAULT_PIPELINE_REL
#error "WAVE_DEFAULT_PIPELINE_REL must be defined by the build system"
#endif

// Anchor symbol whose containing image getMainExecutable can hash back
// to on platforms that need a fallback when `/proc/self/exe` is
// unavailable.
static void wavePipelineAnchor() {}

// Resolve the wave compilation pipeline library path.
// `WAVE_PIPELINES_DIR` in the environment wins; otherwise compose the
// build-time relative path against the running executable's directory
// so a moved `bin/` + `share/` pair stays consistent.
static std::string findDefaultPipelineFile() {
  if (const char *env = std::getenv("WAVE_PIPELINES_DIR")) {
    SmallString<256> p(env);
    llvm::sys::path::append(p, "pipelines.mlir");
    return std::string(p);
  }
  std::string exe = llvm::sys::fs::getMainExecutable(
      /*Argv0=*/nullptr, reinterpret_cast<void *>(&wavePipelineAnchor));
  if (exe.empty())
    return {};
  SmallString<256> p(llvm::sys::path::parent_path(exe));
  llvm::sys::path::append(p, WAVE_DEFAULT_PIPELINE_REL);
  return std::string(p);
}

static LogicalResult runWaveAMDMachinePipeline(ModuleOp module,
                                               StringRef pipelineFile) {
  MLIRContext *ctx = module.getContext();
  Builder builder(ctx);
  if (!module->hasAttr("waveamdmachine.target"))
    module->setAttr(
        "waveamdmachine.target",
        builder.getStringAttr(
            (Twine(kDefaultTargetTriple) + "--" + kDefaultTargetChip).str()));
  auto targetAttr = module->getAttrOfType<StringAttr>("waveamdmachine.target");
  FailureOr<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::parseAMDGPUTargetAttr(
          targetAttr.getValue(), [&]() { return module.emitError(); });
  if (failed(target))
    return failure();
  if (failed(checkSupportedBackendTarget(module, target->triple, target->chip)))
    return failure();

  // The transform interpreter resolves `transform.apply_registered_pass`
  // names through the global pass registry; ensure wave-owned passes are
  // discoverable even when this code path runs outside `wave-opt`
  // (e.g. via `wave-translate`).
  wave::registerWavePasses();
  // Backend transform runs canonicalize + cse around selection too.
  registerCanonicalizerPass();
  registerCSEPass();
  registerLoopInvariantCodeMotionPass();
  ctx->getOrLoadDialect<transform::TransformDialect>();
  ctx->getOrLoadDialect<wave::WaveDialect>();

  std::string resolved;
  StringRef path = pipelineFile;
  if (path.empty()) {
    resolved = findDefaultPipelineFile();
    if (resolved.empty())
      return module.emitError(
          "cannot locate default Wave compilation pipeline; set "
          "WAVE_PIPELINES_DIR or pass `pipeline-file`");
    path = resolved;
  }
  OwningOpRef<ModuleOp> transformModule;
  if (failed(transform::detail::parseTransformModuleFromFile(ctx, path,
                                                             transformModule)))
    return module.emitError("failed to parse Wave compilation pipeline `")
           << path << "`";

  StringRef entryPoint =
      transform::TransformDialect::kTransformEntryPointSymbolName;
  // Explicit callers may select another sequence from the same library.
  if (const char *env = std::getenv("WAVE_PIPELINE_ENTRY_POINT"))
    entryPoint = env;
  Operation *entry = transform::detail::findTransformEntryPoint(
      module, *transformModule, entryPoint);
  if (!entry)
    return module.emitError("Wave compilation pipeline `")
           << path << "` missing entry point `" << entryPoint << "`";

  return transform::applyTransformNamedSequence(module, entry, *transformModule,
                                                transform::TransformOptions());
}

} // namespace

LogicalResult mlir::wave::translateWaveToAMDGPU(Operation *op, raw_ostream &os,
                                                StringRef pipelineFile) {
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    return op->emitError("wave AMDGPU backend expects a module operation");
  if (failed(runWaveAMDMachinePipeline(module, pipelineFile)))
    return failure();
  return WaveAMDGPUEmitter(os).emit(module);
}

// In-process lld driver wrapping the ELF input bytes in a temp file (the
// system linker insists on file paths) and returning the produced HSACO as
// a memory buffer. Temp files are removed on scope exit so they never leak
// to user-visible paths.
static LogicalResult linkElfToHsacoInProcess(Operation *opForDiag,
                                             ArrayRef<char> objBytes,
                                             SmallVectorImpl<char> &out) {
  SmallString<128> objPath;
  int objFd = -1;
  if (llvm::sys::fs::createTemporaryFile("wave_obj", "o", objFd, objPath))
    return opForDiag->emitError("failed to create temporary ELF object file");
  llvm::FileRemover removeObj(objPath);
  {
    llvm::raw_fd_ostream os(objFd, /*shouldClose=*/true);
    os.write(objBytes.data(), objBytes.size());
  }

  SmallString<128> hsacoPath;
  if (llvm::sys::fs::createTemporaryFile("wave_kernels", "hsaco", hsacoPath))
    return opForDiag->emitError("failed to create temporary HSACO file");
  llvm::FileRemover removeHsaco(hsacoPath);

  std::string stderrStr;
  llvm::raw_string_ostream stderrOS(stderrStr);
  std::string objStr(objPath.str());
  std::string hsacoStr(hsacoPath.str());
  std::array<const char *, 5> args = {"ld.lld", "-shared", objStr.c_str(), "-o",
                                      hsacoStr.c_str()};
  bool ok = lld::elf::link(args, llvm::nulls(), stderrOS,
                           /*exitEarly=*/false,
                           /*disableOutput=*/false);
  if (!ok)
    return opForDiag->emitError("lld failed: ") << stderrStr;

  auto buf = llvm::MemoryBuffer::getFile(hsacoPath, /*IsText=*/false);
  if (std::error_code ec = buf.getError())
    return opForDiag->emitError("failed to read HSACO blob: ") << ec.message();
  StringRef bytes = (*buf)->getBuffer();
  out.assign(bytes.begin(), bytes.end());
  return success();
}

LogicalResult
mlir::wave::assembleWaveAMDGPUKernels(Operation *op, StringRef triple,
                                      StringRef chip, StringRef features,
                                      SmallVectorImpl<char> &out) {
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    return op->emitError(
        "assembleWaveAMDGPUKernels expects a module operation");

  SmallString<8192> isaStorage;
  llvm::raw_svector_ostream isaOS(isaStorage);
  if (failed(WaveAMDGPUEmitter(isaOS).emit(module)))
    return failure();

  auto errCallback = [&] { return op->emitError(); };
  FailureOr<SmallVector<char, 0>> elf =
      ROCDL::assembleIsa(StringRef(isaStorage.data(), isaStorage.size()),
                         triple, chip, features, errCallback);
  if (failed(elf))
    return failure();

  return linkElfToHsacoInProcess(op, *elf, out);
}
