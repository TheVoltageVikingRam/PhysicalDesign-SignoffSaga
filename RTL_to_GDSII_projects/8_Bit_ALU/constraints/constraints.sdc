#1. Clock definition: period is 10ns i.e. 100MHz clock with duty cycle 50% 

create_clock -name "clk" -period 10.0 -waveform {0 5} {get_ports "clk"}
#2. Clock quality

set_clock_transition -rise 0.1 [get_clocks "clk"]
set_clock_transition -fall 0.1 [get_clocks "clk"]
set_clock_uncertainty 0.1 [get_clocks "clk"]


#3. Input delays (setup+hold)

set_input_delay -max 1.0 [get_ports {A B op_code en rst_n}] -clock [get_clocks "clk"]
set_input_delay -min 0.2 [get_ports {A B op_code en rst_n}] -clock [get_clocks "clk"]

#4. Output Delays (setup+hold)

set_output_delay -max 1.0 [get_ports {result_out flag_carry flag_zero}] -clock [get_clocks "clk"]
set_output_delay -min 0.2 [get_ports {result_out flag_carry flag_zero}] -clock [get_clocks "clk"]
