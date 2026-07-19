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
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

namespace {

enum class CType { F32, F16, BF16 };
enum class InputType { F16, BF16, MXFP4 };
enum class KernelABI { Matmul, V9Golden, TLXMXFP };
enum class AccumulatorLayout { Automatic, Wmma, Mfma };
enum class OutputLayout { Automatic, TilePacked, RowMajor, ColumnMajor };
enum class ScaleLayout { Canonical, TensileLite };

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
  int seed = 0;
  bool checkOutput = true;
  bool allOnes = false;
  bool randInt = false;
  ScaleLayout scaleLayout = ScaleLayout::Canonical;
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
      "  --kernel-abi matmul|v9-golden|tlx-mxfp  kernel argument ABI\n"
      "  --accumulator-layout automatic|wmma|mfma\n"
      "  --output-layout automatic|tile-packed|row-major|column-major\n"
      "  --dynamic-lds N        dynamic LDS bytes (default 0)\n"
      "  --iters N              launch iterations (default 1000)\n"
      "  --warmup N             warmup launches (default 10)\n"
      "  --seed N               deterministic input seed (default 0)\n"
      "  --scale-layout canonical|tensilelite  MXFP4 scale upload layout\n"
      "  --all-ones             fill A/B with ones and MXFP4 scales with 1\n"
      "  --rand-int             match hipBLASLt f16/bf16 rand_int inputs\n"
      "  --no-check             skip random-output check\n");
}

