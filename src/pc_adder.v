// add 4 to in (pc) and output the result
module pc_adder (
    input [31:0] in,
    output [31:0] out
);
    assign out = in + 32'd4;
endmodule