module test_mem_stage ();
    reg data_mem_access_ready_n;
    reg [31:0] data_from_mem;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [31:0] pc_from_ex;
    reg [4:0] rd_from_ex;
    reg [6:0] opcode_from_ex;
    reg [31:0] b, c;


    wire [31:0] pc_to_wb;
    wire [4:0] rd_to_wb;
    wire [6:0] opcode_to_wb;
    wire [31:0] d;
    wire [31:0] data_mem_addr;
    wire require_mem_access, write;
    wire [1:0] size;
    wire [31:0] data_to_mem;

    mem_stage subject(
        .data_mem_access_ready_n(data_mem_access_ready_n),
        .data_from_mem(data_from_mem),
        .opcode(opcode),
        .funct3(funct3),
        .pc_from_ex(pc_from_ex),
        .rd_from_ex(rd_from_ex),
        .b(b),
        .c(c),
        .pc_to_wb(pc_to_wb),
        .rd_to_wb(rd_to_wb),
        .opcode_to_wb(opcode_to_wb),
        .d(d),
        .data_mem_addr(data_mem_addr),
        .require_mem_access(require_mem_access),
        .write(write),
        .size(size),
        .data_to_mem(data_to_mem)
    );

    initial begin
        // expect: 
        // pc_to_wb: 4
        assign pc_from_ex = 32'd4;
        // expect
        // rd_to_wb = 3
        assign rd_from_ex = 5'd3;

        assign data_mem_access_ready_n = 1'b0;

        // Load Instructions
        // data_mem_addr: 0000_1234
        // require_mem_access: 1
        // write: 0
        // opcode_to_wb: 1100011
        assign opcode = 7'b1100011;
        assign data_from_mem = 32'ha0b1_c2d3; // better to have diff results for signed and unsigned
            // context: LB
            // expect
            // size: 10
            // d: ffff_ffb1
        assign c = 32'h0000_0002;
        assign funct3 = 3'b000;
        #10
            // context: LH
            // expect
            // size: 01
            // d: ffff_a0b1
        assign c = 32'h0000_0002;
        assign funct3 = 3'b001;
        #10
            // context: LW
            // expect
            // size: 00
            // d: a0b1_c2d3
        assign c = 32'h0000_0004;
        assign funct3 = 3'b010;
        #10
            // context: LBU
            // expect
            // size: 10
            // d: 0000_00d3
        assign c = 32'h0000_0000;
        assign funct3 = 3'b100;
        #10
            // context: LHU
            // expect
            // size: 01
            // d: 0000_c2d3
        assign c = 32'h0000_0000;
        assign funct3 = 3'b101;
        #10

        assign c = 32'h0000_1234;

        // Store Instructions
        // data_mem_addr: 0000_1234
        // require_mem_access: 1
        // write: 1
        // opcode_to_wb: 0100011
        assign opcode = 7'b0100011;
        assign b = 32'h8765_4321;
            // context: SB
            // expect
            // size: 10
            // data_to_mem: 2121_2121
        assign funct3 = 3'b000;
        #10
            // context: SH
            // expect
            // size: 01
            // data_to_mem: 4321_4321
        assign funct3 = 3'b001;
        #10
            // context: SW
            // expect
            // size: 00
            // data_to_mem: 8765_4321
        assign funct3 = 3'b010;
        #10

        // Other Instructions
        // expect
        // d: xxxx_xxxx
        // data_mem_addr: 0000_1234
        // require_mem_access: 0
        // write: 0
        // size: 11
        // data_to_mem: xxxx_xxxx
        // opcode_to_wb: xxxxxxx
        assign opcode = 7'bxxxxxxx;
        assign funct3 = 3'bxxx;
        #10

        // expect
        // require_mem_access: 0
        assign data_mem_access_ready_n = 1'b1;
        #10

        $finish;
    end
endmodule