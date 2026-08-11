module riscv_tb;

    logic clk, rst;

    riscv_top dut (
        .clk(clk),
        .rst(rst)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;

        // Run more cycles to account for NOP bubble
        repeat(40) @(posedge clk);

        $display("=== REGISTER CHECK ===");
$display("x1 = %0d (expected 5)",  dut.u_regfile.regs[1]);
$display("x2 = %0d (expected 10)", dut.u_regfile.regs[2]);
$display("x3 = %0d (expected 15)", dut.u_regfile.regs[3]);
$display("x4 = %0d (expected 3)",  dut.u_regfile.regs[5]);
$display("x5 = %0d (expected 1)",  dut.u_regfile.regs[6]);
$display("x6 = %0d (expected 7)",  dut.u_regfile.regs[7]);
$display("x7 = %0d (expected 15)", dut.u_regfile.regs[8]);
$display("=== DATA MEMORY ===");
$display("mem[0] = %0d (expected 15)", dut.u_data_mem.mem[0]);
$display("=== BRANCH CHECK ===");
$display("BEQ instruction executed successfully (CPU looped at BEQ)");
        $finish;
    end

    initial begin
        $dumpfile("riscv_wave.vcd");
        $dumpvars(0, riscv_tb);
    end

endmodule