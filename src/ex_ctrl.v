`include "constants/alu_op.v"
`include "constants/branch_alu_op.v"
`include "constants/opcode.v"
`include "constants/funct3.v"

module ex_ctrl (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] z_,

    output [31:0] in1,
    output [31:0] in2,
    output [2:0] branch_alu_op,
    output [3:0] alu_op
);
    //
    // Main
    //

    assign { in1, in2 } = alu_ins_ctrl(opcode, funct3, data1, data2, pc, imm, z_);
    assign branch_alu_op = branch_alu_op_ctrl(opcode, funct3);
    assign alu_op = alu_op_ctrl(opcode, funct3, funct7);

    //
    // Functions
    //

    // Select the input to ALU
    // return { in1, in2 }
    function [63:0] alu_ins_ctrl(
        input [6:0] opcode,
        input [2:0] funct3,
        input [31:0] data1,
        input [31:0] data2,
        input [31:0] pc,
        input [31:0] imm,
        input [31:0] z_
    );

        begin
            case (opcode)
                `LUI_OP: alu_ins_ctrl = { pc, imm };

                `AUIPC_OP: alu_ins_ctrl = { pc, imm };

                `JAL_OP: alu_ins_ctrl = { pc, imm };
                
                `JALR_OP: alu_ins_ctrl = { data1, imm };

                `BRANCH_OP: alu_ins_ctrl = { pc, imm };

                `LOAD_OP: alu_ins_ctrl = { data1, imm };

                `STORE_OP: alu_ins_ctrl = { data1, imm };

                `I_TYPE_OP: alu_ins_ctrl = { data1, imm };

                `R_TYPE_OP: alu_ins_ctrl = { data1, data2 };

                `SYSTEM_OP: begin
                    // mret, ecall
                    if (funct3 == 3'b000) alu_ins_ctrl = { z_, imm };
                    // funct3[2]: 1 => csr with imm
                    else if (funct3[2] == 1'b1) alu_ins_ctrl = { z_, imm };
                    // funct3[2]: 0 => csr with register
                    else alu_ins_ctrl = { z_, data1 };
                end

                default: alu_ins_ctrl = 64'bx;
            endcase
        end
    endfunction

    function [2:0] branch_alu_op_ctrl(input [6:0] opcode, input [2:0] funct3);
        // first check if instruction is one of the following:
        // JAL. JALR, Branch
        reg is_jal, is_jalr, is_branch, is_system_call;

        begin
            is_jal = (opcode == `JAL_OP);
            is_jalr = (opcode == `JALR_OP);
            is_branch = (opcode == `BRANCH_OP);
            is_system_call = (opcode == `SYSTEM_OP) && (funct3 == 3'b000); // mret, ecall, ebreak

            if (is_jal || is_jalr || is_system_call) begin
                branch_alu_op_ctrl = `JUMP;
            end else if (is_branch) begin
                branch_alu_op_ctrl = funct3;
            end else begin
                branch_alu_op_ctrl = `NO_JUMP;
            end
        end
    endfunction

    function [3:0] alu_op_ctrl(input [6:0] opcode, input [2:0] funct3, input [6:0] funct7);
        reg is_lui, is_jalr, is_reg_reg_ir, is_reg_imm_ir, is_csr_ir, is_system_call;

        begin
            is_lui = (opcode == `LUI_OP);
            is_jalr = (opcode == `JALR_OP);
            is_reg_reg_ir = (opcode == `R_TYPE_OP);
            is_reg_imm_ir = (opcode == `I_TYPE_OP);
            is_csr_ir = (opcode == `SYSTEM_OP) && (funct3 != `SYS_CALL_FUNCT3);
            is_system_call = (opcode == `SYSTEM_OP) && (funct3 == `SYS_CALL_FUNCT3);

            if (is_lui) begin
                alu_op_ctrl = `CP_IN2;
            end else if (is_jalr) begin
                alu_op_ctrl = `JALR;
            end else if (is_reg_reg_ir || is_reg_imm_ir) begin
                case (funct3)
                    // ADD, SUB, ADDI
                    `ADD_FUNCT3: begin
                        if (opcode == `I_TYPE_OP) alu_op_ctrl = { 1'b0, funct3 };
                        else alu_op_ctrl = { funct7[5], funct3 };
                    end
                    
                    // SLL, SLLI
                    `SLL_FUNCT3: alu_op_ctrl = { 1'b0, funct3 };

                    // SLT, SLTI
                    `SLT_FUNCT3: alu_op_ctrl = { 1'b0, funct3 };
                    
                    // SLTU, SLTIU
                    `SLTU_FUNCT3: alu_op_ctrl = { 1'b0, funct3 };

                    // XOR, XORI
                    `XOR_FUNCT3: alu_op_ctrl = { 1'b0, funct3 };

                    // SRL, SRA, SRAI, SRLI
                    `SR_FUNCT3: alu_op_ctrl = { funct7[5], funct3 };

                    // OR, ORI
                    `OR_FUNCT3: alu_op_ctrl = { 1'b0, funct3 };

                    // AND, ANDI
                    `AND_FUNCT3: alu_op_ctrl = { 1'b0, funct3 };

                    // no default case as every case is covered
                endcase
            end else if (is_csr_ir) begin
                if (funct3[1:0] == 2'b01) alu_op_ctrl = `CP_IN2;
                else if (funct3[1:0] == 2'b10) alu_op_ctrl = `OR;
                else if (funct3[1:0] == 2'b11) alu_op_ctrl = `CSRRC;
                else alu_op_ctrl = 4'bx;
            end else if (is_system_call) begin
                // MRET
                alu_op_ctrl = `ADD;
            end else begin
                // AUIPC, JAL, Branch, Load, Store
                alu_op_ctrl = `ADD;
            end
        end 
    endfunction
endmodule
