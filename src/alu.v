`include "constants/alu_op.v"

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
                `ADD: alu_out = in1 + in2;

                // SLL, SLLI
                `SLL: alu_out = in1 << { 27'b0, in2[4:0] };

                // SLT, SLTI
                `SLT: alu_out = (s_in1 < s_in2) ? 32'd1 : 32'd0;

                // SLTU, SLTIU
                `SLTU: alu_out = (in1 < in2) ? 32'd1 : 32'd0;

                // XOR, XORI
                `XOR: alu_out = in1 ^ in2;

                // SRL, SRLI
                `SRL: alu_out = in1 >> { 27'b0, in2[4:0] };

                // OR, ORI, CSRRS, CSRRSI, MRET
                `OR: alu_out = in1 | in2;

                // AND, ANDI
                `AND: alu_out = in1 & in2;

                // SUB
                `SUB: alu_out = in1 - in2;

                // LUI, CSRRW, CSRRWI
                `CP_IN2: alu_out = in2;

                // JALR
                // signed to unsigned assignment occurs. (VER-318)
                `JALR: alu_out = (in1 + in2) & ~1;

                // CSRRC, CSRRCI
                `CSRRC: alu_out = in1 & ~in2;

                // SRA, SRAI
                // signed to unsigned assignment occurs. (VER-318)
                `SRA: alu_out = s_in1 >>> { 27'b0, in2[4:0] };

                // default: false
                default: alu_out = 32'b0;
            endcase
        end
    endfunction
endmodule
