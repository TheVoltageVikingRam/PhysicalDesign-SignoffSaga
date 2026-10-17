set_db init_netlist_files ../physical_design/counter_netlist.v
set_db init_lef_files {../lef/gsclib045_tech.lef ../lef/gsclib045_macro.lef}
set_db init_power_nets VDD
set_db init_ground_nets VSS
set_db init_mmmc_files counter.view
read_mmmc counter.view
read_physical -lef {../lef/gsclib045_tech.lef ../lef/gsclub045_macro.lef}
read_netlist ../physical_design/counter_netlist.v -top counter
init_design

connect_global_net VDD -type pg_pin -pin_base_name VDD -inst_base_name *
connect_global_net VSS -type pg_pin -pin_base_name VSS -inst_base_name *

# Create floorplan
create_floorplan -core_margins_by die -site CoreSite -core_density_size 1 0.7 2.5 2.5 2.5 2.5


#Pin Assignment

read_io_file pins.io


# Power planning
