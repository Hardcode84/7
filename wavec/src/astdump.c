/*===- astdump.c - Deterministic AST text dump ----------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. See astdump.h for the contract. An AST
 * -> a deterministic, S-expression-like indented tree, used as the
 * observable output the parser/sema tests assert on. Links only libc
 * (string.h); no I/O, no globals, no MLIR.
 *
 * The format is line-oriented: each node opens "(<tag> ...)" possibly
 * spanning child lines at a deeper indent. It is fully deterministic --
 * no pointer values, no hash ordering -- so golden comparisons are
 * stable. Identifier/string fields are printed verbatim between double
 * quotes (the v1 lexer admits only ASCII identifier bytes, none of which
 * need escaping, but a defensive backslash-escape of '"' and '\\' is
 * applied for robustness).
 *
 * When options->include_types is set, each Expr line is followed by a
 * "[type ...]" annotation derived from its sema_type (NULL prints
 * "[type ?]"); parser tests pass 0 and never trigger that path.
 *
 * All output accumulates in a Builder that bump-allocates fixed-size
 * chunks from the arena (the arena cannot realloc in place, so we chain
 * chunks and flatten once at the end). No per-character malloc.
 */

#include "astdump.h"

#include <stdint.h>
#include <string.h>

/*===----------------------------------------------------------------===*/
/* String builder over chained arena chunks                              */
/*===----------------------------------------------------------------===*/

#define ASTDUMP_CHUNK 4096u

typedef struct Chunk {
  struct Chunk *next;
  size_t len; /* bytes used in `data` */
  char data[ASTDUMP_CHUNK];
} Chunk;

typedef struct Builder {
  Arena *arena;
  Chunk *head;
  Chunk *tail;
  size_t total; /* total bytes across all chunks */
  int oom;      /* set once any allocation fails */
  int indent_width;
} Builder;

static void builder_init(Builder *b, Arena *arena, int indent_width) {
  b->arena = arena;
  b->head = NULL;
  b->tail = NULL;
  b->total = 0;
  b->oom = 0;
  b->indent_width = indent_width;
}

/* Append `n` bytes from `s`. On arena exhaustion sets b->oom and drops
 * further output (the final flatten returns NULL so callers see failure). */
static void builder_put(Builder *b, const char *s, size_t n) {
  size_t off = 0;
  if (b->oom)
    return;
  while (off < n) {
    size_t room;
    size_t take;
    if (b->tail == NULL || b->tail->len == ASTDUMP_CHUNK) {
      Chunk *c = (Chunk *)arena_alloc(b->arena, sizeof(Chunk), sizeof(void *));
      if (c == NULL) {
        b->oom = 1;
        return;
      }
      c->next = NULL;
      c->len = 0;
      if (b->tail == NULL)
        b->head = c;
      else
        b->tail->next = c;
      b->tail = c;
    }
    room = ASTDUMP_CHUNK - b->tail->len;
    take = (n - off < room) ? (n - off) : room;
    memcpy(b->tail->data + b->tail->len, s + off, take);
    b->tail->len += take;
    b->total += take;
    off += take;
  }
}

/* Append a NUL-terminated literal. */
static void builder_puts(Builder *b, const char *s) {
  builder_put(b, s, strlen(s));
}

/* Append one character. */
static void builder_putc(Builder *b, char c) { builder_put(b, &c, 1u); }

/* Append `level * indent_width` spaces. */
static void builder_indent(Builder *b, int level) {
  int i;
  int total = level * b->indent_width;
  for (i = 0; i < total; i++)
    builder_putc(b, ' ');
}

/* Append a decimal unsigned 64-bit integer. */
static void builder_put_u64(Builder *b, uint64_t v) {
  char tmp[20]; /* 2^64-1 has 20 digits */
  int n = 0;
  if (v == 0) {
    builder_putc(b, '0');
    return;
  }
  while (v > 0 && n < (int)sizeof(tmp)) {
    tmp[n++] = (char)('0' + (int)(v % 10u));
    v /= 10u;
  }
  while (n > 0)
    builder_putc(b, tmp[--n]);
}

/* Append a quoted source slice (pointer + length), escaping '"' and '\'.
 * The v1 lexer never produces those inside an identifier, but escaping
 * keeps the format unambiguous for any byte slice. */
