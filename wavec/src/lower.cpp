//===- lower.cpp - AST -> Wave IR lowering bridge ----------------*- C++
//-*-===//
//
// The ONLY C++ in wavec. Walks a CHECKED AST (ast.h) and builds Wave-dialect
// MLIR through the mlir-c generic op API (mlirOperationCreate + op-name
// strings, as the Python DSL does -- Wave-c exposes no per-op builders),
// using the Wave-c type/attr getters. Renders the module to text.
//
// Lowering is general and type-directed: every construct is DERIVED from the
// AST + sema types, never recognized from a known input. An unsupported
// construct records a diagnostic and fails (returns NULL) -- never a canned
// result.
//
//===----------------------------------------------------------------------===//

// The front headers (ast.h/diag.h/arena.h) declare C-linkage functions but
// lack extern "C" guards; lower.h pulls them in. Wrap so this C++ TU calls
// diag_emit/arena_* with C linkage, matching the libwavefront archive.
extern "C" {
#include "lower.h"
}

#include "mlir-c/BuiltinAttributes.h"
#include "mlir-c/BuiltinTypes.h"
#include "mlir-c/Dialect/Arith.h"
#include "mlir-c/Dialect/Func.h"
#include "mlir-c/Dialect/SCF.h"
#include "mlir-c/IR.h"
#include "mlir-c/Support.h"

#include "Wave-c/Dialects.h"

#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>

