//===- wave-matmul-calibrate-runner.cpp - Timed matmul launcher -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <hip/hip_runtime.h>
#include <hip/hip_runtime_api.h>

#include <algorithm>
#include <array>
#include <cerrno>
#include <climits>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <utility>
#include <vector>

namespace {

enum class CType { F32, F16, BF16 };
enum class InputType { F16, BF16, MXFP4 };
enum class KernelABI { Matmul, V9Golden, TLXMXFP, StreamK };
enum class AccumulatorLayout { Automatic, Wmma, Mfma };
enum class OutputLayout { Automatic, TilePacked, RowMajor, ColumnMajor };
enum class ScaleLayout { Canonical, TensileLite };
enum class MXFP4InputLayout { Canonical, AITER };

struct Args {
  const char *hsaco = nullptr;
  const char *kernel = nullptr;
  int m = 32;
  int n = 32;
  int k = 32;
  int bm = 1;
  int bn = 2;
  int waveMTiles = 1;
  int waveNTiles = 1;
  int waveKTiles = 1;
  int waveSize = 32;
  InputType inputType = InputType::F16;
  CType cType = CType::F32;
  KernelABI kernelABI = KernelABI::Matmul;
  AccumulatorLayout accumulatorLayout = AccumulatorLayout::Automatic;
  OutputLayout outputLayout = OutputLayout::Automatic;
  int iters = 1000;
  int warmupIters = 10;
  int dynamicLdsBytes = 0;
  int streamKWorkers = 1;
  int seed = 0;
  bool checkOutput = true;
  bool allOnes = false;
  bool randInt = false;
  bool hpl = false;
  ScaleLayout scaleLayout = ScaleLayout::Canonical;
  MXFP4InputLayout mxfp4InputLayout = MXFP4InputLayout::Canonical;
};

[[noreturn]] static void die(const char *msg) {
  std::fprintf(stderr, "%s\n", msg);
  std::exit(2);
}

static void usage() {
  std::fprintf(
      stderr,
      "usage: wave-matmul-calibrate-runner [options] <hsaco> <kernel>\n"
      "options:\n"
      "  --m N                  output rows (default 32)\n"
      "  --n N                  output cols (default 32)\n"
      "  --k N                  contraction dim (default 32)\n"
      "  --bm N                 M waves per block (default 1)\n"
      "  --bn N                 N waves per block (default 2)\n"
      "  --wave-m-tiles N       per-wave M tiles (default 1)\n"
      "  --wave-n-tiles N       per-wave N tiles (default 1)\n"
      "  --wave-k-tiles N       per-wave K tiles (default 1)\n"
      "  --wave-size N          lanes per wave (default 32)\n"
      "  --input-type f16|bf16|mxfp4  input element type (default f16)\n"
      "  --c-type f32|f16|bf16  output element type (default f32)\n"
      "  --kernel-abi matmul|v9-golden|tlx-mxfp|streamk  kernel argument "
      "ABI\n"
      "  --accumulator-layout automatic|wmma|mfma\n"
      "  --output-layout automatic|tile-packed|row-major|column-major\n"
      "  --dynamic-lds N        dynamic LDS bytes (default 0)\n"
      "  --streamk-workers N    persistent Stream-K workgroups\n"
      "  --iters N              launch iterations (default 1000)\n"
      "  --warmup N             warmup launches (default 10)\n"
      "  --seed N               deterministic input seed (default 0)\n"
      "  --scale-layout canonical|tensilelite  MXFP4 scale upload layout\n"
      "  --mxfp4-input-layout canonical|aiter  MXFP4 data/scale ABI\n"
      "  --all-ones             fill A/B with ones and MXFP4 scales with 1\n"
      "  --rand-int             match hipBLASLt f16/bf16 rand_int inputs\n"
      "  --hpl                  match hipBLASLt f16/bf16 HPL inputs\n"
      "  --no-check             skip random-output check\n");
}

static int parseInt(const char *s) {
  errno = 0;
  char *end = nullptr;
  long v = std::strtol(s, &end, 10);
  if (!end || *end != '\0' || errno == ERANGE || v < INT_MIN || v > INT_MAX)
    die("bad integer arg");
  return static_cast<int>(v);
}

struct FlagHandler {
  const char *name;
  void (*set)(Args &, const char *);
};

static void setM(Args &a, const char *v) { a.m = parseInt(v); }
static void setN(Args &a, const char *v) { a.n = parseInt(v); }
static void setK(Args &a, const char *v) { a.k = parseInt(v); }
static void setBM(Args &a, const char *v) { a.bm = parseInt(v); }
static void setBN(Args &a, const char *v) { a.bn = parseInt(v); }
static void setWaveMTiles(Args &a, const char *v) {
  a.waveMTiles = parseInt(v);
}
static void setWaveNTiles(Args &a, const char *v) {
  a.waveNTiles = parseInt(v);
}
static void setWaveKTiles(Args &a, const char *v) {
  a.waveKTiles = parseInt(v);
}
static void setWaveSize(Args &a, const char *v) { a.waveSize = parseInt(v); }
static void setInputType(Args &a, const char *v) {
  if (std::strcmp(v, "f16") == 0) {
    a.inputType = InputType::F16;
    return;
  }
  if (std::strcmp(v, "bf16") == 0) {
    a.inputType = InputType::BF16;
    return;
  }
  if (std::strcmp(v, "mxfp4") == 0) {
    a.inputType = InputType::MXFP4;
    return;
  }
  die("bad --input-type; expected f16, bf16, or mxfp4");
}
static void setCType(Args &a, const char *v) {
  if (std::strcmp(v, "f32") == 0) {
    a.cType = CType::F32;
    return;
  }
  if (std::strcmp(v, "f16") == 0) {
    a.cType = CType::F16;
    return;
  }
  if (std::strcmp(v, "bf16") == 0) {
    a.cType = CType::BF16;
    return;
  }
  die("bad --c-type; expected f32, f16, or bf16");
}
static void setScaleLayout(Args &a, const char *v) {
  if (std::strcmp(v, "canonical") == 0) {
    a.scaleLayout = ScaleLayout::Canonical;
    return;
  }
  if (std::strcmp(v, "tensilelite") == 0) {
    a.scaleLayout = ScaleLayout::TensileLite;
    return;
  }
  die("bad --scale-layout; expected canonical or tensilelite");
}
static void setMXFP4InputLayout(Args &a, const char *v) {
  if (std::strcmp(v, "canonical") == 0) {
    a.mxfp4InputLayout = MXFP4InputLayout::Canonical;
    return;
  }
  if (std::strcmp(v, "aiter") == 0) {
    a.mxfp4InputLayout = MXFP4InputLayout::AITER;
    return;
  }
  die("bad --mxfp4-input-layout; expected canonical or aiter");
}
static void setKernelABI(Args &a, const char *v) {
  if (std::strcmp(v, "matmul") == 0) {
    a.kernelABI = KernelABI::Matmul;
    return;
  }
  if (std::strcmp(v, "v9-golden") == 0) {
    a.kernelABI = KernelABI::V9Golden;
    return;
  }
  if (std::strcmp(v, "tlx-mxfp") == 0) {
    a.kernelABI = KernelABI::TLXMXFP;
    return;
  }
  if (std::strcmp(v, "streamk") == 0) {
    a.kernelABI = KernelABI::StreamK;
    return;
  }
  die("bad --kernel-abi; expected matmul, v9-golden, tlx-mxfp, or streamk");
}
static void setAccumulatorLayout(Args &a, const char *v) {
  if (std::strcmp(v, "automatic") == 0) {
    a.accumulatorLayout = AccumulatorLayout::Automatic;
    return;
  }
  if (std::strcmp(v, "wmma") == 0) {
    a.accumulatorLayout = AccumulatorLayout::Wmma;
    return;
  }
  if (std::strcmp(v, "mfma") == 0) {
    a.accumulatorLayout = AccumulatorLayout::Mfma;
    return;
  }
  die("bad --accumulator-layout; expected automatic, wmma, or mfma");
}
static void setOutputLayout(Args &a, const char *v) {
  if (std::strcmp(v, "automatic") == 0) {
    a.outputLayout = OutputLayout::Automatic;
    return;
  }
  if (std::strcmp(v, "tile-packed") == 0) {
    a.outputLayout = OutputLayout::TilePacked;
    return;
  }
  if (std::strcmp(v, "row-major") == 0) {
    a.outputLayout = OutputLayout::RowMajor;
    return;
  }
  if (std::strcmp(v, "column-major") == 0) {
    a.outputLayout = OutputLayout::ColumnMajor;
    return;
  }
  die("bad --output-layout; expected automatic, tile-packed, row-major, or "
      "column-major");
}
static void setIters(Args &a, const char *v) { a.iters = parseInt(v); }
static void setWarmup(Args &a, const char *v) { a.warmupIters = parseInt(v); }
static void setSeed(Args &a, const char *v) { a.seed = parseInt(v); }
static void setDynamicLds(Args &a, const char *v) {
  a.dynamicLdsBytes = parseInt(v);
}
static void setStreamKWorkers(Args &a, const char *v) {
  a.streamKWorkers = parseInt(v);
}

static constexpr FlagHandler kFlags[] = {
    {"--m", setM},
    {"--n", setN},
    {"--k", setK},
    {"--bm", setBM},
    {"--bn", setBN},
    {"--wave-m-tiles", setWaveMTiles},
    {"--wave-n-tiles", setWaveNTiles},
    {"--wave-k-tiles", setWaveKTiles},
    {"--wave-size", setWaveSize},
    {"--input-type", setInputType},
    {"--c-type", setCType},
    {"--kernel-abi", setKernelABI},
    {"--accumulator-layout", setAccumulatorLayout},
    {"--output-layout", setOutputLayout},
    {"--scale-layout", setScaleLayout},
    {"--mxfp4-input-layout", setMXFP4InputLayout},
    {"--dynamic-lds", setDynamicLds},
    {"--streamk-workers", setStreamKWorkers},
    {"--iters", setIters},
    {"--warmup", setWarmup},
    {"--seed", setSeed},
};

static bool tryFlag(const char *arg, const char *val, Args &a) {
  for (const FlagHandler &h : kFlags) {
    if (std::strcmp(arg, h.name) == 0) {
      h.set(a, val);
      return true;
    }
  }
  return false;
}

static void setPositional(Args &a, const char *arg, int &positional) {
  if (positional == 0)
    a.hsaco = arg;
  else if (positional == 1)
    a.kernel = arg;
  else
    die("unexpected positional argument");
  ++positional;
}

static bool isHelp(const char *arg) {
  return std::strcmp(arg, "--help") == 0 || std::strcmp(arg, "-h") == 0;
}

static bool isFlag(const char *arg) { return arg[0] == '-' && arg[1] == '-'; }

static int handleOneArg(int argc, char **argv, int i, Args &a,
                        int &positional) {
  const char *arg = argv[i];
  if (isHelp(arg)) {
    usage();
    std::exit(0);
  }
  if (std::strcmp(arg, "--no-check") == 0) {
    a.checkOutput = false;
    return i + 1;
  }
  if (std::strcmp(arg, "--all-ones") == 0) {
    a.allOnes = true;
    return i + 1;
  }
  if (std::strcmp(arg, "--rand-int") == 0) {
    a.randInt = true;
    return i + 1;
  }
  if (std::strcmp(arg, "--hpl") == 0) {
    a.hpl = true;
    return i + 1;
  }
  if (isFlag(arg)) {
    if (i + 1 >= argc)
      die("missing value for flag");
    if (!tryFlag(arg, argv[i + 1], a))
      die("unknown flag");
    return i + 2;
  }
  setPositional(a, arg, positional);
  return i + 1;
}

static void requirePositive(int v, const char *what) {
  if (v <= 0)
    die(what);
}

static bool hasV9GoldenTileShape(const Args &a) {
  return a.bm == 4 && a.bn == 2 && a.waveMTiles == 4 && a.waveNTiles == 8 &&
         a.waveKTiles == 2;
}

static bool hasTLXMXFPTileShape(const Args &a) {
  return a.bm == 2 && a.bn == 2 && a.waveMTiles == 8 && a.waveNTiles == 8 &&
         a.waveKTiles == 2;
}

static bool isStreamK(const Args &a) {
  return a.kernelABI == KernelABI::StreamK;
}

static uint64_t checkedU64Product(uint64_t lhs, uint64_t rhs,
                                  const char *message) {
  if (rhs && lhs > std::numeric_limits<uint64_t>::max() / rhs)
    die(message);
  return lhs * rhs;
}

static size_t checkedSizeProduct(size_t lhs, size_t rhs, const char *message) {
  if (rhs && lhs > std::numeric_limits<size_t>::max() / rhs)
    die(message);
  return lhs * rhs;
}

static int checkedIntProduct(int lhs, int rhs, const char *message) {
  uint64_t product = checkedU64Product(static_cast<uint64_t>(lhs),
                                       static_cast<uint64_t>(rhs), message);
  if (product > static_cast<uint64_t>(std::numeric_limits<int>::max()))
    die(message);
  return static_cast<int>(product);
}

static int getOutputElementCount(const Args &a) {
  return checkedIntProduct(a.m, a.n, "output element count exceeds i32");
}

static int checkedAlignUp(int value, int alignment, const char *message) {
  int remainder = value % alignment;
  if (!remainder)
    return value;
  int increment = alignment - remainder;
  if (value > std::numeric_limits<int>::max() - increment)
    die(message);
  return value + increment;
}

struct StreamKWorkspaceSizes {
  size_t scratchBytes = 0;
  size_t counterElements = 0;
  size_t counterBytes = 0;
};

static StreamKWorkspaceSizes getStreamKWorkspaceSizes(const Args &a) {
  StreamKWorkspaceSizes sizes;
  sizes.scratchBytes = checkedSizeProduct(static_cast<size_t>(a.streamKWorkers),
                                          2, "Stream-K scratch size overflow");
  sizes.scratchBytes = checkedSizeProduct(sizes.scratchBytes, 256 * 256,
                                          "Stream-K scratch size overflow");
  sizes.scratchBytes = checkedSizeProduct(sizes.scratchBytes, sizeof(float),
                                          "Stream-K scratch size overflow");
  sizes.counterElements = checkedSizeProduct(static_cast<size_t>(a.m / 256),
                                             static_cast<size_t>(a.n / 256),
                                             "Stream-K counter size overflow");
  sizes.counterBytes =
      checkedSizeProduct(sizes.counterElements, sizeof(uint32_t),
                         "Stream-K counter size overflow");
  return sizes;
}

static uint64_t getStreamKTotalIterations(const Args &a) {
  uint64_t tiles = checkedU64Product(static_cast<uint64_t>(a.m / 256),
                                     static_cast<uint64_t>(a.n / 256),
                                     "Stream-K work size overflow");
  return checkedU64Product(tiles, static_cast<uint64_t>(a.k / 64),
                           "Stream-K work size overflow");
}

static void validateStreamKBufferRange(uint64_t elements, const char *message) {
  uint64_t bytes = checkedU64Product(elements, 2, message);
  if (bytes > UINT32_MAX)
    die(message);
}

static void validateStreamKTypesAndShape(const Args &a) {
  if (a.inputType != InputType::F16 || a.cType != CType::F16)
    die("Stream-K ABI requires f16 input and output");
  if (a.waveSize != 64)
    die("Stream-K ABI requires wave-size 64");
  if (!hasTLXMXFPTileShape(a))
    die("Stream-K ABI requires the 256x256x64 four-wave shape");
}

static void validateStreamKGeometry(const Args &a) {
  if (a.m % 256 || a.n % 256 || a.k % 64)
    die("Stream-K ABI requires M/N multiples of 256 and K of 64");
  if (a.outputLayout != OutputLayout::Automatic &&
      a.outputLayout != OutputLayout::ColumnMajor)
    die("Stream-K ABI requires column-major output");
}

static void validateStreamKWork(const Args &a) {
  uint64_t totalIterations = getStreamKTotalIterations(a);
  if (totalIterations > INT_MAX)
    die("Stream-K work index exceeds i32");
  if (a.streamKWorkers <= 0 ||
      static_cast<uint64_t>(a.streamKWorkers) > totalIterations)
    die("Stream-K worker count must fit the work");
  validateStreamKBufferRange(
      checkedU64Product(static_cast<uint64_t>(a.m), static_cast<uint64_t>(a.k),
                        "Stream-K A buffer range overflow"),
      "Stream-K A buffer range overflow");
  validateStreamKBufferRange(
      checkedU64Product(static_cast<uint64_t>(a.n), static_cast<uint64_t>(a.k),
                        "Stream-K B buffer range overflow"),
      "Stream-K B buffer range overflow");
  validateStreamKBufferRange(
      checkedU64Product(static_cast<uint64_t>(a.m), static_cast<uint64_t>(a.n),
                        "Stream-K C buffer range overflow"),
      "Stream-K C buffer range overflow");
  (void)getStreamKWorkspaceSizes(a);
}

static void validateStreamKArgs(const Args &a) {
  if (!isStreamK(a)) {
    if (a.streamKWorkers != 1)
      die("--streamk-workers requires the Stream-K ABI");
    return;
  }
  validateStreamKTypesAndShape(a);
  validateStreamKGeometry(a);
  validateStreamKWork(a);
}

static void validateV9GoldenArgs(const Args &a) {
  if (a.kernelABI != KernelABI::V9Golden)
    return;
  if (a.inputType != InputType::F16)
    die("v9 golden ABI requires f16 input");
  if (a.cType != CType::F16)
    die("v9 golden ABI requires f16 output");
  if (a.waveSize != 64)
    die("v9 golden ABI requires wave-size 64");
  if (a.k != 4096)
    die("v9 golden ABI is frozen for k=4096");
  if (!hasV9GoldenTileShape(a))
    die("v9 golden ABI requires the v9 256x256x64 tile shape");
}

static void validateTLXMXFPArgs(const Args &a) {
  if (a.kernelABI != KernelABI::TLXMXFP)
    return;
  if (a.inputType != InputType::MXFP4)
    die("TLX MXFP ABI requires MXFP4 input");
  if (a.cType != CType::BF16)
    die("TLX MXFP ABI requires BF16 output");
  if (a.waveSize != 64)
    die("TLX MXFP ABI requires wave-size 64");
  if (a.k != 16384)
    die("TLX MXFP ABI is frozen for k=16384");
  if (!hasTLXMXFPTileShape(a))
    die("TLX MXFP ABI requires the TLX 256x256x256 tile shape");
}

static void validateAITERTilePackedPlan(const Args &a);

static void validateAITERTileCounts(const Args &a) {
  if (a.waveKTiles % 2)
    die("aiter input layout requires even wave K tiles");
  if (a.waveMTiles % 2 || a.waveNTiles % 2)
    die("aiter input layout requires even wave M/N tiles");
  if (a.k % 64)
    die("aiter input layout requires K multiple of 64");
  if ((a.k / 64) % a.waveKTiles)
    die("aiter wave K tiles must divide K/64");
}

static void validateAITERBufferRange(uint64_t bytes, const char *message) {
  if (bytes > std::numeric_limits<uint32_t>::max())
    die(message);
}

static void validateAITERBufferRanges(const Args &a) {
  int packedK = a.k / 2;
  validateAITERBufferRange(checkedU64Product(static_cast<uint64_t>(a.m),
                                             packedK,
                                             "AITER A buffer range overflow"),
                           "AITER A buffer range exceeds u32");
  validateAITERBufferRange(checkedU64Product(static_cast<uint64_t>(a.n),
                                             packedK,
                                             "AITER B buffer range overflow"),
                           "AITER B buffer range exceeds u32");
  int paddedGroups =
      checkedAlignUp(a.k / 32, 8, "AITER scale group padding overflow");
  int paddedM = checkedAlignUp(a.m, 256, "AITER scale row padding overflow");
  int paddedN = checkedAlignUp(a.n, 256, "AITER scale row padding overflow");
  validateAITERBufferRange(
      checkedU64Product(static_cast<uint64_t>(paddedM), paddedGroups,
                        "AITER A scale buffer range overflow"),
      "AITER A scale buffer range exceeds u32");
  validateAITERBufferRange(
      checkedU64Product(static_cast<uint64_t>(paddedN), paddedGroups,
                        "AITER B scale buffer range overflow"),
      "AITER B scale buffer range exceeds u32");
}

static void validateAITERInputArgs(const Args &a) {
  if (a.mxfp4InputLayout != MXFP4InputLayout::AITER)
    return;
  if (a.inputType != InputType::MXFP4)
    die("aiter input layout requires MXFP4 input");
  if (a.scaleLayout != ScaleLayout::Canonical)
    die("aiter input layout owns the scale layout");
  if (a.kernelABI != KernelABI::Matmul)
    die("aiter input layout requires the matmul ABI");
  if (a.accumulatorLayout == AccumulatorLayout::Wmma)
    die("aiter input layout requires MFMA accumulators");
  if (a.outputLayout != OutputLayout::Automatic &&
      a.outputLayout != OutputLayout::TilePacked)
    die("aiter final output conversion requires tile-packed kernel output");
  validateAITERTileCounts(a);
  validateAITERBufferRanges(a);
  validateAITERTilePackedPlan(a);
}

static void validateMXFP4InputArgs(const Args &a) {
  if (a.inputType == InputType::MXFP4 && a.waveSize != 64)
    die("MXFP4 calibration expects wave-size 64");
  if (a.scaleLayout == ScaleLayout::TensileLite &&
      a.inputType != InputType::MXFP4)
    die("tensilelite scale layout requires MXFP4 input");
  validateAITERInputArgs(a);
}

static void validateArgs(const Args &a) {
  requirePositive(a.m, "m must be positive");
  requirePositive(a.n, "n must be positive");
  requirePositive(a.k, "k must be positive");
  requirePositive(a.bm, "bm must be positive");
  requirePositive(a.bn, "bn must be positive");
  requirePositive(a.waveMTiles, "wave-m-tiles must be positive");
  requirePositive(a.waveNTiles, "wave-n-tiles must be positive");
  requirePositive(a.waveKTiles, "wave-k-tiles must be positive");
  requirePositive(a.waveSize, "wave-size must be positive");
  requirePositive(a.iters, "iters must be positive");
  if (a.warmupIters < 0)
    die("warmup must be non-negative");
  if (a.dynamicLdsBytes < 0)
    die("dynamic LDS bytes must be non-negative");
  validateMXFP4InputArgs(a);
  if (static_cast<int>(a.allOnes) + static_cast<int>(a.randInt) +
          static_cast<int>(a.hpl) >
      1)
    die("--all-ones, --rand-int, and --hpl are mutually exclusive");
  if ((a.randInt || a.hpl) && a.inputType == InputType::MXFP4)
    die("--rand-int/--hpl support f16/bf16 inputs only");
  validateV9GoldenArgs(a);
  validateTLXMXFPArgs(a);
  validateStreamKArgs(a);
  (void)getOutputElementCount(a);
}

static Args parseArgs(int argc, char **argv) {
  Args a;
  int positional = 0;
  for (int i = 1; i < argc;)
    i = handleOneArg(argc, argv, i, a, positional);
  if (!a.hsaco || !a.kernel) {
    usage();
    die("missing required positional args");
  }
  validateArgs(a);
  return a;
}

static void checkHip(hipError_t e, const char *what) {
  if (e != hipSuccess) {
    std::fprintf(stderr, "%s: %s\n", what, hipGetErrorString(e));
    std::exit(1);
  }
}

static int divExact(int num, int den, const char *what) {
  if (den <= 0 || num % den != 0)
    die(what);
  return num / den;
}

static float halfToFloat(uint16_t h) {
  uint32_t sign = (static_cast<uint32_t>(h & 0x8000)) << 16;
  uint32_t exp = (h >> 10) & 0x1f;
  uint32_t mant = h & 0x03ff;
  uint32_t bits = 0;
  if (exp == 0) {
    if (mant == 0) {
      bits = sign;
    } else {
      exp = 1;
      while ((mant & 0x0400) == 0) {
        mant <<= 1;
        --exp;
      }
      mant &= 0x03ff;
      bits = sign | ((exp + 112) << 23) | (mant << 13);
    }
  } else if (exp == 0x1f) {
    bits = sign | 0x7f800000 | (mant << 13);
  } else {
    bits = sign | ((exp + 112) << 23) | (mant << 13);
  }
  float out;
  std::memcpy(&out, &bits, sizeof(out));
  return out;
}

static uint16_t floatToHalfBits(float value) {
  _Float16 half = static_cast<_Float16>(value);
  uint16_t bits = 0;
  std::memcpy(&bits, &half, sizeof(bits));
  return bits;
}

static uint16_t floatToBF16Bits(float value) {
  uint32_t bits = 0;
  std::memcpy(&bits, &value, sizeof(bits));
  uint32_t rounded = bits + 0x7fffu + ((bits >> 16) & 1u);
  return static_cast<uint16_t>(rounded >> 16);
}

static float bf16ToFloat(uint16_t h) {
  uint32_t bits = static_cast<uint32_t>(h) << 16;
  float out;
  std::memcpy(&out, &bits, sizeof(out));
  return out;
}

static uint32_t randState(int seed, int stream) {
  return static_cast<uint32_t>(seed) ^
         (static_cast<uint32_t>(stream + 1) * 0x9E3779B9u);
}

static uint32_t nextRand(uint32_t &state) {
  state = 1664525u * state + 1013904223u;
  return state;
}

static float randomInputValue(uint32_t &state) {
  int bucket = static_cast<int>((nextRand(state) >> 24) % 17u);
  return static_cast<float>((bucket - 8) * 0.25f);
}

static uint64_t hipblasLtXorShift(uint64_t state) {
  return state ^ (state << 13) ^ (state >> 17) ^ (state << 5);
}

static float hipblasLtRandInt(size_t index) {
  uint64_t state = index * 1664525 + 1013904223;
  state = hipblasLtXorShift(state);
  state = hipblasLtXorShift(state);
  state = hipblasLtXorShift(state);
  return static_cast<float>(static_cast<uint32_t>(state) % 5) - 2.0f;
}

static float hipblasLtHpl(size_t index) {
  uint64_t state = index * 1664525 + 1013904223;
  state = hipblasLtXorShift(state);
  state = hipblasLtXorShift(state);
  state = hipblasLtXorShift(state);
  return static_cast<float>(static_cast<double>(static_cast<uint32_t>(state)) /
                                static_cast<double>(UINT32_MAX) -
                            0.5);
}

static uint8_t randomMXFP4Code(uint32_t &state) {
  return static_cast<uint8_t>((nextRand(state) >> 28) & 0xfu);
}

static float mxfp4CodeToFloat(uint8_t code) {
  static constexpr std::array<float, 8> magnitudes = {0.0f, 0.5f, 1.0f, 1.5f,
                                                      2.0f, 3.0f, 4.0f, 6.0f};
  float value = magnitudes[code & 0x7u];
  return code & 0x8u ? -value : value;
}

static float e8m0ToFloat(uint8_t raw) {
  return static_cast<float>(std::ldexp(1.0, static_cast<int>(raw) - 127));
}

struct HostInputs;

static float computeExpectedElement(const HostInputs &inputs, const Args &a,
                                    int m, int n);

static double roundExpectedOutput(double value, CType type) {
  if (type == CType::F16)
    return halfToFloat(floatToHalfBits(static_cast<float>(value)));
  if (type == CType::BF16)
    return bf16ToFloat(floatToBF16Bits(static_cast<float>(value)));
  return value;
}

struct OutputCoordinate {
  int m;
  int n;
};

struct TilePackedOutputPlan {
  int elements;
  int n;
  int nBlocks;
  int mTilesPerBlock;
  int nTilesPerBlock;
  int bn;
  int waveMTiles;
  int waveNTiles;
  int ctaElements;
  int waveElements;
  int valuesPerLane;
  bool wmma;
};

static AccumulatorLayout getEffectiveAccumulatorLayout(const Args &a) {
  if (a.accumulatorLayout != AccumulatorLayout::Automatic)
    return a.accumulatorLayout;
  return a.waveSize == 64 ? AccumulatorLayout::Mfma : AccumulatorLayout::Wmma;
}

static TilePackedOutputPlan makeTilePackedOutputPlan(const Args &a) {
  bool wmma = getEffectiveAccumulatorLayout(a) == AccumulatorLayout::Wmma;
  if (wmma && a.waveSize != 32)
    die("WMMA output check requires wave32");
  if (!wmma && a.waveSize != 32 && a.waveSize != 64)
    die("MFMA output check requires wave32 or wave64");
  int valuesPerLane = divExact(256, a.waveSize, "bad output wave size");
  int mTilesPerBlock = checkedIntProduct(a.bm, a.waveMTiles,
                                         "tile-packed M blocking exceeds i32");
  int nTilesPerBlock = checkedIntProduct(a.bn, a.waveNTiles,
                                         "tile-packed N blocking exceeds i32");
  int mBlockRows = checkedIntProduct(mTilesPerBlock, 16,
                                     "tile-packed M blocking exceeds i32");
  int nBlockCols = checkedIntProduct(nTilesPerBlock, 16,
                                     "tile-packed N blocking exceeds i32");
  int mBlocks = divExact(a.m, mBlockRows, "bad M blocking");
  int nBlocks = divExact(a.n, nBlockCols, "bad N blocking");
  int tilesPerWave = checkedIntProduct(a.waveMTiles, a.waveNTiles,
                                       "tile-packed wave elements exceed i32");
  int wavesPerWorkgroup = checkedIntProduct(
      a.bm, a.bn, "tile-packed workgroup elements exceed i32");
  int waveElements = checkedIntProduct(tilesPerWave, 256,
                                       "tile-packed wave elements exceed i32");
  int ctaElements =
      checkedIntProduct(wavesPerWorkgroup, waveElements,
                        "tile-packed workgroup elements exceed i32");
  int ctaCount =
      checkedIntProduct(mBlocks, nBlocks, "tile-packed CTA count exceeds i32");
  int elements = getOutputElementCount(a);
  if (checkedIntProduct(ctaCount, ctaElements,
                        "tile-packed output elements exceed i32") != elements)
    die("tile-packed output geometry does not cover M*N");
  return {elements,       a.n,          nBlocks,       mTilesPerBlock,
          nTilesPerBlock, a.bn,         a.waveMTiles,  a.waveNTiles,
          ctaElements,    waveElements, valuesPerLane, wmma};
}

static void validateAITERTilePackedPlan(const Args &a) {
  (void)makeTilePackedOutputPlan(a);
}

static __host__ __device__ int
getAccumulatorRow(bool wmma, int lane, int laneValue, int valuesPerLane) {
  if (wmma)
    return (lane / 16) + 2 * laneValue;
  return (lane / 16) * valuesPerLane + laneValue;
}

static __host__ __device__ OutputCoordinate
getOutputCoordinate(int index, const TilePackedOutputPlan &plan) {
  int cta = index / plan.ctaElements;
  int ctaRem = index % plan.ctaElements;
  int wgM = cta / plan.nBlocks;
  int wgN = cta % plan.nBlocks;
  int waveId = ctaRem / plan.waveElements;
  int waveRem = ctaRem % plan.waveElements;
  int tileId = waveRem / 256;
  int slot = waveRem % 256;
  int mWave = waveId / plan.bn;
  int nWave = waveId % plan.bn;
  int lane = slot / plan.valuesPerLane;
  int laneValue = slot % plan.valuesPerLane;
  int mLane = getAccumulatorRow(plan.wmma, lane, laneValue, plan.valuesPerLane);
  int mTile = wgM * plan.mTilesPerBlock + mWave * plan.waveMTiles +
              tileId / plan.waveNTiles;
  int nTile = wgN * plan.nTilesPerBlock + nWave * plan.waveNTiles +
              tileId % plan.waveNTiles;
  return {mTile * 16 + mLane, nTile * 16 + lane % 16};
}

static OutputCoordinate getOutputCoordinate(const Args &a, int index) {
  TilePackedOutputPlan plan = makeTilePackedOutputPlan(a);
  return getOutputCoordinate(index, plan);
}

template <typename T>
static __global__ void materializeRowMajorOutput(const T *tilePacked,
                                                 T *rowMajor,
                                                 TilePackedOutputPlan plan) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  if (index >= plan.elements)
    return;
  OutputCoordinate coord = getOutputCoordinate(index, plan);
  rowMajor[coord.m * plan.n + coord.n] = tilePacked[index];
}

