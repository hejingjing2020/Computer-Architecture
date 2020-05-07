module ID_EX(
    input wire clock,
//    input wire RegDstJumpD,
    input wire RegWriteD,
    input wire MemtoRegD,
    input wire MemWriteD,
    input wire [4:0] ALUControlD,
    input wire ALUSrcD,
    input wire RegDstD,
    input wire [31:0] Readdata1,
    input wire [31:0] Readdata2,
    input wire [4:0] RtD,
    input wire [4:0] RdD,
    input wire [31:0] ImmD,
    input wire [31:0] PCPlus4D,

//    output reg RegDstJumpE,
    output reg RegWriteE,
    output reg MemtoRegE,
    output reg MemWriteE,
    output reg BranchE,
    output reg [4:0] ALUControlE,
    output reg ALUSrcE,
    output reg RegDstE,
    output reg [31:0] SrcAE,//Readdata1
    output reg [31:0] Readdata2E,
    output reg [4:0] RtE,
    output reg [4:0] RdE,
    output reg [31:0] ImmE,
    output reg [31:0] PCPlus4E
);

    always @(posedge clock)
        begin
//            RegDstJumpE <= RegDstJumpD;
            RegWriteE <= RegWriteD;
            MemtoRegE <= MemtoRegD;
            MemWriteE <= MemWriteD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            RegDstE <= RegDstD;
            SrcAE <= Readdata1;
            Readdata2E <= Readdata2;
            RtE <= RtD;
            RdE <= RdD;
            ImmE <= ImmD;
            PCPlus4E <= PCPlus4D;
        end

endmodule

