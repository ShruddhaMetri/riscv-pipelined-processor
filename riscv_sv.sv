// ============================================================
// FILE: pc.sv
// PURPOSE: Program Counter - tracks which instruction to fetch
// ============================================================

module pc (
    input  logic        clk,        // Clock signal - drives everything
    input  logic        rst,        // Reset - sends PC back to 0
    input  logic        stall,      // If 1, freeze PC (don't move forward)
    input  logic [31:0] pc_next,    // The next address to jump to
    output logic [31:0] pc_out      // Current PC value (sent to instr memory)
);

    // This always block runs on every RISING EDGE of the clock
    always_ff @(posedge clk or posedge rst) begin
        
        if (rst) begin
            pc_out <= 32'h00000000;  // On reset, go back to address 0
        end
        
        else if (stall) begin
            pc_out <= pc_out;        // If stalled, hold current value (freeze)
        end
        
        else begin
            pc_out <= pc_next;       // Normal operation: move to next address
        end
        
    end

endmodule