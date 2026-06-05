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

enum class ScalarMlirKind { Invalid, I1, F16, F32, Index, Token, Integer };

struct ScalarMlirInfo {
  ScalarMlirKind kind;
  unsigned bits;
};

static const ScalarMlirInfo kScalarMlirInfo[] = {
    {ScalarMlirKind::I1, 1},       {ScalarMlirKind::F16, 16},
    {ScalarMlirKind::F32, 32},     {ScalarMlirKind::Index, 0},
    {ScalarMlirKind::Token, 0},    {ScalarMlirKind::Integer, 8},
    {ScalarMlirKind::Integer, 16}, {ScalarMlirKind::Integer, 32},
    {ScalarMlirKind::Integer, 64}, {ScalarMlirKind::Integer, 8},
    {ScalarMlirKind::Integer, 16}, {ScalarMlirKind::Integer, 32},
    {ScalarMlirKind::Integer, 64},
};

static MlirType scalarToType(LowerCtx &lc, ScalarKind k) {
  if ((unsigned)k >= sizeof(kScalarMlirInfo) / sizeof(kScalarMlirInfo[0]))
    return MlirType{nullptr};
  ScalarMlirInfo info = kScalarMlirInfo[k];
  switch (info.kind) {
  case ScalarMlirKind::I1:
    return mlirIntegerTypeGet(lc.ctx, 1);
  case ScalarMlirKind::F16:
    return mlirF16TypeGet(lc.ctx);
  case ScalarMlirKind::F32:
    return mlirF32TypeGet(lc.ctx);
  case ScalarMlirKind::Index:
    return mlirIndexTypeGet(lc.ctx);
  case ScalarMlirKind::Token:
    return mlirWaveMemTokenTypeGet(lc.ctx);
  case ScalarMlirKind::Integer:
    return mlirIntegerTypeGet(lc.ctx, info.bits);
  case ScalarMlirKind::Invalid:
    return MlirType{nullptr};
  }
  return MlirType{nullptr};
}

static MlirAttribute addrSpaceAttr(LowerCtx &lc, bool shared) {
  return shared ? mlirWaveSharedAddressSpaceAttrGet(lc.ctx)
                : mlirWaveGlobalAddressSpaceAttrGet(lc.ctx);
}

static MlirType lowerType(LowerCtx &lc, const TypeRef *t);

static MlirType wrapPointerType(LowerCtx &lc, const TypeRef *t,
                                MlirType element) {
  if (mlirTypeIsNull(element))
    return element;
  if (t->is_pointer)
    return mlirWavePtrTypeGet(element, addrSpaceAttr(lc, t->is_shared != 0));
  return element;
}

static MlirType lowerScalarType(LowerCtx &lc, const TypeRef *t) {
  return wrapPointerType(lc, t, scalarToType(lc, t->scalar));
}

static MlirType lowerSimdType(LowerCtx &lc, const TypeRef *t) {
  MlirType elem = lowerType(lc, t->element);
  if (mlirTypeIsNull(elem))
    return elem;
  return mlirWaveSimdTypeGet(elem, (int64_t)t->width);
}

static MlirType lowerVectorType(LowerCtx &lc, const TypeRef *t) {
  MlirType elem = lowerType(lc, t->element);
  if (mlirTypeIsNull(elem))
    return elem;
  int64_t shape = (int64_t)t->width;
  return wrapPointerType(lc, t, mlirVectorTypeGet(1, &shape, elem));
}

static MlirType lowerFragmentType(LowerCtx &lc, const TypeRef *t) {
  MlirType elem = lowerType(lc, t->element);
  if (mlirTypeIsNull(elem))
    return elem;
  return mlirWaveAMDFragmentTypeGet(
      lc.ctx, (int64_t)t->fragment_role, elem, (int64_t)t->fragment_rows,
      (int64_t)t->fragment_cols, (int64_t)t->width,
      (int64_t)t->fragment_registers);
}

