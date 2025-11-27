module tb_ram_controller;

//DEclare signals

logic clk;
logic reset_n;
logic read_en;
logic write_en;
logic [7:0] addr;
logic [31:0] write_data;
logic [31:0] read_data;
logic ready;

//Instantiate the DUT

ram_controller #(
.ADDR_WIDTH(8),
.DATA_WIDTH(32)

) dut (

.clk(clk),
.reset_n(reset_n),
.read_en(read_en),
.write_en(write_en),
.addr(addr),
.write_data(write_data),
.read_data(read_data),
.ready(ready)

);

//CLOCK GEENRATION

initial begin
	clk = 0;
	forever #5 clk = ~clk; // 10ns period
end

//TEST STIMULUS

initial begin
	reset_n = 0;
	read_en = 0;
	write_en = 0;
	addr = 0;
	write_data = 0;

	//Apply reset 
	#20; //wait 20ns
	reset_n = 1; //reset released
	#10;


	$display("Starting RAM Controller test");
	
// test 1: write some data

$display("\n-- TEST 1: WRITING DATA---");
// Write 0xDEADBEAC to address 0x10
write_to_ram(8'h10, 32'hDEADBEAC );

// write 0x12345678 to address 0x20
write_to_ram(8'h20, 32'h12345678);

// write 0xABCDEF00 to address 0x30
write_to_ram(8'h30, 32'hABCDEF00);

// TEST 2: READ BACK THE DATA

$display("\n--- TEST2: Reading Data ----");
// read data from address 0x10 (expect 0xDEADBEAC)

read_from_ram(8'h10, 32'hDEADBEAC);

//read data from address 0x20 (expect 0x12345678)

read_from_ram(8'h20, 32'h12345678);

//read data from address 0x30 (expect 0XABCDEF00)

read_from_ram(8'h30, 32'hABCDEF00);


//TEST 3: READ FROM UNWRITTEN LOCATIONS


$display ("\n -- TEST3: Read Uninitialized Address ---");
 read_from_ram(8'h50, 32'hXXXXXXXX);  //dont check value

//TEST 4: Overwrite existing data


$display("\n--- TEST 4: Overwrite exisitng data --- ");
write_to_ram(8'h10, 32'hCAFEBABE);
read_from_ram(8'h10, 32'hCAFEBABE);

// END OF TEST

// =============================


#50;

$display("\n =========================================");
$display("Test complete");
$display("================================================");
$finish;

end

//==============================================
// 5. HELPER TASKS
// ============================================





task write_to_ram(input [7:0] address, input [31:0] data);
	begin
		@(posedge clk); //wait for clock edge
		wait(ready); //wait untill controller is ready

		addr = address;
		write_data = data;
		write_en = 1;

		@(posedge clk); //apply for one clock cycle
		write_en = 0;
		$display("WRITE: Addr=0x%0h, Data=0x%0h", address, data);
		@(posedge clk);
	end
endtask



//Task to read from RAM and check

task read_from_ram(input [7:0] address,input [31:0] expected_data);
	begin
		@(posedge clk);
		wait(ready);
		
		addr = address;  //Read takes one cycle
		read_en = 1;
		
		@(posedge clk);
		read_en = 0;
		
		@(posedge clk);  //wait for data to be available

		// CHECK IF DATA MATCHES (IF EXPECTED DATA IS NOT X)

		if (expected_data !== 32'hXXXXXXXX) begin
			if (read_data == expected_data) begin
				$display(" READ: Addr = 0x%0h, Data = 0x%0h [PASS]", address, read_data);
			end else begin
				$display(" READ: Addr = 0x%0h, Data = 0x%0h [FAIL - Expected - 0x%0h]", address, read_data, expected_data);
			end
		end else begin

			$display("READ: Addr = 0x%0h, Data = 0x%0h [NO CHECK] ", address, read_data);
		end
	end
endtask

//  =========================================
// 6. Waveform Dump
// ============================

		
initial begin
	$dumpfile("ram_controller.vcd"); // vcd file
	$dumpvars(0, tb_ram_controller);  //Dump all signals
end

endmodule
