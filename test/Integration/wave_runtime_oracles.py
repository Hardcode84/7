# RUN: %python %s
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "Inputs"))
from wavec_saxpy_ctypes_runner import check_result
from wavec_wmma_matmul_ctypes_runner import check_close, half_bits, reference_output


class RuntimeOracles(unittest.TestCase):
    def test_saxpy_rejects_nonfinite(self):
        for value in [float("nan"), float("inf"), -float("inf")]:
            with self.subTest(value=value), self.assertRaises(AssertionError):
                check_result([value], [1.0], [2.0], 1.0, 1)

    def test_saxpy_size_and_inactive_lanes(self):
        with self.assertRaises(AssertionError):
            check_result([], [1.0], [2.0], 1.0, 1)
        check_result([3.0, 4.0], [1.0, 8.0], [2.0, 4.0], 1.0, 1)
        with self.assertRaises(AssertionError):
            check_result([3.0, 12.0], [1.0, 8.0], [2.0, 4.0], 1.0, 1)

    def test_wmma_rejects_nonfinite(self):
        for value in [float("nan"), float("inf"), -float("inf")]:
            with self.subTest(value=value), self.assertRaises(AssertionError):
                check_close([value] * 256, list(range(256)), 0.01)

    def test_wmma_rejects_size_and_order(self):
        expected = list(range(256))
        for actual in [[], expected[:-1], expected * 2, expected[::-1]]:
            with self.subTest(size=len(actual)), self.assertRaises(AssertionError):
                check_close(actual, expected, 0.01)
        check_close(expected, expected, 0.01)

    def test_wmma_tolerance(self):
        for tolerance in [float("nan"), float("inf"), -1.0]:
            with self.subTest(tolerance=tolerance), self.assertRaises(ValueError):
                check_close([0.0] * 256, [0.0] * 256, tolerance)

    def test_wmma_fragment_storage(self):
        identity = [half_bits(float(i == j)) for i in range(16) for j in range(16)]
        columns = [
            half_bits(float(row * 16 + col)) for col in range(16) for row in range(16)
        ]
        result = reference_output(identity, columns, 16, 16, 16)
        self.assertEqual(result[:8], [0, 32, 64, 96, 128, 160, 192, 224])
        self.assertEqual(result[128:136], [16, 48, 80, 112, 144, 176, 208, 240])
        self.assertEqual(sorted(result), list(range(256)))


if __name__ == "__main__":
    unittest.main()
