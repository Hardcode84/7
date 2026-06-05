/*===- parse.c - Recursive-descent parser ---------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. See parse.h for the contract. Stage 2:
 * a Token array -> an arena AST (per ast.h) plus syntax diagnostics.
 *
 * Links only libc (string.h for memcpy/strlen, stdio.h is NOT used --
 * diagnostics are formatted into a fixed stack buffer with a tiny
 * in-house formatter so no printf/OS dependency leaks in). No global
 * state: all state lives in the ParseContext threaded by the caller.
 *
 * The grammar is the v1 EBNF in CFrontendGrammar.md. The parser is
 * LL(1) with one token of lookahead after a leading identifier (rule 7).
 * The context-sensitive bits handled here:
 *   - rule 2: `<` opens a generic/type-arg list only after a fixed set of
 *     trigger names (the type constructors simd/mask/vector and the
 *     generic builtins lane_id/cast/lds_base/workgroup_id/workitem_id);
 *     everywhere else `<` is the compare operator.
 *   - rule 7: a statement-leading identifier is an assign_stmt if the next
 *     token is an assign_op, else a call_stmt (which must contain `(...)`).
 *   - rule 3: `..` is the range token, never a binop, so expr stops before
 *     it inside a `for` header.
 *   - rule 5: `after` terminates the current argument expr inside a
 *     call_tail and introduces the dependency token.
 *   - rule 6: dangling else/otherwise binds to the nearest unmatched
 *     if/where (falls out of recursive descent: the optional clause is
 *     consumed by the innermost call).
 *
 * Bounded recursion (Implementation rule): every recursive descent point
 * bumps ctx->depth on entry and restores it on exit via the RECURSE_ENTER
 * / RECURSE_LEAVE guard; exceeding ctx->max_depth emits a diagnostic and
 * fails the production rather than overflowing the C stack.
 *
 * Error model: a syntax error emits a diagnostic and the parser
 * resynchronizes (to the next `;`, `}` or top-level `kernel`) so multiple
 * errors surface per run. parse_program always returns a (possibly
 * partial) Program on a live arena; callers check diag_has_errors.
 */

#include "parse.h"

#include <string.h>

/*===----------------------------------------------------------------===*/
/* Small helpers: spans, lexeme text, diagnostics                        */
/*===----------------------------------------------------------------===*/

/* Build a SourceSpan from a Token (the fields line up by design). */
static SourceSpan span_of_token(const Token *t) {
  SourceSpan s;
  s.offset = t->offset;
  s.len = t->len;
  s.line = t->line;
  s.col = t->col;
  return s;
}

/* A zero/point span used when no token is available (e.g. past EOF). */
static SourceSpan span_empty(void) {
  SourceSpan s;
  s.offset = 0;
  s.len = 0;
  s.line = 0;
  s.col = 0;
  return s;
}

/* Span covering from the start of `a` to the end of `b` (inclusive of
 * b's bytes). Used to give compound nodes a span over their whole text. */
static SourceSpan span_join(SourceSpan a, SourceSpan b) {
  SourceSpan s;
  uint32_t b_end = b.offset + b.len;
  s.offset = a.offset;
  s.line = a.line;
  s.col = a.col;
  if (b_end >= a.offset)
    s.len = b_end - a.offset;
  else
    s.len = a.len;
  return s;
}

/* Current token (never out of bounds: the array ends in TOK_EOF and pos
 * is clamped so peek at/after EOF returns the EOF token).
 *
 * A degenerate token array (NULL or count == 0, which a failed lexer may
 * hand back) is handled by returning a shared synthetic EOF token, so the
 * parser never dereferences out of bounds and never crashes on bad input
 * (Implementation rule: syntax errors -> diagnostics, never crash). The
 * synthetic token is a read-only constant, not mutable global state. */
static const Token k_eof_token = {TOK_EOF, 0u, 0u, 0u, 0u};

static const Token *cur(ParseContext *ctx) {
  size_t i = ctx->pos;
  if (ctx->tokens == NULL || ctx->count == 0u)
    return &k_eof_token;
  if (i >= ctx->count)
    i = ctx->count - 1u; /* the trailing TOK_EOF */
  return &ctx->tokens[i];
}

/* Lookahead by `n` tokens, clamped to the trailing TOK_EOF. */
static const Token *peek(ParseContext *ctx, size_t n) {
  size_t i = ctx->pos + n;
  if (ctx->tokens == NULL || ctx->count == 0u)
    return &k_eof_token;
  if (i >= ctx->count)
    i = ctx->count - 1u;
  return &ctx->tokens[i];
}

static TokenKind cur_kind(ParseContext *ctx) { return cur(ctx)->kind; }

static int at_eof(ParseContext *ctx) { return cur_kind(ctx) == TOK_EOF; }

/* Advance one token (never past the final TOK_EOF). */
static void advance(ParseContext *ctx) {
  if (ctx->pos + 1u < ctx->count)
    ctx->pos++;
}

/* The byte slice of a token's lexeme, bounds-checked against src_len.
 * Returns a pointer into ctx->src (never copied) and the length via *len.
 * If the span is out of range (malformed token), returns "" / 0. */
static const char *token_text(ParseContext *ctx, const Token *t,
                              uint32_t *len) {
  if (t->offset > ctx->src_len) {
    *len = 0;
    return "";
  }
  if ((size_t)t->offset + (size_t)t->len > ctx->src_len)
    *len = (uint32_t)(ctx->src_len - t->offset);
  else
    *len = t->len;
  return ctx->src + t->offset;
}

/* Compare a token's lexeme against a NUL-terminated literal. */
static int token_text_is(ParseContext *ctx, const Token *t, const char *lit) {
  uint32_t len;
  const char *s = token_text(ctx, t, &len);
  size_t n = strlen(lit);
  if ((size_t)len != n)
    return 0;
  return memcmp(s, lit, n) == 0;
}

/*
 * Minimal in-house formatter for diagnostic messages. We avoid stdio so
 * the front keeps its no-OS posture. Supports a tiny subset: literal
 * text, "%s" (a NUL-terminated string) and "%t" (a token's lexeme,
 * truncated to fit). Writes into `buf` (size `cap`) and always
 * NUL-terminates. Returns buf for convenience.
 */
static const char *diag_fmt2(ParseContext *ctx, char *buf, size_t cap,
                             const char *fmt, const char *s_arg,
                             const Token *t_arg) {
  size_t w = 0;
  size_t i = 0;
  if (cap == 0)
    return buf;
  while (fmt[i] != '\0' && w + 1u < cap) {
    if (fmt[i] == '%' && fmt[i + 1] == 's' && s_arg != NULL) {
      size_t j = 0;
      while (s_arg[j] != '\0' && w + 1u < cap)
        buf[w++] = s_arg[j++];
      i += 2;
    } else if (fmt[i] == '%' && fmt[i + 1] == 't' && t_arg != NULL) {
      uint32_t tl;
      const char *ts = token_text(ctx, t_arg, &tl);
      uint32_t k = 0;
      while (k < tl && w + 1u < cap)
        buf[w++] = ts[k++];
      i += 2;
    } else {
      buf[w++] = fmt[i++];
    }
  }
  buf[w] = '\0';
  return buf;
}

/* Emit an error diagnostic at the current token with a formatted message.
 * `fmt` is the tiny diag_fmt2 dialect: literal text plus an optional "%t"
 * that substitutes the current (offending) token's lexeme. */
static void error_here(ParseContext *ctx, const char *fmt) {
  char buf[256];
  const Token *t = cur(ctx);
  diag_fmt2(ctx, buf, sizeof(buf), fmt, NULL, t);
  diag_emit(ctx->diags, DIAG_ERROR, span_of_token(t), buf);
}

/*===----------------------------------------------------------------===*/
/* Recursion guard (bounded recursion, Implementation rule)              */
/*===----------------------------------------------------------------===*/