namespace {

// Bounded recursion: mirror the parser's explicit depth guard so a
// pathologically nested AST cannot overflow the C++ stack here either.
constexpr unsigned kMaxDepth = 512;

// arith / wave.cmpi predicate codes (MLIR arith::CmpIPredicate ordering).
enum CmpPred {
  CMP_EQ = 0,
  CMP_NE = 1,
  CMP_SLT = 2,
  CMP_SLE = 3,
  CMP_SGT = 4,
  CMP_SGE = 5,
  CMP_ULT = 6,
  CMP_ULE = 7,
  CMP_UGT = 8,
  CMP_UGE = 9
};

// wave.cast kind codes (Wave CastKind ordering: FpConvert first).
enum CastKindCode {
  CAST_FPCONVERT = 0,
  CAST_INTCONVERT = 1,
  CAST_INT_TO_FP = 2,
  CAST_FP_TO_INT = 3
};

static MlirStringRef sr(const char *s) {
  return mlirStringRefCreate(s, strlen(s));
}
static MlirStringRef srn(const char *s, size_t n) {
  return mlirStringRefCreate(s, n);
}

// One mutable-local / parameter binding. `name` slices the source buffer
// (AST identifiers are not NUL-terminated), so compares are length-bounded.
struct Binding {
  const char *name;
  uint32_t name_len;
  MlirValue value;
};

// Per-lower state. No globals: everything threads through here.
struct LowerCtx {
  MlirContext ctx;
  MlirLocation loc;
  MlirBlock block; // current insertion point
  std::vector<Binding> env;
  DiagList *diags;
  unsigned depth;
  bool failed;
};

static void fail(LowerCtx &lc, SourceSpan span, const std::string &msg) {
  lc.failed = true;
  if (lc.diags)
    diag_emit(lc.diags, DIAG_ERROR, span, msg.c_str());
}

static SourceSpan exprSpan(const Expr *e) { return e->span; }
static SourceSpan stmtSpan(const Stmt *s) { return s->span; }

static bool nameEq(const Binding &b, const char *name, uint32_t len) {
  return b.name_len == len && memcmp(b.name, name, len) == 0;
}

// Most-recent binding for a name (locals shadow params), or NULL.
static Binding *lookup(LowerCtx &lc, const char *name, uint32_t len) {
  for (size_t i = lc.env.size(); i-- > 0;)
    if (nameEq(lc.env[i], name, len))
      return &lc.env[i];
  return nullptr;
}

static void bindNew(LowerCtx &lc, const char *name, uint32_t len, MlirValue v) {
  Binding b;
  b.name = name;
  b.name_len = len;
  b.value = v;
  lc.env.push_back(b);
}

//===----------------------------------------------------------------------===//
// Op builders (generic form, op-name strings).
//===----------------------------------------------------------------------===//

// Build an op with the given name, operands, result types, and attributes;
// append it; return the operation handle (caller pulls results).
static MlirOperation buildOp(LowerCtx &lc, const char *name,
                             std::vector<MlirValue> operands,
                             std::vector<MlirType> results,
                             std::vector<MlirNamedAttribute> attrs = {},
                             std::vector<MlirRegion> regions = {}) {
  MlirOperationState st = mlirOperationStateGet(sr(name), lc.loc);
  if (!operands.empty())
    mlirOperationStateAddOperands(&st, (intptr_t)operands.size(),
                                  operands.data());
  if (!results.empty())
    mlirOperationStateAddResults(&st, (intptr_t)results.size(), results.data());
  if (!attrs.empty())
    mlirOperationStateAddAttributes(&st, (intptr_t)attrs.size(), attrs.data());
  if (!regions.empty())
    mlirOperationStateAddOwnedRegions(&st, (intptr_t)regions.size(),
                                      regions.data());
  MlirOperation op = mlirOperationCreate(&st);
  if (mlirOperationIsNull(op)) {
    // Construction-time verification rejected the op (bad operand/result
    // shape) -- surface as a lowering failure rather than crash on teardown.
    lc.failed = true;
    return op;
  }
  mlirBlockAppendOwnedOperation(lc.block, op);
  return op;
}

// Result 0 of an op, or a null value if the op failed to build (buildOp set
// lc.failed). Keeps the error path from dereferencing a null op.
static MlirValue op0(MlirOperation op) {
  if (mlirOperationIsNull(op))
    return MlirValue{nullptr};
  return mlirOperationGetResult(op, 0);
}

static MlirNamedAttribute namedAttr(LowerCtx &lc, const char *name,
                                    MlirAttribute a) {
  return mlirNamedAttributeGet(mlirIdentifierGet(lc.ctx, sr(name)), a);
}

//===----------------------------------------------------------------------===//
// Type mapping.
//===----------------------------------------------------------------------===//

static bool scalarIsFloat(ScalarKind k) {
  return k == SCALAR_HALF || k == SCALAR_FLOAT;
}
static bool scalarIsInt(ScalarKind k) {
  switch (k) {
  case SCALAR_INT8:
  case SCALAR_INT16:
  case SCALAR_INT32:
  case SCALAR_INT64:
  case SCALAR_UINT8:
  case SCALAR_UINT16:
  case SCALAR_UINT32:
  case SCALAR_UINT64:
    return true;
  default:
    return false;
  }
}
static bool scalarIsSigned(ScalarKind k) {
  return k == SCALAR_INT8 || k == SCALAR_INT16 || k == SCALAR_INT32 ||
         k == SCALAR_INT64;
}
static unsigned scalarIntBits(ScalarKind k) {
  switch (k) {
  case SCALAR_INT8:
  case SCALAR_UINT8:
    return 8;
  case SCALAR_INT16:
  case SCALAR_UINT16:
    return 16;
  case SCALAR_INT32:
  case SCALAR_UINT32:
    return 32;
  case SCALAR_INT64:
  case SCALAR_UINT64:
    return 64;
  default:
    return 0;
  }
}

// A scalar element kind -> the builtin/Wave element MlirType. Null on
// unsupported (token has no element form here).
static MlirType scalarToType(LowerCtx &lc, ScalarKind k) {
  switch (k) {
  case SCALAR_BOOL:
    return mlirIntegerTypeGet(lc.ctx, 1);
  case SCALAR_HALF:
    return mlirF16TypeGet(lc.ctx);
  case SCALAR_FLOAT:
    return mlirF32TypeGet(lc.ctx);
  case SCALAR_INDEX:
    return mlirIndexTypeGet(lc.ctx);
  case SCALAR_TOKEN:
    return mlirWaveMemTokenTypeGet(lc.ctx);
  case SCALAR_INT8:
  case SCALAR_INT16:
  case SCALAR_INT32:
  case SCALAR_INT64:
  case SCALAR_UINT8:
  case SCALAR_UINT16:
  case SCALAR_UINT32:
  case SCALAR_UINT64:
    return mlirIntegerTypeGet(lc.ctx, scalarIntBits(k));
  }
  return MlirType{nullptr};
}

static MlirAttribute addrSpaceAttr(LowerCtx &lc, bool shared) {
  return shared ? mlirWaveSharedAddressSpaceAttrGet(lc.ctx)
                : mlirWaveGlobalAddressSpaceAttrGet(lc.ctx);
}

// Lower a TypeRef to an MlirType. Returns a null MlirType on an unsupported
// type (caller reports), e.g. fragment.
static MlirType lowerType(LowerCtx &lc, const TypeRef *t) {
  switch (t->kind) {
  case TYPE_SCALAR: {
    MlirType elem = scalarToType(lc, t->scalar);
    if (mlirTypeIsNull(elem))
      return elem;
    if (t->is_pointer)
      return mlirWavePtrTypeGet(elem, addrSpaceAttr(lc, t->is_shared != 0));
    return elem;
  }
  case TYPE_SIMD: {
    MlirType elem = lowerType(lc, t->element);
    if (mlirTypeIsNull(elem))
      return elem;
    return mlirWaveSimdTypeGet(elem, (int64_t)t->width);
  }
  case TYPE_MASK:
    return mlirWaveMaskTypeGet(lc.ctx, (int64_t)t->width);
  case TYPE_VECTOR: {
    MlirType elem = lowerType(lc, t->element);
    if (mlirTypeIsNull(elem))
      return elem;
    int64_t shape = (int64_t)t->width;
    return mlirVectorTypeGet(1, &shape, elem);
  }
  case TYPE_FRAGMENT:
    return MlirType{nullptr};
  }
  return MlirType{nullptr};
}

//===----------------------------------------------------------------------===//
// Type queries on built MlirTypes (drive broadcast/op-variant choices).
//===----------------------------------------------------------------------===//

static bool isSimd(MlirType t) { return mlirWaveTypeIsASimd(t); }

// Element type of a value: simd -> its element, else the type itself.
static MlirType elementOf(MlirType t) {
  if (mlirWaveTypeIsASimd(t))
    return mlirWaveSimdTypeGetElementType(t);
  return t;
}

static bool typeIsFloat(MlirType t) {
  MlirType e = elementOf(t);
  return mlirTypeIsAF32(e) || mlirTypeIsAF16(e) || mlirTypeIsABF16(e) ||
         mlirTypeIsAFloat(e);
}

// A pointer or a per-lane simd of pointers (the two forms ptr_add accepts as
// its base).
static bool isPtrLike(MlirType t) {
  return mlirWaveTypeIsAPtr(t) || mlirWaveTypeIsAPtr(elementOf(t));
}

//===----------------------------------------------------------------------===//
// Forward decls.
//===----------------------------------------------------------------------===//

static bool lowerBlock(LowerCtx &lc, const Stmt *blk);
static bool lowerStmt(LowerCtx &lc, const Stmt *s);
static bool lowerExpr(LowerCtx &lc, const Expr *e, MlirValue *out);

//===----------------------------------------------------------------------===//
// Constants and splat.
//===----------------------------------------------------------------------===//

static MlirValue makeIntConst(LowerCtx &lc, MlirType intTy, int64_t v) {
  MlirAttribute a = mlirIntegerAttrGet(intTy, v);
  MlirOperation op =
      buildOp(lc, "arith.constant", {}, {intTy}, {namedAttr(lc, "value", a)});
  return op0(op);
}

static MlirValue makeFloatConst(LowerCtx &lc, MlirType fltTy, double v) {
  MlirAttribute a = mlirFloatAttrDoubleGet(lc.ctx, fltTy, v);
  MlirOperation op =
      buildOp(lc, "arith.constant", {}, {fltTy}, {namedAttr(lc, "value", a)});
  return op0(op);
}

// wave.splat scalar -> simd<scalar, W>.
static MlirValue makeSplat(LowerCtx &lc, MlirValue scalar, int64_t width) {
  MlirType simdTy = mlirWaveSimdTypeGet(mlirValueGetType(scalar), width);
  MlirOperation op = buildOp(lc, "wave.splat", {scalar}, {simdTy});
  return op0(op);
}

// Binding-site broadcast: a scalar value assigned to a simd-typed name splats
// to that name's width (the "scalar broadcasts into a simd" rule, applied at
// decl/assign rather than only inside an op). No-op if `v` is already simd or
// the target is not simd. Element-type mismatches are left to the verifier.
static MlirValue coerceToType(LowerCtx &lc, MlirValue v, MlirType target) {
  if (isSimd(target) && !isSimd(mlirValueGetType(v)))
    return makeSplat(lc, v, mlirWaveSimdTypeGetWidth(target));
  return v;
}

//===----------------------------------------------------------------------===//
// Binary / unary arithmetic.
//===----------------------------------------------------------------------===//

// Result type for wave.addi/muli/shli: simd if any operand simd (element +
// width from the simd operand), else the scalar lhs type. Mirrors the DSL's
// _arith_result_type -- broadcast is built into the op (no pre-splat).
static MlirType arithResultType(MlirValue lhs, MlirValue rhs) {
  MlirType lt = mlirValueGetType(lhs), rt = mlirValueGetType(rhs);
  if (isSimd(lt))
    return lt;
  if (isSimd(rt))
    return rt;
  return lt;
}

// Only ops the Wave dialect actually registers. Integer sub/shr/and/or/xor
// have NO wave op and float div has none either; these return null so
// lowerBinary emits an honest "unsupported" error rather than inventing a
// dialect op name that fails verification.
static const char *intBinName(TokenKind op) {
  switch (op) {
  case TOK_PLUS:
    return "wave.addi";
  case TOK_STAR:
    return "wave.muli";
  case TOK_SHL:
    return "wave.shli";
  default:
    return nullptr;
  }
}

static const char *floatBinName(TokenKind op) {
  switch (op) {
  case TOK_PLUS:
    return "wave.fadd";
  case TOK_MINUS:
    return "wave.fsub";
  case TOK_STAR:
    return "wave.fmul";
  default:
    return nullptr;
  }
}

// Map a comparison token to a wave/arith predicate code, choosing signed vs
// unsigned from the operand element-int signedness.
static bool cmpPred(TokenKind op, bool isSignedInt, int *out) {
  switch (op) {
  case TOK_EQ:
    *out = CMP_EQ;
    return true;
  case TOK_NE:
    *out = CMP_NE;
    return true;
  case TOK_LT:
    *out = isSignedInt ? CMP_SLT : CMP_ULT;
    return true;
  case TOK_LE:
    *out = isSignedInt ? CMP_SLE : CMP_ULE;
    return true;
  case TOK_GT:
    *out = isSignedInt ? CMP_SGT : CMP_UGT;
    return true;
  case TOK_GE:
    *out = isSignedInt ? CMP_SGE : CMP_UGE;
    return true;
  default:
    return false;
  }
}

static bool isCompareTok(TokenKind op) {
  return op == TOK_EQ || op == TOK_NE || op == TOK_LT || op == TOK_LE ||
         op == TOK_GT || op == TOK_GE;
}

// Width of a simd value, or 0 if not simd.
static int64_t simdWidth(MlirType t) {
  if (mlirWaveTypeIsASimd(t))
    return mlirWaveSimdTypeGetWidth(t);
  return 0;
}

// Determine the integer signedness of a value from its sema TypeRef element.
// Defaults to unsigned when no signed sized-int is involved.
static bool valueElemSigned(const Expr *e) {
  const TypeRef *t = (const TypeRef *)e->sema_type;
  if (!t)
    return false;
  ScalarKind sk;
  if (t->kind == TYPE_SCALAR)
    sk = t->scalar;
  else if ((t->kind == TYPE_SIMD || t->kind == TYPE_VECTOR) && t->element &&
           t->element->kind == TYPE_SCALAR)
    sk = t->element->scalar;
  else
    return false;
  return scalarIsSigned(sk);
}

// Broadcast a scalar operand to match a simd sibling (cmpi/fadd/fmul require
// matching operand types). Returns the possibly-splatted value.
static MlirValue matchSimd(LowerCtx &lc, MlirValue v, int64_t width) {
  if (width != 0 && !isSimd(mlirValueGetType(v)))
    return makeSplat(lc, v, width);
  return v;
}

static bool lowerBinary(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprBinary &b = e->as.binary;
  MlirValue lhs, rhs;
  if (!lowerExpr(lc, b.lhs, &lhs) || !lowerExpr(lc, b.rhs, &rhs))
    return false;

  MlirType lt = mlirValueGetType(lhs), rt = mlirValueGetType(rhs);
  bool anySimd = isSimd(lt) || isSimd(rt);
  bool isFloat = typeIsFloat(lt) || typeIsFloat(rt);
  int64_t width = simdWidth(isSimd(lt) ? lt : rt);

  // Pointer arithmetic: `ptr + offset` -> wave.ptr_add. The base is either a
  // uniform !wave.ptr or a per-lane simd<ptr>; the offset carries the lane
  // width. Result: simd<ptr, W> for a lane offset, else the base type.
  bool lhsPtr = isPtrLike(lt);
  bool rhsPtr = isPtrLike(rt);
  if ((lhsPtr || rhsPtr) && b.op == TOK_PLUS) {
    MlirValue base = lhsPtr ? lhs : rhs;
    MlirValue off = lhsPtr ? rhs : lhs;
    MlirType baseTy = mlirValueGetType(base);
    MlirType resTy;
    if (isSimd(baseTy)) {
      resTy = baseTy;
    } else {
      int64_t offWidth = simdWidth(mlirValueGetType(off));
      resTy = (offWidth != 0) ? mlirWaveSimdTypeGet(baseTy, offWidth) : baseTy;
    }
    MlirOperation op = buildOp(lc, "wave.ptr_add", {base, off}, {resTy});
    *out = op0(op);
    return true;
  }
  if ((lhsPtr || rhsPtr)) {
    fail(lc, exprSpan(e), "lowering: only '+' is supported on pointers");
    return false;
  }

  if (isCompareTok(b.op)) {
    // simd -> mask<W>; scalar -> i1 (arith.cmpi). Operands must match: splat
    // the scalar side for the simd case.
    int pred;
    bool signedInt = valueElemSigned(b.lhs) || valueElemSigned(b.rhs);
    if (!cmpPred(b.op, signedInt, &pred)) {
      fail(lc, exprSpan(e), "lowering: unsupported comparison operator");
      return false;
    }
    MlirAttribute predAttr =
        mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 64), pred);
    if (anySimd) {
      lhs = matchSimd(lc, lhs, width);
      rhs = matchSimd(lc, rhs, width);
      MlirType maskTy = mlirWaveMaskTypeGet(lc.ctx, width);
      MlirOperation op = buildOp(lc, "wave.cmpi", {lhs, rhs}, {maskTy},
                                 {namedAttr(lc, "predicate", predAttr)});
      *out = op0(op);
      return true;
    }
    if (isFloat) {
      fail(lc, exprSpan(e), "lowering: float comparison not supported");
      return false;
    }
    MlirType i1 = mlirIntegerTypeGet(lc.ctx, 1);
    MlirOperation op = buildOp(lc, "arith.cmpi", {lhs, rhs}, {i1},
                               {namedAttr(lc, "predicate", predAttr)});
    *out = op0(op);
    return true;
  }

  if (isFloat) {
    if (anySimd) {
      // Lane-varying float: wave.f* (simd-only). Splat the scalar side.
      const char *name = floatBinName(b.op);
      if (!name) {
        fail(lc, exprSpan(e), "lowering: unsupported float operator");
        return false;
      }
      lhs = matchSimd(lc, lhs, width);
      rhs = matchSimd(lc, rhs, width);
      MlirType resTy = mlirValueGetType(lhs);
      MlirOperation op = buildOp(lc, name, {lhs, rhs}, {resTy});
      *out = op0(op);
      return true;
    }
    // Uniform scalar float: wave.f* reject scalar operands, so use arith.*f.
    const char *aname = nullptr;
    switch (b.op) {
    case TOK_PLUS:
      aname = "arith.addf";
      break;
    case TOK_MINUS:
      aname = "arith.subf";
      break;
    case TOK_STAR:
      aname = "arith.mulf";
      break;
    case TOK_SLASH:
      aname = "arith.divf";
      break;
    default:
      break;
    }
    if (!aname) {
      fail(lc, exprSpan(e), "lowering: unsupported float operator");
      return false;
    }
    MlirType resTy = mlirValueGetType(lhs);
    MlirOperation op = buildOp(lc, aname, {lhs, rhs}, {resTy});
    *out = op0(op);
    return true;
  }

  // Integer arithmetic/bitwise: wave.addi/muli/... broadcast internally.
  const char *name = intBinName(b.op);
  if (!name) {
    fail(lc, exprSpan(e), "lowering: unsupported integer operator");
    return false;
  }
  MlirType resTy = arithResultType(lhs, rhs);
  MlirOperation op = buildOp(lc, name, {lhs, rhs}, {resTy});
  *out = op0(op);
  return true;
}

