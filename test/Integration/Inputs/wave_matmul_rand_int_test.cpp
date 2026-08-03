//===- wave_matmul_rand_int_test.cpp - Matmul runner test -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#define WAVE_MATMUL_CALIBRATE_RUNNER_NO_MAIN
#include "../../../tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp"

[[noreturn]] static void fail(const char *message) {
  std::fprintf(stderr, "%s\n", message);
  std::exit(1);
}

static void checkValues(const std::vector<uint8_t> &bytes, InputType type,
                        const std::array<float, 15> &expected) {
  for (size_t i = 0; i < expected.size(); ++i) {
    float actual = readDenseInput(bytes, i, type);
    if (actual != expected[i] ||
        std::signbit(actual) != std::signbit(expected[i]))
      fail("rand_int value mismatch");
  }
}

static void checkType(InputType type, const char *label) {
  constexpr int rows = 3;
  constexpr int k = 5;
  const std::array<float, 15> expectedA = {-2, -2, 0, 0,  1,  0,  1, 2,
                                           -1, -2, 0, -1, -2, -2, 0};
  const std::array<float, 15> expectedB = {2, -2, -0.0f, 0,  -1, 0,  -1,   2,
                                           1, -2, -0.0f, -1, 2,  -2, -0.0f};

  std::vector<uint8_t> a =
      makeInputBytes(rows, k, type, 0, 0, false, true, false);
  std::vector<uint8_t> repeated =
      makeInputBytes(rows, k, type, 91, 0, false, true, false);
  std::vector<uint8_t> b =
      makeInputBytes(rows, k, type, 0, 1, false, true, false);
  if (a != repeated)
    fail("rand_int changed with calibration seed");
  if (a == b)
    fail("rand_int A/B streams match");
  checkValues(a, type, expectedA);
  checkValues(b, type, expectedB);
  std::printf("rand_int_%s: ok\n", label);
}

static void checkHplType(InputType type, const char *label,
                         const std::array<uint16_t, 15> &expected) {
  constexpr int rows = 3;
  constexpr int k = 5;
  std::vector<uint8_t> a =
      makeInputBytes(rows, k, type, 0, 0, false, false, true);
  std::vector<uint8_t> repeated =
      makeInputBytes(rows, k, type, 91, 0, false, false, true);
  std::vector<uint8_t> b =
      makeInputBytes(rows, k, type, 0, 1, false, false, true);
  if (a != repeated)
    fail("HPL changed with calibration seed");
  if (a != b)
    fail("HPL A/B streams differ");
  for (size_t i = 0; i < expected.size(); ++i)
    if (readU16(a, i) != expected[i])
      fail("HPL value mismatch");
  std::printf("hpl_%s: ok\n", label);
}

static void checkCPUReference(InputType type, const char *label) {
  Args args;
  args.m = 2;
  args.n = 2;
  args.k = 4;
  args.inputType = type;
  args.randInt = true;
  HostInputs inputs = makeHostInputs(args);
  const std::array<float, 4> expected = {0, -2, 2, -2};
  for (int m = 0; m < args.m; ++m) {
    for (int n = 0; n < args.n; ++n) {
      if (computeExpectedElement(inputs, args, m, n) !=
          expected[m * args.n + n])
        fail("rand_int CPU reference mismatch");
    }
  }
  std::printf("rand_int_%s_cpu_reference: ok\n", label);
}

static void checkHplCPUReference(InputType type, const char *label) {
  Args args;
  args.m = 2;
  args.n = 2;
  args.k = 4;
  args.inputType = type;
  args.hpl = true;
  HostInputs inputs = makeHostInputs(args);
  float c00 = computeExpectedElement(inputs, args, 0, 0);
  float c01 = computeExpectedElement(inputs, args, 0, 1);
  float c10 = computeExpectedElement(inputs, args, 1, 0);
  float c11 = computeExpectedElement(inputs, args, 1, 1);
  if (c00 <= 0.0f || c11 <= 0.0f || c01 != c10)
    fail("HPL CPU reference mismatch");
  std::printf("hpl_%s_cpu_reference: ok\n", label);
}