/*
 * Bounded-recursion guard (Implementation rule). A production that
 * descends recursively calls recurse_enter on entry; on SUCCESS (return
 * 1) it MUST pair that with exactly one recurse_leave on every exit path.
 *
 * On FAILURE (the cap is exceeded) recurse_enter undoes its own
 * increment and returns 0, and the caller bails WITHOUT calling
 * recurse_leave. This keeps `depth` perfectly balanced: the failing frame
 * leaves depth unchanged, every ancestor unwinds its own successful
 * enter, and the diagnostic is emitted exactly once at the boundary
 * (not repeatedly during unwind). After unwinding, depth is restored to
 * the enclosing block's level so error recovery (resync + continue) can
 * still make progress past the over-deep construct.
 */
static int recurse_enter(ParseContext *ctx) {
  if (ctx->depth + 1u > ctx->max_depth) {
    error_here(ctx, "maximum nesting depth exceeded");
    return 0;
  }
  ctx->depth++;
  return 1;
}

static void recurse_leave(ParseContext *ctx) {
  if (ctx->depth > 0)
    ctx->depth--;
}

/*===----------------------------------------------------------------===*/
/* Arena node constructors                                               */
/*===----------------------------------------------------------------===*/

static Expr *new_expr(ParseContext *ctx, ExprKind kind, SourceSpan span) {
  Expr *e = (Expr *)arena_alloc(ctx->arena, sizeof(Expr), sizeof(void *));
  if (e == NULL)
    return NULL;
  e->kind = kind;
  e->span = span;
  e->sema_type = NULL;
  return e;
}

static Stmt *new_stmt(ParseContext *ctx, StmtKind kind, SourceSpan span) {
  Stmt *s = (Stmt *)arena_alloc(ctx->arena, sizeof(Stmt), sizeof(void *));
  if (s == NULL)
    return NULL;
  s->kind = kind;
  s->span = span;
  return s;
}

static TypeRef *new_type(ParseContext *ctx, TypeKind kind, SourceSpan span) {
  TypeRef *t =
      (TypeRef *)arena_alloc(ctx->arena, sizeof(TypeRef), sizeof(void *));
  if (t == NULL)
    return NULL;
  t->kind = kind;
  t->scalar = SCALAR_BOOL;
  t->element = NULL;
  t->width = 0;
  t->is_shared = 0;
  t->is_pointer = 0;
  t->span = span;
  return t;
}

/* Fill a BoundName from an identifier token (slice + span). */
static BoundName bound_name_of(ParseContext *ctx, const Token *t) {
  BoundName b;
  uint32_t len;
  b.name = token_text(ctx, t, &len);
  b.name_len = len;
  b.span = span_of_token(t);
  return b;
}

/*
 * A growable arena vector of pointers. Because the arena cannot realloc
 * in place (stable-pointer contract), we collect into a small bounded
 * temporary on the C stack first, then copy the exact-sized array out of
 * the arena once the count is known. The cap is generous for any v1
 * construct; overflow emits a diagnostic and truncates (never a crash).
 */
#define PTRVEC_CAP 1024

typedef struct PtrVec {
  void *items[PTRVEC_CAP];
  size_t count;
  int overflow;
} PtrVec;

static void ptrvec_init(PtrVec *v) {
  v->count = 0;
  v->overflow = 0;
}

static void ptrvec_push(PtrVec *v, void *p) {
  if (v->count < PTRVEC_CAP)
    v->items[v->count++] = p;
  else
    v->overflow = 1;
}

/* Copy the collected pointers into an exact-sized arena array. Returns
 * the array (or NULL if count==0, with *out_count=0; or NULL on arena
 * exhaustion). */
static void **ptrvec_finish(ParseContext *ctx, PtrVec *v, size_t *out_count) {
  void **arr;
  size_t i;
  *out_count = v->count;
  if (v->count == 0)
    return NULL;
  arr = (void **)arena_alloc(ctx->arena, v->count * sizeof(void *),
                             sizeof(void *));
  if (arr == NULL) {
    *out_count = 0;
    return NULL;
  }
  for (i = 0; i < v->count; i++)
    arr[i] = v->items[i];
  return arr;
}

/*===----------------------------------------------------------------===*/
/* Token classification helpers                                          */
/*===----------------------------------------------------------------===*/

/* Is this token kind a scalar_type keyword (the closed scalar set)? */
static int is_scalar_type_kw(TokenKind k) {
  switch (k) {
  case TOK_KW_BOOL:
  case TOK_KW_HALF:
  case TOK_KW_FLOAT:
  case TOK_KW_INT8:
  case TOK_KW_INT16:
  case TOK_KW_INT32:
  case TOK_KW_INT64:
  case TOK_KW_UINT8:
  case TOK_KW_UINT16:
  case TOK_KW_UINT32:
  case TOK_KW_UINT64:
    return 1;
  default:
    return 0;
  }
}

/* Map a scalar_type / index / token keyword to its ScalarKind. The caller
 * has already verified the kind is one of these. */
static ScalarKind scalar_kind_of(TokenKind k) {
  switch (k) {
  case TOK_KW_BOOL:
    return SCALAR_BOOL;
  case TOK_KW_HALF:
    return SCALAR_HALF;
  case TOK_KW_FLOAT:
    return SCALAR_FLOAT;
  case TOK_KW_INDEX:
    return SCALAR_INDEX;
  case TOK_KW_TOKEN:
    return SCALAR_TOKEN;
  case TOK_KW_INT8:
    return SCALAR_INT8;
  case TOK_KW_INT16:
    return SCALAR_INT16;
  case TOK_KW_INT32:
    return SCALAR_INT32;
  case TOK_KW_INT64:
    return SCALAR_INT64;
  case TOK_KW_UINT8:
    return SCALAR_UINT8;
  case TOK_KW_UINT16:
    return SCALAR_UINT16;
  case TOK_KW_UINT32:
    return SCALAR_UINT32;
  case TOK_KW_UINT64:
    return SCALAR_UINT64;
  default:
    return SCALAR_BOOL; /* unreachable when guarded by the predicates. */
  }
}

/* Does a token kind begin a `type`? (the leading `shared` or a base_type
 * keyword). Used to decide decl_stmt vs other statements (rule 1). */
static int starts_type(TokenKind k) {
  if (k == TOK_KW_SHARED)
    return 1;
  if (is_scalar_type_kw(k))
    return 1;
  switch (k) {
  case TOK_KW_INDEX:
  case TOK_KW_TOKEN:
  case TOK_KW_SIMD:
  case TOK_KW_MASK:
  case TOK_KW_VECTOR:
  case TOK_KW_FRAGMENT:
    return 1;
  default:
    return 0;
  }
}

/* Is `k` an iv_type keyword (index or a sized int)? Used by the `for`
 * header (the parser records the TypeRef; sema enforces the restriction,
 * but the header grammar only admits these so we gate the keyword here). */
static int is_iv_type_kw(TokenKind k) {
  if (k == TOK_KW_INDEX)
    return 1;
  switch (k) {
  case TOK_KW_INT8:
  case TOK_KW_INT16:
  case TOK_KW_INT32:
  case TOK_KW_INT64:
  case TOK_KW_UINT8:
  case TOK_KW_UINT16:
  case TOK_KW_UINT32:
  case TOK_KW_UINT64:
    return 1;
  default:
    return 0;
  }
}

/* Is `k` an assign_op (the `=` family)? (rule 7 lookahead). */
static int is_assign_op(TokenKind k) {
  switch (k) {
  case TOK_ASSIGN:
  case TOK_PLUS_EQ:
  case TOK_MINUS_EQ:
  case TOK_STAR_EQ:
  case TOK_SLASH_EQ:
  case TOK_AMP_EQ:
  case TOK_PIPE_EQ:
  case TOK_CARET_EQ:
  case TOK_SHL_EQ:
  case TOK_SHR_EQ:
    return 1;
  default:
    return 0;
  }
}

