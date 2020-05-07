
/*
    Module: control unit
*/
module control_unit(Op, funct, RegDst,MemRead,MemWrite,
Branch,ALUSrc,MemtoReg,RegWrite,RegDstJump,ALUOp);
    output signed[0:0] RegDst;
    output signed[0:0] MemRead;
    output signed[0:0] MemWrite;
    output signed[1:0] Branch;
    output [0:0] ALUSrc;
    output signed[0:0] MemtoReg;
    output wire [0:0] RegWrite;
    output wire [0:0] RegDstJump;
    output wire [3:0] ALUOp;

    input [5:0] Op;//6 bits
    input [5:0] funct;
/*:
    0: The register destination number for the Write register comes from 
    the rt field (bits 20:16).
    1: The register destination number for the Write register comes from 
    the rd field (bits 15:11).
*/
reg [0:0] _RegDst;
reg [0:0] _MemRead;
reg [0:0] _MemWrite;
reg [0:0] _Branch;
reg [3:0] _ALUOp;
reg [0:0] _ALUSrc;
reg [0:0] _MemtoReg;
reg [0:0] _RegWrite;
reg [0:0] _RegDstJump;

always @(Op or funct)

begin

case(Op)

    6'b000010: //j
    begin
    _RegDst = 0;
    _Branch = 00;
    _RegDstJump = 1;
    _RegWrite = 0;
    end

    6'b000011: //jal: Save the address of the next instruction in register $ra.
    begin
    _RegDst = 0;
    _Branch = 00;
    _RegDstJump= 1;
    _RegWrite = 1;
    end

    6'b100011: //lw
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 1;
    _RegWrite = 1;
    _MemRead = 1;
    _MemWrite = 0;
    _Branch = 00;
    _ALUOp = 4'b0000; //add
    _RegDstJump = 0;
    end

    6'b101011: //sw
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 1;
    _Branch = 00;
    _ALUOp = 4'b0000; //add
    _RegDstJump = 0;
    end

    6'b000100: //beq
    begin
    _RegDst = 0;
    _ALUSrc = 0;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 01;
    _ALUOp = 4'b0001; //sub
    _RegDstJump = 0;
    end

    6'b000101: //bne
    begin
    _RegDst = 0;
    _ALUSrc = 0;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 10;
    _ALUOp = 4'b0001; //sub
    _RegDstJump = 0;
    end

    6'b001000: //addi
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 0;
    _RegWrite = 1;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 00;
    _ALUOp = 4'b0000; //add
    _RegDstJump = 0;
    end

    6'b001001: //addiu
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 00;
    _ALUOp = 4'b0100; //addu
    _RegDstJump = 0;
    end

    6'b001101://ori
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 00;
    _ALUOp = 4'b0011; //or 
    _RegDstJump = 0;
    end

    6'b001110://xori
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 00;
    _ALUOp = 4'b0101; //xor 
    _RegDstJump = 0;
    end

    6'b001010://slti
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 00;
    _ALUOp = 4'b0111; //slt 
    _RegDstJump = 0;
    end

    6'b001010://sltiu
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 0;
    _ALUOp = 4'b1000; //sltu 
    _RegDstJump = 0;
    end

    6'b001101://andi
    begin
    _RegDst = 0;
    _ALUSrc = 1;
    _MemtoReg = 0;
    _RegWrite = 0;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 00;
    _ALUOp = 4'b0110; //and
    _RegDstJump = 0;
    end

    6'b000000: //R type
    begin
    _RegDst = 1;
    _ALUSrc = 0;
    _MemtoReg = 0;
    _RegWrite = 1;
    _MemRead = 0;
    _MemWrite = 0;
    _Branch = 00;
    _ALUOp = 4'b0010; //r
    _RegDstJump = 0;
    end

endcase

end


assign RegDst=_RegDst;
assign MemRead=_MemRead;
assign MemWrite=_MemWrite;
assign Branch=_Branch;
assign ALUSrc=_ALUSrc;
assign MemtoReg=_MemtoReg;
assign RegWrite=_RegWrite;
assign ALUOp = _ALUOp;
assign RegDstJump = _RegDstJump;

endmodule