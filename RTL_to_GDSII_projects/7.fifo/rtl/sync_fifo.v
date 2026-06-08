module sync_fifo #(
	parameter DATA_WIDTH	= 27,
	parameter ADDR_WIDTH	= 12,
	parameter PROG_FULL_THRESH = 3872,
	parameter PROG_EMPTY_THRESH = 1024
)
