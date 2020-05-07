module ALU_control(funct,ALUOp,ALUControl);

    output wire [4:0] ALUControl;

    input [5:0] funct;
    input [3:0] ALUOp;

    reg[4:0] _ALUControl;
    always @(funct or ALUOp)
    begin
    case(ALUOp)

        4'b0000://add
        begin
            _ALUControl = 5'b00010;
        end

        4'b0100://addu
        begin
            _ALUControl = 5'b00011;
        end    

        4'b0001://sub
        begin
            _ALUControl = 5'b00110;
        end

        4'b0110://and
        begin
            _ALUControl = 5'b00000;
        end

        4'b0011://or
        begin
            _ALUControl = 5'b00001;
        end

        4'b0101://xor
        begin
            _ALUControl = 5'b00101;
        end

        4'b0111://slt
        begin
            _ALUControl = 5'b00111;
        end

        4'b1000://sltu
        begin
            _ALUControl = 5'b01000;
        end

        4'b0010://R-type
        begin
            case(funct)
                6'b100000://add
                begin
                    _ALUControl = 5'b00010;//add
                end

                6'b100010://sub
                begin
                    _ALUControl = 5'b00110;//sub
                end

                6'b100011://subu
                begin
                    _ALUControl = 5'b01100;//subu
                end

                6'b100100://and
                begin
                    _ALUControl = 5'b00000;//and
                end

                6'b100101://or
                begin
                    _ALUControl = 5'b00001;//or
                end

                6'b101010://R:slt
                begin
                    _ALUControl = 5'b00111;//slt
                end

                6'b101011://R:sltu
                begin
                    _ALUControl = 5'b01000;//sltu
                end

                6'b011000://R:mult
                begin
                    _ALUControl = 5'b01001;//mult
                end

                6'b011001://R:multu
                begin
                    _ALUControl = 5'b01010;//multu
                end

                6'b011010://R:div
                begin
                    _ALUControl = 5'b00100;//div
                end

                6'b011011://R:divu
                begin
                    _ALUControl = 5'b01011;//divu
                end

                6'b100110://xor
                begin
                    _ALUControl = 5'b00101;
                end

                6'b100111://nor
                begin
                    _ALUControl = 5'b01101;
                end

                6'b000000://sll(shamt)
                begin
                    _ALUControl = 5'b01110;
                end

                6'b000100://sllv
                begin
                    _ALUControl = 5'b01111;
                end

                6'b000010://srl
                begin
                    _ALUControl = 5'b10000;
                end

                6'b000110://srlv
                begin
                    _ALUControl = 5'b10001;
                end

                6'b000011://sra
                begin
                    _ALUControl = 5'b10010;
                end

                6'b000111://srav
                begin
                    _ALUControl = 5'b10011;
                end
            endcase
        end

    endcase

    end

    assign ALUControl = _ALUControl;
endmodule