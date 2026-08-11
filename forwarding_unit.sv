module forwarding_unit (
    input  logic [4:0] rs1_ex,
    input  logic [4:0] rs2_ex,
    input  logic [4:0] rd_mem,
    input  logic [4:0] rd_wb,
    input  logic       reg_write_mem,
    input  logic       reg_write_wb,
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    always_comb begin
        if (reg_write_mem && (rd_mem != 5'b0) && (rd_mem == rs1_ex))
            forward_a = 2'b10;
        else if (reg_write_wb && (rd_wb != 5'b0) && (rd_wb == rs1_ex))
            forward_a = 2'b01;
        else
            forward_a = 2'b00;
    end

    always_comb begin
        if (reg_write_mem && (rd_mem != 5'b0) && (rd_mem == rs2_ex))
            forward_b = 2'b10;
        else if (reg_write_wb && (rd_wb != 5'b0) && (rd_wb == rs2_ex))
            forward_b = 2'b01;
        else
            forward_b = 2'b00;
    end

endmodule