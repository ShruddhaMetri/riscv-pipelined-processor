module data_mem (
    input  logic        clk,
    input  logic        mem_write,
    input  logic        mem_read,
    input  logic [31:0] addr,
    input  logic [31:0] wr_data,
    output logic [31:0] rd_data
);

    logic [31:0] mem [0:255];

    always_ff @(posedge clk) begin
        if (mem_write)
            mem[addr[9:2]] <= wr_data;
    end

    assign rd_data = mem_read ? mem[addr[9:2]] : 32'h00000000;

endmodule