static void checkCoordinate(const Args &args, int index, int m, int n) {
  OutputCoordinate coord = getOutputCoordinate(args, index);
  if (coord.m != m || coord.n != n)
    fail("fragment output coordinate mismatch");
}

static void checkOutputCoordinates() {
  Args args;
  args.m = 16;
  args.n = 16;
  args.bm = 1;
  args.bn = 1;
  args.waveMTiles = 1;
  args.waveNTiles = 1;

  args.accumulatorLayout = AccumulatorLayout::Mfma;
  args.waveSize = 64;
  checkCoordinate(args, 0, 0, 0);
  checkCoordinate(args, 3, 3, 0);
  checkCoordinate(args, 4, 0, 1);
  checkCoordinate(args, 64, 4, 0);
  checkCoordinate(args, 255, 15, 15);

  args.accumulatorLayout = AccumulatorLayout::Wmma;
  args.waveSize = 32;
  checkCoordinate(args, 0, 0, 0);
  checkCoordinate(args, 7, 14, 0);
  checkCoordinate(args, 8, 0, 1);
  checkCoordinate(args, 128, 1, 0);
  checkCoordinate(args, 255, 15, 15);

  args.accumulatorLayout = AccumulatorLayout::Mfma;
  checkCoordinate(args, 7, 7, 0);
  checkCoordinate(args, 128, 8, 0);
  std::printf("fragment_output_coordinates: ok\n");
}

static void checkOutputLayouts() {
  Args args;
  if (getEffectiveOutputLayout(args) != OutputLayout::TilePacked)
    fail("matmul automatic output layout mismatch");
  args.kernelABI = KernelABI::V9Golden;
  if (getEffectiveOutputLayout(args) != OutputLayout::RowMajor)
    fail("v9 automatic output layout mismatch");
  args.kernelABI = KernelABI::TLXMXFP;
  if (getEffectiveOutputLayout(args) != OutputLayout::TilePacked)
    fail("TLX automatic output layout mismatch");
  args.kernelABI = KernelABI::StreamK;
  if (getEffectiveOutputLayout(args) != OutputLayout::ColumnMajor)
    fail("Stream-K automatic output layout mismatch");
  args.outputLayout = OutputLayout::ColumnMajor;
  if (getEffectiveOutputLayout(args) != OutputLayout::ColumnMajor)
    fail("explicit output layout mismatch");
  std::printf("output_layouts: ok\n");
}

static Args makeAITERArgs() {
  Args args;
  args.m = 256;
  args.n = 512;
  args.k = 512;
  args.bm = 1;
  args.bn = 4;
  args.waveMTiles = 2;
  args.waveNTiles = 2;
  args.waveKTiles = 2;
  args.waveSize = 64;
  args.inputType = InputType::MXFP4;
  args.cType = CType::F16;
  args.accumulatorLayout = AccumulatorLayout::Mfma;
  args.mxfp4InputLayout = MXFP4InputLayout::AITER;
  return args;
}

static void checkAITERRunnerContract() {
  Args args = makeAITERArgs();
  validateArgs(args);
  if (getEffectiveOutputLayout(args) != OutputLayout::TilePacked ||
      getFinalOutputLayout(args) != OutputLayout::RowMajor)
    fail("AITER output contract mismatch");
  HostInputs inputs = makeHostInputs(args);
  validateRandomAITERInputs(inputs, args);
  validateAITEROutputMapping(args.m * args.n, args);
  std::printf("aiter_runner_contract: ok\n");
}

struct AITERExpectedOutput {
  std::vector<uint16_t> values;
  std::vector<uint8_t> seen;
  int packedIndex = 0;
};

static void fillExpectedAITERTile(const Args &args,
                                  const std::vector<uint16_t> &packed,
                                  AITERExpectedOutput &expected, int wgM,
                                  int wgN, int waveN, int tileM, int tileN) {
  for (int lane = 0; lane < 64; ++lane) {
    for (int laneValue = 0; laneValue < 4; ++laneValue) {
      int m = wgM * 32 + tileM * 16 + (lane / 16) * 4 + laneValue;
      int n = wgN * 128 + waveN * 32 + tileN * 16 + lane % 16;
      int logicalIndex = m * args.n + n;
      if (expected.seen[logicalIndex])
        fail("AITER expected mapping is not bijective");
      expected.seen[logicalIndex] = 1;
      expected.values[logicalIndex] = packed[expected.packedIndex++];
    }
  }
}

