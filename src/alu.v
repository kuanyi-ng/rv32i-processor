module alu (
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] alu_op,
    output [31:0] out
);

    assign out = alu_out(in1, in2, alu_op);

    function [31:0] alu_out(input [31:0] in1, input [31:0] in2, input [3:0] alu_op);
        reg signed [31:0] s_in1;
        reg signed [31:0] s_in2;

        begin
            s_in1 = in1;
            s_in2 = in2;

            case (alu_op)
                // ADD, ADDI, Load, Store, Branch, JAL, AUPIC
                4'b0000: alu_out = s_in1 + s_in2;

                // SUB
                4'b0001: alu_out = s_in1 - s_in2;

                // XOR, XORI
                4'b0010: alu_out = in1 ^ in2;

                // OR, ORI
                4'b0011: alu_out = in1 | in2;

                // AND, ANDI
                4'b0100: alu_out = in1 & in2;

                // SLL, SLLI
                4'b0101: alu_out = s_in1 << in2;

                // SRL, SRLI
                4'b0110: alu_out = s_in1 >> in2;
                
                // SRA, SRAI
                4'b0111: alu_out = s_in1 >>> in2;

                // SLT, SLTI
                4'b1000: alu_out = (s_in1 < s_in2) ? 32'd1 : 32'd0;

                // SLTU, SLTIU
                4'b1001: alu_out = (in1 < in2) ? 32'd1 : 32'd0;

                // JALR
                4'b1010: alu_out = (in1 + in2) & ~1;

                // LUI
                4'b1011: alu_out = in2;

                // default: false
                default: alu_out = 32'b0;
            endcase 
        end        
    endfunction    

    // // prepare signed inputs
    // wire signed [31:0] s_in1 = in1;
    // wire signed [31:0] s_in2 = in2;

    // // whenever either one of in1, in2, alu_op changes,
    // // this block will be run and compute a new value for out.
    // always @(in1 or in2 or alu_op) begin
    //     case (alu_op)
    //         // ADD
    //         4'b0000: out <= s_in1 + s_in2;

    //         // SUB
    //         4'b0001: out <= s_in1 - s_in2;

    //         // XOR
    //         4'b0010: out <= s_in1 ^ s_in2;

    //         // OR
    //         4'b0011: out <= s_in1 | s_in2;

    //         // AND
    //         4'b0100: out <= s_in1 & s_in2;

    //         // SLL
    //         4'b0101: out <= in1 << in2;

    //         // SRL
    //         4'b0110: out <= in1 >> in2;
            
    //         // SRA
    //         4'b0111: out <= s_in1 >>> in2;

    //         // EQ
    //         4'b1000: out <= (in1 == in2) ? 32'b1 : 32'b0;

    //         // NE
    //         4'b1001: out <= (in1 != in2) ? 32'b1: 32'b0;

    //         // LT
    //         4'b1010: out <= (s_in1 < s_in2) ? 32'b1 : 32'b0;

    //         // LTU
    //         4'b1011: out <= (in1 < in2) ? 32'b1 : 32'b0;

    //         // GE
    //         4'b1100: out <= (s_in1 > s_in2) ? 32'b1 : 32'b0;

    //         // GEU
    //         4'b1101: out <= (in1 > in2) ? 32'b1 : 32'b0;

    //         // JALR
    //         4'b1110: out <= (in1 + in2) & ~1;

    //         // default: false
    //         default: out <= 32'b0;
    //     endcase
    // end
endmodule