//===----------------------------------------------------------------------===//
// Builtins.
//===----------------------------------------------------------------------===//

static bool identIs(const Expr *e, const char *name) {
  if (e->kind != EXPR_IDENT)
    return false;
  size_t n = strlen(name);
  return e->as.ident.name_len == n && memcmp(e->as.ident.name, name, n) == 0;
}

// Lower a load, returning the (value, token) results. Used both by the
// destructure stmt (keeps token) and expression position (drops token).
static bool lowerLoad(LowerCtx &lc, const ExprCall &call, SourceSpan span,
                      MlirValue *valueOut, MlirValue *tokenOut) {
  if (call.arg_count != 1) {
    fail(lc, span, "lowering: load expects one pointer argument");
    return false;
  }
  MlirValue ptr;
  if (!lowerExpr(lc, call.args[0], &ptr))
    return false;
  std::vector<MlirValue> operands = {ptr};
  if (call.has_dep) {
    MlirValue dep;
    if (!lowerExpr(lc, call.dep, &dep))
      return false;
    operands.push_back(dep);
  }
  // Result simd<T,W>: element from the pointee, width from the simd-ptr.
  MlirType ptrTy = mlirValueGetType(ptr);
  if (!mlirWaveTypeIsASimd(ptrTy)) {
    fail(lc, span, "lowering: load pointer must be a per-lane simd of ptr");
    return false;
  }
  MlirType ptrElem = mlirWaveSimdTypeGetElementType(ptrTy); // !wave.ptr<..>
  int64_t width = mlirWaveSimdTypeGetWidth(ptrTy);
  if (!mlirWaveTypeIsAPtr(ptrElem)) {
    fail(lc, span, "lowering: load operand is not a pointer");
    return false;
  }
  MlirType pointee = mlirWavePtrTypeGetElementType(ptrElem);
  MlirType resTy = mlirWaveSimdTypeGet(pointee, width);
  MlirType tokTy = mlirWaveMemTokenTypeGet(lc.ctx);
  MlirOperation op = buildOp(lc, "wave.load", operands, {resTy, tokTy});
  if (mlirOperationIsNull(op))
    return false;
  *valueOut = mlirOperationGetResult(op, 0);
  *tokenOut = mlirOperationGetResult(op, 1);
  return true;
}

// Returns the wave.cast kind code + whether a policy attr is required; fills
// the policy attribute (a dict) when needed. False on an unsupported cast.
static bool buildCastPolicy(LowerCtx &lc, ScalarKind srcK, ScalarKind dstK,
                            SourceSpan span, int *kindOut, bool *hasPolicy,
                            MlirAttribute *policyOut) {
  *hasPolicy = false;
  bool sFloat = scalarIsFloat(srcK), dFloat = scalarIsFloat(dstK);
  bool sInt = scalarIsInt(srcK), dInt = scalarIsInt(dstK);
  if (sFloat && dFloat) {
    *kindOut = CAST_FPCONVERT; // rounding defaults rne; no policy in golden.
    return true;
  }
  if (sInt && dInt) {
    *kindOut = CAST_INTCONVERT;
    unsigned sb = scalarIntBits(srcK), db = scalarIntBits(dstK);
    if (db > sb) {
      // Widening: extension policy from source signedness.
      const char *ext = scalarIsSigned(srcK) ? "#wave.cast_extension<sign>"
                                             : "#wave.cast_extension<zero>";
      MlirAttribute extAttr = mlirAttributeParseGet(lc.ctx, sr(ext));
      if (mlirAttributeIsNull(extAttr)) {
        fail(lc, span, "lowering: failed to build cast extension policy");
        return false;
      }
      MlirNamedAttribute entry = namedAttr(lc, "extension", extAttr);
      *policyOut = mlirDictionaryAttrGet(lc.ctx, 1, &entry);
      *hasPolicy = true;
    }
    return true;
  }
  if (sInt && dFloat) {
    *kindOut = CAST_INT_TO_FP;
    const char *sg = scalarIsSigned(srcK) ? "#wave.cast_signedness<signed>"
                                          : "#wave.cast_signedness<unsigned>";
    MlirAttribute sgAttr = mlirAttributeParseGet(lc.ctx, sr(sg));
    if (mlirAttributeIsNull(sgAttr)) {
      fail(lc, span, "lowering: failed to build cast signedness policy");
      return false;
    }
    MlirNamedAttribute entry = namedAttr(lc, "signedness", sgAttr);
    *policyOut = mlirDictionaryAttrGet(lc.ctx, 1, &entry);
    *hasPolicy = true;
    return true;
  }
  if (sFloat && dInt) {
    *kindOut = CAST_FP_TO_INT;
    const char *sg = scalarIsSigned(dstK) ? "#wave.cast_signedness<signed>"
                                          : "#wave.cast_signedness<unsigned>";
    MlirAttribute sgAttr = mlirAttributeParseGet(lc.ctx, sr(sg));
    if (mlirAttributeIsNull(sgAttr)) {
      fail(lc, span, "lowering: failed to build cast signedness policy");
      return false;
    }
    MlirNamedAttribute entry = namedAttr(lc, "signedness", sgAttr);
    *policyOut = mlirDictionaryAttrGet(lc.ctx, 1, &entry);
    *hasPolicy = true;
    return true;
  }
  fail(lc, span, "lowering: unsupported cast element kinds");
  return false;
}