static void builder_put_quoted(Builder *b, const char *s, uint32_t len) {
  uint32_t i;
  builder_putc(b, '"');
  for (i = 0; i < len; i++) {
    char c = s[i];
    if (c == '"' || c == '\\') {
      builder_putc(b, '\\');
      builder_putc(b, c);
    } else {
      builder_putc(b, c);
    }
  }
  builder_putc(b, '"');
}

/* Flatten all chunks into one NUL-terminated arena string. Returns NULL
 * if any allocation failed during building or here. */
static const char *builder_finish(Builder *b) {
  char *out;
  size_t off = 0;
  Chunk *c;
  if (b->oom)
    return NULL;
  out = (char *)arena_alloc(b->arena, b->total + 1u, 1u);
  if (out == NULL)
    return NULL;
  for (c = b->head; c != NULL; c = c->next) {
    memcpy(out + off, c->data, c->len);
    off += c->len;
  }
  out[off] = '\0';
  return out;
}

/*===----------------------------------------------------------------===*/
/* Spelling tables                                                       */
/*===----------------------------------------------------------------===*/

static const char *const kScalarNames[] = {
    [SCALAR_BOOL] = "bool",       [SCALAR_HALF] = "half",
    [SCALAR_FLOAT] = "float",     [SCALAR_INDEX] = "index",
    [SCALAR_TOKEN] = "token",     [SCALAR_INT8] = "int8_t",
    [SCALAR_INT16] = "int16_t",   [SCALAR_INT32] = "int32_t",
    [SCALAR_INT64] = "int64_t",   [SCALAR_UINT8] = "uint8_t",
    [SCALAR_UINT16] = "uint16_t", [SCALAR_UINT32] = "uint32_t",
    [SCALAR_UINT64] = "uint64_t",
};

static const char *scalar_name(ScalarKind k) {
  if ((unsigned)k < sizeof(kScalarNames) / sizeof(kScalarNames[0]) &&
      kScalarNames[k] != NULL)
    return kScalarNames[k];
  return "?";
}

static const char *const kOpNames[TOK__COUNT] = {
    [TOK_PLUS] = "+",      [TOK_MINUS] = "-",     [TOK_STAR] = "*",
    [TOK_SLASH] = "/",     [TOK_PERCENT] = "%",   [TOK_SHL] = "<<",
    [TOK_SHR] = ">>",      [TOK_LT] = "<",        [TOK_LE] = "<=",
    [TOK_GT] = ">",        [TOK_GE] = ">=",       [TOK_EQ] = "==",
    [TOK_NE] = "!=",       [TOK_AMP] = "&",       [TOK_PIPE] = "|",
    [TOK_CARET] = "^",     [TOK_TILDE] = "~",     [TOK_BANG] = "!",
    [TOK_AMPAMP] = "&&",   [TOK_PIPEPIPE] = "||", [TOK_ASSIGN] = "=",
    [TOK_PLUS_EQ] = "+=",  [TOK_MINUS_EQ] = "-=", [TOK_STAR_EQ] = "*=",
    [TOK_SLASH_EQ] = "/=", [TOK_AMP_EQ] = "&=",   [TOK_PIPE_EQ] = "|=",
    [TOK_CARET_EQ] = "^=", [TOK_SHL_EQ] = "<<=",  [TOK_SHR_EQ] = ">>=",
};

static const char *op_name(TokenKind k) {
  if ((unsigned)k < TOK__COUNT && kOpNames[k] != NULL)
    return kOpNames[k];
  return "?";
}

/*===----------------------------------------------------------------===*/
/* Type printing (single-line, nested in parentheses)                    */
/*===----------------------------------------------------------------===*/

/*
 * A type prints on one line as a parenthesized form so it can sit inline
 * inside a decl/param. Examples:
 *   (type float)
 *   (type (ptr float))
 *   (type (shared (ptr half)))
 *   (type (simd float 32))
 *   (type (ptr (simd float 32)))         (* if a star applied *)
 *   (type (mask 32))
 *   (type (vector float 4))
 * `is_shared`/`is_pointer` wrap the base form; this keeps the qualifier
 * order explicit and deterministic.
 */
static void dump_type_inner(Builder *b, const TypeRef *t);

