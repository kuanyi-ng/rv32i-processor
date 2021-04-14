module test_id_stage ();
    reg clk;
    reg rst_n;

    reg wr_n;
    reg [4:0] wr_addr;
    reg [31:0] data_in;

    reg [31:0] pc_from_if;
    reg [31:0] ir;

    wire [31:0] pc_to_ex;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] data1, data2, imm;
    wire [4:0] rd;

    id_stage subject(
        .clk(clk),
        .rst_n(rst_n),
        .wr_n(wr_n),
        .wr_addr(wr_addr),
        .data_in(data_in),
        .pc_from_if(pc_from_if),
        .ir(ir),
        .pc_to_ex(pc_to_ex),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .data1(data1),
        .data2(data2),
        .imm(imm),
        .rd(rd)
    );

    initial begin
        // initial state
        assign rst_n = 1'b1;

        //
        // Setup
        //

        // write some data into regfile
        assign wr_n = 1'b0;
        // cycle 1
        assign clk = 1'b0;
        assign wr_addr = 5'd1;
        assign data_in = 32'd1;
        #5
        assign clk = ~clk;
        #5
        // cycle 2
        assign clk = ~clk;
        assign wr_addr = 5'd2;
        assign data_in = 32'd2;
        #5
        assign clk = ~clk;
        assign wr_n = 1'b1;
        assign wr_addr = 32'b0; // clear wr_data (reg0 is read-only)
        assign data_in = 32'b0; // clear data_in
        #5

        //
        // Test
        //

        // ADD r3, r1, r2
        assign clk = ~clk;
        assign pc_from_if = 32'd4;  // any multiple of 4 will do
        assign ir = 32'b0000000_00010_00001_000_00011_0110011;
        // expect
        // pc_to_ex: 4
        // opcode: 0110011
        // funct3: 000
        // funct7: 0000000
        // data1: 1
        // data2: 2
        // imm: X
        // rd: 3
        #5

        // ADDI r3, r1, 12'h801
        assign clk = ~clk;
        assign pc_from_if = 32'd8;
        assign ir = 32'b1000_0000_0001_00001_000_00011_0010011;
        // expect
        // pc_to_ex: 8
        // opcode: 0010011
        // funct3: 000
        // funct7: X
        // data1: 1
        // data2: X
        // imm: 12'hffff_f801
        // rd: 3
        #5

        $finish;
    end
endmodule