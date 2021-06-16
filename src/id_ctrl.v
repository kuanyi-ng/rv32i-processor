`include "constants/ir_type.v"
`include "constants/funct3.v"
`include "constants/imm_type.v"
`include "imm_extractor.v"

module id_ctrl (
    input [31:0] ir,
    input [3:0] ir_type,
    input [6:0] funct7,
    input [2:0] funct3,
    input [4:0] rs1,
    input [4:0] rd,
    input flush,
    input is_mret,
    input is_ecall,
    input is_return_from_ecall,

    output [31:0] imm,
    output wr_reg_n,
    output wr_csr_n,
    output is_illegal_ir
);

    //
    // Main
    //

    wire [3:0] imm_type = imm_type_from(ir_type, funct3, is_return_from_ecall);

    imm_extractor imm_extractor_inst(
        .in(ir),
        .imm_type(imm_type),
        .out(imm)
    );
    
    assign is_illegal_ir = illegal_ir_check(ir_type, funct3, funct7, is_mret, is_ecall);
    assign wr_reg_n = wr_reg_n_ctrl(ir_type, rd, flush ,is_illegal_ir);
    assign wr_csr_n = wr_csr_n_ctrl(ir_type, funct3, rs1, flush, is_illegal_ir);

    //
    // Functions
    //

    function [3:0] imm_type_from(input [3:0] ir_type, input [2:0] funct3, input is_return_from_ecall);
        begin
            case (ir_type)
                `LUI_IR: imm_type_from = `U_IMM;
                `AUIPC_IR: imm_type_from = `U_IMM;
                `JAL_IR: imm_type_from = `J_IMM;
                `JALR_IR: imm_type_from = `I_IMM;
                `BRANCH_IR: imm_type_from = `B_IMM;
                `LOAD_IR: imm_type_from = `I_IMM;
                `STORE_IR: imm_type_from = `S_IMM;
                `REG_IMM_IR: begin
                    // SLLI
                    if (funct3 == `SLL_FUNCT3) imm_type_from = `SHAMT_IMM;
                    // SRLI, SRAI
                    else if (funct3 == `SR_FUNCT3) imm_type_from = `SHAMT_IMM;
                    // I
                    else imm_type_from = `I_IMM;
                end
                `CSR_IR: imm_type_from = `CSR_IMM;
                `SYS_CALL_IR: imm_type_from = (is_return_from_ecall) ? `RETURN_FROM_ECALL_IMM : `CSR_IMM;
                default: imm_type_from = `DEFAULT_IMM;
            endcase
        end
   endfunction

   function wr_reg_n_ctrl(
       input [3:0] ir_type,
       input [4:0] rd,
       input flush,
       input is_illegal_ir
    );
        // 0: write, 1: don't write
        begin
            // Don't allow write when
            // - this stage is flushed
            // - IR is illegal
            // - rd is x0 (x0 is always 0)
            if (flush || is_illegal_ir || (rd == 5'b00000)) begin
                wr_reg_n_ctrl = 1'b1;
            end else begin
                case (ir_type)
                    `LUI_IR,
                    `AUIPC_IR,
                    `REG_IMM_IR,
                    `REG_REG_IR,
                    `LOAD_IR,
                    `JAL_IR,
                    `JALR_IR,
                    `CSR_IR: wr_reg_n_ctrl = 1'b0;

                    default: wr_reg_n_ctrl = 1'b1;
                endcase
            end
        end
    endfunction

    function wr_csr_n_ctrl(
        input [3:0] ir_type,
        input [2:0] funct3,
        input [4:0] rs1,
        input flush,
        input is_illegal_ir
    );
        reg is_csr_ir;

        begin
            is_csr_ir = (ir_type == `CSR_IR);

            // Don't allow write when
            // - this stage is flushed
            // - IR is illegal
            if (flush || is_illegal_ir) wr_csr_n_ctrl = 1'b1;
            // CSR instructions share the same opcode with ecall, ebreak instructions
            // ecall and ebreak have funct3 of 000 while CSR instruction doesn't
            else if (is_csr_ir) begin
                // Don't update when it's CSRR (pseudo-instruction for CSRRS rd, csr, x0)
                // is_csrr_ir = (ir_type == `CSR_IR) && (funct3 == `CSRRS_FUNCT3) && (rs1 == 5'b00000)
                // CSRR doesn't update csr
                wr_csr_n_ctrl = (funct3 == `CSRRS_FUNCT3) && (rs1 == 5'b00000) ? 1'b1 : 1'b0;
            end
            else wr_csr_n_ctrl = 1'b1;
        end
    endfunction

    function illegal_ir_check(input [3:0] ir_type, input [2:0] funct3, input [6:0] funct7, input is_mret, input is_ecall);
        begin
            case (ir_type)
                `LUI_IR: illegal_ir_check = 1'b0;

                `AUIPC_IR: illegal_ir_check = 1'b0;

                `JAL_IR: illegal_ir_check = 1'b0;

                `JALR_IR: illegal_ir_check = (funct3 != `JALR_FUNCT3);

                // BRANCH does not have funct3 of { 010, 011 }
                // funct3 == 010 or 011 is not legal
                `BRANCH_IR: illegal_ir_check = (funct3 == 3'b010) || (funct3 == 3'b011);

                // LOAD does not have funct3 of { 011, 110, 111 }
                // funct3 = either of those is not legal
                `LOAD_IR: illegal_ir_check = (funct3 == 3'b011) || (funct3 == 3'b110) || (funct3 == 3'b111);

                `STORE_IR: illegal_ir_check = (funct3 != `SB_FUNCT3) && (funct3 != `SH_FUNCT3) && (funct3 != `SW_FUNCT3);

                `REG_IMM_IR: begin
                    // SLLI has funct7 of 0
                    if (funct3 == `SLL_FUNCT3) illegal_ir_check = (funct7 != 7'b0);
                    // SRLI, SRAI has funct7 of 0 or 0100000
                    else if (funct3 == `SR_FUNCT3) illegal_ir_check = (funct7 != 7'b0) && (funct7 != 7'b0100000);
                    // Else, legal
                    else illegal_ir_check = 1'b0;
                end

                `REG_REG_IR: begin
                    // ADD, SUB has funct7 of 0 or 0100000
                    // SRL, SRA has funct7 of 0 or 0100000
                    if ((funct3 == `ADD_FUNCT3) || (funct3 == `SR_FUNCT3)) illegal_ir_check = (funct7 != 7'b0) && (funct7 != 7'b0100000);
                    // Else has funct7 of 0000000
                    else illegal_ir_check = (funct7 != 7'b0);
                end

                // illegal if instruction with funct3 of 000 is not (mret or ecall)
                `SYS_CALL_IR: illegal_ir_check = !(is_mret || is_ecall);

                //  CSRs instructions does not have funct3 of { 000, 100 }
                `CSR_IR: illegal_ir_check = (funct3 == `SYS_CALL_FUNCT3) || (funct3 == 3'b100);

                // ir_type is not supported
                default: illegal_ir_check = 1'b1;
            endcase
        end
    endfunction

endmodule
