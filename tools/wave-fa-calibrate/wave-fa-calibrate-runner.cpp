//===- wave-fa-calibrate-runner.cpp - Timed FA launcher -*- C++ -*-=======//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <hip/hip_runtime.h>
#include <hip/hip_runtime_api.h>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

namespace {

struct Args {
  const char *hsaco = nullptr;
  const char *kernel = nullptr;
  int blockM = 4;
  int blockN = 8;
  int seqN = 16;
  int headDim = 8;
  int seed = 0;
  int iters = 1000;
  int warmupIters = 10;
  bool checkOutput = true;
};

[[noreturn]] static void die(const char *msg) {
  std::fprintf(stderr, "%s\n", msg);
  std::exit(2);
}

static void usage() {
  std::fprintf(
      stderr, "usage: wave-fa-calibrate-runner [options] <hsaco> <kernel>\n"
              "options:\n"
              "  --block-m N     Q rows (default 4)\n"
              "  --block-n N     K/V tile width baked into kernel (default 8)\n"
              "  --seq-n N       total K/V rows (default 16)\n"
              "  --head-dim N    head dimension (default 8)\n"
              "  --seed N        deterministic input seed (default 0)\n"
              "  --iters N       timed launch iterations (default 1000)\n"
              "  --warmup N      warmup launches (default 10)\n"
              "  --no-check      skip CPU reference comparison\n");
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

static void setBlockM(Args &a, const char *v) { a.blockM = parseInt(v); }
static void setBlockN(Args &a, const char *v) { a.blockN = parseInt(v); }
static void setSeqN(Args &a, const char *v) { a.seqN = parseInt(v); }
static void setHeadDim(Args &a, const char *v) { a.headDim = parseInt(v); }
static void setSeed(Args &a, const char *v) { a.seed = parseInt(v); }
static void setIters(Args &a, const char *v) { a.iters = parseInt(v); }
static void setWarmup(Args &a, const char *v) { a.warmupIters = parseInt(v); }

static constexpr FlagHandler kFlags[] = {
    {"--block-m", setBlockM},   {"--block-n", setBlockN}, {"--seq-n", setSeqN},
    {"--head-dim", setHeadDim}, {"--seed", setSeed},      {"--iters", setIters},
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
  requirePositive(a.blockM, "block-m must be positive");
  requirePositive(a.blockN, "block-n must be positive");
  requirePositive(a.seqN, "seq-n must be positive");
  requirePositive(a.headDim, "head-dim must be positive");
  requirePositive(a.iters, "iters must be positive");
  if (a.warmupIters < 0)
    die("warmup must be non-negative");
  if (a.blockM * a.headDim != 32)
    die("current FA kernel requires block-m * head-dim == 32");
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

static float randValue(uint32_t &state, float scale) {
  state = 1664525u * state + 1013904223u;
  int bucket = static_cast<int>((state >> 24) % 17u);
  return static_cast<float>((bucket - 8) * scale);
}

static void fillRand(std::vector<float> &values, int seed, int stream,
                     float scale) {
  uint32_t streamMix = static_cast<uint32_t>(stream + 1) * 0x9E3779B9u;
  uint32_t state = static_cast<uint32_t>(seed) ^ streamMix;
  for (float &value : values)
    value = randValue(state, scale);
}

static void makeInputs(const Args &a, std::vector<float> &q,
                       std::vector<float> &k, std::vector<float> &v) {
  fillRand(q, a.seed, 0, 0.0625f);
  fillRand(k, a.seed, 1, 0.0625f);
  fillRand(v, a.seed, 2, 0.125f);
  double qScale =
      1.4426950408889634 / std::sqrt(static_cast<double>(a.headDim));
  for (float &value : q)
    value = static_cast<float>(static_cast<double>(value) * qScale);
}

static std::vector<float> computeReference(const Args &a,
                                           const std::vector<float> &q,
                                           const std::vector<float> &k,
                                           const std::vector<float> &v) {
  std::vector<float> ref(static_cast<size_t>(a.blockM) * a.headDim, 0.0f);
  for (int m = 0; m < a.blockM; ++m) {
    std::vector<double> scores(a.seqN, 0.0);
    for (int n = 0; n < a.seqN; ++n) {
      double score = 0.0;
      for (int d = 0; d < a.headDim; ++d)
        score += static_cast<double>(q[m * a.headDim + d]) *
                 static_cast<double>(k[n * a.headDim + d]);
      scores[n] = score;
    }
    double rowMax = *std::max_element(scores.begin(), scores.end());
    std::vector<double> weights(a.seqN, 0.0);
    double denom = 0.0;
    for (int n = 0; n < a.seqN; ++n) {
      weights[n] = std::exp2(scores[n] - rowMax);
      denom += weights[n];
    }
    for (int d = 0; d < a.headDim; ++d) {
      double acc = 0.0;
      for (int n = 0; n < a.seqN; ++n)
        acc += weights[n] * static_cast<double>(v[n * a.headDim + d]);
      ref[m * a.headDim + d] = static_cast<float>(acc / denom);
    }
  }
  return ref;
}

static void validateOutput(const std::vector<float> &out,
                           const std::vector<float> &ref) {
  double worst = 0.0;
  int worstIdx = -1;
  for (int i = 0, e = static_cast<int>(out.size()); i < e; ++i) {
    double diff =
        std::fabs(static_cast<double>(out[i]) - static_cast<double>(ref[i]));
    if (diff > worst) {
      worst = diff;
      worstIdx = i;
    }
  }
  if (worst > 3.0e-3) {
    std::fprintf(stderr,
                 "output_check: failed index=%d expected=%.8f got=%.8f "
                 "abs_diff=%.8f\n",
                 worstIdx, static_cast<double>(ref[worstIdx]),
                 static_cast<double>(out[worstIdx]), worst);
    std::exit(1);
  }
  std::printf("output_check: passed max_abs_diff=%.8f index=%d\n", worst,
              worstIdx);
}

} // namespace

int main(int argc, char **argv) {
  Args a = parseArgs(argc, argv);

  hipDeviceProp_t props;
  checkHip(hipGetDeviceProperties(&props, 0), "hipGetDeviceProperties");
  double clockMHz = props.clockRate / 1000.0;
  double clockHz = props.clockRate * 1000.0;

  hipModule_t mod = nullptr;
  hipFunction_t kfn = nullptr;
  checkHip(hipModuleLoad(&mod, a.hsaco), "hipModuleLoad");
  checkHip(hipModuleGetFunction(&kfn, mod, a.kernel), "hipModuleGetFunction");

  size_t qElems = static_cast<size_t>(a.blockM) * a.headDim;
  size_t kvElems = static_cast<size_t>(a.seqN) * a.headDim;
  std::vector<float> hostQ(qElems, 0.0f);
  std::vector<float> hostK(kvElems, 0.0f);
  std::vector<float> hostV(kvElems, 0.0f);
  std::vector<float> hostOut(qElems, 0.0f);
  makeInputs(a, hostQ, hostK, hostV);

  float *deviceQ = nullptr;
  float *deviceK = nullptr;
  float *deviceV = nullptr;
  float *deviceOut = nullptr;
  checkHip(hipMalloc(&deviceQ, hostQ.size() * sizeof(float)), "hipMalloc Q");
  checkHip(hipMalloc(&deviceK, hostK.size() * sizeof(float)), "hipMalloc K");
  checkHip(hipMalloc(&deviceV, hostV.size() * sizeof(float)), "hipMalloc V");
  checkHip(hipMalloc(&deviceOut, hostOut.size() * sizeof(float)),
           "hipMalloc out");
  checkHip(hipMemcpy(deviceQ, hostQ.data(), hostQ.size() * sizeof(float),
                     hipMemcpyHostToDevice),
           "hipMemcpy Q");
  checkHip(hipMemcpy(deviceK, hostK.data(), hostK.size() * sizeof(float),
                     hipMemcpyHostToDevice),
           "hipMemcpy K");
  checkHip(hipMemcpy(deviceV, hostV.data(), hostV.size() * sizeof(float),
                     hipMemcpyHostToDevice),
           "hipMemcpy V");
  checkHip(hipMemset(deviceOut, 0, hostOut.size() * sizeof(float)),
           "hipMemset out");

  void *kernelArgs[] = {&deviceQ, &deviceK, &deviceV, &deviceOut};

  for (int i = 0; i < a.warmupIters; ++i)
    checkHip(hipModuleLaunchKernel(kfn, 1, 1, 1, 32, 1, 1, 0, nullptr,
                                   kernelArgs, nullptr),
             "warmup launch");
  checkHip(hipDeviceSynchronize(), "warmup sync");

  hipEvent_t start, stop;
  checkHip(hipEventCreate(&start), "event create start");
  checkHip(hipEventCreate(&stop), "event create stop");
  checkHip(hipEventRecord(start, nullptr), "event record start");
  for (int i = 0; i < a.iters; ++i)
    checkHip(hipModuleLaunchKernel(kfn, 1, 1, 1, 32, 1, 1, 0, nullptr,
                                   kernelArgs, nullptr),
             "timed launch");
  checkHip(hipEventRecord(stop, nullptr), "event record stop");
  checkHip(hipEventSynchronize(stop), "event sync stop");

  float elapsedMs = 0.0f;
  checkHip(hipEventElapsedTime(&elapsedMs, start, stop), "event elapsed");
  double perLaunchUs = (elapsedMs * 1000.0) / a.iters;
  double perLaunchCycles = perLaunchUs * (clockHz / 1e6);

  checkHip(hipMemcpy(hostOut.data(), deviceOut, hostOut.size() * sizeof(float),
                     hipMemcpyDeviceToHost),
           "hipMemcpy out");

  std::printf("device: %s (%s) shader_clock_mhz=%.0f\n", props.name,
              props.gcnArchName, clockMHz);
  std::printf("kernel: %s\n", a.kernel);
  std::printf("shape: block_m=%d block_n=%d seq_n=%d head_dim=%d seed=%d\n",
              a.blockM, a.blockN, a.seqN, a.headDim, a.seed);
  std::printf("grid: 1,1,1 block: 32,1,1 waves_per_workgroup=1\n");
  std::printf("iters: %d\n", a.iters);
  std::printf("total_ms: %.3f\n", elapsedMs);
  std::printf("per_launch_us: %.3f\n", perLaunchUs);
  std::printf("per_launch_cycles_wallclock: %.0f\n", perLaunchCycles);
  if (a.checkOutput)
    validateOutput(hostOut, computeReference(a, hostQ, hostK, hostV));

  checkHip(hipEventDestroy(start), "event destroy start");
  checkHip(hipEventDestroy(stop), "event destroy stop");
  checkHip(hipFree(deviceQ), "hipFree Q");
  checkHip(hipFree(deviceK), "hipFree K");
  checkHip(hipFree(deviceV), "hipFree V");
  checkHip(hipFree(deviceOut), "hipFree out");
  checkHip(hipModuleUnload(mod), "hipModuleUnload");
  return 0;
}
