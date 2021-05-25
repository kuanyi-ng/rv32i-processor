module test_wb_ctrl ();
    reg [6:0] opcode;

    wire [1:0] data_to_reg_sel;

    wb_ctrl subject(
        .opcode(opcode),
        .data_to_reg_sel(data_to_reg_sel)
    );

    initial begin
        // LUI
        // data_to_reg_sel: 0
        opcode = 7'b0110111;
        #10

        // AUIPIC
        // data_to_reg_sel: 0
        opcode = 7'b0010111;
        #10

        // JAL
        // data_to_reg_sel: 2
        opcode = 7'b1101111;
        #10

        // JALR
        // data_to_reg_sel: 2
        opcode = 7'b1100111;
        #10

        // Branch
        // data_to_reg_sel: 0
        opcode = 7'b1100011;
        #10

        // Load
        // data_to_reg_sel: 1
        opcode = 7'b0000011;
        #10

        // Store
        // data_to_reg_sel: 0
        opcode = 7'b0100011;
        #10

        // I
        // data_to_reg_sel: 0
        opcode = 7'b0010011;
        #10

        // R
        // data_to_reg_sel: 0
        opcode = 7'b0110011;
        #10

        // CSRs
        // data_to_reg_sel: 3
        opcode = 7'b1110011;
        #10

        $finish;
    end

    initial begin
        $monitor("t: %d, data_to_reg_sel: %d", $time, data_to_reg_sel);
    end
endmodule