struct ReorderedTilePackedOutput {
  std::vector<double> values;
  std::vector<int> packedIndices;
};

static std::vector<int> getTilePackedIndexMap(int elements, const Args &a) {
  TilePackedOutputPlan plan = makeTilePackedOutputPlan(a);
  if (elements != plan.elements)
    die("tile-packed output element count mismatch");
  std::vector<int> packedIndices(elements, -1);
  for (int index = 0; index < elements; ++index) {
    OutputCoordinate coord = getOutputCoordinate(index, plan);
    if (coord.m < 0 || coord.m >= a.m || coord.n < 0 || coord.n >= a.n) {
      std::fprintf(stderr,
                   "output_check: tile-packed index=%d maps out of bounds "
                   "m=%d n=%d\n",
                   index, coord.m, coord.n);
      std::exit(1);
    }
    int logicalIndex = coord.m * a.n + coord.n;
    if (packedIndices[logicalIndex] >= 0) {
      std::fprintf(stderr,
                   "output_check: duplicate tile-packed coordinate m=%d n=%d "
                   "indices=%d,%d\n",
                   coord.m, coord.n, packedIndices[logicalIndex], index);
      std::exit(1);
    }
    packedIndices[logicalIndex] = index;
  }
  for (int index = 0; index < elements; ++index)
    if (packedIndices[index] < 0)
      die("tile-packed output mapping missed a row-major coordinate");
  return packedIndices;
}

