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
    assign access_size = access_size_ctrl(opcode, funct3);
    assign write_to_data_mem = write_ctrl(opcode, flush);
    assign require_mem_access = mem_access_ctrl(opcode);

    //
    // Functions
    //
    function [1:0] access_size_ctrl(input [6:0] opcode, input [2:0] funct3);
        reg is_load, is_store;

        begin
            assign is_load = (opcode == 7'b0000011);
            assign is_store = (opcode == 7'b0100011);

            if (is_load) begin
                case (funct3[1:0])
                    // LB, LBU
                    2'b00: access_size_ctrl = 2'b10;

                    // LH, LHU
                    2'b01: access_size_ctrl = 2'b01;

                    // LW
                    2'b10: access_size_ctrl = 2'b00;

                    // default: neither of byte, half, word
                    default: access_size_ctrl = 2'b11;
                endcase

                
            end else if (is_store) begin
                case (funct3)
                    // SB
                    3'b000: access_size_ctrl = 2'b10;

                    // SH
                    3'b001: access_size_ctrl = 2'b01;
                    
                    // SW
                    3'b010: access_size_ctrl = 2'b00;

                    // default: neither of byte, half, word
                    default: access_size_ctrl = 2'b11;
                endcase
            end else begin
                // Other Instructions
                access_size_ctrl = 2'b11;
            end
        end
    endfunction

    function write_ctrl(input [6:0] opcode, input flush);
        reg is_store;

        begin
            assign is_store = (opcode == 7'b0100011);

            // don't write when flush
            if (flush) write_ctrl = 1'b0;
            // only Store Instructions write to mem
            else if (is_store) write_ctrl = 1'b1;
            else write_ctrl = 1'b0;
        end
    endfunction

    function mem_access_ctrl(input [6:0] opcode);
        reg is_load, is_store;

        begin
            assign is_load = (opcode == 7'b0000011);
            assign is_store = (opcode == 7'b0100011);

            if (is_load || is_store) mem_access_ctrl = 1'b1;
            else mem_access_ctrl = 1'b0;
        end
    endfunction
endmodule