/*
 * Binary-operator precedence (the table in CFrontendGrammar.md). Returns
 * the precedence level (>0; higher binds tighter) for a binop token, or
 * 0 if the token is not a binop. Note `<` is a binop here ONLY when the
 * caller has decided it is a compare (rule 2) -- the postfix layer
 * intercepts a generic `<` before expr ever sees it. All listed ops are
 * left-associative.
 *
 * The grammar table numbers 1..12 low-number==high-precedence; we invert
 * to a "binding power" (higher==tighter) so precedence climbing reads
 * naturally. Level 1 (postfix) and 2 (unary) are handled structurally,
 * not here, so the binops occupy bands 3..12 -> binding power 10..1.
 */
static int binop_prec(TokenKind k) {
  switch (k) {
  case TOK_STAR:
  case TOK_SLASH:
  case TOK_PERCENT:
    return 10; /* table band 3 */
  case TOK_PLUS:
  case TOK_MINUS:
    return 9; /* band 4 */
  case TOK_SHL:
  case TOK_SHR:
    return 8; /* band 5 */
  case TOK_LT:
  case TOK_LE:
  case TOK_GT:
  case TOK_GE:
    return 7; /* band 6 */
  case TOK_EQ:
  case TOK_NE:
    return 6; /* band 7 */
  case TOK_AMP:
    return 5; /* band 8 */
  case TOK_CARET:
    return 4; /* band 9 */
  case TOK_PIPE:
    return 3; /* band 10 */
  case TOK_AMPAMP:
    return 2; /* band 11 */
  case TOK_PIPEPIPE:
    return 1; /* band 12 */
  default:
    return 0; /* not a binop */
  }
}

/*
 * rule 2 trigger set: an identifier whose lexeme is a generic builtin
 * (takes `<...>`) so a following `<` opens a generic-arg list. The type
 * constructors simd/mask/vector are TOKEN keywords handled in the type
 * grammar; this set is only for the IDENT-spelled generic builtins.
 *
 * Per the grammar/design: lane_id, cast, lds_base (v1), plus
 * workgroup_id and workitem_id which take a const axis `<ax>`. read_first
 * / reduce are later; not predeclared in v1, so omitted (they would parse
 * as plain idents and `<` as compare, which is the correct conservative
 * default and yields a clean parse error in use, never a silent miscompile).
 */
static int ident_is_generic_builtin(ParseContext *ctx, const Token *t) {
  static const char *const names[] = {"lane_id", "cast", "lds_base",
                                      "workgroup_id", "workitem_id"};
  size_t i;
  size_t n = sizeof(names) / sizeof(names[0]);
  for (i = 0; i < n; i++) {
    if (token_text_is(ctx, t, names[i]))
      return 1;
  }
  return 0;
}

/*===----------------------------------------------------------------===*/
/* Resynchronization                                                     */
/*===----------------------------------------------------------------===*/

/* Skip tokens until a statement/recovery boundary. Consumes a trailing
 * `;`. Stops (without consuming) at `}`, `kernel`, or EOF so the enclosing
 * block/program loop can make progress. */
static void resync_stmt(ParseContext *ctx) {
  while (!at_eof(ctx)) {
    TokenKind k = cur_kind(ctx);
    if (k == TOK_SEMI) {
      advance(ctx);
      return;
    }
    if (k == TOK_RBRACE || k == TOK_KW_KERNEL)
      return;
    advance(ctx);
  }
}

/* Skip to the next top-level `kernel` or EOF (program-level recovery). */
static void resync_toplevel(ParseContext *ctx) {
  while (!at_eof(ctx) && cur_kind(ctx) != TOK_KW_KERNEL)
    advance(ctx);
}

/*===----------------------------------------------------------------===*/
/* Forward declarations of the recursive productions                     */
/*===----------------------------------------------------------------===*/

static TypeRef *parse_type(ParseContext *ctx);
static Expr *parse_expr(ParseContext *ctx);
static Expr *parse_binary(ParseContext *ctx, int min_prec);
static Expr *parse_unary(ParseContext *ctx);
static Expr *parse_postfix(ParseContext *ctx);
static Expr *parse_primary(ParseContext *ctx);
static Stmt *parse_stmt(ParseContext *ctx);
static Stmt *parse_block(ParseContext *ctx);

/*===----------------------------------------------------------------===*/
/* expect helpers                                                        */
/*===----------------------------------------------------------------===*/

/* If the current token is `k`, consume it and return 1; else emit `msg`
 * and return 0 without consuming. */
static int expect(ParseContext *ctx, TokenKind k, const char *msg) {
  if (cur_kind(ctx) == k) {
    advance(ctx);
    return 1;
  }
  error_here(ctx, msg);
  return 0;
}

/*
 * Close an angle-bracket (type/generic-arg) list. Accepts a single `>`
 * (TOK_GT) and consumes it.
 *
 * rule 8: a `>>` (TOK_SHR) closes two adjacent generic contexts, e.g.
 * cast<simd<float,4>>(x). It is split the C++11 way WITHOUT mutating the
 * shared token stream: the inner close consumes the `>>` token and records
 * one `>` owed (pending_gt); the enclosing close consumes the pending one.
 */
static int close_angle(ParseContext *ctx, const char *msg) {
  if (ctx->pending_gt) {
    ctx->pending_gt = 0;
    return 1;
  }
  if (cur_kind(ctx) == TOK_GT) {
    advance(ctx);
    return 1;
  }
  if (cur_kind(ctx) == TOK_SHR) {
    advance(ctx);
    ctx->pending_gt = 1;
    return 1;
  }
  error_here(ctx, msg);
  return 0;
}

/*===----------------------------------------------------------------===*/
/* Integer literal decoding                                              */
/*===----------------------------------------------------------------===*/

/* Decode a TOK_INT_LIT token's value. Sets *is_hex. Saturates on
 * overflow to UINT64_MAX (the literal is still recorded; sema may range-
 * check). Assumes the lexer validated the digit shape. */
static uint64_t decode_int_lit(ParseContext *ctx, const Token *t, int *is_hex) {
  uint32_t len;
  const char *s = token_text(ctx, t, &len);
  uint64_t v = 0;
  uint32_t i = 0;
  *is_hex = 0;
  if (len >= 2u && s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
    *is_hex = 1;
    i = 2;
    for (; i < len; i++) {
      char c = s[i];
      unsigned d;
      if (c >= '0' && c <= '9')
        d = (unsigned)(c - '0');
      else if (c >= 'a' && c <= 'f')
        d = (unsigned)(c - 'a' + 10);
      else if (c >= 'A' && c <= 'F')
        d = (unsigned)(c - 'A' + 10);
      else
        break; /* defensive: lexer should not include other chars. */
      v = v * 16u + d;
    }
  } else {
    for (; i < len; i++) {
      char c = s[i];
      if (c < '0' || c > '9')
        break;
      v = v * 10u + (uint64_t)(c - '0');
    }
  }
  return v;
}

/* Decode a TOK_FLOAT_LIT into a double and record the `f` suffix. A small
 * portable scanner (no strtod, to keep locale/OS dependence out). */
static double decode_float_lit(ParseContext *ctx, const Token *t,
                               int *has_f_suffix) {
  uint32_t len;
  const char *s = token_text(ctx, t, &len);
  double mant = 0.0;
  double frac_scale = 1.0;
  int seen_dot = 0;
  int exp_sign = 1;
  int exp_val = 0;
  int has_exp = 0;
  uint32_t i = 0;
  *has_f_suffix = 0;

  for (; i < len; i++) {
    char c = s[i];
    if (c >= '0' && c <= '9') {
      if (seen_dot) {
        frac_scale *= 0.1;
        mant += (double)(c - '0') * frac_scale;
      } else {
        mant = mant * 10.0 + (double)(c - '0');
      }
    } else if (c == '.') {
      seen_dot = 1;
    } else if (c == 'e' || c == 'E') {
      has_exp = 1;
      i++;
      if (i < len && (s[i] == '+' || s[i] == '-')) {
        if (s[i] == '-')
          exp_sign = -1;
        i++;
      }
      for (; i < len; i++) {
        char d = s[i];
        if (d < '0' || d > '9')
          break;
        /* Cap accumulation: any exponent past ~308 makes a double 0/inf
           anyway, and an unbounded run overflows int (UB) and the pow loop. */
        if (exp_val < 1000)
          exp_val = exp_val * 10 + (d - '0');
      }
      i--; /* the outer loop will i++ again. */
    } else if (c == 'f' || c == 'F') {
      *has_f_suffix = 1;
      break;
    } else {
      break;
    }
  }

  if (has_exp) {
    int e = exp_sign * exp_val;
    double p = 1.0;
    int k;
    int n = e < 0 ? -e : e;
    for (k = 0; k < n; k++)
      p *= 10.0;
    if (e < 0)
      mant /= p;
    else
      mant *= p;
  }
  return mant;
}