// Dispatch a call expression. `wantValue` controls whether a value result is
// required (true) or a void-producing builtin like store/wait is allowed.
static bool lowerCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprCall &call = e->as.call;
  const Expr *callee = call.callee;
  SourceSpan span = exprSpan(e);

  if (callee->kind != EXPR_IDENT) {
    fail(lc, span, "lowering: only builtin calls are supported");
    return false;
  }

  // lane_id<W>() -> wave.lane_id : simd<i32, W>.
  if (identIs(callee, "lane_id")) {
    int64_t width = 32;
    if (call.garg_count == 1 && call.gargs[0].kind == GARG_INT)
      width = (int64_t)call.gargs[0].int_value;
    MlirType i32 = mlirIntegerTypeGet(lc.ctx, 32);
    MlirType resTy = mlirWaveSimdTypeGet(i32, width);
    MlirOperation op = buildOp(lc, "wave.lane_id", {}, {resTy});
    *out = op0(op);
    return true;
  }

  // wave_id_in_grid() -> wave.workgroup_id 0 : i32. v1 models one wave per
  // workgroup, so the grid-global wave id is the workgroup id (the same
  // stand-in the saxpy golden uses); a general lowering, not input recognition.
  if (identIs(callee, "wave_id_in_grid")) {
    MlirType i32 = mlirIntegerTypeGet(lc.ctx, 32);
    MlirAttribute axAttr =
        mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 64), 0);
    MlirOperation op = buildOp(lc, "wave.workgroup_id", {}, {i32},
                               {namedAttr(lc, "axis", axAttr)});
    *out = op0(op);
    return true;
  }

  // workgroup_id<ax>() -> wave.workgroup_id {axis} : i32 (uniform).
  if (identIs(callee, "workgroup_id")) {
    int64_t axis = 0;
    if (call.garg_count == 1 && call.gargs[0].kind == GARG_INT)
      axis = (int64_t)call.gargs[0].int_value;
    MlirType i32 = mlirIntegerTypeGet(lc.ctx, 32);
    MlirAttribute axAttr =
        mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 64), axis);
    MlirOperation op = buildOp(lc, "wave.workgroup_id", {}, {i32},
                               {namedAttr(lc, "axis", axAttr)});
    *out = op0(op);
    return true;
  }

  // workitem_id<ax>() -> wave.workitem_id {axis} : simd<i32, W>.
  if (identIs(callee, "workitem_id")) {
    int64_t axis = 0;
    if (call.garg_count == 1 && call.gargs[0].kind == GARG_INT)
      axis = (int64_t)call.gargs[0].int_value;
    // Result width = kernel wave size N, taken from sema's annotation -- NOT
    // hardcoded 32 (that produced wrong IR in wave64 kernels).
    const TypeRef *rt = (const TypeRef *)e->sema_type;
    MlirType resTy =
        (rt != nullptr)
            ? lowerType(lc, rt)
            : mlirWaveSimdTypeGet(mlirIntegerTypeGet(lc.ctx, 32), 32);
    MlirAttribute axAttr =
        mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 64), axis);
    MlirOperation op = buildOp(lc, "wave.workitem_id", {}, {resTy},
                               {namedAttr(lc, "axis", axAttr)});
    *out = op0(op);
    return true;
  }

  // load(ptr [after t]) in expression position: yields value, drops token.
  if (identIs(callee, "load")) {
    MlirValue value, token;
    if (!lowerLoad(lc, call, span, &value, &token))
      return false;
    *out = value;
    return true;
  }

  // store(value, ptr [after t]) -> wave.store : token.
  if (identIs(callee, "store")) {
    if (call.arg_count != 2) {
      fail(lc, span, "lowering: store expects (value, ptr)");
      return false;
    }
    MlirValue value, ptr;
    if (!lowerExpr(lc, call.args[0], &value) ||
        !lowerExpr(lc, call.args[1], &ptr))
      return false;
    std::vector<MlirValue> operands = {value, ptr};
    if (call.has_dep) {
      MlirValue dep;
      if (!lowerExpr(lc, call.dep, &dep))
        return false;
      operands.push_back(dep);
    }
    MlirType tokTy = mlirWaveMemTokenTypeGet(lc.ctx);
    MlirOperation op = buildOp(lc, "wave.store", operands, {tokTy});
    *out = op0(op);
    return true;
  }

  // barrier(t...) -> wave.barrier : token.
  if (identIs(callee, "barrier")) {
    std::vector<MlirValue> operands;
    for (size_t i = 0; i < call.arg_count; ++i) {
      MlirValue t;
      if (!lowerExpr(lc, call.args[i], &t))
        return false;
      operands.push_back(t);
    }
    MlirType tokTy = mlirWaveMemTokenTypeGet(lc.ctx);
    MlirOperation op = buildOp(lc, "wave.barrier", operands, {tokTy});
    *out = op0(op);
    return true;
  }

  // join(t...) -> wave.join : token.
  if (identIs(callee, "join")) {
    std::vector<MlirValue> operands;
    for (size_t i = 0; i < call.arg_count; ++i) {
      MlirValue t;
      if (!lowerExpr(lc, call.args[i], &t))
        return false;
      operands.push_back(t);
    }
    MlirType tokTy = mlirWaveMemTokenTypeGet(lc.ctx);
    MlirOperation op = buildOp(lc, "wave.join", operands, {tokTy});
    *out = op0(op);
    return true;
  }

  // wait(t...) -> wave.wait : () (no result).
  if (identIs(callee, "wait")) {
    std::vector<MlirValue> operands;
    for (size_t i = 0; i < call.arg_count; ++i) {
      MlirValue t;
      if (!lowerExpr(lc, call.args[i], &t))
        return false;
      operands.push_back(t);
    }
    buildOp(lc, "wave.wait", operands, {});
    *out = MlirValue{nullptr};
    return true;
  }

  // lds_base<T>([K]) -> wave.lds_base {offset=K} : shared T*.
  if (identIs(callee, "lds_base")) {
    MlirType elem = mlirIntegerTypeGet(lc.ctx, 32);
    if (call.garg_count == 1 && call.gargs[0].kind == GARG_TYPE) {
      elem = lowerType(lc, call.gargs[0].type);
      if (mlirTypeIsNull(elem)) {
        fail(lc, span, "lowering: unsupported lds_base element type");
        return false;
      }
    }
    int64_t off = 0;
    if (call.arg_count == 1) {
      const Expr *a = call.args[0];
      if (a->kind == EXPR_INT_LIT)
        off = (int64_t)a->as.int_lit.value;
      else {
        fail(lc, span, "lowering: lds_base offset must be a constant");
        return false;
      }
    }
    MlirType ptrTy =
        mlirWavePtrTypeGet(elem, mlirWaveSharedAddressSpaceAttrGet(lc.ctx));
    MlirAttribute offAttr =
        mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 64), off);
    MlirOperation op = buildOp(lc, "wave.lds_base", {}, {ptrTy},
                               {namedAttr(lc, "offset", offAttr)});
    *out = op0(op);
    return true;
  }

  // index_cast(x) -> arith.index_cast : index <-> int. Result type from sema.
  if (identIs(callee, "index_cast")) {
    if (call.arg_count != 1) {
      fail(lc, span, "lowering: index_cast expects one argument");
      return false;
    }
    MlirValue v;
    if (!lowerExpr(lc, call.args[0], &v))
      return false;
    const TypeRef *rt = (const TypeRef *)e->sema_type;
    if (!rt) {
      fail(lc, span, "lowering: index_cast result type unknown");
      return false;
    }
    MlirType resTy = lowerType(lc, rt);
    if (mlirTypeIsNull(resTy)) {
      fail(lc, span, "lowering: unsupported index_cast result type");
      return false;
    }
    MlirOperation op = buildOp(lc, "arith.index_cast", {v}, {resTy});
    *out = op0(op);
    return true;
  }

  // cast<T>(x) -> wave.cast {kind[, policy]} : simd<U> -> simd<T>.
  if (identIs(callee, "cast")) {
    if (call.arg_count != 1 || call.garg_count != 1 ||
        call.gargs[0].kind != GARG_TYPE) {
      fail(lc, span, "lowering: cast expects cast<T>(value)");
      return false;
    }
    MlirValue v;
    if (!lowerExpr(lc, call.args[0], &v))
      return false;
    MlirType srcTy = mlirValueGetType(v);
    // Target element kind from the generic arg; lane shape inherited.
    const TypeRef *dstTypeRef = call.gargs[0].type;
    if (dstTypeRef->kind != TYPE_SCALAR) {
      fail(lc, span, "lowering: cast target must be a scalar element type");
      return false;
    }
    ScalarKind dstK = dstTypeRef->scalar;
    // Source element kind: recover from sema type of the argument.
    const TypeRef *argT = (const TypeRef *)call.args[0]->sema_type;
    ScalarKind srcK;
    if (argT && argT->kind == TYPE_SCALAR)
      srcK = argT->scalar;
    else if (argT && (argT->kind == TYPE_SIMD || argT->kind == TYPE_VECTOR) &&
             argT->element && argT->element->kind == TYPE_SCALAR)
      srcK = argT->element->scalar;
    else {
      fail(lc, span, "lowering: cannot determine cast source element type");
      return false;
    }
    int kind;
    bool hasPolicy;
    MlirAttribute policy;
    if (!buildCastPolicy(lc, srcK, dstK, span, &kind, &hasPolicy, &policy))
      return false;
    MlirType dstElem = scalarToType(lc, dstK);
    MlirType resTy =
        isSimd(srcTy)
            ? mlirWaveSimdTypeGet(dstElem, mlirWaveSimdTypeGetWidth(srcTy))
            : dstElem;
    std::vector<MlirNamedAttribute> attrs;
    attrs.push_back(namedAttr(
        lc, "kind", mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 32), kind)));
    if (hasPolicy)
      attrs.push_back(namedAttr(lc, "policy", policy));
    MlirOperation op = buildOp(lc, "wave.cast", {v}, {resTy}, attrs);
    *out = op0(op);
    return true;
  }

  fail(lc, span, "lowering: unsupported builtin or call");
  return false;
}

