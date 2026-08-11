// ============================================================
// FILE: id_ex_reg.sv
// PURPOSE: Pipeline register between ID and EX stages
// ============================================================

module id_ex_reg (
    input  logic        clk,
    input  logic        rst,
    input  logic        flush,

    // Control signals
    input  logic        reg_write_in,
    input  logic        alu_src_in,
    input  logic        mem_write_in,
    input  logic        mem_read_in,
    input  logic        mem_to_reg_in,
    input  logic        branch_in,
    input  logic [1:0]  alu_op_in,

    // Data
    input  logic [31:0] pc_in,
    input  logic [31:0] rd_data1_in,
    input  logic [31:0] rd_data2_in,
    input  logic [31:0] imm_in,
    input  logic [4:0]  rs1_in,
    input  logic [4:0]  rs2_in,
    input  logic [4:0]  rd_in,
    input  logic [2:0]  funct3_in,
    input  logic [6:0]  funct7_in,

    // Control signals out
    output logic        reg_write_out,
    output logic        alu_src_out,
    output logic        mem_write_out,
    output logic        mem_read_out,
    output logic        mem_to_reg_out,
    output logic        branch_out,
    output logic [1:0]  alu_op_out,

    // Data out
    output logic [31:0] pc_out,
    output logic [31:0] rd_data1_out,
    output logic [31:0] rd_data2_out,
    output logic [31:0] imm_out,
    output logic [4:0]  rs1_out,
    output logic [4:0]  rs2_out,
    output logic [4:0]  rd_out,
    output logic [2:0]  funct3_out,
    output logic [6:0]  funct7_out
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            reg_write_out  <= 0; alu_src_out   <= 0;
            mem_write_out  <= 0; mem_read_out  <= 0;
            mem_to_reg_out <= 0; branch_out    <= 0;
            alu_op_out     <= 0; pc_out        <= 0;
            rd_data1_out   <= 0; rd_data2_out  <= 0;
            imm_out        <= 0; rs1_out       <= 0;
            rs2_out        <= 0; rd_out        <= 0;
            funct3_out     <= 0; funct7_out    <= 0;
        end
        else begin
            reg_write_out  <= reg_write_in;  alu_src_out   <= alu_src_in;
            mem_write_out  <= mem_write_in;  mem_read_out  <= mem_read_in;
            mem_to_reg_out <= mem_to_reg_in; branch_out    <= branch_in;
            alu_op_out     <= alu_op_in;     pc_out        <= pc_in;
            rd_data1_out   <= rd_data1_in;   rd_data2_out  <= rd_data2_in;
            imm_out        <= imm_in;        rs1_out       <= rs1_in;
            rs2_out        <= rs2_in;        rd_out        <= rd_in;
            funct3_out     <= funct3_in;     funct7_out    <= funct7_in;
        end
    end

endmodule