//===- wave-fa-gfx950-runner.cpp - Timed gfx950 FA launcher -*- C++ -*-===//
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
#include <bit>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <vector>

namespace {

constexpr int kBlockM = 256;
constexpr int kHeadDim = 128;
constexpr int kCohortDynamicLDS = 68096;

struct Args {
  const char *hsaco = nullptr;
  const char *kernel = nullptr;
  int batch = 1;
  int heads = 1;
  int sequence = 256;
  int threads = 512;
  int dynamicLDS = kCohortDynamicLDS;
  int seed = 0;
  int iters = 20;
  int warmup = 5;
  int inputScale = 1;
  bool check = false;
  bool zeroQK = false;
};

struct ReferenceRow {
  std::array<float, kHeadDim> values;
  int head = 0;
  int row = 0;
};

struct IntOption {
  int Args::*field;
  const char *name;
};

struct WorstError {
  const ReferenceRow *row = nullptr;
  double difference = 0.0;
  size_t index = 0;
  int component = 0;
};

[[noreturn]] static void die(const char *message) {
  std::fprintf(stderr, "%s\n", message);
  std::exit(2);
}

static void checkHip(hipError_t error, const char *what) {
  if (error == hipSuccess)
    return;
  std::fprintf(stderr, "%s: %s\n", what, hipGetErrorString(error));
  std::exit(1);
}

static int parseInt(const char *text) {
  char *end = nullptr;
  long value = std::strtol(text, &end, 10);
  if (!end || *end != '\0')
    die("bad integer argument");
  return static_cast<int>(value);
}

static void usage() {
  std::fprintf(stderr,
               "usage: wave-fa-gfx950-runner [options] <hsaco> <kernel>\n"
               "  --batch N --heads N --sequence N --threads N "
               "--dynamic-lds N --seed N\n"
               "  --iters N --warmup N --input-scale N --check --zero-qk\n");
}

static bool parseSwitch(const char *arg, Args &args) {
  if (std::strcmp(arg, "--check") == 0) {
    args.check = true;
    return true;
  }
  if (std::strcmp(arg, "--zero-qk") == 0) {
    args.zeroQK = true;
    return true;
  }
  return false;
}

static bool parseIntOption(const char *arg, int value, Args &args) {
  static constexpr std::array<IntOption, 9> options{{
      {&Args::batch, "--batch"},
      {&Args::heads, "--heads"},
      {&Args::sequence, "--sequence"},
      {&Args::threads, "--threads"},
      {&Args::dynamicLDS, "--dynamic-lds"},
      {&Args::seed, "--seed"},
      {&Args::iters, "--iters"},
      {&Args::warmup, "--warmup"},
      {&Args::inputScale, "--input-scale"},
  }};
  for (const IntOption &option : options) {
    if (std::strcmp(arg, option.name) != 0)
      continue;
    args.*(option.field) = value;
    return true;
  }
  return false;
}

static void parsePositional(const char *arg, int &positional, Args &args) {
  if (positional == 0)
    args.hsaco = arg;
  else if (positional == 1)
    args.kernel = arg;
  else
    die("unexpected positional argument");
  ++positional;
}

static bool hasInvalidCounts(const Args &args) {
  return args.batch <= 0 || args.heads <= 0 || args.sequence <= 0 ||
         args.dynamicLDS <= 0 || args.iters <= 0 || args.warmup < 0 ||
         args.inputScale <= 0;
}

static void validateArgs(const Args &args) {
  if (!args.hsaco || !args.kernel) {
    usage();
    die("missing hsaco or kernel");
  }
  if (hasInvalidCounts(args))
    die("invalid non-positive argument");
  if (args.threads != 256 && args.threads != 512)
    die("threads must be 256 or 512");
  if (args.sequence % kBlockM)
    die("sequence must be a multiple of 256");
}

static Args parseArgs(int argc, char **argv) {
  Args args;
  int positional = 0;
  for (int i = 1; i < argc; ++i) {
    const char *arg = argv[i];
    if (parseSwitch(arg, args))
      continue;
    if (std::strcmp(arg, "--help") == 0 || std::strcmp(arg, "-h") == 0) {
      usage();
      std::exit(0);
    }
    if (arg[0] == '-' && arg[1] == '-') {
      if (++i == argc)
        die("missing flag value");
      int value = parseInt(argv[i]);
      if (!parseIntOption(arg, value, args))
        die("unknown flag");
      continue;
    }
    parsePositional(arg, positional, args);
  }
  validateArgs(args);
  return args;
}

static uint16_t toBf16(float value) {
  uint32_t bits = std::bit_cast<uint32_t>(value);
  bits += 0x7fffu + ((bits >> 16) & 1u);
  return static_cast<uint16_t>(bits >> 16);
}

static float fromBf16(uint16_t value) {
  return std::bit_cast<float>(static_cast<uint32_t>(value) << 16);
}

static float randomValue(uint32_t &state, float scale) {
  state = 1664525u * state + 1013904223u;
  int bucket = static_cast<int>((state >> 24) % 17u) - 8;
  return static_cast<float>(bucket) * scale;
}

static std::vector<uint16_t> makeInput(size_t count, int seed, int stream,
                                       float scale) {
  uint32_t state = static_cast<uint32_t>(seed) ^
                   (static_cast<uint32_t>(stream + 1) * 0x9e3779b9u);
  std::vector<uint16_t> result(count);
  for (uint16_t &value : result)
    value = toBf16(randomValue(state, scale));
  return result;
}

static std::vector<int> referenceHeads(const Args &args) {
  int count = args.batch * args.heads;
  if (count <= 4) {
    std::vector<int> heads;
    for (int head = 0; head < count; ++head)
      heads.push_back(head);
    return heads;
  }
  return {0, count / 2, count - 1};
}

static std::vector<int> referenceRows(const Args &args) {
  if (args.sequence <= 512) {
    std::vector<int> rows;
    for (int row = 0; row < args.sequence; ++row)
      rows.push_back(row);
    return rows;
  }
  std::vector<int> rows{0,
                        31,
                        32,
                        127,
                        args.sequence / 2,
                        args.sequence - 128,
                        args.sequence - 1};
  std::sort(rows.begin(), rows.end());
  rows.erase(std::unique(rows.begin(), rows.end()), rows.end());
  return rows;
}

static std::array<float, kHeadDim> computeMeanV(const Args &args,
                                                const std::vector<uint16_t> &v,
                                                size_t headBase) {
  std::array<float, kHeadDim> mean;
  for (int d = 0; d < kHeadDim; ++d) {
    double sum = 0.0;
    for (int key = 0; key < args.sequence; ++key)
      sum += fromBf16(v[headBase + key * kHeadDim + d]);
    mean[d] = static_cast<float>(sum / args.sequence);
  }
  return mean;
}

static ReferenceRow computeAttentionRow(const Args &args,
                                        const std::vector<uint16_t> &q,
                                        const std::vector<uint16_t> &k,
                                        const std::vector<uint16_t> &v,
                                        int head, int row) {
  size_t headElements = static_cast<size_t>(args.sequence) * kHeadDim;
  size_t headBase = static_cast<size_t>(head) * headElements;
  double scale = 1.0 / std::sqrt(static_cast<double>(kHeadDim));
  std::vector<double> scores(args.sequence);
  for (int key = 0; key < args.sequence; ++key) {
    double score = 0.0;
    for (int d = 0; d < kHeadDim; ++d)
      score += fromBf16(q[headBase + row * kHeadDim + d]) *
               fromBf16(k[headBase + key * kHeadDim + d]);
    scores[key] = score * scale;
  }
  double rowMax = *std::max_element(scores.begin(), scores.end());
  double denominator = 0.0;
  for (double &score : scores) {
    score = std::exp(score - rowMax);
    denominator += score;
  }
  ReferenceRow reference;
  reference.head = head;
  reference.row = row;
  for (int d = 0; d < kHeadDim; ++d) {
    double sum = 0.0;
    for (int key = 0; key < args.sequence; ++key)
      sum += scores[key] * fromBf16(v[headBase + key * kHeadDim + d]);
    reference.values[d] = static_cast<float>(sum / denominator);
  }
  return reference;
}

static std::vector<ReferenceRow>
computeReference(const Args &args, const std::vector<uint16_t> &q,
                 const std::vector<uint16_t> &k,
                 const std::vector<uint16_t> &v) {
  size_t headElements = static_cast<size_t>(args.sequence) * kHeadDim;
  std::vector<ReferenceRow> output;
  std::vector<int> heads = referenceHeads(args);
  std::vector<int> rows = referenceRows(args);
  output.reserve(heads.size() * rows.size());
  if (args.zeroQK) {
    for (int head : heads) {
      size_t headBase = static_cast<size_t>(head) * headElements;
      std::array<float, kHeadDim> mean = computeMeanV(args, v, headBase);
      for (int row : rows)
        output.push_back({mean, head, row});
    }
    return output;
  }
  for (int head : heads)
    for (int row : rows)
      output.push_back(computeAttentionRow(args, q, k, v, head, row));
  return output;
}

static WorstError findWorstError(const Args &args,
                                 const std::vector<uint16_t> &output,
                                 const std::vector<ReferenceRow> &reference) {
  WorstError worst;
  size_t headElements = static_cast<size_t>(args.sequence) * kHeadDim;
  for (const ReferenceRow &row : reference) {
    size_t rowBase = static_cast<size_t>(row.head) * headElements +
                     static_cast<size_t>(row.row) * kHeadDim;
    for (int d = 0; d < kHeadDim; ++d) {
      float got = fromBf16(output[rowBase + d]);
      double diff = std::isfinite(got)
                        ? std::fabs(got - row.values[d])
                        : std::numeric_limits<double>::infinity();
      if (diff > worst.difference) {
        worst.difference = diff;
        worst.index = rowBase + d;
        worst.row = &row;
        worst.component = d;
      }
    }
  }
  return worst;
}

static const ReferenceRow *
findNearestRow(const std::vector<uint16_t> &output,
               const std::vector<ReferenceRow> &reference,
               const WorstError &worst, double &nearestError) {
  size_t rowBase = worst.index - worst.component;
  const ReferenceRow *nearestRow = nullptr;
  nearestError = std::numeric_limits<double>::infinity();
  for (const ReferenceRow &candidate : reference) {
    if (candidate.head != worst.row->head)
      continue;
    double error = 0.0;
    for (int d = 0; d < kHeadDim; ++d) {
      double diff = fromBf16(output[rowBase + d]) - candidate.values[d];
      error += diff * diff;
    }
    if (error < nearestError) {
      nearestError = error;
      nearestRow = &candidate;
    }
  }
  return nearestRow;
}

static void reportMismatch(const Args &args,
                           const std::vector<uint16_t> &output,
                           const std::vector<ReferenceRow> &reference,
                           const WorstError &worst) {
  std::fprintf(stderr,
               "output_check: failed head=%d row=%d d=%d index=%zu "
               "expected=%.8f got=%.8f abs_diff=%.8f\n",
               worst.row->head, worst.row->row, worst.component, worst.index,
               worst.row->values[worst.component],
               fromBf16(output[worst.index]), worst.difference);
  double nearestError = 0.0;
  const ReferenceRow *nearestRow =
      findNearestRow(output, reference, worst, nearestError);
  std::fprintf(stderr, "output_check: nearest_reference_row=%d rms=%.8f\n",
               nearestRow->row, std::sqrt(nearestError / kHeadDim));
  size_t rowBase = worst.index - worst.component;
  for (int i = 0; i < 16; ++i) {
    float got = fromBf16(output[rowBase + i]);
    std::fprintf(stderr, "output_check: d=%d expected=%.6f got=%.6f\n", i,
                 worst.row->values[i], got);
  }
  size_t headElements = static_cast<size_t>(args.sequence) * kHeadDim;
  for (const ReferenceRow &candidate : reference) {
    if (candidate.head != worst.row->head || candidate.row % 32)
      continue;
    size_t index = static_cast<size_t>(candidate.head) * headElements +
                   static_cast<size_t>(candidate.row) * kHeadDim;
    std::fprintf(stderr, "output_check: row=%d d=0 expected=%.6f got=%.6f\n",
                 candidate.row, candidate.values[0], fromBf16(output[index]));
  }
}

static void validateOutput(const Args &args,
                           const std::vector<uint16_t> &output,
                           const std::vector<ReferenceRow> &reference) {
  WorstError worst = findWorstError(args, output, reference);
  if (worst.difference > 3.0e-2) {
    reportMismatch(args, output, reference, worst);
    std::exit(1);
  }
  std::printf("output_check: passed max_abs_diff=%.8f index=%zu\n",
              worst.difference, worst.index);
}

static void launch(hipFunction_t function, const Args &args,
                   void **kernelArgs) {
  checkHip(hipModuleLaunchKernel(function, args.sequence / kBlockM,
                                 args.batch * args.heads, 1, args.threads, 1, 1,
                                 args.dynamicLDS, nullptr, kernelArgs, nullptr),
           "hipModuleLaunchKernel");
}

} // namespace

