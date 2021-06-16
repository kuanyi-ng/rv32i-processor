`include "constants/ir_type.v"
`include "id_data_picker.v"

// Prepare the data required by EX stage
module post_id_stage (
    // Inputs from ID stage
    input [3:0] ir_type,
    input [2:0] funct3,
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] z_,

    // Inputs from Regfile
    input [31:0] data1_regfile,
    input [31:0] data2_regfile,

    // Inputs from EX and MEM stage
    input [31:0] data_forwarded_from_ex,
    input [31:0] data_forwarded_from_mem,

    // Inputs from Data Forwarding Unit
    // 00: no forward, 01: forward ex, 10: forward mem
    input [1:0] forward_data1,
    input [1:0] forward_data2,

    output [31:0] in1,
    output [31:0] in2,
    output [31:0] data1,
    output [31:0] data2
);

    id_data_picker id_data_picker_inst(
        .data1_from_regfile(data1_regfile),
        .data2_from_regfile(data2_regfile),
        .data_forwarded_from_ex(data_forwarded_from_ex),
        .data_forwarded_from_mem(data_forwarded_from_mem),
        .forward_data1(forward_data1),
        .forward_data2(forward_data2),
        .data1_id(data1),
        .data2_id(data2)
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