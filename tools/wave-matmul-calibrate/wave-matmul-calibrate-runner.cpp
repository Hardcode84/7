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

enum class CType { F32, F16 };
enum class InputType { F16, BF16, MXFP4 };
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
  int iters = 1000;
  int warmupIters = 10;
  int dynamicLdsBytes = 0;
  int seed = 0;
  bool checkOutput = true;
  bool allOnes = false;
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
      "  --c-type f32|f16       output element type (default f32)\n"
      "  --dynamic-lds N        dynamic LDS bytes (default 0)\n"
      "  --iters N              launch iterations (default 1000)\n"
      "  --warmup N             warmup launches (default 10)\n"
      "  --seed N               deterministic input seed (default 0)\n"
      "  --scale-layout canonical|tensilelite  MXFP4 scale upload layout\n"
      "  --all-ones             fill A/B with ones and MXFP4 scales with 1\n"
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
  die("bad --c-type; expected f32 or f16");
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
  return value;
}

static double computeExpectedOutputSlot(const HostInputs &inputs, const Args &a,
                                        int index) {
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
  int mTile =
      wgM * a.bm * a.waveMTiles + mWave * a.waveMTiles + tileId / a.waveNTiles;
  int nTile =
      wgN * a.bn * a.waveNTiles + nWave * a.waveNTiles + tileId % a.waveNTiles;
  int m = mTile * 16 + slot / 16;
  int n = nTile * 16 + slot % 16;
  return roundExpectedOutput(computeExpectedElement(inputs, a, m, n), a.cType);
}

