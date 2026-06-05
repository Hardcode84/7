## C Frontend Rules

- C front is C99: `-std=c99 -pedantic -Werror`, no GNU/clang extensions.
- Core stages link libc only. No MLIR, ixsimpl, or third-party deps in lexer,
  parser, AST, sema, diagnostics, or AST dump.
- Source is ASCII. Lexer character classes are ASCII; do not add Unicode
  syntax or diagnostics.
- File I/O stays in the driver. Core stages operate on caller-provided buffers
  and explicit context structs.
- C++ appears only in the MLIR lowering bridge. Build IR through MLIR C API and
  Wave CAPI; keep lexer/parser/sema C-only.
- Arena owns frontend memory. AST nodes, token arrays, diagnostics, and scratch
  allocations come from arenas and are freed wholesale.
- No per-node `malloc`/`free`. The arena backing allocation is the heap surface.
- Recursion is bounded with explicit depth counters. Pathological input returns
  diagnostics, not stack overflow.
- No global mutable state. Thread arenas, diagnostics, symbol tables, depth
  counters, and MLIR context through explicit state.
- Test each stage at its own interface: lexer token stream, parser AST shape,
  sema accept/reject plus types, lowering IR, and driver e2e.
