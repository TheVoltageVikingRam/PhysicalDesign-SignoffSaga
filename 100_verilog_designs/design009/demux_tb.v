module demux_tb();

reg in;
reg [1:0] s;
wire y1,y2,y3,y4;

demux uut (.in(in), .s(s), .y1(y1), .y2(y2), .y3(y3), .y4(y4) );

initial begin

$dumpfile("demux.vcd");
$dumpvars(0, demux_tb);


in=1'b1; s=2'b00; #10;
in=1'b1; s=2'b01; #10;
in=1'b1; s=2'b11; #10;
in=1'b1; s=2'b10; #10;
in=1'b1; s=2'b01; #10;
in=1'b1; s=2'b00; #10;
in=1'b1; s=2'b10; #10;

$finish();


end

initial begin
	$monitor("Time=%0t: y1=%b y2=%b y3=%b y4=%b in=%b s=%b",
	$time, y1,y2,y3,y4,in,s);

end

endmodule







