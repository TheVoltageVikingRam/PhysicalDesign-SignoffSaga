# Cadence Genus(TM) Synthesis Solution, Version 23.13-s073_1, built Nov  8 2024 10:01:49

# Date: Sun Sep 28 20:26:10 2025
# Host: hostname1 (x86_64 w/Linux 4.18.0-553.74.1.el8_10.x86_64) (10cores*40cpus*2physical cpus*Intel(R) Xeon(R) CPU E5-2658 v2 @ 2.40GHz 25600KB)
# OS:   Rocky Linux 8.10 (Green Obsidian)

ls
read_hdl full_adder.v
set_db lib_search_path /home/server2/cadence/installs/DDI231/INNOVUS231/share/FoundationFlows/EXAMPLES/INNOVUS/DESIGN/GPDK/LIBS/GPDK045/timing
set_db library "slow.lib typical.lib fast.lib"
read_hdl full_adder.v
elaborate full_adder
ls
nano full_adder_constraints.sdc
nano full_adder_constraints.sdc
nano full_adder_constraints.sdc
read_sdc full_adder_constraints.sdc
check_design
check_timing
ls
nano full_adder_constraints.sdc
read_sdc full_adder_constraints.sdc
check_design
check_timing
syn_gen
syn_map
syn_opt
report_area
report_timing
report_property -all target_library
report_property -all link_library
report_property -all timing_library
report_clocks
report_sdc_files
read_sdc /full/path/your_constraints.sdc
create_clock -name clk -period 2.0 -waveform {0.0 1.0} [get_ports clk]
report_timing -unconstrained -max_paths 50
report_timing -sort_by slack -max_paths 20
report_cells -hierarchical -show_attributes area
report_area -hierarchical
report_timing -unconstrained -max_paths 50
report_timing -unconstrained -max_paths 50
report_clocks
report_sdc_files
report_timing -unconstrained -max_paths 50
report_timimg sort_by slack -max_paths 50
report_timing sort_by slack -max_paths 50
syn_opt
report_area
report_clocks
gui_show
write_hdl -mapped > fa_gate_mapped_hdl.v
gui_show
