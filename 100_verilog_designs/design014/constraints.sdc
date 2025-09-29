# Set input delay for ports a and b (modeling external delay)
set_input_delay 3.0 [get_ports {a[*] b[*]}]

# Set output delay for ports g_t, l_t, and equ (timing budget to external world)
set_output_delay 3.0 [get_ports {g_t l_t equ}]

# Optional synthesis constraints for QoR (Quality of Results)
set_max_fanout 20
set_max_transition 1.5

