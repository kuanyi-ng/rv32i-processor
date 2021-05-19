module ex_ctrl (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output a_sel,   // 0: data1, 1: pc
    output b_sel,   // 0: data2, 1: imm
    output [2:0] branch_alu_op,
    output [3:0] alu_op
);
    //
    // main
    //
    assign a_sel = a_sel_ctrl(opcode);
    assign b_sel = b_sel_ctrl(opcode);
    assign branch_alu_op = branch_alu_op_ctrl(opcode, funct3);
    assign alu_op = alu_op_ctrl(opcode, funct3, funct7);

    //
    // functions
    //
    function a_sel_ctrl(input [6:0] opcode);
        // since most instructions use data1,
        // we will only check if the instructions need pc
        reg is_auipc, is_jal, is_branch;

        begin
            // AUIPC, JAL, Branch
            is_auipc = (opcode == 7'b0010111);
            is_jal = (opcode == 7'b1101111);
            is_branch = (opcode == 7'b1100011);

            a_sel_ctrl = is_auipc || is_jal || is_branch;
        end
    endfunction

    function b_sel_ctrl(input [6:0] opcode);
        // only R-Type instructions use data2
        reg is_reg_reg_ir;

        begin
            is_reg_reg_ir = (opcode == 7'b0110011);

            b_sel_ctrl = !is_reg_reg_ir;
        end
    endfunction

    function [2:0] branch_alu_op_ctrl(input [6:0] opcode, input [2:0] funct3);
        // first check if instruction is one of the following:
        // JAL. JALR, Branch
        reg is_jal, is_jalr, is_branch;

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

    function [3:0] alu_op_ctrl(input [6:0] opcode, input [2:0] funct3, input [6:0] funct7);
        reg is_lui, is_jalr, is_reg_reg_ir, is_reg_imm_ir;

        begin
            is_lui = (opcode == 7'b0110111);
            is_jalr = (opcode == 7'b1100111);
            is_reg_reg_ir = (opcode == 7'b0110011);
            is_reg_imm_ir = (opcode == 7'b0010011);

            if (is_lui) begin
                alu_op_ctrl = 4'b1001;
            end else if (is_jalr) begin
                alu_op_ctrl = 4'b1010;
            end else if (is_reg_reg_ir || is_reg_imm_ir) begin
                case (funct3)
                    // ADD, SUB, ADDI
                    3'b000: begin
                        if (opcode == 7'b0010011) alu_op_ctrl = { 1'b0, funct3 };
                        else alu_op_ctrl = { funct7[5], funct3 };
                    end
                    
                    // SLL, SLLI
                    3'b001: alu_op_ctrl = { 1'b0, funct3 };

                    // SLT, SLTI
                    3'b010: alu_op_ctrl = { 1'b0, funct3 };
                    
                    // SLTU, SLTIU
                    3'b011: alu_op_ctrl = { 1'b0, funct3 };

                    // XOR, XORI
                    3'b100: alu_op_ctrl = { 1'b0, funct3 };

                    // SRL, SRA, SRAI, SRLI
                    3'b101: alu_op_ctrl = { funct7[5], funct3 };

                    // OR, ORI
                    3'b110: alu_op_ctrl = { 1'b0, funct3 };

                    // AND, ANDI
                    3'b111: alu_op_ctrl = { 1'b0, funct3 };

                    // no default case as every case is covered
                endcase
            end else begin
                // AUIPC, JAL, Branch, Load, Store
                alu_op_ctrl = 4'b0000;
            end
        end 
    endfunction
endmodule
