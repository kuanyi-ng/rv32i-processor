module test_imm_extractor ();
    // instruction
    reg [31:0] ir; 
    reg [2:0] imm_type;
    wire [31:0] imm_output;

    imm_extractor subject(.in(ir), .imm_type(imm_type), .out(imm_output));
    
    initial begin
        // I-Type
        assign imm_type = 3'b000;
        // context: imm starts with 0
        // expect: 0000_07ff
        assign ir = 32'h7ffx_xxxx;
        #10
        // context: imm starts with 1
        // expect: ffff_ffff
        assign ir = 32'hfffx_xxxx;
        #10

        // B-Type
        assign imm_type = 3'b001;
        // context: imm starts with 0
        // expect: 0000_0bee
        assign ir = 32'b0011_111x_xxxx_xxxx_xxxx_0111_1xxx_xxxx;
        #10
        // context: imm starts with 1
        // expect: ffff_fbee
        assign ir = 32'b1011_111x_xxxx_xxxx_xxxx_0111_1xxx_xxxx;
        #10

        // S-Type
        assign imm_type = 3'b010;
        // context: imm starts with 0
        // expect: 0000_07ff
        assign ir = 32'b0111_111x_xxxx_xxxx_xxxx_1111_1xxx_xxxx;
        #10
        // context: imm starts with 1
        // expect: ffff_ffff
        assign ir = 32'b1111_111x_xxxx_xxxx_xxxx_1111_1xxx_xxxx;
        #10

        // U-Type
        assign imm_type = 3'b011;
        // context: imm starts with 0
        // expect: 7fff_f000
        assign ir = 32'h7fff_fxxx;
        #10
        // context: imm starts with 1
        // expect: ffff_f000
        assign ir = 32'hffff_fxxx;
        #10

        // J-Type
        assign imm_type = 3'b100;
        // context: imm starts with 0
        // expect: 0007_f3fe
        assign ir = 32'b0011_1111_1110_0111_1111_xxxx_xxxx_xxxx;
        #10
        // context: imm starts with 1
        // expect: fff7_f3f3e
        assign ir = 32'b1011_1111_1110_0111_1111_xxxx_xxxx_xxxx;
        #10

        // Shamt Imm
        assign imm_type = 3'b101;
        // context: imm starts with 0
        // expect: 0000_000f
        assign ir = 32'bxxxx_xxx0_1111_xxxx_xxxx_xxxx_xxxx_xxxx;
        #10
        // context: imm starts with 1
        // expect: 0000_001f
        assign ir = 32'bxxxx_xxx1_1111_xxxx_xxxx_xxxx_xxxx_xxxx;
        #10

        // CSR Type
        assign imm_type = 3'b110;
        // context: imm starts with 0
        // expect: 0000_000f
        assign ir = 32'bxxxx_xxxx_xxxx_01111_101_xxxxx_1110011;
        #10
        // context: imm starts with 1
        // expect: 0000_001f
        assign ir = 32'bxxxx_xxxx_xxxx_11111_101_xxxxx_1110011;
        #10

        $finish;
    end

    initial begin
        $monitor("t: %3d, imm: %h", $time, imm_output);
    end
endmodule