template <typename ReadFn>
static ReorderedTilePackedOutput
reorderTilePackedOutput(int elements, const Args &a, ReadFn readValue) {
  std::vector<int> packedIndices = getTilePackedIndexMap(elements, a);
  std::vector<double> values(elements);
  for (int index = 0; index < elements; ++index)
    values[index] = static_cast<double>(readValue(packedIndices[index]));
  return {std::move(values), std::move(packedIndices)};
}

static void validateAITEROutputMapping(int elements, const Args &a) {
  if (a.mxfp4InputLayout != MXFP4InputLayout::AITER)
    return;
  validateAITERTilePackedPlan(a);
  if (!a.checkOutput)
    return;
  (void)getTilePackedIndexMap(elements, a);
  std::printf("output_layout_check: passed kernel=tile-packed "
              "final=row-major conversion=device coordinates=bijective "
              "elements=%d\n",
              elements);
}

template <typename ReadFn>
static void validateTilePackedOutput(int elements, const Args &a,
                                     const HostInputs &inputs,
                                     ReadFn readValue) {
  ReorderedTilePackedOutput output =
      reorderTilePackedOutput(elements, a, readValue);
  double worst = 0.0;
  int worstIdx = 0;
  for (int m = 0; m < a.m; ++m) {
    for (int n = 0; n < a.n; ++n) {
      int logicalIndex = m * a.n + n;
      double got = output.values[logicalIndex];
      double exp =
          roundExpectedOutput(computeExpectedElement(inputs, a, m, n), a.cType);
      double diff = std::fabs(got - exp);
      if (diff > worst) {
        worst = diff;
        worstIdx = logicalIndex;
      }
      double limit = 1.0e-2 + 1.0e-3 * std::fabs(exp);
      if (diff > limit) {
        std::fprintf(stderr,
                     "output_check: failed m=%d n=%d packed_index=%d "
                     "expected=%.6f got=%.6f abs_diff=%.6f tolerance=%.6f\n",
                     m, n, output.packedIndices[logicalIndex], exp, got, diff,
                     limit);
        std::exit(1);
      }
    }
  }
  std::printf("output_check: passed mode=strict layout=tile-packed "
              "reordered=row-major coordinates=bijective elements=%d "
              "max_abs_diff=%.6f index=%d\n",
              elements, worst, worstIdx);
}

