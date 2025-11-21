module mult_controller #(
    parameter integer WIDTH = 8
)
(
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic signed [WIDTH - 1: 0] multiplicand,
    input logic signed [WIDTH - 1: 0] multiplier,
    output logic signed [2 * WIDTH - 1: 0] product,  // Fixed: comma instead of period
    output logic done
);
    //Control signals
    logic clear_product;
    logic shift_product;
    logic add_multiplicand;
    logic [$clog2(WIDTH)+1:0] bit_count;  // Fixed: bit_count instead of bit_cloud
    
    //Data path registers
    logic signed [WIDTH-1:0] multiplicand_reg;  //signed register
    logic signed [2*WIDTH - 1: 0] product_reg; //signed register for product
    logic sign_adjustment_needed; //Flag for negative multiplier
    
    typedef enum logic [2:0] {
        IDLE,
        LOAD,
        CHECK,
        ADD,
        SHIFT,
        ADJUST,
        COMPLETE
    } state_t;
    
    state_t state;  // Fixed: space between state_t and state
    
    //control FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_count <= '0;
            shift_product <= 1'b0;
            clear_product <= 1'b0;
            add_multiplicand <= 1'b0;
            done <= 1'b0;
            sign_adjustment_needed <= 1'b0;
        end else begin
            case (state) 
                IDLE: begin
                    if (start) begin
                        state <= LOAD;
                        clear_product <= 1'b1;
                        done <= 1'b0;
                    end
                end
                
                LOAD: begin
                    clear_product <= 1'b0;
                    state <= CHECK;
                    bit_count <= '0;  // Fixed: removed extra space
                    // Remember if we need to adjust for negative multiplier
                    sign_adjustment_needed <= multiplier[WIDTH-1];
                end
                
                CHECK: begin
                    if (product_reg[0]) begin
                        state <= ADD;
                        add_multiplicand <= 1'b1;
                    end else begin
                        state <= SHIFT;
                        shift_product <= 1'b1;  // Fixed: shift_product instead of shit_product
                    end
                end
                
                ADD: begin  // Fixed: begin instead of beginn
                    add_multiplicand <= 1'b0;
                    state <= SHIFT;
                    shift_product <= 1'b1;
                end
                
                SHIFT: begin
                    shift_product <= 1'b0;
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == WIDTH-1) begin
                        state <= sign_adjustment_needed ? ADJUST : COMPLETE;  // Fixed: sign_adjustment_needed
                    end else begin
                        state <= CHECK;
                    end
                end
                
                ADJUST: begin
                    //For negative multiplier, subtract multiplicand
                    add_multiplicand <= 1'b1;
                    state <= COMPLETE;
                end
                
                COMPLETE: begin
                    add_multiplicand <= 1'b0;
                    state <= IDLE;
                    done <= 1'b1;
                end
            endcase
        end
    end
    
    // Datapath
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand_reg <= '0;
            product_reg <= '0;
        end else begin
            if (clear_product) begin
                multiplicand_reg <= multiplicand;
                //Sign extend multiplier to 16 bits for proper shifting
                product_reg <= {{WIDTH{1'b0}}, multiplier};
            end else if (add_multiplicand) begin
                if (state == ADJUST) begin  // Fixed: ADJUST instead of COMPLETE
                    // Subtract multiplicand when adjusting for negative multipliers
                    product_reg[2*WIDTH-1: WIDTH] <= product_reg[2*WIDTH-1: WIDTH] - multiplicand_reg;
                end else begin
                    product_reg[2*WIDTH-1:WIDTH] <= product_reg[2*WIDTH-1:WIDTH] + multiplicand_reg;  // Fixed: product_reg
                end
            end else if (shift_product) begin
                product_reg <= product_reg >>> 1;
            end
        end
    end
    
    assign product = product_reg;
    
endmodule
