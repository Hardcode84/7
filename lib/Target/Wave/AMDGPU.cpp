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
#include "Utils/AMDGPUBaseInfo.h"
#include "lld/Common/Driver.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Dialect/Transform/Transforms/TransformInterpreterUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveAMDABI.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/OwningOpRef.h"
#include "mlir/Target/LLVM/ROCDL/Utils.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Config/Targets.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/FileUtilities.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"
#include <algorithm>

LLD_HAS_DRIVER(elf)

using namespace mlir;

namespace {

static constexpr llvm::StringLiteral kDefaultTargetTriple = "amdgcn-amd-amdhsa";
static constexpr llvm::StringLiteral kDefaultTargetChip = "gfx1100";

static bool isSupportedBackendIsa(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 8 || isa.Major == 9 || isa.Major == 11;
}

static bool isGfx950(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 5 && isa.Stepping == 0;
}

static LogicalResult
checkSupportedBackendTarget(ModuleOp module, StringRef triple, StringRef chip,
                            const llvm::AMDGPU::IsaVersion &isa) {
  if (isa.Major == 0)
    return module.emitError("unsupported AMDGPU target: ")
           << triple << "--" << chip;
  if (!isSupportedBackendIsa(isa))
    return module.emitError("wave AMDGPU backend does not support target: ")
           << triple << "--" << chip
           << " (supported gfx generations: gfx8, gfx9, gfx11)";
  return success();
}

static LogicalResult
checkSupportedBackendTarget(ModuleOp module, StringRef triple, StringRef chip) {
  return checkSupportedBackendTarget(module, triple, chip,
                                     llvm::AMDGPU::getIsaVersion(chip));
}

static bool isWM(Operation *op) {
  return op->getName().getDialectNamespace() ==
         waveamdmachine::WaveAMDMachineDialect::getDialectNamespace();
}

struct KernelArgInfo {
  std::string name;
  unsigned offset = 0;
  unsigned size = 0;
  bool isGlobalBuffer = false;
};

struct KernelInfo {
  std::string name;
  unsigned kernargSize = 0;
  unsigned sgprCount = 0;
  unsigned vgprCount = 0;
  unsigned ldsSize = 0;
  SmallVector<KernelArgInfo> args;
};

class WaveAMDGPUEmitter {
public:
  explicit WaveAMDGPUEmitter(raw_ostream &os) : os(os) {}

  LogicalResult emit(Operation *op) {
    auto module = dyn_cast<ModuleOp>(op);
    if (!module)
      return op->emitError("wave AMDGPU backend expects a module operation");
    if (failed(initializeMC(op)))
      return failure();
    if (failed(wave::verifyWaveAMDRegAllocations(
            module, "wave-to-amdgpu-asm",
            wave::WaveAMDRegAllocVerificationScope::AllValues)))
      return failure();

    os << "\t.text\n";
    os << "\t.amdgcn_target \"" << targetTriple << "--" << targetChip << "\"\n";
    os << "\t.amdhsa_code_object_version 6\n";
    for (func::FuncOp func : module.getOps<func::FuncOp>()) {
      if (failed(emitFunction(func)))
        return failure();
    }
    emitMetadata();
    return success();
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
  llvm::AMDGPU::IsaVersion isaVersion;
  std::string targetTriple = kDefaultTargetTriple.str();
  std::string targetChip = kDefaultTargetChip.str();
  unsigned wavefrontSize = 32;
  unsigned indent = 1;
  // Per-function counter handing out unique label suffixes for
  // structured uniform loops, reset at the start of each function.
  unsigned loopCounter = 0;
  std::string funcLabelPrefix;

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
      targetTriple = target->triple.str();
      targetChip = target->chip.str();
    }

    llvm::Triple triple(targetTriple);
    std::string error;
    const llvm::Target *target =
        llvm::TargetRegistry::lookupTarget(triple, error);
    if (!target)
      return op->emitError("failed to lookup AMDGPU target: ") << error;
    llvm::MCTargetOptions mcOptions;
    mri.reset(target->createMCRegInfo(triple));
    mai.reset(target->createMCAsmInfo(*mri, triple, mcOptions));
    mcii.reset(target->createMCInstrInfo());
    sti.reset(target->createMCSubtargetInfo(triple, targetChip, ""));
    if (!sti)
      return module.emitError("unsupported AMDGPU target: ")
             << targetTriple << "--" << targetChip;
    isaVersion = llvm::AMDGPU::getIsaVersion(targetChip);
    if (failed(checkSupportedBackendTarget(module, targetTriple, targetChip,
                                           isaVersion)))
      return failure();
    std::optional<unsigned> defaultWavefrontSize =
        waveamdmachine::getAMDGPUDefaultWavefrontSize(targetChip);
    if (!defaultWavefrontSize)
      return module.emitError("unsupported AMDGPU target: ")
             << targetTriple << "--" << targetChip;
    wavefrontSize = *defaultWavefrontSize;
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
  bool isGfx90APlus() const { return llvm::AMDGPU::isGFX90A(*sti); }

