/*===- sema_test.c - Unit tests for the semantic analyzer -----*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Tests stage 3 (sema) at its OWN
 * interface, per the Implementation rule "every stage tested
 * independently": feed the input form (an AST), assert the output form
 * (accept/reject + the precise diagnostic + the resolved sema_type on
 * each expression). sema consumes the AST data structure from ast.h, so
 * these tests construct ASTs directly in an arena and run sema_check --
 * they do NOT depend on the lexer/parser, which are written by a separate
 * stage agent and are not required to exercise sema.
 *
 * (Blocker note: the task's cc one-liner also lists src/lex.c, src/parse.c
 * and src/astdump.c, none of which exist in the tree yet. Sema is the
 * stage under test and only needs ast.h + arena.c + diag.c, so this test
 * is built and run against exactly those. See the agent's final report.)
 *
 * Checks use a custom CHECK macro, not assert(): assert() is a no-op under
 * -DNDEBUG, which would silently neuter the test. CHECK always evaluates
 * and records failures in any build.
 */

#include "arena.h"
#include "ast.h"
#include "diag.h"
#include "sema.h"
#include "token.h"

/*
 * The lexer, parser and astdump landed (a parallel stage agent's work).
 * Including them lets a second test group drive sema through REAL source
 * text -- lex -> parse -> sema -> typed astdump -- which both confirms the
 * parser's AST is the one sema expects and asserts on the resolved types
 * sema annotates. The hand-built-AST group above remains the primary,
 * parser-independent test of sema's interface; this group is integration
 * coverage at the sema boundary. If these headers/sources are ever absent,
 * delete this group and the first group still fully tests sema.
 */
#include "astdump.h"
#include "lex.h"
#include "parse.h"

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*===----------------------------------------------------------------===*/
/* Test harness                                                          */
/*===----------------------------------------------------------------===*/

static int g_failures;

