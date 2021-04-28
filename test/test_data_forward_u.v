module test_data_forward_u ();
    reg [4:0] rs1, rs2, rd_in_ex, rd_in_mem;

    reg wr_reg_n_in_ex, wr_reg_n_in_mem;

    wire [1:0] forward_a, forward_b;

    data_forward_u subject(
        .rs1(rs1),
        .rs2(rs2),
        .wr_reg_n_in_ex(wr_reg_n_in_ex),
        .rd_in_ex(rd_in_ex),
        .wr_reg_n_in_mem(wr_reg_n_in_mem),
        .rd_in_mem(rd_in_mem),
        .forward_a(forward_a),
        .forward_b(forward_b)
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
        // forward_a: 00
        // forward_b: 00
        #5

        // both rs1, rs2 are not updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b10001;
        assign rd_in_mem = 5'b10010;
        // forward_a: 00
        // forward_b: 00
        #5

        // rs1 is updated by previous instruction only
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign rd_in_mem = 5'b10010;
        // forward_a: 01
        // forward_b: 00
        #5

        // rs2 is updated by previous previous instruction only
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b10010;
        assign rd_in_mem = 5'b00010;
        // forward_a: 00
        // forward_b: 10
        #5

        // rs1 is updated by both previous and previous previous instruction
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign rd_in_mem = 5'b00001;
        // forward_a: 01
        // forward_b: 00
        #5

        // rs1, rs2 are updated by
        // both previous and previous previous instructions
        // respectively
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign rd_in_mem = 5'b00010;
        // forward_a: 01
        // forward_b: 10
        #5

        $finish;
    end
endmodule
