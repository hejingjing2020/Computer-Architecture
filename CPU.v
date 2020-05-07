`include "ALU_control.v"
`include "ALU.v"
`include "control_unit.v"
`include "dataMem.v"
`include "regFile.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "MUX.v"
`include "selector.v"
`include "extender.v"

`timescale 1ns / 1ps

module CPU(
    input wire clock,
    input wire start
    );

    reg [31:0]gr[7:0];//[31:0]for 32bit MIPS processor
    reg [31:0]pc = 32'h00000000;

    reg [31:0]instr;
    reg [31:0]reg_A;
    reg [31:0]reg_B;
    reg [31:0]reg_C;
    reg [31:0]reg_C1;


    reg [5:0] opcode;
    reg [5:0] functcode;
    reg [25:0] jump_offset;

    wire [31:0] PCBranchD;
    wire PCSrcM;
    wire [31:0] PC; // final pc, after combining branch and jump
    wire [31:0] PCF; // pc after passing through 1 flipflop
    wire [31:0] branch_PC; // pc after combining branch address
    wire [31:0] InstrD;
    // inputs of regFile
    wire RegDst;
    wire [4:0] WriteRegW;
    wire [31:0] ResultW;
    wire [31:0] Writedata;
    // outputs of RegFile
    wire [31:0] Readdata1;
    wire [31:0] Readdata2;
    // outputs of control unit
    wire RegDstJumpD;
    wire RegWriteD;
    wire MemtoRegD;
    wire MemWriteD;
    wire [1:0] BranchD;
    wire [4:0] ALUControlD;
    wire [3:0] ALUOp;
    wire ALUSrcD;
    wire RegDstD;
    // other inputs of 1st flipflop
    wire PCSrcD;
    wire [4:0] RtD;
    wire [4:0] RdD;
    wire [31:0] ImmD;
    wire [31:0] PCPlus4D;
    // outputs of 1st flipflop
    wire RegWriteE;
    wire MemtoRegE;
    wire MemWriteE;
    wire BranchE;
    wire [4:0] ALUControlE;
    wire ALUSrcE;
    wire RegDstE;
    wire [31:0] SrcAE;
    wire [31:0] Readdata1E;// WriteData2
    wire [31:0] Readdata2E;// WriteData2
    wire [4:0] RtE;
    wire [4:0] RdE;
    wire [31:0] ImmE;
    wire [31:0] PCPlus4E;
    wire [31:0] SrcBE;
    wire [31:0] ALUOutE;
    wire [4:0] WriteRegE;
    wire [31:0] AdderResult;
    wire [31:0] WriteDataE;//Readdata2;
    wire flagNeg;
    wire flagOverflow;
    wire flagZero;
    // wires between 3rd flipflop and 4th flipflop
    wire RegWriteM;
    wire MemtoRegM;
    wire MemWriteM;
    wire BranchM;
    wire ZeroM;
    wire [31:0] ALUOutM;
    wire [31:0] WriteDataM;
    wire [4:0] WriteRegM;
    wire [31:0] RD;
    // wires after 4th flipflop
    wire RegWriteW;
    wire MemtoRegW;
    wire [31:0] ALUOutW;
    wire [31:0] ReadDataW;
    wire [31:0] four=32'd4;

    integer i = 0;

