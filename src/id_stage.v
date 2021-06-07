`include "constants/opcode.v"

`include "ir_splitter.v"
`include "imm_extractor.v"

module id_stage (
    // inputs from IF stage
    input [31:0] ir,

    // inputs from CSRs
    input is_e_cause_eq_ecall,

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
    // 0: write, 1: don't write
    output wr_reg_n,
    output wr_csr_n,
    // 0: not mret, 1: mret
    output is_mret,
    // 0: not ecall, 1: ecall
    output is_ecall,
    // 0: legal, 1: illegal
    output is_illegal_ir
);

    //
    // Local Parameters
    //

    localparam [11:0] MEPC_ADDR = 12'h341;
    localparam [31:0] MRET_IR = 32'b0011000_00010_00000_000_00000_1110011;
    localparam [31:0] ECALL_IR = 32'b000000000000_00000_000_00000_1110011;

    //
    // Main
    //

    wire [11:0] temp_csr_addr;
    ir_splitter ir_splitter_inst(
        .ir(ir),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7),
        .csr_addr(temp_csr_addr)
    );
    // change csr_addr to mepc when is_mret is true
    // this will enable csr_forwarding value of mepc
    assign csr_addr = (is_mret) ? MEPC_ADDR : temp_csr_addr;

    wire [2:0] imm_type;
    assign imm_type = imm_type_from(opcode, funct3);

    wire [31:0] temp_imm;
    imm_extractor imm_extractor_inst(
        .in(ir),
        .imm_type(imm_type),
        .out(temp_imm)
    );
    // Calculation of Jump (return) address for MRET
    // if it's returning from ecall: jump to mepc + 4
    // else (other type of exception) jump to mepc
    //
    // When is_mret is true, temp_imm will be 32'h0
    assign imm = (is_mret && is_e_cause_eq_ecall) ? 32'h4 : temp_imm;

    assign wr_reg_n = wr_reg_n_ctrl(opcode, rd, funct3, is_illegal_ir);
    assign wr_csr_n = wr_csr_n_ctrl(opcode, funct3, rs1, is_illegal_ir);

    assign is_mret = (ir == MRET_IR);
    assign is_ecall = (ir == ECALL_IR);

    assign is_illegal_ir = illegal_ir_check(opcode, funct3, funct7, is_mret, is_ecall);

    //
    // Functions
    //

    function [2:0] imm_type_from(input [6:0] opcode, input [2:0] funct3);
        begin
            case (opcode)
                // U-Type
                // LUI
                `LUI_OP: imm_type_from = `U_IMM;

                // AUIPC
                `AUIPC_OP: imm_type_from = `U_IMM;

                // JAL
                `JAL_OP: imm_type_from = `J_IMM;

                // JALR
                `JALR_OP: imm_type_from = `I_IMM;

                // Branch
                `BRANCH_OP: imm_type_from = `B_IMM;

                // Load
                `LOAD_OP: imm_type_from = `I_IMM;

                // Store
                `STORE_OP: imm_type_from = `S_IMM;

                // I-Type (including shamt)
                `I_TYPE_OP: begin
                    if (funct3 == 3'b001)
                        // SLLI
                        imm_type_from = `SHAMT_IMM;
                    else if (funct3 == 3'b101)
                        // SRLI, SRAI
                        imm_type_from = `SHAMT_IMM;
                    else
                        imm_type_from = `I_IMM;
                end

                `SYSTEM_OP: imm_type_from = `CSR_IMM;

                // default: anything not from above
                default: imm_type_from = `DEFAULT_IMM;
            endcase
        end
   endfunction

   function wr_reg_n_ctrl(input [6:0] opcode, input [4:0] rd, input [2:0] funct3, input is_illegal_ir);
        // 0: write, 1: don't write

        // whitelist instead of blacklist to be more secure.
        reg is_lui, is_auipc, is_i_type, is_r_type, is_load, is_jal, is_jalr, is_csr;

        begin
            // might to add csr
            is_lui = (opcode == `LUI_OP);
            is_auipc = (opcode == `AUIPC_OP);
            is_i_type = (opcode == `I_TYPE_OP);
            is_r_type = (opcode == `R_TYPE_OP);
            is_load = (opcode == `LOAD_OP);
            is_jal = (opcode == `JAL_OP);
            is_jalr = (opcode == `JALR_OP);
            is_csr = (opcode == `SYSTEM_OP) && (funct3 != 3'b000);

            // Don't update when IR is illegal
            if (is_illegal_ir) wr_reg_n_ctrl = 1'b1;
            else if (rd == 5'b00000) begin
                // don't allow write to x0 (always 0)
                wr_reg_n_ctrl = 1'b1;
            end else if (is_lui || is_auipc || is_i_type || is_r_type || is_load || is_jal || is_jalr || is_csr) begin
                wr_reg_n_ctrl = 1'b0;
            end else begin
                wr_reg_n_ctrl = 1'b1;
            end
        end
    endfunction

    function wr_csr_n_ctrl(input [6:0] opcode, input [2:0] funct3, input [4:0] rs1, input is_illegal_ir);
        reg is_csr_ir, is_csrr_ir;

        begin
            is_csr_ir = (opcode == `SYSTEM_OP) && (funct3 != 3'b000);
            is_csrr_ir = (opcode == `SYSTEM_OP) && (funct3 == 3'b010) && (rs1 == 5'b00000);

            // Don't update when IR is illegal
            if (is_illegal_ir) wr_csr_n_ctrl = 1'b1;
            // Don't update when it's CSRR (pseudo-instruction for CSRRS rd, csr, x0)
            else if (is_csrr_ir) wr_csr_n_ctrl = 1'b1;
            // CSR instructions share the same opcode with ecall, ebreak instructions
            // ecall and ebreak have funct3 of 000 while CSR instruction doesn't
            else if (is_csr_ir) wr_csr_n_ctrl = 1'b0;
            else wr_csr_n_ctrl = 1'b1;
        end
    endfunction

    function illegal_ir_check(input [6:0] opcode, input [2:0] funct3, input [6:0] funct7, input is_mret, input is_ecall);
        begin
            case (opcode)
                `LUI_OP: illegal_ir_check = 1'b0;

                `AUIPC_OP: illegal_ir_check = 1'b0;

                `JAL_OP: illegal_ir_check = 1'b0;

                // JALR has funct3 of 3'b000
                // (funct3 == 3'b000) is legal
                `JALR_OP: illegal_ir_check = (funct3 != 3'b000);

                // BRANCH does not have funct3 of { 010, 011 }
                // funct3 == 010 or 011 is not legal
                `BRANCH_OP: illegal_ir_check = (funct3 == 3'b010) || (funct3 == 3'b011);

                // LOAD does not have funct3 of { 011, 110, 111 }
                // funct3 = either of those is not legal
                `LOAD_OP: illegal_ir_check = (funct3 == 3'b011) || (funct3 == 3'b110) || (funct3 == 3'b111);

                // STORE only has funct3 of { 000, 001, 010 }
                // funct3 = either of those is legal
                // (funct3 == 3'b000) || (funct3 == 3'b001) || (funct3 == 3'b010) is legal
                `STORE_OP: illegal_ir_check = (funct3 != 3'b000) && (funct3 != 3'b001) && (funct3 != 3'b010);

                `I_TYPE_OP: begin
                    // SLLI has funct7 of 0
                    if (funct3 == 3'b001) illegal_ir_check = (funct7 != 7'b0);
                    // SRLI, SRAI has funct7 of 0 or 0100000
                    else if (funct3 == 3'b101) illegal_ir_check = (funct7 != 7'b0) && (funct7 != 7'b0100000);
                    // Else, legal
                    else illegal_ir_check = 1'b0;
                end

                `R_TYPE_OP: begin
                    // ADD, SUB has funct7 of 0 or 0100000
                    // SRL, SRA has funct7 of 0 or 0100000
                    if ((funct3 == 3'b000) || (funct3 == 3'b101)) illegal_ir_check = (funct7 != 7'b0) && (funct7 != 7'b0100000);
                    // Else has funct7 of 0000000
                    else illegal_ir_check = (funct7 != 7'b0);
                end

                `SYSTEM_OP: begin
                    // MRET
                    // illegal if instruction with funct3 of 000 is not (mret or ecall)
                    if (funct3 == 3'b000) illegal_ir_check = !(is_mret || is_ecall);
                    // CSRs instructions does not have funct3 of { 000, 100 }
                    else illegal_ir_check = (funct3 == 3'b100);
                end

                // opcode is not supported
                default: illegal_ir_check = 1'b1;
            endcase
        end
    endfunction
endmodule