#define CHECK(cond, msg)                                                       \
  do {                                                                         \
    if (!(cond)) {                                                             \
      fprintf(stderr, "CHECK failed at %s:%d: %s (%s)\n", __FILE__, __LINE__,  \
              #cond, (msg));                                                   \
      g_failures++;                                                            \
    }                                                                          \
  } while (0)

/*===----------------------------------------------------------------===*/
/* AST builders (arena-allocated, mirroring the parser's output shapes)  */
/*===----------------------------------------------------------------===*/

/* A zero span; these tests do not assert on spans. */
static SourceSpan span0(void) {
  SourceSpan s;
  s.offset = 0;
  s.len = 0;
  s.line = 1;
  s.col = 1;
  return s;
}

static void *xalloc(Arena *a, size_t n) {
  void *p = arena_alloc(a, n, sizeof(void *));
  if (p == NULL) {
    fprintf(stderr, "FATAL: arena exhausted in test builder\n");
    exit(2);
  }
  memset(p, 0, n);
  return p;
}

/* --- Types -------------------------------------------------------- */

static TypeRef *ty_scalar(Arena *a, ScalarKind k) {
  TypeRef *t = (TypeRef *)xalloc(a, sizeof(TypeRef));
  t->kind = TYPE_SCALAR;
  t->scalar = k;
  t->span = span0();
  return t;
}

static TypeRef *ty_ptr(Arena *a, ScalarKind elem, int is_shared) {
  TypeRef *t = ty_scalar(a, elem);
  t->is_pointer = 1;
  t->is_shared = is_shared;
  return t;
}

static TypeRef *ty_simd(Arena *a, TypeRef *elem, uint64_t w) {
  TypeRef *t = (TypeRef *)xalloc(a, sizeof(TypeRef));
  t->kind = TYPE_SIMD;
  t->element = elem;
  t->width = w;
  t->span = span0();
  return t;
}

static TypeRef *ty_mask(Arena *a, uint64_t w) {
  TypeRef *t = (TypeRef *)xalloc(a, sizeof(TypeRef));
  t->kind = TYPE_MASK;
  t->width = w;
  t->span = span0();
  return t;
}

static TypeRef *ty_shared_nonptr(Arena *a, ScalarKind elem) {
  TypeRef *t = ty_scalar(a, elem);
  t->is_shared = 1; /* shared WITHOUT a pointer: the error case. */
  return t;
}

/* --- Expressions -------------------------------------------------- */

static Expr *e_new(Arena *a, ExprKind k) {
  Expr *e = (Expr *)xalloc(a, sizeof(Expr));
  e->kind = k;
  e->span = span0();
  e->sema_type = NULL;
  return e;
}

static Expr *e_int(Arena *a, uint64_t v) {
  Expr *e = e_new(a, EXPR_INT_LIT);
  e->as.int_lit.value = v;
  e->as.int_lit.is_hex = 0;
  return e;
}

static Expr *e_float(Arena *a, double v, int has_f) {
  Expr *e = e_new(a, EXPR_FLOAT_LIT);
  e->as.float_lit.value = v;
  e->as.float_lit.has_f_suffix = has_f;
  return e;
}

static Expr *e_ident(Arena *a, const char *name) {
  Expr *e = e_new(a, EXPR_IDENT);
  e->as.ident.name = name;
  e->as.ident.name_len = (uint32_t)strlen(name);
  return e;
}

static Expr *e_token_seed(Arena *a) { return e_new(a, EXPR_TOKEN_SEED); }

static Expr *e_unary(Arena *a, TokenKind op, Expr *operand) {
  Expr *e = e_new(a, EXPR_UNARY);
  e->as.unary.op = op;
  e->as.unary.operand = operand;
  return e;
}

static Expr *e_bin(Arena *a, TokenKind op, Expr *l, Expr *r) {
  Expr *e = e_new(a, EXPR_BINARY);
  e->as.binary.op = op;
  e->as.binary.lhs = l;
  e->as.binary.rhs = r;
  return e;
}

/* A call with `argc` value args (passed as an array the caller fills),
 * `gargc` generic args, and an optional `after` dependency. */
static Expr *e_call(Arena *a, const char *callee, GArg *gargs, size_t gargc,
                    Expr **args, size_t argc, Expr *dep) {
  Expr *e = e_new(a, EXPR_CALL);
  e->as.call.callee = e_ident(a, callee);
  e->as.call.gargs = gargs;
  e->as.call.garg_count = gargc;
  e->as.call.args = args;
  e->as.call.arg_count = argc;
  e->as.call.dep = dep;
  e->as.call.has_dep = (dep != NULL);
  return e;
}

static GArg *garg_int_arr(Arena *a, uint64_t v) {
  GArg *g = (GArg *)xalloc(a, sizeof(GArg));
  g->kind = GARG_INT;
  g->int_value = v;
  g->span = span0();
  return g;
}

static GArg *garg_type_arr(Arena *a, TypeRef *t) {
  GArg *g = (GArg *)xalloc(a, sizeof(GArg));
  g->kind = GARG_TYPE;
  g->type = t;
  g->span = span0();
  return g;
}

static Expr **expr_arr(Arena *a, size_t n) {
  return (Expr **)xalloc(a, n * sizeof(Expr *));
}

/* Convenience: lane_id<W>() */
static Expr *e_lane_id(Arena *a, uint64_t w) {
  return e_call(a, "lane_id", garg_int_arr(a, w), 1, NULL, 0, NULL);
}

/* --- Statements --------------------------------------------------- */

static BoundName bname(const char *n) {
  BoundName b;
  b.name = n;
  b.name_len = (uint32_t)strlen(n);
  b.span = span0();
  return b;
}

static Stmt *s_new(Arena *a, StmtKind k) {
  Stmt *s = (Stmt *)xalloc(a, sizeof(Stmt));
  s->kind = k;
  s->span = span0();
  return s;
}

static Stmt *s_decl(Arena *a, TypeRef *t, const char *name, Expr *init) {
  Stmt *s = s_new(a, STMT_DECL);
  s->as.decl.type = t;
  s->as.decl.name = bname(name);
  s->as.decl.init = init;
  return s;
}

static Stmt *s_assign(Arena *a, const char *target, TokenKind op, Expr *v) {
  Stmt *s = s_new(a, STMT_ASSIGN);
  s->as.assign.target = bname(target);
  s->as.assign.op = op;
  s->as.assign.value = v;
  return s;
}

static Stmt *s_call(Arena *a, Expr *call) {
  Stmt *s = s_new(a, STMT_CALL);
  s->as.call.call = call;
  return s;
}

static Stmt *s_block(Arena *a, Stmt **stmts, size_t n) {
  Stmt *s = s_new(a, STMT_BLOCK);
  s->as.block.stmts = stmts;
  s->as.block.stmt_count = n;
  return s;
}

static Stmt **stmt_arr(Arena *a, size_t n) {
  return (Stmt **)xalloc(a, n * sizeof(Stmt *));
}

static Stmt *s_if(Arena *a, Expr *cond, Stmt *then_b, Stmt *else_b) {
  Stmt *s = s_new(a, STMT_IF);
  s->as.cond.cond = cond;
  s->as.cond.then_block = then_b;
  s->as.cond.else_block = else_b;
  return s;
}

static Stmt *s_where(Arena *a, Expr *cond, Stmt *then_b, Stmt *else_b) {
  Stmt *s = s_new(a, STMT_WHERE);
  s->as.cond.cond = cond;
  s->as.cond.then_block = then_b;
  s->as.cond.else_block = else_b;
  return s;
}

static Stmt *s_for(Arena *a, TypeRef *iv_type, const char *iv, Expr *lb,
                   Expr *ub, Expr *step, Stmt *body) {
  Stmt *s = s_new(a, STMT_FOR);
  s->as.for_.iv_type = iv_type;
  s->as.for_.iv_name = bname(iv);
  s->as.for_.lb = lb;
  s->as.for_.ub = ub;
  s->as.for_.step = step;
  s->as.for_.body = body;
  return s;
}

static Stmt *s_while(Arena *a, Expr *cond, Stmt *body) {
  Stmt *s = s_new(a, STMT_WHILE);
  s->as.while_.cond = cond;
  s->as.while_.body = body;
  return s;
}

static Stmt *s_destructure(Arena *a, const char **names, size_t n, Expr *init) {
  Stmt *s = s_new(a, STMT_DESTRUCTURE);
  BoundName *bn = (BoundName *)xalloc(a, n * sizeof(BoundName));
  size_t i;
  for (i = 0; i < n; i++)
    bn[i] = bname(names[i]);
  s->as.destructure.names = bn;
  s->as.destructure.name_count = n;
  s->as.destructure.init = init;
  return s;
}

/* --- Attributes / params / kernel / program ----------------------- */

static Attribute *attr(Arena *a, const char *name, int has_arg, uint64_t arg) {
  Attribute *at = (Attribute *)xalloc(a, sizeof(Attribute));
  at->name = name;
  at->name_len = (uint32_t)strlen(name);
  at->has_arg = has_arg;
  at->arg = arg;
  at->span = span0();
  return at;
}

static Param *param(Arena *a, TypeRef *t, const char *name) {
  Param *p = (Param *)xalloc(a, sizeof(Param));
  p->type = t;
  p->name = bname(name);
  p->span = span0();
  return p;
}

static Kernel *kernel(Arena *a, const char *name, Attribute **attrs, size_t na,
                      Param **params, size_t np, Stmt *body) {
  Kernel *k = (Kernel *)xalloc(a, sizeof(Kernel));
  k->name = bname(name);
  k->attrs = attrs;
  k->attr_count = na;
  k->params = params;
  k->param_count = np;
  k->body = body;
  k->span = span0();
  return k;
}

static Program *program1(Arena *a, Kernel *k) {
  Program *p = (Program *)xalloc(a, sizeof(Program));
  Kernel **ks = (Kernel **)xalloc(a, sizeof(Kernel *));
  ks[0] = k;
  p->kernels = ks;
  p->kernel_count = 1;
  p->span = span0();
  return p;
}

/* A kernel with a single [[amdgpu_wave_size(N)]] attribute, no params,
 * and the given top-level statements. The common shape for focused
 * type-rule tests. */
static Program *prog_wave(Arena *a, uint64_t n, Param **params, size_t np,
                          Stmt **stmts, size_t ns) {
  Attribute **attrs = (Attribute **)xalloc(a, sizeof(Attribute *));
  attrs[0] = attr(a, "amdgpu_wave_size", 1, n);
  return program1(a,
                  kernel(a, "k", attrs, 1, params, np, s_block(a, stmts, ns)));
}

/*===----------------------------------------------------------------===*/
/* Running sema + diagnostic search                                      */
/*===----------------------------------------------------------------===*/

/* Run sema on `prog` using a fresh diag list over the shared arena.
 * Returns the accept/reject result and exposes the diag list. */
static int run_sema(Arena *a, Program *prog, DiagList *out_diags) {
  SemaContext ctx;
  diag_list_init(out_diags, a);
  sema_context_init(&ctx, a, out_diags);
  return sema_check(&ctx, prog);
}

/* True iff some emitted diagnostic message contains `needle`. */
static int diag_contains(const DiagList *d, const char *needle) {
  const Diag *it;
  for (it = d->head; it != NULL; it = it->next) {
    if (it->message != NULL && strstr(it->message, needle) != NULL)
      return 1;
  }
  return 0;
}

/* Print all diags (used when a test unexpectedly fails, for debugging). */
static void dump_diags(const char *label, const DiagList *d) {
  const Diag *it;
  fprintf(stderr, "  [%s] diagnostics:\n", label);
  for (it = d->head; it != NULL; it = it->next)
    fprintf(stderr, "    %s\n", it->message);
}

/* Assert that a program is ACCEPTED; on failure, dump its diags. */
static void expect_accept(Arena *a, Program *prog, const char *label) {
  DiagList d;
  int ok = run_sema(a, prog, &d);
  if (!ok) {
    fprintf(stderr, "expected ACCEPT but got REJECT: %s\n", label);
    dump_diags(label, &d);
  }
  CHECK(ok, label);
}

/* Assert that a program is REJECTED and that some diagnostic contains the
 * expected substring. */
static void expect_reject(Arena *a, Program *prog, const char *needle,
                          const char *label) {
  DiagList d;
  int ok = run_sema(a, prog, &d);
  CHECK(!ok, label);
  if (!diag_contains(&d, needle)) {
    fprintf(stderr, "expected REJECT with '%s' but did not find it: %s\n",
            needle, label);
    dump_diags(label, &d);
    g_failures++;
  }
}

static void expect_reject2(Arena *a, Program *prog, const char *first,
                           const char *second, const char *label) {
  DiagList d;
  int ok = run_sema(a, prog, &d);
  CHECK(!ok, label);
  if (!diag_contains(&d, first) || !diag_contains(&d, second)) {
    fprintf(stderr, "expected REJECT with '%s' and '%s': %s\n", first, second,
            label);
    dump_diags(label, &d);
    g_failures++;
  }
}

/*===----------------------------------------------------------------===*/
/* ACCEPT cases                                                          */
/*===----------------------------------------------------------------===*/

/*
 * The north-star saxpy, built structurally (no parser):
 *   kernel [[amdgpu_wave_size(32)]]
 *   void saxpy(float *x, float *y, float a, uint32_t n) {
 *     simd<uint32_t,32> lane = lane_id<32>();
 *     uint32_t          wave = wave_id_in_grid();
 *     simd<uint32_t,32>  i   = wave * 32 + lane;
 *     mask<32>          active = i < n;
 *     where (active) {
 *       simd<float,32> xv = load(x + i);
 *       simd<float,32> yv = load(y + i);
 *       store(a * xv + yv, y + i);
 *     }
 *   }
 */
static void test_accept_saxpy(void) {
  Arena a = arena_create(1u << 20);
  Param **params = (Param **)xalloc(&a, 4 * sizeof(Param *));
  Attribute **attrs = (Attribute **)xalloc(&a, sizeof(Attribute *));
  Stmt **body;
  Stmt **wbody;
  Expr **t;
  Program *prog;

  params[0] = param(&a, ty_ptr(&a, SCALAR_FLOAT, 0), "x");
  params[1] = param(&a, ty_ptr(&a, SCALAR_FLOAT, 0), "y");
  params[2] = param(&a, ty_scalar(&a, SCALAR_FLOAT), "a");
  params[3] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");

  attrs[0] = attr(&a, "amdgpu_wave_size", 1, 32);

  /* where body: 3 statements. */
  wbody = stmt_arr(&a, 3);
  /* xv = load(x + i) */
  t = expr_arr(&a, 1);
  t[0] = e_bin(&a, TOK_PLUS, e_ident(&a, "x"), e_ident(&a, "i"));
  wbody[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "xv",
                    e_call(&a, "load", NULL, 0, t, 1, NULL));
  /* yv = load(y + i) */
  t = expr_arr(&a, 1);
  t[0] = e_bin(&a, TOK_PLUS, e_ident(&a, "y"), e_ident(&a, "i"));
  wbody[1] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "yv",
                    e_call(&a, "load", NULL, 0, t, 1, NULL));
  /* store(a * xv + yv, y + i) */
  t = expr_arr(&a, 2);
  t[0] = e_bin(&a, TOK_PLUS,
               e_bin(&a, TOK_STAR, e_ident(&a, "a"), e_ident(&a, "xv")),
               e_ident(&a, "yv"));
  t[1] = e_bin(&a, TOK_PLUS, e_ident(&a, "y"), e_ident(&a, "i"));
  wbody[2] = s_call(&a, e_call(&a, "store", NULL, 0, t, 2, NULL));

  /* top-level body: 5 statements. */
  body = stmt_arr(&a, 5);
  body[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_UINT32), 32), "lane",
                   e_lane_id(&a, 32));
  body[1] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "wave",
                   e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  body[2] =
      s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_UINT32), 32), "i",
             e_bin(&a, TOK_PLUS,
                   e_bin(&a, TOK_STAR, e_ident(&a, "wave"), e_int(&a, 32)),
                   e_ident(&a, "lane")));
  body[3] = s_decl(&a, ty_mask(&a, 32), "active",
                   e_bin(&a, TOK_LT, e_ident(&a, "i"), e_ident(&a, "n")));
  body[4] = s_where(&a, e_ident(&a, "active"), s_block(&a, wbody, 3), NULL);

  prog = program1(
      &a, kernel(&a, "saxpy", attrs, 1, params, 4, s_block(&a, body, 5)));
  expect_accept(&a, prog, "saxpy accepts");

  /* Spot-check a couple of resolved sema_types so we know it actually
   * propagated, not merely "no errors". */
  {
    Expr *icmp = body[3]->as.decl.init; /* i < n -> mask<32> */
    TypeRef *ct = (TypeRef *)icmp->sema_type;
    CHECK(ct != NULL && ct->kind == TYPE_MASK && ct->width == 32,
          "i < n resolves to mask<32>");
  }
  {
    Expr *mul = body[2]->as.decl.init->as.binary.lhs; /* wave * 32 */
    TypeRef *mt = (TypeRef *)mul->sema_type;
    /* wave is uint32 (scalar), 32 is a literal -> uint32 scalar. */
    CHECK(mt != NULL && mt->kind == TYPE_SCALAR && mt->scalar == SCALAR_UINT32,
          "wave * 32 is a uniform uint32 scalar");
  }
  {
    Expr *add = body[2]->as.decl.init; /* (wave*32) + lane -> simd */
    TypeRef *at = (TypeRef *)add->sema_type;
    CHECK(at != NULL && at->kind == TYPE_SIMD && at->width == 32,
          "scalar + simd broadcasts to simd<...,32>");
  }
  arena_destroy(&a);
}