static void dump_type_base(Builder *b, const TypeRef *t) {
  switch (t->kind) {
  case TYPE_SCALAR:
    builder_puts(b, scalar_name(t->scalar));
    break;
  case TYPE_SIMD:
    builder_puts(b, "(simd ");
    if (t->element != NULL)
      dump_type_inner(b, t->element);
    else
      builder_puts(b, "?");
    builder_putc(b, ' ');
    builder_put_u64(b, t->width);
    builder_putc(b, ')');
    break;
  case TYPE_MASK:
    builder_puts(b, "(mask ");
    builder_put_u64(b, t->width);
    builder_putc(b, ')');
    break;
  case TYPE_VECTOR:
    builder_puts(b, "(vector ");
    if (t->element != NULL)
      dump_type_inner(b, t->element);
    else
      builder_puts(b, "?");
    builder_putc(b, ' ');
    builder_put_u64(b, t->width);
    builder_putc(b, ')');
    break;
  case TYPE_FRAGMENT:
    builder_puts(b, "(fragment ");
    builder_put_u64(b, t->fragment_role);
    builder_putc(b, ' ');
    if (t->element != NULL)
      dump_type_inner(b, t->element);
    else
      builder_puts(b, "?");
    builder_putc(b, ' ');
    builder_put_u64(b, t->fragment_rows);
    builder_putc(b, ' ');
    builder_put_u64(b, t->fragment_cols);
    builder_putc(b, ' ');
    builder_put_u64(b, t->width);
    builder_putc(b, ' ');
    builder_put_u64(b, t->fragment_registers);
    builder_putc(b, ')');
    break;
  case TYPE_VOID:
    builder_puts(b, "void");
    break;
  }
}

/* The base plus its shared/pointer qualifiers. */
static void dump_type_inner(Builder *b, const TypeRef *t) {
  int close = 0;
  if (t->is_shared) {
    builder_puts(b, "(shared ");
    close++;
  }
  if (t->is_pointer) {
    builder_puts(b, "(ptr ");
    dump_type_base(b, t);
    builder_putc(b, ')');
  } else {
    dump_type_base(b, t);
  }
  while (close-- > 0)
    builder_putc(b, ')');
}

/* Top-level type form: "(type <inner>)". */
static void dump_type(Builder *b, const TypeRef *t) {
  builder_puts(b, "(type ");
  if (t == NULL)
    builder_puts(b, "?");
  else
    dump_type_inner(b, t);
  builder_putc(b, ')');
}

/*===----------------------------------------------------------------===*/
/* Expression printing                                                   */
/*===----------------------------------------------------------------===*/

/*
 * Expressions print multi-line for readability and stable diffs. The
 * convention: a node opens its own line "(<tag> ...)" at `level`, and any
 * child expressions appear on their own deeper lines. Leaf nodes
 * (literals, idents, token-seed) print inline and close on the same line.
 *
 * Forms:
 *   (int <value>)             / (int <value> hex)
 *   (float <value>)           (printed via a deterministic decimal form)
 *   (ident "<name>")
 *   (token-seed)
 *   (paren <expr>)
 *   (unary "<op>" <expr>)
 *   (binary "<op>" <lhs> <rhs>)
 *   (call <callee> (gargs ...) (args ...) [ (after <expr>) ])
 */
static void dump_expr(Builder *b, const Expr *e, int level,
                      const AstDumpOptions *opts);

/* Print a double deterministically: integer part, '.', up to 6 fractional
 * digits with trailing zeros trimmed (but at least one fractional digit).
 * This is locale-independent and stable; it is a debug rendering, not a
 * round-trippable float. Negative values are handled though the lexer
 * never produces them (unary minus is a separate node). */
static void builder_put_double(Builder *b, double v) {
  uint64_t ip;
  double frac;
  int i;
  char fbuf[6];
  int fn;
  if (v < 0) {
    builder_putc(b, '-');
    v = -v;
  }
  ip = (uint64_t)v;
  frac = v - (double)ip;
  builder_put_u64(b, ip);
  builder_putc(b, '.');
  /* Extract up to 6 fractional digits. */
  fn = 0;
  for (i = 0; i < 6; i++) {
    int d;
    frac *= 10.0;
    d = (int)frac;
    if (d < 0)
      d = 0;
    if (d > 9)
      d = 9;
    fbuf[fn++] = (char)('0' + d);
    frac -= (double)d;
  }
  /* Trim trailing zeros but keep at least one digit. */
  while (fn > 1 && fbuf[fn - 1] == '0')
    fn--;
  builder_put(b, fbuf, (size_t)fn);
}