//===----------------------------------------------------------------------===//
// Expressions.
//===----------------------------------------------------------------------===//

// A literal's MlirType comes from its sema-assigned result type.
static MlirType litType(LowerCtx &lc, const Expr *e) {
  const TypeRef *t = (const TypeRef *)e->sema_type;
  if (!t)
    return MlirType{nullptr};
  return lowerType(lc, t);
}

static bool lowerExpr(LowerCtx &lc, const Expr *e, MlirValue *out) {
  if (lc.failed)
    return false;
  if (++lc.depth > kMaxDepth) {
    fail(lc, exprSpan(e), "lowering: maximum expression nesting exceeded");
    --lc.depth;
    return false;
  }
  bool ok = true;
  switch (e->kind) {
  case EXPR_INT_LIT: {
    MlirType t = litType(lc, e);
    if (mlirTypeIsNull(t)) {
      fail(lc, exprSpan(e),
           "lowering: integer literal without a resolved type");
      ok = false;
      break;
    }
    // A literal whose resolved type is simd broadcasts: scalar const + splat.
    int64_t width = simdWidth(t);
    MlirType elem = elementOf(t);
    if (mlirTypeIsAInteger(elem) || mlirTypeIsAIndex(elem)) {
      MlirValue c = makeIntConst(lc, elem, (int64_t)e->as.int_lit.value);
      *out = (width != 0) ? makeSplat(lc, c, width) : c;
    } else {
      fail(lc, exprSpan(e),
           "lowering: integer literal mapped to non-integer type");
      ok = false;
    }
    break;
  }
  case EXPR_FLOAT_LIT: {
    MlirType t = litType(lc, e);
    MlirType elem = elementOf(t);
    if (mlirTypeIsNull(t) || !mlirTypeIsAFloat(elem)) {
      fail(lc, exprSpan(e),
           "lowering: float literal without a resolved float type");
      ok = false;
      break;
    }
    int64_t width = simdWidth(t);
    MlirValue c = makeFloatConst(lc, elem, e->as.float_lit.value);
    *out = (width != 0) ? makeSplat(lc, c, width) : c;
    break;
  }
  case EXPR_IDENT: {
    Binding *b = lookup(lc, e->as.ident.name, e->as.ident.name_len);
    if (!b) {
      std::string m = "lowering: unbound identifier '";
      m.append(e->as.ident.name, e->as.ident.name_len);
      m += "'";
      fail(lc, exprSpan(e), m);
      ok = false;
      break;
    }
    *out = b->value;
    break;
  }
  case EXPR_TOKEN_SEED: {
    MlirType tokTy = mlirWaveMemTokenTypeGet(lc.ctx);
    MlirOperation op = buildOp(lc, "wave.token", {}, {tokTy});
    *out = op0(op);
    break;
  }
  case EXPR_PAREN:
    ok = lowerExpr(lc, e->as.paren, out);
    break;
  case EXPR_UNARY:
    fail(lc, exprSpan(e), "lowering: unary operators not supported");
    ok = false;
    break;
  case EXPR_BINARY:
    ok = lowerBinary(lc, e, out);
    break;
  case EXPR_CALL:
    ok = lowerCall(lc, e, out);
    break;
  }
  --lc.depth;
  return ok && !lc.failed;
}

//===----------------------------------------------------------------------===//
// SSA construction over mutable locals: carry detection for regions.
//===----------------------------------------------------------------------===//

// Collect names assigned (STMT_ASSIGN / destructure / decl-shadow) anywhere
// within `s`, including nested regions. Decls introduce *new* locals, so a
// name first declared inside the body is NOT a carry of the outer scope;
// track declared-inside names to exclude them.
static void collectAssigned(const Stmt *s,
                            std::vector<const BoundName *> &assigned,
                            std::vector<const BoundName *> &declaredInside);

static void
collectAssignedBlock(const StmtBlock &blk,
                     std::vector<const BoundName *> &assigned,
                     std::vector<const BoundName *> &declaredInside) {
  for (size_t i = 0; i < blk.stmt_count; ++i)
    collectAssigned(blk.stmts[i], assigned, declaredInside);
}

static void collectAssigned(const Stmt *s,
                            std::vector<const BoundName *> &assigned,
                            std::vector<const BoundName *> &declaredInside) {
  switch (s->kind) {
  case STMT_DECL:
    declaredInside.push_back(&s->as.decl.name);
    break;
  case STMT_DESTRUCTURE:
    for (size_t i = 0; i < s->as.destructure.name_count; ++i)
      declaredInside.push_back(&s->as.destructure.names[i]);
    break;
  case STMT_ASSIGN:
    assigned.push_back(&s->as.assign.target);
    break;
  case STMT_IF:
  case STMT_WHERE:
    if (s->as.cond.then_block)
      collectAssignedBlock(s->as.cond.then_block->as.block, assigned,
                           declaredInside);
    if (s->as.cond.else_block)
      collectAssignedBlock(s->as.cond.else_block->as.block, assigned,
                           declaredInside);
    break;
  case STMT_FOR:
    if (s->as.for_.body)
      collectAssignedBlock(s->as.for_.body->as.block, assigned, declaredInside);
    break;
  case STMT_WHILE:
    if (s->as.while_.body)
      collectAssignedBlock(s->as.while_.body->as.block, assigned,
                           declaredInside);
    break;
  case STMT_BLOCK:
    collectAssignedBlock(s->as.block, assigned, declaredInside);
    break;
  case STMT_CALL:
    break;
  }
}

