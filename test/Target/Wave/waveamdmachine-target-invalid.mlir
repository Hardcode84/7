// RUN: wave-opt --waveamd-decompose-mem-tuples -split-input-file -verify-diagnostics %s

// expected-error @below {{waveamd-decompose-mem-tuples requires waveamdmachine.target to be a string attribute}}
module attributes {waveamdmachine.target = 1 : i64} {
}

// -----

// expected-error @below {{malformed waveamdmachine.target `amdgcn-amd-amdhsa--gfx1100--bad`; expected `<amdgcn-triple>--<chip>[:sramecc(+|-)][:xnack(+|-)]`}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100--bad"} {
}

// -----

// expected-error @below {{malformed waveamdmachine.target `amdgcn-amd-amdhsa`; expected `<amdgcn-triple>--<chip>[:sramecc(+|-)][:xnack(+|-)]`}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa"} {
}

// -----

// expected-error @below {{malformed waveamdmachine.target `x86_64-unknown-linux-gnu--gfx1100`; expected `<amdgcn-triple>--<chip>[:sramecc(+|-)][:xnack(+|-)]`}}
module attributes {waveamdmachine.target = "x86_64-unknown-linux-gnu--gfx1100"} {
}

// -----

// expected-error @below {{malformed waveamdmachine.target `amdgcn-amd-amdhsa--gfx950:sramecc`; expected `<amdgcn-triple>--<chip>[:sramecc(+|-)][:xnack(+|-)]`}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950:sramecc"} {
}

// -----

// expected-error @below {{malformed waveamdmachine.target `amdgcn-amd-amdhsa--gfx950:sramecc+:`; expected `<amdgcn-triple>--<chip>[:sramecc(+|-)][:xnack(+|-)]`}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950:sramecc+:"} {
}

// -----

// expected-error @below {{malformed waveamdmachine.target `amdgcn-amd-amdhsa--gfx950:sramecc+:sramecc-`; expected `<amdgcn-triple>--<chip>[:sramecc(+|-)][:xnack(+|-)]`}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950:sramecc+:sramecc-"} {
}
