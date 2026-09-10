# Cleanup baseline

Source: `a1aa0bf948dcc4b197bd383e23999a3863657fee`.

This baseline supports code removal and shared-helper changes. Preserve
functionality, generated code, diagnostics, and compilation time. It does not
authorize changes to allocation policy, scheduling policy, or memory ordering.

## Frozen artifacts

The tracker records the artifact directory. Set `BASELINE_ROOT` to that directory.
Keep these files until aggregate validation is complete:

- `source/`: source archive, submodule source, copied tools, Python package,
  pipelines, and headers needed by the selected C++ compilation commands.
- `metadata/`: source state, submodule refs, CMake cache, Ninja compilation
  commands, compiler version, CPU information, and shared-library dependencies.
- `inputs/`: generated kernel MLIR and the unscheduled TensileLite pipeline.
- `frozen-sha256.json`: hashes of frozen source and build inputs.
- `host-sha256.json` and `verify.py`: host-file hashes and artifact verification.
- `output-sha256.json`: hashes of the 63 accepted output files.
- `workloads.json`: commands, pipeline selection, and required output files.
- `results/baseline/`: output references, raw samples, command logs, and summaries.
- `run.py` and `build_samples.py`: replay tools for the selected workloads.

The Python extension aliases must resolve to one shared library. Separate copies
load separate MLIR registries. The snapshot preserves these aliases. System
libraries and the Python environment remain host dependencies; verify their
recorded versions and hashes before each comparison.

## Build configuration

The baseline uses GCC Release with `-O3 -DNDEBUG`. Wave compilation commands also
use `-UNDEBUG` and `_GLIBCXX_ASSERTIONS`. Python bindings are enabled. Use the
recorded commands; the build type alone does not describe the assertion settings.

The host has an AMD Ryzen Threadripper PRO 7995WX with 96 cores and 192 logical
CPUs. Builds use all available CPUs. Workload replay uses a fixed set of eight
logical CPUs, recorded with each invocation. Both variants must use the same set.

## Workload coverage

| Workload | Required evidence |
| --- | --- |
| gfx950 f16, 256x256, four waves | Complete kernel output and AGPR relief |
| gfx950 MXFP4, 256x256, eight waves | Complete kernel output and rematerialization |
| TensileLite MXFP4, 256x256, eight waves | Unscheduled pipeline, LDS relief, scratch relief |
| TLX persistent causal attention | Complete attention output and SGPR-to-VGPR relief |
| Original v9 GEMM | Frozen-input compilation and allocation without relief |
| gfx950 BF16 attention, eight waves | Generated attention input and complete output |
| Shared-DAG rematerialization | Loop-local relief and final machine output |
| SGPR overage bundle | Multiple scalar promotions and readback |
| LDS M0 and VGPR-address cases | Resource preservation, waits, and final stores/reloads |
| Scratch relief case | Scratch operations, token flow, and private-segment metadata |
| gfx942, gfx950, and gfx1100 emitter cases | Target-specific instructions and object assembly |
| gfx803, gfx942, and gfx1100 multiply literals | Low/high multiply, literal on either side, physical registers |
| wavec SAXPY and WMMA matmul | Frontend Wave MLIR, ASM, and HSACO output |
| Four generated kernel helpers | Python startup, generation time, and complete source MLIR |

The integration cases use the production passes and reach final machine code.
They supplement the large kernels. Their small sizes do not establish large-kernel
compilation performance. Confirm nonzero relief counters in final ASM; nonzero
pass duration alone does not prove that a provider changed IR.

The gfx900 multiply witness aborts before emission. The default pipeline calls
`getArchData` from the MFMA packed peephole without a support check; the cost
model has no gfx900 entry. The failed input and trace are retained. A separate
bug tracks target-boundary validation and numeric ISA diagnostics. Gfx942 covers
the GFX9 emitter branch in this baseline. Gfx900 compilation is not claimed.

## Output checks

Compare raw generated MLIR, ASM, objects, and HSACO bytes where the workload
produces them. Repeated baseline runs must also match. Compare baseline ASM with
the checked-in goldens using only their existing line-ending and trailing-space
normalization. Do not add normalization or regenerate goldens to accept drift.

Kernel compilation uses frozen generated inputs. The four generator workloads
also regenerate their inputs and compare the full MLIR bytes. Before accepting
Python generator changes, run both workload classes. Frozen-input compiler
measurements cannot establish Python generator performance.

The frontend samples emit 1,972 and 4,611 bytes of Wave MLIR. A large-source
bridge experiment needs an additional real frontend input. Increasing matrix
dimensions in the WMMA example changes loop bounds, not frontend IR size.

TensileLite selects `--variants=baseline`. Its calibration pipeline omits machine
scheduling. The generic timing helper currently uses the default pipeline and
does not reproduce this selection. The artifact captures the pipeline through
`pipeline_text(schedule_options={}, report_options={})`. Preserve this selection.
If pipeline source changes, regenerate the variant pipeline structurally and
compare it before replay. The timing-helper defect has a separate cleanup task.

## Timing protocol

