module id_z_picker (
    // Inputs from CSR Registers
    input [31:0] z_from_csr,

    // Inputs from EX and MEM stage
    input [31:0] z_from_ex,
    input [31:0] z_from_mem,

    // Inputs from CSR Forwarding Unit
    // 00: no forward, 01: forward ex, 10: forward mem
    input [1:0] forward_z,
    
    // Outputs
    output [31:0] z_id
);

    //
    // Main
    //
    assign z_id = prep_z_id(
        z_from_csr,
        z_from_ex,
        z_from_mem,
        forward_z
    );

    //
    // Functions
    //
    function [31:0] prep_z_id(
        input [31:0] data_csr,
        input [31:0] data_ex,
        input [31:0] data_mem,
        input [1:0] forward_data
    );
        begin
            case (forward_data)
                // no forward
                2'b00: prep_z_id = data_csr;

                // forward data_ex
                2'b01: prep_z_id = data_ex;

                // forward data_mem
                2'b10: prep_z_id = data_mem;

                // default: no forward
                default: prep_z_id = data_csr;
            endcase
        end
    endfunction
endmodule