// Carried-in locals of a body: names assigned in the body that are bound in
// the enclosing scope AND not (re)declared inside the body. Deterministic
// order: by first binding position in the enclosing env.
struct Carry {
  const char *name;
  uint32_t name_len;
  MlirValue incoming; // value in the enclosing scope at region entry
};

static bool nameInList(const std::vector<const BoundName *> &v, const char *n,
                       uint32_t len) {
  for (const BoundName *b : v)
    if (b->name_len == len && memcmp(b->name, n, len) == 0)
      return true;
  return false;
}

static std::vector<Carry> computeCarries(LowerCtx &lc, const Stmt *thenBlock,
                                         const Stmt *elseBlock = nullptr) {
  std::vector<const BoundName *> assigned, declaredInside;
  collectAssignedBlock(thenBlock->as.block, assigned, declaredInside);
  // A name assigned only in the else/otherwise branch is still a region carry.
  if (elseBlock != nullptr)
    collectAssignedBlock(elseBlock->as.block, assigned, declaredInside);
  std::vector<Carry> carries;
  // Order by first enclosing-env position; dedup by name.
  for (size_t i = 0; i < lc.env.size(); ++i) {
    const Binding &bnd = lc.env[i];
    if (!nameInList(assigned, bnd.name, bnd.name_len))
      continue;
    if (nameInList(declaredInside, bnd.name, bnd.name_len))
      continue;
    bool dup = false;
    for (const Carry &c : carries)
      if (c.name_len == bnd.name_len &&
          memcmp(c.name, bnd.name, bnd.name_len) == 0)
        dup = true;
    if (dup)
      continue;
    Carry c;
    c.name = bnd.name;
    c.name_len = bnd.name_len;
    // Incoming is the CURRENT (newest) binding -- what every read sees via
    // lookup() -- not this possibly-shadowed env entry. A name rebound to an
    // enclosing region's carry (e.g. a for iter_arg) must carry the rebound
    // value; bnd.value here could feed the body a stale loop-invariant.
    Binding *cur = lookup(lc, bnd.name, bnd.name_len);
    c.incoming = (cur != nullptr) ? cur->value : bnd.value;
    carries.push_back(c);
  }
  return carries;
}

//===----------------------------------------------------------------------===//
// Region body lowering with carry threading.
//===----------------------------------------------------------------------===//

// Core: switch insertion to `target`, bind carries to the supplied block-arg
// values (or to incoming for non-arg regions), lower the body, collect the
// final carry values. Restores insertion block + env.
static bool runBody(LowerCtx &lc, MlirBlock target, const Stmt *bodyBlock,
                    const std::vector<Carry> &carries,
                    const std::vector<MlirValue> &carryBindings,
                    std::vector<MlirValue> &finalsOut) {
  MlirBlock saved = lc.block;
  size_t envMark = lc.env.size();
  lc.block = target;
  for (size_t i = 0; i < carries.size(); ++i)
    bindNew(lc, carries[i].name, carries[i].name_len, carryBindings[i]);

  bool ok = lowerBlock(lc, bodyBlock);

  if (ok) {
    finalsOut.clear();
    for (const Carry &c : carries) {
      Binding *b = lookup(lc, c.name, c.name_len);
      finalsOut.push_back(b ? b->value : c.incoming);
    }
  }
  lc.env.resize(envMark);
  lc.block = saved;
  return ok;
}

//===----------------------------------------------------------------------===//
// Statements.
//===----------------------------------------------------------------------===//

static const char *yieldOpName(bool waveRegion) {
  return waveRegion ? "wave.yield" : "scf.yield";
}

// Destroy regions still owned by the lowerer (not yet handed to an op). On a
// mid-body failure this drops the partial region's ops -- and their uses of
// module SSA values -- so module teardown does not trip the use-after-free
// check. Safe on null regions.
static void destroyRegions(std::vector<MlirRegion> regions) {
  for (MlirRegion r : regions)
    if (r.ptr != nullptr)
      mlirRegionDestroy(r);
}

static void emitYield(LowerCtx &lc, MlirBlock blk, bool waveRegion,
                      const std::vector<MlirValue> &values) {
  MlirBlock saved = lc.block;
  lc.block = blk;
  buildOp(lc, yieldOpName(waveRegion), values, {});
  lc.block = saved;
}

static bool lowerWhere(LowerCtx &lc, const Stmt *s) {
  const StmtCond &c = s->as.cond;
  MlirValue mask;
  if (!lowerExpr(lc, c.cond, &mask))
    return false;
  MlirType maskTy = mlirValueGetType(mask);
  if (!mlirWaveTypeIsAMask(maskTy)) {
    fail(lc, stmtSpan(s), "lowering: where condition must be a mask");
    return false;
  }

  std::vector<Carry> carries = computeCarries(lc, c.then_block, c.else_block);

  std::vector<MlirType> resultTypes;
  for (const Carry &cy : carries)
    resultTypes.push_back(mlirValueGetType(cy.incoming));

  // then region.
  MlirRegion thenRegion = mlirRegionCreate();
  MlirBlock thenBlk = mlirBlockCreate(0, nullptr, nullptr);
  mlirRegionAppendOwnedBlock(thenRegion, thenBlk);
  // otherwise region: always present in generic form; only populated when
  // there is an explicit otherwise or carries need a carried-in yield.
  MlirRegion elseRegion = mlirRegionCreate();
  MlirBlock elseBlk{nullptr};
  bool haveElse = (c.else_block != nullptr) || !carries.empty();
  if (haveElse) {
    elseBlk = mlirBlockCreate(0, nullptr, nullptr);
    mlirRegionAppendOwnedBlock(elseRegion, elseBlk);
  }

  std::vector<MlirValue> thenCarryIn;
  for (const Carry &cy : carries)
    thenCarryIn.push_back(cy.incoming);

  std::vector<MlirValue> thenFinals;
  if (!runBody(lc, thenBlk, c.then_block, carries, thenCarryIn, thenFinals)) {
    destroyRegions({thenRegion, elseRegion});
    return false;
  }
  emitYield(lc, thenBlk, /*waveRegion=*/true, thenFinals);

  if (haveElse) {
    std::vector<MlirValue> elseFinals;
    if (c.else_block) {
      if (!runBody(lc, elseBlk, c.else_block, carries, thenCarryIn,
                   elseFinals)) {
        destroyRegions({thenRegion, elseRegion});
        return false;
      }
    } else {
      // then-only with carries: inactive lanes keep carried-in values.
      elseFinals = thenCarryIn;
    }
    emitYield(lc, elseBlk, /*waveRegion=*/true, elseFinals);
  }

  std::vector<MlirRegion> regions = {thenRegion, elseRegion};
  MlirOperation op =
      buildOp(lc, "wave.where", {mask}, resultTypes, {}, regions);
  if (mlirOperationIsNull(op))
    return false;

  // Rebind carried locals to the where results in the enclosing scope.
  for (size_t i = 0; i < carries.size(); ++i) {
    Binding *b = lookup(lc, carries[i].name, carries[i].name_len);
    if (b)
      b->value = mlirOperationGetResult(op, (intptr_t)i);
  }
  return true;
}

static bool lowerIf(LowerCtx &lc, const Stmt *s) {
  const StmtCond &c = s->as.cond;
  MlirValue cond;
  if (!lowerExpr(lc, c.cond, &cond))
    return false;
  MlirType cTy = mlirValueGetType(cond);
  if (!(mlirTypeIsAInteger(cTy) && mlirIntegerTypeGetWidth(cTy) == 1)) {
    fail(lc, stmtSpan(s), "lowering: if condition must be a uniform bool");
    return false;
  }

  std::vector<Carry> carries = computeCarries(lc, c.then_block, c.else_block);
  std::vector<MlirType> resultTypes;
  for (const Carry &cy : carries)
    resultTypes.push_back(mlirValueGetType(cy.incoming));

  std::vector<MlirValue> carryIn;
  for (const Carry &cy : carries)
    carryIn.push_back(cy.incoming);

  MlirRegion thenRegion = mlirRegionCreate();
  MlirBlock thenBlk = mlirBlockCreate(0, nullptr, nullptr);
  mlirRegionAppendOwnedBlock(thenRegion, thenBlk);
  MlirRegion elseRegion = mlirRegionCreate();
  // scf.if needs an else region whenever it has results; synthesize one that
  // yields carried-in when the source has no else.
  bool haveElse = (c.else_block != nullptr) || !carries.empty();
  MlirBlock elseBlk{nullptr};
  if (haveElse) {
    elseBlk = mlirBlockCreate(0, nullptr, nullptr);
    mlirRegionAppendOwnedBlock(elseRegion, elseBlk);
  }

  std::vector<MlirValue> thenFinals;
  if (!runBody(lc, thenBlk, c.then_block, carries, carryIn, thenFinals)) {
    destroyRegions({thenRegion, elseRegion});
    return false;
  }
  emitYield(lc, thenBlk, /*waveRegion=*/false, thenFinals);

  if (haveElse) {
    std::vector<MlirValue> elseFinals;
    if (c.else_block) {
      if (!runBody(lc, elseBlk, c.else_block, carries, carryIn, elseFinals)) {
        destroyRegions({thenRegion, elseRegion});
        return false;
      }
    } else {
      elseFinals = carryIn;
    }
    emitYield(lc, elseBlk, /*waveRegion=*/false, elseFinals);
  }

  std::vector<MlirRegion> regions = {thenRegion, elseRegion};
  MlirOperation op = buildOp(lc, "scf.if", {cond}, resultTypes, {}, regions);
  if (mlirOperationIsNull(op))
    return false;
  for (size_t i = 0; i < carries.size(); ++i) {
    Binding *b = lookup(lc, carries[i].name, carries[i].name_len);
    if (b)
      b->value = mlirOperationGetResult(op, (intptr_t)i);
  }
  return true;
}

