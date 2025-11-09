module sr_latch (
input S,
input R,
input Q,
input Q_bar
);

assign Q = ~(R | Q_bar);
assign Q_bar = ~(S | Q);

endmodule
