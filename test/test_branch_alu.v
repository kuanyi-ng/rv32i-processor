module test_branch_alu ();
    reg [31:0] data1, data2;
    reg [2:0] branch_alu_op;
    wire branch_alu_output;

    branch_alu subject(.in1(data1), .in2(data2), .branch_alu_op(branch_alu_op), .out(branch_alu_output));

    initial begin
        assign data1 = 32'd4;
        assign data2 = 32'd6;

        // EQ
        // expect: 0
        assign branch_alu_op = 3'b000;
        #10

        // NE
        // expect: 1
        assign branch_alu_op = 3'b001;
        #10

        assign data1 = 32'hf000_0004;
        assign data2 = 32'h0000_0004;

        // LT
        // expect: 1
        assign branch_alu_op = 3'b010;
        #10

        // LTU
        // expect: 0
        assign branch_alu_op = 3'b011;
        #10

        // GE
        // expect: 0
        assign branch_alu_op = 3'b100;
        #10

        // GEU
        // expect: 1
        assign branch_alu_op = 3'b101;
        #10
        
        // JAL
        // expect: 1
        assign branch_alu_op = 3'b110;
        #10

        // JALR
        // expect: 1
        assign branch_alu_op = 3'b111;
        #10

        $finish;
    end
endmodule
