#!/usr/bin/env python3
"""Verifier-coverage gap finder.

Scans C++ files for `LogicalResult *::verify()` bodies, extracts every
string literal that flows into an `emit(Op)?Error(...)` call (including
helper functions invoked one level deep), and cross-references the
messages against `// expected-error {{...}}` annotations in `.mlir`
test files.

This is NOT a proper C++ parser. Regex and line-scanning only --
designed to surface *likely* gaps. A human still has to confirm each
candidate before writing the missing negative test.

Exit codes:
    0  no gaps
    1  at least one verifier error message has no matching test
"""

from __future__ import annotations

import argparse
import re
import sys
from collections.abc import Iterable
from pathlib import Path

WAVE_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_CPP_DIRS = (WAVE_ROOT / "lib",)
DEFAULT_TEST_DIRS = (WAVE_ROOT / "test",)

# `LogicalResult MyOp::verify() {` -- captures the qualified name.
VERIFY_DEF_RE = re.compile(
    r"^\s*(?:static\s+)?LogicalResult\s+([\w:]+)::verify\(\)\s*\{?\s*$"
)
# Free helper definition: `static? LogicalResult name(...)` with no `::`
# in the qualifier. Verifiers commonly delegate to one of these.
HELPER_DEF_RE = re.compile(r"^\s*(?:static\s+)?LogicalResult\s+(\w+)\s*\(")
# Any string literal -- we capture everything inside double quotes,
# excluding escape pairs for simplicity. Good enough for our codebase.
STRING_LITERAL_RE = re.compile(r'"((?:[^"\\]|\\.)*)"')
# Lit `expected-error` annotation: `// expected-error @whatever {{msg}}`.
EXPECTED_ERROR_RE = re.compile(r"expected-error\s*(?:@[+\-\w]*)?\s*\{\{(.+?)\}\}")
# Identifier-call pattern. Filtered against the discovered helper map.
IDENT_CALL_RE = re.compile(r"\b([A-Za-z_]\w*)\s*\(")

# Strings that appear inside emit*Error chains as plain formatting
# fragments rather than human-readable diagnostic text. Filter them.
NOISE_STRINGS = frozenset(
    {
        "",
        " ",
        ", ",
        " vs ",
        ": ",
    }
)


def find_brace_block(lines: list[str], start_idx: int) -> tuple[list[str], int]:
    """Return the body of the brace block starting on or after `lines[start_idx]`.

    Crude depth counter. Does NOT skip string literals or comments;
    string-literal braces (rare in our verifiers) could throw it off.
    Returns (body_lines, end_idx_exclusive).
    """
    body: list[str] = []
    depth = 0
    started = False
    for i in range(start_idx, len(lines)):
        line = lines[i]
        for ch in line:
            if ch == "{":
                depth += 1
                started = True
            elif ch == "}":
                depth -= 1
        if started:
            body.append(line)
            if depth == 0:
                return body, i + 1
    return body, len(lines)


def discover_helpers(lines: list[str]) -> dict[str, list[str]]:
    """Map free-helper-function name -> body lines for any
    `LogicalResult name(...)` definition in the file.

    Methods (with `::` in the name) are intentionally excluded since
    they're not callable by short name from a verifier body.
    """
    helpers: dict[str, list[str]] = {}
    for i, line in enumerate(lines):
        match = HELPER_DEF_RE.match(line)
        if not match:
            continue
        # Skip method definitions; HELPER_DEF_RE intentionally has no
        # `::` but the *prefix* (e.g. `Foo::bar`) might still appear
        # before the captured name on the same line via `Foo::`. Reject.
        if "::" in line[: match.end()]:
            continue
        body, _ = find_brace_block(lines, i)
        helpers[match.group(1)] = body
    return helpers


