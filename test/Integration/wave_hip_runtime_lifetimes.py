# RUN: %python %s
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import sys
import unittest
from pathlib import Path
from unittest.mock import Mock, patch

sys.path.insert(0, str(Path(__file__).parent / "Inputs"))
from hip_runtime import Hip


class HipLifetimes(unittest.TestCase):
    def library(self, fail_allocation=None, fail_free=None):
        events = []
        library = Mock()
        library.hipInit.return_value = 0
        library.hipGetErrorString.return_value = b"injected failure"
        allocations = 0

        def load(pointer, path):
            pointer._obj.value = 100
            events.append("load")
            return 0

        def allocate(pointer, size):
            nonlocal allocations
            allocations += 1
            events.append(f"allocate {allocations}")
            if allocations == fail_allocation:
                return 1
            pointer._obj.value = allocations
            return 0

        def free(pointer):
            events.append(f"free {pointer.value}")
            return int(pointer.value == fail_free)

        def unload(pointer):
            events.append("unload")
            return 0

        library.hipModuleLoad.side_effect = load
        library.hipMalloc.side_effect = allocate
        library.hipFree.side_effect = free
        library.hipModuleUnload.side_effect = unload
        return library, events

    def test_partial_allocation(self):
        for failed in (1, 2, 3):
            library, events = self.library(fail_allocation=failed)
            with (
                self.subTest(failed=failed),
                patch("hip_runtime.ctypes.CDLL", return_value=library),
                self.assertRaisesRegex(RuntimeError, "hipMalloc"),
                Hip("injected") as hip,
            ):
                hip.load_module(Path("kernel.hsaco"))
                for _ in range(3):
                    hip.allocate(128)
            self.assertEqual(
                events,
                [
                    "load",
                    *[f"allocate {i}" for i in range(1, failed + 1)],
                    *[f"free {i}" for i in range(failed - 1, 0, -1)],
                    "unload",
                ],
            )

    def test_normal_release(self):
        library, events = self.library()
        with (
            patch("hip_runtime.ctypes.CDLL", return_value=library),
            Hip("injected") as hip,
        ):
            hip.load_module(Path("kernel.hsaco"))
            hip.allocate(128)
            hip.allocate(128)
        self.assertEqual(
            events, ["load", "allocate 1", "allocate 2", "free 2", "free 1", "unload"]
        )

    def test_cleanup_error_releases_other_resources(self):
        library, events = self.library(fail_free=2)
        with (
            patch("hip_runtime.ctypes.CDLL", return_value=library),
            self.assertRaisesRegex(RuntimeError, "hipFree") as error,
            Hip("injected") as hip,
        ):
            hip.load_module(Path("kernel.hsaco"))
            hip.allocate(128)
            hip.allocate(128)
            raise ValueError("kernel check failed")
        self.assertEqual(events[-3:], ["free 2", "free 1", "unload"])
        self.assertIsInstance(error.exception.__context__, ValueError)


if __name__ == "__main__":
    unittest.main()
