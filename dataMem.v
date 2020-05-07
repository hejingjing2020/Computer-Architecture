
/*
    Module: Data memory
    Implement data memory.

    Note: For ease of test, MEM[x] = x.
*/
module dataMem (
    input wire clock,
    input wire [31:0] ALUOutM,       // Memory Address
    input wire [31:0] WriteDataM,    // Memory Address Contents
    input wire MemWriteM,
    output reg [31:0] RD      // Output of Memory Address Contents
);

    reg [31:0] MEM[0:255];  // 256 words of 32-bit memory

    integer i;

    initial
        begin
            RD <= 0;
            for (i = 0; i < 256; i = i + 1) begin
            MEM[i] = i;
            end
        end

    always @(negedge clock) 
        begin
            if (MemWriteM == 1'b1) begin
                MEM[ALUOutM] <= WriteDataM;
            end

            else begin
                RD <= MEM[ALUOutM];
            end
        end

endmodule