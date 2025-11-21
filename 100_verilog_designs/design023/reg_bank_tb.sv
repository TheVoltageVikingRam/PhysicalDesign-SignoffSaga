module reg_bank_tb;
localparam WIDTH = 8; 
localparam DEPTH = 4; 
localparam CLK_PERIOD = 10;
logic clk = 0;
logic reset_n;
logic [$clog2(DEPTH)-1:0] addr;
logic write_en;
logic [WIDTH-1:0] data_in;
logic [WIDTH-1:0] data_out;

register_bank #(.WIDTH(WIDTH), .DEPTH(DEPTH) ) dut ( .clk(clk), .reset_n(reset_n), .addr(addr), .write_en(write_en), .data_in(data_in), .data_out(data_out) );

always #(CLK_PERIOD/2) clk = ~clk;

initial begin
$dumpfile("tb.vcd");
$dumpvars(0, reg_bank_tb);

//reset 

reset_n = 0;
write_en = 0;
addr = 0;
data_in = 0;

#20;
reset_n = 1;
@(posedge clk);

//SIMPLE READ AND WRITE

$display("TEST 1: WRITE 0XAA to addr 1");
addr = 1;
data_in = 8'hAA;
write_en = 1;

@(posedge clk);
write_en = 0;
#2;

$display ("Read addr 1 = %h", data_out );
//WRITE MULTIPLE LOCATIONS
$display("TEST 2: Fill entire register bank");

for (int i = 0; i < DEPTH; i++ ) begin
	addr = i;
	data_in = i + 8'h10;
	write_en = 1;
	@(posedge clk);
end

write_en = 0;

for (int i =0; i < DEPTH ; i++ ) begin
	addr = i;
	#1;
	$display("Addr %0d read = %h", i, data_out);
end

// BACK TO BACK WRITES

$display("TEST 3: Back to back writes");

addr = 2;
data_in =  8'h55;
write_en = 1;
@(posedge clk);

addr = 3;
data_in = 8'h77;
@(posedge clk);
write_en = 0;

//Read them
addr = 2; #1; $display("Addr 2 = %h", data_out);
addr = 3; #1; $display("Addr 3 = %h", data_out);
// READ WHILE WRITE

$display("TEST 4: Read while write to same address" );

addr = 1;
data_in = 8'hF1;
write_en = 1;
@(posedge clk);
write_en = 0;
#1;

$display("Addr 1 after while = %h", data_out );
$display("All tests complete" );
$finish;

end




  
endmodule
