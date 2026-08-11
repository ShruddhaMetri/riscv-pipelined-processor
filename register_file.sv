// ============================================================
// FILE: register_file.sv
// PURPOSE: 32 registers (x0-x31), read 2 at once, write 1
// ============================================================

module register_file (
    input  logic        clk,
    input  logic        rst,
    input  logic [4:0]  rs1,       // Source register 1 address
    input  logic [4:0]  rs2,       // Source register 2 address
    input  logic [4:0]  rd,        // Destination register address
    input  logic [31:0] wr_data,   // Data to write
    input  logic        reg_write, // Write enable
    output logic [31:0] rd_data1,  // Data from rs1
    output logic [31:0] rd_data2   // Data from rs2
);

    logic [31:0] regs [0:31]; // 32 registers, each 32 bits
    integer i;

    // Reset all registers to 0
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i++)
                regs[i] <= 32'h00000000;
        end
        else if (reg_write && rd != 5'b00000) begin
            // Write to rd, but NEVER write to x0 (always 0)
            regs[rd] <= wr_data;
        end
    end

    // Read is combinational (instant, no clock)
    assign rd_data1 = (rs1 != 0) ? regs[rs1] : 32'h00000000;
    assign rd_data2 = (rs2 != 0) ? regs[rs2] : 32'h00000000;

endmodule