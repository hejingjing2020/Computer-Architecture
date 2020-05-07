/*
    For input-SrcA of ALU, 
    we need to select between rs(instr[25:21]) and shamt[10:6])

    ALUControl:
        SLL = 01110; (shamt)
        SLLV = 01111; (rs)
        SRL = 10000; (shamt)
        SRLV = 10001; (rs)
        SRA = 10010; (shamt)
        SRAV = 10011; (rs)
*/
module selector(
    input [31:0] rs_data,
    input [31:0] imm,
    input [4:0] ALUControl,

    output wire [31:0] SrcAE
);

reg [4:0] shamt;
reg [31:0] _SrcAE;

parameter [4:0] SLL = 5'b01110, // shamt

        SLLV = 5'b01111, // rs

        SRL = 5'b10000, // shamt

        SRLV = 5'b10001, // rs

        SRA = 5'b10010, //shamt

        SRAV = 5'b10011; //rs


    always @ (rs_data or imm or ALUControl)
        begin
        shamt = imm[10:6];
            case (ALUControl)
                SLL,SRL,SRA:
                begin
                    _SrcAE <= shamt;
                end

                default:
                begin
                    _SrcAE <= rs_data;
                end
            endcase
        end

    assign SrcAE = _SrcAE;

endmodule