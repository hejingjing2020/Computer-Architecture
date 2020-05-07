/*
    Module :register file
    Implement 32 general registers.
*/
module regFile(
    input wire clock,
    input wire [4:0] Readreg1,
    input wire [4:0] Readreg2,
    input wire [4:0] Writereg,// write address
    input wire [31:0] Writedata,
    input wire RegWrite,// write enable
    output wire [31:0] Readdata1,
    output wire [31:0] Readdata2
    );

    // The register on the Write register input is written 
    // with the value on the Write data input.
    reg [31:0] gr[31:0]; // 32 registers
    reg [31:0] out_data1;
    reg [31:0] out_data2;

    //initial gr[0] <= 0
    initial
        begin
            gr[0] <= 32'b0;
        end

    // write at negedge
    always @ (negedge clock)
        begin
            if (RegWrite == 1'b1) begin// if write enalbled
                gr[Writereg] <= Writedata;
            end
        end
    // output data
    assign Readdata1 = gr[Readreg1];
    assign Readdata2 = gr[Readreg2];

endmodule