#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail

if [[ $# -gt 1 ]]; then
  echo "Usage: $0 [output.pdf]" >&2
  exit 2
fi
if [[ ${1:-} == --help ]]; then
  echo "Usage: $0 [output.pdf]"
  echo "Requires Bun and Firefox. Installs pinned Marp dependencies with Bun."
  echo "Default output: build/slides/ProjectOverviewSlides.pdf"
  exit 0
fi

for tool in bun firefox; do
  if ! command -v "$tool" >/dev/null; then
    echo "Required tool not found: $tool" >&2
    exit 1
  fi
done

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
marp_dir="$repo_root/build_tools/slides"
output=${1:-"$repo_root/build/slides/ProjectOverviewSlides.pdf"}
if [[ $output != *.pdf ]]; then
  echo "Output path must end in .pdf: $output" >&2
  exit 2
fi

bun install --cwd "$marp_dir" --frozen-lockfile
mkdir -p -- "$(dirname -- "$output")"
# Firefox Snap needs a non-hidden profile outside its private /tmp namespace.
marp_tmp=$(mktemp -d "${HOME}/wave-marp-XXXXXXXX")
trap 'rm -rf -- "$marp_tmp"' EXIT
TMPDIR="$marp_tmp" bun --bun "$marp_dir/node_modules/@marp-team/marp-cli/marp-cli.js" \
  "$repo_root/docs/ProjectOverviewSlides.md" \
  --browser firefox --pdf --output "$output"
