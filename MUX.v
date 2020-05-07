module MUX_32b(in1, in2, cs, out);

output reg [31:0] out;

input wire [31:0] in1, in2;
input wire cs;


always @ (*)
begin
    if (cs==1'b1) begin
        out<=in2;
    end

    else begin
        out<=in1;
    end

end
endmodule

module MUX_5b(in1, in2, cs, out);

output wire [4:0] out;

input wire [4:0] in1, in2;
input wire cs;

reg[4:0] _out;

always @(cs or in1 or in2)
begin
if (cs==1'b0)
    _out=in1;

else _out=in2;
end
assign out = _out[4:0];
endmodule