//verilog code for testbench of AN 8 bit ALU
//definbe module

module tb_ALU();

reg [7:0] a, b, s; //Define I/0 ports
reg clk, en;
wire [15:0] y;
wire carry , zero;

//map all the I/O ports with DUT

ALU uut ( .a(a), .b(b), .s(S), .en(en), .clk(clk), .y(y), .carry(carry), .zero(zero) );


//initialize input pins with 0

initial begin
	a=0; b=0; s=0; en=1; clk=0;
end


always begin //generate a clock of period 10 units
	clk = ~clk; #5;
end


initial begin
	#50;
	a = 8'b11101110; // initialise 8 bit input value for a and b;
	b = 8'b11101110; #29;
	//initialise s value to perform differebt operations

	s = 4'b0001; #30;
	s = 4'b0010; #30;
	en = 0;
	s = 4'b0001; #30;
	s = 4'b0010; #30;
	s = 4'b0011; #30;
	s = 4'b0100; #30;
	s = 4'b0101; #30;
	s = 4'b0110; #30;
	s = 4'b0111; #30;
	s = 4'b1000; #30;
	s = 4'b1001; #30;
	s = 4'b1010; #30;
	s = 4'b1011; #30;
	s = 4'b1100; #30;
	s = 4'b1101; #30;
	s = 4'b1110; #30;
	s = 4'b1111; #30;
	#10; $stop;
end 	// end of initial block

endmodule




 