// Caller reports null result types.
static MlirType lowerType(LowerCtx &lc, const TypeRef *t) {
  switch (t->kind) {
  case TYPE_SCALAR:
    return lowerScalarType(lc, t);
  case TYPE_SIMD:
    return lowerSimdType(lc, t);
  case TYPE_MASK:
    return mlirWaveMaskTypeGet(lc.ctx, (int64_t)t->width);
  case TYPE_VECTOR:
    return lowerVectorType(lc, t);
  case TYPE_FRAGMENT:
    return lowerFragmentType(lc, t);
  case TYPE_VOID:
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

// Result type for wave.binary: simd if any operand simd (element + width from
// the simd operand), else the scalar lhs type.
static MlirType arithResultType(MlirValue lhs, MlirValue rhs) {
  MlirType lt = mlirValueGetType(lhs), rt = mlirValueGetType(rhs);
  if (isSimd(lt))
    return lt;
  if (isSimd(rt))
    return rt;
  return lt;
}

enum BinaryKindCode {
  BINARY_ADDI = 0,
  BINARY_SUBI = 1,
  BINARY_MULI = 2,
  BINARY_SHLI = 3,
  BINARY_SHRUI = 4,
  BINARY_SHRSI = 5,
  BINARY_ANDI = 6,
  BINARY_ORI = 7,
  BINARY_XORI = 8,
  BINARY_DIVUI = 9,
  BINARY_DIVSI = 10,
  BINARY_REMUI = 11,
  BINARY_REMSI = 12
};

struct BinaryKindEntry {
  TokenKind op;
  BinaryKindCode unsignedKind;
  BinaryKindCode signedKind;
};

static constexpr BinaryKindEntry kBinaryKinds[] = {
    {TOK_PLUS, BINARY_ADDI, BINARY_ADDI},
    {TOK_MINUS, BINARY_SUBI, BINARY_SUBI},
    {TOK_STAR, BINARY_MULI, BINARY_MULI},
    {TOK_SLASH, BINARY_DIVUI, BINARY_DIVSI},
    {TOK_PERCENT, BINARY_REMUI, BINARY_REMSI},
    {TOK_SHL, BINARY_SHLI, BINARY_SHLI},
    {TOK_SHR, BINARY_SHRUI, BINARY_SHRSI},
    {TOK_AMP, BINARY_ANDI, BINARY_ANDI},
    {TOK_PIPE, BINARY_ORI, BINARY_ORI},
    {TOK_CARET, BINARY_XORI, BINARY_XORI},
};

static bool intBinKind(TokenKind op, bool signedInt, bool indexResult,
                       int64_t *kind) {
  for (const BinaryKindEntry &entry : kBinaryKinds) {
    if (entry.op != op)
      continue;
    BinaryKindCode selected =
        signedInt && !indexResult ? entry.signedKind : entry.unsignedKind;
    *kind = static_cast<int64_t>(selected);
    return true;
  }
  return false;
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
struct CmpPredEntry {
  TokenKind op;
  int signedPred;
  int unsignedPred;
};

static const CmpPredEntry kCmpPreds[] = {
    {TOK_EQ, CMP_EQ, CMP_EQ},   {TOK_NE, CMP_NE, CMP_NE},
    {TOK_LT, CMP_SLT, CMP_ULT}, {TOK_LE, CMP_SLE, CMP_ULE},
    {TOK_GT, CMP_SGT, CMP_UGT}, {TOK_GE, CMP_SGE, CMP_UGE},
};

static bool cmpPred(TokenKind op, bool isSignedInt, int *out) {
  for (const CmpPredEntry &pred : kCmpPreds) {
    if (pred.op != op)
      continue;
    *out = isSignedInt ? pred.signedPred : pred.unsignedPred;
    return true;
  }
  return false;
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

static bool valueElemUnsignedSized(const Expr *e) {
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
  return scalarIntBits(sk) != 0 && !scalarIsSigned(sk);
}

// Broadcast a scalar operand to match a simd sibling (cmpi/fadd/fmul require
// matching operand types). Returns the possibly-splatted value.
static MlirValue matchSimd(LowerCtx &lc, MlirValue v, int64_t width) {
  if (width != 0 && !isSimd(mlirValueGetType(v)))
    return makeSplat(lc, v, width);
  return v;
}

static MlirType ptrAddResultType(MlirValue base, MlirValue off) {
  MlirType baseTy = mlirValueGetType(base);
  if (isSimd(baseTy))
    return baseTy;
  int64_t offWidth = simdWidth(mlirValueGetType(off));
  return (offWidth != 0) ? mlirWaveSimdTypeGet(baseTy, offWidth) : baseTy;
}

static MlirValue castIndexIntScalar(LowerCtx &lc, MlirValue v, MlirType target,
                                    const Expr *sourceExpr);

static bool lowerPointerBinary(LowerCtx &lc, const Expr *e, MlirValue lhs,
                               MlirValue rhs, bool lhsPtr, bool rhsPtr,
                               MlirValue *out, bool *handled) {
  const ExprBinary &b = e->as.binary;
  *handled = lhsPtr || rhsPtr;
  if (!*handled)
    return true;
  if (b.op != TOK_PLUS) {
    fail(lc, exprSpan(e), "lowering: only '+' is supported on pointers");
    return false;
  }
  MlirValue base = lhsPtr ? lhs : rhs;
  MlirValue off = lhsPtr ? rhs : lhs;
  MlirOperation op =
      buildOp(lc, "wave.ptr_add", {base, off}, {ptrAddResultType(base, off)});
  *out = op0(op);
  return true;
}

static bool lowerCompareBinary(LowerCtx &lc, const Expr *e, MlirValue lhs,
                               MlirValue rhs, bool anySimd, bool isFloat,
                               int64_t width, MlirValue *out) {
  const ExprBinary &b = e->as.binary;
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
  MlirType lhsTy = mlirValueGetType(lhs);
  MlirType rhsTy = mlirValueGetType(rhs);
  if (mlirTypeIsAIndex(lhsTy) && mlirTypeIsAInteger(rhsTy))
    rhs = castIndexIntScalar(lc, rhs, lhsTy, b.rhs);
  else if (mlirTypeIsAIndex(rhsTy) && mlirTypeIsAInteger(lhsTy))
    lhs = castIndexIntScalar(lc, lhs, rhsTy, b.lhs);
  MlirType i1 = mlirIntegerTypeGet(lc.ctx, 1);
  MlirOperation op = buildOp(lc, "arith.cmpi", {lhs, rhs}, {i1},
                             {namedAttr(lc, "predicate", predAttr)});
  *out = op0(op);
  return true;
}

static const char *floatScalarBinName(TokenKind op) {
  switch (op) {
  case TOK_PLUS:
    return "arith.addf";
  case TOK_MINUS:
    return "arith.subf";
  case TOK_STAR:
    return "arith.mulf";
  case TOK_SLASH:
    return "arith.divf";
  default:
    return nullptr;
  }
}

static bool lowerFloatBinary(LowerCtx &lc, const Expr *e, MlirValue lhs,
                             MlirValue rhs, bool anySimd, int64_t width,
                             MlirValue *out) {
  const ExprBinary &b = e->as.binary;
  const char *name = anySimd ? floatBinName(b.op) : floatScalarBinName(b.op);
  if (!name) {
    fail(lc, exprSpan(e), "lowering: unsupported float operator");
    return false;
  }
  if (anySimd) {
    lhs = matchSimd(lc, lhs, width);
    rhs = matchSimd(lc, rhs, width);
  }
  MlirType resTy = mlirValueGetType(lhs);
  MlirOperation op = buildOp(lc, name, {lhs, rhs}, {resTy});
  *out = op0(op);
  return true;
}

static MlirValue castIndexIntScalar(LowerCtx &lc, MlirValue v, MlirType target,
                                    const Expr *sourceExpr) {
  MlirType source = mlirValueGetType(v);
  if (mlirTypeEqual(source, target))
    return v;
  if ((mlirTypeIsAIndex(source) || mlirTypeIsAInteger(source)) &&
      (mlirTypeIsAIndex(target) || mlirTypeIsAInteger(target))) {
    const char *opName = mlirTypeIsAIndex(target) &&
                                 mlirTypeIsAInteger(source) &&
                                 valueElemUnsignedSized(sourceExpr)
                             ? "arith.index_castui"
                             : "arith.index_cast";
    return op0(buildOp(lc, opName, {v}, {target}));
  }
  return v;
}

static bool lowerIntBinary(LowerCtx &lc, const Expr *e, MlirValue lhs,
                           MlirValue rhs, MlirValue *out) {
  const TypeRef *rt = (const TypeRef *)e->sema_type;
  MlirType resTy = rt ? lowerType(lc, rt) : arithResultType(lhs, rhs);
  if (mlirTypeIsNull(resTy)) {
    fail(lc, exprSpan(e), "lowering: unsupported integer result type");
    return false;
  }
  bool indexResult = mlirTypeIsAIndex(elementOf(resTy));
  int64_t kind;
  const ExprBinary &b = e->as.binary;
  bool signedInt = b.op == TOK_SHR
                       ? valueElemSigned(b.lhs)
                       : valueElemSigned(b.lhs) || valueElemSigned(b.rhs);
  if (!intBinKind(b.op, signedInt, indexResult, &kind)) {
    fail(lc, exprSpan(e), "lowering: unsupported integer operator");
    return false;
  }
  if (indexResult) {
    if (!mlirTypeEqual(mlirValueGetType(lhs), resTy))
      lhs = castIndexIntScalar(lc, lhs, resTy, b.lhs);
    if (!mlirTypeEqual(mlirValueGetType(rhs), resTy))
      rhs = castIndexIntScalar(lc, rhs, resTy, b.rhs);
  }
  MlirAttribute kindAttr =
      mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 32), kind);
  MlirOperation op = buildOp(lc, "wave.binary", {lhs, rhs}, {resTy},
                             {namedAttr(lc, "kind", kindAttr)});
  *out = op0(op);
  return true;
}

static bool lowerBinary(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprBinary &b = e->as.binary;
  MlirValue lhs;
  MlirValue rhs;
  bool handled;
  if (!lowerExpr(lc, b.lhs, &lhs) || !lowerExpr(lc, b.rhs, &rhs))
    return false;

  MlirType lt = mlirValueGetType(lhs);
  MlirType rt = mlirValueGetType(rhs);
  bool anySimd = isSimd(lt) || isSimd(rt);
  bool isFloat = typeIsFloat(lt) || typeIsFloat(rt);
  int64_t width = simdWidth(isSimd(lt) ? lt : rt);

  if (!lowerPointerBinary(lc, e, lhs, rhs, isPtrLike(lt), isPtrLike(rt), out,
                          &handled))
    return false;
  if (handled)
    return true;
  if (isCompareTok(b.op))
    return lowerCompareBinary(lc, e, lhs, rhs, anySimd, isFloat, width, out);
  if (isFloat)
    return lowerFloatBinary(lc, e, lhs, rhs, anySimd, width, out);
  return lowerIntBinary(lc, e, lhs, rhs, out);
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
static bool setPolicyAttr(LowerCtx &lc, SourceSpan span, const char *name,
                          const char *asmText, MlirAttribute *policyOut) {
  MlirAttribute attr = mlirAttributeParseGet(lc.ctx, sr(asmText));
  if (mlirAttributeIsNull(attr)) {
    fail(lc, span, "lowering: failed to build cast policy");
    return false;
  }
  MlirNamedAttribute entry = namedAttr(lc, name, attr);
  *policyOut = mlirDictionaryAttrGet(lc.ctx, 1, &entry);
  return true;
}

static bool maybeIntExtensionPolicy(LowerCtx &lc, ScalarKind srcK,
                                    ScalarKind dstK, SourceSpan span,
                                    bool *hasPolicy, MlirAttribute *policyOut) {
  if (scalarIntBits(dstK) <= scalarIntBits(srcK))
    return true;
  *hasPolicy = true;
  return setPolicyAttr(lc, span, "extension",
                       scalarIsSigned(srcK) ? "#wave.cast_extension<sign>"
                                            : "#wave.cast_extension<zero>",
                       policyOut);
}

static bool setSignednessPolicy(LowerCtx &lc, ScalarKind intK, SourceSpan span,
                                bool *hasPolicy, MlirAttribute *policyOut) {
  *hasPolicy = true;
  return setPolicyAttr(lc, span, "signedness",
                       scalarIsSigned(intK) ? "#wave.cast_signedness<signed>"
                                            : "#wave.cast_signedness<unsigned>",
                       policyOut);
}

static bool buildCastPolicy(LowerCtx &lc, ScalarKind srcK, ScalarKind dstK,
                            SourceSpan span, int *kindOut, bool *hasPolicy,
                            MlirAttribute *policyOut) {
  bool sFloat = scalarIsFloat(srcK), dFloat = scalarIsFloat(dstK);
  *hasPolicy = false;
  if (sFloat && dFloat) {
    *kindOut = CAST_FPCONVERT;
    return true;
  }
  if (!sFloat && !dFloat) {
    *kindOut = CAST_INTCONVERT;
    return maybeIntExtensionPolicy(lc, srcK, dstK, span, hasPolicy, policyOut);
  }
  if (!sFloat && dFloat) {
    *kindOut = CAST_INT_TO_FP;
    return setSignednessPolicy(lc, srcK, span, hasPolicy, policyOut);
  }
  if (sFloat && !dFloat) {
    *kindOut = CAST_FP_TO_INT;
    return setSignednessPolicy(lc, dstK, span, hasPolicy, policyOut);
  }
  fail(lc, span, "lowering: unsupported cast element kinds");
  return false;
}

static int64_t callIntGarg(const ExprCall &call, int64_t fallback) {
  if (call.garg_count == 1 && call.gargs[0].kind == GARG_INT)
    return (int64_t)call.gargs[0].int_value;
  return fallback;
}

static bool lowerLaneIdCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  int64_t width = callIntGarg(e->as.call, 32);
  MlirType i32 = mlirIntegerTypeGet(lc.ctx, 32);
  MlirType resTy = mlirWaveSimdTypeGet(i32, width);
  MlirOperation op = buildOp(lc, "wave.lane_id", {}, {resTy});
  *out = op0(op);
  return true;
}

static bool lowerWorkgroupAxis(LowerCtx &lc, int64_t axis, MlirValue *out) {
  MlirType i32 = mlirIntegerTypeGet(lc.ctx, 32);
  MlirAttribute axAttr =
      mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 64), axis);
  MlirOperation op = buildOp(lc, "wave.workgroup_id", {}, {i32},
                             {namedAttr(lc, "axis", axAttr)});
  *out = op0(op);
  return true;
}

