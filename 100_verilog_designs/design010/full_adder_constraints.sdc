set_time_format -unit ns -decimal_places 3

set_operating_conditions -name TT_1V 
create_clock -name clk -period 10.0 -waveform {0.0 5.0} [get_ports clk]


set_clock_uncertainty -setup 0.1 [get_clocks clk]
set_clock_uncertainty -hold 0.05 [get_clocks clk]

set_input_delay -clock [get_clocks clk] -max 1.5 [get_ports {pin_in*} ]
set_output_delay -clock [get_clocks clk] -min 0.2 [get_ports {pin_out*} ]

set_false_path -from [get_pins async_reset*] -to [all_registers]

set_max_delay 3.0 -from [get_ports {pin_in*} ] -to [get_ports {pin_out* } ] 

set_max_transition 0.5 -from [all_inputs]

set_timing_derate -rise 1.0 -fall 1.0
set_max_fanout 16 [current_design]