template <typename ReadFn>
static void validateRowMajorOutput(int elements, const Args &a,
                                   const HostInputs &inputs, ReadFn readValue) {
  if (elements != getOutputElementCount(a))
    die("row-major output check expects dense MxN output");
  double worst = 0.0;
  int worstIdx = 0;
  for (int m = 0; m < a.m; ++m) {
    for (int n = 0; n < a.n; ++n) {
      int index = m * a.n + n;
      double got = static_cast<double>(readValue(index));
      double exp =
          roundExpectedOutput(computeExpectedElement(inputs, a, m, n), a.cType);
      double diff = std::fabs(got - exp);
      if (diff > worst) {
        worst = diff;
        worstIdx = index;
      }
      double limit = 1.0e-2 + 1.0e-3 * std::fabs(exp);
      if (diff > limit) {
        std::fprintf(stderr,
                     "output_check: failed m=%d n=%d expected=%.6f "
                     "got=%.6f abs_diff=%.6f tolerance=%.6f\n",
                     m, n, exp, got, diff, limit);
        std::exit(1);
      }
    }
  }
  std::printf("output_check: passed mode=strict layout=row-major elements=%d "
              "max_abs_diff=%.6f index=%d\n",
              elements, worst, worstIdx);
}

template <typename ReadFn>
static void validateColumnMajorOutput(int elements, const Args &a,
                                      const HostInputs &inputs,
                                      ReadFn readValue) {
  if (elements != getOutputElementCount(a))
    die("column-major output check expects dense MxN output");
  double worst = 0.0;
  int worstIdx = 0;
  for (int n = 0; n < a.n; ++n) {
    for (int m = 0; m < a.m; ++m) {
      int index = n * a.m + m;
      double got = static_cast<double>(readValue(index));
      double exp =
          roundExpectedOutput(computeExpectedElement(inputs, a, m, n), a.cType);
      double diff = std::fabs(got - exp);
      if (diff > worst) {
        worst = diff;
        worstIdx = index;
      }
      double limit = 1.0e-2 + 1.0e-3 * std::fabs(exp);
      if (diff > limit) {
        std::fprintf(stderr,
                     "output_check: failed m=%d n=%d expected=%.6f "
                     "got=%.6f abs_diff=%.6f tolerance=%.6f\n",
                     m, n, exp, got, diff, limit);
        std::exit(1);
      }
    }
  }
  std::printf("output_check: passed mode=strict max_abs_diff=%.6f index=%d\n",
              worst, worstIdx);
}