/* A scalar broadcasts into a simd op; the result is a simd. */
static void test_accept_broadcast(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 2);
  Program *prog;
  Expr **ar;
  /* simd<float,32> v = cast<float>(lane_id<32>()); (a lane-varying float) */
  ar = expr_arr(&a, 1);
  ar[0] = e_lane_id(&a, 32);
  body[0] =
      s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "v",
             e_call(&a, "cast", garg_type_arr(&a, ty_scalar(&a, SCALAR_FLOAT)),
                    1, ar, 1, NULL));
  /* simd<float,32> w = 2.0f * v;  (scalar float broadcasts into simd) */
  body[1] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "w",
                   e_bin(&a, TOK_STAR, e_float(&a, 2.0, 1), e_ident(&a, "v")));
  prog = prog_wave(&a, 32, NULL, 0, body, 2);
  expect_accept(&a, prog, "scalar broadcasts into simd op");
  arena_destroy(&a);
}

/* A scalar compare yields bool; it drives an if. */
static void test_accept_scalar_compare_if(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Stmt **then_b = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");
  /* if (n < 10) { uint32_t z = n; } -- scalar compare -> bool -> if ok */
  then_b[0] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "z", e_ident(&a, "n"));
  body[0] = s_if(&a, e_bin(&a, TOK_LT, e_ident(&a, "n"), e_int(&a, 10)),
                 s_block(&a, then_b, 1), NULL);
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_accept(&a, prog, "scalar compare -> bool -> if");
  arena_destroy(&a);
}

/* A loop carry: a simd local declared before a for and reassigned inside
 * it (reduction). Accepts; the carry is just a mutable local. */
static void test_accept_for_carry(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 2);
  Stmt **loop_body = stmt_arr(&a, 1);
  Expr **ld;
  Program *prog;

  params[0] = param(&a, ty_ptr(&a, SCALAR_FLOAT, 0), "x");
  params[1] = param(&a, ty_scalar(&a, SCALAR_INDEX), "n");

  /* simd<float,32> acc = 0.0f;   (scalar broadcasts to simd) */
  body[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "acc",
                   e_float(&a, 0.0, 1));
  /* for index i in 0..n { acc = acc + load(x + i); } */
  ld = expr_arr(&a, 1);
  ld[0] = e_bin(&a, TOK_PLUS, e_ident(&a, "x"), e_ident(&a, "i"));
  loop_body[0] = s_assign(&a, "acc", TOK_ASSIGN,
                          e_bin(&a, TOK_PLUS, e_ident(&a, "acc"),
                                e_call(&a, "load", NULL, 0, ld, 1, NULL)));
  body[1] = s_for(&a, ty_scalar(&a, SCALAR_INDEX), "i", e_int(&a, 0),
                  e_ident(&a, "n"), NULL, s_block(&a, loop_body, 1));
  prog = prog_wave(&a, 32, params, 2, body, 2);
  expect_accept(&a, prog, "for-loop carry (reduction) accepts");
  arena_destroy(&a);
}

/* LDS round-trip with explicit tokens: lds_base, store->barrier->load
 * after, destructuring not needed. Exercises shared pointers + tokens. */
