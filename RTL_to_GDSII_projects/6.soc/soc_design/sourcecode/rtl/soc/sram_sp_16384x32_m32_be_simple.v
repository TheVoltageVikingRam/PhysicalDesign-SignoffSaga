module sp_ram_m32 
#(
parameter ADDR_WIDTH = 8,
parameter DATA_WIDTH = 32,
parameter NUM_WORDS = 256
)(
//Clock and Resert
input logic clk,
input logic en_i,

input logic [ADDR_WIDTH-1:0] addr_i,
input logic [DATA_WIDTH-1:0] wdata_i,
output logic [DATA_WIDTH-1:0] rdata_o,
input logic we_i,
input logic [DATA_WIDTH/8-1:0] be_i
);


localparam words = NUM_WORDS/(DATA_WIDTH/8);  // (