static const char *getCTypeName(CType type) {
  switch (type) {
  case CType::F32:
    return "f32";
  case CType::F16:
    return "f16";
  case CType::BF16:
    return "bf16";
  }
  die("unknown output type");
}

static const char *getInputTypeName(InputType type) {
  switch (type) {
  case InputType::F16:
    return "f16";
  case InputType::BF16:
    return "bf16";
  case InputType::MXFP4:
    return "mxfp4";
  }
  die("unknown input type");
}

static const char *getKernelABIName(KernelABI abi) {
  switch (abi) {
  case KernelABI::Matmul:
    return "matmul";
  case KernelABI::V9Golden:
    return "v9-golden";
  case KernelABI::TLXMXFP:
    return "tlx-mxfp";
  case KernelABI::StreamK:
    return "streamk";
  }
  die("unknown kernel ABI");
}

static const char *getOutputLayoutName(OutputLayout layout) {
  switch (layout) {
  case OutputLayout::Automatic:
    return "automatic";
  case OutputLayout::TilePacked:
    return "tile-packed";
  case OutputLayout::RowMajor:
    return "row-major";
  case OutputLayout::ColumnMajor:
    return "column-major";
  }
  die("unknown output layout");
}

static const char *getScaleLayoutName(ScaleLayout layout) {
  return layout == ScaleLayout::TensileLite ? "tensilelite" : "canonical";
}

static const char *getMXFP4InputLayoutName(MXFP4InputLayout layout) {
  return layout == MXFP4InputLayout::AITER ? "aiter" : "canonical";
}

static const char *getInputModeName(const Args &a) {
  if (a.allOnes)
    return "all-ones";
  if (a.randInt)
    return "rand-int";
  if (a.hpl)
    return "hpl";
  return "random";
}

static uint16_t oneBits(InputType type) {
  switch (type) {
  case InputType::F16:
    return 0x3c00;
  case InputType::BF16:
    return 0x3f80;
  case InputType::MXFP4:
    die("MXFP4 input is byte packed");
  }
  die("unknown input type");
}

static bool isMXFP4(InputType type) { return type == InputType::MXFP4; }

static bool isV9Golden(const Args &a) {
  return a.kernelABI == KernelABI::V9Golden;
}

static bool isTLXMXFP(const Args &a) {
  return a.kernelABI == KernelABI::TLXMXFP;
}

static OutputLayout getEffectiveOutputLayout(const Args &a) {
  if (a.outputLayout != OutputLayout::Automatic)
    return a.outputLayout;
  if (isV9Golden(a))
    return OutputLayout::RowMajor;
  if (isStreamK(a))
    return OutputLayout::ColumnMajor;
  return OutputLayout::TilePacked;
}

static bool needsAITEROutputConversion(const Args &a) {
  return a.mxfp4InputLayout == MXFP4InputLayout::AITER;
}

static OutputLayout getFinalOutputLayout(const Args &a) {
  return needsAITEROutputConversion(a) ? OutputLayout::RowMajor
                                       : getEffectiveOutputLayout(a);
}

static bool usesFlattenedGrid(const Args &a) {
  return isV9Golden(a) || isTLXMXFP(a) || isStreamK(a);
}

static int mmaKTile(const Args &a) {
  if (isMXFP4(a.inputType))
    return 128;
  if (a.waveSize == 64)
    return 32;
  return 16;
}

struct MatmulBlocking {
  int blocksX;
  int blocksY;
  int virtualKSteps;
  int wavesPerWorkgroup;
  int blockThreads;
};

static MatmulBlocking getMatmulBlocking(const Args &a) {
  int mTilesPerBlock =
      checkedIntProduct(a.bm, a.waveMTiles, "M blocking exceeds i32");
  int nTilesPerBlock =
      checkedIntProduct(a.bn, a.waveNTiles, "N blocking exceeds i32");
  int mBlockRows =
      checkedIntProduct(16, mTilesPerBlock, "M blocking exceeds i32");
  int nBlockCols =
      checkedIntProduct(16, nTilesPerBlock, "N blocking exceeds i32");
  int kBlock =
      checkedIntProduct(mmaKTile(a), a.waveKTiles, "K blocking exceeds i32");
  int wavesPerWorkgroup =
      checkedIntProduct(a.bm, a.bn, "workgroup wave count exceeds i32");
  int blockThreads = checkedIntProduct(wavesPerWorkgroup, a.waveSize,
                                       "block thread count exceeds i32");
  return {divExact(a.m, mBlockRows, "bad M blocking"),
          divExact(a.n, nBlockCols, "bad N blocking"),
          divExact(a.k, kBlock, "bad K blocking"), wavesPerWorkgroup,
          blockThreads};
}

static std::vector<uint8_t> makeMXFP4InputBytes(size_t elements, int seed,
                                                int stream, bool allOnes) {
  if (elements % 2 != 0)
    die("MXFP4 input element count must be even");
  if (allOnes)
    return std::vector<uint8_t>(elements / 2, 0x22);
  std::vector<uint8_t> bytes(elements / 2);
  uint32_t state = randState(seed, stream);
  for (size_t i = 0; i < elements; i += 2) {
    uint8_t low = randomMXFP4Code(state);
    uint8_t high = randomMXFP4Code(state);
    bytes[i / 2] = static_cast<uint8_t>(low | (high << 4));
  }
  return bytes;
}

static uint16_t inputBits(InputType type, float value) {
  return type == InputType::BF16 ? floatToBF16Bits(value)
                                 : floatToHalfBits(value);
}

static std::vector<uint8_t> make16BitInputBytes(size_t elements, int k,
                                                InputType type, int seed,
                                                int stream, bool allOnes,
                                                bool randInt, bool hpl) {
  std::vector<uint8_t> bytes(elements * sizeof(uint16_t));
  if (allOnes) {
    uint16_t bits = oneBits(type);
    for (size_t i = 0; i < elements; ++i)
      std::memcpy(bytes.data() + i * sizeof(bits), &bits, sizeof(bits));
    return bytes;
  }

  if (hpl) {
    for (size_t i = 0; i < elements; ++i) {
      uint16_t bits = inputBits(type, hipblasLtHpl(i));
      std::memcpy(bytes.data() + i * sizeof(bits), &bits, sizeof(bits));
    }
    return bytes;
  }

  if (randInt) {
    for (size_t i = 0; i < elements; ++i) {
      float value = hipblasLtRandInt(i);
      size_t row = i / static_cast<size_t>(k);
      size_t col = i % static_cast<size_t>(k);
      if (stream == 1 && ((row ^ col) & 1u) == 0)
        value = -value;
      uint16_t bits = inputBits(type, value);
      std::memcpy(bytes.data() + i * sizeof(bits), &bits, sizeof(bits));
    }
    return bytes;
  }

  uint32_t state = randState(seed, stream);
  for (size_t i = 0; i < elements; ++i) {
    float value = randomInputValue(state);
    uint16_t bits = inputBits(type, value);
    std::memcpy(bytes.data() + i * sizeof(bits), &bits, sizeof(bits));
  }
  return bytes;
}

static std::vector<uint8_t> makeInputBytes(int rows, int k, InputType type,
                                           int seed, int stream, bool allOnes,
                                           bool randInt, bool hpl) {
  size_t elements = static_cast<size_t>(rows) * k;
  if (isMXFP4(type))
    return makeMXFP4InputBytes(elements, seed, stream, allOnes);
  return make16BitInputBytes(elements, k, type, seed, stream, allOnes, randInt,
                             hpl);
}

static std::vector<uint8_t> makeMXFP4ScaleBytes(int rows, int k, int seed,
                                                int stream, bool allOnes) {
  int groups = divExact(k, 32, "bad MXFP4 scale groups");
  std::vector<uint8_t> bytes(static_cast<size_t>(rows) * groups);
  if (allOnes) {
    std::fill(bytes.begin(), bytes.end(), 0x7f);
    return bytes;
  }
  uint32_t state = randState(seed, stream);
  for (uint8_t &value : bytes)
    value = static_cast<uint8_t>(124 + ((nextRand(state) >> 29) & 3u));
  return bytes;
}

static std::vector<uint8_t>
makeAITERBBytes(const std::vector<uint8_t> &canonical, const Args &a) {
  int storageK = divExact(a.k, 2, "bad MXFP4 packed K");
  if (a.n % 16 || storageK % 32)
    die("aiter B layout requires N/16 and packed K/32 alignment");
  int kBlocks = storageK / 32;
  std::vector<uint8_t> shuffled(canonical.size());
  for (int row = 0; row < a.n; ++row) {
    int rowBlock = row / 16;
    int rowInner = row % 16;
    for (int kByte = 0; kByte < storageK; ++kByte) {
      int kBlock = kByte / 32;
      int kInner = kByte % 32;
      int half = kInner / 16;
      int byte = kInner % 16;
      size_t src = static_cast<size_t>(row) * storageK + kByte;
      size_t dst =
          ((static_cast<size_t>(rowBlock) * kBlocks + kBlock) * 2 + half) *
              256 +
          rowInner * 16 + byte;
      shuffled[dst] = canonical[src];
    }
  }
  return shuffled;
}

