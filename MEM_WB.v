module MEM_WB(
    input wire clock,

    input wire RegWriteM,
    input wire MemtoRegM,
    input wire [31:0] ALUOutM,
    input wire [31:0] RD,
    input wire [4:0] WriteRegM,

    output reg RegWriteW,
    output reg MemtoRegW,
    output reg [31:0] ALUOutW,
    output reg [31:0] ReadDataW,
    output reg [4:0] WriteRegW
);


    always @(posedge clock)
        begin
            RegWriteW <= RegWriteM;
            MemtoRegW <= MemtoRegM;
            ALUOutW <= ALUOutM;
            ReadDataW <= RD;
            WriteRegW <= WriteRegM;
        end


endmodule