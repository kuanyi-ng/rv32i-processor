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

        $finish;
    end
endmodule