static std::vector<uint8_t>
makeAITERScaleBytes(const std::vector<uint8_t> &canonical, int rows,
                    const Args &a) {
  int groups = divExact(a.k, 32, "bad MXFP4 scale groups");
  int paddedRows =
      checkedAlignUp(rows, 256, "AITER scale row padding overflow");
  int paddedGroups =
      checkedAlignUp(groups, 8, "AITER scale group padding overflow");
  int groupBlocks = paddedGroups / 8;
  size_t paddedElements = checkedSizeProduct(static_cast<size_t>(paddedRows),
                                             static_cast<size_t>(paddedGroups),
                                             "AITER scale size overflow");
  if (paddedElements > std::numeric_limits<uint32_t>::max())
    die("AITER scale buffer range exceeds u32");
  std::vector<uint8_t> shuffled(paddedElements, 0x7f);
  for (int row = 0; row < rows; ++row) {
    int rowBlock = row / 32;
    int rowInner = row % 32;
    int rowHalf = rowInner / 16;
    int rowLane = rowInner % 16;
    for (int group = 0; group < groups; ++group) {
      int groupBlock = group / 8;
      int groupInner = group % 8;
      int groupHalf = groupInner / 4;
      int groupLane = groupInner % 4;
      size_t src = static_cast<size_t>(group) * rows + row;
      size_t dst =
          (static_cast<size_t>(rowBlock) * groupBlocks + groupBlock) * 256 +
          groupLane * 64 + rowLane * 4 + groupHalf * 2 + rowHalf;
      shuffled[dst] = canonical[src];
    }
  }
  return shuffled;
}

struct TensileLiteScaleLayout {
  int mBlocks;
  int nBlocks;
  int virtualKSteps;
  int blockWaves;
  int waveTiles;
  int rows;
  int kScaleGroupsPerStep;
  int groupsPerPartition;
  int partitionBytes;
  int ctaBytes;
  bool isA;
};

static TensileLiteScaleLayout makeTensileLiteScaleLayout(const Args &a,
                                                         bool isA) {
  if (a.waveKTiles % 2 || a.waveMTiles % 2 || a.waveNTiles % 2)
    die("tensilelite scale layout needs even wave tile counts");

  MatmulBlocking blocking = getMatmulBlocking(a);
  TensileLiteScaleLayout layout;
  layout.mBlocks = blocking.blocksX;
  layout.nBlocks = blocking.blocksY;
  layout.virtualKSteps = blocking.virtualKSteps;
  layout.blockWaves = isA ? a.bm : a.bn;
  layout.waveTiles = isA ? a.waveMTiles : a.waveNTiles;
  layout.rows = isA ? a.m : a.n;
  layout.kScaleGroupsPerStep = a.waveKTiles / 2;
  layout.groupsPerPartition =
      checkedIntProduct(layout.waveTiles / 2, layout.kScaleGroupsPerStep,
                        "tensilelite scale partition exceeds i32");
  layout.partitionBytes =
      checkedIntProduct(layout.groupsPerPartition, 256,
                        "tensilelite scale partition exceeds i32");
  layout.ctaBytes = checkedIntProduct(layout.blockWaves, layout.partitionBytes,
                                      "tensilelite scale CTA bytes exceed i32");
  layout.ctaBytes = checkedIntProduct(layout.ctaBytes, layout.virtualKSteps,
                                      "tensilelite scale CTA bytes exceed i32");
  layout.isA = isA;
  return layout;
}

static int tensileLiteAxisBase(const Args &a,
                               const TensileLiteScaleLayout &layout, int wgM,
                               int wgN) {
  if (layout.isA)
    return wgM * a.bm * a.waveMTiles;
  return wgN * a.bn * a.waveNTiles;
}

static size_t tensileLiteScaleDst(const TensileLiteScaleLayout &layout, int cta,
                                  int step, int wave, int group, int lane,
                                  int selector) {
  return static_cast<size_t>(cta) * layout.ctaBytes +
         step * layout.blockWaves * layout.partitionBytes +
         wave * layout.partitionBytes + group * 256 + lane * 4 + selector;
}

static void fillTensileLiteScaleLane(std::vector<uint8_t> &out,
                                     const std::vector<uint8_t> &canonical,
                                     const Args &a,
                                     const TensileLiteScaleLayout &layout,
                                     int axisTileBase, int cta, int step,
                                     int wave, int axisGroup, int kGroup,
                                     int group, int lane) {
  int laneMN = lane & 15;
  int laneScaleK = lane / 16;
  for (int kSel = 0; kSel < 2; ++kSel) {
    for (int axisSel = 0; axisSel < 2; ++axisSel) {
      int axisTile =
          axisTileBase + wave * layout.waveTiles + axisGroup * 2 + axisSel;
      int rawK = step * a.waveKTiles + kGroup * 2 + kSel;
      int scaleK = rawK * 4 + laneScaleK;
      size_t src =
          static_cast<size_t>(scaleK) * layout.rows + axisTile * 16 + laneMN;
      int selector = axisSel + 2 * kSel;
      size_t dst =
          tensileLiteScaleDst(layout, cta, step, wave, group, lane, selector);
      out[dst] = canonical[src];
    }
  }
}

static void fillTensileLiteScaleGroup(
    std::vector<uint8_t> &out, const std::vector<uint8_t> &canonical,
    const Args &a, const TensileLiteScaleLayout &layout, int axisTileBase,
    int cta, int step, int wave, int axisGroup, int kGroup, int group) {
  for (int lane = 0; lane < 64; ++lane) {
    fillTensileLiteScaleLane(out, canonical, a, layout, axisTileBase, cta, step,
                             wave, axisGroup, kGroup, group, lane);
  }
}

static void fillTensileLiteScaleStep(std::vector<uint8_t> &out,
                                     const std::vector<uint8_t> &canonical,
                                     const Args &a,
                                     const TensileLiteScaleLayout &layout,
                                     int wgM, int wgN, int cta, int step) {
  int axisTileBase = tensileLiteAxisBase(a, layout, wgM, wgN);
  for (int wave = 0; wave < layout.blockWaves; ++wave) {
    for (int axisGroup = 0; axisGroup < layout.waveTiles / 2; ++axisGroup) {
      for (int kGroup = 0; kGroup < layout.kScaleGroupsPerStep; ++kGroup) {
        int group = axisGroup * layout.kScaleGroupsPerStep + kGroup;
        fillTensileLiteScaleGroup(out, canonical, a, layout, axisTileBase, cta,
                                  step, wave, axisGroup, kGroup, group);
      }
    }
  }
}

static std::vector<uint8_t>
makeTensileLiteScaleBytes(const std::vector<uint8_t> &canonical, const Args &a,
                          bool isA) {
  TensileLiteScaleLayout layout = makeTensileLiteScaleLayout(a, isA);
  std::vector<uint8_t> out(static_cast<size_t>(layout.mBlocks) *
                           layout.nBlocks * layout.ctaBytes);

  for (int wgM = 0; wgM < layout.mBlocks; ++wgM) {
    for (int wgN = 0; wgN < layout.nBlocks; ++wgN) {
      int cta = wgM * layout.nBlocks + wgN;
      for (int step = 0; step < layout.virtualKSteps; ++step)
        fillTensileLiteScaleStep(out, canonical, a, layout, wgM, wgN, cta,
                                 step);
    }
  }
  return out;
}

struct HostInputs {
  std::vector<uint8_t> a;
  std::vector<uint8_t> b;
  std::vector<uint8_t> bKernel;
  std::vector<uint8_t> aScale;
  std::vector<uint8_t> bScale;
  std::vector<uint8_t> aKernelScale;
  std::vector<uint8_t> bKernelScale;
};

static int inputRows(const Args &a, bool isA) {
  if (isA)
    return a.m;
  return isV9Golden(a) ? a.k : a.n;
}

static int inputCols(const Args &a, bool isA) {
  if (isA)
    return a.k;
  return isV9Golden(a) ? a.n : a.k;
}

static HostInputs makeHostInputs(const Args &a) {
  HostInputs inputs;
  inputs.a = makeInputBytes(inputRows(a, true), inputCols(a, true), a.inputType,
                            a.seed, 0, a.allOnes, a.randInt, a.hpl);
  inputs.b =
      makeInputBytes(inputRows(a, false), inputCols(a, false), a.inputType,
                     a.seed, 1, a.allOnes, a.randInt, a.hpl);
  if (isMXFP4(a.inputType)) {
    inputs.aScale = makeMXFP4ScaleBytes(a.m, a.k, a.seed, 2, a.allOnes);
    inputs.bScale = makeMXFP4ScaleBytes(a.n, a.k, a.seed, 3, a.allOnes);
    if (a.mxfp4InputLayout == MXFP4InputLayout::AITER) {
      inputs.bKernel = makeAITERBBytes(inputs.b, a);
      inputs.aKernelScale = makeAITERScaleBytes(inputs.aScale, a.m, a);
      inputs.bKernelScale = makeAITERScaleBytes(inputs.bScale, a.n, a);
    } else if (a.scaleLayout == ScaleLayout::TensileLite) {
      inputs.aKernelScale = makeTensileLiteScaleBytes(inputs.aScale, a, true);
      inputs.bKernelScale = makeTensileLiteScaleBytes(inputs.bScale, a, false);
    } else {
      inputs.aKernelScale = inputs.aScale;
      inputs.bKernelScale = inputs.bScale;
    }
  }
  return inputs;
}

static uint32_t getMXFP4CodeMask(const std::vector<uint8_t> &bytes) {
  uint32_t mask = 0;
  for (uint8_t packed : bytes) {
    mask |= 1u << (packed & 0xfu);
    mask |= 1u << (packed >> 4);
  }
  return mask;
}

static uint32_t getMXFP4ScaleMask(const std::vector<uint8_t> &bytes) {
  uint32_t mask = 0;
  for (uint8_t value : bytes) {
    if (value < 124 || value > 127)
      die("random MXFP4 scale outside test domain");
    mask |= 1u << (value - 124);
  }
  return mask;
}

static void validateRandomAITERInputs(const HostInputs &inputs, const Args &a) {
  if (!a.checkOutput || a.allOnes ||
      a.mxfp4InputLayout != MXFP4InputLayout::AITER)
    return;
  if (getMXFP4CodeMask(inputs.a) != 0xffffu)
    die("random AITER A did not cover all MXFP4 codes");
  if (getMXFP4CodeMask(inputs.b) != 0xffffu)
    die("random AITER B did not cover all MXFP4 codes");
  if (getMXFP4ScaleMask(inputs.aScale) != 0xfu)
    die("random AITER A scales did not cover all values");
  if (getMXFP4ScaleMask(inputs.bScale) != 0xfu)
    die("random AITER B scales did not cover all values");
  std::printf("input_check: passed mode=random a_codes=16 b_codes=16 "
              "a_scale_values=4 b_scale_values=4 reference=canonical "
              "upload=aiter-preshuffled\n");
}

