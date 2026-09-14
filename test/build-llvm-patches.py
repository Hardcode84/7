# RUN: %python %s
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from build_tools import build_llvm


class LLVMPatchTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.source = self.root / "source"
        self.source.mkdir()
        subprocess.run(["git", "init", "-q", str(self.source)], check=True)
        self.patches = self.root / "patches"
        self.patches.mkdir()
        self.patch_path = self.patches / "fix.patch"
        self.patch_path.write_text(
            "diff --git a/input.txt b/input.txt\n"
            "--- a/input.txt\n"
            "+++ b/input.txt\n"
            "@@ -1 +1 @@\n"
            "-before\n"
            "+after\n"
        )
        self.input_path = self.source / "input.txt"
        self.input_path.write_text("before\n")
        self.addCleanup(patch.stopall)
        patch.object(build_llvm, "PATCH_DIR", self.patches).start()

    def test_apply_is_idempotent(self):
        build_llvm.apply_patches(self.source)
        self.assertEqual(self.input_path.read_text(), "after\n")
        build_llvm.apply_patches(self.source)
        self.assertEqual(self.input_path.read_text(), "after\n")

    def add_overlapping_patch(self):
        path = self.patches / "next.patch"
        path.write_text(
            self.patch_path.read_text()
            .replace("-before", "-after")
            .replace("+after", "+final")
        )

    def test_overlapping_stack_is_idempotent(self):
        self.add_overlapping_patch()
        build_llvm.apply_patches(self.source)
        self.assertEqual(self.input_path.read_text(), "final\n")
        timestamp = self.input_path.stat().st_mtime_ns
        build_llvm.apply_patches(self.source)
        self.assertEqual(self.input_path.stat().st_mtime_ns, timestamp)

    def test_extend_applied_prefix(self):
        build_llvm.apply_patches(self.source)
        self.add_overlapping_patch()
        build_llvm.apply_patches(self.source)
        self.assertEqual(self.input_path.read_text(), "final\n")

    def test_later_conflict_preserves_source(self):
        self.add_overlapping_patch()
        path = self.patches / "next.patch"
        path.write_text(path.read_text().replace("-after", "-conflict"))
        with self.assertRaises(subprocess.CalledProcessError):
            build_llvm.apply_patches(self.source)
        self.assertEqual(self.input_path.read_text(), "before\n")

    def test_applied_stack_conflict_preserves_source(self):
        self.add_overlapping_patch()
        build_llvm.apply_patches(self.source)
        self.input_path.write_text("user edit\n")
        with self.assertRaises(subprocess.CalledProcessError):
            build_llvm.apply_patches(self.source)
        self.assertEqual(self.input_path.read_text(), "user edit\n")

    def test_conflict_preserves_source(self):
        self.input_path.write_text("user edit\n")
        with self.assertRaises(subprocess.CalledProcessError):
            build_llvm.apply_patches(self.source)
        self.assertEqual(self.input_path.read_text(), "user edit\n")

    def test_patch_change_invalidates_install(self):
        install = self.root / "install"
        for package in ("llvm", "mlir", "clang", "lld"):
            (install / "lib" / "cmake" / package).mkdir(parents=True)
        for path in build_llvm.required_install_files(install, False, False):
            path.parent.mkdir(parents=True, exist_ok=True)
            path.touch()
        (install / build_llvm.STAMP_FILE).write_text("commit\n")
        patch_stamp = install / build_llvm.PATCH_STAMP_FILE
        self.assertFalse(build_llvm.already_installed(install, "commit", False, False))
        patch_stamp.write_text(build_llvm.patch_fingerprint() + "\n")
        config_stamp = install / build_llvm.CONFIG_STAMP_FILE
        config_stamp.write_text(build_llvm.build_config_stamp(False, False))
        self.assertTrue(build_llvm.already_installed(install, "commit", False, False))
        self.assertFalse(build_llvm.already_installed(install, "commit", True, False))
        self.patch_path.write_text(
            self.patch_path.read_text().replace("+after", "+fixed")
        )
        self.assertFalse(build_llvm.already_installed(install, "commit", False, False))


if __name__ == "__main__":
    unittest.main()
