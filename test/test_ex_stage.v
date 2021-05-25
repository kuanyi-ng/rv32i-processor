module test_ex_stage ();
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [31:0] pc;
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] imm;

    wire jump;
    wire [31:0] c;

    ex_stage subject(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .pc(pc),
        .data1(data1),
        .data2(data2),
        .imm(imm),
        .jump(jump),
        .c(c)
    );

    initial begin
        assign pc = 32'd4;

        // LUI
        // expect
        // jump: 0
        // c: f000_0002
        assign imm = 32'hf000_0002;
        assign opcode = 7'b0110111;
        #5

        // AUIPC
        // expect
        // jump: 0
        // c: f0000_0006        
        assign imm = 32'hf000_0002;
        assign opcode = 7'b0010111;
        #5

        // JAL
        // expect
        // jump: 1
        // c: 0000_0008
        assign imm = 32'd4;
        assign opcode = 7'b1101111;
        #5

        // JALR
        // expect
        // jump: 1
        // c: f000_0002
        assign data1 = 32'hf000_0002;
        assign imm = 32'h0000_0001;
        assign funct3 = 3'b000;
        assign opcode = 7'b1100111;
        #5

        // BEQ
        // c: 0000_0008
        assign pc = 32'd4;
        assign imm = 32'd4;
        assign opcode = 7'b1100011;
        assign funct3 = 3'b000;
            // context: data1 == data2
            // jump: 1
        assign data1 = 32'd1;
        assign data2= 32'd1;
        #5
            // context: data1 != data2
            // jump: 0
        assign data1 = 32'd1;
        assign data2 = 32'd2;
        #5

        // Load
        // expect
        // jump: 0
        // c: 0000_0006
        assign data1 = 32'd2;
        assign imm = 32'd4;
        assign funct3 = 3'b000;
        assign opcode = 7'b0000011;
        #5

        // Store
        // expect:
        // jump: 0
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
        // jump: 0
        // c: 0000_0006
        assign data1 = 32'd2;
        assign imm = 32'd4;
        assign funct3 = 3'b000;
        assign opcode = 7'b0010011;
        #5

        // R
        // expect:
        // jump: 0
        // c: 0000_0002
        assign data1 = 32'd4;
        assign data2 = 32'd2;
        assign funct3 = 3'b000;
        assign funct7 = 7'b0100000;
        assign opcode = 7'b0110011;
        #5

        $finish;
    end

    initial begin
        $monitor("t: %3d, jump: %b, c: %h", $time, jump, c);
    end
endmodule