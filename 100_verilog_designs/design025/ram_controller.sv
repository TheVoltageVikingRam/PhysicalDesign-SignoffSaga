module ram_controller #(
parameter ADDR_WIDTH = 8,
parameter DATA_WIDTH = 32
) (

input logic clk,
input logic reset_n,
input logic read_en,
input logic write_en,
input logic [ADDR_WIDTH-1:0] addr,
input logic [DATA_WIDTH-1:0] write_data,
output logic [DATA_WIDTH-1:0] read_data,
output logic ready
);

//state ecoding

typedef enum logic [1:0] {

IDLE = 2'b00,
READ_CYCLE = 2'b01,
WRITE_CYCLE = 2'b10
} state_t;

state_t state;

//memory array
logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];





always_ff @(posedge clk or negedge reset_n) begin

	if (!reset_n) begin
		state <= IDLE;
		ready <= 1'b1;
		read_data <= '0;

	end else begin
		case(state)
		IDLE: begin
			if (read_en) begin
				 state <= READ_CYCLE;
				 ready <= 1'b0;
			end else if (write_en) begin
				state <= WRITE_CYCLE;
				ready <= 1'b0;
			end else begin
				ready <= 1'b1;
			end

		end

		READ_CYCLE: begin
			read_data <= mem[addr];
			state <= IDLE;	
			ready <= 1'b1;
			end

		WRITE_CYCLE: begin
			mem[addr] <= write_data;
			state <= IDLE;
			ready <= 1'b1;
			end
		default: begin
			state <= IDLE;
			ready <= 1'b1;
			end
	       endcase
	   end	
	end

endmodule
