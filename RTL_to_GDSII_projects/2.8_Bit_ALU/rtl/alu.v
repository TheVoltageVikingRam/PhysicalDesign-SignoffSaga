module alu #(
parameter N = 8
) (
	input wire 		clk,
	input wire		rst_n,
	input wire		en,
	input wire [N-1:0] 	A,B,
	input wire [2:0]	op_code,
	output reg [N-1:0] 	result_out,
	output reg 		flag_carry,
	output reg 		flag_zero
);

localparam [2:0] 
	ADD=	3'b000,
	ADC=	3'b001,
	SUB=	3'b010,
	INC=	3'b011,
	DEC=	3'b100,
	CMP=	3'b101,
	SHL=	3'b110,
	SHR=	3'b111;

	always @(posedge clk) begin
		if (!rst_n) begin
			result_out <= {N{1'b0}};
			flag_carry <= 1'b0;
			flag_zero <= 1'b1;
		end else if (en) begin


	case(op_code)
			ADD: begin
			{flag_carry, result_out} <= {1'b0, A} + {1'b0, B};			

			end

			ADC: begin
			{flag_carry, result_out} <= {1'b0, A} + {1'b0, B} + flag_carry;


			end

			SUB: begin
			{flag_carry, result_out} <= {1'b0, A} - {1'b0, B};

			end


			INC: begin

			{flag_carry, result_out} <= {1'b0, A} + 1'b1;

			end

			DEC: begin
			{flag_carry, result_out} <= {1'b0, A} - 1'b1;


			end

			CMP: begin

			flag_carry <= 1'b0;
			if (A<B) result_out <= {{(N-1){1'b0}}, 1'b1};
			else if (A == B) result_out <= {{(N-2){1'b0}}, 2'b10};
			else 	result_out <= {{(N-3){1'b0}}, 3'b100};
			end

			SHL: begin
			flag_carry <= A[N-1];
			result_out <= {A[N-2:0], 1'b0};
			end
			
			SHR: begin
			flag_carry <= A[0];
			result_out <= {1'b0, A[N-1:1]};

			end

			default: begin
			result_out <= {N{1'b0}};
			flag_carry <= 1'b0;
		
			end			

		endcase

	flag_zero <= (result_out == {N{1'b0}});


		end
	end


endmodule
