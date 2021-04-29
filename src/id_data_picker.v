module id_data_picker (
    // Inputs from Regfile
    input [31:0] data1_from_regfile,
    input [31:0] data2_from_regfile,

    // Inputs from EX and MEM stage
    input [31:0] data_forwarded_from_ex,
    input [31:0] data_forwarded_from_mem,

    // Inputs from Data Forwarding Unit
    // 00: no forward, 01: forward ex, 10: forward mem
    input [1:0] forward_data1,
    input [1:0] forward_data2,
    
    // Outputs
    output [31:0] data1_id,
    output [31:0] data2_id
);

    //
    // Main
    //
    assign data1_id = prep_data_id(data1_from_regfile, data_forwarded_from_ex, data_forwarded_from_mem, forward_data1);
    assign data2_id = prep_data_id(data2_from_regfile, data_forwarded_from_ex, data_forwarded_from_mem, forward_data2);

    //
    // Functions
    //
    function [31:0] prep_data_id(input [31:0] data_reg, input [31:0] data_ex, input [31:0] data_mem, input [1:0] forward_data);
        begin
            case (forward_data)
                // no forward
                2'b00: prep_data_id = data_reg;

                // forward data_ex
                2'b01: prep_data_id = data_ex;

                // forward data_mem
                2'b10: prep_data_id = data_mem;

                // default: no forward
                default: prep_data_id = data_reg;
            endcase
        end
    endfunction
endmodule