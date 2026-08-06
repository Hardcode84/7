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

#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/DiagnosticIDs.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "clang/Frontend/Utils.h"
#include "clang/Lex/PreprocessorOptions.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
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
#include "mlir/Parser/Parser.h"
#include "mlir/Target/Wave/AMDGPU.h"

#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/Host.h"

#include <memory>
#include <string>

using namespace mlir;

namespace {

constexpr size_t kArenaBytes = 8u * 1024u * 1024u;

enum class EmitKind { Preprocessed, Ast, Wave, Asm, Hsaco };
enum class ParseStatus { Ok, Help, Error };
enum class MacroActionKind { Define, Undefine };

struct MacroAction {
  std::string value;
  MacroActionKind kind;
};

struct DriverOptions {
  SmallVector<MacroAction, 4> macroActions;
  SmallVector<std::string, 4> includeDirs;
  SmallVector<std::string, 4> systemIncludeDirs;
  SmallVector<std::string, 4> forcedIncludes;
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

class CapturePreprocessedAction : public clang::PreprocessorFrontendAction {
public:
  explicit CapturePreprocessedAction(std::string &output) : output(output) {}

private:
  void ExecuteAction() override {
    clang::CompilerInstance &compiler = getCompilerInstance();
    llvm::raw_string_ostream os(output);
    clang::DoPrintPreprocessedInput(compiler.getPreprocessor(), &os,
                                    compiler.getPreprocessorOutputOpts());
  }

