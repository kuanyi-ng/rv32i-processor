module test_mem_ctrl ();
    reg [6:0] opcode;
    reg [2:0] funct3;

    wire [1:0] access_size;
    wire write_to_data_mem;
    wire require_mem_access;

    mem_ctrl subject(
        .opcode(opcode),
        .funct3(funct3),
        .access_size(access_size),
        .write_to_data_mem(write_to_data_mem),
        .require_mem_access(require_mem_access)
    );

    initial begin
        // require_mem_access: 1

        // Load Instructions
        // write_to_data_mem: 0
        assign opcode = 7'b0000011;
            // context: LB
            // expect
            // access_size: 10
        assign funct3 = 3'b000;
        #10
            // context: LH
            // expect
            // access_size: 01
        assign funct3 = 3'b001;
        #10
            // context: LW
            // expect
            // access_size: 00
        assign funct3 = 3'b010;
        #10
            // context: LBU
            // expect
            // access_size: 10
        assign funct3 = 3'b100;
        #10
            // context: LHU
            // expect
            // access_size: 01
        assign funct3 = 3'b101;
        #10

        // Store Instructions
        // write_to_data_mem: 1
        assign opcode = 7'b0100011;
            // context: SB
            // expect
            // access_size: 10
        assign funct3 = 3'b000;
        #10
            // context: SH
            // expect
            // access_size: 01
        assign funct3 = 3'b001;
        #10
            // context: SW
            // expect
            // access_size: 00
        assign funct3 = 3'b010;
        #10

        // Other Instructions
        // expect
        // write_to_data_mem: 0
        // access_size: 11
        assign opcode = 7'bxxxxxxx;
        #10

        $finish;
    end
endmodule
