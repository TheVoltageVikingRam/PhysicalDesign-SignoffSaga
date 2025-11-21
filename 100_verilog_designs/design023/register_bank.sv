module register_bank #(
parameter WIDTH = 8,
parameter DEPTH = 4
) (
input logic clk,
input logic reset_n,
input logic [$clog2(DEPTH)-1: 0] addr,
input logic write_en,
input logic [WIDTH-1: 0] data_in,
output logic [WIDTH-1: 0] data_out
);

logic [WIDTH-1:0] registers [DEPTH];

always_ff @(posedge clk or negedge reset_n) begin
	if (!reset_n) 
		for (int i=0; i < DEPTH; i++)
			registers[i] <= '0;
	else if (write_en)
		registers[addr] <= data_in;
end

assign data_out = registers[addr];

endmodule
