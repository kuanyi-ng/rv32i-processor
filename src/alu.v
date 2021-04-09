module alu (
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] alu_op,
    output reg [31:0] out
);
    // prepare signed inputs
    wire signed [31:0] s_in1 = in1;
    wire signed [31:0] s_in2 = in2;

    // whenever either one of in1, in2, alu_op changes,
    // this block will be run and compute a new value for out.
    always @(in1 or in2 or alu_op) begin
        case (alu_op)
            // ADD
            4'b0000: out <= s_in1 + s_in2;

            // SUB
            4'b0001: out <= s_in1 - s_in2;

            // XOR
            4'b0010: out <= s_in1 ^ s_in2;

            // OR
            4'b0011: out <= s_in1 | s_in2;

            // AND
            4'b0100: out <= s_in1 & s_in2;

            // SLL
            4'b0101: out <= in1 << in2;

            // SRL
            4'b0110: out <= in1 >> in2;
            
            // SRA
            4'b0111: out <= s_in1 >>> in2;

            // EQ
            4'b1000: out <= (in1 == in2) ? 32'b1 : 32'b0;

            // NE
            4'b1001: out <= (in1 != in2) ? 32'b1: 32'b0;

            // LT
            4'b1010: out <= (s_in1 < s_in2) ? 32'b1 : 32'b0;

            // LTU
            4'b1011: out <= (in1 < in2) ? 32'b1 : 32'b0;

            // GE
            4'b1100: out <= (s_in1 > s_in2) ? 32'b1 : 32'b0;

            // GEU
            4'b1101: out <= (in1 > in2) ? 32'b1 : 32'b0;

            // default: false
            default: out <= 32'b0;
        endcase
    end
endmodule