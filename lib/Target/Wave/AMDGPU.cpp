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
#include "mlir/Dialect/Wave/Transforms/WaveAMDEntryRegs.h"
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
#include <cassert>

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

#define WAVE_AMDGPU_OPCODE_LIST(X)                                             \
  X(sMovB32, S_MOV_B32_vi, S_MOV_B32_gfx11)                                    \
  X(sAddI32, S_ADD_I32_vi, S_ADD_I32_gfx11)                                    \
  X(sMulI32, S_MUL_I32_vi, S_MUL_I32_gfx11)                                    \
  X(sLshlB32, S_LSHL_B32_vi, S_LSHL_B32_gfx11)                                 \
  X(sLshrB32, S_LSHR_B32_vi, S_LSHR_B32_gfx11)                                 \
  X(sAndB32, S_AND_B32_vi, S_AND_B32_gfx11)                                    \
  X(sXorB32, S_XOR_B32_vi, S_XOR_B32_gfx11)                                    \
  X(sXorB64, S_XOR_B64_vi, S_XOR_B64_gfx11)                                    \
  X(sAndn2B32, S_ANDN2_B32_vi, S_ANDN2_B32_gfx11)                              \
  X(sAndn2B64, S_ANDN2_B64_vi, S_ANDN2_B64_gfx11)                              \
  X(sAndSaveexecB64, S_AND_SAVEEXEC_B64_vi, S_AND_SAVEEXEC_B64_gfx11)          \
  X(sMovB64, S_MOV_B64_vi, S_MOV_B64_gfx11)                                    \
  X(sAddU32, S_ADD_U32_vi, S_ADD_U32_gfx11)                                    \
  X(sAddcU32, S_ADDC_U32_vi, S_ADDC_U32_gfx11)                                 \
  X(sMulHiU32, S_MUL_HI_U32_vi, S_MUL_HI_U32_gfx11)                            \
  X(sCmpLtI32, S_CMP_LT_I32_vi, S_CMP_LT_I32_gfx11)                            \
  X(sCmpLgU32, S_CMP_LG_U32_vi, S_CMP_LG_U32_gfx11)                            \
  X(sCselectB32, S_CSELECT_B32_vi, S_CSELECT_B32_gfx11)                        \
  X(sBranch, S_BRANCH_vi, S_BRANCH_gfx11)                                      \
  X(sCbranchScc0, S_CBRANCH_SCC0_vi, S_CBRANCH_SCC0_gfx11)                     \
  X(sCbranchScc1, S_CBRANCH_SCC1_vi, S_CBRANCH_SCC1_gfx11)                     \
  X(sCbranchExecz, S_CBRANCH_EXECZ_vi, S_CBRANCH_EXECZ_gfx11)                  \
  X(sLoadB32, S_LOAD_DWORD_IMM_vi, S_LOAD_B32_IMM_gfx11)                       \
  X(sLoadB64, S_LOAD_DWORDX2_IMM_vi, S_LOAD_B64_IMM_gfx11)                     \
  X(sLoadB128, S_LOAD_DWORDX4_IMM_vi, S_LOAD_B128_IMM_gfx11)                   \
  X(sLoadB256, S_LOAD_DWORDX8_IMM_vi, S_LOAD_B256_IMM_gfx11)                   \
  X(sWaitcnt, S_WAITCNT_vi, S_WAITCNT_gfx11)                                   \
  X(sNop, S_NOP_vi, S_NOP_gfx11)                                               \
  X(sSetprio, S_SETPRIO_vi, S_SETPRIO_gfx11)                                   \
  X(sBarrier, S_BARRIER_vi, S_BARRIER_gfx11)                                   \
  X(sEndpgm, S_ENDPGM_vi, S_ENDPGM_gfx11)                                      \
  X(sSetpcB64, S_SETPC_B64_vi, S_SETPC_B64_gfx11)                              \
  X(vMbcntLo, V_MBCNT_LO_U32_B32_e64_vi, V_MBCNT_LO_U32_B32_e64_gfx11)         \
  X(vMbcntHi, V_MBCNT_HI_U32_B32_e64_vi, V_MBCNT_HI_U32_B32_e64_gfx11)         \
  X(vMovB32, V_MOV_B32_e32_vi, V_MOV_B32_e32_gfx11)                            \
  X(vAndB32, V_AND_B32_e32_vi, V_AND_B32_e32_gfx11)                            \
  X(vOrB32, V_OR_B32_e32_vi, V_OR_B32_e32_gfx11)                               \
  X(vXorB32, V_XOR_B32_e32_vi, V_XOR_B32_e32_gfx11)                            \
  X(vLshlrevB32, V_LSHLREV_B32_e32_vi, V_LSHLREV_B32_e32_gfx11)                \
  X(vLshrrevB32, V_LSHRREV_B32_e32_vi, V_LSHRREV_B32_e32_gfx11)                \
  X(vReadfirstlaneB32, V_READFIRSTLANE_B32_vi, V_READFIRSTLANE_B32_gfx11)      \
  X(vMulLoU32, V_MUL_LO_U32_vi, V_MUL_LO_U32_e64_gfx11)                        \
  X(vAdd3U32, V_ADD3_U32_vi, V_ADD3_U32_e64_gfx11)                             \
  X(vMadI32I24, V_MAD_I32_I24_vi, V_MAD_I32_I24_e64_gfx11)                     \
  X(vMadU32U24, V_MAD_U32_U24_vi, V_MAD_U32_U24_e64_gfx11)                     \
  X(vLshlAddU32, V_LSHL_ADD_U32_vi, V_LSHL_ADD_U32_e64_gfx11)                  \
  X(vAddLshlU32, V_ADD_LSHL_U32_vi, V_ADD_LSHL_U32_e64_gfx11)                  \
  X(vAndOrB32, V_AND_OR_B32_vi, V_AND_OR_B32_e64_gfx11)                        \
  X(vOr3B32, V_OR3_B32_vi, V_OR3_B32_e64_gfx11)                                \
  X(vXadU32, V_XAD_U32_vi, V_XAD_U32_e64_gfx11)                                \
  X(vAddF32, V_ADD_F32_e32_vi, V_ADD_F32_e32_gfx11)                            \
  X(vSubF32, V_SUB_F32_e32_vi, V_SUB_F32_e32_gfx11)                            \
  X(vMulF32, V_MUL_F32_e32_vi, V_MUL_F32_e32_gfx11)                            \
  X(vMaxF32, V_MAX_F32_e32_vi, V_MAX_F32_e32_gfx11)                            \
  X(vExpF32, V_EXP_F32_e32_vi, V_EXP_F32_e32_gfx11)                            \
  X(vRcpF32, V_RCP_F32_e32_vi, V_RCP_F32_e32_gfx11)                            \
  X(vCmpEqU32, V_CMP_EQ_U32_e64_vi, V_CMP_EQ_U32_e64_gfx11)                    \
  X(vCmpNeU32, V_CMP_NE_U32_e64_vi, V_CMP_NE_U32_e64_gfx11)                    \
  X(vCmpLtU32, V_CMP_LT_U32_e64_vi, V_CMP_LT_U32_e64_gfx11)                    \
  X(vCmpLeU32, V_CMP_LE_U32_e64_vi, V_CMP_LE_U32_e64_gfx11)                    \
  X(vCmpGtU32, V_CMP_GT_U32_e64_vi, V_CMP_GT_U32_e64_gfx11)                    \
  X(vCmpGeU32, V_CMP_GE_U32_e64_vi, V_CMP_GE_U32_e64_gfx11)                    \
  X(vCmpxEqU32, V_CMPX_EQ_U32_e64_vi, V_CMPX_EQ_U32_e64_gfx11)                 \
  X(vCmpxNeU32, V_CMPX_NE_U32_e64_vi, V_CMPX_NE_U32_e64_gfx11)                 \
  X(vCmpxLtU32, V_CMPX_LT_U32_e64_vi, V_CMPX_LT_U32_e64_gfx11)                 \
  X(vCmpxLeU32, V_CMPX_LE_U32_e64_vi, V_CMPX_LE_U32_e64_gfx11)                 \
  X(vCmpxGtU32, V_CMPX_GT_U32_e64_vi, V_CMPX_GT_U32_e64_gfx11)                 \
  X(vCmpxGeU32, V_CMPX_GE_U32_e64_vi, V_CMPX_GE_U32_e64_gfx11)                 \
  X(bufferStoreB32, BUFFER_STORE_DWORD_OFFEN_vi,                               \
    BUFFER_STORE_DWORD_OFFEN_gfx11)                                            \
  X(bufferLoadB32, BUFFER_LOAD_DWORD_OFFEN_vi, BUFFER_LOAD_DWORD_OFFEN_gfx11)  \
  X(globalStoreB32, GLOBAL_STORE_DWORD_SADDR_vi,                               \
    GLOBAL_STORE_DWORD_SADDR_gfx11)                                            \
  X(globalLoadB32, GLOBAL_LOAD_DWORD_SADDR_vi, GLOBAL_LOAD_DWORD_SADDR_gfx11)  \
  X(globalLoadB64, GLOBAL_LOAD_DWORDX2_SADDR_vi,                               \
    GLOBAL_LOAD_DWORDX2_SADDR_gfx11)                                           \
  X(globalLoadB96, GLOBAL_LOAD_DWORDX3_SADDR_vi,                               \
    GLOBAL_LOAD_DWORDX3_SADDR_gfx11)                                           \
  X(globalLoadB128, GLOBAL_LOAD_DWORDX4_SADDR_vi,                              \
    GLOBAL_LOAD_DWORDX4_SADDR_gfx11)                                           \
  X(globalStoreB64, GLOBAL_STORE_DWORDX2_SADDR_vi,                             \
    GLOBAL_STORE_DWORDX2_SADDR_gfx11)                                          \
  X(globalStoreB96, GLOBAL_STORE_DWORDX3_SADDR_vi,                             \
    GLOBAL_STORE_DWORDX3_SADDR_gfx11)                                          \
  X(globalStoreB128, GLOBAL_STORE_DWORDX4_SADDR_vi,                            \
    GLOBAL_STORE_DWORDX4_SADDR_gfx11)                                          \
  X(bufferLoadB64, BUFFER_LOAD_DWORDX2_OFFEN_vi,                               \
    BUFFER_LOAD_DWORDX2_OFFEN_gfx11)                                           \
  X(bufferLoadB96, BUFFER_LOAD_DWORDX3_OFFEN_vi,                               \
    BUFFER_LOAD_DWORDX3_OFFEN_gfx11)                                           \
  X(bufferLoadB128, BUFFER_LOAD_DWORDX4_OFFEN_vi,                              \
    BUFFER_LOAD_DWORDX4_OFFEN_gfx11)                                           \
  X(bufferStoreB64, BUFFER_STORE_DWORDX2_OFFEN_vi,                             \
    BUFFER_STORE_DWORDX2_OFFEN_gfx11)                                          \
  X(bufferStoreB96, BUFFER_STORE_DWORDX3_OFFEN_vi,                             \
    BUFFER_STORE_DWORDX3_OFFEN_gfx11)                                          \
  X(bufferStoreB128, BUFFER_STORE_DWORDX4_OFFEN_vi,                            \
    BUFFER_STORE_DWORDX4_OFFEN_gfx11)                                          \
  X(dsReadB64, DS_READ_B64_vi_gfx9, DS_READ_B64_gfx11)                         \
  X(dsReadB96, DS_READ_B96_vi_gfx9, DS_READ_B96_gfx11)                         \
  X(dsReadB128, DS_READ_B128_vi_gfx9, DS_READ_B128_gfx11)                      \
  X(dsWriteB64, DS_WRITE_B64_vi_gfx9, DS_WRITE_B64_gfx11)                      \
  X(dsWriteB96, DS_WRITE_B96_vi_gfx9, DS_WRITE_B96_gfx11)                      \
  X(dsWriteB128, DS_WRITE_B128_vi_gfx9, DS_WRITE_B128_gfx11)                   \
  X(bufferLoadLdsB32, BUFFER_LOAD_DWORD_LDS_OFFEN_vi,                          \
    BUFFER_LOAD_DWORD_LDS_OFFEN_gfx10)                                         \
  X(dsReadB32, DS_READ_B32_vi_gfx9, DS_READ_B32_gfx11)                         \
  X(dsSwizzleB32, DS_SWIZZLE_B32_vi, DS_SWIZZLE_B32_gfx11)                     \
  X(dsPermuteB32, DS_PERMUTE_B32_vi, DS_PERMUTE_B32_gfx11)                     \
  X(dsBpermuteB32, DS_BPERMUTE_B32_vi, DS_BPERMUTE_B32_gfx11)                  \
  X(dsWriteB32, DS_WRITE_B32_vi_gfx9, DS_WRITE_B32_gfx11)

