module test_ex_ctrl ();
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [31:0] data1, data2, pc, imm, z_;

    wire [31:0] in1, in2;
    wire [2:0] branch_alu_op;
    wire [3:0] alu_op;

    ex_ctrl subject(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .data1(data1),
        .data2(data2),
        .pc(pc),
        .imm(imm),
        .z_(z_),
        .in1(in1),
        .in2(in2),
        .branch_alu_op(branch_alu_op),
        .alu_op(alu_op)
    );

    initial begin
        data1 = 32'h0000_0001;
        data2 = 32'h0000_0002;
        imm = 32'h0000_0003;
        pc = 32'h0000_0004;
        z_ = 32'h0000_0005;

        // LUI
        opcode = 7'b0110111;
        // expect:
        // in1, in2: 4, 3
        // alu_op: 1001
        // branch_alu_op: 011
        #10

        // AUIPC
        opcode = 7'b0010111;
        // expect:
        // in1, in2: 4, 3
        // alu_op: 0000
        // branch_alu_op: 011
        #10

        // JAL
        opcode = 7'b1101111;
        // expect:
        // in1, in2: 4, 3
        // alu_op: 0000
        // branch_alu_op: 010
        #10

        // JALR
        opcode = 7'b1100111;
        // expect:
        // in1, in2: 1, 3
        // alu_op: 1010
        // branch_alu_op: 010
        #10

        // Branch
        opcode = 7'b1100011;
        // expect:
        // in1, in2: 4, 3
        // alu_op: 0000
            // context: BEQ
            // branch_alu_op: 000
        funct3 = 3'b000;
        #10
            // context: BNE
            // branch_alu_op: 001
        funct3 = 3'b001;
        #10
            //context: BLT
            // branch_alu_op: 100
        funct3 = 3'b100;
        #10
            // context: BGE
            // branch_alu_op: 101
        funct3 = 3'b101;
        #10
            // context: BLTU
            // branch_alu_op: 110
        funct3 = 3'b110;
        #10
            // context: BGEU
            // branch_alu_op: 111
        funct3 = 3'b111;
        #10

        // Load
        opcode = 7'b0000011;
        // expect:
        // in1, in2: 1, 3
        // alu_op: 0000
        // branch_alu_op: 011
        #10

        // Store
        opcode = 7'b0100011;
        // expect:
        // in1, in2: 1, 3
        // alu_op: 0000
        // branch_alu_op: 011
        #10

        // I-Type
        opcode = 7'b0010011;
        // expect:
        // in1, in2: 1, 3
        // branch_alu_op: 011
            // context: ADDI
            // alu_op: 0000
        funct3 = 3'b000;
        #10
            // context: SLTI
            // alu_op: 0010
        funct3 = 3'b010;
        #10
            // context: SLTIU
            // alu_op: 0011
        funct3 = 3'b011;
        #10
            // context: XORI
            // alu_op: 0100
        funct3 = 3'b100;
        #10
            //context: ORI
            // alu_op: 0110
        funct3 = 3'b110;
        #10
            // context: ANDI
            // alu_op: 0111
        funct3 = 3'b111;
        #10
            // context: SLLI
            // alu_op: 0001
        funct3 = 3'b001;
        #10
            // context: SRLI
            // alu_op: 0101
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10
            // context: SRAI
            // alu_op: 1101
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        #10

        // R-Type
        opcode = 7'b0110011;
        // expect:
        // in1, in2: 1, 2
        // branch_alu_op: 011
            // context: ADD
            // alu_op: 0000
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10
            // context: SUB
            // alu_op: 1000
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #10
            // context: SLT
            // alu_op: 0010
        funct3 = 3'b010;
        #10
            // context: SLTI
            // alu_op: 0011
        funct3 = 3'b011;
        #10
            // context: XOR
            // alu_op: 0100
        funct3 = 3'b100;
        #10
            //context: OR
            // alu_op: 0110
        funct3 = 3'b110;
        #10
            // context: AND
            // alu_op: 0111
        funct3 = 3'b111;
        #10
            // context: SLL
            // alu_op: 0001
        funct3 = 3'b001;
        #10
            // context: SRL
            // alu_op: 0101
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10
            // context: SRA
            // alu_op: 1101
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        #10

        // CSR
        opcode = 7'b1110011;
            // CSRRW
            // in1, in2: 5, 1
        funct3 = 3'b001;
        #10
            // CSRRS
            // in1, in2: 5, 1
        funct3 = 3'b010;
        #10
            // CSRRC
            // in1, in2: 5, 1
        funct3 = 3'b011;
        #10
            // CSRRWI
            // in1, in2: 5, 3
        funct3 = 3'b101;
        #10
            // CSRRSI
            // in1, in2: 5, 3
        funct3 = 3'b110;
        #10
            // CSRRCI
            // in1, in2: 5, 3
        funct3 = 3'b111;
        #10

        $finish;
    end

    initial begin
        $monitor(
            "t: %3d\nin1: %h\nin2: %h\nbranch_alu_op: %b\nalu_op: %b\n",
            $time,
            in1,
            in2,
            branch_alu_op,
            alu_op
        );
    end
endmodule
