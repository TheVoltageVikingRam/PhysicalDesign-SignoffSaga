module test_alu();
	parameter N = 8;
	reg [N-1:0] A, B;
	reg [2:0] op_code;
	reg 	clk, rst_n, en;
	wire [N-1:0] result_out;
	wire 	flag_carry, flag_zero;


alu #(.N(N)) uut (
	.clk(clk),
	.rst_n(rst_n),
	.en(en),
	.A(A),
	.B(B),
	.op_code(op_code),
	.result_out(result_out),
	.flag_carry(flag_carry),
	.flag_zero(flag_zero)
);

always #5 clk = ~clk;

initial begin




	$dumpfile("alu_waves.vcd"); // Names the output file
	$dumpvars(0, test_alu);     // Records all variables in this module



	clk = 0; rst_n = 0; en = 0;
	A = 0; B = 0; op_code = 3'b000;
	$monitor("T=%0t | op=%0d A=%0d B=%0d |  result=%0d carry=%b zero=%b",
        $time, op_code, A, B,  result_out, flag_carry, flag_zero);    


	//hold reset for one full cycle
	@(posedge clk); #1;
	rst_n = 1; en = 1;

	//ADD: 250 + 5 = 256 -> result = 0, carry = 1
	@(posedge clk); #1;
	op_code = 3'b000; A=250; B=6;
	@(posedge clk);  
	@(posedge clk); #1; 

	//ADC : 2+3+Carry
	@(posedge clk); #1;
        op_code	= 3'b001; A=2; B=3;



	//SUB: 23-20=3
	 @(posedge clk); #1;
        op_code	= 3'b010; A=23; B=20;


	//INC: 25+1
	 @(posedge clk); #1;
        op_code	= 3'b011; A=25; B=0;


	//DEC: 5-1
	 @(posedge clk); #1;
        op_code	= 3'b100; A=5; B=0;


	//CMP: 15 vs 3

	@(posedge clk); #1;
	op_code = 3'b101; A = 15; B = 3;

	//SHL: 8'b00000001 << 1
	@(posedge clk); #1;
	op_code = 3'b110; A = 8'b00000001; B=0;


	//SHR: 8'b100000000 >> 1
	@(posedge clk); #1;
	op_code = 3'b111; A = 8'b10000000; B=0;

	//EXTRA CYCLES TO OBSERVE OUTPUTS
	
	@(posedge clk);
	@(posedge clk);

	$finish;
end

endmodule

