//===- lower_test.cpp - lowering-stage interface test ------------*- C++
//-*-===//
//
// Tests the lowering bridge at ITS OWN interface (AST in -> MLIR text out),
// independent of the lexer/parser/sema. The AST is built by hand here, so a
// regression in lowering is caught without the rest of the front. This is the
// per-stage test the Implementation rules require for stage 4.
//
// It deliberately does NOT route through the parser: this exercises the SAME
// data structure (ast.h) the parser will produce, fed directly. A second
// "overfit probe" feeds a permuted saxpy and asserts the output differs from
// the first -- proving lowering derives IR from the AST, not from a canned
// template.
//
//===----------------------------------------------------------------------===//

// The front headers declare C-linkage functions; this test is C++, so pull
// them in under extern "C" to match the libwavefront archive's symbols.
extern "C" {
#include "arena.h"
#include "ast.h"
#include "diag.h"
#include "lower.h"
}

#include <cstdio>
#include <cstdlib>
#include <cstring>

// --- tiny arena helpers for building the AST ------------------------------

namespace {

Arena g_arena;
DiagList g_diags;

template <typename T> T *make() {
  return static_cast<T *>(arena_alloc(&g_arena, sizeof(T), sizeof(void *)));
}

SourceSpan noSpan() {
  SourceSpan s;
  s.offset = 0;
  s.len = 0;
  s.line = 1;
  s.col = 1;
  return s;
}

TypeRef *scalarType(ScalarKind k, int isPtr, int isShared) {
  TypeRef *t = make<TypeRef>();
  memset(t, 0, sizeof(*t));
  t->kind = TYPE_SCALAR;
  t->scalar = k;
  t->is_pointer = isPtr;
  t->is_shared = isShared;
  t->span = noSpan();
  return t;
}

TypeRef *simdType(TypeRef *elem, uint64_t width) {
  TypeRef *t = make<TypeRef>();
  memset(t, 0, sizeof(*t));
  t->kind = TYPE_SIMD;
  t->element = elem;
  t->width = width;
  t->span = noSpan();
  return t;
}

TypeRef *maskType(uint64_t width) {
  TypeRef *t = make<TypeRef>();
  memset(t, 0, sizeof(*t));
  t->kind = TYPE_MASK;
  t->width = width;
  t->span = noSpan();
  return t;
}

Expr *mkExpr(ExprKind k, TypeRef *semaTy) {
  Expr *e = make<Expr>();
  memset(e, 0, sizeof(*e));
  e->kind = k;
  e->span = noSpan();
  e->sema_type = semaTy;
  return e;
}

Expr *ident(const char *name, TypeRef *semaTy) {
  Expr *e = mkExpr(EXPR_IDENT, semaTy);
  e->as.ident.name = name;
  e->as.ident.name_len = (uint32_t)strlen(name);
  return e;
}

Expr *intLit(uint64_t v, TypeRef *semaTy) {
  Expr *e = mkExpr(EXPR_INT_LIT, semaTy);
  e->as.int_lit.value = v;
  return e;
}

Expr *binary(TokenKind op, Expr *lhs, Expr *rhs, TypeRef *semaTy) {
  Expr *e = mkExpr(EXPR_BINARY, semaTy);
  e->as.binary.op = op;
  e->as.binary.lhs = lhs;
  e->as.binary.rhs = rhs;
  return e;
}

// call: callee ident, optional one int garg, value args.
Expr *call(const char *callee, int hasGarg, uint64_t garg, Expr **args,
           size_t nargs, TypeRef *semaTy) {
  Expr *e = mkExpr(EXPR_CALL, semaTy);
  e->as.call.callee = ident(callee, nullptr);
  if (hasGarg) {
    GArg *g = make<GArg>();
    memset(g, 0, sizeof(*g));
    g->kind = GARG_INT;
    g->int_value = garg;
    g->span = noSpan();
    e->as.call.gargs = g;
    e->as.call.garg_count = 1;
  }
  if (nargs) {
    Expr **arr = static_cast<Expr **>(
        arena_alloc(&g_arena, sizeof(Expr *) * nargs, sizeof(void *)));
    for (size_t i = 0; i < nargs; ++i)
      arr[i] = args[i];
    e->as.call.args = arr;
    e->as.call.arg_count = nargs;
  }
  return e;
}

BoundName boundName(const char *name) {
  BoundName b;
  b.name = name;
  b.name_len = (uint32_t)strlen(name);
  b.span = noSpan();
  return b;
}

Stmt *mkStmt(StmtKind k) {
  Stmt *s = make<Stmt>();
  memset(s, 0, sizeof(*s));
  s->kind = k;
  s->span = noSpan();
  return s;
}

Stmt *declStmt(TypeRef *ty, const char *name, Expr *init) {
  Stmt *s = mkStmt(STMT_DECL);
  s->as.decl.type = ty;
  s->as.decl.name = boundName(name);
  s->as.decl.init = init;
  return s;
}

Stmt *callStmt(Expr *c) {
  Stmt *s = mkStmt(STMT_CALL);
  s->as.call.call = c;
  return s;
}

Stmt *block(Stmt **stmts, size_t n) {
  Stmt *s = mkStmt(STMT_BLOCK);
  Stmt **arr = static_cast<Stmt **>(
      arena_alloc(&g_arena, sizeof(Stmt *) * (n ? n : 1), sizeof(void *)));
  for (size_t i = 0; i < n; ++i)
    arr[i] = stmts[i];
  s->as.block.stmts = arr;
  s->as.block.stmt_count = n;
  return s;
}

Stmt *whereStmt(Expr *cond, Stmt *thenBlk, Stmt *elseBlk) {
  Stmt *s = mkStmt(STMT_WHERE);
  s->as.cond.cond = cond;
  s->as.cond.then_block = thenBlk;
  s->as.cond.else_block = elseBlk;
  return s;
}

Param *param(TypeRef *ty, const char *name);
Program *makeProgram(const char *kname, Param **params, size_t nparams,
                     Stmt *bodyBlk, const char *attrName, uint64_t attrArg);

struct SaxpyTypes {
  TypeRef *f32;
  TypeRef *u32;
  TypeRef *fptr;
  TypeRef *simdU32;
  TypeRef *simdF32;
  TypeRef *simdFPtr;
  TypeRef *mask32;
};

SaxpyTypes makeSaxpyTypes() {
  SaxpyTypes t;
  t.f32 = scalarType(SCALAR_FLOAT, 0, 0);
  t.u32 = scalarType(SCALAR_UINT32, 0, 0);
  t.fptr = scalarType(SCALAR_FLOAT, 1, 0);
  t.simdU32 = simdType(scalarType(SCALAR_UINT32, 0, 0), 32);
  t.simdF32 = simdType(scalarType(SCALAR_FLOAT, 0, 0), 32);
  t.simdFPtr = simdType(t.fptr, 32);
  t.mask32 = maskType(32);
  return t;
}

Stmt *buildSaxpyWhere(const SaxpyTypes &t, bool swapLoads) {
  Expr *xptrRef = ident("xptr", t.simdFPtr);
  Expr *yptrRef = ident("yptr", t.simdFPtr);
  Expr *loadX = call("load", 0, 0, &xptrRef, 1, t.simdF32);
  Expr *loadY = call("load", 0, 0, &yptrRef, 1, t.simdF32);
  Stmt *sXv = declStmt(t.simdF32, "xv", loadX);
  Stmt *sYv = declStmt(t.simdF32, "yv", loadY);
  Expr *axv =
      binary(TOK_STAR, ident("a", t.f32), ident("xv", t.simdF32), t.simdF32);
  Expr *res = binary(TOK_PLUS, axv, ident("yv", t.simdF32), t.simdF32);
  Expr *storeArgs[2] = {res, ident("yptr", t.simdFPtr)};
  Stmt *sStore = callStmt(call("store", 0, 0, storeArgs, 2, nullptr));

  Stmt *bodyStmts[3] = {sXv, sYv, sStore};
  if (swapLoads) {
    bodyStmts[0] = sYv;
    bodyStmts[1] = sXv;
  }
  return whereStmt(ident("active", t.mask32), block(bodyStmts, 3), nullptr);
}

Stmt *buildSaxpyBody(const SaxpyTypes &t, bool swapLoads) {
  Stmt *sLane = declStmt(t.simdU32, "lane",
                         call("lane_id", 1, 32, nullptr, 0, t.simdU32));
  Stmt *sWave =
      declStmt(t.u32, "wave", call("workgroup_id", 1, 0, nullptr, 0, t.u32));
  Expr *mul = binary(TOK_STAR, ident("wave", t.u32), intLit(32, t.u32), t.u32);
  Expr *add = binary(TOK_PLUS, mul, ident("lane", t.simdU32), t.simdU32);
  Stmt *sI = declStmt(t.simdU32, "i", add);
  Expr *cmp =
      binary(TOK_LT, ident("i", t.simdU32), ident("n", t.u32), t.mask32);
  Stmt *sActive = declStmt(t.mask32, "active", cmp);
  Expr *xi =
      binary(TOK_PLUS, ident("x", t.fptr), ident("i", t.simdU32), t.simdFPtr);
  Expr *yi =
      binary(TOK_PLUS, ident("y", t.fptr), ident("i", t.simdU32), t.simdFPtr);
  Stmt *sXptr = declStmt(t.simdFPtr, "xptr", xi);
  Stmt *sYptr = declStmt(t.simdFPtr, "yptr", yi);
  Stmt *top[7] = {
      sLane, sWave, sI, sActive, sXptr, sYptr, buildSaxpyWhere(t, swapLoads)};
  return block(top, 7);
}

Program *buildSaxpy(bool swapLoads) {
  SaxpyTypes t = makeSaxpyTypes();
  Param *ps[4] = {param(t.fptr, "x"), param(t.fptr, "y"), param(t.f32, "a"),
                  param(t.u32, "n")};
  return makeProgram("saxpy", ps, 4, buildSaxpyBody(t, swapLoads), nullptr, 0);
}

// --- extra builders for the other goldens ---------------------------------

Expr *floatLit(double v, TypeRef *semaTy) {
  Expr *e = mkExpr(EXPR_FLOAT_LIT, semaTy);
  e->as.float_lit.value = v;
  e->as.float_lit.has_f_suffix = 1;
  return e;
}

// call with one TYPE generic arg (cast<T>, shared_memory_base<T>).
Expr *callTy(const char *callee, TypeRef *garg, Expr **args, size_t nargs,
             TypeRef *semaTy) {
  Expr *e = mkExpr(EXPR_CALL, semaTy);
  e->as.call.callee = ident(callee, nullptr);
  if (garg) {
    GArg *g = make<GArg>();
    memset(g, 0, sizeof(*g));
    g->kind = GARG_TYPE;
    g->type = garg;
    g->span = noSpan();
    e->as.call.gargs = g;
    e->as.call.garg_count = 1;
  }
  if (nargs) {
    Expr **arr = static_cast<Expr **>(
        arena_alloc(&g_arena, sizeof(Expr *) * nargs, sizeof(void *)));
    for (size_t i = 0; i < nargs; ++i)
      arr[i] = args[i];
    e->as.call.args = arr;
    e->as.call.arg_count = nargs;
  }
  return e;
}

// call(...) with a trailing `after dep`.
Expr *callAfter(const char *callee, Expr **args, size_t nargs, Expr *dep,
                TypeRef *semaTy) {
  Expr *e = call(callee, 0, 0, args, nargs, semaTy);
  e->as.call.dep = dep;
  e->as.call.has_dep = 1;
  return e;
}

Stmt *assignStmt(const char *name, TokenKind op, Expr *value) {
  Stmt *s = mkStmt(STMT_ASSIGN);
  s->as.assign.target = boundName(name);
  s->as.assign.op = op;
  s->as.assign.value = value;
  return s;
}

Stmt *forStmt(TypeRef *ivTy, const char *iv, Expr *lb, Expr *ub, Expr *step,
              Stmt *bodyBlk) {
  Stmt *s = mkStmt(STMT_FOR);
  s->as.for_.iv_type = ivTy;
  s->as.for_.iv_name = boundName(iv);
  s->as.for_.lb = lb;
  s->as.for_.ub = ub;
  s->as.for_.step = step;
  s->as.for_.body = bodyBlk;
  return s;
}

Stmt *ifStmt(Expr *cond, Stmt *thenBlk, Stmt *elseBlk) {
  Stmt *s = mkStmt(STMT_IF);
  s->as.cond.cond = cond;
  s->as.cond.then_block = thenBlk;
  s->as.cond.else_block = elseBlk;
  return s;
}

Stmt *destructure2(const char *a, const char *b, Expr *init) {
  Stmt *s = mkStmt(STMT_DESTRUCTURE);
  BoundName *names = static_cast<BoundName *>(
      arena_alloc(&g_arena, sizeof(BoundName) * 2, sizeof(void *)));
  names[0] = boundName(a);
  names[1] = boundName(b);
  s->as.destructure.names = names;
  s->as.destructure.name_count = 2;
  s->as.destructure.init = init;
  return s;
}

Param *param(TypeRef *ty, const char *name) {
  Param *p = make<Param>();
  memset(p, 0, sizeof(*p));
  p->type = ty;
  p->name = boundName(name);
  p->span = noSpan();
  return p;
}

// Assemble a one-kernel Program. `attrName`/`attrArg` optional ([[..]]).
Program *makeProgram(const char *kname, Param **params, size_t nparams,
                     Stmt *bodyBlk, const char *attrName, uint64_t attrArg) {
  Param **parr = nullptr;
  if (nparams) {
    parr = static_cast<Param **>(
        arena_alloc(&g_arena, sizeof(Param *) * nparams, sizeof(void *)));
    for (size_t i = 0; i < nparams; ++i)
      parr[i] = params[i];
  }
  Kernel *k = make<Kernel>();
  memset(k, 0, sizeof(*k));
  k->name = boundName(kname);
  k->params = parr;
  k->param_count = nparams;
  if (attrName) {
    Attribute *a = make<Attribute>();
    memset(a, 0, sizeof(*a));
    a->name = attrName;
    a->name_len = (uint32_t)strlen(attrName);
    a->has_arg = 1;
    a->arg = attrArg;
    a->span = noSpan();
    Attribute **aa = static_cast<Attribute **>(
        arena_alloc(&g_arena, sizeof(Attribute *), sizeof(void *)));
    aa[0] = a;
    k->attrs = aa;
    k->attr_count = 1;
  }
  k->body = bodyBlk;
  k->span = noSpan();
  Kernel **kernels = static_cast<Kernel **>(
      arena_alloc(&g_arena, sizeof(Kernel *), sizeof(void *)));
  kernels[0] = k;
  Program *p = make<Program>();
  memset(p, 0, sizeof(*p));
  p->kernels = kernels;
  p->kernel_count = 1;
  p->span = noSpan();
  return p;
}

TypeRef *iptr() { return scalarType(SCALAR_INT32, 1, 0); } // int32_t*

// reduce_sum: scf.for over a simd<f32,32> accumulator (mutable local carry).
// Mirrors gen_examples.py: c32 is bound once before the loop and reused, so
// faithful (non-hoisting) lowering keeps the constant out of the loop body.
Program *buildReduceSum() {
  TypeRef *i32 = scalarType(SCALAR_INT32, 0, 0);
  TypeRef *fptr = scalarType(SCALAR_FLOAT, 1, 0);
  TypeRef *simdI32 = simdType(scalarType(SCALAR_INT32, 0, 0), 32);
  TypeRef *simdF32 = simdType(scalarType(SCALAR_FLOAT, 0, 0), 32);
  TypeRef *simdFPtr = simdType(fptr, 32);

  Stmt *sLane =
      declStmt(simdI32, "lane", call("lane_id", 1, 32, nullptr, 0, simdI32));
  // c32 = 32; (bound before loop, reused as k*c32)
  Stmt *sC32 = declStmt(i32, "c32", intLit(32, i32));
  // acc = 0.0f;  (scalar float broadcast to simd by sema -> splat in lowering)
  Stmt *sAcc = declStmt(simdF32, "acc", floatLit(0.0, simdF32));

  // for int32_t k in 0..n { i = k*c32 + lane; ptr = a + i; v = load(ptr); acc =
  // acc + v; }
  Expr *mul = binary(TOK_STAR, ident("k", i32), ident("c32", i32), i32);
  Expr *add = binary(TOK_PLUS, mul, ident("lane", simdI32), simdI32);
  Stmt *sI = declStmt(simdI32, "i", add);
  Expr *ai = binary(TOK_PLUS, ident("a", fptr), ident("i", simdI32), simdFPtr);
  Stmt *sPtr = declStmt(simdFPtr, "ptr", ai);
  Expr *ldArg = ident("ptr", simdFPtr);
  Stmt *sV = declStmt(simdF32, "v", call("load", 0, 0, &ldArg, 1, simdF32));
  Expr *accv =
      binary(TOK_PLUS, ident("acc", simdF32), ident("v", simdF32), simdF32);
  Stmt *sAccUpd = assignStmt("acc", TOK_ASSIGN, accv);
  Stmt *forStmts[4] = {sI, sPtr, sV, sAccUpd};
  Stmt *forBody = block(forStmts, 4);
  Stmt *sFor =
      forStmt(i32, "k", intLit(0, i32), ident("n", i32), nullptr, forBody);

  // store(acc, a + lane);
  Expr *al =
      binary(TOK_PLUS, ident("a", fptr), ident("lane", simdI32), simdFPtr);
  Stmt *sPtr2 = declStmt(simdFPtr, "optr", al);
  Expr *stArgs[2] = {ident("acc", simdF32), ident("optr", simdFPtr)};
  Stmt *sStore = callStmt(call("store", 0, 0, stArgs, 2, nullptr));

  Stmt *top[6] = {sLane, sC32, sAcc, sFor, sPtr2, sStore};
  Stmt *body = block(top, 6);
  Param *ps[2] = {param(fptr, "a"), param(i32, "n")};
  return makeProgram("reduce_sum", ps, 2, body, nullptr, 0);
}

// where_carry: result-bearing wave.where with a then-only carried local.
// NOTE: faithful lowering synthesizes an `otherwise` arm yielding the
// carried-in value (CFrontendDesign.md "Control flow": a then-only where
// leaves inactive lanes unspecified). The golden omits that arm, so this is a
// documented structural superset rather than a byte match.
Program *buildWhereCarry() {
  TypeRef *u32 = scalarType(SCALAR_UINT32, 0, 0); // unsigned -> cmpi ult
  TypeRef *simdI32 = simdType(scalarType(SCALAR_UINT32, 0, 0), 32);
  TypeRef *mask32 = maskType(32);
  TypeRef *i32ptr = iptr();
  TypeRef *simdIPtr = simdType(i32ptr, 32);

  Stmt *sLane =
      declStmt(simdI32, "lane", call("lane_id", 1, 32, nullptr, 0, simdI32));
  // r initialized to a dominating value; reassigned in the then arm.
  Stmt *sR = declStmt(simdI32, "r", ident("lane", simdI32));
  Expr *cmp = binary(TOK_LT, ident("lane", simdI32), ident("n", u32), mask32);
  Stmt *sActive = declStmt(mask32, "active", cmp);
  // where (active) { r = lane; }   -> result where, otherwise yields carried-in
  Stmt *rAssign = assignStmt("r", TOK_ASSIGN, ident("lane", simdI32));
  Stmt *wbStmts[1] = {rAssign};
  Stmt *wb = block(wbStmts, 1);
  Stmt *sWhere = whereStmt(ident("active", mask32), wb, nullptr);
  // store(r, p + lane);
  Expr *pl =
      binary(TOK_PLUS, ident("p", i32ptr), ident("lane", simdI32), simdIPtr);
  Stmt *sPtr = declStmt(simdIPtr, "optr", pl);
  Expr *st[2] = {ident("r", simdI32), ident("optr", simdIPtr)};
  Stmt *sStore = callStmt(call("store", 0, 0, st, 2, nullptr));

  Stmt *all[6] = {sLane, sR, sActive, sWhere, sPtr, sStore};
  Stmt *body = block(all, 6);
  Param *ps[2] = {param(i32ptr, "p"), param(u32, "n")};
  return makeProgram("where_carry", ps, 2, body, nullptr, 0);
}

// where_otherwise: result where with an explicit otherwise arm.
Program *buildWhereOtherwise() {
  TypeRef *u32 = scalarType(SCALAR_UINT32, 0, 0); // unsigned -> cmpi ult
  TypeRef *simdI32 = simdType(scalarType(SCALAR_UINT32, 0, 0), 32);
  TypeRef *mask32 = maskType(32);
  TypeRef *i32ptr = iptr();
  TypeRef *simdIPtr = simdType(i32ptr, 32);

  Stmt *sLane =
      declStmt(simdI32, "lane", call("lane_id", 1, 32, nullptr, 0, simdI32));
  Stmt *sR = declStmt(simdI32, "r", ident("lane", simdI32));
  Expr *cmp = binary(TOK_LT, ident("lane", simdI32), ident("n", u32), mask32);
  Stmt *sActive = declStmt(mask32, "active", cmp);
  // where (active) { r = lane; } otherwise { r = 0; }
  Stmt *rThen = assignStmt("r", TOK_ASSIGN, ident("lane", simdI32));
  Stmt *thenStmts[1] = {rThen};
  Stmt *thenB = block(thenStmts, 1);
  Stmt *rElse = assignStmt("r", TOK_ASSIGN, intLit(0, simdI32));
  Stmt *elseStmts[1] = {rElse};
  Stmt *elseB = block(elseStmts, 1);
  Stmt *sWhere = whereStmt(ident("active", mask32), thenB, elseB);
  Expr *pl =
      binary(TOK_PLUS, ident("p", i32ptr), ident("lane", simdI32), simdIPtr);
  Stmt *sPtr = declStmt(simdIPtr, "optr", pl);
  Expr *st[2] = {ident("r", simdI32), ident("optr", simdIPtr)};
  Stmt *sStore = callStmt(call("store", 0, 0, st, 2, nullptr));

  Stmt *all[6] = {sLane, sR, sActive, sWhere, sPtr, sStore};
  Stmt *body = block(all, 6);
  Param *ps[2] = {param(i32ptr, "p"), param(u32, "n")};
  return makeProgram("where_otherwise", ps, 2, body, nullptr, 0);
}

// uniform_if_else: scf.if on a uniform bool (arith.cmpi), result carry.
Program *buildUniformIfElse() {
  TypeRef *u32 = scalarType(SCALAR_UINT32, 0, 0); // unsigned -> cmpi ult
  TypeRef *boolT = scalarType(SCALAR_BOOL, 0, 0);
  TypeRef *simdI32 = simdType(scalarType(SCALAR_UINT32, 0, 0), 32);
  TypeRef *i32ptr = iptr();
  TypeRef *simdIPtr = simdType(i32ptr, 32);

  // c = n < 64; (uniform bool)
  Expr *cmp = binary(TOK_LT, ident("n", u32), intLit(64, u32), boolT);
  Stmt *sC = declStmt(boolT, "c", cmp);
  Stmt *sLane =
      declStmt(simdI32, "lane", call("lane_id", 1, 32, nullptr, 0, simdI32));
  Stmt *sR = declStmt(simdI32, "r", ident("lane", simdI32));
  // if (c) { r = lane; } else { r = 0; }
  Stmt *rThen = assignStmt("r", TOK_ASSIGN, ident("lane", simdI32));
  Stmt *tS[1] = {rThen};
  Stmt *thenB = block(tS, 1);
  Stmt *rElse = assignStmt("r", TOK_ASSIGN, intLit(0, simdI32));
  Stmt *eS[1] = {rElse};
  Stmt *elseB = block(eS, 1);
  Stmt *sIf = ifStmt(ident("c", boolT), thenB, elseB);
  Expr *pl =
      binary(TOK_PLUS, ident("p", i32ptr), ident("lane", simdI32), simdIPtr);
  Stmt *sPtr = declStmt(simdIPtr, "optr", pl);
  Expr *st[2] = {ident("r", simdI32), ident("optr", simdIPtr)};
  Stmt *sStore = callStmt(call("store", 0, 0, st, 2, nullptr));

  Stmt *all[6] = {sC, sLane, sR, sIf, sPtr, sStore};
  Stmt *body = block(all, 6);
  Param *ps[2] = {param(i32ptr, "p"), param(u32, "n")};
  return makeProgram("uniform_if_else", ps, 2, body, nullptr, 0);
}

// cast_f32_f16: wave.cast fpconvert (no policy).
Program *buildCastF32F16() {
  TypeRef *f32 = scalarType(SCALAR_FLOAT, 0, 0);
  TypeRef *simdF32 = simdType(scalarType(SCALAR_FLOAT, 0, 0), 32);
  TypeRef *halfT = scalarType(SCALAR_HALF, 0, 0);
  TypeRef *simdF16 = simdType(scalarType(SCALAR_HALF, 0, 0), 32);

  // v = 1.0f; (splat to simd<f32>)
  Stmt *sV = declStmt(simdF32, "v", floatLit(1.0, simdF32));
  // h = cast<half>(v);
  Expr *vArg = ident("v", simdF32);
  Stmt *sH = declStmt(simdF16, "h", callTy("cast", halfT, &vArg, 1, simdF16));
  (void)f32;
  Stmt *all[2] = {sV, sH};
  Stmt *body = block(all, 2);
  return makeProgram("cast_f32_f16", nullptr, 0, body, nullptr, 0);
}

// lds_roundtrip: LDS token threading (store after, barrier, load after).
Program *buildLdsRoundtrip() {
  TypeRef *fptr = scalarType(SCALAR_FLOAT, 1, 0);
  TypeRef *simdI32 = simdType(scalarType(SCALAR_INT32, 0, 0), 32);
  TypeRef *simdF32 = simdType(scalarType(SCALAR_FLOAT, 0, 0), 32);
  TypeRef *simdFPtr = simdType(fptr, 32);
  TypeRef *sharedFptr = scalarType(SCALAR_FLOAT, 1, 1); // shared float*
  TypeRef *simdSharedPtr = simdType(sharedFptr, 32);
  TypeRef *tokenT = scalarType(SCALAR_TOKEN, 0, 0);

  Stmt *sLane =
      declStmt(simdI32, "lane", call("lane_id", 1, 32, nullptr, 0, simdI32));
  Expr *gl =
      binary(TOK_PLUS, ident("g", fptr), ident("lane", simdI32), simdFPtr);
  Stmt *sGptr = declStmt(simdFPtr, "gptr", gl);
  // lds = shared_memory_base<float>();
  Stmt *sLds =
      declStmt(sharedFptr, "lds",
               callTy("shared_memory_base", scalarType(SCALAR_FLOAT, 0, 0),
                      nullptr, 0, sharedFptr));
  Expr *ll = binary(TOK_PLUS, ident("lds", sharedFptr), ident("lane", simdI32),
                    simdSharedPtr);
  Stmt *sLptr = declStmt(simdSharedPtr, "lptr", ll);
  // auto [v, t] = load(gptr);
  Expr *ldArg = ident("gptr", simdFPtr);
  Stmt *sLoad = destructure2("v", "t", call("load", 0, 0, &ldArg, 1, simdF32));
  // s = store(v, lptr after t);
  Expr *stArgs[2] = {ident("v", simdF32), ident("lptr", simdSharedPtr)};
  Stmt *sStore = declStmt(
      tokenT, "s", callAfter("store", stArgs, 2, ident("t", tokenT), tokenT));
  // bar = barrier(s);
  Expr *barArg = ident("s", tokenT);
  Stmt *sBar =
      declStmt(tokenT, "bar", call("barrier", 0, 0, &barArg, 1, tokenT));
  // auto [v2, t2] = load(lptr after bar);
  Expr *ld2 = ident("lptr", simdSharedPtr);
  Stmt *sLoad2 = destructure2(
      "v2", "t2", callAfter("load", &ld2, 1, ident("bar", tokenT), simdF32));
  // store(v2, gptr after bar);
  Expr *st2[2] = {ident("v2", simdF32), ident("gptr", simdFPtr)};
  Stmt *sStore2 =
      callStmt(callAfter("store", st2, 2, ident("bar", tokenT), tokenT));

  Stmt *all[8] = {sLane, sGptr, sLds, sLptr, sLoad, sStore, sBar, sLoad2};
  Stmt *all9[9];
  for (int i = 0; i < 8; ++i)
    all9[i] = all[i];
  all9[8] = sStore2;
  Stmt *body = block(all9, 9);
  Param *ps[1] = {param(fptr, "g")};
  return makeProgram("lds_roundtrip", ps, 1, body, "amdgpu_lds_size", 128);
}

Stmt *whileStmt(Expr *cond, Stmt *bodyBlk) {
  Stmt *s = mkStmt(STMT_WHILE);
  s->as.while_.cond = cond;
  s->as.while_.body = bodyBlk;
  return s;
}

// An unsupported construct (while) nested in a where, to confirm the error
// path is clean: lowering must fail with a diagnostic, NOT crash on teardown
// (the orphan-region cleanup path).
Program *buildUnsupported() {
  TypeRef *u32 = scalarType(SCALAR_UINT32, 0, 0);
  TypeRef *boolT = scalarType(SCALAR_BOOL, 0, 0);
  TypeRef *simdI32 = simdType(scalarType(SCALAR_UINT32, 0, 0), 32);
  TypeRef *mask32 = maskType(32);

  Stmt *sLane =
      declStmt(simdI32, "lane", call("lane_id", 1, 32, nullptr, 0, simdI32));
  Expr *cmp = binary(TOK_LT, ident("lane", simdI32), ident("n", u32), mask32);
  Stmt *sActive = declStmt(mask32, "active", cmp);
  // where (active) { while (c) { } }  -- while is unsupported in v1 lowering.
  Stmt *empty = block(nullptr, 0);
  Stmt *sWhile = whileStmt(ident("c", boolT), empty);
  Stmt *wbS[1] = {sWhile};
  Stmt *wb = block(wbS, 1);
  Stmt *sWhere = whereStmt(ident("active", mask32), wb, nullptr);
  Stmt *all[3] = {sLane, sActive, sWhere};
  Stmt *body = block(all, 3);
  Param *ps[2] = {param(scalarType(SCALAR_BOOL, 0, 0), "c"), param(u32, "n")};
  return makeProgram("unsupported", ps, 2, body, nullptr, 0);
}

Program *buildSaxpyDefault() { return buildSaxpy(false); }
Program *buildSaxpySwap() { return buildSaxpy(true); }

using BuildProgramFn = Program *(*)();

struct LowerMode {
  const char *name;
  BuildProgramFn build;
};

static const LowerMode kLowerModes[] = {
    {"saxpy", buildSaxpyDefault},
    {"--swap", buildSaxpySwap},
    {"reduce_sum", buildReduceSum},
    {"where_carry", buildWhereCarry},
    {"where_otherwise", buildWhereOtherwise},
    {"uniform_if_else", buildUniformIfElse},
    {"cast_f32_f16", buildCastF32F16},
    {"lds_roundtrip", buildLdsRoundtrip},
    {"unsupported", buildUnsupported},
};

Program *selectProgram(const char *mode) {
  for (const LowerMode &entry : kLowerModes)
    if (strcmp(mode, entry.name) == 0)
      return entry.build();
  return nullptr;
}

void printLoweringErrors() {
  fprintf(stderr, "lowering failed:\n");
  for (Diag *d = g_diags.head; d; d = d->next)
    fprintf(stderr, "  %s\n", d->message);
}

} // namespace

int main(int argc, char **argv) {
  g_arena = arena_create(4u * 1024u * 1024u);
  if (g_arena.raw == nullptr) {
    fprintf(stderr, "arena alloc failed\n");
    return 2;
  }
  diag_list_init(&g_diags, &g_arena);

  const char *mode = (argc > 1) ? argv[1] : "saxpy";
  Program *p = selectProgram(mode);
  if (p == nullptr) {
    fprintf(stderr, "unknown mode '%s'\n", mode);
    arena_destroy(&g_arena);
    return 2;
  }

  char *mlir = wavec_lower_to_mlir(p, &g_diags);
  if (mlir == nullptr) {
    printLoweringErrors();
    arena_destroy(&g_arena);
    return 1;
  }
  fputs(mlir, stdout);
  wavec_lower_free(mlir);
  arena_destroy(&g_arena);
  return 0;
}
