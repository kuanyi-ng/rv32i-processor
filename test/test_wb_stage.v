module test_wb_stage ();
    reg [6:0] opcode;
    reg [31:0] c;
    reg [31:0] d;
    reg [31:0] pc;

    wire write_n;
    wire [31:0] data_to_reg;

    wb_stage subject(
        .opcode(opcode),
        .c(c),
        .d(d),
        .pc(pc),
        .write_n(write_n),
        .data_to_reg(data_to_reg)
    );

    initial begin
        assign c = 32'd1;
        assign d = 32'd2;
        assign pc = 32'd4;

        // LUI
        // write_n: 0
        // data_to_reg: 1
        assign opcode = 7'b0110111;
        #10

        // AUIPIC
        // write_n: 0
        // data_to_reg: 1
        assign opcode = 7'b0010111;
        #10

        // JAL
        // write_n: 0
        // data_to_reg: 8
        assign opcode = 7'b1101111;
        #10

        // JALR
        // write_n: 0
        // data_to_reg: 8
        assign opcode = 7'b1100111;
        #10

        // Branch
        // write_n: 1
        // data_to_reg: 1
        assign opcode = 7'b1100011;
        #10

        // Load
        // write_n: 0
        // data_to_reg: 2
        assign opcode = 7'b0000011;
        #10

        // Store
        // write_n: 1
        // data_to_reg: 1
        assign opcode = 7'b0100011;
        #10

        // I
        // write_n: 0
        // data_to_reg: 1
        assign opcode = 7'b0010011;
        #10

        // R
        // write_n: 0
        // data_to_reg: 1
        assign opcode = 7'b0110011;
        #10

        $finish;
    end
endmodule