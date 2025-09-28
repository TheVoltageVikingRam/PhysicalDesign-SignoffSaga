# ####################################################################

#  Created by Genus(TM) Synthesis Solution 23.13-s073_1 on Sun Sep 28 16:53:14 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design demux

create_clock -name "VIRTUAL_CLK" -period 2.0 -waveform {0.0 1.0} 
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 0.5 [get_ports in]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 0.5 [get_ports {s[1]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 0.5 [get_ports {s[0]}]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 0.6 [get_ports y1]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 0.6 [get_ports y2]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 0.6 [get_ports y3]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 0.6 [get_ports y4]
set_max_fanout 16.000 [current_design]
set_max_transition 0.2 [current_design]
set_wire_load_mode "enclosed"
