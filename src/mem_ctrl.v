`include "constants/opcode.v"
`include "constants/mem_access_size.v"

module mem_ctrl (
    input [6:0] opcode,
    input [2:0] funct3,
    input flush,

    output [1:0] access_size,       // 00: word, 01: half, 10: byte
    output write_to_data_mem,
    output require_mem_access
);

    //
    // Main
    //

    wire is_load = (opcode == `LOAD_OP);
    wire is_store = (opcode == `STORE_OP);

    // NOTE: tried to simplify by
    // assign access_size = funct3[1:0];
    // but didn't work
    assign access_size = access_size_ctrl(is_load, is_store, funct3);
    assign write_to_data_mem = write_ctrl(is_store, flush);
    assign require_mem_access = mem_access_ctrl(is_load, is_store);

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

    function write_ctrl(input is_store, input flush);
        begin
            // don't write when flush
            if (flush) write_ctrl = 1'b0;
            // only Store Instructions write to mem
            else if (is_store) write_ctrl = 1'b1;
            else write_ctrl = 1'b0;

            // current implementation has smaller area than
            // write_ctrl = is_store && !flush
            // which produce the same truth table
        end
    endfunction

    function mem_access_ctrl(input is_load, input is_store);
        begin
            if (is_load || is_store) mem_access_ctrl = 1'b1;
            else mem_access_ctrl = 1'b0;

            // current implementation has smaller area than
            // mem_access_ctrl = is_load || is_store
            // which produce the same truth table
        end
    endfunction
endmodule
