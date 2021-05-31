module test_if_stage ();
    reg [31:0] current_pc;
    reg [31:0] c;
    reg jump;

    wire [31:0] next_pc;
    wire [31:0] pc4;
    wire i_addr_misaligned;

    if_stage subject(
        .current_pc(current_pc),
        .c(c),
        .jump(jump),
        .pc4(pc4),
        .next_pc(next_pc),
        .i_addr_misaligned(i_addr_misaligned)
    );

    initial begin
        assign current_pc = 32'd8;
        assign c = 32'd4;

        // no jump
        // next_pc = c
        // pc4 = c
        assign jump = 1'b0;
        #10

        // jump
        // expect: next_pc = 4
        // pc4 = c
        assign jump = 1'b1;
        #10

        // no jump
        // address misaligned
        assign jump = 1'b0;
        // i_addr_misaligned = 0
        assign current_pc = 32'h0;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'h1;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'h2;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'h3;
        #10
        // i_addr_misaligned = 0
        assign current_pc = 32'h4;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'h5;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'h6;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'h7;
        #10
        // i_addr_misaligned = 0
        assign current_pc = 32'h8;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'h9;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'ha;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'hb;
        #10
        // i_addr_misaligned = 0
        assign current_pc = 32'hc;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'hd;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'he;
        #10
        // i_addr_misaligned = 1
        assign current_pc = 32'hf;
        #10

        $finish;
    end

    initial begin
        $monitor(
            "t: %d, pc4: %h, next_pc: %h, i_addr_misaligned: %b",
            $time,
            pc4,
            next_pc,
            i_addr_misaligned
        );
    end
endmodule