static int parseInt(const char *s) {
  char *end = nullptr;
  long v = std::strtol(s, &end, 10);
  if (!end || *end != '\0')
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
  die("bad --kernel-abi; expected matmul, v9-golden, or tlx-mxfp");
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
    {"--dynamic-lds", setDynamicLds},
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
  if (a.dynamicLdsBytes < 0)
    die("dynamic LDS bytes must be non-negative");
  if (a.inputType == InputType::MXFP4 && a.waveSize != 64)
    die("MXFP4 calibration expects wave-size 64");
  if (a.scaleLayout == ScaleLayout::TensileLite &&
      a.inputType != InputType::MXFP4)
    die("tensilelite scale layout requires MXFP4 input");
  if (a.allOnes && a.randInt)
    die("--all-ones and --rand-int are mutually exclusive");
  if (a.randInt && a.inputType == InputType::MXFP4)
    die("--rand-int supports f16/bf16 inputs only");
  validateV9GoldenArgs(a);
  validateTLXMXFPArgs(a);
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

static uint8_t randomMXFP4Code(uint32_t &state) {
  return ((nextRand(state) >> 31) & 1u) ? 0x2 : 0x4;
}

static float mxfp4CodeToFloat(uint8_t code) {
  if (code == 0x2)
    return 1.0f;
  if (code == 0x4)
    return 2.0f;
  die("unsupported random MXFP4 code");
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

static AccumulatorLayout getEffectiveAccumulatorLayout(const Args &a) {
  if (a.accumulatorLayout != AccumulatorLayout::Automatic)
    return a.accumulatorLayout;
  return a.waveSize == 64 ? AccumulatorLayout::Mfma : AccumulatorLayout::Wmma;
}

static int getAccumulatorRow(const Args &a, int lane, int laneValue,
                             int valuesPerLane) {
  // WMMA interleaves row parity; MFMA assigns contiguous rows per lane group.
  if (getEffectiveAccumulatorLayout(a) == AccumulatorLayout::Wmma) {
    if (a.waveSize != 32)
      die("WMMA output check requires wave32");
    return (lane / 16) + 2 * laneValue;
  }
  if (a.waveSize != 32 && a.waveSize != 64)
    die("MFMA output check requires wave32 or wave64");
  return (lane / 16) * valuesPerLane + laneValue;
}

static OutputCoordinate getOutputCoordinate(const Args &a, int index) {
  int tilesPerWave = a.waveMTiles * a.waveNTiles;
  int wavesPerWorkgroup = a.bm * a.bn;
  int ctaElems = wavesPerWorkgroup * tilesPerWave * 256;
  int nBlocks = divExact(a.n, 16 * a.bn * a.waveNTiles, "bad N blocking");
  int cta = index / ctaElems;
  int ctaRem = index % ctaElems;
  int wgM = cta / nBlocks;
  int wgN = cta % nBlocks;
  int waveElems = tilesPerWave * 256;
  int waveId = ctaRem / waveElems;
  int waveRem = ctaRem % waveElems;
  int tileId = waveRem / 256;
  int slot = waveRem % 256;
  int mWave = waveId / a.bn;
  int nWave = waveId % a.bn;
  int valuesPerLane = divExact(256, a.waveSize, "bad output wave size");
  int lane = slot / valuesPerLane;
  int laneValue = slot % valuesPerLane;
  int mLane = getAccumulatorRow(a, lane, laneValue, valuesPerLane);
  int mTile =
      wgM * a.bm * a.waveMTiles + mWave * a.waveMTiles + tileId / a.waveNTiles;
  int nTile =
      wgN * a.bn * a.waveNTiles + nWave * a.waveNTiles + tileId % a.waveNTiles;
  return {mTile * 16 + mLane, nTile * 16 + lane % 16};
}

static double computeExpectedOutputSlot(const HostInputs &inputs, const Args &a,
                                        int index) {
  OutputCoordinate coord = getOutputCoordinate(a, index);
  return roundExpectedOutput(
      computeExpectedElement(inputs, a, coord.m, coord.n), a.cType);
}

template <typename ReadFn>
static void validateOutput(int elements, const Args &a,
                           const HostInputs &inputs, ReadFn readValue) {
  if (elements % 256 != 0)
    die("output check expects 16x16 tile-packed output");
  double worst = 0.0;
  int worstIdx = 0;
  for (int tileBase = 0; tileBase < elements; tileBase += 256) {
    for (int slot = 0; slot < 256; ++slot) {
      int index = tileBase + slot;
      double got = static_cast<double>(readValue(index));
      double exp = computeExpectedOutputSlot(inputs, a, index);
      double diff = std::fabs(got - exp);
      if (diff > worst) {
        worst = diff;
        worstIdx = tileBase + slot;
      }
      double limit = 1.0e-2 + 1.0e-3 * std::fabs(exp);
      if (diff > limit) {
        std::fprintf(stderr,
                     "output_check: failed tile=%d slot=%d expected=%.6f "
                     "got=%.6f abs_diff=%.6f tolerance=%.6f\n",
                     tileBase / 256, slot, exp, got, diff, limit);
        std::exit(1);
      }
    }
  }
  std::printf("output_check: passed mode=strict max_abs_diff=%.6f index=%d\n",
              worst, worstIdx);
}

template <typename ReadFn>
static void validateRowMajorOutput(int elements, const Args &a,
                                   const HostInputs &inputs, ReadFn readValue) {
  if (elements != a.m * a.n)
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
  std::printf("output_check: passed mode=strict max_abs_diff=%.6f index=%d\n",
              worst, worstIdx);
}

template <typename ReadFn>
static void validateColumnMajorOutput(int elements, const Args &a,
                                      const HostInputs &inputs,
                                      ReadFn readValue) {
  if (elements != a.m * a.n)
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

static const char *getInputModeName(const Args &a) {
  if (a.allOnes)
    return "all-ones";
  if (a.randInt)
    return "rand-int";
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
  return OutputLayout::TilePacked;
}

static bool usesFlattenedGrid(const Args &a) {
  return isV9Golden(a) || isTLXMXFP(a);
}

static int mmaKTile(const Args &a) {
  if (isMXFP4(a.inputType))
    return 128;
  if (a.waveSize == 64)
    return 32;
  return 16;
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
                                                bool randInt) {
  std::vector<uint8_t> bytes(elements * sizeof(uint16_t));
  if (allOnes) {
    uint16_t bits = oneBits(type);
    for (size_t i = 0; i < elements; ++i)
      std::memcpy(bytes.data() + i * sizeof(bits), &bits, sizeof(bits));
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
                                           bool randInt) {
  size_t elements = static_cast<size_t>(rows) * k;
  if (isMXFP4(type))
    return makeMXFP4InputBytes(elements, seed, stream, allOnes);
  return make16BitInputBytes(elements, k, type, seed, stream, allOnes, randInt);
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

  TensileLiteScaleLayout layout;
  layout.mBlocks = divExact(a.m, 16 * a.bm * a.waveMTiles, "bad M blocking");
  layout.nBlocks = divExact(a.n, 16 * a.bn * a.waveNTiles, "bad N blocking");
  layout.virtualKSteps =
      divExact(a.k, mmaKTile(a) * a.waveKTiles, "bad K blocking");
  layout.blockWaves = isA ? a.bm : a.bn;
  layout.waveTiles = isA ? a.waveMTiles : a.waveNTiles;
  layout.rows = isA ? a.m : a.n;
  layout.kScaleGroupsPerStep = a.waveKTiles / 2;
  layout.groupsPerPartition =
      (layout.waveTiles / 2) * layout.kScaleGroupsPerStep;
  layout.partitionBytes = layout.groupsPerPartition * 256;
  layout.ctaBytes =
      layout.blockWaves * layout.partitionBytes * layout.virtualKSteps;
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
                            a.seed, 0, a.allOnes, a.randInt);
  inputs.b = makeInputBytes(inputRows(a, false), inputCols(a, false),
                            a.inputType, a.seed, 1, a.allOnes, a.randInt);
  if (isMXFP4(a.inputType)) {
    inputs.aScale = makeMXFP4ScaleBytes(a.m, a.k, a.seed, 2, a.allOnes);
    inputs.bScale = makeMXFP4ScaleBytes(a.n, a.k, a.seed, 3, a.allOnes);
    if (a.scaleLayout == ScaleLayout::TensileLite) {
      inputs.aKernelScale = makeTensileLiteScaleBytes(inputs.aScale, a, true);
      inputs.bKernelScale = makeTensileLiteScaleBytes(inputs.bScale, a, false);
    } else {
      inputs.aKernelScale = inputs.aScale;
      inputs.bKernelScale = inputs.bScale;
    }
  }
  return inputs;
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
  int cElements = 0;
  size_t cBytes = 0;
};

static DeviceBuffers prepareDeviceBuffers(const Args &a,
                                          const HostInputs &inputs) {
  DeviceBuffers b;
  b.cElements = a.m * a.n;
  b.cBytes = static_cast<size_t>(b.cElements) *
             (a.cType == CType::F32 ? sizeof(float) : sizeof(uint16_t));
  checkHip(hipMalloc(&b.deviceA, inputs.a.size()), "hipMalloc A");
  checkHip(hipMalloc(&b.deviceB, inputs.b.size()), "hipMalloc B");
  if (isMXFP4(a.inputType)) {
    checkHip(hipMalloc(&b.deviceAScale, inputs.aKernelScale.size()),
             "hipMalloc A scale");
    checkHip(hipMalloc(&b.deviceBScale, inputs.bKernelScale.size()),
             "hipMalloc B scale");
  }
  checkHip(hipMalloc(&b.deviceC, b.cBytes), "hipMalloc C");
  checkHip(hipMemcpy(b.deviceA, inputs.a.data(), inputs.a.size(),
                     hipMemcpyHostToDevice),
           "hipMemcpy A");
  checkHip(hipMemcpy(b.deviceB, inputs.b.data(), inputs.b.size(),
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
}

static void copyAndCheckOutput(void *deviceC, size_t cBytes, int cElements,
                               const Args &a, const HostInputs &inputs) {
  if (!a.checkOutput)
    return;
  OutputLayout layout = getEffectiveOutputLayout(a);
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
    validateOutput(cElements, a, inputs, readValue);
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
  validateOutput(cElements, a, inputs, [&](int i) { return hostC[i]; });
}

struct LaunchShape {
  int gridX = 1;
  int gridY = 1;
  int blockThreads = 1;
  int tripCount = 0;
  int displayTripCount = 0;
};

static LaunchShape makeLaunchShape(const Args &a) {
  int blocksX = divExact(a.m, 16 * a.bm * a.waveMTiles, "bad M blocking");
  int blocksY = divExact(a.n, 16 * a.bn * a.waveNTiles, "bad N blocking");
  int virtualKSteps =
      divExact(a.k, mmaKTile(a) * a.waveKTiles, "bad K blocking");
  LaunchShape shape;
  shape.gridX = usesFlattenedGrid(a) ? blocksX * blocksY : blocksX;
  shape.gridY = usesFlattenedGrid(a) ? 1 : blocksY;
  shape.blockThreads = a.bm * a.bn * a.waveSize;
  shape.tripCount = std::max(virtualKSteps - 1, 0);
  shape.displayTripCount = usesFlattenedGrid(a)
                               ? std::max((virtualKSteps - 2) / 2, 0)
                               : shape.tripCount;
  return shape;
}

struct KernelArgStorage {
  std::array<void *, 4> matmulArgs;
  std::array<void *, 6> mxfp4Args;
  std::array<void *, 8> v9Args;
  std::array<void *, 12> tlxArgs;
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
  DeviceBuffers buffers = prepareDeviceBuffers(a, inputs);
  KernelArgStorage kernelArgs;
  initKernelArgStorage(kernelArgs, a, buffers, launch.tripCount);

  for (int i = 0; i < a.warmupIters; ++i)
    checkHip(hipModuleLaunchKernel(kfn, launch.gridX, launch.gridY, 1,
                                   launch.blockThreads, 1, 1, a.dynamicLdsBytes,
                                   nullptr, kernelArgs.active, nullptr),
             "warmup launch");
  checkHip(hipDeviceSynchronize(), "warmup sync");

  hipEvent_t start, stop;
  checkHip(hipEventCreate(&start), "event create start");
  checkHip(hipEventCreate(&stop), "event create stop");
  checkHip(hipEventRecord(start, nullptr), "event record start");
  for (int i = 0; i < a.iters; ++i)
    checkHip(hipModuleLaunchKernel(kfn, launch.gridX, launch.gridY, 1,
                                   launch.blockThreads, 1, 1, a.dynamicLdsBytes,
                                   nullptr, kernelArgs.active, nullptr),
             "timed launch");
  checkHip(hipEventRecord(stop, nullptr), "event record stop");
  checkHip(hipEventSynchronize(stop), "event sync stop");

  float elapsedMs = 0.0f;
  checkHip(hipEventElapsedTime(&elapsedMs, start, stop), "event elapsed");
  double perLaunchUs = (elapsedMs * 1000.0) / a.iters;
  double perLaunchCycles = perLaunchUs * (clockHz / 1e6);

  std::printf("device: %s (%s) shader_clock_mhz=%.0f\n", props.name,
              props.gcnArchName, clockMHz);
  std::printf("kernel: %s\n", a.kernel);
  std::printf("shape: m=%d n=%d k=%d bm=%d bn=%d wave_m_tiles=%d "
              "wave_n_tiles=%d wave_k_tiles=%d wave_size=%d input_type=%s "
              "c_type=%s kernel_abi=%s output_layout=%s scale_layout=%s "
              "input_mode=%s\n",
              a.m, a.n, a.k, a.bm, a.bn, a.waveMTiles, a.waveNTiles,
              a.waveKTiles, a.waveSize, getInputTypeName(a.inputType),
              getCTypeName(a.cType), getKernelABIName(a.kernelABI),
              getOutputLayoutName(getEffectiveOutputLayout(a)),
              getScaleLayoutName(a.scaleLayout), getInputModeName(a));
  std::printf("grid: %d,%d,1 block: %d,1,1 waves_per_workgroup=%d\n",
              launch.gridX, launch.gridY, launch.blockThreads, a.bm * a.bn);
  std::printf("loop_trip_count: %d\n", launch.displayTripCount);
  std::printf("iters: %d\n", a.iters);
  std::printf("total_ms: %.3f\n", elapsedMs);
  std::printf("per_launch_us: %.3f\n", perLaunchUs);
  std::printf("per_launch_cycles_wallclock: %.0f\n", perLaunchCycles);
  copyAndCheckOutput(buffers.deviceC, buffers.cBytes, buffers.cElements, a,
                     inputs);
  freeDeviceBuffers(buffers);
  return 0;
}
#endif