static void test_accept_lds_roundtrip(void) {
  Arena a = arena_create(1u << 19);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Attribute **attrs = (Attribute **)xalloc(&a, 2 * sizeof(Attribute *));
  Stmt **body = stmt_arr(&a, 6);
  Program *prog;
  Expr **ar;

  params[0] = param(&a, ty_ptr(&a, SCALAR_HALF, 0), "gA");
  params[1] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_INT32), 32), "off_a");

  attrs[0] = attr(&a, "amdgpu_wave_size", 1, 32);
  attrs[1] = attr(&a, "amdgpu_lds_size", 1, 4096);

  /* shared half *lds_a = lds_base<half>(0); */
  ar = expr_arr(&a, 1);
  ar[0] = e_int(&a, 0);
  body[0] = s_decl(&a, ty_ptr(&a, SCALAR_HALF, 1), "lds_a",
                   e_call(&a, "lds_base",
                          garg_type_arr(&a, ty_scalar(&a, SCALAR_HALF)), 1, ar,
                          1, NULL));
  /* token g0 = store(load(gA + off_a), lds_a); */
  {
    Expr **inner = expr_arr(&a, 1);
    Expr **outer = expr_arr(&a, 2);
    inner[0] = e_bin(&a, TOK_PLUS, e_ident(&a, "gA"), e_ident(&a, "off_a"));
    outer[0] = e_call(&a, "load", NULL, 0, inner, 1, NULL);
    outer[1] = e_ident(&a, "lds_a");
    body[1] = s_decl(&a, ty_scalar(&a, SCALAR_TOKEN), "g0",
                     e_call(&a, "store", NULL, 0, outer, 2, NULL));
  }
  /* token bar = barrier(g0); */
  {
    Expr **ba = expr_arr(&a, 1);
    ba[0] = e_ident(&a, "g0");
    body[2] = s_decl(&a, ty_scalar(&a, SCALAR_TOKEN), "bar",
                     e_call(&a, "barrier", NULL, 0, ba, 1, NULL));
  }
  /* simd<half,32> a2 = load(lds_a after bar); */
  {
    Expr **la = expr_arr(&a, 1);
    la[0] = e_ident(&a, "lds_a");
    body[3] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_HALF), 32), "a2",
                     e_call(&a, "load", NULL, 0, la, 1, e_ident(&a, "bar")));
  }
  /* token z = token(); */
  body[4] = s_decl(&a, ty_scalar(&a, SCALAR_TOKEN), "z", e_token_seed(&a));
  /* wait(bar); */
  {
    Expr **wa = expr_arr(&a, 1);
    wa[0] = e_ident(&a, "bar");
    body[5] = s_call(&a, e_call(&a, "wait", NULL, 0, wa, 1, NULL));
  }

  prog = program1(&a,
                  kernel(&a, "lds", attrs, 2, params, 2, s_block(&a, body, 6)));
  expect_accept(&a, prog, "LDS round-trip with tokens accepts");
  arena_destroy(&a);
}

/* where (mask) { ... } otherwise { ... } -- the mask drives where. */
static void test_accept_where_otherwise(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 2);
  Stmt **then_b = stmt_arr(&a, 1);
  Stmt **else_b = stmt_arr(&a, 1);
  Program *prog;

  params[0] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "xv");
  /* mask<32> pos = xv > 0.0f;  (simd compare -> mask) */
  body[0] = s_decl(&a, ty_mask(&a, 32), "pos",
                   e_bin(&a, TOK_GT, e_ident(&a, "xv"), e_float(&a, 0.0, 1)));
  /* simd<float,32> y = 1.0f; (carried across the where branches) */
  /* where (pos) { y = xv; } otherwise { y = 0.0f; } */
  then_b[0] = s_assign(&a, "y", TOK_ASSIGN, e_ident(&a, "xv"));
  else_b[0] = s_assign(&a, "y", TOK_ASSIGN, e_float(&a, 0.0, 1));
  {
    Stmt **full = stmt_arr(&a, 3);
    full[0] = body[0];
    full[1] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "y",
                     e_float(&a, 1.0, 1));
    full[2] = s_where(&a, e_ident(&a, "pos"), s_block(&a, then_b, 1),
                      s_block(&a, else_b, 1));
    prog = prog_wave(&a, 32, params, 1, full, 3);
  }
  expect_accept(&a, prog, "where/otherwise with a mask accepts");
  arena_destroy(&a);
}

/* cast<half>(simd<float,32>) -> simd<half,32> (fpconvert, no policy). */
static void test_accept_cast(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  Expr **ar;
  params[0] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "xv");
  ar = expr_arr(&a, 1);
  ar[0] = e_ident(&a, "xv");
  body[0] =
      s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_HALF), 32), "h",
             e_call(&a, "cast", garg_type_arr(&a, ty_scalar(&a, SCALAR_HALF)),
                    1, ar, 1, NULL));
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_accept(&a, prog, "cast<half> of a simd<float> accepts");
  /* check the result type really is simd<half,32>. */
  {
    TypeRef *ht = (TypeRef *)body[0]->as.decl.init->sema_type;
    CHECK(ht != NULL && ht->kind == TYPE_SIMD && ht->width == 32 &&
              ht->element != NULL && ht->element->scalar == SCALAR_HALF,
          "cast<half> yields simd<half,32>");
  }
  arena_destroy(&a);
}

/* An int->fp cast and a widening int->int cast: both need policies that
 * are derivable from the sized-int signedness; sema must accept them. */
static void test_accept_cast_policies(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 2);
  Program *prog;
  /* simd<float,32> f = cast<float>(lane_id<32>());  int32 -> f32 */
  {
    Expr **ar = expr_arr(&a, 1);
    ar[0] = e_lane_id(&a, 32);
    body[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "f",
                     e_call(&a, "cast",
                            garg_type_arr(&a, ty_scalar(&a, SCALAR_FLOAT)), 1,
                            ar, 1, NULL));
  }
  /* simd<int64_t,32> w = cast<int64_t>(lane_id<32>()); widening intconvert */
  {
    Expr **ar = expr_arr(&a, 1);
    ar[0] = e_lane_id(&a, 32);
    body[1] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_INT64), 32), "w",
                     e_call(&a, "cast",
                            garg_type_arr(&a, ty_scalar(&a, SCALAR_INT64)), 1,
                            ar, 1, NULL));
  }
  prog = prog_wave(&a, 32, NULL, 0, body, 2);
  expect_accept(&a, prog, "int->fp and widening int->int casts accept");
  arena_destroy(&a);
}

/*===----------------------------------------------------------------===*/
/* REJECT cases (each with the precise diagnostic)                       */
/*===----------------------------------------------------------------===*/

/* mask used as an `if` condition -> the if/where split rejects it. */
static void test_reject_mask_in_if(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 2);
  Stmt **then_b = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_UINT32), 32), "i");
  /* mask<32> m = i < 5; if (m) { ... } */
  body[0] = s_decl(&a, ty_mask(&a, 32), "m",
                   e_bin(&a, TOK_LT, e_ident(&a, "i"), e_int(&a, 5)));
  then_b[0] = s_decl(&a, ty_scalar(&a, SCALAR_INT32), "z", e_int(&a, 1));
  body[1] = s_if(&a, e_ident(&a, "m"), s_block(&a, then_b, 1), NULL);
  prog = prog_wave(&a, 32, params, 1, body, 2);
  expect_reject(&a, prog, "'if' requires a uniform bool",
                "mask in if rejected");
  arena_destroy(&a);
}

/* bool used as a `where` condition -> rejected (where wants a mask). */
static void test_reject_bool_in_where(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 2);
  Stmt **then_b = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");
  /* bool b = n < 5; where (b) { ... } */
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_BOOL), "b",
                   e_bin(&a, TOK_LT, e_ident(&a, "n"), e_int(&a, 5)));
  then_b[0] = s_decl(&a, ty_scalar(&a, SCALAR_INT32), "z", e_int(&a, 1));
  body[1] = s_where(&a, e_ident(&a, "b"), s_block(&a, then_b, 1), NULL);
  prog = prog_wave(&a, 32, params, 1, body, 2);
  expect_reject(&a, prog, "'where' requires a mask", "bool in where rejected");
  arena_destroy(&a);
}

