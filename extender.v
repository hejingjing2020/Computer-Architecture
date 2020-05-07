/*
    Module: Extender
    Sign-extend or unsigned-extend the immediate.
*/
module extender(i_datain, ALUControl, extended);

    input signed[15:0] i_datain;
    input signed[4:0] ALUControl;

    output wire [31:0] extended;

    reg [31:0] _extended;
    reg[15:0] imm;

    parameter [4:0] SLTU = 5'b01000,

            SLL = 5'b01110,

            SLLV = 5'b01111,

            SRL = 5'b10000,

            SRLV = 5'b10001,

            SRA = 5'b10010,

            SRAV = 5'b10011;


    always @(i_datain or ALUControl)
    begin
        imm = i_datain[15:0];
        case (ALUControl)
            SLTU, SLL, SLLV, SRL, SRLV, SRA, SRAV:
                begin
                    _extended[31:0] = {16'b0, imm};
                 end
            
            default:
                _extended[31:0] = { {17{imm[15]}}, imm[14:0] };
        endcase

    end

    assign extended = _extended;

endmodule