module test_wb_stage ();
    reg [6:0] opcode;
    reg [31:0] c;
    reg [31:0] d;
    reg [31:0] pc_from_mem;

    wire write;
    wire [31:0] data_to_reg;
    wire [31:0] next_pc;

    wb_stage subject(
        .opcode(opcode),
        .c(c),
        .d(d),
        .pc_from_mem(pc_from_mem),
        .write(write),
        .data_to_reg(data_to_reg),
        .next_pc(next_pc)
    );

    initial begin
        assign c = 32'd1;
        assign d = 32'd2;
        assign pc_from_mem = 32'd4;

        // LUI
        // write: 1
        // data_to_reg: 1
        // next_pc: 1
        assign opcode = 7'b0110111;
        #10

        // AUIPIC
        // write: 1
        // data_to_reg: 1
        // next_pc: 1
        assign opcode = 7'b0010111;
        #10

        // JAL
        // write: 1
        // data_to_reg: 8
        // next_pc: 1
        assign opcode = 7'b1101111;
        #10

        // JALR
        // write: 1
        // data_to_reg: 8
        // next_pc: 1
        assign opcode = 7'b1100111;
        #10

        // Branch
        // write: 0
        // data_to_reg: 1
        // next_pc: 1
        assign opcode = 7'b1100011;
        #10

        // Load
        // write: 1
        // data_to_reg: 2
        // next_pc: 1
        assign opcode = 7'b0000011;
        #10

        // Store
        // write: 0
        // data_to_reg: 1
        // next_pc: 1
        assign opcode = 7'b0100011;
        #10

        // I
        // write: 1
        // data_to_reg: 1
        // next_pc: 1
        assign opcode = 7'b0010011;
        #10

        // R
        // write: 1
        // data_to_reg: 1
        // next_pc: 1
        assign opcode = 7'b0110011;
        #10

        $finish;
    end
endmodule