  std::string &output;
};

static void pushArg(SmallVectorImpl<std::string> &storage,
                    SmallVectorImpl<const char *> &args, llvm::Twine value) {
  storage.push_back(value.str());
  args.push_back(storage.back().c_str());
}

static unsigned countPreprocessorArgs(const DriverOptions &options) {
  return 9 +
         2 * (options.macroActions.size() + options.includeDirs.size() +
              options.systemIncludeDirs.size() + options.forcedIncludes.size());
}

static void appendPreprocessorArgs(const DriverOptions &options,
                                   llvm::StringRef mainFile,
                                   SmallVectorImpl<std::string> &storage,
                                   SmallVectorImpl<const char *> &args) {
  pushArg(storage, args, "-triple");
  pushArg(storage, args, llvm::sys::getDefaultTargetTriple());
  pushArg(storage, args, "-E");
  pushArg(storage, args, "-x");
  pushArg(storage, args, "c");
  pushArg(storage, args, "-std=c99");
  pushArg(storage, args, "-undef");
  pushArg(storage, args, "-P");
  for (const MacroAction &action : options.macroActions) {
    switch (action.kind) {
    case MacroActionKind::Define:
      pushArg(storage, args, "-D");
      break;
    case MacroActionKind::Undefine:
      pushArg(storage, args, "-U");
      break;
    }
    pushArg(storage, args, action.value);
  }
  for (llvm::StringRef dir : options.includeDirs) {
    pushArg(storage, args, "-I");
    pushArg(storage, args, dir);
  }
  for (llvm::StringRef dir : options.systemIncludeDirs) {
    pushArg(storage, args, "-isystem");
    pushArg(storage, args, dir);
  }
  for (llvm::StringRef include : options.forcedIncludes) {
    pushArg(storage, args, "-include");
    pushArg(storage, args, include);
  }
  pushArg(storage, args, mainFile);
}

static bool preprocessSource(const DriverOptions &options,
                             llvm::MemoryBufferRef input,
                             std::string &preprocessed) {
  std::string mainFile =
      options.inputFile == "-" ? "stdin.wave" : options.inputFile;
  SmallVector<std::string, 32> argStorage;
  argStorage.reserve(countPreprocessorArgs(options));
  SmallVector<const char *, 32> args;
  appendPreprocessorArgs(options, mainFile, argStorage, args);

  clang::DiagnosticOptions diagOptions;
  clang::TextDiagnosticPrinter invocationPrinter(llvm::errs(), diagOptions);
  llvm::IntrusiveRefCntPtr<clang::DiagnosticIDs> diagIDs(
      new clang::DiagnosticIDs());
  clang::DiagnosticsEngine diags(diagIDs, diagOptions, &invocationPrinter,
                                 /*ShouldOwnClient=*/false);

  std::shared_ptr<clang::CompilerInvocation> invocation =
      std::make_shared<clang::CompilerInvocation>();
  if (!clang::CompilerInvocation::CreateFromArgs(*invocation, args, diags,
                                                 "wavec"))
    return false;

  invocation->getPreprocessorOpts().UsePredefines = false;
  invocation->getPreprocessorOpts().DefineTargetOSMacros = false;
  invocation->getPreprocessorOutputOpts().ShowCPP = true;
  invocation->getPreprocessorOutputOpts().ShowLineMarkers = false;
  invocation->getPreprocessorOutputOpts().UseLineDirectives = false;

  std::unique_ptr<llvm::MemoryBuffer> remapped =
      llvm::MemoryBuffer::getMemBufferCopy(input.getBuffer(), mainFile);
  invocation->getPreprocessorOpts().addRemappedFile(mainFile,
                                                    remapped.release());

  clang::CompilerInstance compiler(invocation);
  compiler.createDiagnostics(
      new clang::TextDiagnosticPrinter(llvm::errs(), diagOptions),
      /*ShouldOwnClient=*/true);

  CapturePreprocessedAction action(preprocessed);
  bool ok = compiler.ExecuteAction(action);
  return ok && !compiler.getDiagnostics().hasErrorOccurred();
}

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
      << "  --emit=pp|ast|wave|asm|hsaco  Select output kind (default: wave)\n"
      << "  --emit-ast                 Emit parsed AST\n"
      << "  -E, --preprocess-only      Emit preprocessed Wave source\n"
      << "  -S                         Emit AMDGPU assembly\n"
      << "  -c                         Emit HSACO binary\n"
      << "  -D <name[=value]>          Define a preprocessor macro\n"
      << "  -U <name>                  Undefine a preprocessor macro\n"
      << "  -I <dir>                   Add an include search directory\n"
      << "  -isystem <dir>             Add a system include search directory\n"
      << "  -include <file>            Include a file before the main source\n"
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
  if (value == "pp" || value == "preprocessed")
    kind = EmitKind::Preprocessed;
  else if (value == "ast")
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
  if (arg == "-E" || arg == "--preprocess-only")
    return setEmitKind(options, EmitKind::Preprocessed);
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

static bool takeShortJoinedOrSeparate(int argc, char **argv, int &index,
                                      llvm::StringRef arg, llvm::StringRef name,
                                      std::string &value) {
  if (arg.starts_with(name) && arg.size() > name.size()) {
    value = arg.drop_front(name.size()).str();
    return true;
  }
  if (arg == name && index + 1 < argc) {
    value = argv[++index];
    return true;
  }
  llvm::errs() << "wavec: " << name << " expects a value\n";
  return false;
}

static bool requireNonEmpty(llvm::StringRef option, llvm::StringRef value) {
  if (!value.empty())
    return true;
  llvm::errs() << "wavec: " << option << " expects a non-empty value\n";
  return false;
}

static bool parseMacroActionOption(DriverOptions &options, int argc,
                                   char **argv, int &index, llvm::StringRef arg,
                                   llvm::StringRef name, MacroActionKind kind,
                                   bool &handled) {
  std::string value;
  handled = arg == name || (arg.starts_with(name) && arg.size() > name.size());
  if (!handled)
    return true;
  if (!takeShortJoinedOrSeparate(argc, argv, index, arg, name, value) ||
      !requireNonEmpty(name, value))
    return false;
  options.macroActions.push_back({value, kind});
  return true;
}

static bool parsePreprocessorOption(DriverOptions &options, int argc,
                                    char **argv, int &index,
                                    llvm::StringRef arg, bool &handled) {
  if (!parseMacroActionOption(options, argc, argv, index, arg, "-D",
                              MacroActionKind::Define, handled))
    return false;
  if (handled)
    return true;
  return parseMacroActionOption(options, argc, argv, index, arg, "-U",
                                MacroActionKind::Undefine, handled);
}

static bool parseIncludeSearchOption(DriverOptions &options, int argc,
                                     char **argv, int &index,
                                     llvm::StringRef arg, bool &handled) {
  std::string value;
  if (arg == "-I" || (arg.starts_with("-I") && arg.size() > 2)) {
    handled = true;
    if (!takeShortJoinedOrSeparate(argc, argv, index, arg, "-I", value) ||
        !requireNonEmpty("-I", value))
      return false;
    options.includeDirs.push_back(value);
    return true;
  }
  if (arg == "-isystem" || arg.starts_with("-isystem=")) {
    handled = true;
    if (!takeJoinedOrSeparate(argc, argv, index, arg, "-isystem", value) ||
        !requireNonEmpty("-isystem", value))
      return false;
    options.systemIncludeDirs.push_back(value);
    return true;
  }
  handled = false;
  return true;
}

static bool parseForcedIncludeOption(DriverOptions &options, int argc,
                                     char **argv, int &index,
                                     llvm::StringRef arg, bool &handled) {
  std::string value;
  if (arg == "-include" || arg.starts_with("-include=")) {
    handled = true;
    if (!takeJoinedOrSeparate(argc, argv, index, arg, "-include", value) ||
        !requireNonEmpty("-include", value))
      return false;
    options.forcedIncludes.push_back(value);
    return true;
  }
  handled = false;
  return true;
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

using OptionParser = bool (*)(DriverOptions &, int, char **, int &,
                              llvm::StringRef, bool &);

static bool parseModeOption(DriverOptions &options, int, char **, int &,
                            llvm::StringRef arg, bool &handled) {
  return parseModeFlag(options, arg, handled);
}

static bool parseKnownOption(DriverOptions &options, int argc, char **argv,
                             int &index, llvm::StringRef arg, bool &handled) {
  static constexpr OptionParser parsers[] = {
      parseModeOption,          parseOutputOption,
      parsePreprocessorOption,  parseIncludeSearchOption,
      parseForcedIncludeOption, parseValuedLongOption,
  };
  for (OptionParser parser : parsers) {
    if (!parser(options, argc, argv, index, arg, handled))
      return false;
    if (handled)
      return true;
  }
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
  if (!parseKnownOption(options, argc, argv, index, arg, handled))
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
  registry.insert<arith::ArithDialect, func::FuncDialect, gpu::GPUDialect,
                  ub::UBDialect, wave::WaveDialect, waveamd::WaveAMDDialect,
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

        FailureOr<std::string> resolvedFeatures =
            waveamdmachine::getAMDGPUAssemblerFeatures(
                module.getOperation(), options.targetFeatures, "wavec");
        if (failed(resolvedFeatures))
          return false;

        SmallVector<char, 0> hsaco;
        if (failed(wave::assembleWaveAMDGPUKernels(module, target->triple,
                                                   target->chip,
                                                   *resolvedFeatures, hsaco)))
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
  case EmitKind::Preprocessed:
    llvm_unreachable("handled before parsing");
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

static bool readAndPreprocessSource(const DriverOptions &options,
                                    std::string &preprocessedSource) {
  llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> input =
      llvm::MemoryBuffer::getFileOrSTDIN(options.inputFile);
  if (!input) {
    llvm::errs() << "wavec: cannot read `" << options.inputFile
                 << "`: " << input.getError().message() << "\n";
    return false;
  }
  return preprocessSource(options, (*input)->getMemBufferRef(),
                          preprocessedSource);
}

static bool compilePreprocessedSource(const DriverOptions &options,
                                      llvm::StringRef source) {
  FrontendResult result;
  if (!result.arena.valid()) {
    llvm::errs() << "wavec: failed to allocate frontend arena\n";
    return false;
  }
  diag_list_init(&result.diags, &result.arena.arena);

  bool ok = parseSource(result, source);
  if (ok)
    ok = compileToOutput(result, options);
  if (!ok) {
    llvm::StringRef name = options.inputFile;
    if (name == "-")
      name = "<stdin>";
    printDiagnostics(name, result.diags);
  }
  return ok;
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

  std::string preprocessedSource;
  if (!readAndPreprocessSource(options, preprocessedSource))
    return 1;
  if (options.emitKind == EmitKind::Preprocessed)
    return writeOutput(options, preprocessedSource, /*binary=*/false) ? 0 : 1;
  return compilePreprocessedSource(options, preprocessedSource) ? 0 : 1;
}
