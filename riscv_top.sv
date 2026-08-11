module riscv_top (
    input logic clk,
    input logic rst
);
    logic [31:0] pc_current, pc_next, instr_if;
    logic [31:0] pc_id, instr_id;
    logic [31:0] rd_data1_id, rd_data2_id, imm_id;
    logic [4:0]  rs1_id, rs2_id, rd_id;
    logic [2:0]  funct3_id;
    logic [6:0]  funct7_id;
    logic        reg_write_id, alu_src_id, mem_write_id;
    logic        mem_read_id, mem_to_reg_id, branch_id;
    logic [1:0]  alu_op_id;
    logic [31:0] pc_ex, rd_data1_ex, rd_data2_ex, imm_ex;
    logic [4:0]  rs1_ex, rs2_ex, rd_ex;
    logic [2:0]  funct3_ex;
    logic [6:0]  funct7_ex;
    logic        reg_write_ex, alu_src_ex, mem_write_ex;
    logic        mem_read_ex, mem_to_reg_ex, branch_ex;
    logic [1:0]  alu_op_ex;
    logic [31:0] alu_in_a, alu_in_b, alu_result_ex;
    logic [31:0] alu_a_pre, alu_b_pre;
    logic [3:0]  alu_ctrl;
    logic        zero_ex;
    logic [31:0] branch_target_ex;
    logic [1:0]  forward_a, forward_b;
    logic [31:0] alu_result_mem, rd_data2_mem, branch_target_mem;
    logic [4:0]  rd_mem;
    logic        reg_write_mem, mem_write_mem, mem_read_mem;
    logic        mem_to_reg_mem, branch_mem, zero_mem;
    logic [31:0] mem_rd_data;
    logic        branch_taken;
    logic [31:0] alu_result_wb, mem_data_wb;
    logic [4:0]  rd_wb;
    logic        reg_write_wb, mem_to_reg_wb;
    logic [31:0] wr_data_wb;
    logic        stall, flush;

    assign rs1_id       = instr_id[19:15];
    assign rs2_id       = instr_id[24:20];
    assign rd_id        = instr_id[11:7];
    assign funct3_id    = instr_id[14:12];
    assign funct7_id    = instr_id[31:25];
    assign imm_id       = {{20{instr_id[31]}}, instr_id[31:20]};
    assign branch_taken = branch_mem && zero_mem;
    assign branch_target_ex = pc_ex + (imm_ex << 1);
    assign pc_next      = branch_taken ? branch_target_mem : pc_current + 32'd4;
    assign wr_data_wb   = mem_to_reg_wb ? mem_data_wb : alu_result_wb;
    assign alu_a_pre    = (forward_a == 2'b10) ? alu_result_mem :
                          (forward_a == 2'b01) ? wr_data_wb : rd_data1_ex;
    assign alu_in_a     = alu_a_pre;
    assign alu_b_pre    = (forward_b == 2'b10) ? alu_result_mem :
                          (forward_b == 2'b01) ? wr_data_wb : rd_data2_ex;
    assign alu_in_b     = alu_src_ex ? imm_ex : alu_b_pre;

    pc u_pc (.clk(clk), .rst(rst), .stall(stall),
             .pc_next(pc_next), .pc_out(pc_current));

    instr_mem u_instr_mem (.addr(pc_current), .instr(instr_if));

    if_id_reg u_if_id (.clk(clk), .rst(rst), .stall(stall), .flush(flush),
                       .pc_in(pc_current), .instr_in(instr_if),
                       .pc_out(pc_id), .instr_out(instr_id));

    control_unit u_ctrl (.opcode(instr_id[6:0]),
                         .reg_write(reg_write_id), .alu_src(alu_src_id),
                         .mem_write(mem_write_id), .mem_read(mem_read_id),
                         .mem_to_reg(mem_to_reg_id), .branch(branch_id),
                         .alu_op(alu_op_id));

    register_file u_regfile (.clk(clk), .rst(rst),
                              .rs1(rs1_id), .rs2(rs2_id), .rd(rd_wb),
                              .wr_data(wr_data_wb), .reg_write(reg_write_wb),
                              .rd_data1(rd_data1_id), .rd_data2(rd_data2_id));

    id_ex_reg u_id_ex (.clk(clk), .rst(rst), .flush(flush),
                       .reg_write_in(reg_write_id), .alu_src_in(alu_src_id),
                       .mem_write_in(mem_write_id), .mem_read_in(mem_read_id),
                       .mem_to_reg_in(mem_to_reg_id), .branch_in(branch_id),
                       .alu_op_in(alu_op_id), .pc_in(pc_id),
                       .rd_data1_in(rd_data1_id), .rd_data2_in(rd_data2_id),
                       .imm_in(imm_id), .rs1_in(rs1_id), .rs2_in(rs2_id),
                       .rd_in(rd_id), .funct3_in(funct3_id), .funct7_in(funct7_id),
                       .reg_write_out(reg_write_ex), .alu_src_out(alu_src_ex),
                       .mem_write_out(mem_write_ex), .mem_read_out(mem_read_ex),
                       .mem_to_reg_out(mem_to_reg_ex), .branch_out(branch_ex),
                       .alu_op_out(alu_op_ex), .pc_out(pc_ex),
                       .rd_data1_out(rd_data1_ex), .rd_data2_out(rd_data2_ex),
                       .imm_out(imm_ex), .rs1_out(rs1_ex), .rs2_out(rs2_ex),
                       .rd_out(rd_ex), .funct3_out(funct3_ex), .funct7_out(funct7_ex));

    alu_control u_alu_ctrl (.alu_op(alu_op_ex), .funct3(funct3_ex),
                             .funct7(funct7_ex), .alu_ctrl(alu_ctrl));

    alu u_alu (.a(alu_in_a), .b(alu_in_b), .alu_ctrl(alu_ctrl),
               .result(alu_result_ex), .zero(zero_ex));

    ex_mem_reg u_ex_mem (.clk(clk), .rst(rst),
                          .reg_write_in(reg_write_ex), .mem_write_in(mem_write_ex),
                          .mem_read_in(mem_read_ex), .mem_to_reg_in(mem_to_reg_ex),
                          .branch_in(branch_ex), .zero_in(zero_ex),
                          .alu_result_in(alu_result_ex), .rd_data2_in(rd_data2_ex),
                          .branch_target_in(branch_target_ex), .rd_in(rd_ex),
                          .reg_write_out(reg_write_mem), .mem_write_out(mem_write_mem),
                          .mem_read_out(mem_read_mem), .mem_to_reg_out(mem_to_reg_mem),
                          .branch_out(branch_mem), .zero_out(zero_mem),
                          .alu_result_out(alu_result_mem), .rd_data2_out(rd_data2_mem),
                          .branch_target_out(branch_target_mem), .rd_out(rd_mem));

    data_mem u_data_mem (.clk(clk), .mem_write(mem_write_mem),
                          .mem_read(mem_read_mem), .addr(alu_result_mem),
                          .wr_data(rd_data2_mem), .rd_data(mem_rd_data));

    mem_wb_reg u_mem_wb (.clk(clk), .rst(rst),
                          .reg_write_in(reg_write_mem), .mem_to_reg_in(mem_to_reg_mem),
                          .alu_result_in(alu_result_mem), .mem_data_in(mem_rd_data),
                          .rd_in(rd_mem),
                          .reg_write_out(reg_write_wb), .mem_to_reg_out(mem_to_reg_wb),
                          .alu_result_out(alu_result_wb), .mem_data_out(mem_data_wb),
                          .rd_out(rd_wb));

    forwarding_unit u_fwd (.rs1_ex(rs1_ex), .rs2_ex(rs2_ex),
                            .rd_mem(rd_mem), .rd_wb(rd_wb),
                            .reg_write_mem(reg_write_mem), .reg_write_wb(reg_write_wb),
                            .forward_a(forward_a), .forward_b(forward_b));

    hazard_unit u_haz (.rs1_id(rs1_id), .rs2_id(rs2_id),
                        .rd_ex(rd_ex), .mem_read_ex(mem_read_ex),
                        .branch_taken(branch_taken),
                        .stall(stall), .flush(flush));

endmodule