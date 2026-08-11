// ============================================================
// FILE: alu.sv
// PURPOSE: Does all arithmetic and logic operations
// ============================================================

module alu (
    input  logic [31:0] a,          // Operand 1
    input  logic [31:0] b,          // Operand 2
    input  logic [3:0]  alu_ctrl,   // What operation to do
    output logic [31:0] result,     // Result
    output logic        zero        // 1 if result == 0 (used for BEQ)
);

    always_comb begin
        case (alu_ctrl)
            4'b0000: result = a + b;                    // ADD
            4'b0001: result = a - b;                    // SUB
            4'b0010: result = a & b;                    // AND
            4'b0011: result = a | b;                    // OR
            4'b0100: result = a ^ b;                    // XOR
            4'b0101: result = (a < b) ? 32'd1 : 32'd0; // SLT
            4'b0110: result = a << b[4:0];              // SLL
            4'b0111: result = a >> b[4:0];              // SRL
            default: result = 32'h00000000;
        endcase
    end

    assign zero = (result == 32'h00000000) ? 1'b1 : 1'b0;

endmodule