//===- wave-microbench-runner.cpp - HIP-side timed kernel launcher
//-*-C++-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Generic kernel launcher for the Wave microbench harness (Stage 3
// of the AMDGPU scheduler design). Takes a pre-compiled hsaco + a
// kernel name, allocates a single i32 output buffer sized to fill
// the launch grid, fires the kernel N times in a timed loop, and
// reports elapsed time + a per-launch cycle estimate derived from
// the device's shader clock.
//
// Microbench kernels are constrained to the signature
// `(i32 *out)` or `(i32 *out, i32 x)`; the output buffer keeps
// the kernel from being optimised into a no-op and provides a
// target for any VMEM stores the kernel includes. `x` (when
// taken) defaults to 0 and exists for kernels that need any
// scalar input.
//
// Reported "cycles" here is wall-clock-derived (elapsed time times
// shader clock). For exact GRBM_GUI_ACTIVE cycle counts wrap the
// runner with `rocprofv3 --pmc GRBM_GUI_ACTIVE -- ...`; that's
// strictly more accurate but requires the external tool. The
// wall-clock estimate is good enough for ranking across microbench
// kernels on the same machine in the same run.
//
//===----------------------------------------------------------------------===//

#include <hip/hip_runtime.h>
#include <hip/hip_runtime_api.h>

#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

