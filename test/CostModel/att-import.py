# ruff: noqa: E501
# RUN: %PYTHON %S/../../tools/wave-att-import/wave-att-import.py --att-dir %S/Inputs/att-sample --objdump %S/Inputs/att-objdump.txt --summary | FileCheck %s

# CHECK: summary:
# CHECK:   static_instructions: 4
# CHECK:   stats_rows: 3
# CHECK:   stats_resolved: 2
# CHECK:   stats_unresolved: 1
# CHECK:   code_json_files: 1
# CHECK:   code_lines: 2
# CHECK:   wave_files: 1
# CHECK:   wave_rows: 4
# CHECK:   wave_resolved: 2
# CHECK:   wave_unresolved: 2

# CHECK: pc_hex,pc_dec,instruction,mnemonic,class,model_latency,static_index,att_stats_hitcount,att_stats_avg_latency,att_stats_avg_stall,att_stats_idle_total,wave_hitcount,wave_avg_duration,wave_avg_stall,wave_first_time_avg
# CHECK: 0x1600,5632,"s_load_b64 s[6:7], s[0:1], null",s_load_b64,WriteSMEM,20,0,2,10.0,0.0,7.0,1,1.0,0.0,100.0
# CHECK: 0x1608,5640,s_waitcnt lgkmcnt(0),s_waitcnt,WaitcntPseudo,0,1,2,30.0,29.0,0.0,1,31.0,30.0,101.0
# CHECK: 0x160c,5644,"v_and_b32_e32 v1, 15, v0",v_and_b32_e32,Write32Bit,5,2,,,,,,,,
# CHECK: 0x1610,5648,s_endpgm,s_endpgm,WriteBranch,32,3,,,,,,,,
