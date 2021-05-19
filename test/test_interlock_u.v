module test_interlock_u ();
    reg imem_ack_n, dmem_ack_n;
    reg [6:0] opcode;

    wire interlock;

    interlock_u subject(
        .imem_ack_n(imem_ack_n),
        .dmem_ack_n(dmem_ack_n),
        .opcode(opcode),
        .interlock(interlock)
    );

    initial begin
        // Load
        assign opcode = 7'b0000011;
        assign imem_ack_n = 0;
        assign dmem_ack_n = 0;
        // interlock: 0
        #5

        assign imem_ack_n = 0;
        assign dmem_ack_n = 1;
        // interlock: 1
        #5

        assign imem_ack_n = 1;
        assign dmem_ack_n = 0;
        // interlock: 1
        #5
        
        assign imem_ack_n = 1;
        assign dmem_ack_n = 1;
        // interlock: 1
        #5

        // Store
        assign opcode = 7'b0100011;
        assign imem_ack_n = 0;
        assign dmem_ack_n = 0;
        // interlock: 0
        #5

        assign imem_ack_n = 0;
        assign dmem_ack_n = 1;
        // interlock: 1
        #5

        assign imem_ack_n = 1;
        assign dmem_ack_n = 0;
        // interlock: 1
        #5
        
        assign imem_ack_n = 1;
        assign dmem_ack_n = 1;
        // interlock: 1
        #5

        // Others (R)
        assign opcode = 7'b0110011;
        assign imem_ack_n = 0;
        assign dmem_ack_n = 0;
        // interlock: 0
        #5

        assign imem_ack_n = 0;
        assign dmem_ack_n = 1;
        // interlock: 0
        #5

        assign imem_ack_n = 1;
        assign dmem_ack_n = 0;
        // interlock: 1
        #5
        
        assign imem_ack_n = 1;
        assign dmem_ack_n = 1;
        // interlock: 1
        #5

        $finish;
    end

    initial begin
        $monitor("t: %3d, interlock: %b", $time, interlock);
    end

endmodule
