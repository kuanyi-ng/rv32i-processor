module test_imm_extractor ();
    // instruction
    reg [31:0] ir; 
    reg [2:0] imm_type;
    wire [31:0] imm_output;

    imm_extractor subject(.in(ir), .imm_type(imm_type), .out(imm_output));
    
    initial begin
        // I-Type (imm starts with 0)
        // expect: 0000_07ff
        assign ir = 32'h7ffx_xxxx;
        assign imm_type = 3'b000;
        #10

        // I-Type (imm starts with 1)
        // expect: ffff_ffff
        assign ir = 32'hfffx_xxxx;
        assign imm_type = 3'b000;
        #10

        $finish;
    end
endmodule