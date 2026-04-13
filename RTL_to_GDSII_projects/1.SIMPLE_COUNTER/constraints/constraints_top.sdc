create_clock -name clk -period 10 -waveform {0 5} [get_ports "clk"]

# This command creates a clock with period 10ns, 50% duty cucle and the signal is high in the first hald 
set_clock_transition -rise 0.1 [get_clocks "clk"]
set_clock_transition -fall 0.1 [get_clocks "clk"]
# This command deinfes the transition delay for the clock

set_clock_uncertainty 0.1 [get_clocks "clk"]  
#This command will set the uncertainty due to clock skew jitter


set_input_delay -max 1.0 [get_ports "rst"] -clock [get_clocks "clk"]
set_output_delay -max 1.0 [get_ports "count[*]"] -clock [get_clocks "clk"]

#This command will specify the input and output delays used for timing slack calculations

