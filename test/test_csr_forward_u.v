module test_csr_forward_u ();
    reg [11:0] csr_addr_in_id, csr_addr_in_ex, csr_addr_in_mem;
    reg [6:0] opcode_in_ex, opcode_in_mem;
    reg wr_csr_n_in_ex, wr_csr_n_in_mem;

    wire [1:0] forward_z;

    csr_forward_u subject(
        .csr_addr_in_id(csr_addr_in_id),
        .csr_addr_in_ex(csr_addr_in_ex),
        .opcode_in_ex(opcode_in_ex),
        .wr_csr_n_in_ex(wr_csr_n_in_ex),
        .csr_addr_in_mem(csr_addr_in_mem),
        .opcode_in_mem(opcode_in_mem),
        .wr_csr_n_in_mem(wr_csr_n_in_mem),
        .forward_z(forward_z)
    );

    initial begin
        // CSR not in EX, MEM
        wr_csr_n_in_ex = 1'b1;
        wr_csr_n_in_mem = 1'b1;
        // forward: 00
        #5

        // CSR in EX
        wr_csr_n_in_ex = 1'b0;
        wr_csr_n_in_mem = 1'b1;

        // forward: 01
        opcode_in_ex = 7'b1110011;
        csr_addr_in_id = 12'd1;
        csr_addr_in_ex = 12'd1;
        #5

        // doesn't forward: 00
            // different address
        csr_addr_in_id = 12'd2;
        #5
            // happened to have same value as csr_addr_in_id
            // but not CSR instruction in EX
        csr_addr_in_id = 12'd1;
        opcode_in_ex = 7'b0000011;
        #5
            // same address, CSRs instruction in EX but write disabled
        opcode_in_ex = 7'b1110011;
        wr_csr_n_in_ex = 1'b1;
        #5

        // CSR in MEM
        wr_csr_n_in_ex = 1'b1;
        wr_csr_n_in_mem = 1'b0;

        // forward: 10
        opcode_in_mem = 7'b1110011;
        csr_addr_in_id = 12'd1;
        csr_addr_in_mem = 12'd1;
        #5

        // doesn't forward: 00
            // different address
        csr_addr_in_id = 12'd2;
        #5
            // happened to have same value as csr_addr_in_id
            // but not CSR instruction in EX
        csr_addr_in_id = 12'd1;
        opcode_in_mem = 7'b0000011;
        #5
            // same address, CSRs instruction in EX but write disabled
        opcode_in_mem = 7'b1110011;
        wr_csr_n_in_mem = 1'b1;
        #5

        // CSR in both EX, MEM
        // Forward from EX
        wr_csr_n_in_ex = 1'b0;
        wr_csr_n_in_mem = 1'b0;

        opcode_in_ex = 7'b1110011;
        opcode_in_mem = 7'b1110011;

        csr_addr_in_id = 12'd1;
        csr_addr_in_ex = 12'd1;
        csr_addr_in_mem = 12'd1;
        #5

        $finish;
    end

    initial begin
        $monitor("t: %d, forward_z: %b", $time, forward_z);
    end
    
endmodule
