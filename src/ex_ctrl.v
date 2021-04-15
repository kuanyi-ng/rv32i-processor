module ex_ctrl (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output a_sel,   // 0: data1, 1: pc
    output b_sel,   // 0: data2, 1: imm
    output [2:0] branch_alu_op
);
    //
    // main
    //
    assign a_sel = a_sel_ctrl(opcode);
    assign b_sel = b_sel_ctrl(opcode);
    assign branch_alu_op = branch_alu_op_ctrl(opcode, funct3);

    //
    // functions
    //
    function a_sel_ctrl(input [6:0] opcode);
        // since most instructions use data1,
        // we will only check if the instructions need pc
        reg is_aupic;
        reg is_jal;
        reg is_branch;

        begin
            // AUPIC, JAL, Branch
            is_aupic = (opcode == 7'b0010111);
            is_jal = (opcode == 7'b1101111);
            is_branch = (opcode == 7'b1100011);

            a_sel_ctrl = is_aupic || is_jal || is_branch;
        end
    endfunction

    function b_sel_ctrl(input [6:0] opcode);
        // only R-Type instructions use data2
        reg is_r_type_ir;

        begin
            is_r_type_ir = (opcode == 7'b0110011);

            b_sel_ctrl = !is_r_type_ir;
        end
    endfunction

    function [2:0] branch_alu_op_ctrl(input [6:0] opcode, input [2:0] funct3);
        // first check if instruction is one of the following:
        // JAL. JALR, Branch
        reg is_jal;
        reg is_jalr;
        reg is_branch;

        begin
            is_jal = (opcode == 7'b1101111);
            is_jalr = (opcode == 7'b1100111);
            is_branch = (opcode == 7'b1100011);

            if (is_jal || is_jalr) begin
                branch_alu_op_ctrl = 3'b010;
            end else if (is_branch) begin
                branch_alu_op_ctrl = funct3;
            end else begin
                branch_alu_op_ctrl = 3'b011;
            end
        end
    endfunction
endmodule