1. Rebuild tools before output checks. Finish all builds, tests, and artifact
   preparation before measurements. Do not run two measurement jobs together.
2. Warm each variant. Use at least five measured runs per workload and variant.
   Balance each variant across run positions. Randomize complete balanced blocks
   with a recorded seed. Reversing three variants leaves the middle variant in
   the same position. Preserve CPU affinity, environment, pipelines, compiler
   flags, and input bytes.
3. Keep subprocess wall time, individual step time, and MLIR stage time. Treat the
   sum of pipeline steps as the complete workload time. Do not describe a single
   stage improvement as an end-to-end improvement.
4. Include two baseline copies in balanced blocks for affected workloads. Inspect
   their paired differences before interpreting candidate differences. Retain all
   samples; do not remove slow samples without a recorded external cause and a
   complete rerun.
5. Report the paired effect and its uncertainty. A positive median alone does
   not establish a regression, even when a second batch has the same sign.
   Reject a repeatable positive shift that the controls and uncertainty support.
   If noise prevents a decision, keep the task open. Inspect stage measurements,
   instruction counts, generated CPU code, and linker layout to identify the
   mechanism before more runs. Noise is not evidence of equivalence. Identical
   instructions do not exclude a cost from a change in code layout.
6. For shared-header changes, replay the selected original C++ compile commands
   into isolated object files. Preserve the dependency closure and flags. Measure
   the affected incremental build at full parallelism before acceptance. The
   selected translation units do not replace that aggregate build check.

Example replay, after candidate tools are rebuilt:

```sh
python "$BASELINE_ROOT/verify.py"
python "$BASELINE_ROOT/run.py" \
  --variant "before=$BASELINE_ROOT/source" \
  --variant "after=$CANDIDATE_ROOT" --compare baseline --runs 5 --warmups 1
python "$BASELINE_ROOT/build_samples.py" \
  --variant "before=$BASELINE_ROOT/source" \
  --variant "after=$CANDIDATE_ROOT" --runs 5
```

Use fresh result labels for each batch. The replay fails on command failure,
missing output, repeated-output drift, or baseline-output drift.

## Regalloc contract conflict

Root instructions describe deferred relief plans. Nested
`lib/Dialect/Wave/Transforms/RegAlloc/AGENTS.md` describes immediate IR rewrites.
The current `waveamd_regalloc_transform_iteration` pipeline runs alias-state
construction, linear scan, AGPR, rematerialization, SGPR-to-VGPR, LDS, and scratch
in that order. Its driver rebuilds state after a rewrite.

The cleanup removes only machinery with no live consumer. Preserve this current
behavior. Do not use the documentation conflict to introduce deferred plans,
remove SGPR-to-VGPR relief, or change state lifetime. A policy change requires a
separate task and evidence.

## Validation gates

Run `check-wave-mlir`, `check-wavec`, Integration, and PerfGolden. Retain exact
commands, pass counts, unsupported test names, and required host features. Run
the applicable formatting checks and commit hooks. Check the final diff and
working tree. Hardware tests that cannot run are not GPU correctness evidence.

## Recorded baseline results

All 23 workloads completed one warmup and five measured runs. Repeated output
bytes matched. All six large-kernel ASM outputs matched their checked-in goldens.
The four generator workloads matched the frozen MLIR inputs.

| Large kernel | Median workload time, seconds | Relief dwords in final ASM |
| --- | ---: | --- |
| f16, four waves | 1.070 | AGPR 288 |
| MXFP4, eight waves | 0.980 | Rematerialization 5 |
| TensileLite MXFP4, eight waves | 0.938 | Rematerialization 17; LDS 12; scratch 154 |
| TLX persistent causal attention | 38.012 | AGPR 823; rematerialization 9; SGPR-to-VGPR 72 |
| Original v9 | 10.982 | No relief |
| gfx950 BF16 attention, eight waves | 1.869 | No relief |

These times include compiler, assembler, and linker subprocesses. They exclude
input generation, which has separate samples. They are baseline observations,
not a before/after performance claim.

The five-pair same-binary control had a median paired difference of -0.32% for
MXFP4 and +0.55% for wavec SAXPY. Individual pairs ranged from -10.84% to +0.88%
and from -0.03% to +3.52%, respectively. Retain these slow samples. Five samples
alone do not establish a small performance change; repeat the affected control
and candidate batches when the difference is comparable to this variation.

Isolated C++ compilation used one warmup and five measured runs per source.
Median times were 7.244 seconds for LDS relief, 5.490 seconds for scratch
planning, and 15.003 seconds for stride extraction. Raw commands preserve all
Release flags and include paths. These are translation-unit measurements;
aggregate incremental-build timing remains required for a header change.

Validation passed: full lit 571, wavec 6, Integration 168, and PerfGolden 21.
Full lit and Integration each report 32 unsupported tests. The Integration log
lists each test. Those tests require unavailable target features or runtime
support, principally gfx950/MFMA and gfx1250. Two four-wave profile codegen tests
also require a gfx950 host. Compiler output checks do not replace these hardware
checks.
