module test_ex_ctrl ();
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire a_sel, b_sel;
    wire [2:0] branch_alu_op;
    wire [3:0] alu_op;

    ex_ctrl subject(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .branch_alu_op(branch_alu_op),
        .alu_op(alu_op)
    );

    initial begin
        // LUI
        assign opcode = 7'b0110111;
        // expect:
        // a_sel: 0
        // b_sel: 1
        // alu_op: 1001
        // branch_alu_op: 011
        #10

        // AUPIC
        assign opcode = 7'b0010111;
        // expect:
        // a_sel: 1
        // b_sel: 1
        // alu_op: 0000
        // branch_alu_op: 011
        #10

        // JAL
        assign opcode = 7'b1101111;
        // expect:
        // a_sel: 1
        // b_sel: 1
        // alu_op: 0000
        // branch_alu_op: 010
        #10

        // JALR
        assign opcode = 7'b1100111;
        // expect:
        // a_sel: 0
        // b_sel: 1
        // alu_op: 1010
        // branch_alu_op: 010
        #10

        // Branch
        assign opcode = 7'b1100011;
        // expect:
        // a_sel: 1
        // b_sel: 1
        // alu_op: 0000
            // context: BEQ
            // branch_alu_op: 000
        assign funct3 = 3'b000;
        #10
            // context: BNE
            // branch_alu_op: 001
        assign funct3 = 3'b001;
        #10
            //context: BLT
            // branch_alu_op: 100
        assign funct3 = 3'b100;
        #10
            // context: BGE
            // branch_alu_op: 101
        assign funct3 = 3'b101;
        #10
            // context: BLTU
            // branch_alu_op: 110
        assign funct3 = 3'b110;
        #10
            // context: BGEU
            // branch_alu_op: 111
        assign funct3 = 3'b111;
        #10

        // Load
        assign opcode = 7'b0000011;
        // expect:
        // a_sel: 0
        // b_sel: 1
        // alu_op: 0000
        // branch_alu_op: 011
        #10

        // Store
        assign opcode = 7'b0100011;
        // expect:
        // a_sel: 0
        // b_sel: 1
        // alu_op: 0000
        // branch_alu_op: 011
        #10

        // I-Type
        assign opcode = 7'b0010011;
        // expect:
        // a_sel: 0
        // b_sel: 1
        // branch_alu_op: 011
            // context: ADDI
            // alu_op: 0000
        assign funct3 = 3'b000;
        #10
            // context: SLTI
            // alu_op: 0010
        assign funct3 = 3'b010;
        #10
            // context: SLTIU
            // alu_op: 0011
        assign funct3 = 3'b011;
        #10
            // context: XORI
            // alu_op: 0100
        assign funct3 = 3'b100;
        #10
            //context: ORI
            // alu_op: 0110
        assign funct3 = 3'b110;
        #10
            // context: ANDI
            // alu_op: 0111
        assign funct3 = 3'b111;
        #10
            // context: SLLI
            // alu_op: 0001
        assign funct3 = 3'b001;
        #10
            // context: SRLI
            // alu_op: 0101
        assign funct3 = 3'b101;
        assign funct7 = 7'b0000000;
        #10
            // context: SRAI
            // alu_op: 1101
        assign funct3 = 3'b101;
        assign funct7 = 7'b0100000;
        #10

        // R-Type
        assign opcode = 7'b0110011;
        // expect:
        // a_sel: 0
        // b_sel: 0
        // branch_alu_op: 011
            // context: ADD
            // alu_op: 0000
        assign funct3 = 3'b000;
        assign funct7 = 7'b0000000;
        #10
            // context: SUB
            // alu_op: 1000
        assign funct3 = 3'b000;
        assign funct7 = 7'b0100000;
        #10
            // context: SLT
            // alu_op: 0010
        assign funct3 = 3'b010;
        #10
            // context: SLTI
            // alu_op: 0011
        assign funct3 = 3'b011;
        #10
            // context: XOR
            // alu_op: 0100
        assign funct3 = 3'b100;
        #10
            //context: OR
            // alu_op: 0110
        assign funct3 = 3'b110;
        #10
            // context: AND
            // alu_op: 0111
        assign funct3 = 3'b111;
        #10
            // context: SLL
            // alu_op: 0001
        assign funct3 = 3'b001;
        #10
            // context: SRL
            // alu_op: 0101
        assign funct3 = 3'b101;
        assign funct7 = 7'b0000000;
        #10
            // context: SRA
            // alu_op: 1101
        assign funct3 = 3'b101;
        assign funct7 = 7'b0100000;
        #10

        $finish;
    end
endmodule