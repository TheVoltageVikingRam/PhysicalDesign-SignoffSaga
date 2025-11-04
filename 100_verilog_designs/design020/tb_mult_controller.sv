module tb_mult_controller;

    // Parameters
    parameter WIDTH = 8;
    parameter CLK_PERIOD = 10; // 10ns clock period
    
    // Testbench signals
    logic clk;
    logic rst_n;
    logic start;
    logic signed [WIDTH-1:0] multiplicand;
    logic signed [WIDTH-1:0] multiplier;
    logic signed [2*WIDTH-1:0] product;
    logic done;
    
    // Instantiate the multiplier controller
    mult_controller #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product),
        .done(done)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Reset task
    task automatic reset_dut();
        rst_n = 0;
        start = 0;
        multiplicand = 0;
        multiplier = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
    endtask
    
    // Task to perform multiplication and check result
    task automatic do_multiply(
        input signed [WIDTH-1:0] a,
        input signed [WIDTH-1:0] b
    );
        logic signed [2*WIDTH-1:0] expected;
        int timeout_count;
        
        expected = a * b;
        
        // Apply inputs
        @(posedge clk);
        multiplicand = a;
        multiplier = b;
        start = 1;
        
        @(posedge clk);
        start = 0;
        
        // Wait for done signal with timeout
        timeout_count = 0;
        while (!done && timeout_count < 100) begin
            @(posedge clk);
            timeout_count++;
        end
        
        // Check results
        if (timeout_count >= 100) begin
            $display("ERROR: Timeout waiting for done signal");
            $display("  Inputs: %0d * %0d", a, b);
        end else if (product !== expected) begin
            $display("ERROR: Mismatch!");
            $display("  Inputs: %0d * %0d", a, b);
            $display("  Expected: %0d (0x%0h)", expected, expected);
            $display("  Got:      %0d (0x%0h)", product, product);
        end else begin
            $display("PASS: %0d * %0d = %0d", a, b, product);
        end
        
        @(posedge clk);
    endtask
    
    // Main test sequence
    initial begin
        $display("========================================");
        $display("  Multiplier Controller Testbench");
        $display("  WIDTH = %0d", WIDTH);
        $display("========================================\n");
        
        // Initialize
        reset_dut();
        
        $display("Test 1: Basic Positive Numbers");
        do_multiply(5, 3);
        do_multiply(7, 8);
        do_multiply(15, 10);
        
        $display("\nTest 2: Multiplication with Zero");
        do_multiply(0, 5);
        do_multiply(5, 0);
        do_multiply(0, 0);
        
        $display("\nTest 3: Multiplication by One");
        do_multiply(1, 42);
        do_multiply(42, 1);
        do_multiply(1, 1);
        
        $display("\nTest 4: Negative Numbers");
        do_multiply(-5, 3);
        do_multiply(5, -3);
        do_multiply(-5, -3);
        do_multiply(-7, -8);
        
        $display("\nTest 5: Maximum Positive Values");
        do_multiply(127, 1);
        do_multiply(127, 2);
        do_multiply(100, 100);
        
        $display("\nTest 6: Minimum Negative Values");
        do_multiply(-128, 1);
        do_multiply(-128, 2);
        do_multiply(-128, -1);
        
        $display("\nTest 7: Edge Cases");
        do_multiply(127, 127);    // Max positive * Max positive
        do_multiply(-128, -128);  // Min negative * Min negative
        do_multiply(127, -128);   // Max positive * Min negative
        do_multiply(-128, 127);   // Min negative * Max positive
        
        $display("\nTest 8: Powers of Two");
        do_multiply(2, 2);
        do_multiply(4, 4);
        do_multiply(8, 8);
        do_multiply(16, 2);
        
        $display("\nTest 9: Random Values");
        repeat(10) begin
            automatic logic signed [WIDTH-1:0] rand_a, rand_b;
            rand_a = $random;
            rand_b = $random;
            do_multiply(rand_a, rand_b);
        end
        
        $display("\n========================================");
        $display("  All Tests Completed!");
        $display("========================================\n");
        
        $finish;
    end
    
    // Waveform dumping
    initial begin
        $dumpfile("mult_controller.vcd");
        $dumpvars(0, tb_mult_controller);
    end
    
    // Simulation timeout watchdog
    initial begin
        #(CLK_PERIOD * 10000); // 10000 clock cycles max
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule
