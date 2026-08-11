// ============================================================
// FILE: hazard_unit.sv
// PURPOSE: Detects load-use hazards and branch hazards
//          Inserts stalls and flushes as needed
// ============================================================

module hazard_unit (
    input  logic [4:0] rs1_id,       // rs1 being decoded in ID
    input  logic [4:0] rs2_id,       // rs2 being decoded in ID
    input  logic [4:0] rd_ex,        // rd being computed in EX
    input  logic       mem_read_ex,  // Is EX stage a LOAD?
    input  logic       branch_taken, // Did branch resolve as taken?
    output logic       stall,        // Freeze PC and IF/ID
    output logic       flush         // Clear IF/ID and ID/EX
);

    // Load-use hazard: LW followed immediately by use of loaded value
    // We MUST stall 1 cycle - forwarding alone can't fix this
    always_comb begin
        if (mem_read_ex && (rd_ex == rs1_id || rd_ex == rs2_id))
            stall = 1'b1;
        else
            stall = 1'b0;
    end

    // Branch flush: if branch taken, wrong instructions are in pipeline
    assign flush = branch_taken;

endmodule