  unsigned sMovB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_MOV_B32_vi
                       : llvm::AMDGPU::S_MOV_B32_gfx11;
  }
  unsigned sAddI32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_ADD_I32_vi
                       : llvm::AMDGPU::S_ADD_I32_gfx11;
  }
  unsigned sMulI32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_MUL_I32_vi
                       : llvm::AMDGPU::S_MUL_I32_gfx11;
  }
  unsigned sLshlB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_LSHL_B32_vi
                       : llvm::AMDGPU::S_LSHL_B32_gfx11;
  }
  unsigned sLshrB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_LSHR_B32_vi
                       : llvm::AMDGPU::S_LSHR_B32_gfx11;
  }
  unsigned sAndB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_AND_B32_vi
                       : llvm::AMDGPU::S_AND_B32_gfx11;
  }
  unsigned sAndn2B32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_ANDN2_B32_vi
                       : llvm::AMDGPU::S_ANDN2_B32_gfx11;
  }
  unsigned sAddU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_ADD_U32_vi
                       : llvm::AMDGPU::S_ADD_U32_gfx11;
  }
  unsigned sAddcU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_ADDC_U32_vi
                       : llvm::AMDGPU::S_ADDC_U32_gfx11;
  }
  unsigned sMulHiU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_MUL_HI_U32_vi
                       : llvm::AMDGPU::S_MUL_HI_U32_gfx11;
  }
  unsigned sCmpLtI32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_CMP_LT_I32_vi
                       : llvm::AMDGPU::S_CMP_LT_I32_gfx11;
  }
  unsigned sCmpLgU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_CMP_LG_U32_vi
                       : llvm::AMDGPU::S_CMP_LG_U32_gfx11;
  }
  unsigned sCbranchScc0() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_CBRANCH_SCC0_vi
                       : llvm::AMDGPU::S_CBRANCH_SCC0_gfx11;
  }
  unsigned sCbranchScc1() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_CBRANCH_SCC1_vi
                       : llvm::AMDGPU::S_CBRANCH_SCC1_gfx11;
  }
  unsigned sCbranchExecz() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_CBRANCH_EXECZ_vi
                       : llvm::AMDGPU::S_CBRANCH_EXECZ_gfx11;
  }
  unsigned sLoadB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_LOAD_DWORD_IMM_vi
                       : llvm::AMDGPU::S_LOAD_B32_IMM_gfx11;
  }
  unsigned sLoadB64() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_LOAD_DWORDX2_IMM_vi
                       : llvm::AMDGPU::S_LOAD_B64_IMM_gfx11;
  }
  unsigned sLoadB128() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_LOAD_DWORDX4_IMM_vi
                       : llvm::AMDGPU::S_LOAD_B128_IMM_gfx11;
  }
  unsigned sWaitcnt() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_WAITCNT_vi
                       : llvm::AMDGPU::S_WAITCNT_gfx11;
  }
  unsigned sNop() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_NOP_vi : llvm::AMDGPU::S_NOP_gfx11;
  }
  unsigned sSetprio() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_SETPRIO_vi
                       : llvm::AMDGPU::S_SETPRIO_gfx11;
  }
  unsigned sBarrier() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_BARRIER_vi
                       : llvm::AMDGPU::S_BARRIER_gfx11;
  }
  unsigned sEndpgm() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_ENDPGM_vi
                       : llvm::AMDGPU::S_ENDPGM_gfx11;
  }
  unsigned sSetpcB64() const {
    return isGfx8Or9() ? llvm::AMDGPU::S_SETPC_B64_vi
                       : llvm::AMDGPU::S_SETPC_B64_gfx11;
  }

  unsigned vMbcntLo() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_MBCNT_LO_U32_B32_e64_vi
                       : llvm::AMDGPU::V_MBCNT_LO_U32_B32_e64_gfx11;
  }
  unsigned vMovB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_MOV_B32_e32_vi
                       : llvm::AMDGPU::V_MOV_B32_e32_gfx11;
  }
  unsigned vLshlrevB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_LSHLREV_B32_e32_vi
                       : llvm::AMDGPU::V_LSHLREV_B32_e32_gfx11;
  }
  unsigned vLshrrevB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_LSHRREV_B32_e32_vi
                       : llvm::AMDGPU::V_LSHRREV_B32_e32_gfx11;
  }
  unsigned vReadfirstlaneB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_READFIRSTLANE_B32_vi
                       : llvm::AMDGPU::V_READFIRSTLANE_B32_gfx11;
  }
  unsigned vMulLoU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_MUL_LO_U32_vi
                       : llvm::AMDGPU::V_MUL_LO_U32_e64_gfx11;
  }
  unsigned vAddF32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_ADD_F32_e32_vi
                       : llvm::AMDGPU::V_ADD_F32_e32_gfx11;
  }
  unsigned vSubF32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_SUB_F32_e32_vi
                       : llvm::AMDGPU::V_SUB_F32_e32_gfx11;
  }
  unsigned vMulF32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_MUL_F32_e32_vi
                       : llvm::AMDGPU::V_MUL_F32_e32_gfx11;
  }
  unsigned vMaxF32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_MAX_F32_e32_vi
                       : llvm::AMDGPU::V_MAX_F32_e32_gfx11;
  }
  unsigned vExpF32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_EXP_F32_e32_vi
                       : llvm::AMDGPU::V_EXP_F32_e32_gfx11;
  }
  unsigned vRcpF32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_RCP_F32_e32_vi
                       : llvm::AMDGPU::V_RCP_F32_e32_gfx11;
  }
  unsigned vCvtF16F32() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_CVT_F16_F32_e64_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::V_CVT_F16_F32_e64_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::V_CVT_F16_F32V_CVT_F16_F32_t16_e64_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::V_CVT_F16_F32V_CVT_F16_F32_t16_e64_gfx12;
    return llvm::AMDGPU::V_CVT_F16_F32V_CVT_F16_F32_t16_e64_gfx13;
  }
  unsigned vCvtF32F16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_CVT_F32_F16_e64_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::V_CVT_F32_F16_e64_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::V_CVT_F32_F16V_CVT_F32_F16_t16_e64_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::V_CVT_F32_F16V_CVT_F32_F16_t16_e64_gfx12;
    return llvm::AMDGPU::V_CVT_F32_F16V_CVT_F32_F16_t16_e64_gfx13;
  }
  bool usesTrue16Cvt() const { return isaVersion.Major >= 11; }
  bool supportsCvtPkRtzF16F32() const { return isaVersion.Major >= 10; }
  bool supportsPackedF16() const { return isaVersion.Major >= 9; }
  unsigned vCvtPkRtzF16F32() const {
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::V_CVT_PKRTZ_F16_F32_e32_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::V_CVT_PK_RTZ_F16_F32_e32_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::V_CVT_PK_RTZ_F16_F32_e32_gfx12;
    return llvm::AMDGPU::V_CVT_PK_RTZ_F16_F32_e32_gfx13;
  }
  unsigned vPkAddF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_ADD_F16_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::V_PK_ADD_F16_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::V_PK_ADD_F16_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::V_PK_ADD_F16_gfx12;
    return llvm::AMDGPU::V_PK_ADD_F16_gfx13;
  }
  unsigned vPkMulF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_MUL_F16_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::V_PK_MUL_F16_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::V_PK_MUL_F16_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::V_PK_MUL_F16_gfx12;
    return llvm::AMDGPU::V_PK_MUL_F16_gfx13;
  }
  unsigned vPkFmaF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_FMA_F16_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::V_PK_FMA_F16_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::V_PK_FMA_F16_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::V_PK_FMA_F16_gfx12;
    return llvm::AMDGPU::V_PK_FMA_F16_gfx13;
  }
  unsigned vCmpEqU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_CMP_EQ_U32_e64_vi
                       : llvm::AMDGPU::V_CMP_EQ_U32_e64_gfx11;
  }
  unsigned vCmpNeU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_CMP_NE_U32_e64_vi
                       : llvm::AMDGPU::V_CMP_NE_U32_e64_gfx11;
  }
  unsigned vCmpLtU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_CMP_LT_U32_e64_vi
                       : llvm::AMDGPU::V_CMP_LT_U32_e64_gfx11;
  }
  unsigned vCmpLeU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_CMP_LE_U32_e64_vi
                       : llvm::AMDGPU::V_CMP_LE_U32_e64_gfx11;
  }
  unsigned vCmpGtU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_CMP_GT_U32_e64_vi
                       : llvm::AMDGPU::V_CMP_GT_U32_e64_gfx11;
  }
  unsigned vCmpGeU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_CMP_GE_U32_e64_vi
                       : llvm::AMDGPU::V_CMP_GE_U32_e64_gfx11;
  }
  unsigned mfmaF32_16x16x16F16() const {
    return isGfx90APlus() ? llvm::AMDGPU::V_MFMA_F32_16X16X16F16_gfx940_vcd
                          : llvm::AMDGPU::V_MFMA_F32_16X16X16F16_vi;
  }
  unsigned mfmaF32_16x16x32F16() const {
    return llvm::AMDGPU::V_MFMA_F32_16X16X32_F16_gfx940_vcd;
  }

  unsigned bufferStoreB32() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_STORE_DWORD_OFFEN_gfx90a;
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_STORE_DWORD_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_STORE_DWORD_OFFEN_gfx11;
  }

  unsigned bufferStoreB16() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_gfx10;
    return llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_gfx11;
  }

  unsigned bufferLoadB32() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_DWORD_OFFEN_gfx90a;
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_LOAD_DWORD_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_LOAD_DWORD_OFFEN_gfx11;
  }

  unsigned bufferLoadB16() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_gfx10;
    return llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_gfx11;
  }

  unsigned globalStoreB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_STORE_DWORD_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_STORE_DWORD_SADDR_gfx11;
  }

  unsigned globalStoreB32Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_DWORD_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::GLOBAL_STORE_DWORD_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::GLOBAL_STORE_DWORD_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::GLOBAL_STORE_DWORD_gfx12;
    return llvm::AMDGPU::GLOBAL_STORE_DWORD_gfx13;
  }

  unsigned globalStoreB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR_gfx12;
    return llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR_gfx13;
  }

  unsigned globalStoreB16Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_gfx12;
    return llvm::AMDGPU::GLOBAL_STORE_SHORT_gfx13;
  }

  unsigned globalLoadB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_LOAD_DWORD_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_LOAD_DWORD_SADDR_gfx11;
  }

  unsigned globalLoadB32Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_DWORD_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::GLOBAL_LOAD_DWORD_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::GLOBAL_LOAD_DWORD_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::GLOBAL_LOAD_DWORD_gfx12;
    return llvm::AMDGPU::GLOBAL_LOAD_DWORD_gfx13;
  }

  unsigned globalLoadB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR_gfx12;
    return llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR_gfx13;
  }

  unsigned globalLoadB16Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_vi;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_gfx12;
    return llvm::AMDGPU::GLOBAL_LOAD_USHORT_gfx13;
  }

  unsigned globalLoadB64() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_LOAD_DWORDX2_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_LOAD_DWORDX2_SADDR_gfx11;
  }

  unsigned globalLoadB96() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_LOAD_DWORDX3_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_LOAD_DWORDX3_SADDR_gfx11;
  }

  unsigned globalLoadB128() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_LOAD_DWORDX4_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_LOAD_DWORDX4_SADDR_gfx11;
  }

  unsigned globalStoreB64() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_STORE_DWORDX2_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_STORE_DWORDX2_SADDR_gfx11;
  }

  unsigned globalStoreB96() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_STORE_DWORDX3_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_STORE_DWORDX3_SADDR_gfx11;
  }

  unsigned globalStoreB128() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_STORE_DWORDX4_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_STORE_DWORDX4_SADDR_gfx11;
  }

  unsigned bufferLoadB64() const {
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_LOAD_DWORDX2_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_LOAD_DWORDX2_OFFEN_gfx11;
  }

  unsigned bufferLoadB96() const {
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_LOAD_DWORDX3_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_LOAD_DWORDX3_OFFEN_gfx11;
  }

  unsigned bufferLoadB128() const {
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_LOAD_DWORDX4_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_LOAD_DWORDX4_OFFEN_gfx11;
  }

  unsigned bufferStoreB64() const {
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_STORE_DWORDX2_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_STORE_DWORDX2_OFFEN_gfx11;
  }

  unsigned bufferStoreB96() const {
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_STORE_DWORDX3_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_STORE_DWORDX3_OFFEN_gfx11;
  }

  unsigned bufferStoreB128() const {
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_STORE_DWORDX4_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_STORE_DWORDX4_OFFEN_gfx11;
  }

  unsigned dsReadB64() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_READ_B64_vi_gfx9
                       : llvm::AMDGPU::DS_READ_B64_gfx11;
  }

  unsigned dsReadB96() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_READ_B96_vi_gfx9
                       : llvm::AMDGPU::DS_READ_B96_gfx11;
  }

  unsigned dsReadB128() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_READ_B128_vi_gfx9
                       : llvm::AMDGPU::DS_READ_B128_gfx11;
  }

  unsigned dsWriteB64() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_WRITE_B64_vi_gfx9
                       : llvm::AMDGPU::DS_WRITE_B64_gfx11;
  }

  unsigned dsWriteB96() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_WRITE_B96_vi_gfx9
                       : llvm::AMDGPU::DS_WRITE_B96_gfx11;
  }

  unsigned dsWriteB128() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_WRITE_B128_vi_gfx9
                       : llvm::AMDGPU::DS_WRITE_B128_gfx11;
  }

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
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_LOAD_DWORD_LDS_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_LOAD_DWORD_LDS_OFFEN_gfx10;
  }

  unsigned bufferLoadLdsB128() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_DWORDX4_LDS_OFFEN_gfx90a;
    return llvm::AMDGPU::BUFFER_LOAD_DWORDX4_LDS_OFFEN_vi;
  }

  unsigned dsReadB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_READ_B32_vi_gfx9
                       : llvm::AMDGPU::DS_READ_B32_gfx11;
  }

  unsigned dsReadB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::DS_READ_U16_vi_gfx9;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::DS_READ_U16_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::DS_READ_U16_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::DS_READ_U16_gfx12;
    return llvm::AMDGPU::DS_READ_U16_gfx13;
  }

  unsigned dsWriteB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_WRITE_B32_vi_gfx9
                       : llvm::AMDGPU::DS_WRITE_B32_gfx11;
  }

  unsigned dsWriteB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::DS_WRITE_B16_vi_gfx9;
    if (isaVersion.Major == 10)
      return llvm::AMDGPU::DS_WRITE_B16_gfx10;
    if (isaVersion.Major == 11)
      return llvm::AMDGPU::DS_WRITE_B16_gfx11;
    if (isaVersion.Major == 12)
      return llvm::AMDGPU::DS_WRITE_B16_gfx12;
    return llvm::AMDGPU::DS_WRITE_B16_gfx13;
  }

  std::optional<unsigned> getImmediate(Value value) const {
    if (auto imm = value.getDefiningOp<waveamdmachine::ImmOp>())
      return static_cast<unsigned>(imm.getValue());
    return std::nullopt;
  }

  void emitLine(StringRef line) {
    for (unsigned i = 0; i < indent; ++i)
      os << '\t';
    os << line << '\n';
  }

  void emitLine(const Twine &line) {
    SmallString<128> storage;
    emitLine(line.toStringRef(storage));
  }

  unsigned getIntAttr(Operation *op, StringRef name, unsigned fallback) const {
    if (auto attr = op->getAttrOfType<IntegerAttr>(name))
      return attr.getInt();
    return fallback;
  }

  bool getBoolAttr(Operation *op, StringRef name, bool fallback) const {
    if (auto attr = op->getAttrOfType<BoolAttr>(name))
      return attr.getValue();
    return fallback;
  }

  LogicalResult emitFunction(func::FuncOp func) {
    if (!func.getBody().hasOneBlock())
      return func.emitError(
          "WaveAMDMachine AMDGPU emitter supports one-block funcs");

    os << "\n\t.globl\t" << func.getSymName() << "\n";
    os << "\t.p2align\t8\n";
    os << "\t.type\t" << func.getSymName() << ",@function\n";
    os << func.getSymName() << ":\n";
    emitLine(
        StringRef("; wave backend: WaveAMDMachine MLIR pipeline finalized"));

    loopCounter = 0;
    funcLabelPrefix = (".L" + Twine(func.getSymName())).str();

    for (Operation &op : func.getBody().front()) {
      if (isa<func::ReturnOp>(op))
        continue;
      if (!isWM(&op))
        return op.emitError(
            "unexpected non-WaveAMDMachine operation in emitter");
      if (failed(emitOperation(op)))
        return failure();
    }

    os << "\t.size\t" << func.getSymName() << ", .-" << func.getSymName()
       << "\n";
    if (func->hasAttr(wave::WaveDialect::getKernelAttrName())) {
      KernelInfo info;
      info.name = func.getSymName().str();
      info.kernargSize = getKernelArgSize(func);
      info.sgprCount = getIntAttr(func, "waveamdmachine.sgpr_count", 6);
      info.vgprCount = getIntAttr(func, "waveamdmachine.vgpr_count", 1);
      info.ldsSize = getIntAttr(func, "waveamdmachine.lds_size", 0);
      SmallVector<waveamd::KernargSlot> layout =
          waveamd::getKernargLayout(func.getFunctionType().getInputs());
      for (auto [index, slot] : llvm::enumerate(layout)) {
        info.args.push_back(KernelArgInfo{("arg" + Twine(index)).str(),
                                          slot.offset, slot.size,
                                          slot.isGlobalBuffer});
      }
      kernels.push_back(info);
      emitKernelDescriptor(func);
    }
    return success();
  }

  unsigned getKernelArgSize(func::FuncOp func) const {
    if (auto attr =
            func->getAttrOfType<IntegerAttr>("waveamdmachine.kernarg_size"))
      return attr.getInt();
    return waveamd::getKernargSegmentSize(func.getFunctionType().getInputs());
  }

  void emitKernelDescriptor(func::FuncOp func) {
    unsigned kernargSize = getKernelArgSize(func);
    unsigned sgprCount = getIntAttr(func, "waveamdmachine.sgpr_count", 6);
    unsigned vgprCount = getIntAttr(func, "waveamdmachine.vgpr_count", 1);
    unsigned ldsSize = getIntAttr(func, "waveamdmachine.lds_size", 0);
    bool usesWgY = false;
    bool usesWgZ = false;
    func.walk([&](Operation *op) {
      if (isa<waveamdmachine::SWorkgroupIdYOp>(op))
        usesWgY = true;
      if (isa<waveamdmachine::SWorkgroupIdZOp>(op))
        usesWgZ = true;
    });
    os << "\t.section\t.rodata,\"a\",@progbits\n";
    os << "\t.p2align\t6, 0x0\n";
    os << "\t.amdhsa_kernel " << func.getSymName() << "\n";
    os << "\t\t.amdhsa_group_segment_fixed_size " << ldsSize << "\n";
    os << "\t\t.amdhsa_private_segment_fixed_size 0\n";
    os << "\t\t.amdhsa_kernarg_size " << kernargSize << "\n";
    os << "\t\t.amdhsa_user_sgpr_count 2\n";
    os << "\t\t.amdhsa_user_sgpr_kernarg_segment_ptr 1\n";
    if (!isGfx8Or9() && wavefrontSize == 32) {
      os << "\t\t.amdhsa_wavefront_size32 1\n";
      os << "\t\t.amdhsa_uses_dynamic_stack 0\n";
      os << "\t\t.amdhsa_enable_private_segment 0\n";
    }
    os << "\t\t.amdhsa_system_sgpr_workgroup_id_x 1\n";
    os << "\t\t.amdhsa_system_sgpr_workgroup_id_y " << (usesWgY ? 1 : 0)
       << "\n";
    os << "\t\t.amdhsa_system_sgpr_workgroup_id_z " << (usesWgZ ? 1 : 0)
       << "\n";
    os << "\t\t.amdhsa_system_sgpr_workgroup_info 0\n";
    os << "\t\t.amdhsa_system_vgpr_workitem_id 0\n";
    os << "\t\t.amdhsa_next_free_vgpr " << vgprCount << "\n";
    os << "\t\t.amdhsa_next_free_sgpr " << sgprCount << "\n";
    if (isGfx90APlus()) {
      unsigned accumOffset = (std::max(vgprCount, 1u) + 3u) & ~3u;
      os << "\t\t.amdhsa_accum_offset " << accumOffset << "\n";
    }
    os << "\t\t.amdhsa_reserve_vcc 0\n";
    os << "\t\t.amdhsa_float_round_mode_32 0\n";
    os << "\t\t.amdhsa_float_round_mode_16_64 0\n";
    os << "\t\t.amdhsa_float_denorm_mode_32 3\n";
    os << "\t\t.amdhsa_float_denorm_mode_16_64 3\n";
    os << "\t\t.amdhsa_dx10_clamp 1\n";
    os << "\t\t.amdhsa_ieee_mode 1\n";
    os << "\t\t.amdhsa_fp16_overflow 0\n";
    if (!isGfx8Or9()) {
      os << "\t\t.amdhsa_workgroup_processor_mode 1\n";
      os << "\t\t.amdhsa_memory_ordered 1\n";
      os << "\t\t.amdhsa_forward_progress 1\n";
      os << "\t\t.amdhsa_shared_vgpr_count 0\n";
      os << "\t\t.amdhsa_inst_pref_size 1\n";
    }
    os << "\t.end_amdhsa_kernel\n";
    os << "\t.text\n";
    os << "\t.set .L" << func.getSymName() << ".num_vgpr, " << vgprCount
       << "\n";
    os << "\t.set .L" << func.getSymName() << ".num_agpr, 0\n";
    os << "\t.set .L" << func.getSymName() << ".numbered_sgpr, " << sgprCount
       << "\n";
    os << "\t.set .L" << func.getSymName() << ".num_named_barrier, 0\n";
    os << "\t.set .L" << func.getSymName() << ".private_seg_size, 0\n";
    os << "\t.set .L" << func.getSymName() << ".uses_vcc, 0\n";
    os << "\t.set .L" << func.getSymName() << ".uses_flat_scratch, 0\n";
    os << "\t.set .L" << func.getSymName() << ".has_dyn_sized_stack, 0\n";
    os << "\t.set .L" << func.getSymName() << ".has_recursion, 0\n";
    os << "\t.set .L" << func.getSymName() << ".has_indirect_call, 0\n";
  }

  void emitMetadata() {
    if (kernels.empty())
      return;

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
      os << "    .group_segment_fixed_size: " << kernel.ldsSize << "\n";
      os << "    .kernarg_segment_align: 8\n";
      os << "    .kernarg_segment_size: " << kernel.kernargSize << "\n";
      os << "    .max_flat_workgroup_size: 1024\n";
      os << "    .name:           " << kernel.name << "\n";
      os << "    .private_segment_fixed_size: 0\n";
      os << "    .sgpr_count:     " << kernel.sgprCount << "\n";
      os << "    .sgpr_spill_count: 0\n";
      os << "    .symbol:         " << kernel.name << ".kd\n";
      os << "    .uses_dynamic_stack: false\n";
      os << "    .vgpr_count:     " << kernel.vgprCount << "\n";
      os << "    .vgpr_spill_count: 0\n";
      os << "    .wavefront_size: " << wavefrontSize << "\n";
      os << "    .workgroup_processor_mode: 1\n";
    }
    os << "amdhsa.target:   " << targetTriple << "--" << targetChip << "\n";
    os << "amdhsa.version:\n";
    os << "  - 1\n";
    os << "  - 2\n";
    os << "...\n";
    os << "\t.end_amdgpu_metadata\n";
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
    StringRef prefix =
        regType.getRegClass() == waveamdmachine::RegClass::VGPR ? "v" : "s";
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
    if (name == "s0")
      return llvm::AMDGPU::SGPR0;
    if (name == "s[0:1]")
      return llvm::AMDGPU::SGPR0_SGPR1;
    if (name == "vcc")
      return llvm::AMDGPU::VCC;
    if (name == "m0")
      return llvm::AMDGPU::M0;
    if (name == "exec_lo")
      return llvm::AMDGPU::EXEC_LO;
    if (name == "null")
      return llvm::AMDGPU::SGPR_NULL;
    if (name == "vcc_lo")
      return llvm::AMDGPU::VCC_LO;
    llvm_unreachable("unknown physical register name");
  }

  unsigned mcReg(Value value) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    unsigned phys = getPhys(value);
    if (regType.getRegClass() == waveamdmachine::RegClass::VGPR)
      return mcVGPRReg(phys, regType.getWidth());
    if (regType.getWidth() == 4)
      return llvm::AMDGPU::SGPR0_SGPR1_SGPR2_SGPR3 + phys / 4;
    if (regType.getWidth() == 2)
      return llvm::AMDGPU::SGPR0_SGPR1 + phys / 2;
    return llvm::AMDGPU::SGPR0 + phys;
  }

  unsigned mcVGPRReg(unsigned phys, unsigned width) const {
    switch (width) {
    case 1:
      return llvm::AMDGPU::VGPR0 + phys;
    case 2:
      return llvm::AMDGPU::VGPR0_VGPR1 + phys;
    case 3:
      return llvm::AMDGPU::VGPR0_VGPR1_VGPR2 + phys;
    case 4:
      return llvm::AMDGPU::VGPR0_VGPR1_VGPR2_VGPR3 + phys;
    case 8:
      return llvm::AMDGPU::VGPR0_VGPR1_VGPR2_VGPR3_VGPR4_VGPR5_VGPR6_VGPR7 +
             phys;
    default:
      llvm_unreachable("unsupported VGPR tuple width");
    }
  }

  llvm::MCOperand toMCVGPRComponent(Value value, unsigned component) const {
    auto regType = cast<waveamdmachine::RegType>(value.getType());
    if (regType.getRegClass() != waveamdmachine::RegClass::VGPR ||
        component >= regType.getWidth())
      llvm_unreachable("expected valid VGPR tuple component");
    return llvm::MCOperand::createReg(mcVGPRReg(getPhys(value) + component, 1));
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

  LogicalResult emitMC(unsigned opcode, ArrayRef<llvm::MCOperand> operands) {
    llvm::MCInst inst;
    inst.setOpcode(opcode);
    for (const llvm::MCOperand &operand : operands)
      inst.addOperand(operand);
    for (unsigned i = 0; i < indent; ++i)
      os << '\t';
    instPrinter->printInst(&inst, /*Address=*/0, /*Annot=*/"", *sti, os);
    os << '\n';
    return success();
  }

  LogicalResult emitMCValues(unsigned opcode, ValueRange operands) {
    SmallVector<llvm::MCOperand> mcOperands;
    for (Value operand : operands)
      mcOperands.push_back(toMCOperand(operand));
    return emitMC(opcode, mcOperands);
  }

  unsigned packedSrcMods(unsigned opSel, unsigned opSelHi,
                         unsigned operandIndex) const {
    return (((opSel >> operandIndex) & 1) << 2) |
           (((opSelHi >> operandIndex) & 1) << 3);
  }

  LogicalResult emitPackedBinary(unsigned opcode, Operation &op) {
    unsigned opSel = getIntAttr(&op, "op_sel", 0);
    unsigned opSelHi = getIntAttr(&op, "op_sel_hi", 3);
    return emitMC(
        opcode,
        {toMCOperand(op.getResult(0)),
         llvm::MCOperand::createImm(packedSrcMods(opSel, opSelHi, 0)),
         toMCOperand(op.getOperand(0)),
         llvm::MCOperand::createImm(packedSrcMods(opSel, opSelHi, 1)),
         toMCOperand(op.getOperand(1)),
         llvm::MCOperand::createImm(getBoolAttr(&op, "clamp", false)),
         llvm::MCOperand::createImm(opSel), llvm::MCOperand::createImm(opSelHi),
         llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitPackedTernary(unsigned opcode, Operation &op) {
    unsigned opSel = getIntAttr(&op, "op_sel", 0);
    unsigned opSelHi = getIntAttr(&op, "op_sel_hi", 7);
    return emitMC(
        opcode,
        {toMCOperand(op.getResult(0)),
         llvm::MCOperand::createImm(packedSrcMods(opSel, opSelHi, 0)),
         toMCOperand(op.getOperand(0)),
         llvm::MCOperand::createImm(packedSrcMods(opSel, opSelHi, 1)),
         toMCOperand(op.getOperand(1)),
         llvm::MCOperand::createImm(packedSrcMods(opSel, opSelHi, 2)),
         toMCOperand(op.getOperand(2)),
         llvm::MCOperand::createImm(getBoolAttr(&op, "clamp", false)),
         llvm::MCOperand::createImm(opSel), llvm::MCOperand::createImm(opSelHi),
         llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0)});
  }

  // Shared emit shapes for the width-parameterised mem ops. The MC
  // operand order is what the LLVM AMDGPU printer expects per family:
  //   GLOBAL_*_SADDR: vdst/vdata, saddr, vaddr, offset, cpol
  //   BUFFER_*_OFFEN: vdst/vdata, vaddr, srsrc, soffset, offset, cpol
  //   DS_READ_*:      vdst, vaddr, offset, gds
  //   DS_WRITE_*:     vaddr, vdata, offset, gds
  LogicalResult emitGlobalLoad(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(1)),
                   toMCOperand(op.getOperand(0)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitGlobalStore(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   toMCOperand(op.getOperand(2)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitGlobalAddrLoad(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitGlobalAddrStore(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitBufferLoad(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitBufferStore(Operation &op, unsigned opcode) {
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(0)),
                   toMCOperand(op.getOperand(2)), toMCOperand(op.getOperand(3)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsLoad(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitDsStore(Operation &op, unsigned opcode) {
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                   llvm::MCOperand::createImm(0)});
  }

  LogicalResult emitVAddU32(llvm::MCOperand dst, llvm::MCOperand lhs,
                            llvm::MCOperand rhs, Operation &op) {
    if (isaVersion.Major == 8)
      return op.emitError("v_add_u32 without VCC result unsupported on gfx8");
    if (isaVersion.Major == 9)
      return emitMC(llvm::AMDGPU::V_ADD_U32_e32_gfx9, {dst, lhs, rhs});
    return emitMC(llvm::AMDGPU::V_ADD_NC_U32_e32_gfx11, {dst, lhs, rhs});
  }

  LogicalResult emitVAddU32Vcc(llvm::MCOperand dst, llvm::MCOperand lhs,
                               llvm::MCOperand rhs) {
    if (isaVersion.Major == 8)
      return emitMC(llvm::AMDGPU::V_ADD_U32_e32_vi, {dst, lhs, rhs});
    if (isaVersion.Major == 9)
      return emitMC(llvm::AMDGPU::V_ADD_CO_U32_e32_gfx9, {dst, lhs, rhs});
    llvm::MCOperand vccLo = llvm::MCOperand::createReg(namedPhysReg("vcc_lo"));
    llvm::MCOperand clamp = llvm::MCOperand::createImm(0);
    return emitMC(llvm::AMDGPU::V_ADD_CO_U32_e64_gfx11,
                  {dst, vccLo, lhs, rhs, clamp});
  }

  LogicalResult emitVMulLoU32(Operation &op, Value dst, Value lhs, Value rhs) {
    if (isGfx8Or9()) {
      std::optional<unsigned> lhsImm = getImmediate(lhs);
      std::optional<unsigned> rhsImm = getImmediate(rhs);
      if (lhsImm && rhsImm)
        return op.emitError("v_mul_lo_u32 cannot materialize two immediates");
      if (lhsImm || rhsImm) {
        Value immValue = lhsImm ? lhs : rhs;
        Value regValue = lhsImm ? rhs : lhs;
        if (failed(
                emitMC(vMovB32(), {toMCOperand(dst), toMCOperand(immValue)})))
          return failure();
        return emitMC(vMulLoU32(), {toMCOperand(dst), toMCOperand(dst),
                                    toMCOperand(regValue)});
      }
    }
    return emitMC(vMulLoU32(),
                  {toMCOperand(dst), toMCOperand(lhs), toMCOperand(rhs)});
  }

  bool isSGPR(Value value) const {
    auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
    return regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR;
  }

  bool isVGPR(Value value) const {
    auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
    return regType && regType.getRegClass() == waveamdmachine::RegClass::VGPR;
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
    os << headLabel << ":\n";
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
    os << exitLabel << ":\n";
    return success();
  }

  LogicalResult emitOperation(Operation &op) {
    auto operandString = [&](unsigned i) {
      return operandToString(op.getOperand(i));
    };
    auto result = [&]() { return op.getResult(0); };
    StringRef name = op.getName().getStringRef();

    if (isa<waveamdmachine::ImmOp, waveamdmachine::ArgOp,
            waveamdmachine::TokenOp, waveamdmachine::TokenJoinOp,
            waveamdmachine::WaitOp>(&op))
      return success();
    // Preloaded values delivered by the HSA loader: the SSA value already
    // lives in its pinned register (s2/s3/s4 or v0) at kernel entry, so
    // there is nothing to emit here. The descriptor flips the matching
    // `.amdhsa_system_sgpr_workgroup_id_*` / `.amdhsa_system_vgpr_workitem_id`
    // bits to make the loader perform the preload.
    if (isa<waveamdmachine::SWorkgroupIdXOp, waveamdmachine::SWorkgroupIdYOp,
            waveamdmachine::SWorkgroupIdZOp, waveamdmachine::VWorkitemIdXOp>(
            &op))
      return success();
    if (isa<waveamdmachine::LabelOp>(op)) {
      os << op.getAttrOfType<StringAttr>("name").str() << ":\n";
      return success();
    }
    if (isa<waveamdmachine::VMbcntLoOp>(op))
      return emitMC(vMbcntLo(),
                    {toMCOperand(result()), llvm::MCOperand::createImm(-1),
                     llvm::MCOperand::createImm(0)});
    // hwreg(HW_REG_SHADER_CYCLES=29, offset=0, size=32) packed as
    // id | (offset << 6) | ((size - 1) << 11) = 0xF81D. Gated on
    // gfx11 by archPredicate; emitter assumes the dispatcher already
    // honoured isSupportedOnIsa.
    if (isa<waveamdmachine::SGetregShaderCyclesOp>(op))
      return emitMC(
          llvm::AMDGPU::S_GETREG_B32_gfx11,
          {toMCOperand(result()), llvm::MCOperand::createImm(0xF81D)});
    // Pure SSA renames: the regalloc has already aliased each element
    // to its slot of the tuple's physical block (`tuple_phys + i`), so
    // there is nothing to emit.
    if (isa<waveamdmachine::TupleToElementsOp>(op) ||
        isa<waveamdmachine::TupleFromElementsOp>(op))
      return success();
    if (isa<waveamdmachine::VMovB32TupleOp>(op)) {
      auto regType = cast<waveamdmachine::RegType>(result().getType());
      Value src = op.getOperand(0);
      auto srcType = dyn_cast<waveamdmachine::RegType>(src.getType());
      bool srcTuple = srcType &&
                      srcType.getRegClass() == waveamdmachine::RegClass::VGPR &&
                      srcType.getWidth() == regType.getWidth();
      for (unsigned i = 0, e = regType.getWidth(); i != e; ++i) {
        llvm::MCOperand srcOp =
            srcTuple ? toMCVGPRComponent(src, i) : toMCOperand(src);
        if (failed(emitMC(vMovB32(), {toMCVGPRComponent(result(), i), srcOp})))
          return failure();
      }
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
    if (isa<waveamdmachine::WmmaI32_16x16x16_IU8Op>(op))
      return emitMC(
          llvm::AMDGPU::V_WMMA_I32_16X16X16_IU8_twoaddr_w32_gfx11,
          {toMCOperand(result()), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::WmmaF32_16x16x16_F16Op>(op))
      return emitMC(
          llvm::AMDGPU::V_WMMA_F32_16X16X16_F16_twoaddr_w32_gfx11,
          {toMCOperand(result()), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    if (isa<waveamdmachine::MfmaF32_16x16x16_F16Op>(op)) {
      if (!isGfx90APlus())
        return op.emitError("mfma.f32.16x16x16.f16 requires gfx90a+");
      return emitMC(
          mfmaF32_16x16x16F16(),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::MfmaF32_16x16x32_F16Op>(op)) {
      if (!isGfx950(isaVersion))
        return op.emitError("mfma.f32.16x16x32.f16 requires gfx950");
      return emitMC(
          mfmaF32_16x16x32F16(),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<waveamdmachine::VAddU32Op>(op)) {
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (isSGPR(rhs))
        std::swap(lhs, rhs);
      return emitVAddU32(toMCOperand(result()), toMCOperand(lhs),
                         toMCOperand(rhs), op);
    }
    if (isa<waveamdmachine::VAddU32VccOp>(op)) {
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (isSGPR(rhs))
        std::swap(lhs, rhs);
      return emitVAddU32Vcc(toMCOperand(result()), toMCOperand(lhs),
                            toMCOperand(rhs));
    }
    if (isa<waveamdmachine::VAndB32Op, waveamdmachine::VOrB32Op,
            waveamdmachine::VXorB32Op>(op)) {
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      // VOP2 e32: src1 must be a VGPR. Both SGPR and imm RHS need to
      // swap into src0; if both sides are non-VGPR we'd need a VOP3
      // form, but the bucketizer only emits these with a VGPR on one
      // side so the swap suffices.
      if (!isVGPR(rhs))
        std::swap(lhs, rhs);
      unsigned opcode = isa<waveamdmachine::VAndB32Op>(op)
                            ? llvm::AMDGPU::V_AND_B32_e32_gfx11
                        : isa<waveamdmachine::VOrB32Op>(op)
                            ? llvm::AMDGPU::V_OR_B32_e32_gfx11
                            : llvm::AMDGPU::V_XOR_B32_e32_gfx11;
      return emitMC(
          opcode, {toMCOperand(result()), toMCOperand(lhs), toMCOperand(rhs)});
    }
    if (isa<waveamdmachine::VLshlrevB32Op>(op))
      return emitMC(vLshlrevB32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::VLshrrevB32Op>(op))
      return emitMC(vLshrrevB32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::VMulLoU32Op>(op))
      // v_mul_lo_u32 is VOP3-only on RDNA3; operand placement is
      // unconstrained so we emit (vdst, src0, src1) as-is without the
      // VOP2 swap dance.
      return emitVMulLoU32(op, result(), op.getOperand(0), op.getOperand(1));
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
    if (isa<waveamdmachine::VExpF32Op, waveamdmachine::VRcpF32Op>(op)) {
      unsigned opcode =
          isa<waveamdmachine::VExpF32Op>(op) ? vExpF32() : vRcpF32();
      return emitMC(opcode,
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    }
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
        return op.emitError("v_cvt_pk_rtz_f16_f32 requires gfx10+");
      return emitMC(vCvtPkRtzF16F32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
    }
    if (isa<waveamdmachine::VPkAddF16Op, waveamdmachine::VPkMulF16Op>(op)) {
      if (!supportsPackedF16())
        return op.emitError("v_pk_*_f16 requires gfx9+");
      unsigned opcode =
          isa<waveamdmachine::VPkAddF16Op>(op) ? vPkAddF16() : vPkMulF16();
      return emitPackedBinary(opcode, op);
    }
    if (isa<waveamdmachine::VPkFmaF16Op>(op)) {
      if (!supportsPackedF16())
        return op.emitError("v_pk_fma_f16 requires gfx9+");
      return emitPackedTernary(vPkFmaF16(), op);
    }
    if (isa<waveamdmachine::VCmpEqU32Op, waveamdmachine::VCmpEqU32VccOp,
            waveamdmachine::VCmpNeU32Op, waveamdmachine::VCmpNeU32VccOp,
            waveamdmachine::VCmpLtU32Op, waveamdmachine::VCmpLtU32VccOp,
            waveamdmachine::VCmpLeU32Op, waveamdmachine::VCmpLeU32VccOp,
            waveamdmachine::VCmpGtU32Op, waveamdmachine::VCmpGtU32VccOp,
            waveamdmachine::VCmpGeU32Op, waveamdmachine::VCmpGeU32VccOp>(op)) {
      unsigned opcode =
          isa<waveamdmachine::VCmpEqU32Op, waveamdmachine::VCmpEqU32VccOp>(op)
              ? vCmpEqU32()
          : isa<waveamdmachine::VCmpNeU32Op, waveamdmachine::VCmpNeU32VccOp>(op)
              ? vCmpNeU32()
          : isa<waveamdmachine::VCmpLtU32Op, waveamdmachine::VCmpLtU32VccOp>(op)
              ? vCmpLtU32()
          : isa<waveamdmachine::VCmpLeU32Op, waveamdmachine::VCmpLeU32VccOp>(op)
              ? vCmpLeU32()
          : isa<waveamdmachine::VCmpGtU32Op, waveamdmachine::VCmpGtU32VccOp>(op)
              ? vCmpGtU32()
              : vCmpGeU32();
      bool writesVcc =
          isa<waveamdmachine::VCmpEqU32VccOp, waveamdmachine::VCmpNeU32VccOp,
              waveamdmachine::VCmpLtU32VccOp, waveamdmachine::VCmpLeU32VccOp,
              waveamdmachine::VCmpGtU32VccOp, waveamdmachine::VCmpGeU32VccOp>(
              op);
      if (isGfx8Or9() && !writesVcc)
        return op.emitError(
            "v_cmp_*_u32 without VCC result unsupported on gfx8/9");
      llvm::MCOperand dst =
          writesVcc ? llvm::MCOperand::createReg(
                          namedPhysReg(wavefrontSize == 32 ? "vcc_lo" : "vcc"))
                    : toMCOperand(result());
      if (failed(emitMC(opcode, {dst, toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))})))
        return failure();
      if (!writesVcc)
        return success();
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
    if (isa<waveamdmachine::SMulI32Op>(op))
      return emitMC(sMulI32(), {toMCOperand(op.getResult(0)),
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
    if (isa<waveamdmachine::SAndB32Op>(op))
      return emitMC(sAndB32(), {toMCOperand(op.getResult(0)),
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
      // wave32 carry register: vcc_lo. Documented constraint that
      // nothing else clobbers it across this pair.
      Value res = op.getResult(0);
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      llvm::MCOperand vccLo =
          llvm::MCOperand::createReg(namedPhysReg("vcc_lo"));
      llvm::MCOperand clamp = llvm::MCOperand::createImm(0);
      if (failed(emitMC(llvm::AMDGPU::V_ADD_CO_U32_e64_gfx11,
                        {toMCVGPRComponent(res, 0), vccLo,
                         toMCVGPRComponent(lhs, 0), toMCVGPRComponent(rhs, 0),
                         clamp})))
        return failure();
      return emitMC(llvm::AMDGPU::V_ADD_CO_CI_U32_e64_gfx11,
                    {toMCVGPRComponent(res, 1), vccLo,
                     toMCVGPRComponent(lhs, 1), toMCVGPRComponent(rhs, 1),
                     vccLo, clamp});
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
      if (failed(emitMC(llvm::AMDGPU::V_MUL_LO_U32_e64_gfx11,
                        {toMCVGPRComponent(res, 0), toMCVGPRComponent(lhs, 0),
                         toMCVGPRComponent(rhs, 0)})) ||
          failed(emitMC(llvm::AMDGPU::V_MUL_HI_U32_e64_gfx11,
                        {toMCVGPRComponent(res, 1), toMCVGPRComponent(lhs, 0),
                         toMCVGPRComponent(rhs, 0)})) ||
          failed(emitMC(llvm::AMDGPU::V_MUL_LO_U32_e64_gfx11,
                        {toMCOperand(scratch), toMCVGPRComponent(lhs, 0),
                         toMCVGPRComponent(rhs, 1)})) ||
          failed(emitVAddU32(toMCVGPRComponent(res, 1),
                             toMCVGPRComponent(res, 1), toMCOperand(scratch),
                             op)) ||
          failed(emitMC(llvm::AMDGPU::V_MUL_LO_U32_e64_gfx11,
                        {toMCOperand(scratch), toMCVGPRComponent(lhs, 1),
                         toMCVGPRComponent(rhs, 0)})))
        return failure();
      return emitVAddU32(toMCVGPRComponent(res, 1), toMCVGPRComponent(res, 1),
                         toMCOperand(scratch), op);
    }
    if (isa<waveamdmachine::SLshlB64Op>(op))
      // Hardware reads only the low 32 bits of the shift amount; pass
      // the low component of the 2-wide shift operand.
      return emitMC(llvm::AMDGPU::S_LSHL_B64_gfx11,
                    {toMCOperand(op.getResult(0)),
                     toMCOperand(op.getOperand(0)),
                     toMCSGPRComponent(op.getOperand(1), 0)});
    if (isa<waveamdmachine::VLshlrevB64Op>(op))
      return emitMC(llvm::AMDGPU::V_LSHLREV_B64_e64_gfx11,
                    {toMCOperand(op.getResult(0)),
                     toMCVGPRComponent(op.getOperand(0), 0),
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
    if (isa<waveamdmachine::SCmpLtI32Op>(op))
      return emitMC(sCmpLtI32(), {toMCOperand(op.getOperand(0)),
                                  toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SCmpLgU32Op>(op))
      return emitMC(sCmpLgU32(), {toMCOperand(op.getOperand(0)),
                                  toMCOperand(op.getOperand(1))});
    if (isa<waveamdmachine::SCBranchScc0Op>(op))
      return emitMC(sCbranchScc0(),
                    {labelOperand(op.getAttrOfType<StringAttr>("label"))});
    if (isa<waveamdmachine::SCBranchScc1Op>(op))
      return emitMC(sCbranchScc1(),
                    {labelOperand(op.getAttrOfType<StringAttr>("label"))});
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
    if (isa<waveamdmachine::SWaitcntOp>(op))
      return emitMCValues(sWaitcnt(), op.getOperands());
    if (isa<waveamdmachine::SWaitcntVscntOp>(op)) {
      if (isGfx8Or9()) {
        unsigned vmcnt = getImmediate(op.getOperand(0)).value_or(0);
        unsigned encoded =
            llvm::AMDGPU::encodeWaitcnt(isaVersion, vmcnt, /*expcnt=*/~0u,
                                        /*lgkmcnt=*/~0u);
        return emitMC(sWaitcnt(), {llvm::MCOperand::createImm(encoded)});
      }
      return emitMC(llvm::AMDGPU::S_WAITCNT_VSCNT_gfx11,
                    {llvm::MCOperand::createReg(namedPhysReg("null")),
                     toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::SNopOp>(op))
      return emitMCValues(sNop(), op.getOperands());
    if (isa<waveamdmachine::SSetprioOp>(op))
      return emitMCValues(sSetprio(), op.getOperands());
    if (isa<waveamdmachine::SDelayAluOp>(op)) {
      if (isGfx8Or9())
        return success();
      return emitMCValues(llvm::AMDGPU::S_DELAY_ALU_gfx11, op.getOperands());
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
      return emitMC(llvm::AMDGPU::S_AND_SAVEEXEC_B32_gfx11,
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    }
    if (isa<waveamdmachine::SAndn2ExecB32Op>(op)) {
      return emitMC(sAndn2B32(),
                    {llvm::MCOperand::createReg(namedPhysReg("exec_lo")),
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
    if (isa<waveamdmachine::SMovM0Op>(op))
      return emitMC(sMovB32(), {llvm::MCOperand::createReg(namedPhysReg("m0")),
                                toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::VReadfirstlaneB32Op>(op))
      return emitMC(vReadfirstlaneB32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    if (isa<waveamdmachine::GlobalStoreB16Addr64Op>(op))
      return emitGlobalAddrStore(op, globalStoreB16Addr64());
    if (isa<waveamdmachine::GlobalStoreB32Addr64Op>(op))
      return emitGlobalAddrStore(op, globalStoreB32Addr64());
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
    if (isa<waveamdmachine::GlobalLoadB16Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadB16Addr64());
    if (isa<waveamdmachine::GlobalLoadB32Addr64Op>(op))
      return emitGlobalAddrLoad(op, globalLoadB32Addr64());
    if (isa<waveamdmachine::GlobalLoadB16Op>(op))
      return emitGlobalLoad(op, globalLoadB16());
    if (isa<waveamdmachine::GlobalLoadB32Op>(op))
      return emitGlobalLoad(op, globalLoadB32());
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
    if (isa<waveamdmachine::MakeBufferRsrcOp>(op)) {
      constexpr uint32_t gfx11Format32Float = 22;
      constexpr uint32_t defaultRsrcFlags =
          (gfx11Format32Float << 12) | (1u << 24) | (3u << 28);
      if (failed(emitMC(sMovB32(), {toMCSGPRComponent(result(), 0),
                                    toMCSGPRComponent(op.getOperand(0), 0)})) ||
          failed(emitMC(sMovB32(), {toMCSGPRComponent(result(), 1),
                                    toMCSGPRComponent(op.getOperand(0), 1)})) ||
          failed(emitMC(sMovB32(), {toMCSGPRComponent(result(), 2),
                                    toMCOperand(op.getOperand(1))})) ||
          failed(emitMC(sMovB32(),
                        {toMCSGPRComponent(result(), 3),
                         llvm::MCOperand::createImm(defaultRsrcFlags)})))
        return failure();
      return success();
    }
    // MUBUF OFFEN variants (BUFFER_{LOAD,STORE}_DWORD_OFFEN) take the
    // operands in the order vdata/vdst, vaddr, srsrc, soffset, offset,
    // cpol. The SGPR descriptor (`srsrc`) is the 4-tuple from
    // `make_buffer_rsrc`, the per-lane VGPR offset is fed through
    // `vaddr` with the `offen` flag, and `soffset` is a hard-zero
    // immediate; `cpol` is the unset cache-policy.
    // MUBUF OFFEN operand layout (MC):
    //   STORE: vdata, vaddr, srsrc, soffset, offset, cpol
    //   LOAD : vdst, vaddr, srsrc, soffset, offset, cpol
    // Our IR layout (waveamdmachine):
    //   STORE: offset(VGPR1), value(VGPR1), descriptor(SGPR4),
    //          soffset(SGPR1OrImm), [dep], inst_offset attr
    //   LOAD : offset(VGPR1), descriptor(SGPR4),
    //          soffset(SGPR1OrImm), [dep], inst_offset attr
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
    if (isa<waveamdmachine::GlobalLoadLdsB32Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitMC(globalLoadLdsB32(), {toMCOperand(op.getOperand(1)),
                                         toMCOperand(op.getOperand(0)),
                                         llvm::MCOperand::createImm(instOffset),
                                         llvm::MCOperand::createImm(aux)});
    }
    if (isa<waveamdmachine::GlobalLoadLdsB128Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitMC(globalLoadLdsB128(),
                    {toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(0)),
                     llvm::MCOperand::createImm(instOffset),
                     llvm::MCOperand::createImm(aux)});
    }
    if (isa<waveamdmachine::BufferLoadLdsB32Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitMC(bufferLoadLdsB32(), {toMCOperand(op.getOperand(0)),
                                         toMCOperand(op.getOperand(1)),
                                         toMCOperand(op.getOperand(2)),
                                         llvm::MCOperand::createImm(instOffset),
                                         llvm::MCOperand::createImm(aux)});
    }
    if (isa<waveamdmachine::BufferLoadLdsB128Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitMC(bufferLoadLdsB128(),
                    {toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(2)),
                     llvm::MCOperand::createImm(instOffset),
                     llvm::MCOperand::createImm(aux)});
    }
    if (isa<waveamdmachine::DsLoadB16Op>(op))
      return emitDsLoad(op, dsReadB16());
    if (isa<waveamdmachine::DsLoadB32Op>(op))
      return emitDsLoad(op, dsReadB32());
    if (isa<waveamdmachine::DsLoadB64Op>(op))
      return emitDsLoad(op, dsReadB64());
    if (isa<waveamdmachine::DsLoadB96Op>(op))
      return emitDsLoad(op, dsReadB96());
    if (isa<waveamdmachine::DsLoadB128Op>(op))
      return emitDsLoad(op, dsReadB128());
    if (isa<waveamdmachine::DsStoreB16Op>(op))
      return emitDsStore(op, dsWriteB16());
    if (isa<waveamdmachine::DsStoreB32Op>(op))
      return emitDsStore(op, dsWriteB32());
    if (isa<waveamdmachine::DsStoreB64Op>(op))
      return emitDsStore(op, dsWriteB64());
    if (isa<waveamdmachine::DsStoreB96Op>(op))
      return emitDsStore(op, dsWriteB96());
    if (isa<waveamdmachine::DsStoreB128Op>(op))
      return emitDsStore(op, dsWriteB128());
    if (isa<waveamdmachine::SBarrierOp>(op))
      return emitMC(sBarrier(), {});
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
  // The backend pipeline runs canonicalize + cse after selection to
  // fold duplicate const materializations; register them for this
  // path too (outside wave-opt's registerAllPasses).
  registerCanonicalizerPass();
  registerCSEPass();
  registerLoopInvariantCodeMotionPass();
  ctx->getOrLoadDialect<transform::TransformDialect>();

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

  Operation *entry =
      transform::detail::findTransformEntryPoint(module, *transformModule);
  if (!entry)
    return module.emitError("Wave compilation pipeline `")
           << path << "` missing entry point";

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
