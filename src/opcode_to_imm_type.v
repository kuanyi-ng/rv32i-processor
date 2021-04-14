module opcode_to_imm_type (
    input [6:0] opcode,
    output [2:0] imm_type
);
   assign imm_type = convert(opcode);

   function [2:0] convert(input [6:0] opcode);
        parameter [2:0] i_type = 3'b000;
        parameter [2:0] b_type = 3'b001;
        parameter [2:0] s_type = 3'b010;
        parameter [2:0] u_type = 3'b011;
        parameter [2:0] j_type = 3'b100;
        parameter [2:0] default_type = 3'b111;

        begin
            case (opcode)
                // I-Type (include JALR)
                7'b0000011: convert = i_type;
                // JALR
                7'b1100111: convert = i_type;

                // B-Type
                7'b1100011: convert = b_type;

                // S-Type
                7'b0100011: convert = s_type;

                // U-Type
                // LUI
                7'b0110111: convert = u_type;
                // AUPIC
                7'b0010111: convert = u_type;

                // J-Type (doesn't include JALR)
                7'b1101111: convert = j_type;

                // I-Type (including shamt)
                7'b0010011: convert = i_type;

                // default: anything not from above
                default: convert = default_type;
            endcase
        end 
   endfunction
endmodule