static uint16_t readU16(const std::vector<uint8_t> &bytes, size_t element) {
  uint16_t value = 0;
  std::memcpy(&value, bytes.data() + element * sizeof(value), sizeof(value));
  return value;
}

static float readDenseInput(const std::vector<uint8_t> &bytes, size_t element,
                            InputType type) {
  uint16_t raw = readU16(bytes, element);
  return type == InputType::BF16 ? bf16ToFloat(raw) : halfToFloat(raw);
}

static float readMXFP4Input(const std::vector<uint8_t> &bytes, size_t element) {
  uint8_t packed = bytes[element / 2];
  uint8_t code = element % 2 == 0 ? (packed & 0xf) : (packed >> 4);
  return mxfp4CodeToFloat(code);
}

static float readInputElement(const HostInputs &inputs, const Args &a, bool isA,
                              int row, int kIndex) {
  int rows = isA ? a.m : a.n;
  const std::vector<uint8_t> &bytes = isA ? inputs.a : inputs.b;
  size_t element = !isA && isV9Golden(a)
                       ? static_cast<size_t>(kIndex) * a.n + row
                       : static_cast<size_t>(row) * a.k + kIndex;
  if (!isMXFP4(a.inputType))
    return readDenseInput(bytes, element, a.inputType);

  const std::vector<uint8_t> &scales = isA ? inputs.aScale : inputs.bScale;
  uint8_t scale = scales[static_cast<size_t>(kIndex / 32) * rows + row];
  return readMXFP4Input(bytes, element) * e8m0ToFloat(scale);
}

static float computeExpectedElement(const HostInputs &inputs, const Args &a,
                                    int m, int n) {
  float acc = 0.0f;
  for (int k = 0; k < a.k; ++k) {
    float lhs = readInputElement(inputs, a, true, m, k);
    float rhs = readInputElement(inputs, a, false, n, k);
    acc += lhs * rhs;
  }
  return acc;
}

struct DeviceBuffers {
  void *deviceA = nullptr;
  void *deviceB = nullptr;
  void *deviceAScale = nullptr;
  void *deviceBScale = nullptr;
  void *deviceC = nullptr;
  void *deviceFinalC = nullptr;
  void *deviceStreamKScratch = nullptr;
  void *deviceStreamKCounters = nullptr;
  size_t cBytes = 0;
  size_t streamKScratchBytes = 0;
  size_t streamKCounterBytes = 0;
  int cElements = 0;
  size_t streamKCounterElements = 0;
};

static DeviceBuffers prepareDeviceBuffers(const Args &a,
                                          const HostInputs &inputs) {
  DeviceBuffers b;
  const std::vector<uint8_t> &kernelB =
      inputs.bKernel.empty() ? inputs.b : inputs.bKernel;
  b.cElements = getOutputElementCount(a);
  b.cBytes = checkedSizeProduct(static_cast<size_t>(b.cElements),
                                a.cType == CType::F32 ? sizeof(float)
                                                      : sizeof(uint16_t),
                                "output buffer size overflow");
  checkHip(hipMalloc(&b.deviceA, inputs.a.size()), "hipMalloc A");
  checkHip(hipMalloc(&b.deviceB, kernelB.size()), "hipMalloc B");
  if (isMXFP4(a.inputType)) {
    checkHip(hipMalloc(&b.deviceAScale, inputs.aKernelScale.size()),
             "hipMalloc A scale");
    checkHip(hipMalloc(&b.deviceBScale, inputs.bKernelScale.size()),
             "hipMalloc B scale");
  }
  checkHip(hipMalloc(&b.deviceC, b.cBytes), "hipMalloc C");
  if (needsAITEROutputConversion(a))
    checkHip(hipMalloc(&b.deviceFinalC, b.cBytes), "hipMalloc final C");
  if (isStreamK(a)) {
    StreamKWorkspaceSizes sizes = getStreamKWorkspaceSizes(a);
    b.streamKScratchBytes = sizes.scratchBytes;
    b.streamKCounterElements = sizes.counterElements;
    b.streamKCounterBytes = sizes.counterBytes;
    checkHip(hipMalloc(&b.deviceStreamKScratch, b.streamKScratchBytes),
             "hipMalloc Stream-K scratch");
    checkHip(hipMalloc(&b.deviceStreamKCounters, b.streamKCounterBytes),
             "hipMalloc Stream-K counters");
    checkHip(hipMemset(b.deviceStreamKScratch, 0, b.streamKScratchBytes),
             "hipMemset Stream-K scratch");
    checkHip(hipMemset(b.deviceStreamKCounters, 0, b.streamKCounterBytes),
             "hipMemset Stream-K counters");
  }
  checkHip(hipMemcpy(b.deviceA, inputs.a.data(), inputs.a.size(),
                     hipMemcpyHostToDevice),
           "hipMemcpy A");
  checkHip(hipMemcpy(b.deviceB, kernelB.data(), kernelB.size(),
                     hipMemcpyHostToDevice),
           "hipMemcpy B");
  if (isMXFP4(a.inputType)) {
    checkHip(hipMemcpy(b.deviceAScale, inputs.aKernelScale.data(),
                       inputs.aKernelScale.size(), hipMemcpyHostToDevice),
             "hipMemcpy A scale");
    checkHip(hipMemcpy(b.deviceBScale, inputs.bKernelScale.data(),
                       inputs.bKernelScale.size(), hipMemcpyHostToDevice),
             "hipMemcpy B scale");
  }
  checkHip(hipMemset(b.deviceC, 0, b.cBytes), "hipMemset C");
  if (b.deviceFinalC)
    checkHip(hipMemset(b.deviceFinalC, 0, b.cBytes), "hipMemset final C");
  return b;
}

static void freeDeviceBuffers(DeviceBuffers &b) {
  checkHip(hipFree(b.deviceA), "hipFree A");
  checkHip(hipFree(b.deviceB), "hipFree B");
  if (b.deviceAScale)
    checkHip(hipFree(b.deviceAScale), "hipFree A scale");
  if (b.deviceBScale)
    checkHip(hipFree(b.deviceBScale), "hipFree B scale");
  checkHip(hipFree(b.deviceC), "hipFree C");
  if (b.deviceFinalC)
    checkHip(hipFree(b.deviceFinalC), "hipFree final C");
  if (b.deviceStreamKScratch)
    checkHip(hipFree(b.deviceStreamKScratch), "hipFree Stream-K scratch");
  if (b.deviceStreamKCounters)
    checkHip(hipFree(b.deviceStreamKCounters), "hipFree Stream-K counters");
}

static void launchAITEROutputConversion(const DeviceBuffers &b, const Args &a) {
  if (!needsAITEROutputConversion(a))
    return;
  constexpr int threads = 256;
  int blocks = 1 + (b.cElements - 1) / threads;
  TilePackedOutputPlan plan = makeTilePackedOutputPlan(a);
  if (plan.elements != b.cElements)
    die("AITER conversion output element count mismatch");
  if (a.cType == CType::F32) {
    materializeRowMajorOutput<float>
        <<<blocks, threads>>>(static_cast<const float *>(b.deviceC),
                              static_cast<float *>(b.deviceFinalC), plan);
  } else {
    materializeRowMajorOutput<uint16_t>
        <<<blocks, threads>>>(static_cast<const uint16_t *>(b.deviceC),
                              static_cast<uint16_t *>(b.deviceFinalC), plan);
  }
  checkHip(hipGetLastError(), "launch AITER output conversion");
}

static void copyAndCheckOutput(void *deviceC, size_t cBytes, int cElements,
                               OutputLayout layout, const Args &a,
                               const HostInputs &inputs) {
  if (!a.checkOutput)
    return;
  if (a.cType == CType::F16 || a.cType == CType::BF16) {
    std::vector<uint16_t> hostC(cElements);
    checkHip(hipMemcpy(hostC.data(), deviceC, cBytes, hipMemcpyDeviceToHost),
             "hipMemcpy C");
    auto readValue = [&](int i) {
      return a.cType == CType::F16 ? halfToFloat(hostC[i])
                                   : bf16ToFloat(hostC[i]);
    };
    if (layout == OutputLayout::ColumnMajor) {
      validateColumnMajorOutput(cElements, a, inputs, readValue);
      return;
    }
    if (layout == OutputLayout::RowMajor) {
      validateRowMajorOutput(cElements, a, inputs, readValue);
      return;
    }
    validateTilePackedOutput(cElements, a, inputs, readValue);
    return;
  }
  std::vector<float> hostC(cElements);
  checkHip(hipMemcpy(hostC.data(), deviceC, cBytes, hipMemcpyDeviceToHost),
           "hipMemcpy C");
  if (layout == OutputLayout::ColumnMajor) {
    validateColumnMajorOutput(cElements, a, inputs,
                              [&](int i) { return hostC[i]; });
    return;
  }
  if (layout == OutputLayout::RowMajor) {
    validateRowMajorOutput(cElements, a, inputs,
                           [&](int i) { return hostC[i]; });
    return;
  }
  validateTilePackedOutput(cElements, a, inputs,
                           [&](int i) { return hostC[i]; });
}