/* `shared` on a non-pointer type -> sema rule violation. */
static void test_reject_shared_nonpointer(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  /* shared half lds = 0;  (shared without a star) */
  body[0] = s_decl(&a, ty_shared_nonptr(&a, SCALAR_HALF), "lds", e_int(&a, 0));
  prog = prog_wave(&a, 32, NULL, 0, body, 1);
  expect_reject(&a, prog, "'shared' requires a pointer",
                "shared non-pointer rejected");
  arena_destroy(&a);
}

/* A simd width that differs from the kernel wave size N, isolated to the
 * DECLARED TYPE's width check (the initializer is a broadcast scalar
 * literal, which carries no competing width, so the only error is the
 * type's W != N). */
static void test_reject_width_mismatch(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  /* kernel wave size 32, but simd<uint32_t,64> v = 0; */
  body[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_UINT32), 64), "v",
                   e_int(&a, 0));
  prog = prog_wave(&a, 32, NULL, 0, body, 1);
  expect_reject(&a, prog, "simd width 64 must equal the kernel wave size 32",
                "simd type width != N rejected");
  arena_destroy(&a);
}

/* lane_id<W> with W != N. */
static void test_reject_lane_id_width(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  body[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_INT32), 32), "v",
                   e_lane_id(&a, 16)); /* lane_id<16> in a wave-32 kernel */
  prog = prog_wave(&a, 32, NULL, 0, body, 1);
  expect_reject(&a, prog, "lane_id width 16 must equal the kernel wave size 32",
                "lane_id<W> width mismatch rejected");
  arena_destroy(&a);
}

/* use-before-def: a local referenced inside its own initializer. The name
 * is in scope (declared) but not yet defined -> use-before-def, distinct
 * from "undeclared". */
static void test_reject_use_before_def(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  /* uint32_t x = x + 1;  (x used before its definition) */
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "x",
                   e_bin(&a, TOK_PLUS, e_ident(&a, "x"), e_int(&a, 1)));
  prog = prog_wave(&a, 32, NULL, 0, body, 1);
  expect_reject(&a, prog, "before its definition", "self-ref use-before-def");
  arena_destroy(&a);
}

/* A second use-before-def shape: a forward reference. A local read in a
 * sibling declaration's initializer BEFORE its own declaration line --
 * the name is not yet in scope at the point of use. This is the
 * definite-assignment / dominating-definition rule (the same machinery
 * the some-but-not-all-branch carry check relies on). */
static void test_reject_use_before_def_forward(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 2);
  Program *prog;
  /* uint32_t a1 = b1 + 1;   (b1 used before it is declared below) */
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "a1",
                   e_bin(&a, TOK_PLUS, e_ident(&a, "b1"), e_int(&a, 1)));
  body[1] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "b1", e_int(&a, 2));
  prog = prog_wave(&a, 32, NULL, 0, body, 2);
  /* b1 is not yet declared at the use -> "undeclared identifier". (Once
   * the grammar supports split decl/def this becomes the branch
   * use-before-def; the analysis is the same dominating-def check.) */
  expect_reject(&a, prog, "undeclared identifier",
                "forward reference rejected");
  arena_destroy(&a);
}

/* Branch-merge definedness, accept side: a carry defined BEFORE an if (so
 * it has a dominating def), compound-assigned in the then branch only,
 * then read after the if. The merge must keep it defined -- no false
 * use-before-def. This exercises the if/where merge path that the
 * some-but-not-all-branch rule guards. */
static void test_accept_branch_merge_carry(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 3);
  Stmt **then_b = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");
  /* uint32_t acc = 0;  -- dominating definition before the if. */
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "acc", e_int(&a, 0));
  /* if (n < 4) { acc += n; }   -- then-only reassignment (a carry). */
  then_b[0] = s_assign(&a, "acc", TOK_PLUS_EQ, e_ident(&a, "n"));
  body[1] = s_if(&a, e_bin(&a, TOK_LT, e_ident(&a, "n"), e_int(&a, 4)),
                 s_block(&a, then_b, 1), NULL);
  /* uint32_t z = acc;  -- acc had a dominating def -> still defined. */
  body[2] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "z", e_ident(&a, "acc"));
  prog = prog_wave(&a, 32, params, 1, body, 3);
  expect_accept(&a, prog,
                "carry defined before an if stays defined after the merge");
  arena_destroy(&a);
}

/* Branch-merge definedness, both-branches side: a variable defined in
 * BOTH branches of an if/else (each with a dominating-init via the carry)
 * stays defined after. A compound assignment to a pre-defined local is
 * also accepted here (guards against over-rejection of reads). */
static void test_accept_compound_assign(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 3);
  Stmt **then_b = stmt_arr(&a, 1);
  Stmt **else_b = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");
  /* uint32_t acc = 1; */
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "acc", e_int(&a, 1));
  /* if (n < 4) { acc *= n; } else { acc -= n; } */
  then_b[0] = s_assign(&a, "acc", TOK_STAR_EQ, e_ident(&a, "n"));
  else_b[0] = s_assign(&a, "acc", TOK_MINUS_EQ, e_ident(&a, "n"));
  body[1] = s_if(&a, e_bin(&a, TOK_LT, e_ident(&a, "n"), e_int(&a, 4)),
                 s_block(&a, then_b, 1), s_block(&a, else_b, 1));
  /* uint32_t z = acc; */
  body[2] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "z", e_ident(&a, "acc"));
  prog = prog_wave(&a, 32, params, 1, body, 3);
  expect_accept(&a, prog,
                "compound assignment to a defined carry in both branches "
                "accepts");
  arena_destroy(&a);
}

/* Implicit simd -> scalar conversion is rejected (no read_first/reduce). */
static void test_reject_implicit_simd_to_scalar(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 2);
  Program *prog;
  /* simd<float,32> v = cast<float>(lane_id<32>()); */
  {
    Expr **ar = expr_arr(&a, 1);
    ar[0] = e_lane_id(&a, 32);
    body[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "v",
                     e_call(&a, "cast",
                            garg_type_arr(&a, ty_scalar(&a, SCALAR_FLOAT)), 1,
                            ar, 1, NULL));
  }
  /* float s = v;  (simd -> scalar, implicit) -> rejected */
  body[1] = s_decl(&a, ty_scalar(&a, SCALAR_FLOAT), "s", e_ident(&a, "v"));
  prog = prog_wave(&a, 32, NULL, 0, body, 2);
  expect_reject(&a, prog, "no implicit simd->scalar",
                "implicit simd->scalar rejected");
  arena_destroy(&a);
}

/* An unknown attribute name -> rejected (closed attribute set). */
static void test_reject_unknown_attribute(void) {
  Arena a = arena_create(1u << 18);
  Attribute **attrs = (Attribute **)xalloc(&a, 2 * sizeof(Attribute *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  attrs[0] = attr(&a, "amdgpu_wave_size", 1, 32);
  attrs[1] = attr(&a, "amdgpu_unroll", 1, 4); /* not in the closed set */
  body[0] = s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  prog = program1(&a, kernel(&a, "k", attrs, 2, NULL, 0, s_block(&a, body, 1)));
  expect_reject(&a, prog, "unknown attribute", "unknown attribute rejected");
  arena_destroy(&a);
}

/* A kernel missing [[amdgpu_wave_size]] while using simd -> rejected. */
static void test_reject_missing_wave_size(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  body[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_INT32), 32), "v",
                   e_lane_id(&a, 32));
  prog = program1(&a, kernel(&a, "k", NULL, 0, NULL, 0, s_block(&a, body, 1)));
  expect_reject(&a, prog, "simd<T,W> requires", "missing wave size rejected");
  arena_destroy(&a);
}

/* if takes bool but where takes mask -- the dual: a simd compare cannot
 * feed an `if` (it is a mask), confirming the type-directed herding. */
