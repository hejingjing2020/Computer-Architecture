module alu(ALUControl,SrcAE,SrcBE,ALUresult,flagZero,flagNeg,flagOverflow);

    output reg [31:0] ALUresult;

    output reg flagZero;
    output reg flagNeg;
    output reg flagOverflow;

    input signed[31:0] SrcAE, SrcBE;
    input signed[4:0] ALUControl;

    reg [31:0] ALUOutE;//output
    reg[5:0] opcode, func;

    reg[31:0] reg_A, reg_B, reg_C, reg_hi, reg_lo;
    reg sign = 1'b0;

    reg signed[31:0] signed_A, signed_B;
    integer idx;

    parameter [4:0] AND = 5'b00000,

            OR = 5'b00001,

            ADD = 5'b00010,

            ADDU = 5'b00011,

            DIV = 5'b00100,

            XOR = 5'b00101,

            SUB = 5'b00110,

            SLT = 5'b00111,

            SLTU = 5'b01000,

            MULT = 5'b01001,

            MULTU = 5'b01010,

            DIVU = 5'b01011,

            SUBU = 5'b01100,

            NOR = 5'b01101,

            SLL = 5'b01110,

            SLLV = 5'b01111,

            SRL = 5'b10000,

            SRLV = 5'b10001,

            SRA = 5'b10010,

            SRAV = 5'b10011;


    always @ (SrcAE or SrcBE or ALUControl) // sensitivity list
    begin

    //SrcAE - instruction[25:21](rs)
    //SrcBE - instruction[20:16](rt)

    reg_A = SrcAE; //rs
    signed_A = SrcAE;
    reg_B = SrcBE; //rt
    signed_B = SrcBE;

    case(ALUControl)

        AND:
        begin
            reg_C = reg_A & reg_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
        end

        OR:
        begin
            reg_C = reg_A | reg_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
        end

        ADD:
        begin
            reg_C = reg_A + reg_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
            //trap overflow
            if((reg_A >= 0) && (reg_B >= 0) && (flagNeg==1)) flagOverflow <= 1'b1;
            else if((reg_A < 0) && (reg_B < 0) && (flagNeg==0)) flagOverflow <= 1'b1;
            else flagOverflow <= 1'b0;
        end

        ADDU:
        begin
            flagOverflow <= 1'b0;
            reg_C = reg_A + reg_B;
            flagNeg = 0;
            flagZero = (reg_C==32'b0);
        end

        SUB:
        begin
            reg_C = reg_A - reg_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
            //trap overflow
            if((reg_A[31] == 0) && (reg_B[31] == 1) && (flagNeg == 1)) flagOverflow <= 1'b1;
            else if((reg_A[31] == 1) && (reg_B[31] == 0) && (flagNeg == 0)) flagOverflow <= 1'b1;
        end

        SLT://signed extend
        begin
            reg_C = signed_A - signed_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
        end

        SLTU:
        begin
            flagNeg = (reg_A<reg_B);
            flagZero = (reg_C==32'b0);
        end

        AND:
        begin
            reg_C = reg_A & reg_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
        end

        MULT:
        begin
            reg_C = signed_A * signed_B;
            reg_hi = reg_C[31:16];
            reg_lo = reg_C[15:0];
        end

        MULTU:
        begin
            reg_C = reg_A * reg_B;
            reg_hi = reg_C[31:16];
            reg_lo = reg_C[15:0];
        end

        OR:
        begin
        reg_C = reg_A | reg_B;
        flagNeg = reg_C[31];
        flagZero = (reg_C==32'b0);
        end

        SUBU:
        begin
            flagOverflow <= 1'b0;
            reg_C = reg_A - reg_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
        end

        NOR:
        begin
            reg_C = reg_A ~| reg_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
        end

        XOR:
        begin
            reg_C = reg_A ^ reg_B;
            flagNeg = reg_C[31];
            flagZero = (reg_C==32'b0);
        end

        SLL:
        begin
            reg_C = reg_B << reg_A;
        end

        SLLV:
        begin
            reg_C = reg_B << reg_A;
        end

        SRL:
        begin
            reg_C = reg_B >> (SrcBE);
        end        

        SRLV:
        begin
            reg_C = reg_A >> reg_B;
        end

        SRA:
        begin
            sign = reg_A[31];
            reg_B = SrcBE;
            reg_C = reg_A >> reg_B;
            for(idx = 31; idx >= 31-reg_B; idx = idx-1)
            begin
                reg_C[idx] = sign;
            end
        end

        SRAV:
        begin
            sign = reg_A[31];
            reg_C = reg_A >> reg_B;
            begin
                reg_C[idx] = sign;
            end
        end
    endcase
    ALUresult = reg_C;
    end


endmodule


