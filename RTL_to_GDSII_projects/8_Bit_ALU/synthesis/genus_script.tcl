set PDK_DIR "/home/server2/design_kits/cadence_dft/Stylus_21.1x_RAK/libs/GPDK045"
set_db init_lib_search_path $PDK_DIR/gsclib045/timing

set_db init_hdl_search_path ../

read_libs slow_vdd1v0_basicCells.lib
read_physical -lef "$PDK_DIR/gsclib045_tech/lef/gsclib045_tech.lef $PDK_DIR/gsclib045/lef/gsclib045_macro.lef"

read_hdl -language v2001 alu.v

elaborate

read_sdc ../constraints/constraints_genus.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
check_timing_intent
check_design -unresolved
syn_map
syn_opt


#Reports

report_timing  >  reports/report_timing.rpt
report_power > reports/report_power.rpt
report_area > reports/report_area.rpt
report_qor > reports/report_qor.rpt


#Outputs

write_hdl > outputs/alu_netlist.v
write_sdc > outputs/alu_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delay.sdf