static void test_reject_simd_compare_in_if(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Stmt **then_b = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_INT32), 32), "i");
  then_b[0] = s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  /* if (i < 5) {...}  -- i<5 is a mask -> cannot be an if condition */
  body[0] = s_if(&a, e_bin(&a, TOK_LT, e_ident(&a, "i"), e_int(&a, 5)),
                 s_block(&a, then_b, 1), NULL);
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_reject(&a, prog, "must be", "simd compare in if rejected (mask)");
  arena_destroy(&a);
}

/* The for IV must be index/sized int, not e.g. float. */
static void test_reject_for_iv_type(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Stmt **loop_body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_FLOAT), "n");
  loop_body[0] =
      s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  /* for float i in 0..n {...} -- float IV is illegal */
  body[0] = s_for(&a, ty_scalar(&a, SCALAR_FLOAT), "i", e_int(&a, 0),
                  e_ident(&a, "n"), NULL, s_block(&a, loop_body, 1));
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_reject(&a, prog, "induction variable must be",
                "float for-IV rejected");
  arena_destroy(&a);
}

/* shared requires a pointer is also enforced on parameters. */
static void test_reject_shared_param(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_shared_nonptr(&a, SCALAR_FLOAT), "p");
  body[0] = s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_reject(&a, prog, "'shared' requires a pointer",
                "shared non-pointer param rejected");
  arena_destroy(&a);
}

/* store value/pointer element mismatch (simd<float> into half*). */
static void test_reject_store_mismatch(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  Expr **ar;
  params[0] = param(&a, ty_ptr(&a, SCALAR_HALF, 0), "p");
  params[1] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "v");
  ar = expr_arr(&a, 2);
  ar[0] = e_ident(&a, "v"); /* simd<float,32> */
  ar[1] = e_bin(&a, TOK_PLUS, e_ident(&a, "p"), e_lane_id(&a, 32)); /* half* */
  body[0] = s_call(&a, e_call(&a, "store", NULL, 0, ar, 2, NULL));
  prog = prog_wave(&a, 32, params, 2, body, 1);
  expect_reject(&a, prog, "does not match pointer element",
                "store element mismatch rejected");
  arena_destroy(&a);
}

/* store(value, ptr) diagnoses both bad operands. */
static void test_reject_store_bad_operands(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  Expr **ar = expr_arr(&a, 2);
  params[0] = param(&a, ty_scalar(&a, SCALAR_UINT32), "bad");
  ar[0] = e_ident(&a, "bad");
  ar[1] = e_ident(&a, "bad");
  body[0] = s_call(&a, e_call(&a, "store", NULL, 0, ar, 2, NULL));
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_reject2(&a, prog, "store target must be a pointer",
                 "store value must be a simd<T,W>",
                 "store rejects bad value and pointer");
  arena_destroy(&a);
}

/* using wait()'s (void) result in a value context -> rejected. */
static void test_reject_void_in_value(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 2);
  Program *prog;
  Expr **wa;
  params[0] = param(&a, ty_scalar(&a, SCALAR_TOKEN), "t");
  /* token z = wait(t);  -- wait yields no value */
  wa = expr_arr(&a, 1);
  wa[0] = e_ident(&a, "t");
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_TOKEN), "z",
                   e_call(&a, "wait", NULL, 0, wa, 1, NULL));
  body[1] = s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  prog = prog_wave(&a, 32, params, 1, body, 2);
  expect_reject(&a, prog, "produces no value",
                "void result in value context rejected");
  arena_destroy(&a);
}

/* `if` rejects a non-bool, non-mask scalar (e.g. a uint32) too. */
static void test_reject_int_in_if(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Stmt **then_b = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");
  then_b[0] = s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  body[0] = s_if(&a, e_ident(&a, "n"), s_block(&a, then_b, 1), NULL);
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_reject(&a, prog, "'if' requires a uniform bool", "int in if rejected");
  arena_destroy(&a);
}

/* A duplicate amdgpu_wave_size attribute is rejected. */
static void test_reject_duplicate_wave_size(void) {
  Arena a = arena_create(1u << 18);
  Attribute **attrs = (Attribute **)xalloc(&a, 2 * sizeof(Attribute *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  attrs[0] = attr(&a, "amdgpu_wave_size", 1, 32);
  attrs[1] = attr(&a, "amdgpu_wave_size", 1, 64);
  body[0] = s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  prog = program1(&a, kernel(&a, "k", attrs, 2, NULL, 0, s_block(&a, body, 1)));
  expect_reject(&a, prog, "duplicate", "duplicate wave_size rejected");
  arena_destroy(&a);
}

/* amdgpu_wave_size without its integer argument is rejected. */
static void test_reject_wave_size_no_arg(void) {
  Arena a = arena_create(1u << 18);
  Attribute **attrs = (Attribute **)xalloc(&a, sizeof(Attribute *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  attrs[0] = attr(&a, "amdgpu_wave_size", 0, 0); /* no arg */
  body[0] = s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  prog = program1(&a, kernel(&a, "k", attrs, 1, NULL, 0, s_block(&a, body, 1)));
  expect_reject(&a, prog, "requires an integer argument",
                "wave_size missing arg rejected");
  arena_destroy(&a);
}

/* `&&` requires bool operands (mask uses `&`); a mask && mask is rejected. */
static void test_reject_logical_on_mask(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_mask(&a, 32), "m1");
  params[1] = param(&a, ty_mask(&a, 32), "m2");
  /* mask<32> r = m1 && m2;  -> rejected; use & */
  body[0] = s_decl(&a, ty_mask(&a, 32), "r",
                   e_bin(&a, TOK_AMPAMP, e_ident(&a, "m1"), e_ident(&a, "m2")));
  prog = prog_wave(&a, 32, params, 2, body, 1);
  expect_reject(&a, prog, "logical '&&'", "logical-and on masks rejected");
  arena_destroy(&a);
}

/* mask algebra with `&` between two masks is ACCEPTED (the right spelling). */
static void test_accept_mask_algebra(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_mask(&a, 32), "m1");
  params[1] = param(&a, ty_mask(&a, 32), "m2");
  /* mask<32> r = m1 & ~m2; */
  body[0] = s_decl(&a, ty_mask(&a, 32), "r",
                   e_bin(&a, TOK_AMP, e_ident(&a, "m1"),
                         e_unary(&a, TOK_TILDE, e_ident(&a, "m2"))));
  prog = prog_wave(&a, 32, params, 2, body, 1);
  expect_accept(&a, prog, "mask & ~mask accepts");
  {
    TypeRef *rt = (TypeRef *)body[0]->as.decl.init->sema_type;
    CHECK(rt != NULL && rt->kind == TYPE_MASK && rt->width == 32,
          "mask & mask -> mask<32>");
  }
  arena_destroy(&a);
}

/* Destructuring auto [v, t] = load(...) binds a simd and a token. */
static void test_accept_destructure_load(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 3);
  Program *prog;
  Expr **ld;
  const char *names[2];
  names[0] = "xv";
  names[1] = "t";
  params[0] = param(&a, ty_ptr(&a, SCALAR_FLOAT, 0), "x");
  params[1] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_INT32), 32), "i");
  ld = expr_arr(&a, 1);
  ld[0] = e_bin(&a, TOK_PLUS, e_ident(&a, "x"), e_ident(&a, "i"));
  body[0] =
      s_destructure(&a, names, 2, e_call(&a, "load", NULL, 0, ld, 1, NULL));
  /* token s = store(xv, x + i after t);  uses both bindings. */
  {
    Expr **st = expr_arr(&a, 2);
    st[0] = e_ident(&a, "xv");
    st[1] = e_bin(&a, TOK_PLUS, e_ident(&a, "x"), e_ident(&a, "i"));
    body[1] = s_decl(&a, ty_scalar(&a, SCALAR_TOKEN), "s",
                     e_call(&a, "store", NULL, 0, st, 2, e_ident(&a, "t")));
  }
  body[2] = s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  prog = prog_wave(&a, 32, params, 2, body, 3);
  expect_accept(&a, prog, "auto [v,t] = load(...) destructure accepts");
  arena_destroy(&a);
}

