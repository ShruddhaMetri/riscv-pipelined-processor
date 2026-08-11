// ============================================================
// FILE: control_unit.sv
// PURPOSE: Looks at opcode and generates all control signals
// ============================================================

module control_unit (
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_write,
    output logic       mem_read,
    output logic       mem_to_reg,
    output logic       branch,
    output logic [1:0] alu_op
);

    always_comb begin
        // Default all signals to 0
        reg_write  = 0;
        alu_src    = 0;
        mem_write  = 0;
        mem_read   = 0;
        mem_to_reg = 0;
        branch     = 0;
        alu_op     = 2'b00;

        case (opcode)
            7'b0110011: begin // R-type (ADD, SUB, AND, OR)
                reg_write = 1;
                alu_op    = 2'b10;
            end

            7'b0010011: begin // I-type (ADDI)
                reg_write = 1;
                alu_src   = 1;
                alu_op    = 2'b10;
            end

            7'b0000011: begin // Load (LW)
                reg_write  = 1;
                alu_src    = 1;
                mem_read   = 1;
                mem_to_reg = 1;
                alu_op     = 2'b00;
            end

            7'b0100011: begin // Store (SW)
                alu_src   = 1;
                mem_write = 1;
                alu_op    = 2'b00;
            end

            7'b1100011: begin // Branch (BEQ)
                branch = 1;
                alu_op = 2'b01;
            end

            default: begin
                reg_write  = 0;
                alu_src    = 0;
                mem_write  = 0;
                mem_read   = 0;
                mem_to_reg = 0;
                branch     = 0;
                alu_op     = 2'b00;
            end
        endcase
    end

endmodule