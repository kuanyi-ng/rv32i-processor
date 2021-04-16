module mem_ctrl (
    input [6:0] opcode,
    input [2:0] funct3,
    input data_mem_access_ready_n,  // 0: ready to access data memory, 1: not ready
    output [1:0] access_size,       // 00: word, 01: half, 10: byte
    output write_to_data_mem,
    output require_mem_access
);

    //
    // Main
    //
    assign access_size = access_size_ctrl(opcode, funct3);
    assign write_to_data_mem = write_ctrl(opcode);
    assign require_mem_access = !data_mem_access_ready_n;

    //
    // Functions
    //
    function [1:0] access_size_ctrl(input [6:0] opcode, input [2:0] funct3);
        begin
            if (opcode == 7'b1100011) begin
                // Branch Instructions
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

                
            end else if (opcode == 7'b0100011) begin
                // Store Instructions
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

    function write_ctrl(input [6:0] opcode);
        begin
            // only Store Instructions write to mem
            write_ctrl = (opcode == 7'b0100011);
        end
    endfunction
    
endmodule