/*===----------------------------------------------------------------===*/
/* Types                                                                 */
/*===----------------------------------------------------------------===*/

/* Parse an int_lit and return its value; on a non-int token emits `msg`
 * and returns 0 with *ok = 0. */
static uint64_t parse_int_lit_value(ParseContext *ctx, const char *msg,
                                    int *ok) {
  const Token *t = cur(ctx);
  int is_hex;
  uint64_t v;
  if (t->kind != TOK_INT_LIT) {
    error_here(ctx, msg);
    *ok = 0;
    return 0;
  }
  v = decode_int_lit(ctx, t, &is_hex);
  advance(ctx);
  *ok = 1;
  return v;
}

/*
 * base_type = scalar_type | index | token
 *           | simd "<" type "," int_lit ">"
 *           | mask "<" int_lit ">"
 *           | vector "<" type "," int_lit ">" ;
 * Returns a TypeRef with kind/scalar/element/width set, or NULL on error.
 */
static TypeRef *parse_base_type(ParseContext *ctx) {
  const Token *t = cur(ctx);
  SourceSpan start = span_of_token(t);

  if (!recurse_enter(ctx))
    return NULL;

  if (is_scalar_type_kw(t->kind) || t->kind == TOK_KW_INDEX ||
      t->kind == TOK_KW_TOKEN) {
    TypeRef *ty = new_type(ctx, TYPE_SCALAR, start);
    if (ty == NULL) {
      recurse_leave(ctx);
      return NULL;
    }
    ty->scalar = scalar_kind_of(t->kind);
    advance(ctx);
    recurse_leave(ctx);
    return ty;
  }

  if (t->kind == TOK_KW_FRAGMENT) {
    /* Reserved with no v1 production: a clear, honest error. */
    error_here(ctx, "fragment type not supported");
    advance(ctx);
    recurse_leave(ctx);
    return NULL;
  }

  if (t->kind == TOK_KW_SIMD || t->kind == TOK_KW_VECTOR) {
    TypeKind tk = (t->kind == TOK_KW_SIMD) ? TYPE_SIMD : TYPE_VECTOR;
    TypeRef *ty;
    TypeRef *elem;
    int ok;
    uint64_t w;
    SourceSpan end;
    advance(ctx); /* consume simd/vector */
    if (!expect(ctx, TOK_LT, "expected '<' after type constructor")) {
      recurse_leave(ctx);
      return NULL;
    }
    elem = parse_type(ctx);
    if (elem == NULL) {
      recurse_leave(ctx);
      return NULL;
    }
    if (!expect(ctx, TOK_COMMA, "expected ',' in type constructor")) {
      recurse_leave(ctx);
      return NULL;
    }
    w = parse_int_lit_value(ctx, "expected integer width in type constructor",
                            &ok);
    if (!ok) {
      recurse_leave(ctx);
      return NULL;
    }
    end = span_of_token(cur(ctx));
    if (!close_angle(ctx, "expected '>' to close type constructor")) {
      recurse_leave(ctx);
      return NULL;
    }
    ty = new_type(ctx, tk, span_join(start, end));
    if (ty == NULL) {
      recurse_leave(ctx);
      return NULL;
    }
    ty->element = elem;
    ty->width = w;
    recurse_leave(ctx);
    return ty;
  }

  if (t->kind == TOK_KW_MASK) {
    TypeRef *ty;
    int ok;
    uint64_t w;
    SourceSpan end;
    advance(ctx); /* consume mask */
    if (!expect(ctx, TOK_LT, "expected '<' after 'mask'")) {
      recurse_leave(ctx);
      return NULL;
    }
    w = parse_int_lit_value(ctx, "expected integer width in 'mask<...>'", &ok);
    if (!ok) {
      recurse_leave(ctx);
      return NULL;
    }
    end = span_of_token(cur(ctx));
    if (!close_angle(ctx, "expected '>' to close 'mask<...>'")) {
      recurse_leave(ctx);
      return NULL;
    }
    ty = new_type(ctx, TYPE_MASK, span_join(start, end));
    if (ty == NULL) {
      recurse_leave(ctx);
      return NULL;
    }
    ty->width = w;
    recurse_leave(ctx);
    return ty;
  }

  error_here(ctx, "expected a type, found '%t'");
  recurse_leave(ctx);
  return NULL;
}

/* type = [ "shared" ] base_type [ "*" ] ; */
static TypeRef *parse_type(ParseContext *ctx) {
  int is_shared = 0;
  SourceSpan shared_span = span_empty();
  TypeRef *ty;

  if (cur_kind(ctx) == TOK_KW_SHARED) {
    is_shared = 1;
    shared_span = span_of_token(cur(ctx));
    advance(ctx);
  }

  ty = parse_base_type(ctx);
  if (ty == NULL)
    return NULL;

  if (is_shared) {
    ty->is_shared = 1;
    ty->span = span_join(shared_span, ty->span);
  }

  if (cur_kind(ctx) == TOK_STAR) {
    ty->is_pointer = 1;
    ty->span = span_join(ty->span, span_of_token(cur(ctx)));
    advance(ctx);
  }
  return ty;
}

/*===----------------------------------------------------------------===*/
/* Expressions                                                           */
/*===----------------------------------------------------------------===*/

/* garg = type | int_lit ; Returns 1 on success, filling *out. */
static int parse_garg(ParseContext *ctx, GArg *out) {
  const Token *t = cur(ctx);
  out->span = span_of_token(t);
  if (t->kind == TOK_INT_LIT) {
    int is_hex;
    out->kind = GARG_INT;
    out->int_value = decode_int_lit(ctx, t, &is_hex);
    out->type = NULL;
    advance(ctx);
    return 1;
  }
  /* Otherwise it must be a type. */
  out->kind = GARG_TYPE;
  out->int_value = 0;
  out->type = parse_type(ctx);
  if (out->type == NULL)
    return 0;
  out->span = out->type->span;
  return 1;
}

/*
 * call_tail = [ "<" garg {"," garg} ">" ] "(" [args] ["after" expr] ")" ;
 * Parses a single call tail onto `callee` and returns the resulting
 * EXPR_CALL node, or NULL on error. The leading `<` is only consumed when
 * `has_generic` is set (the caller decides via rule 2). The `(` is
 * mandatory for a call_tail.
 */
