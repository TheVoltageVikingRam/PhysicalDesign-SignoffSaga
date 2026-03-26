                                                               
set_db init_lib_search_path /home/server2/cadence/installs/DDI231/INNOVUS231/share/FoundationFlows/EXAMPLES/INNOVUS/DESIGN/GPDK/LIBS/GPDK045/timing/
set_db init_hdl_search_path /home/server2/Music/ram/counter
read_libs "fast.lib  slow.lib  typical.lib"

read_hdl counter.v
elaborate
read_sdc ../constraints/constraints_top.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
syn_map
syn_opt

#reports

report_timing > reports/report_timing.rpt
report_power > reports/report_area.rpt
report_area > reports/report_area.rpt
report_qor > reports/report_qor.rpt

#Outputs

write_hdl > outputs/counter_netlist.v
write_sdc > outputs/counter_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delays.sdf






