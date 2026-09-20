import os
import shutil
import subprocess
import sys
from pathlib import Path

from wave_tlx import wave_bridge_tools


def test_backend_source_hash_tracks_edits_across_processes(tmp_path):
    package = tmp_path / "wave_tlx"
    shutil.copytree(Path(wave_bridge_tools.__file__).parent, package)
    env = {**os.environ, "PYTHONPATH": str(tmp_path)}

    def source_hash():
        return subprocess.check_output(
            [
                sys.executable,
                "-c",
                "from wave_tlx.wave_bridge_tools import backend_source_sha256; "
                "print(backend_source_sha256())",
            ],
            cwd=tmp_path,
            env=env,
            text=True,
        ).strip()

    original = source_hash()
    assert source_hash() == original
    source = package / "converter" / "source_import.py"
    text = source.read_text()
    source.write_text(text.replace('STAGE = "import"', 'STAGE = "changed_import"'))
    assert source_hash() != original
    source.write_text(text)
    assert source_hash() == original
    source.rename(source.with_name("renamed_import.py"))
    assert source_hash() != original


def test_binding_overrides_precede_builds_and_existing_paths(tmp_path, monkeypatch):
    source_root = tmp_path / "source"
    build = tmp_path / "build"
    override = tmp_path / "override"
    second_override = tmp_path / "second_override"
    paths = [
        override,
        second_override,
        build / "python_packages" / "wave_mlir",
        source_root / "build" / "python_packages" / "wave_mlir",
        source_root / "build" / "wave-build" / "python_packages" / "wave_mlir",
    ]
    for path in paths:
        path.mkdir(parents=True)
    monkeypatch.setattr(wave_bridge_tools, "_wave_source_root", lambda: source_root)
    monkeypatch.setenv("TRITON_WAVE_BUILD_DIR", str(build))
    monkeypatch.setenv(
        "TRITON_WAVE_PYTHONPATH",
        os.pathsep.join(map(str, (override, second_override, override))),
    )
    monkeypatch.setattr(sys, "path", [str(paths[-1]), "installed", str(override)])

    wave_bridge_tools._add_wave_python_paths()
    assert sys.path == [*map(str, paths), "installed"]
    wave_bridge_tools._add_wave_python_paths()
    assert sys.path == [*map(str, paths), "installed"]
