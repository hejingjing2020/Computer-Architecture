/*
    Module: instruction memory
    Store all the instructions to excute.
*/

`include "define.v"

module instrMem(
    input [31:0] A,

    output wire [31:0] RD
    );

    reg [31:0] instr [256:0];

    initial
        begin
        // instr1
            instr[0]  <= {`lw, `gr0, `gr1, 16'h0003}; // lw gr1 <- address(32'b0+h0003)
            instr[4]  <= `nop;
            instr[8]  <= `nop;
            instr[12] <= `nop;
            instr[16] <= `nop;
            // now: gr1 = 3, gr2 = 0, gr3 = 0
        // instr2
            instr[20] <= {`lw, `gr0, `gr2, 16'h0002}; // lw gr2 <- address(32'b0+h0002)
            instr[24] <= `nop;
            instr[28] <= `nop;
            instr[32] <= `nop;
            instr[36] <= `nop;
            // now: gr1 = 0, gr2 = 2, gr3 = 0
        // instr3
            instr[40] <= {`lw, `gr0, `gr3, 16'h0001}; // lw gr3 <- address(32'b0+h0001)
            instr[44] <= `nop;
            instr[48] <= `nop;
            instr[52] <= `nop;
            instr[56] <= `nop;
            // now: gr1 = 3, gr2 = 2, gr3 = 1
        // instr4
            instr[60] = {6'b000000, `gr1, `gr2, `gr3, 5'b00000, `add}; // add gr3 <- gr1 + gr2
            instr[64] <= `nop;
            instr[68] <= `nop;
            instr[72] <= `nop;
            instr[76] <= `nop;
            // now: gr1 = 3, gr2 = 2, gr3 = 5
        // instr5
            instr[80] <= {`sll, `gr1, `gr2, 5'b00001, `add}; // sll gr1 <- gr2 << 1
            instr[84] <= `nop;
            instr[88] <= `nop;
            instr[92] <= `nop;
            instr[96] <= `nop;
            // now: gr1 = 4, gr2 = 2, gr3 = 5
        // instr6
            instr[100] <= {`addi, `gr2, `gr1, 16'h0001}; // addi gr1 <- gr2 + 1
            instr[104] <= `nop;
            instr[108] <= `nop;
            instr[112] <= `nop;
            instr[116] <= `nop;
            // now: gr1 = 4, gr2 = 3, gr3 = 5
        // instr7
            instr[120] <= {6'd0, `gr1, `gr2, `gr3, 5'd0, `AND}; // and gr3 = gr1 & gr2
            instr[124] <= `nop;
            instr[128] <= `nop;
            instr[132] <= `nop;
            instr[136] <= `nop;
            // now: gr1 = 4, gr2 = 3, gr3 = 0
        // instr8
            instr[140]<= {`beq, `gr5, `gr6, 16'h0004}; // beq
            instr[144] <= `nop;
            instr[148] <= `nop;
            instr[152] <= `nop;
            instr[156] <= `nop;
            // now: branch to instr9
        // instr9
            instr[160]<= {`j, 26'd0}; // j to pc = 0
            instr[164] <= `nop;
            instr[168] <= `nop;
            instr[172] <= `nop;
            instr[176] <= `nop;
            // now: branch to instr1
        end

    assign RD = instr[A];

endmodule