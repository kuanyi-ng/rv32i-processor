module wb_ctrl (
    input [6:0] opcode,
    output write_to_reg,
    output [1:0] data_to_reg_sel
);
    
    //
    // Main
    //
    assign write_to_reg = write_to_reg_ctrl(opcode);
    assign data_to_reg_sel = data_to_reg_ctrl(opcode);

    //
    // Functions
    //
    function write_to_reg_ctrl(input [6:0] opcode);
        // whitelist instead of blacklist to be more secure.
        reg is_lui, is_auipc, is_i_type, is_r_type, is_load, is_jal, is_jalr;

        begin
            is_lui = (opcode == 7'b0110111);
            is_auipc = (opcode == 7'b0010111);
            is_i_type = (opcode == 7'b0010011);
            is_r_type = (opcode == 7'b0110011);
            is_load = (opcode == 7'b0000011);
            is_jal = (opcode == 7'b1101111);
            is_jalr = (opcode == 7'b1100111);

            if (is_lui || is_auipc || is_i_type || is_r_type || is_load || is_jal || is_jalr) begin
                write_to_reg_ctrl = 1'b1;
            end else begin
                write_to_reg_ctrl = 1'b0;
            end
        end
    endfunction

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