struct AMDGPUOpcodeSet {
#define WAVE_AMDGPU_OPCODE_FIELD(name, viOpcode, gfx11Opcode) unsigned name = 0;
  WAVE_AMDGPU_OPCODE_LIST(WAVE_AMDGPU_OPCODE_FIELD)
#undef WAVE_AMDGPU_OPCODE_FIELD
};

static AMDGPUOpcodeSet
makeAMDGPUOpcodeSet(const llvm::AMDGPU::IsaVersion &isa) {
  assert(isSupportedBackendIsa(isa) && "unsupported backend ISA");
  bool useVIEncoding = isa.Major == 8 || isa.Major == 9;
  AMDGPUOpcodeSet opcodes;
#define WAVE_AMDGPU_OPCODE_INIT(name, viOpcode, gfx11Opcode)                   \
  opcodes.name =                                                               \
      useVIEncoding ? llvm::AMDGPU::viOpcode : llvm::AMDGPU::gfx11Opcode;
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
  AMDGPUOpcodeSet opcodes;
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
    opcodes = makeAMDGPUOpcodeSet(isaVersion);
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
  unsigned gfx11Opcode(unsigned opcode) const {
    if (!isGfx11())
      llvm_unreachable("backend target gate admits only gfx8/gfx9/gfx11");
    return opcode;
  }

  unsigned sMovB32() const { return opcodes.sMovB32; }
  unsigned sAddI32() const { return opcodes.sAddI32; }
  unsigned sMulI32() const { return opcodes.sMulI32; }
  unsigned sLshlB32() const { return opcodes.sLshlB32; }
  unsigned sLshrB32() const { return opcodes.sLshrB32; }
  unsigned sAndB32() const { return opcodes.sAndB32; }
  unsigned sXorB32() const { return opcodes.sXorB32; }
  unsigned sXorB64() const { return opcodes.sXorB64; }
  unsigned sAndn2B32() const { return opcodes.sAndn2B32; }
  unsigned sAndn2B64() const { return opcodes.sAndn2B64; }
  unsigned sAndSaveexecB64() const { return opcodes.sAndSaveexecB64; }
  unsigned sMovB64() const { return opcodes.sMovB64; }
  unsigned sAddU32() const { return opcodes.sAddU32; }
  unsigned sAddcU32() const { return opcodes.sAddcU32; }
  unsigned sMulHiU32() const { return opcodes.sMulHiU32; }
  unsigned sCmpLtI32() const { return opcodes.sCmpLtI32; }
  unsigned sCmpLgU32() const { return opcodes.sCmpLgU32; }
  unsigned sCselectB32() const { return opcodes.sCselectB32; }
  unsigned sBranch() const { return opcodes.sBranch; }
  unsigned sCbranchScc0() const { return opcodes.sCbranchScc0; }
  unsigned sCbranchScc1() const { return opcodes.sCbranchScc1; }
  unsigned sCbranchExecz() const { return opcodes.sCbranchExecz; }
  unsigned sLoadB32() const { return opcodes.sLoadB32; }
  unsigned sLoadB64() const { return opcodes.sLoadB64; }
  unsigned sLoadB128() const { return opcodes.sLoadB128; }
  unsigned sLoadB256() const { return opcodes.sLoadB256; }
  unsigned sWaitcnt() const { return opcodes.sWaitcnt; }
  unsigned sNop() const { return opcodes.sNop; }
  unsigned sSetprio() const { return opcodes.sSetprio; }
  unsigned sBarrier() const { return opcodes.sBarrier; }
  unsigned sEndpgm() const { return opcodes.sEndpgm; }
  unsigned sSetpcB64() const { return opcodes.sSetpcB64; }
  unsigned vMbcntLo() const { return opcodes.vMbcntLo; }
  unsigned vMbcntHi() const { return opcodes.vMbcntHi; }
  unsigned vMovB32() const { return opcodes.vMovB32; }
  unsigned vAndB32() const { return opcodes.vAndB32; }
  unsigned vOrB32() const { return opcodes.vOrB32; }
  unsigned vXorB32() const { return opcodes.vXorB32; }
  unsigned vLshlrevB32() const { return opcodes.vLshlrevB32; }
  unsigned vLshrrevB32() const { return opcodes.vLshrrevB32; }
  unsigned vReadfirstlaneB32() const { return opcodes.vReadfirstlaneB32; }
  unsigned vMulLoU32() const { return opcodes.vMulLoU32; }
  unsigned vAdd3U32() const { return opcodes.vAdd3U32; }
  unsigned vMadI32I24() const { return opcodes.vMadI32I24; }
  unsigned vMadU32U24() const { return opcodes.vMadU32U24; }
  unsigned vLshlAddU32() const { return opcodes.vLshlAddU32; }
  unsigned vAddLshlU32() const { return opcodes.vAddLshlU32; }
  unsigned vAndOrB32() const { return opcodes.vAndOrB32; }
  unsigned vOr3B32() const { return opcodes.vOr3B32; }
  unsigned vXadU32() const { return opcodes.vXadU32; }
  unsigned vAddF32() const { return opcodes.vAddF32; }
  unsigned vSubF32() const { return opcodes.vSubF32; }
  unsigned vMulF32() const { return opcodes.vMulF32; }
  unsigned vMaxF32() const { return opcodes.vMaxF32; }
  unsigned vExpF32() const { return opcodes.vExpF32; }
  unsigned vRcpF32() const { return opcodes.vRcpF32; }
  unsigned vCvtF16F32() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_CVT_F16_F32_e64_vi;
    return gfx11Opcode(llvm::AMDGPU::V_CVT_F16_F32V_CVT_F16_F32_t16_e64_gfx11);
  }
  unsigned vCvtF32F16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_CVT_F32_F16_e64_vi;
    return gfx11Opcode(llvm::AMDGPU::V_CVT_F32_F16V_CVT_F32_F16_t16_e64_gfx11);
  }
  bool usesTrue16Cvt() const { return isGfx11(); }
  bool supportsCvtPkRtzF16F32() const { return isGfx11(); }
  bool supportsPackedF16() const {
    return isaVersion.Major == 9 || isaVersion.Major == 11;
  }
  unsigned vCvtPkRtzF16F32() const {
    return gfx11Opcode(llvm::AMDGPU::V_CVT_PK_RTZ_F16_F32_e32_gfx11);
  }
  unsigned vPkAddF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_ADD_F16_vi;
    return gfx11Opcode(llvm::AMDGPU::V_PK_ADD_F16_gfx11);
  }
  unsigned vPkMulF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_MUL_F16_vi;
    return gfx11Opcode(llvm::AMDGPU::V_PK_MUL_F16_gfx11);
  }
  unsigned vPkFmaF16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::V_PK_FMA_F16_vi;
    return gfx11Opcode(llvm::AMDGPU::V_PK_FMA_F16_gfx11);
  }
  unsigned vCmpEqU32() const { return opcodes.vCmpEqU32; }
  unsigned vCmpNeU32() const { return opcodes.vCmpNeU32; }
  unsigned vCmpLtU32() const { return opcodes.vCmpLtU32; }
  unsigned vCmpLeU32() const { return opcodes.vCmpLeU32; }
  unsigned vCmpGtU32() const { return opcodes.vCmpGtU32; }
  unsigned vCmpGeU32() const { return opcodes.vCmpGeU32; }
  unsigned vCmpxEqU32() const { return opcodes.vCmpxEqU32; }
  unsigned vCmpxNeU32() const { return opcodes.vCmpxNeU32; }
  unsigned vCmpxLtU32() const { return opcodes.vCmpxLtU32; }
  unsigned vCmpxLeU32() const { return opcodes.vCmpxLeU32; }
  unsigned vCmpxGtU32() const { return opcodes.vCmpxGtU32; }
  unsigned vCmpxGeU32() const { return opcodes.vCmpxGeU32; }
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
    return opcodes.bufferStoreB32;
  }

  unsigned bufferStoreB16() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_vi;
    return gfx11Opcode(llvm::AMDGPU::BUFFER_STORE_SHORT_OFFEN_gfx11);
  }

  unsigned bufferLoadB32() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_DWORD_OFFEN_gfx90a;
    return opcodes.bufferLoadB32;
  }

  unsigned bufferLoadB16() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_gfx90a;
    if (isGfx8Or9())
      return llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_vi;
    return gfx11Opcode(llvm::AMDGPU::BUFFER_LOAD_USHORT_OFFEN_gfx11);
  }

  unsigned globalStoreB32() const { return opcodes.globalStoreB32; }

  unsigned globalStoreB32Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_DWORD_vi;
    return gfx11Opcode(llvm::AMDGPU::GLOBAL_STORE_DWORD_gfx11);
  }

  unsigned globalStoreB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR_vi;
    return gfx11Opcode(llvm::AMDGPU::GLOBAL_STORE_SHORT_SADDR_gfx11);
  }

  unsigned globalStoreB16Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_STORE_SHORT_vi;
    return gfx11Opcode(llvm::AMDGPU::GLOBAL_STORE_SHORT_gfx11);
  }

  unsigned globalLoadB32() const { return opcodes.globalLoadB32; }

  unsigned globalLoadB32Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_DWORD_vi;
    return gfx11Opcode(llvm::AMDGPU::GLOBAL_LOAD_DWORD_gfx11);
  }

  unsigned globalLoadB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR_vi;
    return gfx11Opcode(llvm::AMDGPU::GLOBAL_LOAD_USHORT_SADDR_gfx11);
  }

  unsigned globalLoadB16Addr64() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::GLOBAL_LOAD_USHORT_vi;
    return gfx11Opcode(llvm::AMDGPU::GLOBAL_LOAD_USHORT_gfx11);
  }

  unsigned globalLoadB64() const { return opcodes.globalLoadB64; }
  unsigned globalLoadB96() const { return opcodes.globalLoadB96; }
  unsigned globalLoadB128() const { return opcodes.globalLoadB128; }
  unsigned globalStoreB64() const { return opcodes.globalStoreB64; }
  unsigned globalStoreB96() const { return opcodes.globalStoreB96; }
  unsigned globalStoreB128() const { return opcodes.globalStoreB128; }
  unsigned bufferLoadB64() const { return opcodes.bufferLoadB64; }
  unsigned bufferLoadB96() const { return opcodes.bufferLoadB96; }
  unsigned bufferLoadB128() const { return opcodes.bufferLoadB128; }
  unsigned bufferStoreB64() const { return opcodes.bufferStoreB64; }
  unsigned bufferStoreB96() const { return opcodes.bufferStoreB96; }
  unsigned bufferStoreB128() const { return opcodes.bufferStoreB128; }
  unsigned dsReadB64() const { return opcodes.dsReadB64; }
  unsigned dsReadB96() const { return opcodes.dsReadB96; }
  unsigned dsReadB128() const { return opcodes.dsReadB128; }
  unsigned dsWriteB64() const { return opcodes.dsWriteB64; }
  unsigned dsWriteB96() const { return opcodes.dsWriteB96; }
  unsigned dsWriteB128() const { return opcodes.dsWriteB128; }

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
  unsigned dsSwizzleB32() const { return opcodes.dsSwizzleB32; }
  unsigned dsPermuteB32() const { return opcodes.dsPermuteB32; }
  unsigned dsBpermuteB32() const { return opcodes.dsBpermuteB32; }

  unsigned dsReadB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::DS_READ_U16_vi_gfx9;
    return gfx11Opcode(llvm::AMDGPU::DS_READ_U16_gfx11);
  }

  unsigned dsWriteB32() const { return opcodes.dsWriteB32; }

  unsigned dsWriteB16() const {
    if (isGfx8Or9())
      return llvm::AMDGPU::DS_WRITE_B16_vi_gfx9;
    return gfx11Opcode(llvm::AMDGPU::DS_WRITE_B16_gfx11);
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
    funcLabelPrefix = (".L" + Twine(func.getSymName())).str();

    os << "\n\t.globl\t" << func.getSymName() << "\n";
    os << "\t.p2align\t8\n";
    os << "\t.type\t" << func.getSymName() << ",@function\n";
    os << func.getSymName() << ":\n";
    if (emitPreloadCompatProlog) {
      std::string realEntryLabel = funcLabelPrefix + ".kernarg_preload_entry";
      if (failed(emitKernargPreloadCompatProlog(entryRegs, realEntryLabel)))
        return failure();
      os << "\t.p2align\t8\n";
      os << realEntryLabel << ":\n";
    }
    emitLine(
        StringRef("; wave backend: WaveAMDMachine MLIR pipeline finalized"));

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
    if (isKernel) {
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
      if (failed(emitKernelDescriptor(func)))
        return failure();
      kernels.push_back(info);
    }
    return success();
  }

  unsigned getKernelArgSize(func::FuncOp func) const {
    if (auto attr =
            func->getAttrOfType<IntegerAttr>("waveamdmachine.kernarg_size"))
      return attr.getInt();
    return waveamd::getKernargSegmentSize(func.getFunctionType().getInputs());
  }

  LogicalResult
  verifyKernelDescriptor(func::FuncOp func,
                         const wave::WaveAMDKernelEntryRegs &entryRegs) const {
    unsigned maxUserSGPRs = llvm::AMDGPU::getMaxNumUserSGPRs(*sti);
    if (entryRegs.userSGPRCount > maxUserSGPRs)
      return func.emitError("wave-to-amdgpu-asm kernarg preload consumes ")
             << entryRegs.userSGPRCount << " user SGPRs, but target supports "
             << maxUserSGPRs;
    if (entryRegs.kernargPreloadDwords != 0 &&
        entryRegs.kernargPreloadOffsetDwords >= 512)
      return func.emitError("wave-to-amdgpu-asm kernarg preload offset must be "
                            "less than 512 dwords");
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
      if (failed(emitMC(opcode, {llvm::MCOperand::createReg(
                                     mcSGPRReg(preloadSGPR, width)),
                                 llvm::MCOperand::createReg(kernargPtr),
                                 llvm::MCOperand::createImm(offsetDwords * 4),
                                 llvm::MCOperand::createImm(0)})))
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
    unsigned sgprCount = getIntAttr(func, "waveamdmachine.sgpr_count", 6);
    unsigned vgprCount = getIntAttr(func, "waveamdmachine.vgpr_count", 1);
    unsigned ldsSize = getIntAttr(func, "waveamdmachine.lds_size", 0);
    bool usesWgY = false;
    bool usesWgZ = false;
    wave::WaveAMDKernelEntryRegs entryRegs =
        wave::getWaveAMDKernelEntryRegs(func);
    func.walk([&](Operation *op) {
      if (isa<waveamdmachine::SWorkgroupIdYOp>(op))
        usesWgY = true;
      if (isa<waveamdmachine::SWorkgroupIdZOp>(op))
        usesWgZ = true;
    });
    if (failed(verifyKernelDescriptor(func, entryRegs)))
      return failure();

    os << "\t.section\t.rodata,\"a\",@progbits\n";
    os << "\t.p2align\t6, 0x0\n";
    os << "\t.amdhsa_kernel " << func.getSymName() << "\n";
    os << "\t\t.amdhsa_group_segment_fixed_size " << ldsSize << "\n";
    os << "\t\t.amdhsa_private_segment_fixed_size 0\n";
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
    return success();
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
    if (name == "exec")
      return llvm::AMDGPU::EXEC;
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

  LogicalResult emitTernaryInt(unsigned opcode, Operation &op) {
    return emitMC(
        opcode, {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                 toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2))});
  }

  LogicalResult emitTernaryIntClamp(unsigned opcode, Operation &op) {
    return emitMC(opcode,
                  {toMCOperand(op.getResult(0)), toMCOperand(op.getOperand(0)),
                   toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
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

  LogicalResult emitBufferLoadLds(Operation &op, unsigned opcode) {
    if (std::optional<unsigned> imm = getImmediate(op.getOperand(2)))
      if (*imm != 0)
        return op.emitError(
            "buffer_load_lds nonzero literal soffset must be SGPR");
    int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
    int64_t aux = getIntAttr(&op, "aux", 0);
    return emitMC(opcode,
                  {toMCOperand(op.getOperand(0)), toMCOperand(op.getOperand(1)),
                   toMCOperand(op.getOperand(2)),
                   llvm::MCOperand::createImm(instOffset),
                   llvm::MCOperand::createImm(aux)});
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

    if (op.hasTrait<OpTrait::waveamdmachine::NoAsmEmission>())
      return success();
    if (isa<waveamdmachine::LabelOp>(op)) {
      os << op.getAttrOfType<StringAttr>("name").str() << ":\n";
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
    // hwreg(HW_REG_SHADER_CYCLES=29, offset=0, size=32) packed as
    // id | (offset << 6) | ((size - 1) << 11) = 0xF81D. Gated on
    // gfx11 by archPredicate; emitter assumes the dispatcher already
    // honoured isSupportedOnIsa.
    if (isa<waveamdmachine::SGetregShaderCyclesOp>(op))
      return emitMC(
          llvm::AMDGPU::S_GETREG_B32_gfx11,
          {toMCOperand(result()), llvm::MCOperand::createImm(0xF81D)});
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
      // swap into src0; if both sides are non-VGPR we'd need a VOP3 form.
      // Wave selection emits these with a VGPR on one side.
      if (!isVGPR(rhs))
        std::swap(lhs, rhs);
      unsigned opcode = isa<waveamdmachine::VAndB32Op>(op)  ? vAndB32()
                        : isa<waveamdmachine::VOrB32Op>(op) ? vOrB32()
                                                            : vXorB32();
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
    if (isa<waveamdmachine::VMadI32I24Op, waveamdmachine::VMadU32U24Op>(op)) {
      unsigned opcode =
          isa<waveamdmachine::VMadI32I24Op>(op) ? vMadI32I24() : vMadU32U24();
      return emitTernaryIntClamp(opcode, op);
    }
    if (isa<waveamdmachine::VAdd3U32Op, waveamdmachine::VLshlAddU32Op,
            waveamdmachine::VAddLshlU32Op, waveamdmachine::VAndOrB32Op,
            waveamdmachine::VOr3B32Op, waveamdmachine::VXadU32Op>(op)) {
      unsigned opcode = isa<waveamdmachine::VAdd3U32Op>(op)      ? vAdd3U32()
                        : isa<waveamdmachine::VLshlAddU32Op>(op) ? vLshlAddU32()
                        : isa<waveamdmachine::VAddLshlU32Op>(op) ? vAddLshlU32()
                        : isa<waveamdmachine::VAndOrB32Op>(op)   ? vAndOrB32()
                        : isa<waveamdmachine::VOr3B32Op>(op)     ? vOr3B32()
                                                                 : vXadU32();
      return emitTernaryInt(opcode, op);
    }
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
        return op.emitError("v_cvt_pk_rtz_f16_f32 requires gfx11");
      return emitMC(vCvtPkRtzF16F32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
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
    if (isa<waveamdmachine::VCmpxEqU32Op, waveamdmachine::VCmpxNeU32Op,
            waveamdmachine::VCmpxLtU32Op, waveamdmachine::VCmpxLeU32Op,
            waveamdmachine::VCmpxGtU32Op, waveamdmachine::VCmpxGeU32Op>(op)) {
      unsigned opcode = isa<waveamdmachine::VCmpxEqU32Op>(op)   ? vCmpxEqU32()
                        : isa<waveamdmachine::VCmpxNeU32Op>(op) ? vCmpxNeU32()
                        : isa<waveamdmachine::VCmpxLtU32Op>(op) ? vCmpxLtU32()
                        : isa<waveamdmachine::VCmpxLeU32Op>(op) ? vCmpxLeU32()
                        : isa<waveamdmachine::VCmpxGtU32Op>(op) ? vCmpxGtU32()
                                                                : vCmpxGeU32();
      llvm::MCOperand exec = llvm::MCOperand::createReg(
          namedPhysReg(wavefrontSize == 32 ? "exec_lo" : "exec"));
      return emitMC(opcode, {exec, toMCOperand(op.getOperand(0)),
                             toMCOperand(op.getOperand(1))});
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
      auto resultType = cast<waveamdmachine::RegType>(result().getType());
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
      if (wavefrontSize != 32)
        return op.emitError("s_mov_vcc_b32 supports wave32 only");
      return emitMC(sMovB32(),
                    {llvm::MCOperand::createReg(namedPhysReg("vcc_lo")),
                     toMCOperand(op.getOperand(0))});
    }
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
      return emitBufferLoadLds(op, bufferLoadLdsB32());
    }
    if (isa<waveamdmachine::BufferLoadLdsB128Op>(op)) {
      return emitBufferLoadLds(op, bufferLoadLdsB128());
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
    if (isa<waveamdmachine::DsSwizzleB32Op>(op))
      return emitDsLoad(op, dsSwizzleB32());
    if (isa<waveamdmachine::DsPermuteB32Op>(op))
      return emitDsPermute(op, dsPermuteB32());
    if (isa<waveamdmachine::DsBpermuteB32Op>(op))
      return emitDsPermute(op, dsBpermuteB32());
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
