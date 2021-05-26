`include "ir_splitter.v"
`include "imm_extractor.v"

module id_stage
#(
    parameter [6:0] LUI_OP = 7'b0110111,
    parameter [6:0] AUIPC_OP = 7'b0010111,
    parameter [6:0] JAL_OP = 7'b1101111,
    parameter [6:0] JALR_OP = 7'b1100111,
    parameter [6:0] BRANCH_OP = 7'b1100011,
    parameter [6:0] LOAD_OP = 7'b0000011,
    parameter [6:0] STORE_OP = 7'b0100011,
    parameter [6:0] I_TYPE_OP = 7'b0010011,
    parameter [6:0] R_TYPE_OP = 7'b0110011,
    parameter [6:0] CSR_OP = 7'b1110011
) (
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
    output [11:0] csr_addr,
    output [31:0] imm,
    output wr_reg_n,    // 0: write, 1: don't write
    output wr_csr_n     // 0: write, 1: don't write
);

    //
    // Local Parameters
    //

    localparam [2:0] I_TYPE = 3'b000;
    localparam [2:0] B_TYPE = 3'b001;
    localparam [2:0] S_TYPE = 3'b010;
    localparam [2:0] U_TYPE = 3'b011;
    localparam [2:0] J_TYPE = 3'b100;
    localparam [2:0] SHAMT_TYPE = 3'b101;
    localparam [2:0] CSR_TYPE = 3'b110;
    localparam [2:0] DEFAULT_TYPE = 3'b111;

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
        .funct7(funct7),
        .csr_addr(csr_addr)
    );

    wire [2:0] imm_type;
    assign imm_type = imm_type_from(opcode, funct3);

    imm_extractor #(
        .I_TYPE(I_TYPE),
        .B_TYPE(B_TYPE),
        .S_TYPE(S_TYPE),
        .U_TYPE(U_TYPE),
        .J_TYPE(J_TYPE),
        .SHAMT_TYPE(SHAMT_TYPE),
        .CSR_TYPE(CSR_TYPE),
        .DEFAULT_TYPE(DEFAULT_TYPE)
    ) imm_extractor_inst(
        .in(ir),
        .imm_type(imm_type),
        .out(imm)
    );

    assign wr_reg_n = wr_reg_n_ctrl(opcode, rd, funct3);
    assign wr_csr_n = wr_csr_n_ctrl(opcode, funct3);

    //
    // Functions
    //

    function [2:0] imm_type_from(input [6:0] opcode, input [2:0] funct3);
        begin
            case (opcode)
                // U-Type
                // LUI
                LUI_OP: imm_type_from = U_TYPE;

                // AUIPC
                AUIPC_OP: imm_type_from = U_TYPE;

                // JAL
                JAL_OP: imm_type_from = J_TYPE;

                // JALR
                JALR_OP: imm_type_from = I_TYPE;

                // Branch
                BRANCH_OP: imm_type_from = B_TYPE;

                // Load
                LOAD_OP: imm_type_from = I_TYPE;

                // Store
                STORE_OP: imm_type_from = S_TYPE;

                // I-Type (including shamt)
                I_TYPE_OP: begin
                    if (funct3 == 3'b001)
                        // SLLI
                        imm_type_from = SHAMT_TYPE;
                    else if (funct3 == 3'b101)
                        // SRLI, SRAI
                        imm_type_from = SHAMT_TYPE;
                    else
                        imm_type_from = I_TYPE;
                end

                CSR_OP: imm_type_from = CSR_TYPE;

                // default: anything not from above
                default: imm_type_from = DEFAULT_TYPE;
            endcase
        end
   endfunction

   function wr_reg_n_ctrl(input [6:0] opcode, input [4:0] rd, input [2:0] funct3);
        // 0: write, 1: don't write

        // whitelist instead of blacklist to be more secure.
        reg is_lui, is_auipc, is_i_type, is_r_type, is_load, is_jal, is_jalr, is_csr;

        begin
            // might to add csr
            is_lui = (opcode == LUI_OP);
            is_auipc = (opcode == AUIPC_OP);
            is_i_type = (opcode == I_TYPE_OP);
            is_r_type = (opcode == R_TYPE_OP);
            is_load = (opcode == LOAD_OP);
            is_jal = (opcode == JAL_OP);
            is_jalr = (opcode == JALR_OP);
            is_csr = (opcode == CSR_OP) && (funct3 != 3'b000);

            if (rd == 5'b00000) begin
                // don't allow write to x0 (always 0)
                wr_reg_n_ctrl = 1'b1;
            end else if (is_lui || is_auipc || is_i_type || is_r_type || is_load || is_jal || is_jalr || is_csr) begin
                wr_reg_n_ctrl = 1'b0;
            end else begin
                wr_reg_n_ctrl = 1'b1;
            end
        end
    endfunction

    function wr_csr_n_ctrl(input [6:0] opcode, input [2:0] funct3);
        begin
            // CSR instructions share the same opcode with ecall, ebreak instructions
            // ecall and ebreak have funct3 of 000 while CSR instruction doesn't
            if ((opcode == CSR_OP) && (funct3 != 3'b000)) wr_csr_n_ctrl = 1'b0;
            else wr_csr_n_ctrl = 1'b1;
        end
    endfunction
endmodule
