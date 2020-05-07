/*
    Note:
    - The test instructions is written in module instrMem.
    - For ease of test, only gr0-3 are used.
    - For ease of test, data written in dataMem[x] is set to integer x.
*/

`include "CPU.v"

`timescale 1ns/1ps

module CPU_test;

    // Inputs
	reg clock;
    reg start;

    CPU uut(
        .clock(clock),
        .start(start)
    );

    initial begin
        // Initialize Inputs
        clock = 0;
        start = 1;

    $display("    pc    :        instruction             :  gr0   :  gr1   :  gr2   :  gr3");
    $monitor("%d:%b:%h:%h:%h:%h",
        uut.PCF, uut.InstrD, uut.gr[0], uut.gr[1], uut.gr[2], uut.gr[3]);

    # 4000
    $finish;
    end

parameter period = 100;
always #50 clock = ~clock;
endmodule