static void fillExpectedAITERWorkgroup(const Args &args,
                                       const std::vector<uint16_t> &packed,
                                       AITERExpectedOutput &expected, int wgM,
                                       int wgN) {
  for (int waveN = 0; waveN < 4; ++waveN)
    for (int tileM = 0; tileM < 2; ++tileM)
      for (int tileN = 0; tileN < 2; ++tileN)
        fillExpectedAITERTile(args, packed, expected, wgM, wgN, waveN, tileM,
                              tileN);
}

static std::vector<uint16_t>
makeExpectedAITEROutput(const Args &args, const std::vector<uint16_t> &packed) {
  AITERExpectedOutput expected{std::vector<uint16_t>(packed.size()),
                               std::vector<uint8_t>(packed.size())};
  for (int wgM = 0; wgM < 8; ++wgM)
    for (int wgN = 0; wgN < 2; ++wgN)
      fillExpectedAITERWorkgroup(args, packed, expected, wgM, wgN);
  if (expected.packedIndex != static_cast<int>(packed.size()))
    fail("AITER expected mapping missed packed values");
  for (uint8_t value : expected.seen)
    if (!value)
      fail("AITER expected mapping missed row-major values");
  return std::move(expected.values);
}

static void runAITERDeviceOutputConversion(const Args &args,
                                           DeviceBuffers &buffers,
                                           bool invert) {
  std::vector<uint16_t> packed(buffers.cElements);
  for (int index = 0; index < buffers.cElements; ++index) {
    uint16_t value = static_cast<uint16_t>(index);
    packed[index] = invert ? static_cast<uint16_t>(~value) : value;
  }
  std::vector<uint16_t> expected = makeExpectedAITEROutput(args, packed);
  checkHip(hipMemset(buffers.deviceFinalC, 0xa5, buffers.cBytes),
           "hipMemset test final C");
  checkHip(hipMemcpy(buffers.deviceC, packed.data(), buffers.cBytes,
                     hipMemcpyHostToDevice),
           "hipMemcpy test C");
  launchAITEROutputConversion(buffers, args);
  checkHip(hipDeviceSynchronize(), "AITER conversion sync");
  std::vector<uint16_t> rowMajor(buffers.cElements);
  checkHip(hipMemcpy(rowMajor.data(), buffers.deviceFinalC, buffers.cBytes,
                     hipMemcpyDeviceToHost),
           "hipMemcpy test final C");
  for (int index = 0; index < buffers.cElements; ++index)
    if (rowMajor[index] != expected[index])
      fail("AITER device output conversion mismatch");
}

static void checkAITERDeviceOutputConversion() {
  Args args = makeAITERArgs();
  args.n = 256;
  validateArgs(args);
  if (args.m != 256 || args.n != 256 || args.bm != 1 || args.bn != 4 ||
      args.waveMTiles != 2 || args.waveNTiles != 2 || args.waveSize != 64)
    fail("AITER conversion test geometry changed");

  DeviceBuffers buffers;
  buffers.cElements = getOutputElementCount(args);
  buffers.cBytes = buffers.cElements * sizeof(uint16_t);
  checkHip(hipMalloc(&buffers.deviceC, buffers.cBytes), "hipMalloc test C");
  checkHip(hipMalloc(&buffers.deviceFinalC, buffers.cBytes),
           "hipMalloc test final C");
  runAITERDeviceOutputConversion(args, buffers, false);
  runAITERDeviceOutputConversion(args, buffers, true);
  checkHip(hipFree(buffers.deviceC), "hipFree test C");
  checkHip(hipFree(buffers.deviceFinalC), "hipFree test final C");
  std::printf("aiter_device_output_conversion: ok\n");
}

static Args makeStreamKArgs() {
  Args args;
  args.m = 512;
  args.n = 256;
  args.k = 256;
  args.bm = 2;
  args.bn = 2;
  args.waveMTiles = 8;
  args.waveNTiles = 8;
  args.waveKTiles = 2;
  args.waveSize = 64;
  args.cType = CType::F16;
  args.kernelABI = KernelABI::StreamK;
  args.streamKWorkers = 5;
  return args;
}

