/*===- arena_test.c - Unit tests for the arena allocator ------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Real checks on the arena contract:
 * allocation returns usable distinct memory, the backing region is
 * 4 KiB aligned, sub-allocations honor their requested alignment, reset
 * rewinds the cursor, destroy frees, and two arenas are independent.
 * Exercised standalone via the cc one-liner in the task and through
 * CMake (arena_test target).
 *
 * The checks use a custom CHECK macro, NOT assert(): assert() is a no-op
 * under -DNDEBUG (which CMake sets in Release builds), which would
 * silently turn this into a test that asserts nothing. CHECK always
 * evaluates its condition and aborts with a nonzero status on failure,
 * in any build type, so the test is meaningful everywhere. No OS calls
 * beyond stdio for the failure message and the arena's single malloc.
 */

#include "arena.h"

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Running count of failures; main() returns nonzero if any tripped. */
static int g_failures;

/* CHECK(cond, msg): always evaluates cond. On failure, prints where and
 * why and bumps the failure counter (survives -DNDEBUG, unlike assert).
 * Implemented as a do/while so it is a single statement. */
#define CHECK(cond, msg)                                                       \
  do {                                                                         \
    if (!(cond)) {                                                             \
      fprintf(stderr, "CHECK failed at %s:%d: %s (%s)\n", __FILE__, __LINE__,  \
              #cond, (msg));                                                   \
      g_failures++;                                                            \
    }                                                                          \
  } while (0)

/* True iff `p` is aligned to `align` (a power of two). */
static int is_aligned(const void *p, size_t align) {
  return ((uintptr_t)p & (uintptr_t)(align - 1u)) == 0u;
}

/* Basic allocation: non-NULL, writable, and the bump cursor advances by
 * at least the requested size. */
static void test_basic_alloc(void) {
  Arena a = arena_create(4096);
  unsigned char *p;
  size_t i;

  CHECK(a.raw != NULL, "arena_create must back a nonzero arena");
  CHECK(a.base != NULL, "usable base must be set");
  CHECK(a.used == 0, "fresh arena has an empty cursor");
  CHECK(a.capacity >= 4096, "capacity is at least the request");

  p = (unsigned char *)arena_alloc(&a, 100, 1);
  CHECK(p != NULL, "100 bytes must fit in a 4096 arena");
  CHECK(a.used >= 100, "cursor advanced by the request");

  /* The region must be writable and independent of later allocations. */
  for (i = 0; i < 100; i++)
    p[i] = (unsigned char)(i & 0xff);
  for (i = 0; i < 100; i++)
    CHECK(p[i] == (unsigned char)(i & 0xff), "written bytes persist");

  arena_destroy(&a);
}

/* The usable base is page-aligned to 4096, per the Implementation
 * rules. Repeat across several arenas because malloc alignment varies. */
static void test_page_alignment(void) {
  int trial;
  CHECK(ARENA_PAGE_ALIGN == 4096, "page align is fixed at 4 KiB");
  for (trial = 0; trial < 8; trial++) {
    Arena a = arena_create(8192);
    CHECK(a.base != NULL, "base set");
    CHECK(is_aligned(a.base, ARENA_PAGE_ALIGN),
          "usable base must be 4096-aligned");
    arena_destroy(&a);
  }
}

/* Sub-allocations honor their individual power-of-two alignments, even
 * when interleaved with odd-sized requests that desync the cursor. */
static void test_sub_alignment(void) {
  Arena a = arena_create(1u << 16);
  size_t aligns[6];
  size_t i;

  aligns[0] = 1;
  aligns[1] = 2;
  aligns[2] = 4;
  aligns[3] = 8;
  aligns[4] = 16;
  aligns[5] = 64;

  /* Burn an odd number of bytes so the cursor is not already aligned. */
  (void)arena_alloc(&a, 1, 1);

  for (i = 0; i < sizeof(aligns) / sizeof(aligns[0]); i++) {
    void *p = arena_alloc(&a, 24, aligns[i]);
    CHECK(p != NULL, "sub-aligned request must fit");
    CHECK(is_aligned(p, aligns[i]),
          "each allocation honors its requested alignment");
    /* Desync again before the next iteration. */
    (void)arena_alloc(&a, 3, 1);
  }

  arena_destroy(&a);
}

/* A zero-byte request returns a valid, aligned pointer and does not
 * fail on a live arena. */
static void test_zero_bytes(void) {
  Arena a = arena_create(4096);
  void *p = arena_alloc(&a, 0, 16);
  CHECK(p != NULL, "zero-byte alloc is valid on a live arena");
  CHECK(is_aligned(p, 16), "zero-byte alloc is still aligned");
  arena_destroy(&a);
}

/* reset() rewinds the cursor: the same address is handed out again, and
 * capacity is unchanged, without freeing the backing block. */
static void test_reset(void) {
  Arena a = arena_create(4096);
  void *first;
  void *again;
  size_t cap_before;

  cap_before = a.capacity;
  first = arena_alloc(&a, 256, 16);
  CHECK(first != NULL, "first alloc fits");
  CHECK(a.used >= 256, "cursor advanced");

  arena_reset(&a);
  CHECK(a.used == 0, "reset rewinds the cursor to zero");
  CHECK(a.capacity == cap_before, "reset preserves capacity");
  CHECK(a.raw != NULL, "reset does not free the backing block");

  again = arena_alloc(&a, 256, 16);
  CHECK(again == first, "post-reset alloc reuses the same address");

  arena_destroy(&a);
}

/* Over-capacity requests return NULL (fixed-capacity, no grow) and do
 * not corrupt the cursor for later in-bounds requests. */
static void test_overflow_policy(void) {
  Arena a = arena_create(1024);
  void *big;
  void *small;

  big = arena_alloc(&a, 1u << 20, 1); /* 1 MiB into a 1 KiB arena */
  CHECK(big == NULL, "request beyond capacity returns NULL, no grow");

  /* A reasonable request still succeeds afterwards. */
  small = arena_alloc(&a, 64, 8);
  CHECK(small != NULL, "a failed over-alloc must not break the arena");

  arena_destroy(&a);
}

/* Two arenas are fully independent: allocating from one does not move
 * the other's cursor, and their regions do not overlap. */
static void test_independence(void) {
  Arena a = arena_create(4096);
  Arena b = arena_create(4096);
  unsigned char *pa;
  unsigned char *pb;
  int disjoint;
  size_t a_used;

  pa = (unsigned char *)arena_alloc(&a, 512, 16);
  pb = (unsigned char *)arena_alloc(&b, 512, 16);
  CHECK(pa != NULL && pb != NULL, "both arenas allocate");

  /* Distinct backing blocks => non-overlapping 512-byte regions.
   * Compute the predicate first so the && / || precedence is explicit. */
  disjoint = (pa + 512 <= pb) || (pb + 512 <= pa);
  CHECK(disjoint, "independent arenas must not overlap");

  /* Allocating from b must not change a's cursor. */
  a_used = a.used;
  (void)arena_alloc(&b, 256, 8);
  CHECK(a.used == a_used, "arena b allocation leaves arena a untouched");

  /* Distinct fills stay distinct. */
  memset(pa, 0xAA, 512);
  memset(pb, 0xBB, 512);
  CHECK(pa[0] == 0xAA && pb[0] == 0xBB, "no cross-arena aliasing");

  arena_destroy(&a);
  arena_destroy(&b);
}

/* destroy() zeroes the handle so a second destroy is a no-op and a
 * post-destroy alloc safely returns NULL (no crash, no global state). */
static void test_destroy_safety(void) {
  Arena a = arena_create(4096);
  void *p;

  arena_destroy(&a);
  CHECK(a.raw == NULL, "destroy zeroes the handle");
  CHECK(a.base == NULL && a.capacity == 0 && a.used == 0,
        "destroy clears all fields");

  p = arena_alloc(&a, 16, 8);
  CHECK(p == NULL, "alloc on a destroyed arena returns NULL");

  arena_destroy(&a); /* second destroy must be safe. */
}

/* A zero-size create still yields a usable, page-aligned arena. */
static void test_zero_size_create(void) {
  Arena a = arena_create(0);
  void *p;

  CHECK(a.raw != NULL, "zero-size create rounds up to a usable arena");
  CHECK(is_aligned(a.base, ARENA_PAGE_ALIGN), "rounded arena is aligned");
  p = arena_alloc(&a, 8, 8);
  CHECK(p != NULL, "the rounded-up arena can satisfy a small request");
  arena_destroy(&a);
}

int main(void) {
  g_failures = 0;

  test_basic_alloc();
  test_page_alignment();
  test_sub_alignment();
  test_zero_bytes();
  test_reset();
  test_overflow_policy();
  test_independence();
  test_destroy_safety();
  test_zero_size_create();

  if (g_failures != 0) {
    fprintf(stderr, "arena_test: %d check(s) FAILED\n", g_failures);
    return EXIT_FAILURE;
  }
  printf("arena_test: all checks passed\n");
  return EXIT_SUCCESS;
}