static bool lowerWaveIdCall(LowerCtx &lc, const Expr *, MlirValue *out) {
  return lowerWorkgroupAxis(lc, 0, out);
}

static bool lowerWorkgroupIdCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  return lowerWorkgroupAxis(lc, callIntGarg(e->as.call, 0), out);
}

static bool lowerWorkitemIdCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprCall &call = e->as.call;
  int64_t axis = callIntGarg(call, 0);
  const TypeRef *rt = (const TypeRef *)e->sema_type;
  MlirType resTy =
      (rt != nullptr) ? lowerType(lc, rt)
                      : mlirWaveSimdTypeGet(mlirIntegerTypeGet(lc.ctx, 32), 32);
  MlirAttribute axAttr =
      mlirIntegerAttrGet(mlirIntegerTypeGet(lc.ctx, 64), axis);
  MlirOperation op = buildOp(lc, "wave.workitem_id", {}, {resTy},
                             {namedAttr(lc, "axis", axAttr)});
  *out = op0(op);
  return true;
}

static bool lowerSubgroupIdCall(LowerCtx &lc, const Expr *, MlirValue *out) {
  MlirType indexTy = mlirIndexTypeGet(lc.ctx);
  MlirOperation op = buildOp(lc, "wave.subgroup_id", {}, {indexTy});
  *out = op0(op);
  return true;
}