static void checkStreamKWorkspace(const Args &args) {
  StreamKWorkspaceSizes sizes = getStreamKWorkspaceSizes(args);
  if (sizes.scratchBytes != 5 * 2 * 256 * 256 * sizeof(float) ||
      sizes.counterElements != 2 || sizes.counterBytes != 2 * sizeof(uint32_t))
    fail("Stream-K workspace size mismatch");
}

static void checkStreamKLaunch(const Args &args) {
  LaunchShape launch = makeLaunchShape(args);
  if (launch.gridX != 5 || launch.gridY != 1 || launch.blockThreads != 256)
    fail("Stream-K launch shape mismatch");
}

static void checkStreamKArgStorage(Args &args) {
  LaunchShape launch = makeLaunchShape(args);
  DeviceBuffers first;
  first.deviceStreamKScratch = reinterpret_cast<void *>(uintptr_t{0x1000});
  first.deviceStreamKCounters = reinterpret_cast<void *>(uintptr_t{0x2000});
  DeviceBuffers second;
  second.deviceStreamKScratch = reinterpret_cast<void *>(uintptr_t{0x3000});
  second.deviceStreamKCounters = reinterpret_cast<void *>(uintptr_t{0x4000});
  KernelArgStorage firstStorage;
  KernelArgStorage secondStorage;
  initKernelArgStorage(firstStorage, args, first, launch.tripCount);
  initKernelArgStorage(secondStorage, args, second, launch.tripCount);
  if (firstStorage.active != firstStorage.streamKArgs.data() ||
      secondStorage.active != secondStorage.streamKArgs.data())
    fail("Stream-K argument block not selected");
  if (*static_cast<void **>(firstStorage.streamKArgs[3]) ==
          *static_cast<void **>(secondStorage.streamKArgs[3]) ||
      *static_cast<void **>(firstStorage.streamKArgs[4]) ==
          *static_cast<void **>(secondStorage.streamKArgs[4]))
    fail("Stream-K workspaces alias");
}

static void checkStreamKABI() {
  Args args = makeStreamKArgs();
  validateArgs(args);
  checkStreamKWorkspace(args);
  checkStreamKLaunch(args);
  checkStreamKArgStorage(args);
  std::printf("streamk_kernel_abi: ok\n");
}

static bool setInputInvalidMode(const char *mode, Args &args) {
  if (std::strcmp(mode, "mutual-exclusion") == 0) {
    args.allOnes = true;
    args.hpl = true;
    return true;
  }
  if (std::strcmp(mode, "mxfp4") == 0) {
    args.inputType = InputType::MXFP4;
    args.waveSize = 64;
    args.randInt = true;
    return true;
  }
  if (std::strcmp(mode, "hpl-mxfp4") == 0) {
    args.inputType = InputType::MXFP4;
    args.waveSize = 64;
    args.hpl = true;
    return true;
  }
  return false;
}

static bool setStreamKInvalidMode(const char *mode, Args &args) {
  if (std::strcmp(mode, "streamk-workers") == 0) {
    args = makeStreamKArgs();
    args.streamKWorkers = 0;
    return true;
  }
  if (std::strcmp(mode, "streamk-layout") == 0) {
    args = makeStreamKArgs();
    args.outputLayout = OutputLayout::RowMajor;
    return true;
  }
  if (std::strcmp(mode, "streamk-work-overflow") == 0) {
    args = makeStreamKArgs();
    args.m = 256 * 32768;
    args.n = 256 * 32768;
    return true;
  }
  if (std::strcmp(mode, "streamk-buffer-overflow") == 0) {
    args = makeStreamKArgs();
    args.m = 2147481600;
    args.n = 256;
    args.k = 64;
    args.streamKWorkers = 1;
    return true;
  }
  return false;
}

