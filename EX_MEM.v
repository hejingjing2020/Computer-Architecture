module EX_MEM(
    input wire clock,

    input wire RegWriteE,
    input wire MemtoRegE,
    input wire MemWriteE,
    input wire flagZero,
    input wire [31:0] ALUOutE,
    input wire [31:0] WriteDataE,
    input wire [4:0] WriteRegE,

    output reg RegWriteM,
    output reg MemtoRegM,
    output reg MemWriteM,
    output reg ZeroM,
    output reg [31:0] ALUOutM,
    output reg [31:0] WriteDataM,
    output reg [4:0] WriteRegM
);

    always @ (posedge clock)
        begin
            RegWriteM <= RegWriteE;
            MemtoRegM <= MemtoRegE;
            MemWriteM <= MemWriteE;
            ZeroM <= flagZero;
            ALUOutM <= ALUOutE;
            WriteDataM <= WriteDataE;
            WriteRegM <= WriteRegE;
        end

endmodule