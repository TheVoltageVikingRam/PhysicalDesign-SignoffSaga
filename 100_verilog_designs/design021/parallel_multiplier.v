// ============================================
// MAIN MULTIPLIER MODULE
// ============================================
module parallel_multiplier #(
    parameter WIDTH = 8
) (
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    output signed [2*WIDTH-1:0] product
);
    // Partial products
    wire signed [2*WIDTH-1:0] partial_products [0:WIDTH-1];
    
    partial_product_generator #(.WIDTH(WIDTH)) pp_gen (
        .a(a),
        .b(b),
        .partial_products(partial_products)
    );
    
    // Adder tree to sum partial products
    adder_tree #(.WIDTH(WIDTH)) adder_tree_inst (
        .partial_products(partial_products),
        .sum(product)
    );
endmodule

// ============================================
// PARTIAL PRODUCT GENERATOR
// ============================================
module partial_product_generator #(
    parameter WIDTH = 8
) (
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    output signed [2*WIDTH-1:0] partial_products [0:WIDTH-1]
);
    wire signed [2*WIDTH-1:0] a_extended;
    
    // Sign extend 'a' to 2*WIDTH bits
    assign a_extended = {{WIDTH{a[WIDTH-1]}}, a};
    
    genvar i;
    generate
        // Generate partial products for bits [WIDTH-2:0]
        for (i = 0; i < WIDTH-1; i = i + 1) begin: gen_pp
            assign partial_products[i] = b[i] ? (a_extended << i) : {2*WIDTH{1'b0}};
        end
        
        // MSB (sign bit) partial product - needs to be subtracted
        assign partial_products[WIDTH-1] = b[WIDTH-1] ? (-(a_extended << (WIDTH-1))) : {2*WIDTH{1'b0}};
    endgenerate
endmodule

// ============================================
// ADDER TREE
// ============================================
module adder_tree #(
    parameter WIDTH = 8,
    parameter STAGES = $clog2(WIDTH)
) (
    input signed [2*WIDTH-1:0] partial_products [0:WIDTH-1],
    output signed [2*WIDTH-1:0] sum
);
    // Stage storage
    reg signed [2*WIDTH-1:0] stage_data [0:STAGES][0:WIDTH-1];
    
    integer stage, i, num_inputs, num_outputs;
    
    always @(*) begin
        // Stage 0: Initialize with partial products
        for (i = 0; i < WIDTH; i = i + 1) begin
            stage_data[0][i] = partial_products[i];
        end
        
        // Subsequent stages: pair and add
        for (stage = 1; stage <= STAGES; stage = stage + 1) begin
            num_inputs = WIDTH >> (stage - 1);
            num_outputs = (num_inputs + 1) >> 1;
            
            for (i = 0; i < WIDTH; i = i + 1) begin
                if (i < num_outputs) begin
                    if (i*2 + 1 < num_inputs) begin
                        // Pair exists - add them
                        stage_data[stage][i] = stage_data[stage-1][i*2] + stage_data[stage-1][i*2+1];
                    end else begin
                        // Odd one out - pass through
                        stage_data[stage][i] = stage_data[stage-1][i*2];
                    end
                end else begin
                    stage_data[stage][i] = {2*WIDTH{1'b0}};
                end
            end
        end
    end
    
    // Final result
    assign sum = stage_data[STAGES][0];
endmodule