static Expr *parse_call_tail(ParseContext *ctx, Expr *callee, int has_generic) {
  PtrVec gargs;
  PtrVec args;
  GArg *garg_arr = NULL;
  size_t garg_count = 0;
  Expr **arg_arr = NULL;
  size_t arg_count = 0;
  Expr *dep = NULL;
  int has_dep = 0;
  Expr *call;
  SourceSpan end;
  size_t i;

  ptrvec_init(&gargs);
  ptrvec_init(&args);

  if (has_generic) {
    /* consume '<' garg {',' garg} '>' */
    advance(ctx); /* '<' */
    for (;;) {
      GArg *g = (GArg *)arena_alloc(ctx->arena, sizeof(GArg), sizeof(void *));
      if (g == NULL)
        return NULL;
      if (!parse_garg(ctx, g))
        return NULL;
      ptrvec_push(&gargs, g);
      if (cur_kind(ctx) == TOK_COMMA) {
        advance(ctx);
        continue;
      }
      break;
    }
    if (!close_angle(ctx, "expected '>' to close generic arguments"))
      return NULL;
  }

  if (!expect(ctx, TOK_LPAREN, "expected '(' to begin call arguments"))
    return NULL;

  /* args = expr {"," expr} ; with the optional trailing `after expr`.
   * An empty arg list is allowed (e.g. lane_id<32>(), token()-like). */
  if (cur_kind(ctx) != TOK_RPAREN && cur_kind(ctx) != TOK_KW_AFTER) {
    for (;;) {
      Expr *a = parse_expr(ctx);
      if (a == NULL)
        return NULL;
      ptrvec_push(&args, a);
      if (cur_kind(ctx) == TOK_COMMA) {
        advance(ctx);
        continue;
      }
      break;
    }
  }

  /* rule 5: a trailing `after expr` is the dependency token, not an arg. */
  if (cur_kind(ctx) == TOK_KW_AFTER) {
    advance(ctx);
    dep = parse_expr(ctx);
    if (dep == NULL)
      return NULL;
    has_dep = 1;
  }

  end = span_of_token(cur(ctx));
  if (!expect(ctx, TOK_RPAREN, "expected ')' to close call arguments"))
    return NULL;

  garg_arr = (GArg *)NULL;
  if (gargs.count > 0) {
    garg_arr = (GArg *)arena_alloc(ctx->arena, gargs.count * sizeof(GArg),
                                   sizeof(void *));
    if (garg_arr == NULL)
      return NULL;
    for (i = 0; i < gargs.count; i++)
      garg_arr[i] = *(GArg *)gargs.items[i];
    garg_count = gargs.count;
  }
  if (gargs.overflow)
    error_here(ctx, "too many generic arguments");

  arg_arr = (Expr **)ptrvec_finish(ctx, &args, &arg_count);
  if (args.count > 0 && arg_arr == NULL)
    return NULL;
  if (args.overflow)
    error_here(ctx, "too many call arguments");

  call = new_expr(ctx, EXPR_CALL, span_join(callee->span, end));
  if (call == NULL)
    return NULL;
  call->as.call.callee = callee;
  call->as.call.gargs = garg_arr;
  call->as.call.garg_count = garg_count;
  call->as.call.args = arg_arr;
  call->as.call.arg_count = arg_count;
  call->as.call.dep = dep;
  call->as.call.has_dep = has_dep;
  return call;
}

/*
 * primary = int_lit | float_lit | ident
 *         | "token" "(" ")"          (the empty-token seed)
 *         | "(" expr ")" ;
 */
static Expr *parse_primary(ParseContext *ctx) {
  const Token *t = cur(ctx);
  SourceSpan sp = span_of_token(t);
  Expr *e;

  switch (t->kind) {
  case TOK_INT_LIT: {
    int is_hex;
    uint64_t v = decode_int_lit(ctx, t, &is_hex);
    advance(ctx);
    e = new_expr(ctx, EXPR_INT_LIT, sp);
    if (e == NULL)
      return NULL;
    e->as.int_lit.value = v;
    e->as.int_lit.is_hex = is_hex;
    return e;
  }
  case TOK_FLOAT_LIT: {
    int has_f;
    double v = decode_float_lit(ctx, t, &has_f);
    advance(ctx);
    e = new_expr(ctx, EXPR_FLOAT_LIT, sp);
    if (e == NULL)
      return NULL;
    e->as.float_lit.value = v;
    e->as.float_lit.has_f_suffix = has_f;
    return e;
  }
  case TOK_IDENT: {
    uint32_t len;
    const char *name = token_text(ctx, t, &len);
    advance(ctx);
    e = new_expr(ctx, EXPR_IDENT, sp);
    if (e == NULL)
      return NULL;
    e->as.ident.name = name;
    e->as.ident.name_len = len;
    return e;
  }
  case TOK_KW_TOKEN: {
    /* token() seed: the reserved type used as a nullary constructor. The
     * grammar requires exactly "(" ")" here. */
    SourceSpan end;
    advance(ctx); /* 'token' */
    if (!expect(ctx, TOK_LPAREN, "expected '(' after 'token'"))
      return NULL;
    end = span_of_token(cur(ctx));
    if (!expect(ctx, TOK_RPAREN, "expected ')' for the empty 'token()' seed"))
      return NULL;
    e = new_expr(ctx, EXPR_TOKEN_SEED, span_join(sp, end));
    return e;
  }
  case TOK_LPAREN: {
    Expr *inner;
    SourceSpan end;
    advance(ctx); /* '(' */
    inner = parse_expr(ctx);
    if (inner == NULL)
      return NULL;
    end = span_of_token(cur(ctx));
    if (!expect(ctx, TOK_RPAREN,
                "expected ')' to close parenthesized "
                "expression"))
      return NULL;
    e = new_expr(ctx, EXPR_PAREN, span_join(sp, end));
    if (e == NULL)
      return NULL;
    e->as.paren = inner;
    return e;
  }
  default:
    error_here(ctx, "expected an expression, found '%t'");
    return NULL;
  }
}

/*
 * postfix = primary { call_tail } ;
 * A call_tail begins with an optional generic `<...>` (only after a
 * generic-builtin name, rule 2) and a mandatory `(...)`. We loop so
 * chained calls `f()()` are accepted structurally (sema rejects what is
 * not callable). The generic `<` is recognized only when the immediately
 * preceding primary was an EXPR_IDENT naming a generic builtin.
 */
static Expr *parse_postfix(ParseContext *ctx) {
  Expr *e;
  int prev_is_generic_name;

  if (!recurse_enter(ctx))
    return NULL;

  /* Determine, before consuming, whether the primary is a generic-builtin
   * identifier (so a following `<` opens generic args, rule 2). */
  prev_is_generic_name =
      (cur_kind(ctx) == TOK_IDENT) && ident_is_generic_builtin(ctx, cur(ctx));

  e = parse_primary(ctx);
  if (e == NULL) {
    recurse_leave(ctx);
    return NULL;
  }

  for (;;) {
    TokenKind k = cur_kind(ctx);
    int has_generic = 0;
    if (k == TOK_LT && prev_is_generic_name) {
      has_generic = 1;
    } else if (k != TOK_LPAREN) {
      break; /* no further call tail */
    }
    e = parse_call_tail(ctx, e, has_generic);
    if (e == NULL) {
      recurse_leave(ctx);
      return NULL;
    }
    /* A produced call is no longer a bare generic-builtin name; further
     * tails would need their own `(` and never a generic `<`. */
    prev_is_generic_name = 0;
  }

  recurse_leave(ctx);
  return e;
}

/*
 * unary = [ "-" | "!" | "~" ] postfix ; -- exactly ONE optional prefix,
 * then a postfix. The grammar deliberately forbids stacked prefixes
 * (`- -x`), so the operand is a postfix, not another unary. A stacked
 * prefix therefore parse-errors at the inner postfix (correct per spec).
 */
static Expr *parse_unary(ParseContext *ctx) {
  TokenKind k = cur_kind(ctx);
  if (k == TOK_MINUS || k == TOK_BANG || k == TOK_TILDE) {
    SourceSpan sp = span_of_token(cur(ctx));
    Expr *operand;
    Expr *e;
    advance(ctx);
    operand = parse_postfix(ctx);
    if (operand == NULL)
      return NULL;
    /* Fold `-<numeric literal>` into a negated literal so it stays a
       polymorphic literal (assignable to int8_t/half/...) and never reaches
       the unimplemented unary-operator lowering. */
    if (k == TOK_MINUS && operand->kind == EXPR_INT_LIT) {
      operand->as.int_lit.value =
          (uint64_t)(-(int64_t)operand->as.int_lit.value);
      operand->span = span_join(sp, operand->span);
      return operand;
    }
    if (k == TOK_MINUS && operand->kind == EXPR_FLOAT_LIT) {
      operand->as.float_lit.value = -operand->as.float_lit.value;
      operand->span = span_join(sp, operand->span);
      return operand;
    }
    e = new_expr(ctx, EXPR_UNARY, span_join(sp, operand->span));
    if (e == NULL)
      return NULL;
    e->as.unary.op = k;
    e->as.unary.operand = operand;
    return e;
  }
  return parse_postfix(ctx);
}

