module test_ex_stage ();
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [31:0] pc_from_id;
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] imm;
    reg [4:0] rd;

    wire jump_or_branch;
    wire [31:0] b;
    wire [31:0] c;
    wire [4:0] reg_wr_addr;

    ex_stage subject(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .pc_from_id(pc_from_id),
        .data1(data1),
        .data2(data2),
        .imm(imm),
        .rd(rd),
        .jump_or_branch(jump_or_branch),
        .b(b),
        .c(c),
        .reg_wr_addr(reg_wr_addr)
    );

    initial begin
        assign pc_from_id = 32'd4;
        // reg_wr_addr: 1
        assign rd = 5'd1;

        // LUI
        // expect
        // jump_or_branch: 0
        // c: f000_0002
        assign imm = 32'hf000_0002;
        assign opcode = 7'b0110111;
        #5

        // AUPIC
        // expect
        // jump_or_branch: 0
        // c: f0000_0006        
        assign imm = 32'hf000_0002;
        assign opcode = 7'b0010111;
        #5

        // JAL
        // expect
        // jump_or_branch: 1
        // c: 0000_0008
        assign imm = 32'd4;
        assign opcode = 7'b1101111;
        #5

        // JALR
        // expect
        // jump_or_branch: 1
        // c: f000_0002
        assign data1 = 32'hf000_0002;
        assign imm = 32'h0000_0001;
        assign funct3 = 3'b000;
        assign opcode = 7'b1100111;
        #5

        // BEQ
        // c: 0000_0008
        assign pc_from_id = 32'd4;
        assign imm = 32'd4;
        assign opcode = 7'b1100011;
        assign funct3 = 3'b000;
            // context: data1 == data2
            // jump_or_branch: 1
        assign data1 = 32'd1;
        assign data2= 32'd1;
        #5
            // context: data1 != data2
            // jump_or_branch: 0
        assign data1 = 32'd1;
        assign data2 = 32'd2;
        #5

        // Load
        // expect
        // jump_or_branch: 0
        // c: 0000_0006
        assign data1 = 32'd2;
        assign imm = 32'd4;
        assign funct3 = 3'b000;
        assign opcode = 7'b0000011;
        #5

        // Store
        // expect:
        // jump_or_branch: 0
        // c: 0000_0006
        // b: 0000_0008
        assign data1 = 32'd2;
        assign imm = 32'd4;
        assign data2 = 32'd8;
        assign funct3 = 3'b000;
        assign opcode = 7'b0100011;
        #5

        // I
        // expect:
        // jump_or_branch: 0
        // c: 0000_0006
        assign data1 = 32'd2;
        assign imm = 32'd4;
        assign funct3 = 3'b000;
        assign opcode = 7'b0010011;
        #5

        // R
        // expect:
        // jump_or_branch: 0
        // c: 0000_0002
        assign data1 = 32'd4;
        assign data2 = 32'd2;
        assign funct3 = 3'b000;
        assign funct7 = 7'b0100000;
        assign opcode = 7'b0110011;
        #5

        $finish;
    end
endmodule