int main(int argc, char **argv) {
  Args args = parseArgs(argc, argv);
  size_t elements =
      static_cast<size_t>(args.batch) * args.heads * args.sequence * kHeadDim;
  float qkScale = 0.125f * static_cast<float>(args.inputScale);
  std::vector<uint16_t> hostQ = makeInput(elements, args.seed, 0, qkScale);
  std::vector<uint16_t> hostK = makeInput(elements, args.seed, 1, qkScale);
  std::vector<uint16_t> hostV = makeInput(elements, args.seed, 2, 0.25f);
  if (args.zeroQK) {
    std::fill(hostQ.begin(), hostQ.end(), 0);
    std::fill(hostK.begin(), hostK.end(), 0);
  }
  std::vector<uint16_t> hostOutput(elements, 0);

  hipModule_t hipModule = nullptr;
  hipFunction_t function = nullptr;
  checkHip(hipModuleLoad(&hipModule, args.hsaco), "hipModuleLoad");
  checkHip(hipModuleGetFunction(&function, hipModule, args.kernel),
           "hipModuleGetFunction");
  checkHip(hipFuncSetAttribute(reinterpret_cast<const void *>(function),
                               hipFuncAttributeMaxDynamicSharedMemorySize,
                               args.dynamicLDS),
           "hipFuncSetAttribute");

  uint16_t *deviceQ = nullptr;
  uint16_t *deviceK = nullptr;
  uint16_t *deviceV = nullptr;
  uint16_t *deviceOutput = nullptr;
  size_t bytes = elements * sizeof(uint16_t);
  checkHip(hipMalloc(&deviceQ, bytes), "hipMalloc Q");
  checkHip(hipMalloc(&deviceK, bytes), "hipMalloc K");
  checkHip(hipMalloc(&deviceV, bytes), "hipMalloc V");
  checkHip(hipMalloc(&deviceOutput, bytes), "hipMalloc output");
  checkHip(hipMemcpy(deviceQ, hostQ.data(), bytes, hipMemcpyHostToDevice),
           "hipMemcpy Q");
  checkHip(hipMemcpy(deviceK, hostK.data(), bytes, hipMemcpyHostToDevice),
           "hipMemcpy K");
  checkHip(hipMemcpy(deviceV, hostV.data(), bytes, hipMemcpyHostToDevice),
           "hipMemcpy V");
  checkHip(hipMemset(deviceOutput, 0, bytes), "hipMemset output");
  void *kernelArgs[] = {&deviceQ, &deviceK, &deviceV, &deviceOutput};

  for (int i = 0; i < args.warmup; ++i)
    launch(function, args, kernelArgs);
  checkHip(hipDeviceSynchronize(), "warmup sync");

  hipEvent_t start = nullptr;
  hipEvent_t stop = nullptr;
  checkHip(hipEventCreate(&start), "hipEventCreate start");
  checkHip(hipEventCreate(&stop), "hipEventCreate stop");
  checkHip(hipEventRecord(start), "hipEventRecord start");
  for (int i = 0; i < args.iters; ++i)
    launch(function, args, kernelArgs);
  checkHip(hipEventRecord(stop), "hipEventRecord stop");
  checkHip(hipEventSynchronize(stop), "hipEventSynchronize");
  float milliseconds = 0.0f;
  checkHip(hipEventElapsedTime(&milliseconds, start, stop),
           "hipEventElapsedTime");
  double microseconds = milliseconds * 1000.0 / args.iters;
  long double flops =
      4.0L * args.batch * args.heads * args.sequence * args.sequence * kHeadDim;
  double tflops = static_cast<double>(flops / microseconds * 1.0e-6L);

  checkHip(
      hipMemcpy(hostOutput.data(), deviceOutput, bytes, hipMemcpyDeviceToHost),
      "hipMemcpy output");
  std::printf("shape: B=%d H=%d N=%d D=%d\n", args.batch, args.heads,
              args.sequence, kHeadDim);
  std::printf("grid: %d,%d,1 block: %d,1,1 dynamic_lds=%d\n",
              args.sequence / kBlockM, args.batch * args.heads, args.threads,
              args.dynamicLDS);
  std::printf("per_launch_us: %.3f\n", microseconds);
  std::printf("tflops: %.3f\n", tflops);
  if (args.check)
    validateOutput(args, hostOutput,
                   computeReference(args, hostQ, hostK, hostV));

  checkHip(hipEventDestroy(start), "hipEventDestroy start");
  checkHip(hipEventDestroy(stop), "hipEventDestroy stop");
  checkHip(hipFree(deviceQ), "hipFree Q");
  checkHip(hipFree(deviceK), "hipFree K");
  checkHip(hipFree(deviceV), "hipFree V");
  checkHip(hipFree(deviceOutput), "hipFree output");
  checkHip(hipModuleUnload(hipModule), "hipModuleUnload");
  return 0;
}