/*
 * Precedence climbing for binary operators. `min_prec` is the lowest
 * binding power this call will accept; it parses a left operand (a
 * unary), then folds while the next binop binds at least as tight as
 * min_prec. All binops are left-associative, so the recursive call uses
 * (prec + 1) as the new minimum.
 *
 * rule 2: a `<` here is always the compare operator -- a generic `<`
 * cannot reach this layer because parse_postfix consumes the whole
 * call_tail (including its `<...>`) before returning. So binop_prec(TOK_LT)
 * is correct as compare.
 */
static Expr *parse_binary(ParseContext *ctx, int min_prec) {
  Expr *lhs;

  if (!recurse_enter(ctx))
    return NULL;

  lhs = parse_unary(ctx);
  if (lhs == NULL) {
    recurse_leave(ctx);
    return NULL;
  }

  for (;;) {
    TokenKind op = cur_kind(ctx);
    int prec = binop_prec(op);
    Expr *rhs;
    Expr *bin;
    if (prec == 0 || prec < min_prec)
      break;
    advance(ctx); /* consume the operator */
    rhs = parse_binary(ctx, prec + 1);
    if (rhs == NULL) {
      recurse_leave(ctx);
      return NULL;
    }
    bin = new_expr(ctx, EXPR_BINARY, span_join(lhs->span, rhs->span));
    if (bin == NULL) {
      recurse_leave(ctx);
      return NULL;
    }
    bin->as.binary.op = op;
    bin->as.binary.lhs = lhs;
    bin->as.binary.rhs = rhs;
    lhs = bin;
  }

  recurse_leave(ctx);
  return lhs;
}

/* expr = unary { binop unary } ; (resolved by precedence climbing). */
static Expr *parse_expr(ParseContext *ctx) { return parse_binary(ctx, 1); }

/*===----------------------------------------------------------------===*/
/* Statements                                                            */
/*===----------------------------------------------------------------===*/

/* decl_stmt (typed form): type ident "=" expr ";" . The leading `type`
 * has already been confirmed by the caller (starts_type). */
static Stmt *parse_decl_stmt(ParseContext *ctx) {
  TypeRef *ty;
  const Token *name_tok;
  BoundName name;
  Expr *init;
  Stmt *s;
  SourceSpan start = span_of_token(cur(ctx));

  ty = parse_type(ctx);
  if (ty == NULL)
    return NULL;

  name_tok = cur(ctx);
  if (name_tok->kind != TOK_IDENT) {
    error_here(ctx, "expected an identifier in declaration, found '%t'");
    return NULL;
  }
  name = bound_name_of(ctx, name_tok);
  advance(ctx);

  if (!expect(ctx, TOK_ASSIGN, "expected '=' in declaration"))
    return NULL;

  init = parse_expr(ctx);
  if (init == NULL)
    return NULL;

  if (!expect(ctx, TOK_SEMI, "expected ';' after declaration"))
    return NULL;

  s = new_stmt(ctx, STMT_DECL, span_join(start, init->span));
  if (s == NULL)
    return NULL;
  s->as.decl.type = ty;
  s->as.decl.name = name;
  s->as.decl.init = init;
  return s;
}

/* destructure: "auto" "[" ident {"," ident} "]" "=" expr ";" . The `auto`
 * has been confirmed by the caller. */
static Stmt *parse_destructure_stmt(ParseContext *ctx) {
  PtrVec names;
  BoundName *name_arr;
  size_t name_count = 0;
  Expr *init;
  Stmt *s;
  size_t i;
  SourceSpan start = span_of_token(cur(ctx));

  advance(ctx); /* 'auto' */
  if (!expect(ctx, TOK_LBRACKET, "expected '[' after 'auto'"))
    return NULL;

  ptrvec_init(&names);
  for (;;) {
    const Token *t = cur(ctx);
    BoundName *b;
    if (t->kind != TOK_IDENT) {
      error_here(ctx, "expected an identifier in destructuring, found "
                      "'%t'");
      return NULL;
    }
    b = (BoundName *)arena_alloc(ctx->arena, sizeof(BoundName), sizeof(void *));
    if (b == NULL)
      return NULL;
    *b = bound_name_of(ctx, t);
    advance(ctx);
    ptrvec_push(&names, b);
    if (cur_kind(ctx) == TOK_COMMA) {
      advance(ctx);
      continue;
    }
    break;
  }

  if (!expect(ctx, TOK_RBRACKET, "expected ']' to close destructuring list"))
    return NULL;
  if (!expect(ctx, TOK_ASSIGN, "expected '=' in destructuring declaration"))
    return NULL;

  init = parse_expr(ctx);
  if (init == NULL)
    return NULL;
  if (!expect(ctx, TOK_SEMI, "expected ';' after destructuring declaration"))
    return NULL;

  if (names.overflow)
    error_here(ctx, "too many names in destructuring");

  /* Copy the BoundName values out into a contiguous arena array. */
  name_count = names.count;
  if (name_count == 0) {
    error_here(ctx, "destructuring must bind at least one name");
    return NULL;
  }
  name_arr = (BoundName *)arena_alloc(
      ctx->arena, name_count * sizeof(BoundName), sizeof(void *));
  if (name_arr == NULL)
    return NULL;
  for (i = 0; i < name_count; i++)
    name_arr[i] = *(BoundName *)names.items[i];

  s = new_stmt(ctx, STMT_DESTRUCTURE, span_join(start, init->span));
  if (s == NULL)
    return NULL;
  s->as.destructure.names = name_arr;
  s->as.destructure.name_count = name_count;
  s->as.destructure.init = init;
  return s;
}

/*
 * A statement that begins with an identifier (rule 7): either an
 * assign_stmt (next token is an assign_op) or a call_stmt (the eventual
 * `(...)`). We parse a full postfix expression starting at the ident; if
 * the *next* token after the leading ident is an assign_op, it is an
 * assignment of the bare name; otherwise the postfix must be a call.
 *
 * Rule 7 detail: the assign-vs-call decision keys on the token right
 * after the leading identifier. If that token is an assign_op -> assign.
 * Else it is a call (which may interpose a generic `<...>` per rule 2);
 * any other shape (e.g. `a < b;` on a non-generic name) is a parse error,
 * surfaced as "expected a call or assignment".
 */
static Stmt *parse_ident_led_stmt(ParseContext *ctx) {
  const Token *name_tok = cur(ctx);
  TokenKind next = peek(ctx, 1)->kind;
  SourceSpan start = span_of_token(name_tok);

  if (is_assign_op(next)) {
    BoundName target = bound_name_of(ctx, name_tok);
    TokenKind op = next;
    Expr *value;
    Stmt *s;
    advance(ctx); /* the identifier */
    advance(ctx); /* the assign_op */
    value = parse_expr(ctx);
    if (value == NULL)
      return NULL;
    if (!expect(ctx, TOK_SEMI, "expected ';' after assignment"))
      return NULL;
    s = new_stmt(ctx, STMT_ASSIGN, span_join(start, value->span));
    if (s == NULL)
      return NULL;
    s->as.assign.target = target;
    s->as.assign.op = op;
    s->as.assign.value = value;
    return s;
  }

  /* Otherwise: a call statement. Parse a postfix expression; it MUST be a
   * call (contain a `(...)`). A non-generic leading `<` is a compare,
   * which is not a statement -> error (rule 7). */
  {
    Expr *e = parse_postfix(ctx);
    Stmt *s;
    if (e == NULL)
      return NULL;
    if (e->kind != EXPR_CALL) {
      SourceSpan sp = e->span;
      diag_emit(ctx->diags, DIAG_ERROR, sp,
                "expected a call or assignment statement");
      return NULL;
    }
    if (!expect(ctx, TOK_SEMI, "expected ';' after call statement"))
      return NULL;
    s = new_stmt(ctx, STMT_CALL, span_join(start, e->span));
    if (s == NULL)
      return NULL;
    s->as.call.call = e;
    return s;
  }
}

/* if_stmt / where_stmt share the (cond) block [else/otherwise block]
 * shape; `is_where` selects the keyword set and the AST kind. The
 * dangling else/otherwise binds here, to the nearest unmatched
 * if/where (rule 6), because the optional clause is consumed eagerly. */
