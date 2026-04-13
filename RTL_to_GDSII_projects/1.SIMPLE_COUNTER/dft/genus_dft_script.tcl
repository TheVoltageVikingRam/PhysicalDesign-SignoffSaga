#set_db init_lib_search_path /home/server2/design_kits/pd_cadence/BlockImplementation231/RAK_23.10_blockImplementation/LIBS/lib/max

set PDK_DIR "/home/server2/design_kits/cadence_dft/Stylus_21.1x_RAK/libs/GPDK045"

set_db init_lib_search_path $PDK_DIR/gsclib045/timing

set_db init_hdl_search_path /home/server2/Music/ram/counter
read_libs slow_vdd1v0_basicCells.lib


read_physical -lef "$PDK_DIR/gsclib045_tech/lef/gsclib045_tech.lef $PDK_DIR/gsclib045/lef/gsclib045_macro.lef"

read_hdl -language v2001 counter.v
elaborate
read_sdc ../constraints/constraints_top.sdc

#DFT setup pre-synthesis

set_db dft_scan_style muxed_scan
set_db dft_prefix dft_
define_test_signal -function shift_enable -name SE  -active high -create_port SE
check_dft_rules



set_db syn_generic_effort medium
syn_generic

set_db syn_map_effort medium
syn_map
set_db syn_opt_effort medium
syn_opt

check_dft_rules
set_db design:counter .dft_min_number_of_scan_chains 1
define_dft scan_chain -name top_chain -sdi scan_in -sdo scan_out -create_ports


#The following commands are used to remove the assign statements and replace it with BUFX20 
#in the synthesized netlist
set_db remove_assigns true
add_assign_buffer_options -ports scan_out -buffer_or_inverter BUFX20

connect_scan_chains -auto_create_chains
syn_opt

report_scan_chains > reports/report_dft_chains.rpt

#Outputs
write_dft_atpg -library ../lib/slow_vddd1v0_basiccells.v

write_hdl > outputs/counter_netlist_dft.v
write_sdc > outputs/counter_sdc_dft.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delays.sdf
write_scandef > outputs/counter_scanDEF.scandef
