// RUN: wave-opt --waveamd-decompose-mem-tuples -split-input-file -verify-diagnostics %s

// expected-error @below {{malformed waveamdmachine.target `amdgcn-amd-amdhsa--gfx1100--bad`; expected `<amdgcn-triple>--<chip>`}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100--bad"} {
}

// -----

// expected-error @below {{malformed waveamdmachine.target `amdgcn-amd-amdhsa`; expected `<amdgcn-triple>--<chip>`}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa"} {
}

// -----

// expected-error @below {{malformed waveamdmachine.target `x86_64-unknown-linux-gnu--gfx1100`; expected `<amdgcn-triple>--<chip>`}}
module attributes {waveamdmachine.target = "x86_64-unknown-linux-gnu--gfx1100"} {
}
