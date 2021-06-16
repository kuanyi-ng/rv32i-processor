`include "constants/ir_type.v"

// Prepare the data required by EX stage
module post_id_stage (
    input [3:0] ir_type,
    input [2:0] funct3,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] z_,

    output [31:0] in1,
    output [31:0] in2
);

    assign { in1, in2 } = alu_ins_ctrl(ir_type, funct3, data1, data2, pc, imm, z_);
    
    //
    // Function
    //

    // Select the input to ALU
    // return { in1, in2 }
    function [63:0] alu_ins_ctrl(
        input [3:0] ir_type,
        input [2:0] funct3,
        input [31:0] data1,
        input [31:0] data2,
        input [31:0] pc,
        input [31:0] imm,
        input [31:0] z_
    );

        begin
            case (ir_type)
                `LUI_IR: alu_ins_ctrl = { pc, imm };

                `AUIPC_IR: alu_ins_ctrl = { pc, imm };

                `JAL_IR: alu_ins_ctrl = { pc, imm };
                
                `JALR_IR: alu_ins_ctrl = { data1, imm };

                `BRANCH_IR: alu_ins_ctrl = { pc, imm };

                `LOAD_IR: alu_ins_ctrl = { data1, imm };

                `STORE_IR: alu_ins_ctrl = { data1, imm };

                `REG_IMM_IR: alu_ins_ctrl = { data1, imm };

                `REG_REG_IR: alu_ins_ctrl = { data1, data2 };

                // mret, ecall
                `SYS_CALL_IR: alu_ins_ctrl = { z_, imm };

                `CSR_IR: begin
                    // if (funct3[2] == 1'b1) => csr with imm
                    // else csr with register
                    alu_ins_ctrl = (funct3[2] == 1'b1) ? { z_, imm } : { z_, data1 };
                end

                default: alu_ins_ctrl = { data1, data2 };
            endcase
        end
    endfunction
    
endmodule