static bool lowerFor(LowerCtx &lc, const Stmt *s) {
  const StmtFor &f = s->as.for_;
  MlirValue lb, ub;
  if (!lowerExpr(lc, f.lb, &lb) || !lowerExpr(lc, f.ub, &ub))
    return false;
  MlirType ivTy = lowerType(lc, f.iv_type);
  if (mlirTypeIsNull(ivTy)) {
    fail(lc, stmtSpan(s), "lowering: unsupported for induction-variable type");
    return false;
  }
  MlirValue step;
  if (f.step) {
    if (!lowerExpr(lc, f.step, &step))
      return false;
  } else {
    step = makeIntConst(lc, ivTy, 1);
  }

  std::vector<Carry> carries = computeCarries(lc, f.body);
  std::vector<MlirType> resultTypes;
  for (const Carry &cy : carries)
    resultTypes.push_back(mlirValueGetType(cy.incoming));

  // Body block args: IV first, then one per carry.
  std::vector<MlirType> argTypes;
  std::vector<MlirLocation> argLocs;
  argTypes.push_back(ivTy);
  argLocs.push_back(lc.loc);
  for (const Carry &cy : carries) {
    argTypes.push_back(mlirValueGetType(cy.incoming));
    argLocs.push_back(lc.loc);
  }

  MlirRegion region = mlirRegionCreate();
  MlirBlock body = mlirBlockCreate((intptr_t)argTypes.size(), argTypes.data(),
                                   argLocs.data());
  mlirRegionAppendOwnedBlock(region, body);

  // Bind IV name + carries to block args; lower body.
  std::vector<MlirValue> carryArgs;
  for (size_t i = 0; i < carries.size(); ++i)
    carryArgs.push_back(mlirBlockGetArgument(body, (intptr_t)(i + 1)));

  MlirBlock saved = lc.block;
  size_t envMark = lc.env.size();
  lc.block = body;
  bindNew(lc, f.iv_name.name, f.iv_name.name_len,
          mlirBlockGetArgument(body, 0));
  for (size_t i = 0; i < carries.size(); ++i)
    bindNew(lc, carries[i].name, carries[i].name_len, carryArgs[i]);
  bool ok = lowerBlock(lc, f.body);
  std::vector<MlirValue> finals;
  if (ok)
    for (const Carry &cy : carries) {
      Binding *b = lookup(lc, cy.name, cy.name_len);
      finals.push_back(b ? b->value : cy.incoming);
    }
  // scf.for body terminator is scf.yield of the carries.
  if (ok)
    buildOp(lc, "scf.yield", finals, {});
  lc.env.resize(envMark);
  lc.block = saved;
  if (!ok) {
    destroyRegions({region});
    return false;
  }

  std::vector<MlirValue> operands = {lb, ub, step};
  for (const Carry &cy : carries)
    operands.push_back(cy.incoming);
  std::vector<MlirRegion> regions = {region};
  MlirOperation op = buildOp(lc, "scf.for", operands, resultTypes, {}, regions);
  if (mlirOperationIsNull(op))
    return false;
  for (size_t i = 0; i < carries.size(); ++i) {
    Binding *b = lookup(lc, carries[i].name, carries[i].name_len);
    if (b)
      b->value = mlirOperationGetResult(op, (intptr_t)i);
  }
  return true;
}

// Compound assignment desugars to the binary op then store-to-local.
static TokenKind compoundToBinop(TokenKind op) {
  switch (op) {
  case TOK_PLUS_EQ:
    return TOK_PLUS;
  case TOK_MINUS_EQ:
    return TOK_MINUS;
  case TOK_STAR_EQ:
    return TOK_STAR;
  case TOK_SLASH_EQ:
    return TOK_SLASH;
  case TOK_AMP_EQ:
    return TOK_AMP;
  case TOK_PIPE_EQ:
    return TOK_PIPE;
  case TOK_CARET_EQ:
    return TOK_CARET;
  case TOK_SHL_EQ:
    return TOK_SHL;
  case TOK_SHR_EQ:
    return TOK_SHR;
  default:
    return TOK_EOF;
  }
}

static bool lowerStmtImpl(LowerCtx &lc, const Stmt *s) {
  switch (s->kind) {
  case STMT_DECL: {
    MlirValue v;
    if (!lowerExpr(lc, s->as.decl.init, &v))
      return false;
    // Broadcast a scalar initializer to the declared simd type.
    MlirType declTy = lowerType(lc, s->as.decl.type);
    if (!mlirTypeIsNull(declTy))
      v = coerceToType(lc, v, declTy);
    bindNew(lc, s->as.decl.name.name, s->as.decl.name.name_len, v);
    return true;
  }
  case STMT_DESTRUCTURE: {
    // Only `load` yields multiple results in v1: (value, token).
    const Expr *init = s->as.destructure.init;
    if (init->kind != EXPR_CALL || !identIs(init->as.call.callee, "load")) {
      fail(lc, stmtSpan(s),
           "lowering: destructuring only supported for load(...)");
      return false;
    }
    if (s->as.destructure.name_count != 2) {
      fail(lc, stmtSpan(s),
           "lowering: load destructure binds exactly (value, token)");
      return false;
    }
    MlirValue value, token;
    if (!lowerLoad(lc, init->as.call, stmtSpan(s), &value, &token))
      return false;
    bindNew(lc, s->as.destructure.names[0].name,
            s->as.destructure.names[0].name_len, value);
    bindNew(lc, s->as.destructure.names[1].name,
            s->as.destructure.names[1].name_len, token);
    return true;
  }
  case STMT_ASSIGN: {
    const StmtAssign &a = s->as.assign;
    Binding *b = lookup(lc, a.target.name, a.target.name_len);
    if (!b) {
      std::string m = "lowering: assignment to unbound '";
      m.append(a.target.name, a.target.name_len);
      m += "'";
      fail(lc, stmtSpan(s), m);
      return false;
    }
    MlirValue rhs;
    if (a.op == TOK_ASSIGN) {
      if (!lowerExpr(lc, a.value, &rhs))
        return false;
    } else {
      // Compound: build (target binop value) using the current binding.
      TokenKind binop = compoundToBinop(a.op);
      if (binop == TOK_EOF) {
        fail(lc, stmtSpan(s), "lowering: unsupported compound assignment");
        return false;
      }
      Expr lhsE;
      memset(&lhsE, 0, sizeof(lhsE));
      lhsE.kind = EXPR_IDENT;
      lhsE.span = a.target.span;
      lhsE.as.ident.name = a.target.name;
      lhsE.as.ident.name_len = a.target.name_len;
      lhsE.sema_type = nullptr;
      Expr binE;
      memset(&binE, 0, sizeof(binE));
      binE.kind = EXPR_BINARY;
      binE.span = stmtSpan(s);
      binE.as.binary.op = binop;
      binE.as.binary.lhs = &lhsE;
      binE.as.binary.rhs = a.value;
      binE.sema_type = nullptr;
      if (!lowerBinary(lc, &binE, &rhs))
        return false;
      b = lookup(lc, a.target.name, a.target.name_len);
    }
    if (b) {
      // Broadcast a scalar RHS to the target's simd type (carry shape stays
      // consistent so the region's yields all agree).
      b->value = coerceToType(lc, rhs, mlirValueGetType(b->value));
    }
    return true;
  }
  case STMT_CALL: {
    MlirValue ignored;
    return lowerExpr(lc, s->as.call.call, &ignored);
  }
  case STMT_IF:
    return lowerIf(lc, s);
  case STMT_WHERE:
    return lowerWhere(lc, s);
  case STMT_FOR:
    return lowerFor(lc, s);
  case STMT_WHILE:
    fail(lc, stmtSpan(s), "lowering: while loops not supported");
    return false;
  case STMT_BLOCK:
    return lowerBlock(lc, s);
  }
  fail(lc, stmtSpan(s), "lowering: unknown statement");
  return false;
}

