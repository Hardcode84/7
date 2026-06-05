//===- wavec.cpp - Wave C driver ----------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

extern "C" {
#include "arena.h"
#include "astdump.h"
#include "diag.h"
#include "lex.h"
#include "lower.h"
#include "parse.h"
#include "sema.h"
}

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/InitAllDialects.h"
#include "mlir/Parser/Parser.h"
#include "mlir/Target/Wave/AMDGPU.h"

#include "llvm/ADT/SmallString.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>
#include <string>

using namespace mlir;

namespace {

constexpr size_t kArenaBytes = 8u * 1024u * 1024u;

enum class EmitKind { Ast, Wave, Asm, Hsaco };
enum class ParseStatus { Ok, Help, Error };

struct DriverOptions {
  std::string inputFile;
  std::string outputFile = "-";
  std::string targetAttr;
  std::string offloadArch;
  std::string targetFeatures;
  std::string pipelineFile;
  EmitKind emitKind = EmitKind::Wave;
  bool emitKindSet = false;
};

struct ArenaOwner {
  Arena arena;

  ArenaOwner() : arena(arena_create(kArenaBytes)) {}
  ArenaOwner(const ArenaOwner &) = delete;
  ArenaOwner &operator=(const ArenaOwner &) = delete;
  ~ArenaOwner() { arena_destroy(&arena); }