/* A bad destructure arity (binding three names) is rejected. */
static void test_reject_destructure_arity(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  Expr **ld;
  const char *names[3];
  names[0] = "a1";
  names[1] = "b1";
  names[2] = "c1";
  params[0] = param(&a, ty_ptr(&a, SCALAR_FLOAT, 0), "x");
  params[1] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_INT32), 32), "i");
  ld = expr_arr(&a, 1);
  ld[0] = e_bin(&a, TOK_PLUS, e_ident(&a, "x"), e_ident(&a, "i"));
  body[0] =
      s_destructure(&a, names, 3, e_call(&a, "load", NULL, 0, ld, 1, NULL));
  prog = prog_wave(&a, 32, params, 2, body, 1);
  expect_reject(&a, prog, "binds exactly two names",
                "3-name destructure rejected");
  arena_destroy(&a);
}

/* An unknown builtin/function name is rejected. */
static void test_reject_unknown_call(void) {
  Arena a = arena_create(1u << 18);
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  body[0] = s_call(&a, e_call(&a, "frobnicate", NULL, 0, NULL, 0, NULL));
  prog = prog_wave(&a, 32, NULL, 0, body, 1);
  expect_reject(&a, prog, "unknown builtin or function",
                "unknown call rejected");
  arena_destroy(&a);
}

/* index_cast bridges sized int <-> index (accepts). */
static void test_accept_index_cast(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  Expr **ar;
  params[0] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");
  ar = expr_arr(&a, 1);
  ar[0] = e_ident(&a, "n");
  /* index ni = index_cast(n); */
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_INDEX), "ni",
                   e_call(&a, "index_cast", NULL, 0, ar, 1, NULL));
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_accept(&a, prog, "index_cast(int)->index accepts");
  arena_destroy(&a);
}

/* mixing index and a sized int in arithmetic is rejected (no implicit
 * convert; use index_cast). */
static void test_reject_index_int_mix(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_INDEX), "ix");
  params[1] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");
  /* index r = ix + n;  -> incompatible element types */
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_INDEX), "r",
                   e_bin(&a, TOK_PLUS, e_ident(&a, "ix"), e_ident(&a, "n")));
  prog = prog_wave(&a, 32, params, 2, body, 1);
  expect_reject(&a, prog, "incompatible operand element types",
                "index + int rejected");
  arena_destroy(&a);
}

/* mixing half and float in arithmetic needs an explicit cast -> rejected. */
static void test_reject_half_float_mix(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_HALF), 32), "h");
  params[1] = param(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "f");
  body[0] = s_decl(&a, ty_simd(&a, ty_scalar(&a, SCALAR_FLOAT), 32), "r",
                   e_bin(&a, TOK_PLUS, e_ident(&a, "h"), e_ident(&a, "f")));
  prog = prog_wave(&a, 32, params, 2, body, 1);
  expect_reject(&a, prog, "incompatible operand element types",
                "half + float rejected");
  arena_destroy(&a);
}

/* int32_t and uint32_t are assignment/operator compatible (signless). */
static void test_accept_signless_int(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, 2 * sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_INT32), "s");
  params[1] = param(&a, ty_scalar(&a, SCALAR_UINT32), "u");
  /* uint32_t r = s + u;  -- same width, signless -> ok */
  body[0] = s_decl(&a, ty_scalar(&a, SCALAR_UINT32), "r",
                   e_bin(&a, TOK_PLUS, e_ident(&a, "s"), e_ident(&a, "u")));
  prog = prog_wave(&a, 32, params, 2, body, 1);
  expect_accept(&a, prog, "int32 + uint32 (signless) accepts");
  arena_destroy(&a);
}

/* A while loop with a uniform bool condition accepts. */
static void test_accept_while_bool(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Stmt **loop_body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_scalar(&a, SCALAR_UINT32), "n");
  loop_body[0] =
      s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  body[0] = s_while(&a, e_bin(&a, TOK_LT, e_int(&a, 0), e_ident(&a, "n")),
                    s_block(&a, loop_body, 1));
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_accept(&a, prog, "while(bool) accepts");
  arena_destroy(&a);
}

/* A while loop with a mask condition is rejected (uniform only). */
static void test_reject_while_mask(void) {
  Arena a = arena_create(1u << 18);
  Param **params = (Param **)xalloc(&a, sizeof(Param *));
  Stmt **body = stmt_arr(&a, 1);
  Stmt **loop_body = stmt_arr(&a, 1);
  Program *prog;
  params[0] = param(&a, ty_mask(&a, 32), "m");
  loop_body[0] =
      s_call(&a, e_call(&a, "wave_id_in_grid", NULL, 0, NULL, 0, NULL));
  body[0] = s_while(&a, e_ident(&a, "m"), s_block(&a, loop_body, 1));
  prog = prog_wave(&a, 32, params, 1, body, 1);
  expect_reject(&a, prog, "'while' requires a uniform bool",
                "while(mask) rejected");
  arena_destroy(&a);
}

/* fragment type shape is checked by sema. */
static void test_reject_fragment(void) {
  Arena a = arena_create(1u << 18);
  TypeRef *elem = ty_scalar(&a, SCALAR_HALF);
  TypeRef *frag = (TypeRef *)xalloc(&a, sizeof(TypeRef));
  Stmt **body = stmt_arr(&a, 1);
  Program *prog;
  frag->kind = TYPE_FRAGMENT;
  frag->element = elem;
  frag->fragment_role = 3;
  frag->fragment_rows = 16;
  frag->fragment_cols = 16;
  frag->width = 32;
  frag->fragment_registers = 8;
  frag->span = span0();
  body[0] = s_decl(&a, frag, "fr", e_int(&a, 0));
  prog = prog_wave(&a, 32, NULL, 0, body, 1);
  expect_reject(&a, prog, "fragment role must be 0, 1, or 2",
                "invalid fragment role rejected");
  arena_destroy(&a);
}

/*===----------------------------------------------------------------===*/
/* Source-driven integration tests (lex -> parse -> sema -> typed dump)  */
/*===----------------------------------------------------------------===*/

/* Run the full front on `src`: lex, parse, sema. Writes the sema result
 * (accept=1) through *out_ok and, when the parse produced an AST, the
 * include_types astdump through *out_dump (else NULL). Returns 1 if the
 * source lexed+parsed cleanly enough to run sema, 0 if it failed before
 * sema (a hard parse/lex error). All allocations come from `a`. */
static int run_front(Arena *a, const char *src, int *out_ok,
                     const char **out_dump) {
  LexContext lx;
  TokenArray toks;
  ParseContext px;
  Program *prog;
  DiagList diags;
  SemaContext sx;
  AstDumpOptions opts;

  *out_ok = 0;
  *out_dump = NULL;
  diag_list_init(&diags, a);

  lx.src = src;
  lx.src_len = strlen(src);
  lx.arena = a;
  lx.diags = &diags;
  toks = lex_tokenize(&lx);

  parse_context_init(&px, toks.tokens, toks.count, src, lx.src_len, a, &diags);
  prog = parse_program(&px);
  if (prog == NULL || diag_has_errors(&diags)) {
    /* Did not reach a clean AST; report the parse failure to the caller. */
    if (prog != NULL) {
      opts.include_types = 0;
      opts.indent_width = 2;
      *out_dump = astdump_program(a, prog, &opts);
    }
    return 0;
  }

  sema_context_init(&sx, a, &diags);
  *out_ok = sema_check(&sx, prog);

  opts.include_types = 1;
  opts.indent_width = 2;
  *out_dump = astdump_program(a, prog, &opts);
  return 1;
}

