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
        #5

        rst_n = 1'b1;
        #5

        // Write to Read-only CSRs
        // shouldn't be update
        wr_csr_n = 1'b0;
        csr_data_in = 32'hffff_ffff;

        csr_wr_addr = mvendorid_addr;
        #10

        csr_wr_addr = marchid_addr;
        #10

        csr_wr_addr = mimpid_addr;
        #10

        csr_wr_addr = mhartid_addr;
        #10

        csr_wr_addr = misa_addr;
        #10

        csr_wr_addr = mtvec_addr;
        #10

        csr_wr_addr = mcounteren_addr;
        #10

        // Read Read-only CSRs
        // check if they are not update
        wr_csr_n = 1'b1;

        csr_addr = mvendorid_addr;
        // 32'b0
        #10

        csr_addr = marchid_addr;
        // 32'b0
        #10

        csr_addr = mimpid_addr;
        // 32'b0
        #10

        csr_addr = mhartid_addr;
        // 32'b0
        #10

        csr_addr = misa_addr;
        // b'01_0000_00_00_00_00_00_00_00_00_01_00_00_00_00
        // h'4000_0100
        #10

        csr_addr = mtvec_addr;
        // h'0000_0004
        #10

        csr_addr = mcounteren_addr;
        // 32'b0
        #10

        // Write to mstatus
        wr_csr_n = 1'b0;

        csr_wr_addr = mstatus_addr;
        csr_data_in = 32'hffff_ffff;
        #10

        // Read mstatus
        wr_csr_n = 1'b1;

        csr_addr = mstatus_addr;
        // 0_00000000_000000_00_00_11_00_11_0_111_0_11
        // h'0000_19bb
        #10

        // Write Reg32
        wr_csr_n = 1'b0;

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
        // h'1234_5678
        #10

        csr_addr = mepc_addr;
        // h'9abc_efec
        #10

        csr_addr = mcause_addr;
        // h'ba98_7654
        #10

        csr_addr = mtval_addr;
        // h'3210_1234
        #10

        // Write mie, mip
        wr_csr_n = 1'b0;

        csr_wr_addr = mie_addr;
        csr_data_in = { 20'hf, 12'b1_0_111_0_111_0_11 };
        #10

        csr_wr_addr = mip_addr;
        csr_data_in = { 20'hf, 12'b1_0_101_0_101_0_11 };
        #10

        // Read MIE, MIP
        wr_csr_n = 1'b1;

        csr_addr = mie_addr;
        // h'0000_0bbb
        #10

        csr_addr = mip_addr;
        // h'0000_0aab
        #10

        $finish;
    end

    initial begin
        $monitor(
            "t: %3d, csr_addr: %h, csr_value: %h, csr_wr_addr: %h, csr_data_in: %h",
            $time,
            csr_addr,
            csr_out,
            csr_wr_addr,
            csr_data_in
        );
    end

endmodule