static bool lowerReadFirstCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprCall &call = e->as.call;
  MlirValue src;
  if (!lowerExpr(lc, call.args[0], &src))
    return false;
  MlirType resTy = lowerType(lc, (const TypeRef *)e->sema_type);
  if (mlirTypeIsNull(resTy)) {
    fail(lc, exprSpan(e), "lowering: read_first result type unknown");
    return false;
  }
  MlirOperation op = buildOp(lc, "wave.read_first", {src}, {resTy});
  *out = op0(op);
  return true;
}

static bool lowerLoadCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  MlirValue value;
  MlirValue token;
  if (!lowerLoad(lc, e->as.call, exprSpan(e), &value, &token))
    return false;
  *out = value;
  return true;
}

static bool lowerStoreCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprCall &call = e->as.call;
  SourceSpan span = exprSpan(e);
  if (call.arg_count != 2) {
    fail(lc, span, "lowering: store expects (value, ptr)");
    return false;
  }
  MlirValue value;
  MlirValue ptr;
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

static bool lowerFragmentFillCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  MlirValue src;
  if (!lowerExpr(lc, e->as.call.args[0], &src))
    return false;
  MlirType resTy = lowerType(lc, (const TypeRef *)e->sema_type);
  if (mlirTypeIsNull(resTy)) {
    fail(lc, exprSpan(e), "lowering: fragment_fill result type unknown");
    return false;
  }
  MlirOperation op = buildOp(lc, "waveamd.fragment_fill", {src}, {resTy});
  *out = op0(op);
  return true;
}

static bool lowerFragmentPackCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  MlirValue regs;
  if (!lowerExpr(lc, e->as.call.args[0], &regs))
    return false;
  MlirType resTy = lowerType(lc, (const TypeRef *)e->sema_type);
  if (mlirTypeIsNull(resTy)) {
    fail(lc, exprSpan(e), "lowering: fragment_pack result type unknown");
    return false;
  }
  MlirOperation op = buildOp(lc, "waveamd.fragment_pack", {regs}, {resTy});
  *out = op0(op);
  return true;
}

static bool lowerFragmentUnpackCall(LowerCtx &lc, const Expr *e,
                                    MlirValue *out) {
  MlirValue frag;
  if (!lowerExpr(lc, e->as.call.args[0], &frag))
    return false;
  MlirType resTy = lowerType(lc, (const TypeRef *)e->sema_type);
  if (mlirTypeIsNull(resTy)) {
    fail(lc, exprSpan(e), "lowering: fragment_unpack result type unknown");
    return false;
  }
  MlirOperation op = buildOp(lc, "waveamd.fragment_unpack", {frag}, {resTy});
  *out = op0(op);
  return true;
}

static const char *mmaKindForBuiltin(const Expr *callee) {
  if (identIs(callee, "mma_wmma_i32_16x16x16_iu8"))
    return "wmma.i32.16x16x16.iu8";
  if (identIs(callee, "mma_wmma_f32_16x16x16_f16"))
    return "wmma.f32.16x16x16.f16";
  if (identIs(callee, "mma_mfma_f32_16x16x16_f16"))
    return "mfma.f32.16x16x16.f16";
  if (identIs(callee, "mma_mfma_f32_16x16x32_f16"))
    return "mfma.f32.16x16x32.f16";
  return nullptr;
}

static bool lowerMmaCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprCall &call = e->as.call;
  MlirValue a, b, acc;
  if (!lowerExpr(lc, call.args[0], &a) || !lowerExpr(lc, call.args[1], &b) ||
      !lowerExpr(lc, call.args[2], &acc))
    return false;
  const char *kind = mmaKindForBuiltin(call.callee);
  if (kind == nullptr) {
    fail(lc, exprSpan(e), "lowering: unknown mma builtin");
    return false;
  }
  MlirType resTy = lowerType(lc, (const TypeRef *)e->sema_type);
  if (mlirTypeIsNull(resTy)) {
    fail(lc, exprSpan(e), "lowering: mma result type unknown");
    return false;
  }
  MlirAttribute kindAttr = mlirStringAttrGet(lc.ctx, sr(kind));
  MlirOperation op = buildOp(lc, "waveamd.mma", {a, b, acc}, {resTy},
                             {namedAttr(lc, "kind", kindAttr)});
  *out = op0(op);
  return true;
}

