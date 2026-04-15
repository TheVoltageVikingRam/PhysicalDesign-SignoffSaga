module sram_sp_16384x32_m16_be_wrap (
output [31:0] Q, //READ Data
input CLK, //CLOCK
input CEN, //Chip Enable NOT
input [3:0] BEN, //BYTE Enable NOT
input GWEN, //Global write enable NOT
input [13:0] A, //Address
input [31:0] D //Write data
);

localparam ADDR_WIDTH = 14;
localparam DATA_WIDTH = 32;
localparam NUM_WORDS = (2**ADDR_WIDTH)*(DATA_WIDTH/8);

parameter RAM_SIZE = NUM_WORDS;

sp_ram_m16 
	#(
	.ADDR_WIDTH(ADDR_WIDTH),
	.DATA_WIDTH(DATA_WIDTH),
	.NUM_WORDS(NUM_WORDS)
	)   ram (
		//clock and reset
		.clk(CLK), 	//Input logic
		.en_i((!CEN)||(!GWEN)), //input
		.addr_i(A),	//Input [ADDR_WIDTH-1:0
		.wdata_i(D), 	// Input [DATA__WIDTH-1:0]
		.rdata_o(Q),	//Output [DATA_WIDTH-1:0]
		.we_i(!GWEN),	//input
		.be_i(~BEN)	// input [DATA_WIDTH/8-1:0]
);

endmodule
