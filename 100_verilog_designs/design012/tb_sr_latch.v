module tb_sr_latch();

reg S;
reg R;

wire Q;
wire Q_bar;

sr_latch uut( .S(S), .R(R), .Q(Q), .Q_bar(Q_bar) );

initial begin


$dumpfile("tb_sr_latch.vcd");
$dumpvars(0, tb_sr_latch);

//Initial values 

S=0;
R=0;
#1;

$monitor("Time- %0d : S %b R %b Q %b Q_bar %b", $time, S, R, Q, Q_bar);
#10;
S=1; R=0; #10;
S=0; R=0; #10;
S=0; R=1; #10;
S=0; R=0; #10;
S=1; R=1; #10;
S=0; R=0; #10;

$finish();

end

endmodule