def _emit_chain_text(chain_lines: list[str]) -> str:
    """Splice a chain back into a single string with the `<<`-inserted
    runtime values turned into `*` wildcards. Adjacent C++ string
    literals (no `<<` between them) are concatenated by the compiler;
    this reproduces that. The result is a hopefully-representative
    rendering of the diagnostic that's substring-friendly to match
    against `expected-error` annotations."""
    blob = " ".join(chain_lines)
    # Drop everything up to and including the opening `emit*Error(`.
    blob = re.sub(r"^.*?\bemit(?:Op)?Error\s*\(", "", blob, count=1, flags=re.S)
    # Trim trailing whitespace + the final `;`. We cannot strip the
    # first `);` because for chains (`emit*Error("...") << x << "..."`)
    # the closing paren of `emit*Error` is mid-chain.
    blob = blob.rstrip("; \t\n")
    # Replace each non-string-literal `<<` argument with `*`. Walk the
    # blob and rewrite stretches of "non-literal text" into a single
    # `*`.
    pieces: list[str] = []
    pos = 0
    for m in STRING_LITERAL_RE.finditer(blob):
        if m.start() > pos:
            gap = blob[pos : m.start()]
            # `<<` is the LLVM stream operator, `+` is Twine
            # concatenation, `(` and `,` cover further argument lists.
            # Any of these means a non-literal runtime value sits
            # between the two captured literals; collapse it to `*`.
            # An empty gap (`"foo" "bar"`) is C++ adjacent-literal
            # concatenation -- leave the literals fused.
            if re.search(r"<<|\+|\(|,", gap):
                pieces.append("*")
        pieces.append(m.group(1))
        pos = m.end()
    return "".join(pieces)


def _gather_chain_lines(body: list[str], start: int) -> tuple[list[str], int]:
    """Collect lines from `start` until the trailing `;` that ends the
    emit-chain statement. Returns (chain_lines, last_idx_inclusive)."""
    chain_lines = [body[start]]
    j = start
    while ";" not in chain_lines[-1] and j + 1 < len(body):
        j += 1
        chain_lines.append(body[j])
    return chain_lines, j


def _build_chain_group(chain_lines: list[str]) -> list[str]:
    """Turn a single emit-chain (already extracted) into its fragment
    group: the wildcard-rendered full chain followed by each de-duped
    string literal. Noise fragments are dropped."""
    group: list[str] = []
    full = _emit_chain_text(chain_lines)
    if full and full not in NOISE_STRINGS:
        group.append(full)
    for chain_line in chain_lines:
        for lit_match in STRING_LITERAL_RE.finditer(chain_line):
            msg = lit_match.group(1)
            if msg in NOISE_STRINGS or msg in group:
                continue
            group.append(msg)
    return group


def _helper_calls(line: str, helpers: dict[str, list[str]]) -> list[str]:
    """Helper function names that appear as calls on `line`."""
    return [m.group(1) for m in IDENT_CALL_RE.finditer(line) if m.group(1) in helpers]


def collect_messages(
    body: list[str],
    helpers: dict[str, list[str]],
    depth: int = 0,
) -> list[list[str]]:
    """Walk a function body and return one "fragment group" per
    `emit(Op)?Error` chain found. The group is treated as one
    diagnostic for coverage purposes -- a single test matching any
    fragment covers the whole group.

    If the body contains a call to a known free helper, recurse into
    that helper's body once and merge its groups in.
    """
    groups: list[list[str]] = []
    i = 0
    while i < len(body):
        line = body[i]
        if depth < 1:
            for name in _helper_calls(line, helpers):
                groups.extend(collect_messages(helpers[name], helpers, depth + 1))
        if re.search(r"\bemit(Op)?Error\s*\(", line):
            chain_lines, last = _gather_chain_lines(body, i)
            group = _build_chain_group(chain_lines)
            if group:
                groups.append(group)
            i = last
        i += 1
    return groups


def scan_cpp(cpp_path: Path) -> list[tuple[str, list[list[str]]]]:
    """Return `(op_name, groups)` per verifier. Each group is one
    emit-chain's fragments; a group is covered iff any fragment is."""
    text = cpp_path.read_text()
    lines = text.splitlines()
    helpers = discover_helpers(lines)
    out: list[tuple[str, list[list[str]]]] = []
    for i, line in enumerate(lines):
        m = VERIFY_DEF_RE.match(line)
        if not m:
            continue
        op_name = m.group(1).split("::")[-1]
        body, _ = find_brace_block(lines, i)
        groups = collect_messages(body, helpers)
        if groups:
            out.append((op_name, groups))
    return out


