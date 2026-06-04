// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ROUNDTRIP-LABEL: func.func @gfx950_ds_memory_ops
// ROUNDTRIP: %[[ADDR:.*]] = waveamdmachine.v_mbcnt_lo
// ROUNDTRIP: %[[STORE:.*]] = waveamdmachine.ds_store_b8 %[[ADDR]], %[[ADDR]] offset 7
// ROUNDTRIP: %[[B4:.*]], %[[B4TOK:.*]] = waveamdmachine.ds_read_tr_b64_b4 %[[ADDR]] after %[[STORE]] offset 16
// ROUNDTRIP: %[[B8:.*]], %[[B8TOK:.*]] = waveamdmachine.ds_read_tr_b64_b8 %[[ADDR]] after %[[B4TOK]] offset 32

// ASM-LABEL: gfx950_ds_memory_ops:
// ASM: ds_write_b8 {{v[0-9]+}}, {{v[0-9]+}} offset:7
// ASM: ds_read_b64_tr_b4 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:16
// ASM: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:32
// ASM: s_endpgm
func.func @gfx950_ds_memory_ops() attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %store = waveamdmachine.ds_store_b8 %addr, %addr offset 7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
  %b4, %b4_tok = waveamdmachine.ds_read_tr_b64_b4 %addr after %store offset 16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %b8, %b8_tok = waveamdmachine.ds_read_tr_b64_b8 %addr after %b4_tok offset 32
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}