static bool lowerTokenOperands(LowerCtx &lc, const ExprCall &call,
                               std::vector<MlirValue> &operands) {
  for (size_t i = 0; i < call.arg_count; ++i) {
    MlirValue token;
    if (!lowerExpr(lc, call.args[i], &token))
      return false;
    operands.push_back(token);
  }
  return true;
}

static bool lowerTokenResultCall(LowerCtx &lc, const Expr *e,
                                 const char *opName, MlirValue *out) {
  std::vector<MlirValue> operands;
  if (!lowerTokenOperands(lc, e->as.call, operands))
    return false;
  MlirType tokTy = mlirWaveMemTokenTypeGet(lc.ctx);
  MlirOperation op = buildOp(lc, opName, operands, {tokTy});
  *out = op0(op);
  return true;
}

static bool lowerBarrierCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  return lowerTokenResultCall(lc, e, "wave.barrier", out);
}

static bool lowerJoinCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  return lowerTokenResultCall(lc, e, "wave.join", out);
}

static bool lowerWaitCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  std::vector<MlirValue> operands;
  if (!lowerTokenOperands(lc, e->as.call, operands))
    return false;
  buildOp(lc, "wave.wait", operands, {});
  *out = MlirValue{nullptr};
  return true;
}

static bool lowerLdsBaseCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprCall &call = e->as.call;
  SourceSpan span = exprSpan(e);
  MlirType elem = mlirIntegerTypeGet(lc.ctx, 32);
  int64_t off = 0;
  if (call.garg_count == 1 && call.gargs[0].kind == GARG_TYPE) {
    elem = lowerType(lc, call.gargs[0].type);
    if (mlirTypeIsNull(elem)) {
      fail(lc, span, "lowering: unsupported lds_base element type");
      return false;
    }
  }
  if (call.arg_count == 1) {
    const Expr *a = call.args[0];
    if (a->kind != EXPR_INT_LIT) {
      fail(lc, span, "lowering: lds_base offset must be a constant");
      return false;
    }
    off = (int64_t)a->as.int_lit.value;
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

static bool lowerIndexCastCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprCall &call = e->as.call;
  SourceSpan span = exprSpan(e);
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
  *out = castIndexIntScalar(lc, v, resTy, call.args[0]);
  return true;
}

static bool castSourceKind(const Expr *arg, ScalarKind *srcK) {
  const TypeRef *argT = (const TypeRef *)arg->sema_type;
  if (argT && argT->kind == TYPE_SCALAR) {
    *srcK = argT->scalar;
    return true;
  }
  if (argT && (argT->kind == TYPE_SIMD || argT->kind == TYPE_VECTOR) &&
      argT->element && argT->element->kind == TYPE_SCALAR) {
    *srcK = argT->element->scalar;
    return true;
  }
  return false;
}

static bool lowerCastCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const ExprCall &call = e->as.call;
  SourceSpan span = exprSpan(e);
  if (call.arg_count != 1 || call.garg_count != 1 ||
      call.gargs[0].kind != GARG_TYPE) {
    fail(lc, span, "lowering: cast expects cast<T>(value)");
    return false;
  }
  MlirValue v;
  if (!lowerExpr(lc, call.args[0], &v))
    return false;
  const TypeRef *dstTypeRef = call.gargs[0].type;
  if (dstTypeRef->kind != TYPE_SCALAR) {
    fail(lc, span, "lowering: cast target must be a scalar element type");
    return false;
  }
  ScalarKind srcK;
  ScalarKind dstK = dstTypeRef->scalar;
  if (!castSourceKind(call.args[0], &srcK)) {
    fail(lc, span, "lowering: cannot determine cast source element type");
    return false;
  }
  int kind;
  bool hasPolicy;
  MlirAttribute policy;
  if (!buildCastPolicy(lc, srcK, dstK, span, &kind, &hasPolicy, &policy))
    return false;
  MlirType srcTy = mlirValueGetType(v);
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

typedef bool (*LowerCallFn)(LowerCtx &, const Expr *, MlirValue *);

struct LowerCallEntry {
  const char *name;
  LowerCallFn lower;
};

static const LowerCallEntry kLowerCalls[] = {
    {"lane_id", lowerLaneIdCall},
    {"wave_id_in_grid", lowerWaveIdCall},
    {"workgroup_id", lowerWorkgroupIdCall},
    {"workitem_id", lowerWorkitemIdCall},
    {"subgroup_id", lowerSubgroupIdCall},
    {"read_first", lowerReadFirstCall},
    {"load", lowerLoadCall},
    {"store", lowerStoreCall},
    {"barrier", lowerBarrierCall},
    {"join", lowerJoinCall},
    {"wait", lowerWaitCall},
    {"lds_base", lowerLdsBaseCall},
    {"index_cast", lowerIndexCastCall},
    {"cast", lowerCastCall},
    {"fragment_fill", lowerFragmentFillCall},
    {"fragment_pack", lowerFragmentPackCall},
    {"fragment_unpack", lowerFragmentUnpackCall},
    {"mma_wmma_i32_16x16x16_iu8", lowerMmaCall},
    {"mma_wmma_f32_16x16x16_f16", lowerMmaCall},
    {"mma_mfma_f32_16x16x16_f16", lowerMmaCall},
    {"mma_mfma_f32_16x16x32_f16", lowerMmaCall},
};