static void checkStreamKCounters(const DeviceBuffers &b, const Args &a) {
  if (!isStreamK(a))
    return;
  std::vector<uint32_t> counters(b.streamKCounterElements);
  checkHip(hipMemcpy(counters.data(), b.deviceStreamKCounters,
                     b.streamKCounterBytes, hipMemcpyDeviceToHost),
           "hipMemcpy Stream-K counters");
  for (size_t i = 0; i < counters.size(); ++i) {
    if (counters[i] == 0)
      continue;
    std::fprintf(stderr, "Stream-K counter %zu did not reset: %u\n", i,
                 counters[i]);
    std::exit(2);
  }
  std::printf("streamk_counter_check: passed\n");
}

struct LaunchShape {
  int gridX = 1;
  int gridY = 1;
  int blockThreads = 1;
  int wavesPerWorkgroup = 1;
  int tripCount = 0;
  int displayTripCount = 0;
};

static LaunchShape makeLaunchShape(const Args &a) {
  MatmulBlocking blocking = getMatmulBlocking(a);
  LaunchShape shape;
  if (isStreamK(a)) {
    shape.gridX = a.streamKWorkers;
    shape.gridY = 1;
  } else {
    shape.gridX = usesFlattenedGrid(a)
                      ? checkedIntProduct(blocking.blocksX, blocking.blocksY,
                                          "flattened grid size exceeds i32")
                      : blocking.blocksX;
    shape.gridY = usesFlattenedGrid(a) ? 1 : blocking.blocksY;
  }
  shape.blockThreads = blocking.blockThreads;
  shape.wavesPerWorkgroup = blocking.wavesPerWorkgroup;
  shape.tripCount = std::max(blocking.virtualKSteps - 1, 0);
  shape.displayTripCount = usesFlattenedGrid(a)
                               ? std::max((blocking.virtualKSteps - 2) / 2, 0)
                               : shape.tripCount;
  return shape;
}

struct KernelArgStorage {
  std::array<void *, 4> matmulArgs;
  std::array<void *, 6> mxfp4Args;
  std::array<void *, 8> v9Args;
  std::array<void *, 12> tlxArgs;
  std::array<void *, 6> streamKArgs;
  void **active = nullptr;
  int strideAM = 0;
  int strideBK = 0;
  int strideCM = 0;
  int packedKStride = 0;
  int scaleKStride = 0;
};

static void initKernelArgStorage(KernelArgStorage &storage, Args &a,
                                 DeviceBuffers &buffers, int &tripCount) {
  storage.strideAM = a.k;
  storage.strideBK = a.n;
  storage.strideCM = a.n;
  storage.packedKStride =
      isMXFP4(a.inputType) ? divExact(a.k, 2, "bad MXFP4 packed K stride") : 0;
  storage.scaleKStride =
      isMXFP4(a.inputType) ? divExact(a.k, 32, "bad MXFP4 scale stride") : 0;
  storage.matmulArgs = {&buffers.deviceA, &buffers.deviceB, &buffers.deviceC,
                        &tripCount};
  storage.mxfp4Args = {&buffers.deviceA,      &buffers.deviceB,
                       &buffers.deviceC,      &buffers.deviceAScale,
                       &buffers.deviceBScale, &tripCount};
  storage.v9Args = {
      &buffers.deviceA,  &buffers.deviceB,  &buffers.deviceC, &a.m, &a.n,
      &storage.strideAM, &storage.strideBK, &storage.strideCM};
  storage.tlxArgs = {&buffers.deviceA,
                     &buffers.deviceB,
                     &buffers.deviceC,
                     &buffers.deviceAScale,
                     &buffers.deviceBScale,
                     &a.m,
                     &a.n,
                     &storage.packedKStride,
                     &storage.packedKStride,
                     &storage.strideCM,
                     &storage.scaleKStride,
                     &storage.scaleKStride};
  storage.streamKArgs = {&buffers.deviceA,
                         &buffers.deviceB,
                         &buffers.deviceC,
                         &buffers.deviceStreamKScratch,
                         &buffers.deviceStreamKCounters,
                         &a.streamKWorkers};
  if (isStreamK(a)) {
    storage.active = storage.streamKArgs.data();
    return;
  }
  if (isTLXMXFP(a)) {
    storage.active = storage.tlxArgs.data();
    return;
  }
  if (isV9Golden(a)) {
    storage.active = storage.v9Args.data();
    return;
  }
  storage.active = isMXFP4(a.inputType) ? storage.mxfp4Args.data()
                                        : storage.matmulArgs.data();
}

} // namespace

#ifndef WAVE_MATMUL_CALIBRATE_RUNNER_NO_MAIN
int main(int argc, char **argv) {
  Args a = parseArgs(argc, argv);

  LaunchShape launch = makeLaunchShape(a);

  hipDeviceProp_t props;
  checkHip(hipGetDeviceProperties(&props, 0), "hipGetDeviceProperties");
  double clockMHz = props.clockRate / 1000.0;
  double clockHz = props.clockRate * 1000.0;

  hipModule_t mod = nullptr;
  hipFunction_t kfn = nullptr;
  checkHip(hipModuleLoad(&mod, a.hsaco), "hipModuleLoad");
  checkHip(hipModuleGetFunction(&kfn, mod, a.kernel), "hipModuleGetFunction");

  HostInputs inputs = makeHostInputs(a);
  validateRandomAITERInputs(inputs, a);
  DeviceBuffers buffers = prepareDeviceBuffers(a, inputs);
  validateAITEROutputMapping(buffers.cElements, a);
  KernelArgStorage kernelArgs;
  initKernelArgStorage(kernelArgs, a, buffers, launch.tripCount);

  auto launchGemm = [&](const char *what) {
    checkHip(hipModuleLaunchKernel(kfn, launch.gridX, launch.gridY, 1,
                                   launch.blockThreads, 1, 1, a.dynamicLdsBytes,
                                   nullptr, kernelArgs.active, nullptr),
             what);
  };
  for (int i = 0; i < a.warmupIters; ++i) {
    launchGemm("warmup launch");
    launchAITEROutputConversion(buffers, a);
  }
  checkHip(hipDeviceSynchronize(), "warmup sync");

  hipEvent_t start, stop;
  checkHip(hipEventCreate(&start), "event create start");
  checkHip(hipEventCreate(&stop), "event create stop");
  checkHip(hipEventRecord(start, nullptr), "event record start");
  for (int i = 0; i < a.iters; ++i) {
    launchGemm("timed launch");
    launchAITEROutputConversion(buffers, a);
  }
  checkHip(hipEventRecord(stop, nullptr), "event record stop");
  checkHip(hipEventSynchronize(stop), "event sync stop");

  float elapsedMs = 0.0f;
  checkHip(hipEventElapsedTime(&elapsedMs, start, stop), "event elapsed");
  float kernelOnlyElapsedMs = 0.0f;
  if (needsAITEROutputConversion(a)) {
    checkHip(hipEventRecord(start, nullptr), "kernel event record start");
    for (int i = 0; i < a.iters; ++i)
      launchGemm("kernel-only timed launch");
    checkHip(hipEventRecord(stop, nullptr), "kernel event record stop");
    checkHip(hipEventSynchronize(stop), "kernel event sync stop");
    checkHip(hipEventElapsedTime(&kernelOnlyElapsedMs, start, stop),
             "kernel event elapsed");
  }
  double perLaunchUs = (elapsedMs * 1000.0) / a.iters;
  double perLaunchCycles = perLaunchUs * (clockHz / 1e6);

  std::printf("device: %s (%s) shader_clock_mhz=%.0f\n", props.name,
              props.gcnArchName, clockMHz);
  std::printf("kernel: %s\n", a.kernel);
  std::printf("shape: m=%d n=%d k=%d bm=%d bn=%d wave_m_tiles=%d "
              "wave_n_tiles=%d wave_k_tiles=%d wave_size=%d input_type=%s "
              "c_type=%s kernel_abi=%s output_layout=%s scale_layout=%s "
              "mxfp4_input_layout=%s input_mode=%s\n",
              a.m, a.n, a.k, a.bm, a.bn, a.waveMTiles, a.waveNTiles,
              a.waveKTiles, a.waveSize, getInputTypeName(a.inputType),
              getCTypeName(a.cType), getKernelABIName(a.kernelABI),
              getOutputLayoutName(getEffectiveOutputLayout(a)),
              getScaleLayoutName(a.scaleLayout),
              getMXFP4InputLayoutName(a.mxfp4InputLayout), getInputModeName(a));
  std::printf("output_contract: kernel=%s final=%s conversion=%s\n",
              getOutputLayoutName(getEffectiveOutputLayout(a)),
              getOutputLayoutName(getFinalOutputLayout(a)),
              needsAITEROutputConversion(a) ? "device" : "none");
  std::printf("grid: %d,%d,1 block: %d,1,1 waves_per_workgroup=%d\n",
              launch.gridX, launch.gridY, launch.blockThreads,
              launch.wavesPerWorkgroup);
  std::printf("loop_trip_count: %d\n", launch.displayTripCount);
  std::printf("iters: %d\n", a.iters);
  std::printf("timing_scope: %s\n", needsAITEROutputConversion(a)
                                        ? "gemm+device-output-conversion"
                                        : "gemm");
  if (needsAITEROutputConversion(a))
    std::printf("kernel_only_per_launch_us: %.3f\n",
                kernelOnlyElapsedMs * 1000.0 / a.iters);
  std::printf("total_ms: %.3f\n", elapsedMs);
  std::printf("per_launch_us: %.3f\n", perLaunchUs);
  std::printf("per_launch_cycles_wallclock: %.0f\n", perLaunchCycles);
  void *finalOutput =
      buffers.deviceFinalC ? buffers.deviceFinalC : buffers.deviceC;
  copyAndCheckOutput(finalOutput, buffers.cBytes, buffers.cElements,
                     getFinalOutputLayout(a), a, inputs);
  checkStreamKCounters(buffers, a);
  freeDeviceBuffers(buffers);
  return 0;
}
#endif
