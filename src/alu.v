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
            s_in1 = $signed(in1);
            s_in2 = $signed(in2);

            case (alu_op)
                // ADD, ADDI, Load, Store, Branch, JAL, AUIPC
                4'b0000: alu_out = in1 + in2;

                // SLL, SLLI
                4'b0001: alu_out = in1 << { 27'b0, in2[4:0] };

                // SLT, SLTI
                4'b0010: alu_out = (s_in1 < s_in2) ? 32'd1 : 32'd0;

                // SLTU, SLTIU
                4'b0011: alu_out = (in1 < in2) ? 32'd1 : 32'd0;

                // XOR, XORI
                4'b0100: alu_out = in1 ^ in2;

                // SRL, SRLI
                4'b0101: alu_out = in1 >> { 27'b0, in2[4:0] };

                // OR, ORI
                4'b0110: alu_out = in1 | in2;

                // AND, ANDI
                4'b0111: alu_out = in1 & in2;

                // SUB
                4'b1000: alu_out = in1 - in2;

                // LUI
                4'b1001: alu_out = in2;

                // JALR
                // signed to unsigned assignment occurs. (VER-318)
                4'b1010: alu_out = (in1 + in2) & ~1;

                // SRA, SRAI
                // signed to unsigned assignment occurs. (VER-318)
                4'b1101: alu_out = s_in1 >>> { 27'b0, in2[4:0] };

                // default: false
                default: alu_out = 32'b0;
            endcase
        end
    endfunction
endmodule
