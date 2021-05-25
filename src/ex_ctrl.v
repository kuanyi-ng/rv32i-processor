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

    assign { in1, in2 } = alu_ins_ctrl(opcode, funct3[2], data1, data2, pc, imm, z_);
    assign branch_alu_op = branch_alu_op_ctrl(opcode, funct3);
    assign alu_op = alu_op_ctrl(opcode, funct3, funct7);

    //
    // Functions
    //

    localparam [6:0] lui_op = 7'b0110111;
    localparam [6:0] auipc_op = 7'b0010111;
    localparam [6:0] jal_op = 7'b1101111;
    localparam [6:0] jalr_op = 7'b1100111;
    localparam [6:0] branch_op = 7'b1100011;
    localparam [6:0] load_op = 7'b0000011;
    localparam [6:0] store_op = 7'b0100011;
    localparam [6:0] i_type_op = 7'b0010011;
    localparam [6:0] r_type_op = 7'b0110011;
    localparam [6:0] csr_op = 7'b1110011;

    // Select the input to ALU
    // return { in1, in2 }
    function [63:0] alu_ins_ctrl(
        input [6:0] opcode,
        input funct3_2, // funct3[2]
        input [31:0] data1,
        input [31:0] data2,
        input [31:0] pc,
        input [31:0] imm,
        input [31:0] z_
    );
        reg [31:0] in1, in2;

        begin
            case (opcode)
                lui_op: alu_ins_ctrl = { pc, imm };

                auipc_op: alu_ins_ctrl = { pc, imm };

                jal_op: alu_ins_ctrl = { pc, imm };
                
                jalr_op: alu_ins_ctrl = { data1, imm };

                branch_op: alu_ins_ctrl = { pc, imm };

                load_op: alu_ins_ctrl = { data1, imm };

                store_op: alu_ins_ctrl = { data1, imm };

                i_type_op: alu_ins_ctrl = { data1, imm };

                r_type_op: alu_ins_ctrl = { data1, data2 };

                csr_op: begin
                    // funct3[2]: 1 => csr with imm
                    if (funct3[2]) alu_ins_ctrl = { z_, imm };
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
        reg is_jal, is_jalr, is_branch;

        begin
            is_jal = (opcode == jal_op);
            is_jalr = (opcode == jalr_op);
            is_branch = (opcode == branch_op);

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
            is_lui = (opcode == lui_op);
            is_jalr = (opcode == jalr_op);
            is_reg_reg_ir = (opcode == r_type_op);
            is_reg_imm_ir = (opcode == i_type_op);

            if (is_lui) begin
                alu_op_ctrl = 4'b1001;
            end else if (is_jalr) begin
                alu_op_ctrl = 4'b1010;
            end else if (is_reg_reg_ir || is_reg_imm_ir) begin
                case (funct3)
                    // ADD, SUB, ADDI
                    3'b000: begin
                        if (opcode == i_type_op) alu_op_ctrl = { 1'b0, funct3 };
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
