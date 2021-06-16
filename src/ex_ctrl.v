`include "constants/alu_op.v"
`include "constants/branch_alu_op.v"
`include "constants/ir_type.v"
`include "constants/funct3.v"

module ex_ctrl (
    input [3:0] ir_type,
    input [2:0] funct3,
    input [6:0] funct7,

    output [2:0] branch_alu_op,
    output [3:0] alu_op
);
    //
    // Main
    //

    assign branch_alu_op = branch_alu_op_ctrl(ir_type, funct3);
    assign alu_op = alu_op_ctrl(ir_type, funct3, funct7);

    //
    // Functions
    //

        function [2:0] branch_alu_op_ctrl(input [3:0] ir_type, input [2:0] funct3);
        begin
            case (ir_type)
                `JAL_IR: branch_alu_op_ctrl = `JUMP;
                `JALR_IR: branch_alu_op_ctrl = `JUMP;
                `SYS_CALL_IR: branch_alu_op_ctrl = `JUMP;
                `BRANCH_IR: branch_alu_op_ctrl = funct3;
                default: branch_alu_op_ctrl = `NO_JUMP;
            endcase
        end
    endfunction

    function [3:0] alu_op_ctrl(input [3:0] ir_type, input [2:0] funct3, input [6:0] funct7);
        begin
            case (ir_type)
                `LUI_IR: alu_op_ctrl = `CP_IN2;

                `AUIPC_IR: alu_op_ctrl = `ADD;

                `JAL_IR: alu_op_ctrl = `ADD;

                `JALR_IR: alu_op_ctrl = `JALR;

                `BRANCH_IR: alu_op_ctrl = `ADD;

                `LOAD_IR: alu_op_ctrl = `ADD;

                `STORE_IR: alu_op_ctrl = `ADD;

                `REG_REG_IR: alu_op_ctrl = reg_ir_alu_op_ctrl(1'b0, funct3, funct7);

                `REG_IMM_IR: alu_op_ctrl = reg_ir_alu_op_ctrl(1'b1, funct3, funct7);

                `CSR_IR: begin
                    case (funct3[1:0])
                        2'b01: alu_op_ctrl = `CP_IN2;
                        2'b10: alu_op_ctrl = `OR;
                        2'b11: alu_op_ctrl = `CSRRC;
                        default: alu_op_ctrl = `X_ALU_OP;
                    endcase
                end

                // mret
                `SYS_CALL_IR: alu_op_ctrl = `ADD;

                default: alu_op_ctrl = `ADD;
            endcase
        end 
    endfunction

    function [3:0] reg_ir_alu_op_ctrl(input is_reg_imm_ir, input [2:0] funct3, input [6:0] funct7);
        begin
            case (funct3)
                // ADD, SUB, ADDI
                `ADD_FUNCT3: reg_ir_alu_op_ctrl = (is_reg_imm_ir) ? { 1'b0, funct3 } : { funct7[5], funct3 };

                // SLL, SLLI
                `SLL_FUNCT3: reg_ir_alu_op_ctrl = { 1'b0, funct3 };

                // SLT, SLTI
                `SLT_FUNCT3: reg_ir_alu_op_ctrl = { 1'b0, funct3 };

                // SLTU, SLTIU
                `SLTU_FUNCT3: reg_ir_alu_op_ctrl = { 1'b0, funct3 };

                // XOR, XORI
                `XOR_FUNCT3: reg_ir_alu_op_ctrl = { 1'b0, funct3 };

                // SRL, SRA, SRAI, SRLI
                `SR_FUNCT3: reg_ir_alu_op_ctrl = { funct7[5], funct3 };

                // OR, ORI
                `OR_FUNCT3: reg_ir_alu_op_ctrl = { 1'b0, funct3 };

                // AND, ANDI
                `AND_FUNCT3: reg_ir_alu_op_ctrl = { 1'b0, funct3 };
            endcase
        end
    endfunction

endmodule
