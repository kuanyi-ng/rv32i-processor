module test_ex_jump_picker ();
    reg jump_from_branch_alu;
    reg flush;

    wire jump;

    ex_jump_picker subject(
        .jump_from_branch_alu(jump_from_branch_alu),
        .flush(flush),
        .jump(jump)
    );

    initial begin
        assign jump_from_branch_alu = 1'b0;
        assign flush = 1'b0;
        // jump: 0
        #5

        assign jump_from_branch_alu = 1'b0;
        assign flush = 1'b1;
        // jump: 0
        #5

        assign jump_from_branch_alu = 1'b1;
        assign flush = 1'b0;
        // jump: 1
        #5

        assign jump_from_branch_alu = 1'b1;
        assign flush = 1'b1;
        // jump: 0
        #5

        $finish;
    end

    initial begin
        $monitor("t: %3d, jump: %b", $time, jump);
    end
    
endmodule