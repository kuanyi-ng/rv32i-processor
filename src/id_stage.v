`include "ir_splitter.v"
`include "imm_extractor.v"

module id_stage (
    // inputs from IF stage
    input [31:0] ir,

    // outputs to Register File
    output [4:0] rs1,
    output [4:0] rs2,

    // outputs to EX stage
    output [4:0] rd,
    output [6:0] opcode,
    output [2:0] funct3,
    output [6:0] funct7,
    output [31:0] imm,
    output wr_reg_n         // 0: write, 1: don't write
);

    //
    // Main
    //
    ir_splitter ir_splitter_inst(
        .ir(ir),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7)
    );

    wire [2:0] imm_type;
    assign imm_type = imm_type_from(opcode, funct3);

    imm_extractor imm_extractor_inst(
        .in(ir),
        .imm_type(imm_type),
        .out(imm)
    );

    assign wr_reg_n = wr_reg_n_ctrl(opcode);

    //
    // Functions
    //
    function [2:0] imm_type_from(input [6:0] opcode, input [2:0] funct3);
        parameter [2:0] i_type = 3'b000;
        parameter [2:0] b_type = 3'b001;
        parameter [2:0] s_type = 3'b010;
        parameter [2:0] u_type = 3'b011;
        parameter [2:0] j_type = 3'b100;
        parameter [2:0] shamt_type = 3'b101;
        parameter [2:0] default_type = 3'b111;

        begin
            case (opcode)
                // U-Type
                // LUI
                7'b0110111: imm_type_from = u_type;
                // AUPIC
                7'b0010111: imm_type_from = u_type;

                // JAL
                7'b1101111: imm_type_from = j_type;

                // JALR
                7'b1100111: imm_type_from = i_type;

                // Branch
                7'b1100011: imm_type_from = b_type;

                // Load
                7'b0000011: imm_type_from = i_type;

                // Store
                7'b0100011: imm_type_from = s_type;

                // I-Type (including shamt)
                7'b0010011: begin
                    if (funct3 == 3'b001)
                        // SLLI
                        imm_type_from = shamt_type;
                    else if (funct3 == 3'b101)
                        // SRLI, SRAI
                        imm_type_from = shamt_type;
                    else
                        imm_type_from = i_type;
                end

                // default: anything not from above
                default: imm_type_from = default_type;
            endcase
        end
   endfunction

   function wr_reg_n_ctrl(input [6:0] opcode);
        // 0: write, 1: don't write

        // whitelist instead of blacklist to be more secure.
        reg is_lui, is_aupic, is_i_type, is_r_type, is_load, is_jal, is_jalr;

        begin
            is_lui = (opcode == 7'b0110111);
            is_aupic = (opcode == 7'b0010111);
            is_i_type = (opcode == 7'b0010011);
            is_r_type = (opcode == 7'b0110011);
            is_load = (opcode == 7'b0000011);
            is_jal = (opcode == 7'b1101111);
            is_jalr = (opcode == 7'b1100111);

            if (is_lui || is_aupic || is_i_type || is_r_type || is_load || is_jal || is_jalr) begin
                wr_reg_n_ctrl = 1'b0;
            end else begin
                wr_reg_n_ctrl = 1'b1;
            end
        end
    endfunction
endmodule
