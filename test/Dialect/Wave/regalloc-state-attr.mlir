// RUN: wave-opt %s | FileCheck %s

// CHECK: test.empty = #wave.regalloc_state<version = 1, ops = [], op_paths = [], values = [], value_paths = [], value_ranges = [], alias_sets = [], alias_members = []>
// CHECK: test.state = #wave.regalloc_state<version = 1, ops = [0, 1], op_paths = [0], values = [1, 1, -1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1], value_paths = [0], value_ranges = [0, 0], alias_sets = [1, 1, 0, 1], alias_members = [0]>
module attributes {
  test.empty = #wave.regalloc_state<
      version = 1,
      ops = [],
      op_paths = [],
      values = [],
      value_paths = [],
      value_ranges = [],
      alias_sets = [],
      alias_members = []>,
  test.state = #wave.regalloc_state<
      version = 1,
      ops = [0, 1],
      op_paths = [0],
      values = [1, 1, -1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1],
      value_paths = [0],
      value_ranges = [0, 0],
      alias_sets = [1, 1, 0, 1],
      alias_members = [0]>
} {
}
