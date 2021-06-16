`include "constants/ir_type.v"
`include "constants/mem_access_size.v"

module mem_ctrl (
    input [3:0] ir_type,
    input [2:0] funct3,
    input flush,

    output [1:0] access_size,       // 00: word, 01: half, 10: byte
    output write_to_data_mem,
    output require_mem_access
);

    //
    // Main
    //

    wire is_load = (ir_type == `LOAD_IR);
    wire is_store = (ir_type == `STORE_IR);

    assign access_size = access_size_ctrl(is_load, is_store, funct3);
    assign write_to_data_mem = !flush && is_store;
    assign require_mem_access = (is_load || is_store);

    //
    // Functions
    //

    function [1:0] access_size_ctrl(input is_load, input is_store, input [2:0] funct3);
        begin
            if (is_load || is_store) begin
                case (funct3[1:0])
                    // LB, LBU | SB
                    2'b00: access_size_ctrl = `BYTE;

                    // LH, LHU | SH
                    2'b01: access_size_ctrl = `HALF;

                    // LW | SW
                    2'b10: access_size_ctrl = `WORD;

                    // default: neither of byte, half, word
                    default: access_size_ctrl = `INPROPER_SIZE;
                endcase
            end else begin
                // Other Instructions
                access_size_ctrl = `INPROPER_SIZE;
            end
        end
    endfunction

endmodule
