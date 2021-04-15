module test_ex_ctrl ();
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire a_sel;
    wire b_sel;

    ex_ctrl subject(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .a_sel(a_sel),
        .b_sel(b_sel)
    );

    initial begin
        // LUI
        assign opcode = 7'b0110111;
        // expect:
        // a_sel: 0
        // b_sel: 1
        #10

        // AUPIC
        assign opcode = 7'b0010111;
        // expect:
        // a_sel: 1
        // b_sel: 1
        #10

        // JAL
        assign opcode = 7'b1101111;
        // expect:
        // a_sel: 1
        // b_sel: 1
        #10

        // JALR
        assign opcode = 7'b1100111;
        // expect:
        // a_sel: 0
        // b_sel: 1
        #10

        // Branch
        assign opcode = 7'b1100011;
        // expect:
        // a_sel: 1
        // b_sel: 1
        #10

        // Load
        assign opcode = 7'b0000011;
        // expect:
        // a_sel: 0
        // b_sel: 1
        #10

        // Store
        assign opcode = 7'b0100011;
        // expect:
        // a_sel: 0
        // b_sel: 1
        #10

        // I-Type
        assign opcode = 7'b0010011;
        // expect:
        // a_sel: 0
        // b_sel: 1
        #10

        // R-Type
        assign opcode = 7'b0110011;
        // expect:
        // a_sel: 0
        // b_sel: 0
        #10

        $finish;
    end
endmodule