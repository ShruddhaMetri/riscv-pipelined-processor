// ============================================================
// FILE: mem_wb_reg.sv
// PURPOSE: Pipeline register between MEM and WB stages
// ============================================================

module mem_wb_reg (
    input  logic        clk,
    input  logic        rst,

    // Control in
    input  logic        reg_write_in,
    input  logic        mem_to_reg_in,

    // Data in
    input  logic [31:0] alu_result_in,
    input  logic [31:0] mem_data_in,
    input  logic [4:0]  rd_in,

    // Control out
    output logic        reg_write_out,
    output logic        mem_to_reg_out,

    // Data out
    output logic [31:0] alu_result_out,
    output logic [31:0] mem_data_out,
    output logic [4:0]  rd_out
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_write_out  <= 0;
            mem_to_reg_out <= 0;
            alu_result_out <= 0;
            mem_data_out   <= 0;
            rd_out         <= 0;
        end
        else begin
            reg_write_out  <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            alu_result_out <= alu_result_in;
            mem_data_out   <= mem_data_in;
            rd_out         <= rd_in;
        end
    end

endmodule