module test_csrs ();
    reg clk, rst_n;
    
    reg [11:0] csr_addr, csr_wr_addr;
    reg [31:0] csr_data_in;
    reg wr_csr_n;

    wire [31:0] csr_out;

    csrs subject(
        .clk(clk),
        .rst_n(rst_n),
        .csr_addr(csr_addr),
        .csr_wr_addr(csr_wr_addr),
        .csr_data_in(csr_data_in),
        .wr_csr_n(wr_csr_n),
        .csr_out(csr_out)
    );

    always begin
        clk = 1'b1;
        #5 clk = 1'b0;
        #5;
    end

    localparam [11:0] mvendorid_addr = 12'hf11;
    localparam [11:0] marchid_addr = 12'hf12;
    localparam [11:0] mimpid_addr = 12'hf13;
    localparam [11:0] mhartid_addr = 12'hf14;

    localparam [11:0] mstatus_addr = 12'h300;
    localparam [11:0] misa_addr = 12'h301;
    localparam [11:0] mie_addr = 12'h304;
    localparam [11:0] mtvec_addr = 12'h305;
    localparam [11:0] mcounteren_addr = 12'h306;

    localparam [11:0] mscratch_addr = 12'h340;
    localparam [11:0] mepc_addr = 12'h341;
    localparam [11:0] mcause_addr = 12'h342;
    localparam [11:0] mtval_addr = 12'h343;
    localparam [11:0] mip_addr = 12'h344;

    initial begin
        // Reset
        rst_n = 1'b0;
        #10

        rst_n = 1'b1;
        #10

        // Write Reg32
        wr_csr_n = 1'b0;
        #10

        csr_wr_addr = mscratch_addr;
        csr_data_in = 32'h1234_5678;
        #10

        csr_wr_addr = mepc_addr;
        csr_data_in = 32'h9abc_efec;
        #10

        csr_wr_addr = mcause_addr;
        csr_data_in = 32'hba98_7654;
        #10

        csr_wr_addr = mtval_addr;
        csr_data_in = 32'h3210_1234;
        #10

        // Read Reg32
        wr_csr_n = 1'b1;

        csr_addr = mscratch_addr;
        #10

        csr_addr = mepc_addr;
        #10

        csr_addr = mcause_addr;
        #10

        csr_addr = mtval_addr;
        #10

        // Write mie, mip
        wr_csr_n = 1'b0;

        csr_wr_addr = mie_addr;
        csr_data_in = { 20'bx, 12'b1_0_111_0_111_0_11 };
        #10

        csr_wr_addr = mip_addr;
        csr_data_in = { 20'bx, 12'b1_0_101_0_101_0_11 };
        #10

        $finish;
    end

    initial begin
        $monitor("t: %3d, csr_value: %h", $time, csr_out);
    end

endmodule
