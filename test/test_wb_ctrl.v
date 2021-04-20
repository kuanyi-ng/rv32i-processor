module test_wb_ctrl ();
    reg [6:0] opcode;

    wire write_to_reg;
    wire [1:0] data_to_reg_sel;

    wb_ctrl subject(
        .opcode(opcode),
        .write_to_reg(write_to_reg),
        .data_to_reg_sel(data_to_reg_sel)
    );

    initial begin
        // LUI
        // write_to_reg: 1
        // data_to_reg_sel: 0
        assign opcode = 7'b0110111;
        #10

        // AUIPIC
        // write_to_reg: 1
        // data_to_reg_sel: 0
        assign opcode = 7'b0010111;
        #10

        // JAL
        // write_to_reg: 1
        // data_to_reg_sel: 2
        assign opcode = 7'b1101111;
        #10

        // JALR
        // write_to_reg: 1
        // data_to_reg_sel: 2
        assign opcode = 7'b1100111;
        #10

        // Branch
        // write_to_reg: 0
        // data_to_reg_sel: 0
        assign opcode = 7'b1100011;
        #10

        // Load
        // write_to_reg: 1
        // data_to_reg_sel: 1
        assign opcode = 7'b0000011;
        #10

        // Store
        // write_to_reg: 0
        // data_to_reg_sel: 0
        assign opcode = 7'b0100011;
        #10

        // I
        // write_to_reg: 1
        // data_to_reg_sel: 0
        assign opcode = 7'b0010011;
        #10

        // R
        // write_to_reg: 1
        // data_to_reg_sel: 0
        assign opcode = 7'b0110011;
        #10

        $finish;
    end
endmodule