set_db init_lib_search_path /home/server2/design_kits/pd_cadence/BlockImplementation231/RAK_23.10_blockImplementation/LIBS/lib/max

set_db init_hdl_search_path /home/server2/Music/ram/counter
read_libs {slow.lib leon.lib} 

read_physical -lef /home/server2/design_kits/pd_cadence/BlockImplementation231/RAK_23.10_blockImplementation/LIBS/lef/gsclib045.fixed.lef


read_hdl -language v2001 counter.v
elaborate
read_sdc ../constraints/constraints_top.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
check_timing_intent
check_design -unresolved
syn_map
syn_opt

#reports

report_timing > reports/report_timing.rpt
report_power > reports/report_power.rpt
report_area > reports/report_area.rpt
report_qor > reports/report_qor.rpt

#Outputs

write_hdl > outputs/counter_netlist.v
write_sdc > outputs/counter_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delays.sdf