  bool valid() const { return arena.raw != nullptr; }
};

struct FrontendResult {
  ArenaOwner arena;
  DiagList diags;
  Program *program = nullptr;
  std::string waveIR;
};

static const char *severityLabel(DiagSeverity severity) {
  switch (severity) {
  case DIAG_ERROR:
    return "error";
  case DIAG_WARNING:
    return "warning";
  case DIAG_NOTE:
    return "note";
  }
  return "diag";
}

static void printDiagnostics(llvm::StringRef path, const DiagList &diags) {
  for (const Diag *diag = diags.head; diag != nullptr; diag = diag->next) {
    llvm::errs() << path << ":" << diag->span.line << ":" << diag->span.col
                 << ": " << severityLabel(diag->severity) << ": "
                 << diag->message << "\n";
  }
}

static bool parseSource(FrontendResult &result, llvm::StringRef source) {
  LexContext lexCtx;
  lexCtx.src = source.data();
  lexCtx.src_len = source.size();
  lexCtx.arena = &result.arena.arena;
  lexCtx.diags = &result.diags;
  TokenArray toks = lex_tokenize(&lexCtx);

  ParseContext parseCtx;
  parse_context_init(&parseCtx, toks.tokens, toks.count, source.data(),
                     source.size(), &result.arena.arena, &result.diags);
  result.program = parse_program(&parseCtx);
  return result.program != nullptr && !diag_has_errors(&result.diags);
}

static bool checkSema(FrontendResult &result) {
  SemaContext semaCtx;
  sema_context_init(&semaCtx, &result.arena.arena, &result.diags);
  return sema_check(&semaCtx, result.program) &&
         !diag_has_errors(&result.diags);
}

static bool lowerToWaveIR(FrontendResult &result) {
  char *mlir = wavec_lower_to_mlir(result.program, &result.diags);
  if (mlir == nullptr)
    return false;
  result.waveIR = mlir;
  wavec_lower_free(mlir);
  return true;
}

static void printHelp(llvm::StringRef argv0) {
  llvm::outs()
      << "OVERVIEW: Wave C driver\n\n"
      << "USAGE: " << argv0 << " [options] <source.wave>\n\n"
      << "OPTIONS:\n"
      << "  --emit=ast|wave|asm|hsaco  Select output kind (default: wave)\n"
      << "  --emit-ast                 Emit parsed AST\n"
      << "  -S                         Emit AMDGPU assembly\n"
      << "  -c                         Emit HSACO binary\n"
      << "  -o <file>                  Write output to <file> (default: "
         "stdout)\n"
      << "  --target <triple--chip>    Full AMDGPU target attr\n"
      << "  --offload-arch <chip>      AMDGPU chip, e.g. gfx1100\n"
      << "  --target-features <list>   Feature string for HSACO assembly\n"
      << "  --pipeline-file <file>     Wave backend transform pipeline\n"
      << "  -h, --help                 Show this help\n";
}

static std::string getBackendTargetAttr(const DriverOptions &options) {
  if (!options.targetAttr.empty())
    return options.targetAttr;
  if (!options.offloadArch.empty())
    return (llvm::Twine("amdgcn-amd-amdhsa--") + options.offloadArch).str();
  return {};
}

static bool setEmitKind(DriverOptions &options, EmitKind kind) {
  if (options.emitKindSet) {
    llvm::errs() << "wavec: choose only one output mode\n";
    return false;
  }
  options.emitKind = kind;
  options.emitKindSet = true;
  return true;
}

static bool parseEmitKind(llvm::StringRef value, EmitKind &kind) {
  if (value == "ast")
    kind = EmitKind::Ast;
  else if (value == "wave")
    kind = EmitKind::Wave;
  else if (value == "asm")
    kind = EmitKind::Asm;
  else if (value == "hsaco")
    kind = EmitKind::Hsaco;
  else
    return false;
  return true;
}

static bool takeJoinedOrSeparate(int argc, char **argv, int &index,
                                 llvm::StringRef arg, llvm::StringRef name,
                                 std::string &value) {
  if (arg.consume_front((name + "=").str())) {
    value = arg.str();
    return true;
  }
  if (arg == name && index + 1 < argc) {
    value = argv[++index];
    return true;
  }
  llvm::errs() << "wavec: " << name << " expects a value\n";
  return false;
}

static bool matchesValuedOption(llvm::StringRef arg, llvm::StringRef name) {
  std::string joined = (name + "=").str();
  return arg == name || arg.starts_with(joined);
}

static bool parseEmitOption(DriverOptions &options, llvm::StringRef value) {
  EmitKind kind;
  if (!parseEmitKind(value, kind)) {
    llvm::errs() << "wavec: unknown emit kind `" << value << "`\n";
    return false;
  }
  return setEmitKind(options, kind);
}

static bool parseModeFlag(DriverOptions &options, llvm::StringRef arg,
                          bool &handled) {
  handled = true;
  if (arg == "--emit-ast")
    return setEmitKind(options, EmitKind::Ast);
  if (arg == "-S")
    return setEmitKind(options, EmitKind::Asm);
  if (arg == "-c")
    return setEmitKind(options, EmitKind::Hsaco);
  handled = false;
  return true;
}

static bool parseOutputOption(DriverOptions &options, int argc, char **argv,
                              int &index, llvm::StringRef arg, bool &handled) {
  handled = arg == "-o" || (arg.starts_with("-o") && arg.size() > 2);
  if (!handled)
    return true;
  if (arg.size() > 2) {
    options.outputFile = arg.drop_front(2).str();
    return true;
  }
  return takeJoinedOrSeparate(argc, argv, index, arg, "-o", options.outputFile);
}

static bool parseValuedLongOption(DriverOptions &options, int argc, char **argv,
                                  int &index, llvm::StringRef arg,
                                  bool &handled) {
  handled = true;
  std::string value;
  if (matchesValuedOption(arg, "--emit"))
    return takeJoinedOrSeparate(argc, argv, index, arg, "--emit", value) &&
           parseEmitOption(options, value);
  if (matchesValuedOption(arg, "--target"))
    return takeJoinedOrSeparate(argc, argv, index, arg, "--target",
                                options.targetAttr);
  if (matchesValuedOption(arg, "--offload-arch"))
    return takeJoinedOrSeparate(argc, argv, index, arg, "--offload-arch",
                                options.offloadArch);
  if (matchesValuedOption(arg, "--target-features"))
    return takeJoinedOrSeparate(argc, argv, index, arg, "--target-features",
                                options.targetFeatures);
  if (matchesValuedOption(arg, "--pipeline-file"))
    return takeJoinedOrSeparate(argc, argv, index, arg, "--pipeline-file",
                                options.pipelineFile);
  handled = false;
  return true;
}

static bool parseInput(DriverOptions &options, llvm::StringRef arg) {
  if (!options.inputFile.empty()) {
    llvm::errs() << "wavec: multiple input files are not supported\n";
    return false;
  }
  options.inputFile = arg.str();
  return true;
}

static ParseStatus finishArgs(const DriverOptions &options) {
  if (options.inputFile.empty()) {
    llvm::errs() << "wavec: missing input file\n";
    return ParseStatus::Error;
  }
  if (!options.targetAttr.empty() && !options.offloadArch.empty()) {
    llvm::errs() << "wavec: use either --target or --offload-arch, not both\n";
    return ParseStatus::Error;
  }
  return ParseStatus::Ok;
}

static ParseStatus parseOptionOrInput(DriverOptions &options, int argc,
                                      char **argv, int &index,
                                      llvm::StringRef arg) {
  bool handled = false;
  if (!parseModeFlag(options, arg, handled))
    return ParseStatus::Error;
  if (handled)
    return ParseStatus::Ok;
  if (!parseOutputOption(options, argc, argv, index, arg, handled))
    return ParseStatus::Error;
  if (handled)
    return ParseStatus::Ok;
  if (!parseValuedLongOption(options, argc, argv, index, arg, handled))
    return ParseStatus::Error;
  if (handled)
    return ParseStatus::Ok;
  if (arg.starts_with("-") && arg != "-") {
    llvm::errs() << "wavec: unknown option `" << arg << "`\n";
    return ParseStatus::Error;
  }
  return parseInput(options, arg) ? ParseStatus::Ok : ParseStatus::Error;
}

static ParseStatus parseArgs(int argc, char **argv, DriverOptions &options) {
  for (int i = 1; i < argc; ++i) {
    llvm::StringRef arg(argv[i]);
    if (arg == "-h" || arg == "--help") {
      printHelp(argv[0]);
      return ParseStatus::Help;
    }

    ParseStatus status = parseOptionOrInput(options, argc, argv, i, arg);
    if (status != ParseStatus::Ok)
      return status;
  }
  return finishArgs(options);
}

static bool writeOutput(const DriverOptions &options, llvm::StringRef bytes,
                        bool binary) {
  if (options.outputFile == "-") {
    llvm::outs().write(bytes.data(), bytes.size());
    return !llvm::outs().has_error();
  }

  std::error_code ec;
  llvm::raw_fd_ostream os(options.outputFile, ec,
                          binary ? llvm::sys::fs::OF_None
                                 : llvm::sys::fs::OF_Text);
  if (ec) {
    llvm::errs() << "wavec: cannot open output `" << options.outputFile
                 << "`: " << ec.message() << "\n";
    return false;
  }
  os.write(bytes.data(), bytes.size());
  return !os.has_error();
}

static bool emitAstOutput(FrontendResult &result,
                          const DriverOptions &options) {
  AstDumpOptions dumpOptions;
  dumpOptions.include_types = 0;
  dumpOptions.indent_width = 2;
  const char *dump =
      astdump_program(&result.arena.arena, result.program, &dumpOptions);
  if (dump == nullptr) {
    llvm::errs() << "wavec: failed to allocate AST dump\n";
    return false;
  }
  return writeOutput(options, dump, /*binary=*/false);
}

static void registerWaveDialects(DialectRegistry &registry) {
  registerAllDialects(registry);
  registry.insert<arith::ArithDialect, func::FuncDialect, ub::UBDialect,
                  wave::WaveDialect, waveamd::WaveAMDDialect,
                  wavemeta::WaveMetaDialect,
                  waveamdmachine::WaveAMDMachineDialect>();
}

static OwningOpRef<ModuleOp> parseWaveModule(llvm::StringRef waveIR,
                                             MLIRContext &context,
                                             llvm::SourceMgr &sourceMgr) {
  sourceMgr.AddNewSourceBuffer(
      llvm::MemoryBuffer::getMemBufferCopy(waveIR, "<wavec-wave-ir>"),
      llvm::SMLoc());
  return parseSourceFile<ModuleOp>(sourceMgr, &context);
}

static void applyBackendTarget(ModuleOp module, const DriverOptions &options) {
  std::string target = getBackendTargetAttr(options);
  if (target.empty())
    return;
  Builder builder(module.getContext());
  module->setAttr("waveamdmachine.target", builder.getStringAttr(target));
}

static bool
withWaveModule(llvm::StringRef waveIR, const DriverOptions &options,
               llvm::function_ref<bool(ModuleOp, MLIRContext &)> callback) {
  DialectRegistry registry;
  registerWaveDialects(registry);
  MLIRContext context(registry);
  context.loadAllAvailableDialects();

  llvm::SourceMgr sourceMgr;
  SourceMgrDiagnosticHandler handler(sourceMgr, &context);
  OwningOpRef<ModuleOp> module = parseWaveModule(waveIR, context, sourceMgr);
  if (!module)
    return false;
  applyBackendTarget(*module, options);
  return callback(*module, context);
}

static bool emitWaveOutput(FrontendResult &result,
                           const DriverOptions &options) {
  if (options.targetAttr.empty() && options.offloadArch.empty())
    return writeOutput(options, result.waveIR, /*binary=*/false);

  return withWaveModule(
      result.waveIR, options, [&](ModuleOp module, MLIRContext &) {
        std::string text;
        llvm::raw_string_ostream os(text);
        module.print(os);
        os << "\n";
        return writeOutput(options, os.str(), /*binary=*/false);
      });
}

static bool emitAsmOutput(FrontendResult &result,
                          const DriverOptions &options) {
  return withWaveModule(
      result.waveIR, options, [&](ModuleOp module, MLIRContext &) {
        std::string text;
        llvm::raw_string_ostream os(text);
        if (failed(
                wave::translateWaveToAMDGPU(module, os, options.pipelineFile)))
          return false;
        return writeOutput(options, os.str(), /*binary=*/false);
      });
}

static bool emitHsacoOutput(FrontendResult &result,
                            const DriverOptions &options) {
  return withWaveModule(
      result.waveIR, options, [&](ModuleOp module, MLIRContext &) {
        llvm::raw_null_ostream nullOS;
        if (failed(wave::translateWaveToAMDGPU(module, nullOS,
                                               options.pipelineFile)))
          return false;

        FailureOr<waveamdmachine::AMDGPUTarget> target =
            waveamdmachine::getAMDGPUTarget(module, "wavec");
        if (failed(target))
          return false;

        SmallVector<char, 0> hsaco;
        if (failed(wave::assembleWaveAMDGPUKernels(
                module, target->triple, target->chip, options.targetFeatures,
                hsaco)))
          return false;
        return writeOutput(options, llvm::StringRef(hsaco.data(), hsaco.size()),
                           /*binary=*/true);
      });
}

static bool compileToOutput(FrontendResult &result,
                            const DriverOptions &options) {
  if (options.emitKind == EmitKind::Ast)
    return emitAstOutput(result, options);
  if (!checkSema(result))
    return false;
  if (!lowerToWaveIR(result))
    return false;
  switch (options.emitKind) {
  case EmitKind::Ast:
    llvm_unreachable("handled above");
  case EmitKind::Wave:
    return emitWaveOutput(result, options);
  case EmitKind::Asm:
    return emitAsmOutput(result, options);
  case EmitKind::Hsaco:
    return emitHsacoOutput(result, options);
  }
  llvm_unreachable("unknown emit kind");
}

} // namespace

int main(int argc, char **argv) {
  llvm::InitLLVM init(argc, argv);

  DriverOptions options;
  ParseStatus parseStatus = parseArgs(argc, argv, options);
  if (parseStatus == ParseStatus::Help)
    return 0;
  if (parseStatus == ParseStatus::Error)
    return 1;

  llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> input =
      llvm::MemoryBuffer::getFileOrSTDIN(options.inputFile);
  if (!input) {
    llvm::errs() << "wavec: cannot read `" << options.inputFile
                 << "`: " << input.getError().message() << "\n";
    return 1;
  }

  FrontendResult result;
  if (!result.arena.valid()) {
    llvm::errs() << "wavec: failed to allocate frontend arena\n";
    return 1;
  }
  diag_list_init(&result.diags, &result.arena.arena);

  bool ok = parseSource(result, (*input)->getBuffer());
  if (ok)
    ok = compileToOutput(result, options);
  if (!ok) {
    llvm::StringRef name =
        options.inputFile == "-" ? "<stdin>" : options.inputFile;
    printDiagnostics(name, result.diags);
    return 1;
  }
  return 0;
}