///////////////////////
/// connect circuit ///
///////////////////////

    // Instruction Fetch
    IF_ID IF_ID(.clock(clock), .clr(PCSrcD), .start(start), .jump_offset(jump_offset), 
                .RegDstJump(RegDstJumpD), .PCBranch(PCBranchD), .PCSrc(PCSrcD),
                .PCF(PCF), .instr_out(InstrD));
    // PCSrcD for branch instruction
    pc_srcD pc_srcD(.BranchD(BranchD), .data1(Readdata1), .data2(Readdata2), .PCSrcD(PCSrcD));
    // ALU
    control_unit control_unit(.Op(opcode), .funct(functcode), .RegDst(RegDstD), .MemRead(MemReadD),.MemWrite(MemWriteD),
                            .Branch(BranchD), .ALUSrc(ALUSrcD), .MemtoReg(MemtoRegD), .RegWrite(RegWriteD), .RegDstJump(RegDstJumpD), .ALUOp(ALUOp));

    ALU_control alu_control(.funct(InstrD[5:0]), .ALUOp(ALUOp), .ALUControl(ALUControlD));

    regFile regFile(.clock(clock), .Readreg1(InstrD[25:21]), .Readreg2(InstrD[20:16]), .Writereg(WriteRegW), .Writedata(ResultW), .RegWrite(RegWriteW),
                    .Readdata1(Readdata1), .Readdata2(Readdata2));

    extender extender(.i_datain(InstrD[15:0]), .ALUControl(ALUControlD), .extended(ImmD));

    pc_branchD pc_branchD(.imm(ImmD), .PCBranchD(PCBranchD));


    ID_EX ID_EX(
        .clock(clock),
        .RegWriteD(RegWriteD),
        .MemtoRegD(MemtoRegD),
        .MemWriteD(MemWriteD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RegDstD(RegDstD),
        .Readdata1(Readdata1),
        .Readdata2(Readdata2),
        .RtD(InstrD[20:16]),
        .RdD(InstrD[15:11]),
        .ImmD(ImmD),
        .PCPlus4D(PCPlus4D),
        // outputs
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .RegDstE(RegDstE),
        .SrcAE(Readdata1E),
        .Readdata2E(Readdata2E),
        .RtE(RtE),
        .RdE(RdE),
        .ImmE(ImmE),
        .PCPlus4E(PCPlus4E)
    );
    // Rt or Rd
    MUX_5b MUX2(RtE, RdE, RegDstE, WriteRegE);
    // reg_B or immediate
    MUX_32b MUX3(Readdata2E, ImmE,ALUSrcE,SrcBE);
    // select rs or shamt
    selector selector(.rs_data(Readdata1E), .imm(ImmE), .ALUControl(ALUControlE), .SrcAE(SrcAE));
    // ALU
    alu alu(.ALUControl(ALUControlE),.SrcAE(SrcAE),.SrcBE(SrcBE),.ALUresult(ALUOutE),.flagZero(flagZero),.flagNeg(flagNeg),.flagOverflow(flagOverflow));

    EX_MEM EX_MEM(
        clock,
        RegWriteE,
        MemtoRegE,
        MemWriteE,
        flagZero,
        ALUOutE,
        WriteDataE,
        WriteRegE,

        RegWriteM,
        MemtoRegM,
        MemWriteM,
        ZeroM,
        ALUOutM,
        WriteDataM,
        WriteRegM
    );
    // data memory
    dataMem dataMem(clock, ALUOutM, WriteDataM, MemWriteM, RD);

    MEM_WB MEM_WB(
        .clock(clock),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .ALUOutM(ALUOutM),
        .RD(RD),
        .WriteRegM(WriteRegM),

        .RegWriteW(RegWriteW),
        .MemtoRegW(MemtoRegW),
        .ALUOutW(ALUOutW),
        .ReadDataW(ReadDataW),
        .WriteRegW(WriteRegW)
    );
    // ALU result or data read
    MUX_32b MUX4(.in1(ALUOutW), .in2(ReadDataW), .cs(MemtoRegW), .out(ResultW));

///////////////////////
/// initialization  ///
///////////////////////

// initialize all registers with 0
always @ (start)
    begin
        while (i<=31)
            begin
                regFile.gr[i] = 32'b0;
                i = i + 1;
            end

        pc = 16'd0;
    end
////////////////////////////
/// update op and funct  ///
////////////////////////////

always @ (InstrD)
    begin
        opcode = InstrD[31:26];
        functcode = InstrD[5:0];
        jump_offset = InstrD[25:0];
    end

///////////////////////
///   show result   ///
///////////////////////
always @(posedge clock)
    begin
        gr[0] = regFile.gr[0];
        gr[1] = regFile.gr[1];
        gr[2] = regFile.gr[2];
        gr[3] = regFile.gr[3];

    end

endmodule


// generate PCBranchD
// Note: The output is linked as branch offset, so we do not
// need to add PCPlus4 here.
module pc_branchD(
    input [31:0] imm,

    output reg [31:0] PCBranchD
);

    always @ (*)
        begin
            PCBranchD <= (imm<<2);
        end

endmodule


// generate PCSrcD
module pc_srcD(
    input [1:0] BranchD,
    input [31:0] data1,
    input [31:0] data2,

    output reg PCSrcD
);

    initial
        begin
            PCSrcD <= 1'b0;
        end

    always @ (*)
        begin
            if (BranchD==2'b00) begin
                PCSrcD <= 1'b0;
            end

            else if (BranchD==2'b01) begin
                PCSrcD <= (data1==data2) ? 1'b1:1'b0;
            end

            else if (BranchD==2'b10) begin
                PCSrcD <= (data1!=data2) ? 1'b1:1'b0;
            end
        end

endmodule