template <typename ReadFn>
static void validateOutput(int elements, const Args &a,
                           const HostInputs &inputs, ReadFn readValue) {
  if (elements % 256 != 0)
    die("output check expects 16x16 tile-packed output");
  double worst = 0.0;
  int worstIdx = 0;
  for (int tileBase = 0; tileBase < elements; tileBase += 256) {
    std::vector<double> actual(256);
    std::vector<double> expected(256);
    for (int slot = 0; slot < 256; ++slot) {
      int index = tileBase + slot;
      actual[slot] = static_cast<double>(readValue(index));
      expected[slot] = computeExpectedOutputSlot(inputs, a, index);
    }
    std::sort(actual.begin(), actual.end());
    std::sort(expected.begin(), expected.end());
    for (int slot = 0; slot < 256; ++slot) {
      double got = actual[slot];
      double exp = expected[slot];
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
  std::printf("output_check: passed max_abs_diff=%.6f index=%d\n", worst,
              worstIdx);
}

static const char *getCTypeName(CType type) {
  return type == CType::F16 ? "f16" : "f32";
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

static const char *getScaleLayoutName(ScaleLayout layout) {
  return layout == ScaleLayout::TensileLite ? "tensilelite" : "canonical";
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

static int mmaKTile(const Args &a) {
  if (isMXFP4(a.inputType))
    return 128;
  if (a.waveSize == 64)
    return 32;
  return 16;
}

static std::vector<uint8_t> makeInputBytes(int rows, int k, InputType type,
                                           int seed, int stream, bool allOnes) {
  size_t elements = static_cast<size_t>(rows) * k;
  if (isMXFP4(type)) {
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

  std::vector<uint8_t> bytes(elements * sizeof(uint16_t));
  if (allOnes) {
    uint16_t bits = oneBits(type);
    for (size_t i = 0; i < elements; ++i)
      std::memcpy(bytes.data() + i * sizeof(bits), &bits, sizeof(bits));
    return bytes;
  }

  uint32_t state = randState(seed, stream);
  for (size_t i = 0; i < elements; ++i) {
    float value = randomInputValue(state);
    uint16_t bits = type == InputType::BF16 ? floatToBF16Bits(value)
                                            : floatToHalfBits(value);
    std::memcpy(bytes.data() + i * sizeof(bits), &bits, sizeof(bits));
  }
  return bytes;
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

static HostInputs makeHostInputs(const Args &a) {
  HostInputs inputs;
  inputs.a = makeInputBytes(a.m, a.k, a.inputType, a.seed, 0, a.allOnes);
  inputs.b = makeInputBytes(a.n, a.k, a.inputType, a.seed, 1, a.allOnes);
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
  size_t element = static_cast<size_t>(row) * a.k + kIndex;
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
             (a.cType == CType::F16 ? sizeof(uint16_t) : sizeof(float));
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
  if (a.cType == CType::F16) {
    std::vector<uint16_t> hostC(cElements);
    checkHip(hipMemcpy(hostC.data(), deviceC, cBytes, hipMemcpyDeviceToHost),
             "hipMemcpy C");
    validateOutput(cElements, a, inputs,
                   [&](int i) { return halfToFloat(hostC[i]); });
    return;
  }
  std::vector<float> hostC(cElements);
  checkHip(hipMemcpy(hostC.data(), deviceC, cBytes, hipMemcpyDeviceToHost),
           "hipMemcpy C");
  validateOutput(cElements, a, inputs, [&](int i) { return hostC[i]; });
}

} // namespace

int main(int argc, char **argv) {
  Args a = parseArgs(argc, argv);

  int blocksX = divExact(a.m, 16 * a.bm * a.waveMTiles, "bad M blocking");
  int blocksY = divExact(a.n, 16 * a.bn * a.waveNTiles, "bad N blocking");
  int blockThreads = a.bm * a.bn * a.waveSize;
  int virtualKSteps =
      divExact(a.k, mmaKTile(a) * a.waveKTiles, "bad K blocking");
  int tripCount = std::max(virtualKSteps - 1, 0);

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
  std::array<void *, 4> kernelArgs = {&buffers.deviceA, &buffers.deviceB,
                                      &buffers.deviceC, &tripCount};
  std::array<void *, 6> mxfp4KernelArgs = {
      &buffers.deviceA,      &buffers.deviceB,      &buffers.deviceC,
      &buffers.deviceAScale, &buffers.deviceBScale, &tripCount};
  void **activeKernelArgs =
      isMXFP4(a.inputType) ? mxfp4KernelArgs.data() : kernelArgs.data();

  for (int i = 0; i < a.warmupIters; ++i)
    checkHip(hipModuleLaunchKernel(kfn, blocksX, blocksY, 1, blockThreads, 1, 1,
                                   a.dynamicLdsBytes, nullptr, activeKernelArgs,
                                   nullptr),
             "warmup launch");
  checkHip(hipDeviceSynchronize(), "warmup sync");

  hipEvent_t start, stop;
  checkHip(hipEventCreate(&start), "event create start");
  checkHip(hipEventCreate(&stop), "event create stop");
  checkHip(hipEventRecord(start, nullptr), "event record start");
  for (int i = 0; i < a.iters; ++i)
    checkHip(hipModuleLaunchKernel(kfn, blocksX, blocksY, 1, blockThreads, 1, 1,
                                   a.dynamicLdsBytes, nullptr, activeKernelArgs,
                                   nullptr),
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
              "c_type=%s scale_layout=%s input_mode=%s\n",
              a.m, a.n, a.k, a.bm, a.bn, a.waveMTiles, a.waveNTiles,
              a.waveKTiles, a.waveSize, getInputTypeName(a.inputType),
              getCTypeName(a.cType), getScaleLayoutName(a.scaleLayout),
              a.allOnes ? "all-ones" : "random");
  std::printf("grid: %d,%d,1 block: %d,1,1 waves_per_workgroup=%d\n", blocksX,
              blocksY, blockThreads, a.bm * a.bn);
  std::printf("loop_trip_count: %d\n", tripCount);
  std::printf("iters: %d\n", a.iters);
  std::printf("total_ms: %.3f\n", elapsedMs);
  std::printf("per_launch_us: %.3f\n", perLaunchUs);
  std::printf("per_launch_cycles_wallclock: %.0f\n", perLaunchCycles);
  copyAndCheckOutput(buffers.deviceC, buffers.cBytes, buffers.cElements, a,
                     inputs);
  freeDeviceBuffers(buffers);
  return 0;
}