/* Print the type annotation for an expr when include_types is set. The
 * sema_type slot is an opaque TypeRef* (or NULL pre-sema). */
static void dump_type_annotation(Builder *b, const Expr *e) {
  builder_puts(b, " [type ");
  if (e->sema_type == NULL)
    builder_puts(b, "?");
  else
    dump_type_inner(b, (const TypeRef *)e->sema_type);
  builder_putc(b, ']');
}

/* A generic argument: (gtype <type>) or (gint <value>). */
static void dump_garg(Builder *b, const GArg *g) {
  if (g->kind == GARG_TYPE) {
    builder_puts(b, "(gtype ");
    if (g->type != NULL)
      dump_type_inner(b, g->type);
    else
      builder_puts(b, "?");
    builder_putc(b, ')');
  } else {
    builder_puts(b, "(gint ");
    builder_put_u64(b, g->int_value);
    builder_putc(b, ')');
  }
}

static void dump_call(Builder *b, const Expr *e, int level,
                      const AstDumpOptions *opts) {
  const ExprCall *c = &e->as.call;
  size_t i;

  builder_puts(b, "(call");
  if (opts->include_types)
    dump_type_annotation(b, e);
  builder_putc(b, '\n');

  /* callee */
  dump_expr(b, c->callee, level + 1, opts);
  builder_putc(b, '\n');

  /* gargs */
  builder_indent(b, level + 1);
  if (c->garg_count == 0) {
    builder_puts(b, "(gargs)");
  } else {
    builder_puts(b, "(gargs");
    for (i = 0; i < c->garg_count; i++) {
      builder_putc(b, ' ');
      dump_garg(b, &c->gargs[i]);
    }
    builder_putc(b, ')');
  }
  builder_putc(b, '\n');

  /* args */
  builder_indent(b, level + 1);
  if (c->arg_count == 0) {
    builder_puts(b, "(args)");
  } else {
    builder_puts(b, "(args\n");
    for (i = 0; i < c->arg_count; i++) {
      dump_expr(b, c->args[i], level + 2, opts);
      builder_putc(b, '\n');
    }
    builder_indent(b, level + 1);
    builder_putc(b, ')');
  }

  /* optional after-dependency */
  if (c->has_dep) {
    builder_putc(b, '\n');
    builder_indent(b, level + 1);
    builder_puts(b, "(after\n");
    dump_expr(b, c->dep, level + 2, opts);
    builder_putc(b, '\n');
    builder_indent(b, level + 1);
    builder_putc(b, ')');
  }

  builder_putc(b, ')');
}

static void dump_int_expr(Builder *b, const Expr *e,
                          const AstDumpOptions *opts) {
  builder_puts(b, "(int ");
  builder_put_u64(b, e->as.int_lit.value);
  if (e->as.int_lit.is_hex)
    builder_puts(b, " hex");
  if (opts->include_types)
    dump_type_annotation(b, e);
  builder_putc(b, ')');
}

static void dump_float_expr(Builder *b, const Expr *e,
                            const AstDumpOptions *opts) {
  builder_puts(b, "(float ");
  builder_put_double(b, e->as.float_lit.value);
  if (e->as.float_lit.has_f_suffix)
    builder_puts(b, " f");
  if (opts->include_types)
    dump_type_annotation(b, e);
  builder_putc(b, ')');
}

static void dump_ident_expr(Builder *b, const Expr *e,
                            const AstDumpOptions *opts) {
  builder_puts(b, "(ident ");
  builder_put_quoted(b, e->as.ident.name, e->as.ident.name_len);
  if (opts->include_types)
    dump_type_annotation(b, e);
  builder_putc(b, ')');
}

