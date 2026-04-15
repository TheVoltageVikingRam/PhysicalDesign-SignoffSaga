module cluster_clock_gating 
(
	input logic clk_i,
	input logic en_i,
	input logic test_en_i,
	output logic clk_o
);

`ifdef PULP_FPGA_EMUL
	// NO CLOCK GATES IN FPGA FLOW

assign clk_o = clk_i;
`else
 logic clk_en;

always_latch
begin
	if (clk_i == 1'b0)
		clk_en <= en_i | test_en_i;
end

assign clk_o = clk_i & clk_en;

`endif

endmodule

##this system verilog module implements a clock gating cell , a critical component in digitl design used to reduce power consumption by disabling the clock signal for logic blocks that are not currently in use.