static bool lowerCall(LowerCtx &lc, const Expr *e, MlirValue *out) {
  const Expr *callee = e->as.call.callee;
  if (callee->kind != EXPR_IDENT) {
    fail(lc, exprSpan(e), "lowering: only builtin calls are supported");
    return false;
  }
  for (const LowerCallEntry &entry : kLowerCalls) {
    if (identIs(callee, entry.name))
      return entry.lower(lc, e, out);
  }
  fail(lc, exprSpan(e), "lowering: unsupported builtin or call");
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

static bool lowerIntLiteral(LowerCtx &lc, const Expr *e, MlirValue *out) {
  MlirType t = litType(lc, e);
  if (mlirTypeIsNull(t)) {
    fail(lc, exprSpan(e), "lowering: integer literal without a resolved type");
    return false;
  }
  int64_t width = simdWidth(t);
  MlirType elem = elementOf(t);
  if (!mlirTypeIsAInteger(elem) && !mlirTypeIsAIndex(elem)) {
    fail(lc, exprSpan(e),
         "lowering: integer literal mapped to non-integer type");
    return false;
  }
  MlirValue c = makeIntConst(lc, elem, (int64_t)e->as.int_lit.value);
  *out = (width != 0) ? makeSplat(lc, c, width) : c;
  return true;
}

static bool lowerFloatLiteral(LowerCtx &lc, const Expr *e, MlirValue *out) {
  MlirType t = litType(lc, e);
  MlirType elem = elementOf(t);
  if (mlirTypeIsNull(t) || !mlirTypeIsAFloat(elem)) {
    fail(lc, exprSpan(e), "lowering: float literal without a resolved type");
    return false;
  }
  int64_t width = simdWidth(t);
  MlirValue c = makeFloatConst(lc, elem, e->as.float_lit.value);
  *out = (width != 0) ? makeSplat(lc, c, width) : c;
  return true;
}

static bool lowerIdentExpr(LowerCtx &lc, const Expr *e, MlirValue *out) {
  Binding *b = lookup(lc, e->as.ident.name, e->as.ident.name_len);
  if (!b) {
    std::string m = "lowering: unbound identifier '";
    m.append(e->as.ident.name, e->as.ident.name_len);
    m += "'";
    fail(lc, exprSpan(e), m);
    return false;
  }
  *out = b->value;
  return true;
}

static bool lowerTokenSeed(LowerCtx &lc, MlirValue *out) {
  MlirType tokTy = mlirWaveMemTokenTypeGet(lc.ctx);
  MlirOperation op = buildOp(lc, "wave.token", {}, {tokTy});
  *out = op0(op);
  return true;
}

static bool lowerExprInner(LowerCtx &lc, const Expr *e, MlirValue *out) {
  switch (e->kind) {
  case EXPR_INT_LIT:
    return lowerIntLiteral(lc, e, out);
  case EXPR_FLOAT_LIT:
    return lowerFloatLiteral(lc, e, out);
  case EXPR_IDENT:
    return lowerIdentExpr(lc, e, out);
  case EXPR_TOKEN_SEED: {
    return lowerTokenSeed(lc, out);
  }
  case EXPR_PAREN:
    return lowerExpr(lc, e->as.paren, out);
  case EXPR_UNARY:
    fail(lc, exprSpan(e), "lowering: unary operators not supported");
    return false;
  case EXPR_BINARY:
    return lowerBinary(lc, e, out);
  case EXPR_CALL:
    return lowerCall(lc, e, out);
  }
  return false;
}

static bool lowerExpr(LowerCtx &lc, const Expr *e, MlirValue *out) {
  if (lc.failed)
    return false;
  if (++lc.depth > kMaxDepth) {
    fail(lc, exprSpan(e), "lowering: maximum expression nesting exceeded");
    --lc.depth;
    return false;
  }
  bool ok = lowerExprInner(lc, e, out);
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

using CollectFn = void (*)(const Stmt *, std::vector<const BoundName *> &,
                           std::vector<const BoundName *> &);

static void collectDecl(const Stmt *s, std::vector<const BoundName *> &,
                        std::vector<const BoundName *> &declaredInside) {
  declaredInside.push_back(&s->as.decl.name);
}

static void collectDestructure(const Stmt *s, std::vector<const BoundName *> &,
                               std::vector<const BoundName *> &declaredInside) {
  for (size_t i = 0; i < s->as.destructure.name_count; ++i)
    declaredInside.push_back(&s->as.destructure.names[i]);
}

static void collectAssign(const Stmt *s,
                          std::vector<const BoundName *> &assigned,
                          std::vector<const BoundName *> &) {
  assigned.push_back(&s->as.assign.target);
}

static void collectCond(const Stmt *s, std::vector<const BoundName *> &assigned,
                        std::vector<const BoundName *> &declaredInside) {
  if (s->as.cond.then_block)
    collectAssignedBlock(s->as.cond.then_block->as.block, assigned,
                         declaredInside);
  if (s->as.cond.else_block)
    collectAssignedBlock(s->as.cond.else_block->as.block, assigned,
                         declaredInside);
}

static void collectFor(const Stmt *s, std::vector<const BoundName *> &assigned,
                       std::vector<const BoundName *> &declaredInside) {
  if (s->as.for_.body)
    collectAssignedBlock(s->as.for_.body->as.block, assigned, declaredInside);
}

static void collectWhile(const Stmt *s,
                         std::vector<const BoundName *> &assigned,
                         std::vector<const BoundName *> &declaredInside) {
  if (s->as.while_.body)
    collectAssignedBlock(s->as.while_.body->as.block, assigned, declaredInside);
}

static void collectBlock(const Stmt *s,
                         std::vector<const BoundName *> &assigned,
                         std::vector<const BoundName *> &declaredInside) {
  collectAssignedBlock(s->as.block, assigned, declaredInside);
}

struct CollectEntry {
  StmtKind kind;
  CollectFn fn;
};

static const CollectEntry kCollectEntries[] = {
    {STMT_DECL, collectDecl},     {STMT_DESTRUCTURE, collectDestructure},
    {STMT_ASSIGN, collectAssign}, {STMT_IF, collectCond},
    {STMT_WHERE, collectCond},    {STMT_FOR, collectFor},
    {STMT_WHILE, collectWhile},   {STMT_BLOCK, collectBlock},
};

static void collectAssigned(const Stmt *s,
                            std::vector<const BoundName *> &assigned,
                            std::vector<const BoundName *> &declaredInside) {
  for (const CollectEntry &entry : kCollectEntries) {
    if (entry.kind != s->kind)
      continue;
    entry.fn(s, assigned, declaredInside);
    return;
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

static void fillCarryTypesAndInputs(const std::vector<Carry> &carries,
                                    std::vector<MlirType> &resultTypes,
                                    std::vector<MlirValue> &carryIn) {
  for (const Carry &cy : carries) {
    resultTypes.push_back(mlirValueGetType(cy.incoming));
    carryIn.push_back(cy.incoming);
  }
}

static MlirBlock appendEmptyBlock(MlirRegion region) {
  MlirBlock block = mlirBlockCreate(0, nullptr, nullptr);
  mlirRegionAppendOwnedBlock(region, block);
  return block;
}

static void rebindCarriesFromOp(LowerCtx &lc, const std::vector<Carry> &carries,
                                MlirOperation op) {
  for (size_t i = 0; i < carries.size(); ++i) {
    Binding *b = lookup(lc, carries[i].name, carries[i].name_len);
    if (b)
      b->value = mlirOperationGetResult(op, (intptr_t)i);
  }
}

static bool lowerRegionBody(LowerCtx &lc, MlirBlock block, const Stmt *body,
                            const std::vector<Carry> &carries,
                            const std::vector<MlirValue> &carryIn,
                            bool waveRegion,
                            std::vector<MlirRegion> cleanupRegions) {
  std::vector<MlirValue> finals;
  if (!runBody(lc, block, body, carries, carryIn, finals)) {
    destroyRegions(cleanupRegions);
    return false;
  }
  emitYield(lc, block, waveRegion, finals);
  return true;
}

static bool lowerElseRegion(LowerCtx &lc, MlirBlock block, const Stmt *body,
                            const std::vector<Carry> &carries,
                            const std::vector<MlirValue> &carryIn,
                            bool waveRegion,
                            std::vector<MlirRegion> cleanupRegions) {
  std::vector<MlirValue> finals;
  if (body != nullptr) {
    if (!runBody(lc, block, body, carries, carryIn, finals)) {
      destroyRegions(cleanupRegions);
      return false;
    }
  } else {
    finals = carryIn;
  }
  emitYield(lc, block, waveRegion, finals);
  return true;
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
  std::vector<MlirValue> carryIn;
  fillCarryTypesAndInputs(carries, resultTypes, carryIn);

  MlirRegion thenRegion = mlirRegionCreate();
  MlirBlock thenBlk = appendEmptyBlock(thenRegion);
  MlirRegion elseRegion = mlirRegionCreate();
  MlirBlock elseBlk{nullptr};
  bool haveElse = (c.else_block != nullptr) || !carries.empty();
  if (haveElse)
    elseBlk = appendEmptyBlock(elseRegion);

  if (!lowerRegionBody(lc, thenBlk, c.then_block, carries, carryIn,
                       /*waveRegion=*/true, {thenRegion, elseRegion}))
    return false;
  if (haveElse) {
    if (!lowerElseRegion(lc, elseBlk, c.else_block, carries, carryIn,
                         /*waveRegion=*/true, {thenRegion, elseRegion}))
      return false;
  }

  std::vector<MlirRegion> regions = {thenRegion, elseRegion};
  MlirOperation op =
      buildOp(lc, "wave.where", {mask}, resultTypes, {}, regions);
  if (mlirOperationIsNull(op))
    return false;
  rebindCarriesFromOp(lc, carries, op);
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
  std::vector<MlirValue> carryIn;
  fillCarryTypesAndInputs(carries, resultTypes, carryIn);

  MlirRegion thenRegion = mlirRegionCreate();
  MlirBlock thenBlk = appendEmptyBlock(thenRegion);
  MlirRegion elseRegion = mlirRegionCreate();
  bool haveElse = (c.else_block != nullptr) || !carries.empty();
  MlirBlock elseBlk{nullptr};
  if (haveElse)
    elseBlk = appendEmptyBlock(elseRegion);

  if (!lowerRegionBody(lc, thenBlk, c.then_block, carries, carryIn,
                       /*waveRegion=*/false, {thenRegion, elseRegion}))
    return false;
  if (haveElse) {
    if (!lowerElseRegion(lc, elseBlk, c.else_block, carries, carryIn,
                         /*waveRegion=*/false, {thenRegion, elseRegion}))
      return false;
  }

  std::vector<MlirRegion> regions = {thenRegion, elseRegion};
  MlirOperation op = buildOp(lc, "scf.if", {cond}, resultTypes, {}, regions);
  if (mlirOperationIsNull(op))
    return false;
  rebindCarriesFromOp(lc, carries, op);
  return true;
}

struct LoweredForHeader {
  MlirValue lb;
  MlirValue ub;
  MlirValue step;
  MlirType ivTy;
};

static bool lowerForHeader(LowerCtx &lc, const Stmt *s,
                           LoweredForHeader &header) {
  const StmtFor &f = s->as.for_;
  if (!lowerExpr(lc, f.lb, &header.lb) || !lowerExpr(lc, f.ub, &header.ub))
    return false;
  header.ivTy = lowerType(lc, f.iv_type);
  if (mlirTypeIsNull(header.ivTy)) {
    fail(lc, stmtSpan(s), "lowering: unsupported for induction-variable type");
    return false;
  }
  if (f.step) {
    if (!lowerExpr(lc, f.step, &header.step))
      return false;
  } else {
    header.step = makeIntConst(lc, header.ivTy, 1);
  }
  header.lb = castIndexIntScalar(lc, header.lb, header.ivTy, f.lb);
  header.ub = castIndexIntScalar(lc, header.ub, header.ivTy, f.ub);
  header.step = castIndexIntScalar(lc, header.step, header.ivTy, f.step);
  return true;
}

static void makeForBlockArgs(LowerCtx &lc, MlirType ivTy,
                             const std::vector<Carry> &carries,
                             std::vector<MlirType> &argTypes,
                             std::vector<MlirLocation> &argLocs) {
  argTypes.push_back(ivTy);
  argLocs.push_back(lc.loc);
  for (const Carry &cy : carries) {
    argTypes.push_back(mlirValueGetType(cy.incoming));
    argLocs.push_back(lc.loc);
  }
}

static MlirBlock createForBodyBlock(LowerCtx &lc, MlirType ivTy,
                                    const std::vector<Carry> &carries,
                                    MlirRegion region) {
  std::vector<MlirType> argTypes;
  std::vector<MlirLocation> argLocs;
  makeForBlockArgs(lc, ivTy, carries, argTypes, argLocs);
  MlirBlock body = mlirBlockCreate((intptr_t)argTypes.size(), argTypes.data(),
                                   argLocs.data());
  mlirRegionAppendOwnedBlock(region, body);
  return body;
}

static bool lowerForBody(LowerCtx &lc, const StmtFor &f, MlirBlock body,
                         const std::vector<Carry> &carries) {
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
  if (ok) {
    for (const Carry &cy : carries) {
      Binding *b = lookup(lc, cy.name, cy.name_len);
      finals.push_back(b ? b->value : cy.incoming);
    }
    buildOp(lc, "scf.yield", finals, {});
  }
  lc.env.resize(envMark);
  lc.block = saved;
  return ok;
}

static MlirOperation buildForOp(LowerCtx &lc, const LoweredForHeader &header,
                                MlirRegion region,
                                const std::vector<Carry> &carries,
                                const std::vector<MlirType> &resultTypes) {
  std::vector<MlirValue> operands = {header.lb, header.ub, header.step};
  for (const Carry &cy : carries)
    operands.push_back(cy.incoming);
  std::vector<MlirRegion> regions = {region};
  return buildOp(lc, "scf.for", operands, resultTypes, {}, regions);
}

static bool lowerFor(LowerCtx &lc, const Stmt *s) {
  const StmtFor &f = s->as.for_;
  LoweredForHeader header;
  if (!lowerForHeader(lc, s, header))
    return false;

  std::vector<Carry> carries = computeCarries(lc, f.body);
  std::vector<MlirType> resultTypes;
  for (const Carry &cy : carries)
    resultTypes.push_back(mlirValueGetType(cy.incoming));
  MlirRegion region = mlirRegionCreate();
  MlirBlock body = createForBodyBlock(lc, header.ivTy, carries, region);
  if (!lowerForBody(lc, f, body, carries)) {
    destroyRegions({region});
    return false;
  }

  MlirOperation op = buildForOp(lc, header, region, carries, resultTypes);
  if (mlirOperationIsNull(op))
    return false;
  rebindCarriesFromOp(lc, carries, op);
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

static bool lowerDeclStmt(LowerCtx &lc, const Stmt *s) {
  MlirValue v;
  if (!lowerExpr(lc, s->as.decl.init, &v))
    return false;
  MlirType declTy = lowerType(lc, s->as.decl.type);
  if (!mlirTypeIsNull(declTy))
    v = coerceToType(lc, v, declTy);
  bindNew(lc, s->as.decl.name.name, s->as.decl.name.name_len, v);
  return true;
}

static bool lowerDestructureStmt(LowerCtx &lc, const Stmt *s) {
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

static void buildIdentExpr(const StmtAssign &a, Expr &lhsE) {
  memset(&lhsE, 0, sizeof(lhsE));
  lhsE.kind = EXPR_IDENT;
  lhsE.span = a.target.span;
  lhsE.as.ident.name = a.target.name;
  lhsE.as.ident.name_len = a.target.name_len;
  lhsE.sema_type = nullptr;
}

static bool lowerCompoundAssign(LowerCtx &lc, const Stmt *s, Expr &lhsE,
                                MlirValue *rhs) {
  const StmtAssign &a = s->as.assign;
  TokenKind binop = compoundToBinop(a.op);
  if (binop == TOK_EOF) {
    fail(lc, stmtSpan(s), "lowering: unsupported compound assignment");
    return false;
  }
  buildIdentExpr(a, lhsE);

  Expr binE;
  memset(&binE, 0, sizeof(binE));
  binE.kind = EXPR_BINARY;
  binE.span = stmtSpan(s);
  binE.as.binary.op = binop;
  binE.as.binary.lhs = &lhsE;
  binE.as.binary.rhs = a.value;
  binE.sema_type = nullptr;
  return lowerBinary(lc, &binE, rhs);
}

static bool lowerAssignRhs(LowerCtx &lc, const Stmt *s, MlirValue *rhs) {
  const StmtAssign &a = s->as.assign;
  if (a.op == TOK_ASSIGN)
    return lowerExpr(lc, a.value, rhs);
  Expr lhsE;
  return lowerCompoundAssign(lc, s, lhsE, rhs);
}

static bool lowerAssignStmt(LowerCtx &lc, const Stmt *s) {
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
  if (!lowerAssignRhs(lc, s, &rhs))
    return false;
  b = lookup(lc, a.target.name, a.target.name_len);
  if (b)
    b->value = coerceToType(lc, rhs, mlirValueGetType(b->value));
  return true;
}

static bool lowerCallStmt(LowerCtx &lc, const Stmt *s) {
  MlirValue ignored;
  return lowerExpr(lc, s->as.call.call, &ignored);
}

static bool lowerWhileStmt(LowerCtx &lc, const Stmt *s) {
  fail(lc, stmtSpan(s), "lowering: while loops not supported");
  return false;
}

using LowerStmtFn = bool (*)(LowerCtx &, const Stmt *);

struct LowerStmtEntry {
  StmtKind kind;
  LowerStmtFn lower;
};

static const LowerStmtEntry kLowerStmts[] = {
    {STMT_DECL, lowerDeclStmt},
    {STMT_DESTRUCTURE, lowerDestructureStmt},
    {STMT_ASSIGN, lowerAssignStmt},
    {STMT_CALL, lowerCallStmt},
    {STMT_IF, lowerIf},
    {STMT_WHERE, lowerWhere},
    {STMT_FOR, lowerFor},
    {STMT_WHILE, lowerWhileStmt},
    {STMT_BLOCK, lowerBlock},
};

static bool lowerStmtImpl(LowerCtx &lc, const Stmt *s) {
  for (const LowerStmtEntry &entry : kLowerStmts)
    if (entry.kind == s->kind)
      return entry.lower(lc, s);
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
