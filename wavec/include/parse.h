/*===- parse.h - Parser stage interface -----------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Stage 2: a Token array -> an arena
 * AST plus syntax diagnostics. Signatures only; src/parse.c links only
 * libc. No global state.
 *
 * The parser is recursive descent over the LL(1) grammar in
 * CFrontendGrammar.md (one token of lookahead after a leading
 * identifier). It carries an EXPLICIT recursion-depth counter and
 * errors past a fixed cap so pathological nesting cannot overflow the C
 * stack (Implementation rule: bounded recursion). It resolves the
 * context-sensitive bits (rule 2 `<` as generic-args vs less-than via
 * the fixed trigger-name set; rule 7 statement-leading-identifier; the
 * `..` range vs float; `after` terminating an argument expr).
 */

#ifndef WAVEC_PARSE_H
#define WAVEC_PARSE_H

#include "arena.h"
#include "ast.h"
#include "diag.h"
#include "token.h"

#include <stddef.h>
#include <stdint.h>

/* Default cap on recursive-descent nesting depth. Chosen well above any
 * realistic kernel's expression/statement nesting yet far below the C
 * stack limit; the parser emits "maximum nesting depth exceeded" and
 * resyncs when `depth` would exceed `max_depth`. Callers may override
 * via ParseContext.max_depth before parsing. */
#define PARSE_DEFAULT_MAX_DEPTH 256

/*
 * Parser context. `tokens`/`count` is the lexer output (must end in
 * TOK_EOF). `arena` backs the AST. `diags` collects syntax errors.
 * `src`/`src_len` is the original byte buffer, retained so the parser
 * can slice identifier/literal lexemes and so diagnostics can quote
 * source. `depth`/`max_depth` implement the bounded-recursion guard
 * (depth is managed by the parser; initialize to 0, max_depth to
 * PARSE_DEFAULT_MAX_DEPTH or a caller override). `pos` is the current
 * token index (parser-internal; initialize to 0). No globals: one
 * context per parse.
 */
typedef struct ParseContext {
  const Token *tokens;
  size_t count;
  const char *src;
  size_t src_len;
  Arena *arena;
  DiagList *diags;
  size_t pos;
  unsigned depth;
  unsigned max_depth;
  int pending_gt; /* one '>' owed from a split '>>' (rule 8) */
} ParseContext;

/* Initialize a ParseContext from a lexer result and the source buffer.
 * Sets pos = 0, depth = 0, max_depth = PARSE_DEFAULT_MAX_DEPTH. The
 * caller supplies the arena and diag sink. */
void parse_context_init(ParseContext *ctx, const Token *tokens, size_t count,
                        const char *src, size_t src_len, Arena *arena,
                        DiagList *diags);

/*
 * Parse a whole translation unit (`program`). Returns the arena Program
 * node, or NULL on a hard failure (e.g. arena exhaustion) with a
 * diagnostic recorded. Recoverable syntax errors are reported through
 * `ctx->diags` and the parser resynchronizes (typically to the next
 * statement boundary or top-level `kernel`) to find further errors;
 * such a parse still returns a (partial) Program, so callers must check
 * diag_has_errors(ctx->diags) -- a non-NULL Program does not imply a
 * clean parse.
 */
Program *parse_program(ParseContext *ctx);

#endif /* WAVEC_PARSE_H */