/* The saxpy source accepts and its key expressions get the right types. */
static void test_src_saxpy(void) {
  Arena a = arena_create(1u << 21);
  static const char *SRC =
      "kernel [[amdgpu_wave_size(32)]]\n"
      "void saxpy(float *x, float *y, float a, uint32_t n) {\n"
      "  simd<uint32_t, 32> lane = lane_id<32>();\n"
      "  uint32_t           wave = wave_id_in_grid();\n"
      "  simd<uint32_t, 32> i    = wave * 32 + lane;\n"
      "  mask<32>           active = i < n;\n"
      "  where (active) {\n"
      "    simd<float, 32> xv = load(x + i);\n"
      "    simd<float, 32> yv = load(y + i);\n"
      "    store(a * xv + yv, y + i);\n"
      "  }\n"
      "}\n";
  int ok;
  const char *dump;
  int reached = run_front(&a, SRC, &ok, &dump);
  CHECK(reached, "saxpy source lexes+parses cleanly");
  CHECK(ok, "saxpy source passes sema");
  if (dump != NULL) {
    /* i < n -> mask<32>; the scalar*scalar+simd add -> simd<...,32>. */
    CHECK(strstr(dump, "[type (mask 32)]") != NULL,
          "a compare on simd resolved to mask<32> in the typed dump");
    CHECK(strstr(dump, "(simd uint32_t 32)") != NULL,
          "simd<uint32_t,32> appears as a resolved type");
  } else {
    CHECK(0, "saxpy produced a typed dump");
  }
  arena_destroy(&a);
}

/* A mask in an `if` is rejected when driven from real source. */
static void test_src_mask_in_if(void) {
  Arena a = arena_create(1u << 20);
  static const char *SRC = "kernel [[amdgpu_wave_size(32)]]\n"
                           "void k(uint32_t n) {\n"
                           "  simd<uint32_t,32> i = lane_id<32>();\n"
                           "  mask<32> m = i < n;\n"
                           "  if (m) {\n"
                           "    uint32_t z = n;\n"
                           "  }\n"
                           "}\n";
  int ok;
  const char *dump;
  int reached = run_front(&a, SRC, &ok, &dump);
  CHECK(reached, "mask-in-if source parses");
  CHECK(reached && !ok, "mask-in-if source is rejected by sema");
  arena_destroy(&a);
}

/* A bool in a `where` is rejected from real source. */
static void test_src_bool_in_where(void) {
  Arena a = arena_create(1u << 20);
  static const char *SRC = "kernel [[amdgpu_wave_size(32)]]\n"
                           "void k(uint32_t n) {\n"
                           "  bool b = n < 5;\n"
                           "  where (b) {\n"
                           "    uint32_t z = n;\n"
                           "  }\n"
                           "}\n";
  int ok;
  const char *dump;
  int reached = run_front(&a, SRC, &ok, &dump);
  CHECK(reached, "bool-in-where source parses");
  CHECK(reached && !ok, "bool-in-where source is rejected by sema");
  arena_destroy(&a);
}

/* shared on a non-pointer is rejected from real source. */
static void test_src_shared_nonpointer(void) {
  Arena a = arena_create(1u << 20);
  static const char *SRC = "kernel [[amdgpu_wave_size(32)]]\n"
                           "void k() {\n"
                           "  shared half lds = 0;\n"
                           "}\n";
  int ok;
  const char *dump;
  int reached = run_front(&a, SRC, &ok, &dump);
  /* The parser accepts the grammar (shared half is a valid type form);
   * sema rejects it. If the parser instead rejects it syntactically that
   * is also a valid rejection, so accept either pre-sema or sema failure. */
  if (reached)
    CHECK(!ok, "shared non-pointer source is rejected by sema");
  else
    CHECK(1, "shared non-pointer rejected before sema (also acceptable)");
  arena_destroy(&a);
}

/* W != N is rejected from real source (simd<...,64> in a wave-32 kernel). */
static void test_src_width_mismatch(void) {
  Arena a = arena_create(1u << 20);
  static const char *SRC = "kernel [[amdgpu_wave_size(32)]]\n"
                           "void k() {\n"
                           "  simd<uint32_t, 64> v = 0;\n"
                           "}\n";
  int ok;
  const char *dump;
  int reached = run_front(&a, SRC, &ok, &dump);
  CHECK(reached, "width-mismatch source parses");
  CHECK(reached && !ok, "simd width != N rejected by sema from source");
  arena_destroy(&a);
}

/* An unknown attribute is rejected from real source. */
static void test_src_unknown_attribute(void) {
  Arena a = arena_create(1u << 20);
  static const char *SRC =
      "kernel [[amdgpu_wave_size(32)]] [[amdgpu_unroll(4)]]\n"
      "void k() {\n"
      "  uint32_t w = wave_id_in_grid();\n"
      "}\n";
  int ok;
  const char *dump;
  int reached = run_front(&a, SRC, &ok, &dump);
  CHECK(reached, "unknown-attr source parses");
  CHECK(reached && !ok, "unknown attribute rejected by sema from source");
  arena_destroy(&a);
}

/* Implicit simd->scalar is rejected from real source. */
static void test_src_implicit_simd_to_scalar(void) {
  Arena a = arena_create(1u << 20);
  static const char *SRC = "kernel [[amdgpu_wave_size(32)]]\n"
                           "void k() {\n"
                           "  simd<float,32> v = cast<float>(lane_id<32>());\n"
                           "  float s = v;\n"
                           "}\n";
  int ok;
  const char *dump;
  int reached = run_front(&a, SRC, &ok, &dump);
  CHECK(reached, "simd->scalar source parses");
  CHECK(reached && !ok, "implicit simd->scalar rejected by sema from source");
  arena_destroy(&a);
}

/*===----------------------------------------------------------------===*/
/* main                                                                  */
/*===----------------------------------------------------------------===*/

int main(void) {
  g_failures = 0;

  /* ACCEPT */
  test_accept_saxpy();
  test_accept_broadcast();
  test_accept_scalar_compare_if();
  test_accept_for_carry();
  test_accept_lds_roundtrip();
  test_accept_where_otherwise();
  test_accept_cast();
  test_accept_cast_policies();
  test_accept_mask_algebra();
  test_accept_destructure_load();
  test_accept_index_cast();
  test_accept_signless_int();
  test_accept_while_bool();
  test_accept_branch_merge_carry();
  test_accept_compound_assign();

  /* REJECT (each with its required diagnostic) */
  test_reject_mask_in_if();
  test_reject_bool_in_where();
  test_reject_shared_nonpointer();
  test_reject_width_mismatch();
  test_reject_lane_id_width();
  test_reject_use_before_def();
  test_reject_use_before_def_forward();
  test_reject_implicit_simd_to_scalar();
  test_reject_unknown_attribute();
  test_reject_missing_wave_size();
  test_reject_simd_compare_in_if();
  test_reject_for_iv_type();
  test_reject_shared_param();
  test_reject_store_mismatch();
  test_reject_store_bad_operands();
  test_reject_void_in_value();
  test_reject_int_in_if();
  test_reject_duplicate_wave_size();
  test_reject_wave_size_no_arg();
  test_reject_logical_on_mask();
  test_reject_destructure_arity();
  test_reject_unknown_call();
  test_reject_index_int_mix();
  test_reject_half_float_mix();
  test_reject_while_mask();
  test_reject_fragment();

  /* Source-driven integration (lex -> parse -> sema -> typed dump). */
  test_src_saxpy();
  test_src_mask_in_if();
  test_src_bool_in_where();
  test_src_shared_nonpointer();
  test_src_width_mismatch();
  test_src_unknown_attribute();
  test_src_implicit_simd_to_scalar();

  if (g_failures != 0) {
    fprintf(stderr, "sema_test: %d check(s) FAILED\n", g_failures);
    return EXIT_FAILURE;
  }
  printf("sema_test: all checks passed\n");
  return EXIT_SUCCESS;
}
