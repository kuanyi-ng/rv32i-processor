`include "constants/ir_type.v"

// Unconditional Jump Predictor
//
// Table (Memory) are
// Ansynchronous Read, Synchronous Write
module u_jump_predictor #(
    // NOTE: keep TABLE_SIZE <= 4096
    parameter TABLE_SIZE = 4096
) (
    input clk,

    // Inputs from IF Stage
    // - used for read operation
    input [31:0] pc_in_if,
    input [3:0] ir_type_in_if,

    // Inputs from EX Stage
    // - used for write operation
    input [31:0] pc_in_ex,
    input [3:0] ir_type_in_ex,
    input [31:0] jump_addr_if_taken,    // c_ex
    input is_prediction_wrong,
    input jump_result,

    // Output to IF Stage
    output u_jump,
    output [31:0] addr_prediction
);

    // Entries of table
    // Identifier of entries in table:
    // - to differentiate pc user / machine memory
    //   - pc[28]
    //   - pc in hexdecimal is either 0xxx_xxxx or 1xxx_xxxx
    //     for the amount of memory this processor has
    //   - user: 1, machine: 0
    // - to differentiate instructions
    //   - pc[12:2] (2048 entries for each mode)
    //
    // What to store?
    // init [33] | state [32] | target_addr [31:0]
    // - init: whether target_addr's value is available or not
    // - state: state of 1-bit predictor for this entry
    //   - take: 1, don't take: 0
    // - target_addr: addr to jump to when state == take
    reg [33:0] entries[0:TABLE_SIZE-1];

    //
    // Read (Ansynchronous)
    //

    wire is_u_jump_ir_in_if = is_u_jump_ir_ctrl(ir_type_in_if);
    wire [11:0] read_entry_id = entry_id_ctrl(pc_in_if);

    reg init, state, temp_u_jump;
    reg [31:0] target_addr;
    always @(*) begin
        { init, state, target_addr } = entries[read_entry_id];

        // init | state | u_jump
        // 0    | 0     | 0
        // 0    | 1     | 0 (not init yet)
        // 1    | 0     | 0
        // 1    | 1     | 1
        case ({ init, state })
            2'b00: temp_u_jump = 1'b0;
            2'b01: temp_u_jump = 1'b0;
            2'b10: temp_u_jump = 1'b0;
            2'b11: temp_u_jump = 1'b1; 

            // default added to handle cases where
            // either init / state is 1'bx
            default: temp_u_jump = 1'b0;
        endcase 
    end
    assign u_jump = (is_u_jump_ir_in_if) ? temp_u_jump : 1'b0;
    assign addr_prediction = target_addr;

    //
    // Write (Synchronous)
    //

    wire is_u_jump_ir_in_ex = is_u_jump_ir_ctrl(ir_type_in_ex);
    wire [11:0] write_entry_id = entry_id_ctrl(pc_in_ex);
    wire update_entry = is_u_jump_ir_in_ex && is_prediction_wrong;

    always @(negedge clk) begin
        if (update_entry) begin
            // update init to 1
            // update state to jump_result (1-bit predictor)
            // update target_addr to jump_addr_if_taken
            entries[write_entry_id] <= { 1'b1, jump_result, jump_addr_if_taken };
        end else begin
            entries[write_entry_id] <= entries[write_entry_id];
        end
    end

    //
    // Function
    //

    function is_u_jump_ir_ctrl(input [3:0] ir_type);
        begin
            is_u_jump_ir_ctrl = (ir_type == `JAL_IR) || (ir_type == `JALR_IR) || (ir_type == `BRANCH_IR);
        end
    endfunction

    function [11:0] entry_id_ctrl(input [31:0] pc);
        begin
            entry_id_ctrl = { pc[28], pc[12:2] };
        end
    endfunction

endmodule
