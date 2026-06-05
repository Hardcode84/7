/*===- lex.h - Lexer stage interface --------------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Stage 1: a byte buffer -> an array of
 * Tokens. Signatures only; the implementation is src/lex.c and links
 * only libc (no MLIR). No global state -- the source, arena and diag
 * sink are passed explicitly.
 *
 * The lexer implements the Lexical section of CFrontendGrammar.md:
 * maximal-munch operators (`..`, `<<`, compound assigns, `[[`/`]]`),
 * the float-only-with-a-digit-after-the-dot rule that frees `..`, line
 * comments and non-nested block comments, and keyword recognition. It
 * never decides `<` as type-args vs less-than (that is the parser's
 * rule 2); it just emits TOK_LT.
 */

#ifndef WAVEC_LEX_H
#define WAVEC_LEX_H

#include "arena.h"
#include "diag.h"
#include "token.h"

#include <stddef.h>
#include <stdint.h>

/*
 * Input to the lexer. `src`/`src_len` is the source byte buffer (not
 * required to be NUL-terminated; the lexer is bounded by src_len).
 * `arena` backs the produced token array. `diags` collects lex errors
 * (e.g. an unterminated block comment, a stray byte); a TOK_ERROR token
 * is also emitted at the offending span so the parser can resync.
 */
typedef struct LexContext {
  const char *src;
  size_t src_len;
  Arena *arena;
  DiagList *diags;
} LexContext;

/*
 * The lexer result: an arena array of Tokens, always terminated by
 * exactly one TOK_EOF. `tokens`/`count` describe the array (count
 * includes the trailing TOK_EOF). On allocation failure `tokens` is
 * NULL and `count` is 0, and an error is recorded in the diag sink.
 */
typedef struct TokenArray {
  Token *tokens;
  size_t count;
} TokenArray;

/*
 * Tokenize `ctx->src`. Returns the token array (see TokenArray). Lexing
 * does not stop at the first error: a TOK_ERROR is emitted, a
 * diagnostic recorded, and scanning continues so the user sees multiple
 * errors per run. The return is non-failing in the sense that a
 * TokenArray (possibly containing TOK_ERROR tokens) is always returned;
 * inspect ctx->diags for errors.
 */
TokenArray lex_tokenize(LexContext *ctx);

#endif /* WAVEC_LEX_H */
