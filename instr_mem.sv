module instr_mem (
    input  logic [31:0] addr,
    output logic [31:0] instr
);

    logic [31:0] mem [0:255];

    initial begin
        mem[0]  = 32'h00500093; // ADDI x1, x0, 5
        mem[1]  = 32'h00A00113; // ADDI x2, x0, 10
        mem[2]  = 32'h002081B3; // ADD  x3, x1, x2
        mem[3]  = 32'h00000013; // NOP  (bubble to let x3 settle)
        mem[4]  = 32'h40118233; // SUB  x4, x3, x1
        mem[5]  = 32'h00300293; // ADDI x5, x0, 3
        mem[6]  = 32'h0050F333; // AND  x6, x1, x5
        mem[7]  = 32'h0050E3B3; // OR   x7, x1, x5
        mem[8]  = 32'h00302023; // SW   x3, 0(x0)
        mem[9]  = 32'h00002403; // LW   x8, 0(x0)
        mem[10] = 32'h00108063; // BEQ  x1, x1, 0
        mem[11] = 32'h00000013; // NOP
        mem[12] = 32'h00000013; // NOP
        mem[13] = 32'h00000013; // NOP
        mem[14] = 32'h00000013; // NOP
        mem[15] = 32'h00000013; // NOP
        mem[16] = 32'h00000013; // NOP
        mem[17] = 32'h00000013; // NOP
        mem[18] = 32'h00000013; // NOP
        mem[19] = 32'h00000013; // NOP
        mem[20] = 32'h00000013; // NOP
        mem[21] = 32'h00000013; // NOP
        mem[22] = 32'h00000013; // NOP
        mem[23] = 32'h00000013; // NOP
        mem[24] = 32'h00000013; // NOP
        mem[25] = 32'h00000013; // NOP
        mem[26] = 32'h00000013; // NOP
        mem[27] = 32'h00000013; // NOP
        mem[28] = 32'h00000013; // NOP
        mem[29] = 32'h00000013; // NOP
        mem[30] = 32'h00000013; // NOP
        mem[31] = 32'h00000013; // NOP
    end

    assign instr = mem[addr[9:2]];

endmodule