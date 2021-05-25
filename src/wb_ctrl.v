module wb_ctrl (
    input [6:0] opcode,
    output [1:0] data_to_reg_sel
);
    
    //
    // Main
    //
    assign data_to_reg_sel = data_to_reg_ctrl(opcode);

    //
    // Functions
    //

    localparam [6:0] jal_op = 7'b1101111;
    localparam [6:0] jalr_op = 7'b1100111;
    localparam [6:0] load_op = 7'b0000011;
    localparam [6:0] csr_op = 7'b1110011;

    function [1:0] data_to_reg_ctrl(input [6:0] opcode);
        reg is_load, is_jal, is_jalr, is_csr;

        begin
            is_load = (opcode == load_op);
            is_jal = (opcode == jal_op);
            is_jalr = (opcode == jalr_op);
            is_csr = (opcode == csr_op);

            if (is_load) data_to_reg_ctrl = 2'b01;
            else if (is_jal || is_jalr) data_to_reg_ctrl = 2'b10;
            else if (is_csr) data_to_reg_ctrl = 2'b11;
            else data_to_reg_ctrl = 2'b00;
        end
    endfunction
endmodule