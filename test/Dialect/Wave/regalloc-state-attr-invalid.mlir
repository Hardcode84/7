// RUN: wave-opt --split-input-file --verify-diagnostics %s

// expected-error @+1 {{unsupported regalloc state version 2}}
module attributes {test.state = #wave.regalloc_state<version = 2, ops = [], op_paths = [], values = [], value_paths = [], value_ranges = [], alias_sets = [], alias_members = []>} {
}

// -----

// expected-error @+1 {{regalloc op slab has partial record}}
module attributes {test.state = #wave.regalloc_state<version = 1, ops = [0], op_paths = [], values = [], value_paths = [], value_ranges = [], alias_sets = [], alias_members = []>} {
}

// -----

// expected-error @+1 {{regalloc value has invalid register class}}
module attributes {test.state = #wave.regalloc_state<version = 1, ops = [0, 1], op_paths = [0], values = [3, 1, -1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1], value_paths = [0], value_ranges = [0, 0], alias_sets = [1, 1, 0, 1], alias_members = [0]>} {
}

// -----

// expected-error @+1 {{regalloc alias-set width mismatches members}}
module attributes {test.state = #wave.regalloc_state<version = 1, ops = [0, 1], op_paths = [0], values = [1, 1, -1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1], value_paths = [0], value_ranges = [0, 0], alias_sets = [1, 2, 0, 1], alias_members = [0]>} {
}