namespace {

struct Args {
  const char *hsaco = nullptr;
  const char *kernel = nullptr;
  int iters = 1000;
  int warmupIters = 10;
  int gridX = 1, gridY = 1, gridZ = 1;
  int blockX = 32, blockY = 1, blockZ = 1;
  // Output buffer size in i32 elements. Default scales to fill the
  // launch grid so each lane gets one slot.
  int bufElems = -1;
  // 1 = (i32 *out), 2 = (i32 *out, i32 x). Default 1.
  int numArgs = 1;
  int extraI32 = 0;
};

[[noreturn]] static void die(const char *msg) {
  std::fprintf(stderr, "%s\n", msg);
  std::exit(2);
}

static void usage() {
  std::fprintf(
      stderr,
      "usage: wave-microbench-runner [options] <hsaco> <kernel>\n"
      "options:\n"
      "  --iters N       launch iterations (default 1000)\n"
      "  --warmup N      warmup iterations (default 10)\n"
      "  --grid X,Y,Z    grid dim (default 1,1,1)\n"
      "  --block X,Y,Z   block dim (default 32,1,1)\n"
      "  --buf-elems N   i32 output buffer size (default grid*block)\n"
      "  --args N        kernel arg count (1 or 2; default 1)\n"
      "  --x VAL         second i32 arg value when --args=2 (default 0)\n");
}

static int parseInt(const char *s) {
  char *end = nullptr;
  long v = std::strtol(s, &end, 10);
  if (!end || *end != '\0')
    die("bad integer arg");
  return static_cast<int>(v);
}

static void parseTriple(const char *s, int &x, int &y, int &z) {
  if (std::sscanf(s, "%d,%d,%d", &x, &y, &z) != 3)
    die("bad triple, expected X,Y,Z");
}

// Each flag handler takes the value string and updates Args.
struct FlagHandler {
  const char *name;
  void (*set)(Args &, const char *);
};

static void setIters(Args &a, const char *v) { a.iters = parseInt(v); }
static void setWarmup(Args &a, const char *v) { a.warmupIters = parseInt(v); }
static void setBufElems(Args &a, const char *v) { a.bufElems = parseInt(v); }
static void setNumArgs(Args &a, const char *v) { a.numArgs = parseInt(v); }
static void setExtraI32(Args &a, const char *v) { a.extraI32 = parseInt(v); }
static void setGrid(Args &a, const char *v) {
  parseTriple(v, a.gridX, a.gridY, a.gridZ);
}
static void setBlock(Args &a, const char *v) {
  parseTriple(v, a.blockX, a.blockY, a.blockZ);
}

static constexpr FlagHandler kFlags[] = {
    {"--iters", setIters}, {"--warmup", setWarmup},      {"--grid", setGrid},
    {"--block", setBlock}, {"--buf-elems", setBufElems}, {"--args", setNumArgs},
    {"--x", setExtraI32},
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

// Process one CLI token at index i. Returns the index of the next
// token to consume.
static int handleOneArg(int argc, char **argv, int i, Args &a,
                        int &positional) {
  const char *arg = argv[i];
  if (isHelp(arg)) {
    usage();
    std::exit(0);
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

static Args parseArgs(int argc, char **argv) {
  Args a;
  int positional = 0;
  for (int i = 1; i < argc;)
    i = handleOneArg(argc, argv, i, a, positional);
  if (!a.hsaco || !a.kernel) {
    usage();
    die("missing required positional args");
  }
  if (a.bufElems < 0)
    a.bufElems = a.gridX * a.gridY * a.gridZ * a.blockX * a.blockY * a.blockZ;
  return a;
}

static void check(hipError_t e, const char *what) {
  if (e != hipSuccess) {
    std::fprintf(stderr, "%s: %s\n", what, hipGetErrorString(e));
    std::exit(1);
  }
}

} // namespace

int main(int argc, char **argv) {
  Args a = parseArgs(argc, argv);

  hipDeviceProp_t props;
  check(hipGetDeviceProperties(&props, 0), "hipGetDeviceProperties");
  // clockRate is in kHz; convert to MHz for display + Hz for math.
  double clockMHz = props.clockRate / 1000.0;
  double clockHz = props.clockRate * 1000.0;
  std::printf("device: %s (%s) shader_clock_mhz=%.0f\n", props.name,
              props.gcnArchName, clockMHz);

  hipModule_t mod = nullptr;
  hipFunction_t kfn = nullptr;
  check(hipModuleLoad(&mod, a.hsaco), "hipModuleLoad");
  check(hipModuleGetFunction(&kfn, mod, a.kernel), "hipModuleGetFunction");

  int32_t *deviceOut = nullptr;
  size_t bufBytes = a.bufElems * sizeof(int32_t);
  check(hipMalloc(&deviceOut, bufBytes), "hipMalloc");

  // Kernel signature: (i32 *out) by default, (i32 *out, i32 x) when
  // --args=2. Pointer to extraI32 must outlive the launches.
  int32_t extra = a.extraI32;
  void *kargs1[] = {&deviceOut};
  void *kargs2[] = {&deviceOut, &extra};
  void **kargs = (a.numArgs == 2) ? kargs2 : kargs1;

  // Warmup.
  for (int i = 0; i < a.warmupIters; ++i) {
    check(hipModuleLaunchKernel(kfn, a.gridX, a.gridY, a.gridZ, a.blockX,
                                a.blockY, a.blockZ, 0, nullptr, kargs, nullptr),
          "warmup launch");
  }
  check(hipDeviceSynchronize(), "warmup sync");

  // Timed loop, event-bracketed.
  hipEvent_t start, stop;
  check(hipEventCreate(&start), "event create start");
  check(hipEventCreate(&stop), "event create stop");
  check(hipEventRecord(start, nullptr), "event record start");
  for (int i = 0; i < a.iters; ++i) {
    check(hipModuleLaunchKernel(kfn, a.gridX, a.gridY, a.gridZ, a.blockX,
                                a.blockY, a.blockZ, 0, nullptr, kargs, nullptr),
          "timed launch");
  }
  check(hipEventRecord(stop, nullptr), "event record stop");
  check(hipEventSynchronize(stop), "event sync stop");
  float elapsedMs = 0.0f;
  check(hipEventElapsedTime(&elapsedMs, start, stop), "event elapsed");

  double perLaunchUs = (elapsedMs * 1000.0) / a.iters;
  double perLaunchCycles = perLaunchUs * (clockHz / 1e6);

  std::printf("kernel: %s\n", a.kernel);
  std::printf("iters: %d\n", a.iters);
  std::printf("grid: %d,%d,%d block: %d,%d,%d\n", a.gridX, a.gridY, a.gridZ,
              a.blockX, a.blockY, a.blockZ);
  std::printf("total_ms: %.3f\n", elapsedMs);
  std::printf("per_launch_us: %.3f\n", perLaunchUs);
  std::printf("per_launch_cycles_wallclock: %.0f\n", perLaunchCycles);

  check(hipEventDestroy(start), "event destroy start");
  check(hipEventDestroy(stop), "event destroy stop");
  check(hipFree(deviceOut), "hipFree");
  check(hipModuleUnload(mod), "hipModuleUnload");
  return 0;
}
