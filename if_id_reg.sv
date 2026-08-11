// ============================================================
// FILE: if_id_reg.sv
// PURPOSE: Pipeline register between IF and ID stages
// ============================================================

module if_id_reg (
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,    // Freeze this register (hazard)
    input  logic        flush,    // Clear this register (branch taken)
    input  logic [31:0] pc_in,    // PC value from IF stage
    input  logic [31:0] instr_in, // Instruction from memory

    output logic [31:0] pc_out,   // PC passed to ID stage
    output logic [31:0] instr_out // Instruction passed to ID stage
);

    always_ff @(posedge clk or posedge rst) begin

        if (rst || flush) begin
            // On reset OR branch flush → insert NOP (bubble)
            pc_out    <= 32'h00000000;
            instr_out <= 32'h00000013; // NOP instruction
        end

        else if (stall) begin
            // Freeze - hold current values, don't update
            pc_out    <= pc_out;
            instr_out <= instr_out;
        end

        else begin
            // Normal - pass values forward to next stage
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end

    end

endmodule