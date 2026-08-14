#!/usr/bin/env python3
"""Collect and validate canonical Wave index-expression corpora."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

SCHEMA = "wave-index-expr-corpus-v3"
STAGE = "canonical-memory-relations-and-pre-div-index-exprs"
PREFIX_PASSES = (
    "waveamd-clear-regalloc-assignments",
    "wavemeta-specialize",
    "canonicalize",
    "wave-normalize-integer-div-rem",
    "wave-lower-redistribute",
    "wave-lower-symbolic-memory",
    "wave-strength-reduce-modulo",
    "wave-normalize-pointer-offsets",
    "wave-generate-index-exprs",
    "wave-promote-global-to-buffer",
    "wave-combine-pointer-offsets",
    "wave-simplify-index-exprs",
    "wave-coalesce-memory",
    "canonicalize",
    "cse",
    "waveamd-deduplicate-writes",
    "wave-balance-reassociable-math",
    "wave-form-packed-math",
    "canonicalize",
    "cse",
    "wave-normalize-pointer-offsets",
    "wave-generate-index-exprs",
    "wave-combine-pointer-offsets",
    "wave-simplify-index-exprs",
    "wave-promote-global-to-buffer",
    "wave-extract-loop-strides",
    "waveamd-dma-zero-fill",
    "loop-invariant-code-motion",
    "wave-optimize-masks",
)
PASS_PIPELINE = "builtin.module(" + ",".join(PREFIX_PASSES) + ")"
PASS_RE = re.compile(r'transform\.apply_registered_pass "([^"]+)"')


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


class _SymbolicDecoder:
    def __init__(self, context, expr_attr, pred_attr, memory_mapping_attr):
        self.context = context
        self.expr_attr = expr_attr
        self.pred_attr = pred_attr
        self.memory_mapping_attr = memory_mapping_attr

    def _rename(self, attribute, attr_type, names: list[str]) -> str:
        expr = self.context.deserialize(attr_type(attribute).to_bytes())
        replacements = {
            name: self.context.sym(f"b{index}") for index, name in enumerate(names)
        }
        return str(expr.subs(replacements))

    def expression(self, attribute, names: list[str]) -> str:
        return self._rename(attribute, self.expr_attr, names)

    def predicate(self, attribute, names: list[str]) -> str:
        return self._rename(attribute, self.pred_attr, names)

    def memory_bit_offset(self, attribute, names: list[str]) -> str:
        mapping = self.memory_mapping_attr(attribute)
        return self.expression(mapping.bit_offset, names)


def _signature(record: dict[str, object]) -> dict[str, object]:
    return {
        "kind": record["kind"],
        "expression": record["expression"],
        "assumptions": record["assumptions"],
        "operand_types": record["operand_types"],
        "result_type": record["result_type"],
    }


def _record_id(record: dict[str, object]) -> str:
    encoded = json.dumps(
        _signature(record), sort_keys=True, separators=(",", ":")
    ).encode()
    return _sha256(encoded)[:20]


def _pipeline_prefix(pipeline_file: Path) -> tuple[str, ...]:
    passes = []
    in_lowering = False
    for line in pipeline_file.read_text().splitlines():
        if "transform.named_sequence @waveamd_backend_lower" in line:
            in_lowering = True
        if not in_lowering:
            continue
        match = PASS_RE.search(line)
        if not match:
            continue
        name = match.group(1)
        if name == "wave-expand-integer-div-rem":
            return tuple(passes)
        passes.append(name)
    raise ValueError(f"cannot find wave-expand-integer-div-rem in {pipeline_file}")


def _check_pipeline(pipeline_file: Path) -> None:
    actual = _pipeline_prefix(pipeline_file)
    if actual != PREFIX_PASSES:
        raise ValueError(
            "corpus pipeline no longer matches waveamd_backend_lower before "
            f"wave-expand-integer-div-rem:\nexpected {PREFIX_PASSES}\nactual   {actual}"
        )


def _run_prefix(wave_opt: Path, source: Path) -> str:
    result = subprocess.run(
        [
            str(wave_opt),
            str(source),
            f"--pass-pipeline={PASS_PIPELINE}",
            "-o",
            "-",
        ],
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"failed to lower {source} to the corpus boundary:\n{result.stderr}"
        )
    return result.stdout


def _index_expr_record(
    operation,
    source: dict[str, str],
    function: str,
    block_id: int,
    loop_depth: int,
    control_depth: int,
    ordinal: int,
    value_infos,
    mlir_ir,
    decoder: _SymbolicDecoder,
) -> dict[str, object]:
    names = [
        mlir_ir.StringAttr(value).value
        for value in mlir_ir.ArrayAttr(operation.attributes["names"])
    ]
    expression = decoder.expression(operation.attributes["expr"], names)
    assumptions = sorted(
        {
            decoder.predicate(value, names)
            for value in mlir_ir.ArrayAttr(operation.attributes["assumptions"])
        }
    )
    consumers = sorted({use.owner.name for use in operation.results[0].uses})
    record = {
        "kind": "index_expr",
        "expression": expression,
        "assumptions": assumptions,
        "operand_types": [str(value.type) for value in operation.operands],
        "result_type": str(operation.results[0].type),
        "occurrence": {
            **source,
            "function": function,
            "ordinal": ordinal,
            "block": block_id,
            "loop_depth": loop_depth,
            "control_depth": control_depth,
            "consumers": consumers,
            "binding_ids": [value_infos[value]["id"] for value in operation.operands],
            "binding_blocks": [
                value_infos[value]["block"] for value in operation.operands
            ],
            "binding_loop_depths": [
                value_infos[value]["loop_depth"] for value in operation.operands
            ],
            "binding_control_depths": [
                value_infos[value]["control_depth"] for value in operation.operands
            ],
        },
    }
    record["id"] = _record_id(record)
    return record


def _memory_relation_record(
    operation,
    source: dict[str, str],
    function: str,
    block_id: int,
    loop_depth: int,
    control_depth: int,
    ordinal: int,
    value_infos,
    mlir_ir,
    decoder: _SymbolicDecoder,
) -> dict[str, object]:
    names = [
        mlir_ir.StringAttr(value).value
        for value in mlir_ir.ArrayAttr(operation.attributes["binding_names"])
    ]
    expression = decoder.memory_bit_offset(operation.attributes["mapping"], names)
    segments = list(operation.attributes["operandSegmentSizes"])
    binding_start = (
        segments[0] if operation.name == "wave.gather" else sum(segments[:2])
    )
    bindings = list(operation.operands)[binding_start : binding_start + len(names)]
    record = {
        "kind": "memory_relation",
        "expression": expression,
        "assumptions": [],
        "operand_types": [str(value.type) for value in bindings],
        "result_type": "index",
        "occurrence": {
            **source,
            "function": function,
            "ordinal": ordinal,
            "block": block_id,
            "loop_depth": loop_depth,
            "control_depth": control_depth,
            "consumers": [operation.name],
            "binding_ids": [value_infos[value]["id"] for value in bindings],
            "binding_blocks": [value_infos[value]["block"] for value in bindings],
            "binding_loop_depths": [
                value_infos[value]["loop_depth"] for value in bindings
            ],
            "binding_control_depths": [
                value_infos[value]["control_depth"] for value in bindings
            ],
        },
    }
    record["id"] = _record_id(record)
    return record


class _RecordExtractor:
    def __init__(
        self,
        source,
        mlir_ir,
        decoder,
        include_index_exprs: bool,
        include_memory_relations: bool,
    ):
        self.source = source
        self.mlir_ir = mlir_ir
        self.decoder = decoder
        self.include_index_exprs = include_index_exprs
        self.include_memory_relations = include_memory_relations
        self.records = []
        self.value_infos = {}
        self.ordinal = 0
        self.next_block = 0
        self.next_value = 0

    def _assign_value(
        self, value, block_id: int, loop_depth: int, control_depth: int
    ) -> None:
        if value in self.value_infos:
            return
        self.value_infos[value] = {
            "id": f"v{self.next_value}",
            "block": block_id,
            "loop_depth": loop_depth,
            "control_depth": control_depth,
        }
        self.next_value += 1

    def _record(
        self,
        operation,
        function: str,
        block_id: int,
        loop_depth: int,
        control_depth: int,
    ) -> None:
        if self.include_index_exprs and operation.name == "wave.index_expr":
            builder = _index_expr_record
        elif self.include_memory_relations and operation.name in {
            "wave.gather",
            "wave.scatter",
        }:
            builder = _memory_relation_record
        else:
            return
        self.records.append(
            builder(
                operation,
                self.source,
                function,
                block_id,
                loop_depth,
                control_depth,
                self.ordinal,
                self.value_infos,
                self.mlir_ir,
                self.decoder,
            )
        )
        self.ordinal += 1

    def _visit(
        self,
        operation,
        function: str,
        block_id: int,
        loop_depth: int,
        control_depth: int,
    ) -> None:
        for result in operation.results:
            self._assign_value(result, block_id, loop_depth, control_depth)
        if operation.name == "func.func":
            function = self.mlir_ir.StringAttr(operation.attributes["sym_name"]).value
        self._record(operation, function, block_id, loop_depth, control_depth)
        nested_loop_depth = loop_depth + (operation.name == "scf.for")
        nested_control_depth = control_depth + (
            operation.name in {"scf.if", "wave.where"}
        )
        for region in operation.regions:
            for block in region.blocks:
                nested_block = self.next_block
                self.next_block += 1
                for argument in block.arguments:
                    self._assign_value(
                        argument,
                        nested_block,
                        nested_loop_depth,
                        nested_control_depth,
                    )
                for child in block.operations:
                    self._visit(
                        child.operation,
                        function,
                        nested_block,
                        nested_loop_depth,
                        nested_control_depth,
                    )

    def extract(self, operation) -> list[dict[str, object]]:
        self._visit(operation, "", -1, 0, 0)
        return self.records


def _extract_records(
    ir,
    source: dict[str, str],
    *,
    include_index_exprs: bool = True,
    include_memory_relations: bool = False,
) -> list[dict[str, object]]:
    import ixsimpl
    from mlir import ir as mlir_ir
    from mlir.dialects import wave

    with mlir_ir.Context() as context:
        wave.register_dialects(context)
        context.allow_unregistered_dialects = True
        decoder = _SymbolicDecoder(
            ixsimpl.Context(), wave.ExprAttr, wave.PredAttr, wave.MemoryMappingAttr
        )
        module = mlir_ir.Module.parse(ir)
        extractor = _RecordExtractor(
            source,
            mlir_ir,
            decoder,
            include_index_exprs,
            include_memory_relations,
        )
        return extractor.extract(module.operation)


def _source_identity(root: Path, path: Path) -> dict[str, str]:
    relative = path.relative_to(root)
    data = path.read_bytes()
    return {
        "group": relative.parts[0] if len(relative.parts) > 1 else ".",
        "source": path.name,
        "source_sha256": _sha256(data),
    }


def _merge_records(
    records: list[dict[str, object]], source_count: int
) -> dict[str, object]:
    expressions: dict[str, dict[str, object]] = {}
    for record in records:
        record_id = record["id"]
        entry = expressions.setdefault(
            record_id,
            {
                "id": record_id,
                **_signature(record),
                "occurrences": [],
            },
        )
        entry["occurrences"].append(record["occurrence"])
    for entry in expressions.values():
        aggregated = {}
        for occurrence in entry["occurrences"]:
            occurrence = dict(occurrence)
            occurrence.pop("ordinal")
            key = json.dumps(occurrence, sort_keys=True, separators=(",", ":"))
            aggregated.setdefault(key, {**occurrence, "count": 0})["count"] += 1
        entry["occurrences"] = sorted(
            aggregated.values(),
            key=lambda item: (
                item["group"],
                item["source"],
                item["source_sha256"],
                item["function"],
                item["block"],
                item["binding_ids"],
            ),
        )
    groups: dict[str, int] = {}
    unique_sources = set()
    for record in records:
        occurrence = record["occurrence"]
        key = (
            occurrence["group"],
            occurrence["source"],
            occurrence["source_sha256"],
        )
        if key in unique_sources:
            continue
        unique_sources.add(key)
        groups[occurrence["group"]] = groups.get(occurrence["group"], 0) + 1
    if len(unique_sources) != source_count:
        raise ValueError(
            f"expected {source_count} distinct sources, found {len(unique_sources)}"
        )
    return {
        "schema": SCHEMA,
        "stage": STAGE,
        "pipeline_sha256": _sha256(PASS_PIPELINE.encode()),
        "source_count": source_count,
        "occurrence_count": len(records),
        "expression_count": len(expressions),
        "groups": dict(sorted(groups.items())),
        "expressions": [expressions[key] for key in sorted(expressions)],
    }


def _write_corpus(path: Path, corpus: dict[str, object]) -> None:
    encoded = (json.dumps(corpus, indent=2, sort_keys=True) + "\n").encode()
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.suffix == ".gz":
        path.write_bytes(gzip.compress(encoded, compresslevel=9, mtime=0))
    else:
        path.write_bytes(encoded)


def _read_corpus(path: Path) -> dict[str, object]:
    encoded = path.read_bytes()
    if path.suffix == ".gz":
        encoded = gzip.decompress(encoded)
    return json.loads(encoded)


def collect(args) -> None:
    root = args.input.resolve()
    build = args.wave_build_dir.resolve()
    wave_opt = (args.wave_opt or build / "bin" / "wave-opt").resolve()
    pipeline_file = build / "share" / "wave-mlir" / "pipelines" / "pipelines.mlir"
    python_root = build / "python_packages" / "wave_mlir"
    if str(python_root) not in sys.path:
        sys.path.insert(0, str(python_root))
    _check_pipeline(pipeline_file)
    sources = sorted(root.rglob("*.wave"))
    if not sources:
        raise ValueError(f"no .wave sources found under {root}")
    identities = {path: _source_identity(root, path) for path in sources}
    unique_sources = {}
    for path in sources:
        identity = identities[path]
        key = (identity["group"], identity["source"], identity["source_sha256"])
        unique_sources.setdefault(key, path)
    sources = list(unique_sources.values())
    records = []
    workers = args.workers or os.cpu_count() or 1
    with ThreadPoolExecutor(max_workers=workers) as executor:
        futures = {
            executor.submit(_run_prefix, wave_opt, source): source for source in sources
        }
        for future in as_completed(futures):
            source = futures[future]
            lowered = future.result()
            records.extend(_extract_records(lowered, identities[source]))
            records.extend(
                _extract_records(
                    source.read_text(),
                    identities[source],
                    include_index_exprs=False,
                    include_memory_relations=True,
                )
            )
    corpus = _merge_records(records, len(sources))
    _write_corpus(args.output, corpus)


def _validate_entry(entry) -> tuple[str, int, set[tuple[str, str, str]]]:
    expected = _record_id(entry)
    if entry.get("id") != expected:
        raise ValueError(
            f"invalid expression id {entry.get('id')}, expected {expected}"
        )
    occurrences = entry.get("occurrences")
    if not isinstance(occurrences, list) or not occurrences:
        raise ValueError(f"expression {expected} has no occurrences")
    occurrence_count = 0
    sources = set()
    for occurrence in occurrences:
        count = occurrence.get("count")
        if not isinstance(count, int) or isinstance(count, bool) or count <= 0:
            raise ValueError(f"expression {expected} has invalid occurrence count")
        occurrence_count += count
        sources.add(
            (
                occurrence["group"],
                occurrence["source"],
                occurrence["source_sha256"],
            )
        )
    return expected, occurrence_count, sources


def _validate_expressions(expressions) -> tuple[int, set[tuple[str, str, str]]]:
    ids = []
    occurrence_count = 0
    sources = set()
    for entry in expressions:
        entry_id, entry_count, entry_sources = _validate_entry(entry)
        ids.append(entry_id)
        occurrence_count += entry_count
        sources.update(entry_sources)
    if ids != sorted(set(ids)):
        raise ValueError("expression ids are not unique and sorted")
    return occurrence_count, sources


def _validated_expressions(corpus):
    if corpus.get("schema") != SCHEMA or corpus.get("stage") != STAGE:
        raise ValueError("unexpected corpus schema or pipeline stage")
    if corpus.get("pipeline_sha256") != _sha256(PASS_PIPELINE.encode()):
        raise ValueError("corpus pipeline fingerprint does not match collector")
    expressions = corpus.get("expressions")
    if not isinstance(expressions, list) or not expressions:
        raise ValueError("corpus has no expressions")
    return expressions


def _validate_totals(corpus, expressions, occurrence_count: int, sources) -> None:
    if len(expressions) != corpus.get("expression_count"):
        raise ValueError("expression count does not match corpus header")
    if occurrence_count != corpus.get("occurrence_count"):
        raise ValueError("occurrence count does not match corpus header")
    if len(sources) != corpus.get("source_count"):
        raise ValueError("source count does not match corpus header")


def _validate_groups(corpus, sources, required_groups) -> None:
    groups = {}
    for group, _, _ in sources:
        groups[group] = groups.get(group, 0) + 1
    groups = dict(sorted(groups.items()))
    if groups != corpus.get("groups"):
        raise ValueError("source groups do not match corpus header")
    missing = sorted(set(required_groups) - set(groups))
    if missing:
        raise ValueError(f"corpus is missing required groups: {', '.join(missing)}")


def validate(args) -> None:
    corpus = _read_corpus(args.corpus)
    expressions = _validated_expressions(corpus)
    occurrence_count, sources = _validate_expressions(expressions)
    _validate_totals(corpus, expressions, occurrence_count, sources)
    _validate_groups(corpus, sources, args.require_group)
    print(
        f"validated {len(expressions)} expressions, {occurrence_count} occurrences, "
        f"{len(sources)} sources"
    )


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    collect_parser = subparsers.add_parser("collect")
    collect_parser.add_argument("input", type=Path)
    collect_parser.add_argument("output", type=Path)
    collect_parser.add_argument("--wave-build-dir", type=Path, required=True)
    collect_parser.add_argument("--wave-opt", type=Path)
    collect_parser.add_argument("--workers", type=int, default=0)
    collect_parser.set_defaults(run=collect)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("corpus", type=Path)
    validate_parser.add_argument("--require-group", action="append", default=[])
    validate_parser.set_defaults(run=validate)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    args.run(args)


if __name__ == "__main__":
    main()
