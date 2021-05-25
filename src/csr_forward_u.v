module csr_forward_u (
    // Inputs from ID Stage (current cycle)
    input [11:0] csr_addr_in_id,

    // Inputs from EX Stage (current cycle)
    input [11:0] csr_addr_in_ex,
    input [6:0] opcode_in_ex,
    input wr_csr_n_in_ex,

    output forward_z
);
    
    //
    // Main
    //

    assign forward_z = forward_z_ctrl(csr_addr_in_id, csr_addr_in_ex, opcode_in_ex, wr_csr_n_in_ex);

    //
    // Function
    //

    localparam [6:0] csr_op = 7'b1110011;

    function forward_z_ctrl(
        input [11:0] csr_addr_in_id,
        input [11:0] csr_addr_in_ex,
        input [6:0] opcode_in_ex,
        input wr_csr_n_in_ex
    );
        
        begin
            // Forward calculated result to the next CSRs instruction
            // if the current instruction is a CSR instruction
            forward_z_ctrl = (!wr_csr_n_in_ex) && (opcode_in_ex == csr_op) && (csr_addr_in_id == csr_addr_in_ex);
        end
    endfunction
endmodule
