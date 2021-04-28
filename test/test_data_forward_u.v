module test_data_forward_u ();
    reg [4:0] rs1, rs2, rd_in_ex, rd_in_mem;

    reg wr_reg_n_in_ex, wr_reg_n_in_mem;
    reg [6:0] opcode_in_ex;

    wire [1:0] forward_data1, forward_data2;

    data_forward_u subject(
        .rs1(rs1),
        .rs2(rs2),
        .wr_reg_n_in_ex(wr_reg_n_in_ex),
        .rd_in_ex(rd_in_ex),
        .opcode_in_ex(opcode_in_ex),
        .wr_reg_n_in_mem(wr_reg_n_in_mem),
        .rd_in_mem(rd_in_mem),
        .forward_data1(forward_data1),
        .forward_data2(forward_data2)
    );

    initial begin
        // assume all instructions involved try to update regfile
        // for simplicity and worst case
        assign wr_reg_n_in_ex = 1'b0;
        assign wr_reg_n_in_mem = 1'b0;

        // both rs1 and rs2 are x0
        assign rs1 = 5'b00000;
        assign rs2 = 5'b00000;
        assign rd_in_ex = 5'b00000;
        assign rd_in_mem = 5'b00000;
        assign opcode_in_ex = 7'b0110011;   // R-Type
        // forward_data1: 00
        // forward_data2: 00
        #10

        // both rs1, rs2 are not updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b10001;
        assign rd_in_mem = 5'b10010;
        assign opcode_in_ex = 7'b0110011;   // R-Type
        // forward_data1: 00
        // forward_data2: 00
        #10

        // rs1 is updated by previous instruction only
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign rd_in_mem = 5'b10010;
        assign opcode_in_ex = 7'b0110011;   // R-Type
        // forward_data1: 01
        // forward_data2: 00
        #10

        // rs1 is updated by previous instruction only
        // but previous instruction is a load instruction
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign rd_in_mem = 5'b10010;
        assign opcode_in_ex = 7'b0000011;   // Load
        // forward_data1: 00
        // forward_data2: 00
        #10

        // rs2 is updated by previous previous instruction only
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b10010;
        assign rd_in_mem = 5'b00010;
        assign opcode_in_ex = 7'b0110011;   // R-Type
        // forward_data1: 00
        // forward_data2: 10
        #10

        // rs1 is updated by both previous and previous previous instruction
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign rd_in_mem = 5'b00001;
        assign opcode_in_ex = 7'b0110011;   // R-Type
        // forward_data1: 01
        // forward_data2: 00
        #10

        // rs1, rs2 are updated by
        // both previous and previous previous instructions
        // respectively
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign rd_in_mem = 5'b00010;
        assign opcode_in_ex = 7'b0110011;   // R-Type
        // forward_data1: 01
        // forward_data2: 10
        #10

        $finish;
    end
endmodule
