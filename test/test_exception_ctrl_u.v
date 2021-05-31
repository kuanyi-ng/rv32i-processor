module test_exception_ctrl_u ();

    reg i_addr_misaligned, illegal_ir, jump;
    reg [31:0] pc_of_i_addr_misaligned, pc_of_illegal_ir, ir_in_question;
    
    wire [1:0] exception_cause;
    wire [31:0] exception_epc, exception_tval;

    exception_ctrl_u subject(
        .i_addr_misaligned(i_addr_misaligned),
        .pc_of_i_addr_misaligned(pc_of_i_addr_misaligned),
        .illegal_ir(illegal_ir),
        .ir_in_question(ir_in_question),
        .pc_of_illegal_ir(pc_of_illegal_ir),
        .jump(jump),
        .exception_cause(exception_cause),
        .exception_epc(exception_epc),
        .exception_tval(exception_tval)
    );

    initial begin
        pc_of_i_addr_misaligned = 32'd6;
        pc_of_illegal_ir = 32'd8;
        ir_in_question = 32'hf;

        { jump, illegal_ir, i_addr_misaligned } = 3'b000;
        // cause: 00
        // epc: 0001_0000
        // tval: 0000_0000
        #10

        { jump, illegal_ir, i_addr_misaligned } = 3'b001;
        // cause: 01
        // epc: 0000_0006
        // tval: 0000_0006
        #10

        { jump, illegal_ir, i_addr_misaligned } = 3'b010;
        // cause: 10
        // epc: 0000_0008
        // tval: 0000_000f
        #10

        { jump, illegal_ir, i_addr_misaligned } = 3'b011;
        // cause: 10
        // epc: 0000_0008
        // tval: 0000_000f
        #10
        
        { jump, illegal_ir, i_addr_misaligned } = 3'b100;
        // cause: 00
        // epc: 0001_0000
        // tval: 0000_0000
        #10

        { jump, illegal_ir, i_addr_misaligned } = 3'b101;
        // cause: 00
        // epc: 0001_0000
        // tval: 0000_0000
        #10

        { jump, illegal_ir, i_addr_misaligned } = 3'b110;
        // cause: 00
        // epc: 0001_0000
        // tval: 0000_0000
        #10

        { jump, illegal_ir, i_addr_misaligned } = 3'b111;
        // cause: 00
        // epc: 0001_0000
        // tval: 0000_0000
        #10

        $finish;
    end

    initial begin
        $monitor(
            "t: %d, cause: %b, epc: %h, tval: %h",
            $time,
            exception_cause,
            exception_epc,
            exception_tval
        );
    end
endmodule