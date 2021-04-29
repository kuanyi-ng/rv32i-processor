module test_if_stage ();
    reg [31:0] current_pc;
    reg [31:0] c;
    reg jump_or_branch;

    wire [31:0] next_pc;
    wire [31:0] pc4;

    if_stage subject(
        .current_pc(current_pc),
        .c(c),
        .jump_or_branch(jump_or_branch),
        .pc4(pc4),
        .next_pc(next_pc)
    );

    initial begin
        assign current_pc = 32'd8;
        assign c = 32'd4;

        // no jump
        // next_pc = c
        // pc4 = c
        assign jump_or_branch = 1'b0;
        #10

        // jump
        // expect: next_pc = 4
        // pc4 = c
        assign jump_or_branch = 1'b1;
        #10

        $finish;
    end
endmodule