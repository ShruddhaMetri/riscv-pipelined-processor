// ============================================================
// FILE: ex_mem_reg.sv
// PURPOSE: Pipeline register between EX and MEM stages
// ============================================================

module ex_mem_reg (
    input  logic        clk,
    input  logic        rst,

    // Control in
    input  logic        reg_write_in,
    input  logic        mem_write_in,
    input  logic        mem_read_in,
    input  logic        mem_to_reg_in,
    input  logic        branch_in,
    input  logic        zero_in,

    // Data in
    input  logic [31:0] alu_result_in,
    input  logic [31:0] rd_data2_in,
    input  logic [31:0] branch_target_in,
    input  logic [4:0]  rd_in,

    // Control out
    output logic        reg_write_out,
    output logic        mem_write_out,
    output logic        mem_read_out,
    output logic        mem_to_reg_out,
    output logic        branch_out,
    output logic        zero_out,

    // Data out
    output logic [31:0] alu_result_out,
    output logic [31:0] rd_data2_out,
    output logic [31:0] branch_target_out,
    output logic [4:0]  rd_out
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_write_out    <= 0; mem_write_out  <= 0;
            mem_read_out     <= 0; mem_to_reg_out <= 0;
            branch_out       <= 0; zero_out       <= 0;
            alu_result_out   <= 0; rd_data2_out   <= 0;
            branch_target_out<= 0; rd_out         <= 0;
        end
        else begin
            reg_write_out    <= reg_write_in;
            mem_write_out    <= mem_write_in;
            mem_read_out     <= mem_read_in;
            mem_to_reg_out   <= mem_to_reg_in;
            branch_out       <= branch_in;
            zero_out         <= zero_in;
            alu_result_out   <= alu_result_in;
            rd_data2_out     <= rd_data2_in;
            branch_target_out<= branch_target_in;
            rd_out           <= rd_in;
        end
    end

endmodule