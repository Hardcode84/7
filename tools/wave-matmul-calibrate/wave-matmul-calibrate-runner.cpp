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
  bool checkOutput = true;
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
      "  --no-check             skip all-ones output check\n");
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
static void setIters(Args &a, const char *v) { a.iters = parseInt(v); }
static void setWarmup(Args &a, const char *v) { a.warmupIters = parseInt(v); }
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
    {"--dynamic-lds", setDynamicLds},
    {"--iters", setIters},
    {"--warmup", setWarmup},
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

template <typename ReadFn>
static void validateOutput(int elements, int k, ReadFn readValue) {
  double worst = 0.0;
  int worstIdx = -1;
  double expected = static_cast<double>(k);
  for (int i = 0; i < elements; ++i) {
    double got = static_cast<double>(readValue(i));
    double diff = std::fabs(got - expected);
    if (diff > worst) {
      worst = diff;
      worstIdx = i;
    }
  }
  if (worst > 1.0e-3) {
    std::fprintf(stderr,
                 "output_check: failed index=%d expected=%.6f got=%.6f "
                 "abs_diff=%.6f\n",
                 worstIdx, expected, static_cast<double>(readValue(worstIdx)),
                 worst);
    std::exit(1);
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

static std::vector<uint8_t> makeInputBytes(int rows, int k, InputType type) {
  size_t elements = static_cast<size_t>(rows) * k;
  if (isMXFP4(type)) {
    if (elements % 2 != 0)
      die("MXFP4 input element count must be even");
    return std::vector<uint8_t>(elements / 2, 0x22);
  }

  uint16_t bits = oneBits(type);
  std::vector<uint8_t> bytes(elements * sizeof(bits));
  for (size_t i = 0; i < elements; ++i)
    std::memcpy(bytes.data() + i * sizeof(bits), &bits, sizeof(bits));
  return bytes;
}

static std::vector<uint8_t> makeMXFP4ScaleBytes(int rows, int k) {
  int groups = divExact(k, 32, "bad MXFP4 scale groups");
  return std::vector<uint8_t>(static_cast<size_t>(rows) * groups, 0x7f);
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

static DeviceBuffers prepareDeviceBuffers(const Args &a) {
  std::vector<uint8_t> hostA = makeInputBytes(a.m, a.k, a.inputType);
  std::vector<uint8_t> hostB = makeInputBytes(a.n, a.k, a.inputType);
  std::vector<uint8_t> hostAScale;
  std::vector<uint8_t> hostBScale;
  if (isMXFP4(a.inputType)) {
    hostAScale = makeMXFP4ScaleBytes(a.m, a.k);
    hostBScale = makeMXFP4ScaleBytes(a.n, a.k);
  }

  DeviceBuffers b;
  b.cElements = a.m * a.n;
  b.cBytes = static_cast<size_t>(b.cElements) *
             (a.cType == CType::F16 ? sizeof(uint16_t) : sizeof(float));
  checkHip(hipMalloc(&b.deviceA, hostA.size()), "hipMalloc A");
  checkHip(hipMalloc(&b.deviceB, hostB.size()), "hipMalloc B");
  if (isMXFP4(a.inputType)) {
    checkHip(hipMalloc(&b.deviceAScale, hostAScale.size()),
             "hipMalloc A scale");
    checkHip(hipMalloc(&b.deviceBScale, hostBScale.size()),
             "hipMalloc B scale");
  }
  checkHip(hipMalloc(&b.deviceC, b.cBytes), "hipMalloc C");
  checkHip(
      hipMemcpy(b.deviceA, hostA.data(), hostA.size(), hipMemcpyHostToDevice),
      "hipMemcpy A");
  checkHip(
      hipMemcpy(b.deviceB, hostB.data(), hostB.size(), hipMemcpyHostToDevice),
      "hipMemcpy B");
  if (isMXFP4(a.inputType)) {
    checkHip(hipMemcpy(b.deviceAScale, hostAScale.data(), hostAScale.size(),
                       hipMemcpyHostToDevice),
             "hipMemcpy A scale");
    checkHip(hipMemcpy(b.deviceBScale, hostBScale.data(), hostBScale.size(),
                       hipMemcpyHostToDevice),
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
                               const Args &a) {
  if (!a.checkOutput)
    return;
  if (a.cType == CType::F16) {
    std::vector<uint16_t> hostC(cElements);
    checkHip(hipMemcpy(hostC.data(), deviceC, cBytes, hipMemcpyDeviceToHost),
             "hipMemcpy C");
    validateOutput(cElements, a.k,
                   [&](int i) { return halfToFloat(hostC[i]); });
    return;
  }
  std::vector<float> hostC(cElements);
  checkHip(hipMemcpy(hostC.data(), deviceC, cBytes, hipMemcpyDeviceToHost),
           "hipMemcpy C");
  validateOutput(cElements, a.k, [&](int i) { return hostC[i]; });
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

  DeviceBuffers buffers = prepareDeviceBuffers(a);
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
              "c_type=%s\n",
              a.m, a.n, a.k, a.bm, a.bn, a.waveMTiles, a.waveNTiles,
              a.waveKTiles, a.waveSize, getInputTypeName(a.inputType),
              getCTypeName(a.cType));
  std::printf("grid: %d,%d,1 block: %d,1,1 waves_per_workgroup=%d\n", blocksX,
              blocksY, blockThreads, a.bm * a.bn);
  std::printf("loop_trip_count: %d\n", tripCount);
  std::printf("iters: %d\n", a.iters);
  std::printf("total_ms: %.3f\n", elapsedMs);
  std::printf("per_launch_us: %.3f\n", perLaunchUs);
  std::printf("per_launch_cycles_wallclock: %.0f\n", perLaunchCycles);
  copyAndCheckOutput(buffers.deviceC, buffers.cBytes, buffers.cElements, a);
  freeDeviceBuffers(buffers);
  return 0;
}
