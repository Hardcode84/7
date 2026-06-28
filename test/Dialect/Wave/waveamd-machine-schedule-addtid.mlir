// RUN: wave-opt %s --waveamd-machine-schedule-report='print-classes=1 print-deps=1 print-score=1' 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @addtid_schedule(%base: !waveamdmachine.reg<sgpr, 1>,
                           %data: !waveamdmachine.reg<vgpr, 1>) {
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %tok1 = waveamdmachine.ds_store_addtid_b32 %m0, %data after %tok0 offset 16
      : (!waveamdmachine.m0, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %loaded, %tok2 = waveamdmachine.ds_load_addtid_b32 %m0 after %tok1 offset 16
      : (!waveamdmachine.m0, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  return
}
}

// CHECK: waveamd-machine-schedule-report op func=addtid_schedule region=0 index=0 name=waveamdmachine.s_mov_m0 class=WriteSALU fu=SALU
// CHECK: waveamd-machine-schedule-report op func=addtid_schedule region=0 index=1 name=waveamdmachine.token class=NoInst
// CHECK: waveamd-machine-schedule-report op func=addtid_schedule region=0 index=2 name=waveamdmachine.ds_store_addtid_b32 class=WriteLDS fu=LGKM
// CHECK: waveamd-machine-schedule-report op func=addtid_schedule region=0 index=3 name=waveamdmachine.ds_load_addtid_b32 class=WriteLDS fu=LGKM
// CHECK: waveamd-machine-schedule-report deps func=addtid_schedule region=0 nodes=4
// CHECK: waveamd-machine-schedule-report edge region=0 kind=ssa 0->2 src=waveamdmachine.s_mov_m0 dst=waveamdmachine.ds_store_addtid_b32
// CHECK: waveamd-machine-schedule-report edge region=0 kind=mem_token 1->2 src=waveamdmachine.token dst=waveamdmachine.ds_store_addtid_b32
// CHECK: waveamd-machine-schedule-report edge region=0 kind=ssa 0->3 src=waveamdmachine.s_mov_m0 dst=waveamdmachine.ds_load_addtid_b32
// CHECK: waveamd-machine-schedule-report edge region=0 kind=mem_token 2->3 src=waveamdmachine.ds_store_addtid_b32 dst=waveamdmachine.ds_load_addtid_b32
// CHECK: waveamd-machine-schedule-report score func=addtid_schedule region=0 order=original cycles={{[0-9]+}} issued_ops=3
