module csr_forward_u (
    // Inputs from ID Stage (current cycle)
    input [11:0] csr_addr_in_id,

    // Inputs from EX Stage (current cycle)
    input [11:0] csr_addr_in_ex,
    input [6:0] opcode_in_ex,
    input wr_csr_n_in_ex,

    // Inputs from MEM Stage (current cycle)
    input [11:0] csr_addr_in_mem,
    input [6:0] opcode_in_mem,
    input wr_csr_n_in_mem,

    output [1:0] forward_z
);
    
    //
    // Main
    //

    assign forward_z = forward_z_ctrl(
        csr_addr_in_id,
        csr_addr_in_ex,
        opcode_in_ex,
        wr_csr_n_in_ex,
        csr_addr_in_mem,
        opcode_in_mem,
        wr_csr_n_in_mem
    );

    //
    // Function
    //

    localparam [6:0] csr_op = 7'b1110011;

    function [1:0] forward_z_ctrl(
        input [11:0] csr_addr_in_id,
        input [11:0] csr_addr_in_ex,
        input [6:0] opcode_in_ex,
        input wr_csr_n_in_ex,
        input [11:0] csr_addr_in_mem,
        input [6:0] opcode_in_mem,
        input wr_csr_n_in_mem
    );

        reg csr_updated_by_prev, csr_updated_by_prev_prev;
        
        begin
            csr_updated_by_prev = (!wr_csr_n_in_ex) && (opcode_in_ex == csr_op) && (csr_addr_in_id == csr_addr_in_ex);
            csr_updated_by_prev_prev = (!wr_csr_n_in_mem) && (opcode_in_mem == csr_op) && (csr_addr_in_id == csr_addr_in_mem);

            // Forward calculated result to the next CSRs instruction
            // if the current instruction is a CSR instruction

            // if csr is updated by both instructions (prev and prev_prev)
            // forward the value updated by prev instruction as it's the latest value.
            if (csr_updated_by_prev) forward_z_ctrl = 2'b01;
            else if (csr_updated_by_prev_prev) forward_z_ctrl = 2'b10;
            else forward_z_ctrl = 2'b00;
        end
    endfunction
endmodule
