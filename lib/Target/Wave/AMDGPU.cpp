//===- AMDGPU.cpp - WaveMachine to AMDGPU backend -------------------------===//
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
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Target/LLVM/ROCDL/Utils.h"
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

static bool isWM(Operation *op) {
  return op->getName().getDialectNamespace() ==
         wavemachine::WaveMachineDialect::getDialectNamespace();
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

    auto targetAttr = module->getAttrOfType<StringAttr>("wavemachine.target");
    if (targetAttr) {
      std::pair<StringRef, StringRef> split =
          targetAttr.getValue().rsplit("--");
      if (split.second.empty())
        targetChip = targetAttr.getValue().str();
      else {
        targetTriple = split.first.str();
        targetChip = split.second.str();
      }
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
    if (isaVersion.Major == 0)
      return module.emitError("unsupported AMDGPU target: ")
             << targetTriple << "--" << targetChip;
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
  unsigned vAddU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_ADD_CO_U32_e32_gfx9
                       : llvm::AMDGPU::V_ADD_NC_U32_e32_gfx11;
  }
  unsigned vMulLoU32() const {
    return isGfx8Or9() ? llvm::AMDGPU::V_MUL_LO_U32_vi
                       : llvm::AMDGPU::V_MUL_LO_U32_e64_gfx11;
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

  unsigned bufferLoadB32() const {
    if (isGfx90APlus())
      return llvm::AMDGPU::BUFFER_LOAD_DWORD_OFFEN_gfx90a;
    return isGfx8Or9() ? llvm::AMDGPU::BUFFER_LOAD_DWORD_OFFEN_vi
                       : llvm::AMDGPU::BUFFER_LOAD_DWORD_OFFEN_gfx11;
  }

  unsigned globalStoreB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_STORE_DWORD_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_STORE_DWORD_SADDR_gfx11;
  }

  unsigned globalLoadB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::GLOBAL_LOAD_DWORD_SADDR_vi
                       : llvm::AMDGPU::GLOBAL_LOAD_DWORD_SADDR_gfx11;
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

  unsigned dsWriteB32() const {
    return isGfx8Or9() ? llvm::AMDGPU::DS_WRITE_B32_vi_gfx9
                       : llvm::AMDGPU::DS_WRITE_B32_gfx11;
  }

  std::optional<unsigned> getImmediate(Value value) const {
    if (auto imm = value.getDefiningOp<wavemachine::ImmOp>())
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

  bool isBufferPointer(Type type) const {
    auto ptr = dyn_cast<wave::PtrType>(type);
    return ptr && isa<waveamd::BufferAddressSpaceAttr>(ptr.getAddressSpace());
  }

  unsigned kernelArgSize(Type type) const {
    auto ptr = dyn_cast<wave::PtrType>(type);
    if (!ptr)
      return 4;
    return isBufferPointer(type) ? 16 : 8;
  }

  LogicalResult emitFunction(func::FuncOp func) {
    if (!func.getBody().hasOneBlock())
      return func.emitError(
          "WaveMachine AMDGPU emitter supports one-block funcs");

    os << "\n\t.globl\t" << func.getSymName() << "\n";
    os << "\t.p2align\t8\n";
    os << "\t.type\t" << func.getSymName() << ",@function\n";
    os << func.getSymName() << ":\n";
    emitLine(StringRef("; wave backend: WaveMachine MLIR pipeline finalized"));

    loopCounter = 0;
    funcLabelPrefix = (".L" + Twine(func.getSymName())).str();

    for (Operation &op : func.getBody().front()) {
      if (isa<func::ReturnOp>(op))
        continue;
      if (!isWM(&op))
        return op.emitError("unexpected non-WaveMachine operation in emitter");
      if (failed(emitOperation(op)))
        return failure();
    }

    os << "\t.size\t" << func.getSymName() << ", .-" << func.getSymName()
       << "\n";
    if (func->hasAttr("wave.kernel")) {
      KernelInfo info;
      info.name = func.getSymName().str();
      info.kernargSize = getKernelArgSize(func);
      info.sgprCount = getIntAttr(func, "wavemachine.sgpr_count", 6);
      info.vgprCount = getIntAttr(func, "wavemachine.vgpr_count", 1);
      info.ldsSize = getIntAttr(func, "wavemachine.lds_size", 0);
      unsigned offset = 0;
      for (auto [index, arg] : llvm::enumerate(func.getArguments())) {
        bool isBuffer = isa<wave::PtrType>(arg.getType());
        unsigned size = kernelArgSize(arg.getType());
        info.args.push_back(
            KernelArgInfo{("arg" + Twine(index)).str(), offset, size,
                          isBuffer && !isBufferPointer(arg.getType())});
        offset += size;
      }
      kernels.push_back(info);
      emitKernelDescriptor(func);
    }
    return success();
  }

  unsigned getKernelArgSize(func::FuncOp func) const {
    if (auto attr =
            func->getAttrOfType<IntegerAttr>("wavemachine.kernarg_size"))
      return attr.getInt();
    unsigned size = 0;
    for (BlockArgument arg : func.getArguments())
      size += kernelArgSize(arg.getType());
    return (std::max(size, 4u) + 7u) & ~7u;
  }

  void emitKernelDescriptor(func::FuncOp func) {
    unsigned kernargSize = getKernelArgSize(func);
    unsigned sgprCount = getIntAttr(func, "wavemachine.sgpr_count", 6);
    unsigned vgprCount = getIntAttr(func, "wavemachine.vgpr_count", 1);
    unsigned ldsSize = getIntAttr(func, "wavemachine.lds_size", 0);
    bool usesWgY = false;
    bool usesWgZ = false;
    func.walk([&](Operation *op) {
      if (isa<wavemachine::SWorkgroupIdYOp>(op))
        usesWgY = true;
      if (isa<wavemachine::SWorkgroupIdZOp>(op))
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
    if (!isGfx8Or9()) {
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
      os << "  - .args:\n";
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
      os << "    .wavefront_size: " << (targetChip == "gfx950" ? 64 : 32)
         << "\n";
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
    auto regType = cast<wavemachine::RegType>(value.getType());
    if (regType.getIndex() >= 0)
      return regType.getIndex();
    llvm_unreachable("expected allocated WaveMachine register");
  }

  std::string physReg(Value value) const {
    auto regType = cast<wavemachine::RegType>(value.getType());
    unsigned phys = getPhys(value);
    StringRef prefix =
        regType.getRegClass() == wavemachine::RegClass::VGPR ? "v" : "s";
    if (regType.getWidth() == 1)
      return (prefix + Twine(phys)).str();
    return (prefix + Twine("[") + Twine(phys) + ":" +
            Twine(phys + regType.getWidth() - 1) + "]")
        .str();
  }

  std::string operandToString(Value value) const {
    if (Operation *def = value.getDefiningOp())
      if (isa<wavemachine::ImmOp>(def))
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
    auto regType = cast<wavemachine::RegType>(value.getType());
    unsigned phys = getPhys(value);
    if (regType.getRegClass() == wavemachine::RegClass::VGPR)
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
    auto regType = cast<wavemachine::RegType>(value.getType());
    if (regType.getRegClass() != wavemachine::RegClass::VGPR ||
        component >= regType.getWidth())
      llvm_unreachable("expected valid VGPR tuple component");
    return llvm::MCOperand::createReg(mcVGPRReg(getPhys(value) + component, 1));
  }

  llvm::MCOperand toMCSGPRComponent(Value value, unsigned component) const {
    auto regType = cast<wavemachine::RegType>(value.getType());
    if (regType.getRegClass() != wavemachine::RegClass::SGPR ||
        component >= regType.getWidth())
      llvm_unreachable("expected valid SGPR tuple component");
    return llvm::MCOperand::createReg(llvm::AMDGPU::SGPR0 + getPhys(value) +
                                      component);
  }

  llvm::MCOperand toMCOperand(Value value) {
    if (Operation *def = value.getDefiningOp())
      if (isa<wavemachine::ImmOp>(def))
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

  LogicalResult emitVAddU32(llvm::MCOperand dst, llvm::MCOperand lhs,
                            llvm::MCOperand rhs) {
    return emitMC(vAddU32(), {dst, lhs, rhs});
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
    auto regType = dyn_cast<wavemachine::RegType>(value.getType());
    return regType && regType.getRegClass() == wavemachine::RegClass::SGPR;
  }

  bool isVGPR(Value value) const {
    auto regType = dyn_cast<wavemachine::RegType>(value.getType());
    return regType && regType.getRegClass() == wavemachine::RegClass::VGPR;
  }

  LogicalResult emitUniformLoop(wavemachine::UniformLoopOp loop) {
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
    auto term = cast<wavemachine::ContinueIfOp>(body.getTerminator());
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

    if (isa<wavemachine::ImmOp, wavemachine::ArgOp, wavemachine::TokenOp,
            wavemachine::TokenJoinOp, wavemachine::WaitOp>(&op))
      return success();
    // Preloaded values delivered by the HSA loader: the SSA value already
    // lives in its pinned register (s2/s3/s4 or v0) at kernel entry, so
    // there is nothing to emit here. The descriptor flips the matching
    // `.amdhsa_system_sgpr_workgroup_id_*` / `.amdhsa_system_vgpr_workitem_id`
    // bits to make the loader perform the preload.
    if (isa<wavemachine::SWorkgroupIdXOp, wavemachine::SWorkgroupIdYOp,
            wavemachine::SWorkgroupIdZOp, wavemachine::VWorkitemIdXOp>(&op))
      return success();
    if (isa<wavemachine::LabelOp>(op)) {
      os << op.getAttrOfType<StringAttr>("name").str() << ":\n";
      return success();
    }
    if (isa<wavemachine::VMbcntLoOp>(op))
      return emitMC(vMbcntLo(),
                    {toMCOperand(result()), llvm::MCOperand::createImm(-1),
                     llvm::MCOperand::createImm(0)});
    // Pure SSA renames: the regalloc has already aliased each element
    // to its slot of the tuple's physical block (`tuple_phys + i`), so
    // there is nothing to emit.
    if (isa<wavemachine::TupleToElementsOp>(op) ||
        isa<wavemachine::TupleFromElementsOp>(op))
      return success();
    if (isa<wavemachine::VMovB32TupleOp>(op)) {
      auto regType = cast<wavemachine::RegType>(result().getType());
      Value src = op.getOperand(0);
      auto srcType = dyn_cast<wavemachine::RegType>(src.getType());
      bool srcTuple = srcType &&
                      srcType.getRegClass() == wavemachine::RegClass::VGPR &&
                      srcType.getWidth() == regType.getWidth();
      for (unsigned i = 0, e = regType.getWidth(); i != e; ++i) {
        llvm::MCOperand srcOp =
            srcTuple ? toMCVGPRComponent(src, i) : toMCOperand(src);
        if (failed(emitMC(vMovB32(), {toMCVGPRComponent(result(), i), srcOp})))
          return failure();
      }
      return success();
    }
    if (isa<wavemachine::WmmaI32_16x16x16_IU8Op>(op))
      return emitMC(
          llvm::AMDGPU::V_WMMA_I32_16X16X16_IU8_twoaddr_w32_gfx11,
          {toMCOperand(result()), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0)});
    if (isa<wavemachine::WmmaF32_16x16x16_F16Op>(op))
      return emitMC(
          llvm::AMDGPU::V_WMMA_F32_16X16X16_F16_twoaddr_w32_gfx11,
          {toMCOperand(result()), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(1)), llvm::MCOperand::createImm(0),
           toMCOperand(op.getOperand(2)), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    if (isa<wavemachine::MfmaF32_16x16x16_F16Op>(op)) {
      if (!isGfx90APlus())
        return op.emitError("mfma.f32.16x16x16.f16 requires gfx90a+");
      return emitMC(
          mfmaF32_16x16x16F16(),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<wavemachine::MfmaF32_16x16x32_F16Op>(op)) {
      if (targetChip != "gfx950")
        return op.emitError("mfma.f32.16x16x32.f16 requires gfx950");
      return emitMC(
          mfmaF32_16x16x32F16(),
          {toMCOperand(result()), toMCOperand(op.getOperand(0)),
           toMCOperand(op.getOperand(1)), toMCOperand(op.getOperand(2)),
           llvm::MCOperand::createImm(0), llvm::MCOperand::createImm(0),
           llvm::MCOperand::createImm(0)});
    }
    if (isa<wavemachine::VAddU32Op>(op)) {
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      if (isSGPR(rhs))
        std::swap(lhs, rhs);
      return emitVAddU32(toMCOperand(result()), toMCOperand(lhs),
                         toMCOperand(rhs));
    }
    if (isa<wavemachine::VAndB32Op, wavemachine::VOrB32Op,
            wavemachine::VXorB32Op>(op)) {
      Value lhs = op.getOperand(0);
      Value rhs = op.getOperand(1);
      // VOP2 e32: src1 must be a VGPR. Both SGPR and imm RHS need to
      // swap into src0; if both sides are non-VGPR we'd need a VOP3
      // form, but the bucketizer only emits these with a VGPR on one
      // side so the swap suffices.
      if (!isVGPR(rhs))
        std::swap(lhs, rhs);
      unsigned opcode =
          isa<wavemachine::VAndB32Op>(op)  ? llvm::AMDGPU::V_AND_B32_e32_gfx11
          : isa<wavemachine::VOrB32Op>(op) ? llvm::AMDGPU::V_OR_B32_e32_gfx11
                                           : llvm::AMDGPU::V_XOR_B32_e32_gfx11;
      return emitMC(
          opcode, {toMCOperand(result()), toMCOperand(lhs), toMCOperand(rhs)});
    }
    if (isa<wavemachine::VLshlrevB32Op>(op))
      return emitMC(vLshlrevB32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(0))});
    if (isa<wavemachine::VLshrrevB32Op>(op))
      return emitMC(vLshrrevB32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(0))});
    if (isa<wavemachine::VMulLoU32Op>(op))
      // v_mul_lo_u32 is VOP3-only on RDNA3; operand placement is
      // unconstrained so we emit (vdst, src0, src1) as-is without the
      // VOP2 swap dance.
      return emitVMulLoU32(op, result(), op.getOperand(0), op.getOperand(1));
    if (isa<wavemachine::VCmpEqU32Op, wavemachine::VCmpNeU32Op,
            wavemachine::VCmpLtU32Op, wavemachine::VCmpLeU32Op,
            wavemachine::VCmpGtU32Op, wavemachine::VCmpGeU32Op>(op)) {
      unsigned opcode = isa<wavemachine::VCmpEqU32Op>(op)   ? vCmpEqU32()
                        : isa<wavemachine::VCmpNeU32Op>(op) ? vCmpNeU32()
                        : isa<wavemachine::VCmpLtU32Op>(op) ? vCmpLtU32()
                        : isa<wavemachine::VCmpLeU32Op>(op) ? vCmpLeU32()
                        : isa<wavemachine::VCmpGtU32Op>(op) ? vCmpGtU32()
                                                            : vCmpGeU32();
      llvm::MCOperand dst =
          isGfx8Or9() ? llvm::MCOperand::createReg(namedPhysReg("vcc"))
                      : toMCOperand(result());
      if (failed(emitMC(opcode, {dst, toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))})))
        return failure();
      if (!isGfx8Or9())
        return success();
      return emitMC(sMovB32(),
                    {toMCOperand(result()),
                     llvm::MCOperand::createReg(namedPhysReg("vcc_lo"))});
    }
    if (isa<wavemachine::SMovB32Op>(op)) {
      StringRef dst = op.getAttrOfType<StringAttr>("dst").getValue();
      std::string src = operandString(0);
      if (dst != src)
        return emitMC(sMovB32(), {llvm::MCOperand::createReg(namedPhysReg(dst)),
                                  toMCOperand(op.getOperand(0))});
      return success();
    }
    if (isa<wavemachine::SMovB32ValueOp>(op)) {
      // Coalescing in the regalloc may have folded source==dest;
      // skip in that case to avoid a `s_mov_b32 sX, sX`.
      Value src = op.getOperand(0);
      if (auto srcRt = dyn_cast<wavemachine::RegType>(src.getType())) {
        if (srcRt.getRegClass() == wavemachine::RegClass::SGPR &&
            srcRt.getIndex() == getPhys(op.getResult(0)))
          return success();
      }
      return emitMC(sMovB32(),
                    {toMCOperand(op.getResult(0)), toMCOperand(src)});
    }
    if (isa<wavemachine::SAddI32Op>(op))
      return emitMC(sAddI32(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (isa<wavemachine::SMulI32Op>(op))
      return emitMC(sMulI32(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (isa<wavemachine::SLshlB32Op>(op))
      return emitMC(sLshlB32(), {toMCOperand(op.getResult(0)),
                                 toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))});
    if (isa<wavemachine::SLshrB32Op>(op))
      return emitMC(sLshrB32(), {toMCOperand(op.getResult(0)),
                                 toMCOperand(op.getOperand(0)),
                                 toMCOperand(op.getOperand(1))});
    if (isa<wavemachine::SAndB32Op>(op))
      return emitMC(sAndB32(), {toMCOperand(op.getResult(0)),
                                toMCOperand(op.getOperand(0)),
                                toMCOperand(op.getOperand(1))});
    if (isa<wavemachine::SAddU64Op>(op)) {
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
    if (isa<wavemachine::VAddU64Op>(op)) {
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
    if (isa<wavemachine::SMulU64Op>(op)) {
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
    if (isa<wavemachine::VMulU64Op>(op)) {
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
                             toMCVGPRComponent(res, 1),
                             toMCOperand(scratch))) ||
          failed(emitMC(llvm::AMDGPU::V_MUL_LO_U32_e64_gfx11,
                        {toMCOperand(scratch), toMCVGPRComponent(lhs, 1),
                         toMCVGPRComponent(rhs, 0)})))
        return failure();
      return emitVAddU32(toMCVGPRComponent(res, 1), toMCVGPRComponent(res, 1),
                         toMCOperand(scratch));
    }
    if (isa<wavemachine::SLshlB64Op>(op))
      // Hardware reads only the low 32 bits of the shift amount; pass
      // the low component of the 2-wide shift operand.
      return emitMC(llvm::AMDGPU::S_LSHL_B64_gfx11,
                    {toMCOperand(op.getResult(0)),
                     toMCOperand(op.getOperand(0)),
                     toMCSGPRComponent(op.getOperand(1), 0)});
    if (isa<wavemachine::VLshlrevB64Op>(op))
      return emitMC(llvm::AMDGPU::V_LSHLREV_B64_e64_gfx11,
                    {toMCOperand(op.getResult(0)),
                     toMCVGPRComponent(op.getOperand(0), 0),
                     toMCOperand(op.getOperand(1))});
    if (isa<wavemachine::SMovB64ImmOp>(op)) {
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
    if (isa<wavemachine::SCmpLtI32Op>(op))
      return emitMC(sCmpLtI32(), {toMCOperand(op.getOperand(0)),
                                  toMCOperand(op.getOperand(1))});
    if (isa<wavemachine::SCmpLgU32Op>(op))
      return emitMC(sCmpLgU32(), {toMCOperand(op.getOperand(0)),
                                  toMCOperand(op.getOperand(1))});
    if (isa<wavemachine::SCBranchScc0Op>(op))
      return emitMC(sCbranchScc0(),
                    {labelOperand(op.getAttrOfType<StringAttr>("label"))});
    if (isa<wavemachine::SCBranchScc1Op>(op))
      return emitMC(sCbranchScc1(),
                    {labelOperand(op.getAttrOfType<StringAttr>("label"))});
    if (auto loop = dyn_cast<wavemachine::UniformLoopOp>(op))
      return emitUniformLoop(loop);
    if (isa<wavemachine::ContinueIfOp>(op))
      // continue_if is consumed by emitUniformLoop; reaching it
      // here would mean the loop op didn't recurse properly.
      return op.emitError(
          "wavemachine.continue_if escaped its parent uniform_loop");
    if (isa<wavemachine::SLoadB32Op>(op))
      return emitMC(
          sLoadB32(),
          {toMCOperand(result()),
           llvm::MCOperand::createReg(
               namedPhysReg(op.getAttrOfType<StringAttr>("base").getValue())),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0)});
    if (isa<wavemachine::SLoadB64Op>(op))
      return emitMC(
          sLoadB64(),
          {toMCOperand(result()),
           llvm::MCOperand::createReg(
               namedPhysReg(op.getAttrOfType<StringAttr>("base").getValue())),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0)});
    if (isa<wavemachine::SLoadB128Op>(op))
      return emitMC(
          sLoadB128(),
          {toMCOperand(result()),
           llvm::MCOperand::createReg(
               namedPhysReg(op.getAttrOfType<StringAttr>("base").getValue())),
           toMCOperand(op.getOperand(0)), llvm::MCOperand::createImm(0)});
    if (isa<wavemachine::SWaitcntOp>(op))
      return emitMCValues(sWaitcnt(), op.getOperands());
    if (isa<wavemachine::SWaitcntVscntOp>(op)) {
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
    if (isa<wavemachine::SNopOp>(op))
      return emitMCValues(sNop(), op.getOperands());
    if (isa<wavemachine::SDelayAluOp>(op)) {
      if (isGfx8Or9())
        return success();
      return emitMCValues(llvm::AMDGPU::S_DELAY_ALU_gfx11, op.getOperands());
    }
    if (isa<wavemachine::SAndSaveexecB32Op>(op)) {
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
    if (isa<wavemachine::SAndn2ExecB32Op>(op)) {
      return emitMC(sAndn2B32(),
                    {llvm::MCOperand::createReg(namedPhysReg("exec_lo")),
                     toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1))});
    }
    if (isa<wavemachine::SCBranchExeczOp>(op))
      return emitMC(sCbranchExecz(),
                    {labelOperand(op.getAttrOfType<StringAttr>("label"))});
    if (isa<wavemachine::SMovExecLoOp>(op)) {
      return emitMC(sMovB32(),
                    {llvm::MCOperand::createReg(namedPhysReg("exec_lo")),
                     toMCOperand(op.getOperand(0))});
    }
    if (isa<wavemachine::SMovM0Op>(op))
      return emitMC(sMovB32(), {llvm::MCOperand::createReg(namedPhysReg("m0")),
                                toMCOperand(op.getOperand(0))});
    if (isa<wavemachine::VReadfirstlaneB32Op>(op))
      return emitMC(vReadfirstlaneB32(),
                    {toMCOperand(result()), toMCOperand(op.getOperand(0))});
    if (isa<wavemachine::GlobalStoreB32Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      return emitMC(globalStoreB32(), {toMCOperand(op.getOperand(0)),
                                       toMCOperand(op.getOperand(1)),
                                       toMCOperand(op.getOperand(2)),
                                       llvm::MCOperand::createImm(instOffset),
                                       llvm::MCOperand::createImm(0)});
    }
    // GLOBAL_LOAD_DWORD_SADDR encodes its MC operands as
    //   vdst, saddr, vaddr, offset, cpol
    // -- the SADDR variants put the SGPR base first, unlike the *non*-SADDR
    // store variants we use elsewhere.
    if (isa<wavemachine::GlobalLoadB32Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      return emitMC(globalLoadB32(), {toMCOperand(op.getResult(0)),
                                      toMCOperand(op.getOperand(1)),
                                      toMCOperand(op.getOperand(0)),
                                      llvm::MCOperand::createImm(instOffset),
                                      llvm::MCOperand::createImm(0)});
    }
    if (isa<wavemachine::GlobalLoadTupleB32Op>(op)) {
      auto regType = cast<wavemachine::RegType>(op.getResult(0).getType());
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      for (unsigned i = 0, e = regType.getWidth(); i != e; ++i)
        if (failed(emitMC(globalLoadB32(),
                          {toMCVGPRComponent(op.getResult(0), i),
                           toMCOperand(op.getOperand(1)),
                           toMCOperand(op.getOperand(0)),
                           llvm::MCOperand::createImm(instOffset + i * 4),
                           llvm::MCOperand::createImm(0)})))
          return failure();
      return success();
    }
    if (isa<wavemachine::MakeBufferRsrcOp>(op)) {
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
    // Our IR layout (wavemachine):
    //   STORE: offset(VGPR1), value(VGPR1), descriptor(SGPR4),
    //          soffset(SGPR1OrImm), [dep], inst_offset attr
    //   LOAD : offset(VGPR1), descriptor(SGPR4),
    //          soffset(SGPR1OrImm), [dep], inst_offset attr
    if (isa<wavemachine::BufferStoreB32Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      return emitMC(bufferStoreB32(), {toMCOperand(op.getOperand(1)),
                                       toMCOperand(op.getOperand(0)),
                                       toMCOperand(op.getOperand(2)),
                                       toMCOperand(op.getOperand(3)),
                                       llvm::MCOperand::createImm(instOffset),
                                       llvm::MCOperand::createImm(0)});
    }
    if (isa<wavemachine::BufferLoadB32Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      return emitMC(bufferLoadB32(), {toMCOperand(op.getResult(0)),
                                      toMCOperand(op.getOperand(0)),
                                      toMCOperand(op.getOperand(1)),
                                      toMCOperand(op.getOperand(2)),
                                      llvm::MCOperand::createImm(instOffset),
                                      llvm::MCOperand::createImm(0)});
    }
    if (isa<wavemachine::GlobalLoadLdsB32Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitMC(globalLoadLdsB32(), {toMCOperand(op.getOperand(1)),
                                         toMCOperand(op.getOperand(0)),
                                         llvm::MCOperand::createImm(instOffset),
                                         llvm::MCOperand::createImm(aux)});
    }
    if (isa<wavemachine::GlobalLoadLdsB128Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitMC(globalLoadLdsB128(),
                    {toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(0)),
                     llvm::MCOperand::createImm(instOffset),
                     llvm::MCOperand::createImm(aux)});
    }
    if (isa<wavemachine::BufferLoadLdsB32Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitMC(bufferLoadLdsB32(), {toMCOperand(op.getOperand(0)),
                                         toMCOperand(op.getOperand(1)),
                                         toMCOperand(op.getOperand(2)),
                                         llvm::MCOperand::createImm(instOffset),
                                         llvm::MCOperand::createImm(aux)});
    }
    if (isa<wavemachine::BufferLoadLdsB128Op>(op)) {
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      int64_t aux = getIntAttr(&op, "aux", 0);
      return emitMC(bufferLoadLdsB128(),
                    {toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1)),
                     toMCOperand(op.getOperand(2)),
                     llvm::MCOperand::createImm(instOffset),
                     llvm::MCOperand::createImm(aux)});
    }
    // Tuple buffer loads expand into N consecutive `buffer_load_dword`
    // instructions sharing the same vaddr / descriptor / soffset, with
    // the per-component byte offset folded into the
    // `offset:(inst_offset + i*4)` immediate.
    if (isa<wavemachine::BufferLoadTupleB32Op>(op)) {
      auto regType = cast<wavemachine::RegType>(op.getResult(0).getType());
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      for (unsigned i = 0, e = regType.getWidth(); i != e; ++i)
        if (failed(emitMC(bufferLoadB32(),
                          {toMCVGPRComponent(op.getResult(0), i),
                           toMCOperand(op.getOperand(0)),
                           toMCOperand(op.getOperand(1)),
                           toMCOperand(op.getOperand(2)),
                           llvm::MCOperand::createImm(instOffset + i * 4),
                           llvm::MCOperand::createImm(0)})))
          return failure();
      return success();
    }
    if (isa<wavemachine::GlobalStoreTupleB32Op>(op)) {
      unsigned component = getIntAttr(&op, "component", 0);
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      return emitMC(globalStoreB32(),
                    {toMCOperand(op.getOperand(0)),
                     toMCVGPRComponent(op.getOperand(1), component),
                     toMCOperand(op.getOperand(2)),
                     llvm::MCOperand::createImm(instOffset + component * 4),
                     llvm::MCOperand::createImm(0)});
    }
    if (isa<wavemachine::BufferStoreTupleB32Op>(op)) {
      // Mirror BufferStoreB32 in MUBUF OFFEN form: vdata, vaddr,
      // srsrc, soffset, offset:(inst_offset + component*4), cpol.
      // vdata is the selected dword of the VGPR tuple.
      unsigned component = getIntAttr(&op, "component", 0);
      int64_t instOffset = getIntAttr(&op, "inst_offset", 0);
      return emitMC(bufferStoreB32(),
                    {toMCVGPRComponent(op.getOperand(1), component),
                     toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(2)),
                     toMCOperand(op.getOperand(3)),
                     llvm::MCOperand::createImm(instOffset + component * 4),
                     llvm::MCOperand::createImm(0)});
    }
    if (isa<wavemachine::DsLoadB32Op>(op))
      return emitMC(dsReadB32(),
                    {toMCOperand(op.getResult(0)),
                     toMCOperand(op.getOperand(0)),
                     llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                     llvm::MCOperand::createImm(0)});
    if (isa<wavemachine::DsLoadTupleB32Op>(op)) {
      auto regType = cast<wavemachine::RegType>(op.getResult(0).getType());
      int64_t baseOffset = getIntAttr(&op, "offset", 0);
      for (unsigned i = 0, e = regType.getWidth(); i != e; ++i)
        if (failed(emitMC(dsReadB32(),
                          {toMCVGPRComponent(op.getResult(0), i),
                           toMCOperand(op.getOperand(0)),
                           llvm::MCOperand::createImm(baseOffset + i * 4),
                           llvm::MCOperand::createImm(0)})))
          return failure();
      return success();
    }
    if (isa<wavemachine::DsStoreB32Op>(op))
      return emitMC(dsWriteB32(),
                    {toMCOperand(op.getOperand(0)),
                     toMCOperand(op.getOperand(1)),
                     llvm::MCOperand::createImm(getIntAttr(&op, "offset", 0)),
                     llvm::MCOperand::createImm(0)});
    if (isa<wavemachine::DsStoreTupleB32Op>(op)) {
      auto regType = cast<wavemachine::RegType>(op.getOperand(1).getType());
      int64_t baseOffset = getIntAttr(&op, "offset", 0);
      for (unsigned i = 0, e = regType.getWidth(); i != e; ++i)
        if (failed(emitMC(dsWriteB32(),
                          {toMCOperand(op.getOperand(0)),
                           toMCVGPRComponent(op.getOperand(1), i),
                           llvm::MCOperand::createImm(baseOffset + i * 4),
                           llvm::MCOperand::createImm(0)})))
          return failure();
      return success();
    }
    if (isa<wavemachine::SBarrierOp>(op))
      return emitMC(sBarrier(), {});
    if (isa<wavemachine::SEndpgmOp>(op))
      return emitMC(sEndpgm(), {llvm::MCOperand::createImm(0)});
    if (isa<wavemachine::SSetpcB64Op>(op)) {
      return emitMC(sSetpcB64(),
                    {llvm::MCOperand::createReg(namedPhysReg("s[30:31]"))});
    }

    return op.emitError("unsupported WaveMachine opcode: ") << name;
  }
};

