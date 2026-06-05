# wave C-family frontend: v1 grammar

Stage-0 artifact for [CFrontendDesign.md](CFrontendDesign.md). Covers the
v1 subset: saxpy + `if`/`where`/`for`/`while`, explicit memory tokens, and
fragment/MMA primitives. No user functions beyond `kernel`, no
value-returning kernels.

Notation: ISO EBNF. `=` defines, `,` concatenates, `|` alternates, `{ }`
is zero-or-more, `[ ]` is optional, `" "` is a terminal, `(* *)` is a
comment. Lexer rules and the context-sensitive bits are in
[Disambiguation](#disambiguation); the CFG below is LL(1) with one token of
lookahead after a leading identifier (assign vs call, rule 7).

## Lexical

```
letter     = "a".."z" | "A".."Z" ;   digit = "0".."9" ;
hexdigit   = digit | "a".."f" | "A".."F" ;   (* 'any' = source char, 'newline' = EOL *)

comment    = "//" , { any - newline }
           | "/*" , { any } , "*/" ;                  (* not nested *)

ident      = ( letter | "_" ) , { letter | digit | "_" } ;

int_lit    = dec_lit | hex_lit ;
dec_lit    = digit , { digit } ;
hex_lit    = "0x" , hexdigit , { hexdigit } ;
float_lit  = digit , { digit } , ( "." , digit , { digit } , [ exp ] | exp ) , [ "f" ] ;
exp        = ( "e" | "E" ) , [ "+" | "-" ] , digit , { digit } ;
```

A `.` starts a fraction only when immediately followed by a digit, so a
float always has a digit on both sides of the dot (`0.5`, not `.5` or
`0.`). This is what frees `..` for ranges (see Disambiguation).

Reserved words (cannot be identifiers):

```
kernel  void  auto
if  else  where  otherwise  for  in  step  while
after
bool  half  float  index  token
int8_t  int16_t  int32_t  int64_t  uint8_t  uint16_t  uint32_t  uint64_t
simd  mask  vector  fragment  shared
```

Builtins (`lane_id`, `subgroup_id`, `wave_id_in_grid`, `workgroup_id`,
`workitem_id`, `load`, `store`, `barrier`, `wait`, `join`, `lds_base`,
`index_cast`, `cast`, `read_first`, `fragment_unpack`, and the explicit
`mma_*` names) are **predeclared identifiers**, not reserved words; sema
resolves them. Generic builtins (take `<...>`): `lane_id<W>`, `cast<T>`,
`lds_base<T>`, `fragment_fill<T>`, `fragment_pack<T>`. The empty-token seed
is spelled `token()` -- the `token` type used as a nullary constructor (see
Grammar).

Punctuation and operators:

```
( ) { } [ ] [[  ]]  < >  , ; *  ..  =
+ - * / %  << >>  < <= > >= == !=  & | ^ ~ !  && ||
+= -= *= /= &= |= ^= <<= >>=
```

## Grammar

```
program    = { kernel } ;

kernel     = "kernel" , { attribute } , "void" , ident ,
             "(" , [ params ] , ")" , block ;
attribute  = "[[" , ident , [ "(" , int_lit , ")" ] , "]]" ;
params     = param , { "," , param } ;
param      = type , ident ;

type       = [ "shared" ] , base_type , [ "*" ] ;  (* one optional star; 'shared' needs the star (sema) *)
base_type  = scalar_type
           | "index"
           | "token"
           | "simd"   , "<" , type , "," , int_lit , ">"
           | "mask"   , "<" , int_lit , ">"
           | "vector" , "<" , type , "," , int_lit , ">"
           | "fragment" , "<" , int_lit , "," , type , ","
                          int_lit , "," , int_lit , ","
                          int_lit , "," , int_lit , ">" ;
scalar_type= "bool" | "float" | "half"
           | "int8_t"  | "int16_t"  | "int32_t"  | "int64_t"
           | "uint8_t" | "uint16_t" | "uint32_t" | "uint64_t" ;

block      = "{" , { stmt } , "}" ;
stmt       = decl_stmt
           | assign_stmt
           | call_stmt
           | if_stmt
           | where_stmt
           | for_stmt
           | while_stmt
           | block ;

decl_stmt  = type , ident , "=" , expr , ";"
           | "auto" , "[" , ident , { "," , ident } , "]" , "=" , expr , ";" ;
assign_stmt= ident , assign_op , expr , ";" ;
assign_op  = "=" | "+=" | "-=" | "*=" | "/=" | "&=" | "|=" | "^=" | "<<=" | ">>=" ;
call_stmt  = call , ";" ;

if_stmt    = "if"    , "(" , expr , ")" , block , [ "else"      , block ] ;
where_stmt = "where" , "(" , expr , ")" , block , [ "otherwise" , block ] ;
while_stmt = "while" , "(" , expr , ")" , block ;
for_stmt   = "for" , iv_type , ident , "in" , expr , ".." , expr ,
             [ "step" , expr ] , block ;
iv_type    = "index"                            (* uniform signless int or index *)
           | "int8_t"  | "int16_t"  | "int32_t"  | "int64_t"
           | "uint8_t" | "uint16_t" | "uint32_t" | "uint64_t" ;

expr       = unary , { binop , unary } ;       (* precedence: see table *)
unary      = [ "-" | "!" | "~" ] , postfix ;
postfix    = primary , { call_tail } ;
call_tail  = [ "<" , garg , { "," , garg } , ">" ] ,
             "(" , [ args ] , [ "after" , expr ] , ")" ;
garg       = type | int_lit ;
args       = expr , { "," , expr } ;
primary    = int_lit | float_lit | ident
           | "token" , "(" , ")"               (* empty-token seed -> wave.token *)
           | "(" , expr , ")" ;

call       = ident , call_tail ;               (* must contain a "(" ... ")" *)
binop      = "*" | "/" | "%" | "+" | "-" | "<<" | ">>"
           | "<" | "<=" | ">" | ">=" | "==" | "!="
           | "&" | "^" | "|" | "&&" | "||" ;
```

`expr = unary , { binop , unary }` is ambiguous on its own; precedence
climbing with the table below resolves it.

## Operator precedence

High to low; all binary operators are left-associative. Unary `-`/`!`/`~`
and the postfix `call_tail` bind tighter than any binary operator.

```
1   postfix   f(...)   f<...>(...)        (call, generic call)
2   unary     - ! ~
3   * / %
4   + -
5   << >>
6   < <= > >=
7   == !=
8   &
9   ^
10  |
11  &&
12  ||
```

## Disambiguation

1. **No typedef ambiguity.** Types are a closed keyword set -- there are no
   user-defined type names in v1. A statement that starts with a type
   keyword is a `decl_stmt`; one that starts with an identifier, literal, or
   `(` is an `assign_stmt` or `call_stmt`. So C's lexer hack does not arise,
   and `a * b` is always multiplication (never a declaration).

2. **`<` is type-args or less-than, by the preceding token.** `<` opens a
   type/generic argument list only after a type keyword (`simd`, `mask`,
   `vector`, `fragment`) or a predeclared generic builtin (`lane_id`,
   `workgroup_id`, `workitem_id`, `cast`, `lds_base`, `fragment_fill`,
   `fragment_pack`).
   Everywhere else `<` is the comparison
   operator. The trigger set is fixed and known to the parser, so one token
   of lookahead suffices: `simd<...>`, `lane_id<32>(...)`, `cast<float>(x)`
   parse as generics; `i < n` parses as a compare.

3. **`..` vs float.** A `.` is a float fraction only when followed by a
   digit; `..` is always the range token (maximal munch). So `0..n` lexes
   `0` `..` `n`, while `0.5` is one float. Range bounds are full `expr`s,
   but `..` is not a `binop`, so `expr` stops before it inside a `for`.

4. **`auto` only destructures.** `auto` is always followed by `[ ident {,
   ident} ]` -- it is not general type inference. `auto [v, t] = load(...)`
   binds the (value, token) result; one production, no C++ needed.

5. **`after` is reserved**, so it terminates the preceding argument `expr`
   inside a `call_tail` and introduces the dependency token:
   `load(x + i after t)` -> args `[x+i]`, dep `t`.

6. **Dangling else.** `else` / `otherwise` binds to the nearest unmatched
   `if` / `where`.

7. **Statement-leading identifier.** A statement beginning with an identifier
   is an `assign_stmt` if the next token is an `assign_op`, else a
   `call_stmt`, distinguished by the eventual `(` (a generic builtin may
   interpose `<...>` per rule 2). A leading-identifier `<` on a non-generic
   name is the compare operator (rule 2), so `a < b;` is not a statement and
   parse-errors. The `assign_op`-vs-`(`/`<` lookahead resolves it.

8. **`>>` in nested args.** A `>>` adjacent to an open type/generic-args
   context is re-split into two `>` close tokens (the C++11 rule).

## Sema-only rules (not in the CFG)

- `shared` requires at least one `*`; a `shared` non-pointer is a type error.
- Attributes are a closed set: `amdgpu_wave_size(int)` and
  `amdgpu_lds_size(int)`, each requiring its int; other names are errors.
- `if` takes `bool`, `where` takes `mask<W>` (the checker rejects the other);
  the `for` IV is `int`/`index` (`iv_type`); `lane_id<W>`/`simd<T,W>`/
  `mask<W>` all use the kernel `W` from `[[amdgpu_wave_size(W)]]` (the
  backend separately validates `W` == target wavefront).

## Worked coverage

The saxpy, the LDS round-trip, and the carried-loop snippets in
CFrontendDesign.md all parse under this grammar. The spots that exercise
the rules above:

```c
simd<uint32_t, 32> i = wave * 32 + lane;   // rule 2 (simd<...>), rule 1
mask<32> active = i < n;                   // rule 2: 'i < n' is compare, not generic
for index k in 0..K step BK { ... }        // rule 3: '0..K'; iv_type restricts the IV
auto [v, t1] = load(p after t);            // rule 4 + rule 5
store(scratch, x + i after t);             // value-first; args [scratch, x+i], dep t
shared half *lds = lds_base<half>(0);      // 'shared' qualifier; lds_base<T> generic (rule 2)
simd<float,32> f = cast<float>(xv);        // rule 2: cast<...> generic
token z = token();                         // token() seed: reserved type as nullary ctor
fragment<2,float,16,16,32,8> acc = fragment_fill<fragment<2,float,16,16,32,8>>(0);
```

## Not in v1 (grammar)

- User-defined (non-`kernel`) functions; value-returning kernels / `return`.
- The `-> t` load-token clause (alternative to `auto [v,t]`); the spec
  prefers destructuring, so it is omitted here.
- Arrays / subscript `[]` (outside destructuring), structs, member access.
- General templates/generics beyond the fixed type constructors and the
  generic builtins (`lane_id`/`cast`/`lds_base`/`fragment_fill`/
  `fragment_pack`).
- No raw pointer deref/address-of (`*p`, `&x`) and no `a[i]` subscript:
  pointers are read/written only via `load`/`store`.
- No `?:` ternary (use `where`/`if`), no comma operator, no `sizeof`, no
  `++`/`--`, no unary `+`; one prefix unary only (`- ! ~`).
- Assignment is a statement: single-name LHS, no chaining (`a = b = c`), no
  assignment in conditions.
- Preprocessor (`#include`/`#define`): not part of the language.
```
