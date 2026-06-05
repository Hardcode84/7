/*===- lower.h - AST -> Wave IR lowering bridge ---------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Stage 4: a CHECKED AST -> textual
 * Wave-dialect MLIR. This is the ONE stage allowed to be C++ and to
 * touch MLIR (the "lowering bridge"); the front (lexer/parser/sema)
 * contains no MLIR. The interface is therefore declared `extern "C"` so
 * the C driver and the C99 stages can call into the C++ implementation
 * (src/lower.cpp) without seeing any C++/MLIR type in this header.
 *
 * IMPLEMENTED LATER. This header pins the contract the parser/sema
 * agents lower into; src/lower.cpp builds IR via the MLIR C API
 * (`mlirOperationCreate` with op-name strings, as the Python DSL does --
 * Wave-c has no per-op builders) and renders it to text. Per the
 * Implementation rules, an unsupported construct makes lowering fail
 * with a clear error rather than emit a canned/hardcoded result.
 */

#ifndef WAVEC_LOWER_H
#define WAVEC_LOWER_H

#include "ast.h"
#include "diag.h"

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Lower a checked `program` to textual Wave MLIR.
 *
 * Returns a NUL-terminated C string containing the MLIR module text,
 * allocated on the HEAP by the bridge (this is the C++/MLIR side, which
 * is outside the front's arena-only / no-malloc rule). Ownership passes
 * to the caller, who MUST release it with wavec_lower_free. Returns
 * NULL on failure; in that case one or more diagnostics are recorded in
 * `diags` (e.g. "error: <feature> not supported", or an IR construction
 * error). `diags` may be NULL to discard diagnostics.
 *
 * The `program` MUST have passed sema (sema_check == 1); lowering trusts
 * the annotations (each Expr->sema_type) and does not re-typecheck.
 */
char *wavec_lower_to_mlir(const Program *program, DiagList *diags);

/*
 * Release a string returned by wavec_lower_to_mlir. Safe on NULL.
 * Provided so the heap allocation made on the C++ side is freed with
 * the matching deallocator regardless of the caller's allocator.
 */
void wavec_lower_free(char *mlir_text);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* WAVEC_LOWER_H */
