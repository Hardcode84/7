//===- wave_matmul_rand_int_test.cpp - rand_int input test ------*- C++ -*-===//
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

  std::vector<uint8_t> a = makeInputBytes(rows, k, type, 0, 0, false, true);
  std::vector<uint8_t> repeated =
      makeInputBytes(rows, k, type, 91, 0, false, true);
  std::vector<uint8_t> b = makeInputBytes(rows, k, type, 0, 1, false, true);
  if (a != repeated)
    fail("rand_int changed with calibration seed");
  if (a == b)
    fail("rand_int A/B streams match");
  checkValues(a, type, expectedA);
  checkValues(b, type, expectedB);
  std::printf("rand_int_%s: ok\n", label);
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

int main(int argc, char **argv) {
  if (argc == 2) {
    Args args;
    if (std::strcmp(argv[1], "mutual-exclusion") == 0) {
      args.allOnes = true;
      args.randInt = true;
    } else if (std::strcmp(argv[1], "mxfp4") == 0) {
      args.inputType = InputType::MXFP4;
      args.waveSize = 64;
      args.randInt = true;
    } else {
      fail("unknown test mode");
    }
    validateArgs(args);
    fail("invalid rand_int arguments accepted");
  }
  if (argc != 1)
    fail("unexpected test arguments");

  checkType(InputType::F16, "f16");
  checkType(InputType::BF16, "bf16");
  checkCPUReference(InputType::F16, "f16");
  checkCPUReference(InputType::BF16, "bf16");
  checkOutputCoordinates();
  return 0;
}
