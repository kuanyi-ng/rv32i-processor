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
    function [1:0] data_to_reg_ctrl(input [6:0] opcode);
        reg is_load, is_jal, is_jalr;

        begin
            is_load = (opcode == 7'b0000011);
            is_jal = (opcode == 7'b1101111);
            is_jalr = (opcode == 7'b1100111);

            if (is_load) data_to_reg_ctrl = 2'b01;
            else if (is_jal || is_jalr) data_to_reg_ctrl = 2'b10;
            else data_to_reg_ctrl = 2'b00;
        end
    endfunction
endmodule