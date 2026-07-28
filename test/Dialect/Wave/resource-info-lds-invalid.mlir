// RUN: wave-opt --waveamd-resource-info --split-input-file --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // expected-error @+1 {{waveamd-resource-info LDS usage 65537 bytes exceeds target-addressable capacity 65536 bytes}}
  func.func @fixed_overflow() attributes {
    wave.kernel,
    wave.lds_size = 65537 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  // expected-error @+1 {{waveamd-resource-info LDS usage 327681 bytes exceeds target-addressable capacity 327680 bytes}}
  func.func @gfx1250_lds_overflow() attributes {
    wave.kernel,
    wave.lds_size = 327681 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // expected-error @+1 {{waveamd-resource-info LDS usage 65537 bytes exceeds target-addressable capacity 65536 bytes}}
  func.func @dynamic_overflow() attributes {
    wave.kernel,
    wave.dynamic_lds_size = 65537 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // expected-error @+1 {{waveamd-resource-info LDS usage 65537 bytes exceeds target-addressable capacity 65536 bytes}}
  func.func @aggregate_overflow() attributes {
    wave.kernel,
    wave.dynamic_lds_size = 1 : i64,
    wave.lds_size = 65536 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // expected-error @+1 {{waveamd-resource-info LDS usage 65537 bytes exceeds target-addressable capacity 65536 bytes}}
  func.func @spill_overflow() attributes {
    wave.kernel,
    wave.lds_size = 65536 : i64,
    waveamdmachine.lds_spill_bytes = 1 : i64
  } {
    return
  }
}
