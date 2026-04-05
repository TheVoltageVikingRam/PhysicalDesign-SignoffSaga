module alu #(
    parameter N = 8
) (
    input  wire             clk,
    input  wire             rst_n,      // active-low synchronous reset
    input  wire             en,
    input  wire [N-1:0]     A, B,
    input  wire [2:0]         op_code,
    output reg  [N-1:0]     result_out,
    output reg              flag_carry,
    output reg              flag_zero
);

    // ── Op-code mnemonics ─────────────────────────────────────────────────────
    localparam [2:0]
        ADD = 3'b000,   // A + B
        ADC = 3'b001,   // A + B + carry_in  (flag_carry from prev cycle)
        SUB = 3'b010,   // A – B  (borrow reflected in flag_carry)
        INC = 3'b011,   // A + 1
        DEC = 3'b100,   // A – 1
        CMP = 3'b101,   // compare: result = 1 (AB)
        SHL = 3'b110,   // logical shift left  (MSB → flag_carry)
        SHR = 3'b111;  // logical shift right (LSB → flag_carry)

    // ── Internal wide wire for carry capture ─────────────────────────────────
    reg [N:0] wide;   // N+1 bits: [N] = carry, [N-1:0] = result

    always @(posedge clk) begin
        if (!rst_n) begin
            result_out <= {N{1'b0}};
            flag_carry <= 1'b0;
            flag_zero  <= 1'b1;   // 0 == 0 → zero flag asserted at reset
        end else if (en) begin
            wide <= {(N+1){1'b0}};  // default: clear carry accumulator

            case (op_code)
                ADD: begin
                    wide       <= {1'b0, A} + {1'b0, B};
                    result_out <= wide[N-1:0];
                    flag_carry <= wide[N];
                end
                ADC: begin
                    wide       <= {1'b0, A} + {1'b0, B} + flag_carry;
                    result_out <= wide[N-1:0];
                    flag_carry <= wide[N];
                end
                SUB: begin
                    wide       <= {1'b0, A} - {1'b0, B};
                    result_out <= wide[N-1:0];
                    flag_carry <= wide[N];  // borrow = 1 when A < B
                end
                INC: begin
                    wide       <= {1'b0, A} + 1'b1;
                    result_out <= wide[N-1:0];
                    flag_carry <= wide[N];
                end
                DEC: begin
                    wide       <= {1'b0, A} - 1'b1;
                    result_out <= wide[N-1:0];
                    flag_carry <= wide[N];  // underflow flag
                end
                CMP: begin
                    flag_carry <= 1'b0;
                    if      (A < B)  result_out <= {{(N-1){1'b0}}, 1'b1};  // 1
                    else if (A == B) result_out <= {{(N-2){1'b0}}, 2'b10}; // 2
                    else             result_out <= {{(N-3){1'b0}}, 3'b100}; // 4
                end
                SHL: begin
                    flag_carry <= A[N-1];           // MSB shifted out
                    result_out <= {A[N-2:0], 1'b0};
                end
                SHR: begin
                    flag_carry <= A[0];              // LSB shifted out
                    result_out <= {1'b0, A[N-1:1]};
                end
                default: begin
                    result_out <= {N{1'b0}};
                    flag_carry <= 1'b0;
                end
            endcase

            // flag_zero is registered separately so it tracks result_out
            // with a one-cycle lag — identical timing to result_out itself.
            flag_zero <= (result_out == {N{1'b0}});
        end
    end

endmodule