static bool lowerStmt(LowerCtx &lc, const Stmt *s) {
  if (lc.failed)
    return false;
  // Bounded recursion: statement nesting (blocks/where/if/for) shares the
  // expression depth counter so pathological nesting cannot blow the stack.
  if (++lc.depth > kMaxDepth) {
    fail(lc, stmtSpan(s), "lowering: maximum statement nesting exceeded");
    --lc.depth;
    return false;
  }
  bool ok = lowerStmtImpl(lc, s);
  --lc.depth;
  return ok && !lc.failed;
}

static bool lowerBlock(LowerCtx &lc, const Stmt *blk) {
  const StmtBlock &b = blk->as.block;
  for (size_t i = 0; i < b.stmt_count; ++i)
    if (!lowerStmt(lc, b.stmts[i]))
      return false;
  return true;
}

//===----------------------------------------------------------------------===//
// Kernel + module.
//===----------------------------------------------------------------------===//

// Read [[amdgpu_lds_size(N)]] off a kernel, if present. Returns true if found.
static bool kernelLdsSize(const Kernel *k, uint64_t *out) {
  for (size_t i = 0; i < k->attr_count; ++i) {
    const Attribute *a = k->attrs[i];
    static const char ks[] = "amdgpu_lds_size";
    if (a->name_len == sizeof(ks) - 1 &&
        memcmp(a->name, ks, sizeof(ks) - 1) == 0 && a->has_arg) {
      *out = a->arg;
      return true;
    }
  }
  return false;
}

static bool lowerKernel(LowerCtx &lc, MlirBlock moduleBody, const Kernel *k) {
  // Parameter types.
  std::vector<MlirType> inputs;
  for (size_t i = 0; i < k->param_count; ++i) {
    MlirType t = lowerType(lc, k->params[i]->type);
    if (mlirTypeIsNull(t)) {
      fail(lc, k->params[i]->span, "lowering: unsupported parameter type");
      return false;
    }
    inputs.push_back(t);
  }

  MlirType funcTy = mlirFunctionTypeGet(lc.ctx, (intptr_t)inputs.size(),
                                        inputs.data(), 0, nullptr);

  // func.func op with sym_name + function_type, body region with one block.
  MlirRegion bodyRegion = mlirRegionCreate();
  std::vector<MlirLocation> argLocs(inputs.size(), lc.loc);
  MlirBlock entry = mlirBlockCreate((intptr_t)inputs.size(), inputs.data(),
                                    inputs.empty() ? nullptr : argLocs.data());
  mlirRegionAppendOwnedBlock(bodyRegion, entry);

  MlirOperationState st = mlirOperationStateGet(sr("func.func"), lc.loc);
  std::vector<MlirNamedAttribute> attrs;
  attrs.push_back(namedAttr(
      lc, "sym_name",
      mlirStringAttrGet(lc.ctx, srn(k->name.name, k->name.name_len))));
  attrs.push_back(namedAttr(lc, "function_type", mlirTypeAttrGet(funcTy)));
  attrs.push_back(namedAttr(lc, "wave.kernel", mlirUnitAttrGet(lc.ctx)));
  uint64_t lds;
  if (kernelLdsSize(k, &lds))
    attrs.push_back(namedAttr(
        lc, "wave.lds_size",
        mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 64), (int64_t)lds)));
  mlirOperationStateAddAttributes(&st, (intptr_t)attrs.size(), attrs.data());
  MlirRegion regionArr[1] = {bodyRegion};
  mlirOperationStateAddOwnedRegions(&st, 1, regionArr);
  MlirOperation func = mlirOperationCreate(&st);
  if (mlirOperationIsNull(func)) {
    fail(lc, k->span, "lowering: failed to construct func.func");
    return false;
  }
  mlirBlockAppendOwnedOperation(moduleBody, func);

  // Bind params to block args, lower the body, append func.return.
  size_t envMark = lc.env.size();
  MlirBlock saved = lc.block;
  lc.block = entry;
  for (size_t i = 0; i < k->param_count; ++i)
    bindNew(lc, k->params[i]->name.name, k->params[i]->name.name_len,
            mlirBlockGetArgument(entry, (intptr_t)i));

  bool ok = lowerBlock(lc, k->body);
  if (ok)
    buildOp(lc, "func.return", {}, {});
  lc.env.resize(envMark);
  lc.block = saved;
  return ok;
}

//===----------------------------------------------------------------------===//
// Dialect registration + printing.
//===----------------------------------------------------------------------===//

static void registerDialects(MlirContext ctx) {
  MlirDialectHandle wave = mlirGetDialectHandle__wave__();
  MlirDialectHandle waveamd = mlirGetDialectHandle__waveamd__();
  MlirDialectHandle wavemeta = mlirGetDialectHandle__wavemeta__();
  MlirDialectHandle func = mlirGetDialectHandle__func__();
  MlirDialectHandle scf = mlirGetDialectHandle__scf__();
  MlirDialectHandle arith = mlirGetDialectHandle__arith__();
  mlirDialectHandleRegisterDialect(wave, ctx);
  mlirDialectHandleRegisterDialect(waveamd, ctx);
  mlirDialectHandleRegisterDialect(wavemeta, ctx);
  mlirDialectHandleRegisterDialect(func, ctx);
  mlirDialectHandleRegisterDialect(scf, ctx);
  mlirDialectHandleRegisterDialect(arith, ctx);
  mlirDialectHandleLoadDialect(wave, ctx);
  mlirDialectHandleLoadDialect(waveamd, ctx);
  mlirDialectHandleLoadDialect(wavemeta, ctx);
  mlirDialectHandleLoadDialect(func, ctx);
  mlirDialectHandleLoadDialect(scf, ctx);
  mlirDialectHandleLoadDialect(arith, ctx);
  // gpu.container_module attr needs the gpu dialect registered to parse/print
  // the attribute name; the module attribute is a plain unit attr though, so
  // a discardable attr does not require the dialect. Load all available to be
  // safe for any attr we attach.
  mlirContextLoadAllAvailableDialects(ctx);
}

// Append-to-std::string callback for mlirOperationPrint.
static void printCallback(MlirStringRef s, void *userData) {
  std::string *out = static_cast<std::string *>(userData);
  out->append(s.data, s.length);
}

} // namespace

extern "C" char *wavec_lower_to_mlir(const Program *program, DiagList *diags) {
  if (program == nullptr)
    return nullptr;

  MlirContext ctx = mlirContextCreate();
  registerDialects(ctx);

  MlirLocation loc = mlirLocationUnknownGet(ctx);
  MlirModule mod = mlirModuleCreateEmpty(loc);
  MlirOperation modOp = mlirModuleGetOperation(mod);

  // module attribute: gpu.container_module (unit attr).
  mlirOperationSetAttributeByName(modOp, sr("gpu.container_module"),
                                  mlirUnitAttrGet(ctx));

  MlirBlock moduleBody = mlirModuleGetBody(mod);

  LowerCtx lc;
  lc.ctx = ctx;
  lc.loc = loc;
  lc.block = moduleBody;
  lc.diags = diags;
  lc.depth = 0;
  lc.failed = false;

  bool ok = true;
  for (size_t i = 0; i < program->kernel_count && ok; ++i)
    ok = lowerKernel(lc, moduleBody, program->kernels[i]);

  char *result = nullptr;
  if (ok && !lc.failed) {
    std::string text;
    mlirOperationPrint(modOp, printCallback, &text);
    result = static_cast<char *>(malloc(text.size() + 1));
    if (result) {
      memcpy(result, text.data(), text.size());
      result[text.size()] = '\0';
    }
  }

  mlirModuleDestroy(mod);
  mlirContextDestroy(ctx);
  return result;
}

extern "C" void wavec_lower_free(char *mlir_text) { free(mlir_text); }