static Stmt *parse_cond_stmt(ParseContext *ctx, int is_where) {
  SourceSpan start = span_of_token(cur(ctx));
  Expr *cond;
  Stmt *then_block;
  Stmt *else_block = NULL;
  Stmt *s;
  TokenKind else_kw = is_where ? TOK_KW_OTHERWISE : TOK_KW_ELSE;
  SourceSpan end;

  advance(ctx); /* 'if' or 'where' */
  if (!expect(ctx, TOK_LPAREN,
              is_where ? "expected '(' after 'where'"
                       : "expected '(' after 'if'"))
    return NULL;
  cond = parse_expr(ctx);
  if (cond == NULL)
    return NULL;
  if (!expect(ctx, TOK_RPAREN, "expected ')' after condition"))
    return NULL;

  then_block = parse_block(ctx);
  if (then_block == NULL)
    return NULL;
  end = then_block->span;

  if (cur_kind(ctx) == else_kw) {
    advance(ctx);
    else_block = parse_block(ctx);
    if (else_block == NULL)
      return NULL;
    end = else_block->span;
  }

  s = new_stmt(ctx, is_where ? STMT_WHERE : STMT_IF, span_join(start, end));
  if (s == NULL)
    return NULL;
  s->as.cond.cond = cond;
  s->as.cond.then_block = then_block;
  s->as.cond.else_block = else_block;
  return s;
}

/*
 * for_stmt = "for" iv_type ident "in" expr ".." expr ["step" expr] block ;
 * rule 3: the range bounds are full exprs, but `..` is not a binop so
 * parse_expr stops before it; we then consume `..` explicitly. The IV
 * type is restricted to iv_type keywords by the grammar (sema re-checks).
 */
static Stmt *parse_for_stmt(ParseContext *ctx) {
  SourceSpan start = span_of_token(cur(ctx));
  TypeRef *iv_type;
  const Token *name_tok;
  BoundName iv_name;
  Expr *lb;
  Expr *ub;
  Expr *step = NULL;
  Stmt *body;
  Stmt *s;

  advance(ctx); /* 'for' */

  if (!is_iv_type_kw(cur_kind(ctx))) {
    error_here(ctx, "expected an induction-variable type "
                    "(index or a sized int), found '%t'");
    return NULL;
  }
  /* iv_type is a plain scalar base type (no shared/pointer/generic). */
  iv_type = new_type(ctx, TYPE_SCALAR, span_of_token(cur(ctx)));
  if (iv_type == NULL)
    return NULL;
  iv_type->scalar = scalar_kind_of(cur_kind(ctx));
  advance(ctx);

  name_tok = cur(ctx);
  if (name_tok->kind != TOK_IDENT) {
    error_here(ctx, "expected the induction variable name, found '%t'");
    return NULL;
  }
  iv_name = bound_name_of(ctx, name_tok);
  advance(ctx);

  if (!expect(ctx, TOK_KW_IN, "expected 'in' in for-loop header"))
    return NULL;

  lb = parse_expr(ctx);
  if (lb == NULL)
    return NULL;
  if (!expect(ctx, TOK_DOTDOT, "expected '..' between for-loop bounds"))
    return NULL;
  ub = parse_expr(ctx);
  if (ub == NULL)
    return NULL;

  if (cur_kind(ctx) == TOK_KW_STEP) {
    advance(ctx);
    step = parse_expr(ctx);
    if (step == NULL)
      return NULL;
  }

  body = parse_block(ctx);
  if (body == NULL)
    return NULL;

  s = new_stmt(ctx, STMT_FOR, span_join(start, body->span));
  if (s == NULL)
    return NULL;
  s->as.for_.iv_type = iv_type;
  s->as.for_.iv_name = iv_name;
  s->as.for_.lb = lb;
  s->as.for_.ub = ub;
  s->as.for_.step = step;
  s->as.for_.body = body;
  return s;
}

/* while_stmt = "while" "(" expr ")" block ; */
static Stmt *parse_while_stmt(ParseContext *ctx) {
  SourceSpan start = span_of_token(cur(ctx));
  Expr *cond;
  Stmt *body;
  Stmt *s;

  advance(ctx); /* 'while' */
  if (!expect(ctx, TOK_LPAREN, "expected '(' after 'while'"))
    return NULL;
  cond = parse_expr(ctx);
  if (cond == NULL)
    return NULL;
  if (!expect(ctx, TOK_RPAREN, "expected ')' after while condition"))
    return NULL;
  body = parse_block(ctx);
  if (body == NULL)
    return NULL;

  s = new_stmt(ctx, STMT_WHILE, span_join(start, body->span));
  if (s == NULL)
    return NULL;
  s->as.while_.cond = cond;
  s->as.while_.body = body;
  return s;
}

/*
 * stmt dispatch. Picks the production from the leading token(s):
 *   - a type keyword (incl. `shared`) -> decl_stmt (rule 1).
 *   - `auto` -> destructure.
 *   - `if`/`where`/`for`/`while` -> the matching control statement.
 *   - `{` -> a nested block.
 *   - an identifier -> assign_stmt or call_stmt (rule 7).
 * Returns NULL on error (the block loop resynchronizes).
 */
static Stmt *parse_stmt(ParseContext *ctx) {
  TokenKind k = cur_kind(ctx);

  if (!recurse_enter(ctx))
    return NULL;

  {
    Stmt *s = NULL;
    if (k == TOK_KW_AUTO) {
      s = parse_destructure_stmt(ctx);
    } else if (starts_type(k)) {
      s = parse_decl_stmt(ctx);
    } else if (k == TOK_KW_IF) {
      s = parse_cond_stmt(ctx, 0);
    } else if (k == TOK_KW_WHERE) {
      s = parse_cond_stmt(ctx, 1);
    } else if (k == TOK_KW_FOR) {
      s = parse_for_stmt(ctx);
    } else if (k == TOK_KW_WHILE) {
      s = parse_while_stmt(ctx);
    } else if (k == TOK_LBRACE) {
      s = parse_block(ctx);
    } else if (k == TOK_IDENT) {
      s = parse_ident_led_stmt(ctx);
    } else {
      error_here(ctx, "expected a statement, found '%t'");
      s = NULL;
    }
    recurse_leave(ctx);
    return s;
  }
}

/* block = "{" { stmt } "}" ; On a failed child statement, resync to the
 * next boundary and keep going so multiple errors surface. */
static Stmt *parse_block(ParseContext *ctx) {
  SourceSpan start = span_of_token(cur(ctx));
  PtrVec stmts;
  Stmt **stmt_arr;
  size_t stmt_count = 0;
  Stmt *s;
  SourceSpan end;

  if (!recurse_enter(ctx))
    return NULL;

  if (!expect(ctx, TOK_LBRACE, "expected '{' to begin a block")) {
    recurse_leave(ctx);
    return NULL;
  }

  ptrvec_init(&stmts);
  while (cur_kind(ctx) != TOK_RBRACE && !at_eof(ctx)) {
    Stmt *child = parse_stmt(ctx);
    if (child == NULL) {
      /* Recover: skip to the next statement boundary and continue. If no
       * progress is possible (e.g. stuck on `}`/EOF), break out. */
      size_t before = ctx->pos;
      resync_stmt(ctx);
      if (ctx->pos == before) {
        if (cur_kind(ctx) == TOK_RBRACE || at_eof(ctx))
          break;
        advance(ctx); /* force progress to avoid an infinite loop. */
      }
      continue;
    }
    ptrvec_push(&stmts, child);
  }

  if (stmts.overflow)
    error_here(ctx, "too many statements in a block");

  end = span_of_token(cur(ctx));
  if (!expect(ctx, TOK_RBRACE, "expected '}' to close a block")) {
    recurse_leave(ctx);
    return NULL;
  }

  stmt_arr = (Stmt **)ptrvec_finish(ctx, &stmts, &stmt_count);
  if (stmts.count > 0 && stmt_arr == NULL) {
    recurse_leave(ctx);
    return NULL;
  }

  s = new_stmt(ctx, STMT_BLOCK, span_join(start, end));
  if (s == NULL) {
    recurse_leave(ctx);
    return NULL;
  }
  s->as.block.stmts = stmt_arr;
  s->as.block.stmt_count = stmt_count;
  recurse_leave(ctx);
  return s;
}

