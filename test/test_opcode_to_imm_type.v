module test_opcode_to_imm_type ();
    reg [6:0] opcode;
    wire [2:0] imm_type;

    opcode_to_imm_type subject(.opcode(opcode), .imm_type(imm_type));

    initial begin
        // U (LUI)
        assign opcode = 7'b0110111;
        // expect: 011
        #10

        // U (AUPIC)
        assign opcode = 7'b0010111;
        // expect: 011
        #10

        // J (JAL)
        assign opcode = 7'b1101111;
        // expect: 100
        #10

        // B
        assign opcode = 7'b1100011;
        // expect: 001
        #10

        // I (Load)
        assign opcode = 7'b0000011;
        // expect: 000
        #10

        // S
        assign opcode = 7'b0100011;
        // expect: 010
        #10

        // I (Arithmetic including shamt)
        assign opcode = 7'b0010011;
        // expect: 000
        #10

        // R
        assign opcode = 7'b0110011;
        // expect: 111
        #10

        $finish;
    end
endmodule