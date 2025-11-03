module tb_sequence_detector;

logic clk;
logic rst_n;
logic data_in;
logic pattern_found;

sequence_detector uut (
.clk(clk),
.rst_n(rst_n),
.data_in(data_in),
.pattern_found(pattern_found)

);

initial begin

clk = 0;
forever #5 clk = ~clk;
end

initial begin
//Initialise signals
rst_n = 0;
data_in =0;

#20;   // Waiit a few clock cycles with reset active 2 cycless here

rst_n = 1; //reset released

$monitor("Time=%0t clk=%b rst_n=%b data_in=%b state=%b pattern_found=%b", 
         $time, clk, rst_n, data_in, uut.current_state, pattern_found);


@(posedge clk); data_in = 1;
@(posedge clk);	data_in	= 1;
@(posedge clk);	data_in	= 0;
@(posedge clk);	data_in	= 0;
@(posedge clk);	data_in	= 1;
@(posedge clk);	data_in	= 1;
@(posedge clk);	data_in	= 0;
@(posedge clk);	data_in	= 1;
@(posedge clk);	data_in	= 0;
@(posedge clk);	data_in	= 1;
@(posedge clk);	data_in	= 1;
@(posedge clk);	data_in	= 0;
@(posedge clk);	data_in	= 1;

#20;
$finish;


end


endmodule
