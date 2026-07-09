##########################
## Innovus Synthesis Flow
##########################

#This works only if there is INVS540 license else use the db or netlist handoff from a place and route tool like Genus

# Reading MMMC File

read_mmmc dtmf_syn.mmmc

#Reading LEF file

read_physical -lef {../lef/all.lef}

#Elaborate Design 

elaborate_design -script hdl.tcl

init_design


#Read_io_file dtmf.io


read_floorplan dtmf_power_syn.fp

#DFT setup

define_test_signal -name test_mode -active high -function test_mode test_mode

define_test_signal -name scan_en -active high -function shift_enable -default scan_en


#Synthesize 

synthesize_design

dft_design -script dft_script.tcl

#Writing synthesized netlist

write_netlist inv_syn_dtmf_dft.v

##########################place_opt_design ############################

#place_opt_design
#write_db dbs/place.db


#######################clock_opt_design#################################


#clock_opt_design
#write_db dbs/clock.db


############################route_opt_design##############################

#route_opt_design
#write_db dbs/route.db




gui_show




