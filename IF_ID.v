/*
    Stage: IF
    Function: Select pc with value of pc+4 or branch address (pc += offset)
        or jump address (pc = address).
*/
`include "instrMem.v"

module IF_ID(
    input wire start,
    input wire clr,
    input wire clock,
    input [25:0] jump_offset,
    input wire RegDstJump,
    input wire [31:0] PCBranch,
    input wire PCSrc, // decide whether branch or not

    output wire [31:0] PCF,
    output reg [31:0] instr_out
);

    wire [31:0] PC;
    wire [31:0] offset; // The offset pc that should be added with
    wire [31:0] PC_Adderout;
    wire [31:0] PC_out;
    wire [31:0] RD;

    reg [31:0] JumpAddr;

    // Calculate the jump address
    always @(*)
        begin
            JumpAddr <=  {(PCF[31:28]) , jump_offset, 2'b00};
        end
    

// pc += (branch offset) or (4)?
    MUX_32b pc_offset(
        .in1(32'd4),
        .in2(PCBranch),
        .cs(PCSrc),
        .out(offset)
    );

// pc += offset
    Adder adder(.in1(offset), .in2(PCF), .out(PC_Adderout));
// pc = (pc+offset) or (jump address)?
    MUX_32b pc_jump(
        .in1(PC_Adderout),
        .in2(JumpAddr),
        .cs(RegDstJump),
        .out(PC_out)
    );

    program_counter pc(
        .clock(clock),
        .start(start),
        .pc_in(PC_out),
        .pc_out(PCF)
    );

    // inctructions
    instrMem instrMem(.A(PCF), .RD(RD));
    // if CLR is active, output instruction nop
    always @ (posedge clock)
        begin
            if (clr) begin
                instr_out <= 32'd0;
            end

            else begin
                instr_out <= RD;
            end
        end

endmodule


module program_counter(
    input clock,
    input start,
    input [31:0] pc_in,
    output reg [31:0] pc_out
    );

    initial
        begin
            pc_out <= 32'd0;
        end

    always @ (posedge clock) 
        begin
            pc_out <= pc_in;
        end

endmodule


module Adder (
    input [31:0] in1,
    input [31:0] in2,
    output wire [31:0] out
    );

    assign out = in1 + in2;

endmodule