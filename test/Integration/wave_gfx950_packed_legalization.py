# REQUIRES: wave-python-bindings
# RUN: %python %s %wave_obj_root | FileCheck %s
# CHECK: default: packed F32 legalization passed
# CHECK: unscheduled: packed F32 legalization passed
# CHECK: baseline: packed F32 legalization passed
# CHECK: scheduled: packed F32 legalization passed

import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT / "tools"))

import wave_calibration  # noqa: E402

PACKED_F32 = re.compile(r"\bv_pk_(?:add|mul|fma)_f32\b")


def run(command, env=None):
    result = subprocess.run(command, env=env, capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(f"{command}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def check_asm(asm, cases):
    if not cases:
        assert "v_mfma_" in asm, "GLU must retain its matrix operations"
        assert not PACKED_F32.search(asm), "GLU retains packed F32"
        return
    scaled, packed = asm.split("\npacked:", 1)
    assert "v_mfma_scale_" in scaled, "scaled MFMA must remain live"
    assert not PACKED_F32.search(scaled), "scaled MFMA function retains packed F32"
    for kind in ("add", "mul", "fma"):
        assert f"v_{kind}_f32" in scaled, f"missing scalar {kind}"
        assert f"v_pk_{kind}_f32" in packed, f"non-matrix function lost packed {kind}"


def main():
    build_dir = Path(sys.argv[1]).resolve()
    translate = str(build_dir / "bin" / "wave-translate")
    opt = str(build_dir / "bin" / "wave-opt")
    library = wave_calibration.backend_pipeline_path(build_dir)
    sources = (
        REPO_ROOT / "test/PerfGolden/Inputs/tlx_glu_optimized.mlir",
        REPO_ROOT / "test/Integration/Inputs/gfx950_packed_legalization.mlir",
    )
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        for name in ("default", "unscheduled", "baseline", "scheduled"):
            env = os.environ.copy()
            env["WAVE_PIPELINES_DIR"] = str(library.parent)
            if name in wave_calibration.VARIANTS:
                pipeline = wave_calibration.prepare_variant_pipeline(
                    build_dir, work, variant=wave_calibration.VARIANTS[name]
                )
                env["WAVE_PIPELINES_DIR"] = str(pipeline.parent)
            for source in sources:
                input_path = source
                if name == "unscheduled":
                    input_path = work / source.name
                    run(
                        [
                            opt,
                            str(source),
                            "--pass-pipeline=builtin.module("
                            "transform-preload-library{transform-library-paths="
                            f"{library}"
                            "},transform-interpreter{"
                            "entry-point=waveamd_backend_unscheduled})",
                            "-o",
                            str(input_path),
                        ]
                    )
                    env["WAVE_PIPELINES_DIR"] = str(
                        REPO_ROOT / "test/Target/Wave/Inputs/emit-only-pipeline"
                    )
                asm = run([translate, str(input_path), "--wave-to-amdgpu-asm"], env)
                check_asm(asm, source == sources[1])
            print(f"{name}: packed F32 legalization passed")


if __name__ == "__main__":
    main()
