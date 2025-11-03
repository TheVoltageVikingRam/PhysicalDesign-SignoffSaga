module sequence_detector (
input logic clk,
input logic rst_n,
input logic data_in,
output logic pattern_found
);


parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;


logic[1:0] current_state;
logic[1:0] next_state;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		current_state <= 2'b00;
	end
	
	else begin
		current_state <= next_state;
	end
end


always @(*) begin

	case(current_state)
		S0: begin
			if (data_in == 0)
			next_state = S0;
			else
			next_state = S1;
		end
		S1: begin
			if (data_in == 0)
			next_state = S0;
			else
			next_state = S2;
		end
		S2: begin
			if (data_in == 0)
			next_state = S3;
			else
			next_state = S2;
		end
		S3: begin
			if (data_in == 0)
			next_state = S0;
			else
			next_state = S1;
		end
		default: next_state = S0;
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		pattern_found <= 1'b0;
	end
	else begin

	if (current_state == S3 && data_in == 1)
		pattern_found = 1'b1;
	else
		pattern_found = 1'b0;
end
end


endmodule
