module test_alu ();
    reg [31:0] data1, data2;
    reg [3:0] alu_op;
    wire [31:0] alu_output;

    alu subject(.in1(data1), .in2(data2), .alu_op(alu_op), .out(alu_output));

    initial begin
        // initial setup
        assign data1 = 32'd4;
        assign data2 = 32'd6;

        // ADD, ADDI, Load, Store, Branch, JAL, AUIPC
        // expect: 0000_000a
        assign alu_op = 4'b0000;
        #10

        // SUB
        // expect: ffff_fffe
        assign alu_op = 4'b1000;
        #10

        // XOR, XORI
        // expect: 0000_0002
        assign alu_op = 4'b0100;
        #10

        // OR, ORI
        // expect: 0000_0006
        assign alu_op = 4'b0110;
        #10

        // AND, ANDI
        // expect: 0000_0004
        assign alu_op = 4'b0111;
        #10

        assign data1 = 32'hf000_0004;
        assign data2 = 32'd4;

        // SLL, SLLI
        // expect: 0000_0040
        assign alu_op = 4'b0001;
        #10

        // SRL, SRLI
        // expect: 0f00_0000
        assign alu_op = 4'b0101;
        #10

        // SRA, SRAI
        // expect: ff00_0000
        assign alu_op = 4'b1101;
        #10

        assign data1 = 32'h0000_1000;
        assign data2 = 32'hf000_1000;

        // SLT, SLTI
        // expect: 0000_0000
        assign alu_op = 4'b0010;
        #10

        // SLTU, SLTIU
        // expect: 0000_0001
        assign alu_op = 4'b0011;
        #10

        // JALR
        assign data2 = 32'd8;
        assign alu_op = 4'b1010;
        // context: doesn't switch 0th bit
        // expect: 0000_0008
        assign data1 = 32'd1;
        #10
        // context: switch 0th bit
        // expect: 0000_000a
        assign data1 = 32'd2;
        #10

        // LUI
        // expect: 0000_0008
        assign alu_op = 4'b1001;
        #10

        $finish;
    end
endmodule
