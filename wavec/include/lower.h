/*===- lower.h - AST -> Wave IR lowering bridge ---------------*- C -*-===*/
/*
 * C ABI for checked AST -> textual Wave MLIR. The C++ lowering bridge owns
 * MLIR; lexer, parser, and sema see no C++ or MLIR types.
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
