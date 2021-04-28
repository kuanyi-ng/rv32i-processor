module test_data_forward_helper ();
    reg [31:0] main_data, sub_data;
    reg [6:0] opcode;

    wire [31:0] data_to_forward;

    data_forward_helper subject(
        .main_data(main_data),
        .sub_data(sub_data),
        .opcode(opcode),
        .data_to_forward(data_to_forward)
    );

    initial begin
        assign main_data = 32'h0000_0001;
        assign sub_data = 32'h0000_0002;

        // LUI
        assign opcode = 7'b0110111;
        // data_to_forward: 1
        #5

        // AUIPC
        assign opcode = 7'b0010111;
        // data_to_forward: 1
        #5

        // JAL
        assign opcode = 7'b1101111;
        // data_to_forward: 2
        #5

        // JALR
        assign opcode = 7'b1100111;
        // data_to_forward: 2
        #5

        // Branch: BEQ
        assign opcode = 7'b1100011;
        // data_to_forward: x
        #5

        // Load: LB
        assign opcode = 7'b0000011;
        // data_to_forward: 2
        #5

        // Store: SB
        assign opcode = 7'b0100011;
        // data_to_forward: x
        #5

        // I: ADDI r3, r1, 12'h801
        assign opcode = 7'b0010011;
        // data_to_forward: 1
        #5

        // R: ADD r3, r1, r2
        assign opcode = 7'b0110011;
        // data_to_forward: 1
        #5

        $finish;
        
    end
endmodule