static LogicalResult runWaveMachinePipeline(ModuleOp module) {
  Builder builder(module.getContext());
  if (!module->hasAttr("wavemachine.target"))
    module->setAttr(
        "wavemachine.target",
        builder.getStringAttr(
            (Twine(kDefaultTargetTriple) + "--" + kDefaultTargetChip).str()));
  PassManager pm(module.getContext());
  pm.addPass(wave::createConvertWaveAMDToWaveMachine());
  pm.addPass(wave::createWaveAMDABILowering());
  pm.addPass(wave::createWaveAMDTicketWaits());
  pm.addPass(wave::createWaveAMDHazardWaits());
  pm.addPass(wave::createWaveAMDRegAlloc());
  pm.addPass(wave::createWaveAMDResourceInfo());
  pm.addPass(wave::createWaveAMDMetadata());
  return pm.run(module);
}

} // namespace

LogicalResult mlir::wave::translateWaveToAMDGPU(Operation *op,
                                                raw_ostream &os) {
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    return op->emitError("wave AMDGPU backend expects a module operation");
  if (failed(runWaveMachinePipeline(module)))
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

LogicalResult mlir::wave::compileWaveToHSACO(Operation *op, StringRef triple,
                                             StringRef chip, StringRef features,
                                             SmallVectorImpl<char> &out) {
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    return op->emitError("compileWaveToHSACO expects a module operation");

  SmallString<8192> isaStorage;
  llvm::raw_svector_ostream isaOS(isaStorage);
  if (failed(translateWaveToAMDGPU(module, isaOS)))
    return failure();

  auto errCallback = [&] { return op->emitError(); };
  FailureOr<SmallVector<char, 0>> elf =
      ROCDL::assembleIsa(StringRef(isaStorage.data(), isaStorage.size()),
                         triple, chip, features, errCallback);
  if (failed(elf))
    return failure();

  return linkElfToHsacoInProcess(op, *elf, out);
}
