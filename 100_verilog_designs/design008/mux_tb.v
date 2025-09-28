module tb_mux();

reg a,b,c,d;
reg [1:0]s;
wire out;

mux4x1 uut (.a(a), .b(b), .c(c), .d(d), .out(out), .s(s) );
initial begin

$dumpfile("mux.vcd");
$dumpvars(0, tb_mux);

a=1'b1; b=1'b1; c=1'b1; d=1'b1;
s=2'b10; #10;

a=1'b0;	b=1'b0;	c=1'b1;	d=1'b1;
s=2'b11;	#10;


a=1'b1;	b=1'b1;	c=1'b1;	d=1'b1;
s=2'b01;	#10;



a=1'b1;	b=1'b1;	c=1'b1;	d=1'b1;
s=2'b00;	#10;

a=1'b1;	b=1'b1;	c=1'b0;	d=1'b0;
s=2'b10;	#20;

$finish();
end


initial begin

$monitor("Time=%0t: a=%b b=%b c=%b d=%b s=%b out=%b",
$time, a,b,c,d,s,out);
end
endmodule