static bool setAITERInvalidMode(const char *mode, Args &args) {
  if (std::strcmp(mode, "aiter-output-layout") == 0) {
    args = makeAITERArgs();
    args.outputLayout = OutputLayout::RowMajor;
    return true;
  }
  if (std::strcmp(mode, "aiter-wmma") == 0) {
    args = makeAITERArgs();
    args.accumulatorLayout = AccumulatorLayout::Wmma;
    return true;
  }
  if (std::strcmp(mode, "aiter-wave-k") == 0) {
    args = makeAITERArgs();
    args.waveKTiles = 3;
    return true;
  }
  if (std::strcmp(mode, "aiter-wave-mn") == 0) {
    args = makeAITERArgs();
    args.waveMTiles = 3;
    return true;
  }
  if (std::strcmp(mode, "aiter-b-range-overflow") == 0) {
    args = makeAITERArgs();
    args.m = 32;
    args.n = 128;
    args.k = 67109120;
    return true;
  }
  return false;
}

static bool setScalarInvalidMode(const char *mode, Args &args) {
  if (std::strcmp(mode, "iters-zero") == 0) {
    args.iters = 0;
    return true;
  }
  if (std::strcmp(mode, "warmup-negative") == 0) {
    args.warmupIters = -1;
    return true;
  }
  if (std::strcmp(mode, "output-elements-overflow") == 0) {
    args.m = std::numeric_limits<int>::max();
    args.n = 2;
    return true;
  }
  return false;
}

static bool runOverflowInvalidMode(const char *mode) {
  if (std::strcmp(mode, "workspace-overflow") == 0) {
    checkedSizeProduct(std::numeric_limits<size_t>::max(), 2,
                       "Stream-K workspace size overflow");
    return true;
  }
  if (std::strcmp(mode, "aiter-scale-padding-overflow") == 0) {
    Args args = makeAITERArgs();
    (void)makeAITERScaleBytes({}, std::numeric_limits<int>::max(), args);
    return true;
  }
  if (std::strcmp(mode, "aiter-scale-range-overflow") == 0) {
    Args args = makeAITERArgs();
    (void)makeAITERScaleBytes({}, 1 << 28, args);
    return true;
  }
  if (std::strcmp(mode, "launch-k-overflow") == 0) {
    Args args;
    args.waveKTiles = 1 << 28;
    validateArgs(args);
    (void)makeLaunchShape(args);
    return true;
  }
  if (std::strcmp(mode, "integer-overflow") == 0) {
    (void)parseInt("2147483648");
    return true;
  }
  return false;
}

[[noreturn]] static void runInvalidMode(const char *mode) {
  Args args;
  bool matched = setInputInvalidMode(mode, args);
  if (!matched)
    matched = setStreamKInvalidMode(mode, args);
  if (!matched)
    matched = setAITERInvalidMode(mode, args);
  if (!matched)
    matched = setScalarInvalidMode(mode, args);
  if (!matched && runOverflowInvalidMode(mode))
    fail("overflow input accepted");
  if (!matched)
    fail("unknown test mode");
  validateArgs(args);
  fail("invalid input arguments accepted");
}

int main(int argc, char **argv) {
  if (argc == 2 &&
      std::strcmp(argv[1], "aiter-device-output-conversion") == 0) {
    checkAITERDeviceOutputConversion();
    return 0;
  }
  if (argc == 2)
    runInvalidMode(argv[1]);
  if (argc != 1)
    fail("unexpected test arguments");

  checkType(InputType::F16, "f16");
  checkType(InputType::BF16, "bf16");
  checkHplType(InputType::F16, "f16",
               {0xb5dc, 0x33a1, 0xb028, 0xb61c, 0x2a95, 0x3581, 0xb509, 0xb583,
                0xb537, 0xaaa8, 0x365c, 0xb48d, 0xa801, 0x2b96, 0x304a});
  checkHplType(InputType::BF16, "bf16",
               {0xbebb, 0x3e74, 0xbe05, 0xbec3, 0x3d53, 0x3eb0, 0xbea1, 0xbeb0,
                0xbea7, 0xbd55, 0x3ecb, 0xbe92, 0xbd00, 0x3d73, 0x3e09});
  checkCPUReference(InputType::F16, "f16");
  checkCPUReference(InputType::BF16, "bf16");
  checkHplCPUReference(InputType::F16, "f16");
  checkHplCPUReference(InputType::BF16, "bf16");
  checkOutputCoordinates();
  checkOutputLayouts();
  checkAITERRunnerContract();
  checkStreamKABI();
  return 0;
}
