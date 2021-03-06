module test_if_ctrl ();
    reg [31:0] pc4;
    reg [31:0] c;
    reg jump;

    wire [31:0] next_pc;

    if_ctrl subject(
        .pc4(pc4),
        .c(c),
        .jump(jump),
        .next_pc(next_pc)
    );

    initial begin
        assign pc4 = 32'd8;
        assign c = 32'd4;

        // no jump
        // expect: next_pc = 8
        assign jump = 1'b0;
        #10

        // jump
        // expect: next_pc = 4
        assign jump = 1'b1;
        #10

        $finish;
    end
endmodule