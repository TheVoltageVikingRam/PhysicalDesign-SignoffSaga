module tb_full_sub;

reg a, b, c;
wire diff, borrow ;

full_sub dut( .a(a), .b(b), .c(c), .diff(diff), .borrow(borrow) );

initial begin

a=0; b=0; c=0; #5;
a=0; b=0; c=1; #5;
a=0; b=1; c=0; #5;
a=0; b=1; c=1; #5;
a=1; b=0; c=0; #5;
a=1; b=0; c=1; #5;
a=1; b=1; c=0; #5;
a=1; b=1; c=1; #5;



$finish;

end 
endmodule