static void dump_paren_expr(Builder *b, const Expr *e, int level,
                            const AstDumpOptions *opts) {
  builder_puts(b, "(paren");
  if (opts->include_types)
    dump_type_annotation(b, e);
  builder_putc(b, '\n');
  dump_expr(b, e->as.paren, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_unary_expr(Builder *b, const Expr *e, int level,
                            const AstDumpOptions *opts) {
  builder_puts(b, "(unary \"");
  builder_puts(b, op_name(e->as.unary.op));
  builder_putc(b, '"');
  if (opts->include_types)
    dump_type_annotation(b, e);
  builder_putc(b, '\n');
  dump_expr(b, e->as.unary.operand, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_binary_expr(Builder *b, const Expr *e, int level,
                             const AstDumpOptions *opts) {
  builder_puts(b, "(binary \"");
  builder_puts(b, op_name(e->as.binary.op));
  builder_putc(b, '"');
  if (opts->include_types)
    dump_type_annotation(b, e);
  builder_putc(b, '\n');
  dump_expr(b, e->as.binary.lhs, level + 1, opts);
  builder_putc(b, '\n');
  dump_expr(b, e->as.binary.rhs, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_int_expr_dispatch(Builder *b, const Expr *e, int level,
                                   const AstDumpOptions *opts) {
  (void)level;
  dump_int_expr(b, e, opts);
}

static void dump_float_expr_dispatch(Builder *b, const Expr *e, int level,
                                     const AstDumpOptions *opts) {
  (void)level;
  dump_float_expr(b, e, opts);
}

static void dump_ident_expr_dispatch(Builder *b, const Expr *e, int level,
                                     const AstDumpOptions *opts) {
  (void)level;
  dump_ident_expr(b, e, opts);
}

static void dump_token_seed_expr(Builder *b, const Expr *e, int level,
                                 const AstDumpOptions *opts) {
  (void)level;
  builder_puts(b, "(token-seed");
  if (opts->include_types)
    dump_type_annotation(b, e);
  builder_putc(b, ')');
}

typedef void (*DumpExprFn)(Builder *, const Expr *, int,
                           const AstDumpOptions *);

typedef struct ExprDumpEntry {
  ExprKind kind;
  DumpExprFn dump;
} ExprDumpEntry;

static const ExprDumpEntry kExprDumpers[] = {
    {EXPR_INT_LIT, dump_int_expr_dispatch},
    {EXPR_FLOAT_LIT, dump_float_expr_dispatch},
    {EXPR_IDENT, dump_ident_expr_dispatch},
    {EXPR_TOKEN_SEED, dump_token_seed_expr},
    {EXPR_PAREN, dump_paren_expr},
    {EXPR_UNARY, dump_unary_expr},
    {EXPR_BINARY, dump_binary_expr},
    {EXPR_CALL, dump_call},
};

static void dump_expr(Builder *b, const Expr *e, int level,
                      const AstDumpOptions *opts) {
  builder_indent(b, level);
  if (e == NULL) {
    builder_puts(b, "(null-expr)");
    return;
  }

  for (size_t i = 0; i < sizeof(kExprDumpers) / sizeof(kExprDumpers[0]); ++i)
    if (kExprDumpers[i].kind == e->kind)
      kExprDumpers[i].dump(b, e, level, opts);
}

/*===----------------------------------------------------------------===*/
/* Statement printing                                                    */
/*===----------------------------------------------------------------===*/

static void dump_stmt(Builder *b, const Stmt *s, int level,
                      const AstDumpOptions *opts);

/* A bound name prints as a quoted slice. */
static void dump_bound_name(Builder *b, const BoundName *n) {
  builder_put_quoted(b, n->name, n->name_len);
}

/* Print a block's child statements at `level`; the "(block ...)" wrapper
 * is emitted by the caller so if/for/etc can place it inline. */
static void dump_block_body(Builder *b, const Stmt *blk, int level,
                            const AstDumpOptions *opts) {
  size_t i;
  const StmtBlock *bl;
  builder_puts(b, "(block");
  if (blk == NULL || blk->kind != STMT_BLOCK) {
    builder_puts(b, " <malformed>)");
    return;
  }
  bl = &blk->as.block;
  if (bl->stmt_count == 0) {
    builder_putc(b, ')');
    return;
  }
  builder_putc(b, '\n');
  for (i = 0; i < bl->stmt_count; i++) {
    dump_stmt(b, bl->stmts[i], level + 1, opts);
    builder_putc(b, '\n');
  }
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_decl_stmt(Builder *b, const Stmt *s, int level,
                           const AstDumpOptions *opts) {
  builder_puts(b, "(decl ");
  dump_type(b, s->as.decl.type);
  builder_putc(b, ' ');
  dump_bound_name(b, &s->as.decl.name);
  builder_putc(b, '\n');
  dump_expr(b, s->as.decl.init, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_destructure_stmt(Builder *b, const Stmt *s, int level,
                                  const AstDumpOptions *opts) {
  size_t i;
  builder_puts(b, "(destructure (names");
  for (i = 0; i < s->as.destructure.name_count; i++) {
    builder_putc(b, ' ');
    dump_bound_name(b, &s->as.destructure.names[i]);
  }
  builder_puts(b, ")\n");
  dump_expr(b, s->as.destructure.init, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_assign_stmt(Builder *b, const Stmt *s, int level,
                             const AstDumpOptions *opts) {
  builder_puts(b, "(assign \"");
  builder_puts(b, op_name(s->as.assign.op));
  builder_puts(b, "\" ");
  dump_bound_name(b, &s->as.assign.target);
  builder_putc(b, '\n');
  dump_expr(b, s->as.assign.value, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_call_stmt(Builder *b, const Stmt *s, int level,
                           const AstDumpOptions *opts) {
  builder_puts(b, "(call-stmt\n");
  dump_expr(b, s->as.call.call, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_cond_header(Builder *b, const Expr *cond, int level,
                             const AstDumpOptions *opts) {
  builder_indent(b, level + 1);
  builder_puts(b, "(cond\n");
  dump_expr(b, cond, level + 2, opts);
  builder_putc(b, '\n');
  builder_indent(b, level + 1);
  builder_puts(b, ")\n");
}

static void dump_cond_stmt(Builder *b, const Stmt *s, int level,
                           const AstDumpOptions *opts) {
  builder_puts(b, s->kind == STMT_IF ? "(if\n" : "(where\n");
  dump_cond_header(b, s->as.cond.cond, level, opts);
  builder_indent(b, level + 1);
  dump_block_body(b, s->as.cond.then_block, level + 1, opts);
  if (s->as.cond.else_block != NULL) {
    builder_putc(b, '\n');
    builder_indent(b, level + 1);
    builder_puts(b, s->kind == STMT_IF ? "(else " : "(otherwise ");
    dump_block_body(b, s->as.cond.else_block, level + 1, opts);
    builder_putc(b, ')');
  }
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_for_bound(Builder *b, const char *tag, const Expr *expr,
                           int level, const AstDumpOptions *opts) {
  builder_indent(b, level + 1);
  builder_puts(b, tag);
  builder_putc(b, '\n');
  dump_expr(b, expr, level + 2, opts);
  builder_putc(b, '\n');
  builder_indent(b, level + 1);
  builder_puts(b, ")\n");
}

static void dump_for_stmt(Builder *b, const Stmt *s, int level,
                          const AstDumpOptions *opts) {
  builder_puts(b, "(for ");
  dump_type(b, s->as.for_.iv_type);
  builder_putc(b, ' ');
  dump_bound_name(b, &s->as.for_.iv_name);
  builder_putc(b, '\n');
  dump_for_bound(b, "(lb", s->as.for_.lb, level, opts);
  dump_for_bound(b, "(ub", s->as.for_.ub, level, opts);
  if (s->as.for_.step != NULL)
    dump_for_bound(b, "(step", s->as.for_.step, level, opts);
  builder_indent(b, level + 1);
  dump_block_body(b, s->as.for_.body, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

static void dump_while_stmt(Builder *b, const Stmt *s, int level,
                            const AstDumpOptions *opts) {
  builder_puts(b, "(while\n");
  dump_cond_header(b, s->as.while_.cond, level, opts);
  builder_indent(b, level + 1);
  dump_block_body(b, s->as.while_.body, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

typedef void (*DumpStmtFn)(Builder *, const Stmt *, int,
                           const AstDumpOptions *);

typedef struct StmtDumpEntry {
  StmtKind kind;
  DumpStmtFn dump;
} StmtDumpEntry;

static const StmtDumpEntry kStmtDumpers[] = {
    {STMT_DECL, dump_decl_stmt},     {STMT_DESTRUCTURE, dump_destructure_stmt},
    {STMT_ASSIGN, dump_assign_stmt}, {STMT_CALL, dump_call_stmt},
    {STMT_IF, dump_cond_stmt},       {STMT_WHERE, dump_cond_stmt},
    {STMT_FOR, dump_for_stmt},       {STMT_WHILE, dump_while_stmt},
    {STMT_BLOCK, dump_block_body},
};

static void dump_stmt(Builder *b, const Stmt *s, int level,
                      const AstDumpOptions *opts) {
  builder_indent(b, level);
  if (s == NULL) {
    builder_puts(b, "(null-stmt)");
    return;
  }

  for (size_t i = 0; i < sizeof(kStmtDumpers) / sizeof(kStmtDumpers[0]); ++i)
    if (kStmtDumpers[i].kind == s->kind)
      kStmtDumpers[i].dump(b, s, level, opts);
}

/*===----------------------------------------------------------------===*/
/* Top-level printing                                                    */
/*===----------------------------------------------------------------===*/

static void dump_attribute(Builder *b, const Attribute *a) {
  builder_puts(b, "(attr ");
  builder_put_quoted(b, a->name, a->name_len);
  if (a->has_arg) {
    builder_putc(b, ' ');
    builder_put_u64(b, a->arg);
  }
  builder_putc(b, ')');
}

static void dump_param(Builder *b, const Param *p, int level) {
  builder_indent(b, level);
  builder_puts(b, "(param ");
  dump_type(b, p->type);
  builder_putc(b, ' ');
  dump_bound_name(b, &p->name);
  builder_putc(b, ')');
}

static void dump_kernel(Builder *b, const Kernel *k, int level,
                        const AstDumpOptions *opts) {
  size_t i;
  builder_indent(b, level);
  builder_puts(b, "(kernel ");
  dump_bound_name(b, &k->name);
  builder_putc(b, '\n');

  /* attributes (single line) */
  builder_indent(b, level + 1);
  if (k->attr_count == 0) {
    builder_puts(b, "(attrs)");
  } else {
    builder_puts(b, "(attrs");
    for (i = 0; i < k->attr_count; i++) {
      builder_putc(b, ' ');
      dump_attribute(b, k->attrs[i]);
    }
    builder_putc(b, ')');
  }
  builder_putc(b, '\n');

  /* params (one per line for stable diffs) */
  builder_indent(b, level + 1);
  if (k->param_count == 0) {
    builder_puts(b, "(params)");
  } else {
    builder_puts(b, "(params\n");
    for (i = 0; i < k->param_count; i++) {
      dump_param(b, k->params[i], level + 2);
      builder_putc(b, '\n');
    }
    builder_indent(b, level + 1);
    builder_putc(b, ')');
  }
  builder_putc(b, '\n');

  /* body */
  builder_indent(b, level + 1);
  dump_block_body(b, k->body, level + 1, opts);
  builder_putc(b, '\n');
  builder_indent(b, level);
  builder_putc(b, ')');
}

/*===----------------------------------------------------------------===*/
/* Public entry points                                                   */
/*===----------------------------------------------------------------===*/

static int effective_indent(const AstDumpOptions *options) {
  if (options == NULL || options->indent_width <= 0)
    return 2;
  return options->indent_width;
}

const char *astdump_program(Arena *arena, const Program *program,
                            const AstDumpOptions *options) {
  Builder b;
  AstDumpOptions local;
  size_t i;

  if (options != NULL)
    local = *options;
  else {
    local.include_types = 0;
    local.indent_width = 0;
  }

  builder_init(&b, arena, effective_indent(&local));

  if (program == NULL) {
    /* Contract: a NULL program yields the empty string on a live arena. */
    builder_puts(&b, "");
    return builder_finish(&b);
  }

  builder_puts(&b, "(program");
  if (program->kernel_count == 0) {
    builder_putc(&b, ')');
    builder_putc(&b, '\n');
    return builder_finish(&b);
  }
  builder_putc(&b, '\n');
  for (i = 0; i < program->kernel_count; i++) {
    dump_kernel(&b, program->kernels[i], 1, &local);
    builder_putc(&b, '\n');
  }
  builder_putc(&b, ')');
  builder_putc(&b, '\n');
  return builder_finish(&b);
}

const char *astdump_expr(Arena *arena, const Expr *expr,
                         const AstDumpOptions *options) {
  Builder b;
  AstDumpOptions local;

  if (options != NULL)
    local = *options;
  else {
    local.include_types = 0;
    local.indent_width = 0;
  }

  builder_init(&b, arena, effective_indent(&local));

  if (expr == NULL) {
    builder_puts(&b, "");
    return builder_finish(&b);
  }
  dump_expr(&b, expr, 0, &local);
  builder_putc(&b, '\n');
  return builder_finish(&b);
}