/*===----------------------------------------------------------------===*/
/* Top level: attributes, params, kernels                                */
/*===----------------------------------------------------------------===*/

/* attribute = "[[" ident [ "(" int_lit ")" ] "]]" ; */
static Attribute *parse_attribute(ParseContext *ctx) {
  SourceSpan start = span_of_token(cur(ctx));
  Attribute *a;
  const Token *name_tok;
  uint32_t name_len;
  const char *name;
  int has_arg = 0;
  uint64_t arg = 0;
  SourceSpan end;

  if (!expect(ctx, TOK_LATTR, "expected '[[' to begin an attribute"))
    return NULL;

  name_tok = cur(ctx);
  if (name_tok->kind != TOK_IDENT) {
    error_here(ctx, "expected an attribute name, found '%t'");
    return NULL;
  }
  name = token_text(ctx, name_tok, &name_len);
  advance(ctx);

  if (cur_kind(ctx) == TOK_LPAREN) {
    int ok;
    advance(ctx);
    arg =
        parse_int_lit_value(ctx, "expected an integer attribute argument", &ok);
    if (!ok)
      return NULL;
    has_arg = 1;
    if (!expect(ctx, TOK_RPAREN, "expected ')' after attribute argument"))
      return NULL;
  }

  end = span_of_token(cur(ctx));
  if (!expect(ctx, TOK_RATTR, "expected ']]' to close an attribute"))
    return NULL;

  a = (Attribute *)arena_alloc(ctx->arena, sizeof(Attribute), sizeof(void *));
  if (a == NULL)
    return NULL;
  a->name = name;
  a->name_len = name_len;
  a->has_arg = has_arg;
  a->arg = arg;
  a->span = span_join(start, end);
  return a;
}

/* param = type ident ; */
static Param *parse_param(ParseContext *ctx) {
  SourceSpan start = span_of_token(cur(ctx));
  TypeRef *ty;
  const Token *name_tok;
  Param *p;

  ty = parse_type(ctx);
  if (ty == NULL)
    return NULL;
  name_tok = cur(ctx);
  if (name_tok->kind != TOK_IDENT) {
    error_here(ctx, "expected a parameter name, found '%t'");
    return NULL;
  }
  p = (Param *)arena_alloc(ctx->arena, sizeof(Param), sizeof(void *));
  if (p == NULL)
    return NULL;
  p->type = ty;
  p->name = bound_name_of(ctx, name_tok);
  p->span = span_join(start, p->name.span);
  advance(ctx);
  return p;
}

/*
 * kernel = "kernel" { attribute } "void" ident "(" [params] ")" block ;
 * On a header error we resync to the top level so the program loop can
 * continue past a broken kernel.
 */
static Kernel *parse_kernel(ParseContext *ctx) {
  SourceSpan start = span_of_token(cur(ctx));
  Kernel *kern;
  PtrVec attrs;
  PtrVec params;
  Attribute **attr_arr;
  size_t attr_count = 0;
  Param **param_arr;
  size_t param_count = 0;
  const Token *name_tok;

  if (!expect(ctx, TOK_KW_KERNEL, "expected 'kernel'"))
    return NULL;

  ptrvec_init(&attrs);
  while (cur_kind(ctx) == TOK_LATTR) {
    Attribute *a = parse_attribute(ctx);
    if (a == NULL)
      return NULL;
    ptrvec_push(&attrs, a);
  }
  if (attrs.overflow)
    error_here(ctx, "too many attributes on a kernel");

  if (!expect(ctx, TOK_KW_VOID, "expected 'void' (kernels return void in v1)"))
    return NULL;

  name_tok = cur(ctx);
  if (name_tok->kind != TOK_IDENT) {
    error_here(ctx, "expected a kernel name, found '%t'");
    return NULL;
  }

  kern = (Kernel *)arena_alloc(ctx->arena, sizeof(Kernel), sizeof(void *));
  if (kern == NULL)
    return NULL;
  kern->name = bound_name_of(ctx, name_tok);
  advance(ctx);

  if (!expect(ctx, TOK_LPAREN, "expected '(' after the kernel name"))
    return NULL;

  ptrvec_init(&params);
  if (cur_kind(ctx) != TOK_RPAREN) {
    for (;;) {
      Param *p = parse_param(ctx);
      if (p == NULL)
        return NULL;
      ptrvec_push(&params, p);
      if (cur_kind(ctx) == TOK_COMMA) {
        advance(ctx);
        continue;
      }
      break;
    }
  }
  if (params.overflow)
    error_here(ctx, "too many kernel parameters");

  if (!expect(ctx, TOK_RPAREN, "expected ')' to close the parameter list"))
    return NULL;

  /* Build exact arena arrays from the temporaries. */
  attr_arr = (Attribute **)ptrvec_finish(ctx, &attrs, &attr_count);
  if (attrs.count > 0 && attr_arr == NULL)
    return NULL;
  param_arr = (Param **)ptrvec_finish(ctx, &params, &param_count);
  if (params.count > 0 && param_arr == NULL)
    return NULL;

  kern->attrs = attr_arr;
  kern->attr_count = attr_count;
  kern->params = param_arr;
  kern->param_count = param_count;

  kern->body = parse_block(ctx);
  if (kern->body == NULL)
    return NULL;
  kern->span = span_join(start, kern->body->span);
  return kern;
}

/* program = { kernel } ; */
Program *parse_program(ParseContext *ctx) {
  Program *prog;
  PtrVec kernels;
  Kernel **kern_arr;
  size_t kern_count = 0;
  SourceSpan first = span_empty();
  SourceSpan last = span_empty();
  int have_span = 0;

  prog = (Program *)arena_alloc(ctx->arena, sizeof(Program), sizeof(void *));
  if (prog == NULL) {
    diag_emit(ctx->diags, DIAG_ERROR, span_empty(),
              "out of memory allocating the program node");
    return NULL;
  }

  ptrvec_init(&kernels);
  while (!at_eof(ctx)) {
    Kernel *k;
    size_t before = ctx->pos;
    if (cur_kind(ctx) != TOK_KW_KERNEL) {
      error_here(ctx, "expected a top-level 'kernel', found '%t'");
      resync_toplevel(ctx);
      if (ctx->pos == before && !at_eof(ctx))
        advance(ctx);
      continue;
    }
    k = parse_kernel(ctx);
    if (k == NULL) {
      resync_toplevel(ctx);
      if (ctx->pos == before && !at_eof(ctx))
        advance(ctx);
      continue;
    }
    if (!have_span) {
      first = k->span;
      have_span = 1;
    }
    last = k->span;
    ptrvec_push(&kernels, k);
  }

  if (kernels.overflow)
    error_here(ctx, "too many kernels in the translation unit");

  kern_arr = (Kernel **)ptrvec_finish(ctx, &kernels, &kern_count);
  if (kernels.count > 0 && kern_arr == NULL) {
    diag_emit(ctx->diags, DIAG_ERROR, span_empty(),
              "out of memory allocating the kernel list");
    return NULL;
  }
  prog->kernels = kern_arr;
  prog->kernel_count = kern_count;
  prog->span = have_span ? span_join(first, last) : span_empty();
  return prog;
}

/*===----------------------------------------------------------------===*/
/* Context init                                                          */
/*===----------------------------------------------------------------===*/

void parse_context_init(ParseContext *ctx, const Token *tokens, size_t count,
                        const char *src, size_t src_len, Arena *arena,
                        DiagList *diags) {
  ctx->tokens = tokens;
  ctx->count = count;
  ctx->src = src;
  ctx->src_len = src_len;
  ctx->arena = arena;
  ctx->diags = diags;
  ctx->pos = 0;
  ctx->depth = 0;
  ctx->max_depth = PARSE_DEFAULT_MAX_DEPTH;
  ctx->pending_gt = 0;
}