def collect_expected(test_dirs: Iterable[Path]) -> list[str]:
    """Every `expected-error {{...}}` payload across all .mlir tests."""
    seen: list[str] = []
    for d in test_dirs:
        for mlir_file in d.rglob("*.mlir"):
            for m in EXPECTED_ERROR_RE.finditer(mlir_file.read_text()):
                seen.append(m.group(1))
    return seen


def _normalise(s: str) -> str:
    """Strip lit-irrelevant punctuation/whitespace from both ends so
    that fragment matching ignores the trailing `: ` that verifier
    chains carry but test annotations typically omit."""
    return s.strip().strip(":,; ").strip()


def _covered(msg: str, expected: list[str]) -> bool:
    """A verifier fragment is considered covered if *some* test
    annotation, after normalisation, either contains the fragment or
    is contained by it. The bidirectional check absorbs the case where
    the verifier chain adds runtime formatting (`"prefix: "` + value)
    but the test only asserts the prefix without the colon."""
    m = _normalise(msg)
    if not m:
        return True
    for exp in expected:
        e = _normalise(exp)
        if not e:
            continue
        # Wildcard `*` segments in the chain rendering match anything.
        if "*" in m:
            pat = "(.*)".join(re.escape(seg) for seg in m.split("*"))
            if re.search(pat, e):
                return True
        if m in e or e in m:
            return True
    return False


def _group_canonical(group: list[str]) -> str:
    """Pick the longest fragment in a group as the representative
    diagnostic for display. The longest fragment is typically the
    full chain rendering with `*` wildcards, which is the closest
    approximation of what the user would see at runtime."""
    return max(group, key=lambda m: len(_normalise(m)))


def find_gaps(
    verifiers: list[tuple[Path, str, list[list[str]]]],
    expected: list[str],
) -> list[tuple[Path, str, str]]:
    """One gap per uncovered emit-chain group. A group is covered iff
    at least one of its fragments matches some `expected-error {{...}}`
    annotation."""
    gaps: list[tuple[Path, str, str]] = []
    for cpp_path, op, groups in verifiers:
        seen_repr: set[str] = set()
        for group in groups:
            if any(_covered(fragment, expected) for fragment in group):
                continue
            repr_msg = _group_canonical(group)
            key = _normalise(repr_msg)
            if not key or key in seen_repr:
                continue
            seen_repr.add(key)
            gaps.append((cpp_path, op, repr_msg))
    return gaps


def _scan_all_verifiers(
    cpp_dirs: Iterable[Path],
) -> list[tuple[Path, str, list[list[str]]]]:
    out: list[tuple[Path, str, list[list[str]]]] = []
    for d in cpp_dirs:
        for cpp_path in d.rglob("*.cpp"):
            for op, msgs in scan_cpp(cpp_path):
                out.append((cpp_path.relative_to(WAVE_ROOT), op, msgs))
    return out


def _print_gaps(gaps: list[tuple[Path, str, str]]) -> None:
    current_op = None
    for cpp_path, op, msg in sorted(gaps, key=lambda t: (str(t[0]), t[1])):
        if op != current_op:
            print(f"  {op:<40} {cpp_path}")
            current_op = op
        print(f"      {msg!r}")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument(
        "--cpp-dir",
        action="append",
        type=Path,
        help="Directory tree to scan for verifier bodies (default: lib/).",
    )
    ap.add_argument(
        "--test-dir",
        action="append",
        type=Path,
        help="Directory tree to scan for .mlir tests (default: test/).",
    )
    args = ap.parse_args()

    cpp_dirs = args.cpp_dir or list(DEFAULT_CPP_DIRS)
    test_dirs = args.test_dir or list(DEFAULT_TEST_DIRS)

    all_verifiers = _scan_all_verifiers(cpp_dirs)
    expected = collect_expected(test_dirs)
    gaps = find_gaps(all_verifiers, expected)

    total_groups = sum(len(g) for _, _, g in all_verifiers)
    total_fragments = sum(len(frag) for _, _, g in all_verifiers for frag in g)
    print(
        f"Scanned {len(all_verifiers)} verifier(s), {total_groups} "
        f"emit-chain(s) totalling {total_fragments} fragment(s)."
    )
    print(f"Found {len(expected)} expected-error annotation(s) across tests.")
    print(f"Coverage gap: {len(gaps)} diagnostic(s) with no matching test.")

    if gaps:
        print()
        _print_gaps(gaps)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
